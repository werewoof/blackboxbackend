package guilds

import (
	"context"
	"encoding/json"
	"fmt"
	"io"
	"mime/multipart"
	"net/http"
	"os"
	"path/filepath"
	"strings"
	"time"

	"github.com/asianchinaboi/backendserver/internal/api/middleware"
	"github.com/asianchinaboi/backendserver/internal/config"
	"github.com/asianchinaboi/backendserver/internal/db"
	"github.com/asianchinaboi/backendserver/internal/errors"
	"github.com/asianchinaboi/backendserver/internal/events"
	"github.com/asianchinaboi/backendserver/internal/files"
	"github.com/asianchinaboi/backendserver/internal/logger"
	"github.com/asianchinaboi/backendserver/internal/session"
	"github.com/asianchinaboi/backendserver/internal/uid"
	"github.com/asianchinaboi/backendserver/internal/wsclient"
	"github.com/gin-gonic/gin"
)

/*
alter table userguilds add column owner bool not null default false;
update userguilds  set owner = true from guilds where guild_id = guilds.id and user_id =  guilds.owner_id;
alter table guilds drop column owner_id;
*/

//accepts name, icon, savechat

func createGuild(c *gin.Context) {
	user := c.MustGet(middleware.User).(*session.Session)
	if user == nil {
		logger.Error.Println("user token not sent in data")
		c.JSON(http.StatusInternalServerError,
			errors.Body{
				Error:  errors.ErrSessionDidntPass.Error(),
				Status: errors.StatusInternalError,
			})
		return
	}

	var guild events.Guild
	var imageHeader *multipart.FileHeader

	contentType := c.GetHeader("Content-Type")
	if strings.HasPrefix(contentType, "multipart/form-data") {
		var err error
		if imageHeader, err = c.FormFile("image"); err != nil && err != http.ErrMissingFile {
			logger.Error.Println(err)
			c.JSON(http.StatusBadRequest, errors.Body{
				Error:  err.Error(),
				Status: errors.StatusBadRequest,
			})
			return
		}
		jsonData := c.PostForm("body")
		if err := json.Unmarshal([]byte(jsonData), &guild); err != nil {
			logger.Error.Println(err)
			c.JSON(http.StatusBadRequest, errors.Body{
				Error:  err.Error(),
				Status: errors.StatusBadRequest,
			})
			return
		}
	} else if strings.HasPrefix(contentType, "application/json") {
		if err := c.ShouldBindJSON(&guild); err != nil {
			logger.Error.Println(err)
			c.JSON(http.StatusBadRequest, errors.Body{
				Error:  err.Error(),
				Status: errors.StatusBadRequest,
			})
			return
		}
	} else {
		logger.Error.Println(errors.ErrNotSupportedContentType)
		c.JSON(http.StatusBadRequest, errors.Body{
			Error:  errors.ErrNotSupportedContentType.Error(),
			Status: errors.StatusBadRequest,
		})
		return
	}

	if statusCode, err := events.ValidateGuildInput(&guild); err != nil {
		if statusCode != errors.StatusInternalError {
			c.JSON(http.StatusUnprocessableEntity, errors.Body{
				Error:  err.Error(),
				Status: statusCode,
			})
			return
		} else {
			c.JSON(http.StatusInternalServerError, errors.Body{
				Error:  err.Error(),
				Status: errors.StatusInternalError,
			})
			return
		}
	}

	//BEGIN TRANSACTION
	ctx := context.Background()
	tx, err := db.Db.BeginTx(ctx, nil)
	if err != nil {
		logger.Error.Println(err)
		c.JSON(http.StatusInternalServerError, errors.Body{
			Error:  err.Error(),
			Status: errors.StatusInternalError,
		})
		return
	}
	defer tx.Rollback() //rollback changes if failed

	successful := false

	guildId := uid.Snowflake.Generate().Int64()

	if _, err := tx.ExecContext(ctx, "INSERT INTO guilds (id, name, save_chat) VALUES ($1, $2, $3)", guildId, guild.Name, guild.SaveChat); err != nil {
		logger.Error.Println(err)
		c.JSON(http.StatusInternalServerError, errors.Body{
			Error:  err.Error(),
			Status: errors.StatusInternalError,
		})
		return
	}

	if imageHeader != nil {
		imageId := uid.Snowflake.Generate().Int64()
		filename := imageHeader.Filename
		fileType := filepath.Ext(filename)
		imageCreated := time.Now().Unix()
		image, err := imageHeader.Open()
		if err != nil {
			logger.Error.Println(err)
			c.JSON(http.StatusBadRequest, errors.Body{
				Error:  err.Error(),
				Status: errors.StatusBadRequest,
			})
			return
		}
		defer image.Close()

		fileBytes, err := io.ReadAll(image)
		if err != nil {
			logger.Error.Println(err)
			c.JSON(http.StatusInternalServerError, errors.Body{
				Error:  err.Error(),
				Status: errors.StatusInternalError,
			})
			return
		}

		fileMIMEType := http.DetectContentType(fileBytes)

		if valid := files.ValidateImage(fileBytes, fileType); !valid {
			logger.Error.Println(errors.ErrFileInvalid)
			c.JSON(http.StatusBadRequest, errors.Body{
				Error:  errors.ErrFileInvalid.Error(),
				Status: errors.StatusFileInvalid,
			})
			return
		}

		filesize := len(fileBytes)

		if filesize > config.Config.Server.MaxFileSize {
			logger.Error.Println(errors.ErrFileTooLarge)
			c.JSON(http.StatusRequestEntityTooLarge, errors.Body{
				Error:  errors.ErrFileTooLarge.Error(),
				Status: errors.StatusFileTooLarge,
			})
			return
		} else if !(filesize >= 0) {
			logger.Error.Println(errors.ErrFileNoBytes)
			c.JSON(http.StatusBadRequest, errors.Body{
				Error:  errors.ErrFileNoBytes.Error(),
				Status: errors.StatusFileNoBytes,
			})
			return
		}

		compressedBuffer, err := files.Compress(fileBytes, filesize)
		if err != nil {
			logger.Error.Println(err)
			c.JSON(http.StatusInternalServerError, errors.Body{
				Error:  err.Error(),
				Status: errors.StatusInternalError,
			})
			return
		}

		outFile, err := os.Create(fmt.Sprintf("uploads/guild/%d.lz4", imageId))
		//TODO: delete files if failed or write them after when its deemed successful
		if err != nil {
			logger.Error.Println(err)
			c.JSON(http.StatusInternalServerError, errors.Body{
				Error:  err.Error(),
				Status: errors.StatusInternalError,
			})
			return
		}
		defer func() { //defer just in case something went wrong
			if !successful {
				if err := os.Remove(fmt.Sprintf("uploads/guild/%d.lz4", imageId)); err != nil {
					logger.Warn.Printf("failed to remove file: %v\n", err)
				}
			}
		}()
		defer outFile.Close()

		if _, err = outFile.Write(compressedBuffer); err != nil {
			logger.Error.Println(err)
			c.JSON(http.StatusInternalServerError, errors.Body{
				Error:  err.Error(),
				Status: errors.StatusInternalError,
			})
			return
		}

		if _, err = tx.ExecContext(ctx, "INSERT INTO files (id, guild_id, filename, created, temp, filesize, filetype, entity_type) VALUES ($1, $2, $3, $4, $5, $6, $7, 'guild')", imageId, guildId, filename, imageCreated, false, filesize, fileMIMEType); err != nil {
			logger.Error.Println(err)
			c.JSON(http.StatusInternalServerError, errors.Body{
				Error:  err.Error(),
				Status: errors.StatusInternalError,
			})
			return
		}
		guild.ImageId = imageId
	} else {
		logger.Debug.Println("no image provided")
		guild.ImageId = -1
	}

	invite := events.Invite{
		Invite:  session.GenerateRandString(10),
		GuildId: guildId,
	}

	if _, err := tx.ExecContext(ctx, "INSERT INTO unreadmsgs (guild_id, user_id) VALUES ($1, $2)", guildId, user.Id); err != nil { //cleanup if failed later
		logger.Error.Println(err)
		c.JSON(http.StatusInternalServerError, errors.Body{
			Error:  err.Error(),
			Status: errors.StatusInternalError,
		})
		return
	}
	if _, err := tx.ExecContext(ctx, "INSERT INTO userguilds (guild_id, user_id, owner) VALUES ($1, $2, true)", guildId, user.Id); err != nil {
		logger.Error.Println(err)
		c.JSON(http.StatusInternalServerError, errors.Body{
			Error:  err.Error(),
			Status: errors.StatusInternalError,
		})
		return
	}
	if _, err := tx.ExecContext(ctx, "INSERT INTO invites (invite, guild_id) VALUES ($1, $2)", invite.Invite, guildId); err != nil {
		logger.Error.Println(err)
		c.JSON(http.StatusInternalServerError, errors.Body{
			Error:  err.Error(),
			Status: errors.StatusInternalError,
		})
		return
	}

	if err := tx.Commit(); err != nil { //commits the transaction
		logger.Error.Println(err)
		c.JSON(http.StatusInternalServerError, errors.Body{
			Error:  err.Error(),
			Status: errors.StatusInternalError,
		})
		return
	}

	successful = true

	res := wsclient.DataFrame{
		Op: wsclient.TYPE_DISPATCH,
		Data: events.Guild{
			GuildId: guildId,
			OwnerId: user.Id,
			Name:    guild.Name,
			ImageId: guild.ImageId,
		},
		Event: events.CREATE_GUILD,
	}
	invRes := wsclient.DataFrame{
		Op:    wsclient.TYPE_DISPATCH,
		Data:  invite,
		Event: events.CREATE_INVITE,
	}
	wsclient.Pools.BroadcastClient(user.Id, res)
	//shit i forgot to create a pool
	wsclient.Pools.AddUserToGuildPool(guildId, user.Id)
	wsclient.Pools.BroadcastGuild(guildId, invRes)
	//possible race condition but shouldnt be possible since sql does it by queue
	c.Status(http.StatusNoContent) //writing this code at nearly 12 am gotta keep the grind up
	//dec 9 2022 writing code at nearly 12 am is not good im fixing it rn and holy crap some of the stuff looks shit
}
