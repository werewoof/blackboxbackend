package guilds

import (
	"context"
	"net/http"
	"regexp"
	"strconv"

	"github.com/asianchinaboi/backendserver/internal/api/middleware"
	"github.com/asianchinaboi/backendserver/internal/db"
	"github.com/asianchinaboi/backendserver/internal/errors"
	"github.com/asianchinaboi/backendserver/internal/events"
	"github.com/asianchinaboi/backendserver/internal/logger"
	"github.com/asianchinaboi/backendserver/internal/session"
	"github.com/asianchinaboi/backendserver/internal/wsclient"
	"github.com/gin-gonic/gin"
)

type editGuildBody struct {
	SaveChat *bool   `json:"saveChat"`
	Name     *string `json:"name"`
	Icon     *int    `json:"icon"`
	OwnerId  *int64  `json:"ownerId"`
}

func editGuild(c *gin.Context) {
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

	guildId := c.Param("guildId")
	if match, err := regexp.MatchString("^[0-9]+$", guildId); err != nil {
		logger.Error.Println(err)
		c.JSON(http.StatusInternalServerError, errors.Body{
			Error:  err.Error(),
			Status: errors.StatusInternalError,
		})
		return
	} else if !match {
		logger.Error.Println(errors.ErrRouteParamInvalid)
		c.JSON(http.StatusBadRequest, errors.Body{
			Error:  errors.ErrRouteParamInvalid.Error(),
			Status: errors.StatusRouteParamInvalid,
		})
		return
	}

	var newSettings editGuildBody
	if err := c.ShouldBindJSON(&newSettings); err != nil {
		logger.Error.Println(err)
		c.JSON(http.StatusBadRequest, errors.Body{
			Error:  err.Error(),
			Status: errors.StatusBadRequest,
		})
		return
	}

	if newSettings.SaveChat == nil && newSettings.Icon == nil && newSettings.Name == nil {
		logger.Error.Println(errors.ErrAllFieldsEmpty)
		c.JSON(http.StatusBadRequest, errors.Body{
			Error:  errors.ErrAllFieldsEmpty.Error(),
			Status: errors.StatusAllFieldsEmpty,
		})
		return
	}

	var exists bool
	var isOwner bool
	var isAdmin bool
	if err := db.Db.QueryRow("SELECT EXISTS(SELECT 1 FROM guilds WHERE id = $1), EXISTS(SELECT 1 FROM userguilds WHERE user_id=$2 and guild_id=$1 and owner = true), EXISTS (SELECT 1 FROM userguilds WHERE user_id=$2 AND guild=$1 AND admin = true)", guildId, user.Id).Scan(&exists, &isOwner, &isAdmin); err != nil {
		logger.Error.Println(err)
		c.JSON(http.StatusInternalServerError, errors.Body{
			Error:  err.Error(),
			Status: errors.StatusInternalError,
		})
		return
	}
	if !exists {
		c.JSON(http.StatusNotFound, errors.Body{
			Error:  errors.ErrGuildNotExist.Error(),
			Status: errors.StatusGuildNotExist,
		})
		return
	}
	if !isOwner && !isAdmin {
		c.JSON(http.StatusForbidden, errors.Body{
			Error:  errors.ErrNotGuildAuthorised.Error(),
			Status: errors.StatusNotGuildAuthorised,
		})
		return
	}

	bodyRes := events.Guild{}
	intGuildId, err := strconv.ParseInt(guildId, 10, 64)
	if err != nil {
		logger.Error.Println(err)
		c.JSON(http.StatusInternalServerError, errors.Body{
			Error:  err.Error(),
			Status: errors.StatusInternalError,
		})
		return
	}
	bodyRes.GuildId = intGuildId

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
	defer func() {
		if err := tx.Rollback(); err != nil {
			logger.Warn.Printf("unable to rollback error: %v\n", err)
		}
	}() //rollback changes if failed

	if newSettings.SaveChat != nil {

		if _, err = tx.ExecContext(ctx, "UPDATE guilds SET save_chat=$1 WHERE id=$2", *newSettings.SaveChat, guildId); err != nil {
			logger.Error.Println(err)
			c.JSON(http.StatusInternalServerError, errors.Body{
				Error:  err.Error(),
				Status: errors.StatusInternalError,
			})
			return
		}
		bodyRes.SaveChat = newSettings.SaveChat
	} else {
		var saveChat bool
		if err := db.Db.QueryRow("SELECT save_chat FROM guilds WHERE id=$1", guildId).Scan(&saveChat); err != nil {
			logger.Error.Println(err)
			c.JSON(http.StatusInternalServerError, errors.Body{
				Error:  err.Error(),
				Status: errors.StatusInternalError,
			})
			return
		}
		bodyRes.SaveChat = &saveChat
	}
	if newSettings.Name != nil {
		if valid, err := events.ValidateGuildName(*newSettings.Name); err != nil {
			c.JSON(http.StatusInternalServerError, errors.Body{
				Error:  err.Error(),
				Status: errors.StatusInternalError,
			})
		} else if !valid {
			c.JSON(http.StatusUnprocessableEntity, errors.Body{
				Error:  errors.ErrInvalidGuildName.Error(),
				Status: errors.StatusInvalidGuildName,
			})
			return
		}

		if _, err = tx.ExecContext(ctx, "UPDATE guilds SET name=$1 WHERE id=$2", *newSettings.Name, guildId); err != nil {
			logger.Error.Println(err)
			c.JSON(http.StatusInternalServerError, errors.Body{
				Error:  err.Error(),
				Status: errors.StatusInternalError,
			})
			return
		}
		bodyRes.Name = *newSettings.Name
	} else {
		var name string
		if err := db.Db.QueryRow("SELECT name FROM guilds WHERE id=$1", guildId).Scan(&name); err != nil {
			logger.Error.Println(err)
			c.JSON(http.StatusInternalServerError, errors.Body{
				Error:  err.Error(),
				Status: errors.StatusInternalError,
			})
			return
		}
		bodyRes.Name = name
	}
	if newSettings.Icon != nil {
		if _, err = tx.ExecContext(ctx, "UPDATE guilds SET icon=$1 WHERE id=$2", *newSettings.Icon, guildId); err != nil {
			logger.Error.Println(err)
			c.JSON(http.StatusInternalServerError, errors.Body{
				Error:  err.Error(),
				Status: errors.StatusInternalError,
			})
			return
		}
		bodyRes.Icon = *newSettings.Icon
	} else {
		var icon int
		if err := db.Db.QueryRow("SELECT icon FROM guilds WHERE id=$1", guildId).Scan(&icon); err != nil {
			logger.Error.Println(err)
			c.JSON(http.StatusInternalServerError, errors.Body{
				Error:  err.Error(),
				Status: errors.StatusInternalError,
			})
			return
		}
		bodyRes.Icon = icon
	}

	if newSettings.OwnerId != nil {
		var inGuild bool
		if err := db.Db.QueryRow("SELECT EXISTS (SELECT 1 FROM userguilds WHERE guild_id=$1 AND user_id=$2)", guildId, newSettings.OwnerId).Scan(&isOwner, &inGuild); err != nil {
			logger.Error.Println(err)
			c.JSON(http.StatusInternalServerError, errors.Body{
				Error:  err.Error(),
				Status: errors.StatusInternalError,
			})
			return
		}
		if isOwner {
			logger.Error.Println(errors.ErrAlreadyOwner)
			c.JSON(http.StatusForbidden, errors.Body{
				Error:  errors.ErrAlreadyOwner.Error(),
				Status: errors.StatusAlreadyOwner,
			})
			return
		}
		if !inGuild {
			logger.Error.Println(errors.ErrNotInGuild)
			c.JSON(http.StatusForbidden, errors.Body{
				Error:  errors.ErrNotInGuild.Error(),
				Status: errors.StatusNotInGuild,
			})
			return
		}
		if _, err = tx.ExecContext(ctx, "UPDATE userguilds SET owner=false WHERE guild_id=$1 AND user_id = $2", guildId, user.Id); err != nil {
			logger.Error.Println(err)
			c.JSON(http.StatusInternalServerError, errors.Body{
				Error:  err.Error(),
				Status: errors.StatusInternalError,
			})
			return
		}
		if _, err := tx.ExecContext(ctx, "UPDATE userguilds SET owner = true WHERE user_id = $1 AND guild_id = $2", newSettings.OwnerId, guildId); err != nil {
			logger.Error.Println(err)
			c.JSON(http.StatusInternalServerError, errors.Body{
				Error:  err.Error(),
				Status: errors.StatusInternalError,
			})
			return
		}
		bodyRes.OwnerId = *newSettings.OwnerId
	} else {
		bodyRes.OwnerId = user.Id
	}

	if err := tx.Commit(); err != nil { //commits the transaction
		logger.Error.Println(err)
		c.JSON(http.StatusInternalServerError, errors.Body{
			Error:  err.Error(),
			Status: errors.StatusInternalError,
		})
		return
	}

	guildRes := wsclient.DataFrame{
		Op:    wsclient.TYPE_DISPATCH,
		Data:  bodyRes,
		Event: events.UPDATE_GUILD,
	}
	wsclient.Pools.BroadcastGuild(intGuildId, guildRes)

	c.Status(http.StatusNoContent)
}
