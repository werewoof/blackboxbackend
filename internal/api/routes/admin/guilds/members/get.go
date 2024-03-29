package members

import (
	"database/sql"
	"net/http"
	"regexp"
	"strconv"

	"github.com/asianchinaboi/backendserver/internal/api/middleware"
	"github.com/asianchinaboi/backendserver/internal/db"
	"github.com/asianchinaboi/backendserver/internal/errors"
	"github.com/asianchinaboi/backendserver/internal/events"
	"github.com/asianchinaboi/backendserver/internal/session"
	"github.com/gin-gonic/gin"
)

func Get(c *gin.Context) {
	user := c.MustGet(middleware.User).(*session.Session)
	if user == nil {
		errors.SendErrorResponse(c, errors.ErrSessionDidntPass, errors.StatusInternalError)
		return
	}
	if !user.Perms.Admin && !user.Perms.Guilds.Get {
		errors.SendErrorResponse(c, errors.ErrNotAuthorised, errors.StatusNotAuthorised)
		return
	}

	guildId := c.Param("guildId")
	if match, err := regexp.MatchString("^[0-9]+$", guildId); err != nil {
		errors.SendErrorResponse(c, err, errors.StatusInternalError)
		return
	} else if !match {
		errors.SendErrorResponse(c, errors.ErrRouteParamInvalid, errors.StatusRouteParamInvalid)
		return
	}

	rows, err := db.Db.Query("SELECT users.username, files.id, users.id, admin, owner FROM userguilds INNER JOIN users ON userguilds.user_id=users.id LEFT JOIN files ON files.user_id=users.id WHERE userguilds.guild_id=$1 AND banned = false", guildId)
	if err != nil {
		errors.SendErrorResponse(c, err, errors.StatusInternalError)
		return
	}
	userlist := []events.Member{}
	intGuildId, err := strconv.ParseInt(guildId, 10, 64)
	if err != nil {
		errors.SendErrorResponse(c, err, errors.StatusInternalError)
		return
	}
	defer rows.Close()
	for rows.Next() {
		var user events.Member
		var imageId sql.NullInt64
		if err := rows.Scan(&user.UserInfo.Name, &imageId, &user.UserInfo.UserId, &user.Admin, &user.Owner); err != nil {
			errors.SendErrorResponse(c, err, errors.StatusInternalError)
			return
		}
		if imageId.Valid {
			user.UserInfo.ImageId = imageId.Int64
		} else {
			user.UserInfo.ImageId = -1
		}
		user.GuildId = intGuildId

		userlist = append(userlist, user)
	}
	c.JSON(http.StatusOK, userlist)
}
