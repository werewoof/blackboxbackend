package main

import (
	"database/sql"
	"encoding/json"
	"io/ioutil"
	"net/http"
	"strconv"
)

/*
Guilds table
id PRIMARY KEY SERIAL | name VARCHAR(16) | icon INT | owner_id INT | invites_amount SMALLINT DEFAULT 1 | public BOOLEAN DEFAULT FALSE | keephistory BOOLEAN DEFAULT FALSE
*/
/*
Invites table
invite VARCHAR(10) | guild_id INT | ExpireDate (IMPLEMENT THIS LATER ON) INT64
*/
type createGuildData struct {
	Icon int    `json:"Icon"` // if icon none its zero assume no icon
	Name string `json:"Name"`
}

type sendInvite struct {
	Invite string `json:"Invite"`
	Guild  int    `json:"Guild"`
}

//small but keep it like that for now
type changeGuild struct {
	Guild       int    `json:"Guild"`
	Public      bool   `json:"Public"`
	KeepHistory bool   `json:"KeepHistory"`
	Name        string `json:"Name"`
	Icon        int    `json:"Icon"`
}

type movedGuild struct {
	DataType int `json:"DataType"`
	Guild    int `json:"Guild"`
}

type userGuild struct {
	Username string
	Id       int
	Icon     int
}

type infoGuild struct {
	Id   int    `json:"Id"`
	Name string `json:"Name"`
	Icon int    `json:"Icon"`
}

func createGuild(w http.ResponseWriter, r *http.Request, user *session) {

	bodyBytes, err := ioutil.ReadAll(r.Body)
	if err != nil {
		reportError(http.StatusBadRequest, w, err)
		return
	}
	var guild createGuildData
	if err := json.Unmarshal(bodyBytes, &guild); err != nil {
		reportError(http.StatusBadRequest, w, err)
		return
	}
	var guild_id int
	row := db.QueryRow("INSERT INTO guilds (name, icon, owner_id) VALUES ($1, $2, $3) RETURNING id", guild.Name, guild.Icon, user.Id)
	row.Scan(&guild_id)
	invite := sendInvite{
		Invite: generateRandString(10),
		Guild:  guild_id,
	}
	if _, err = db.Exec("INSERT INTO userguilds (guild_id, user_id) VALUES ($1, $2)", guild_id, user.Id); err != nil { //cleanup if failed later
		reportError(http.StatusBadRequest, w, err)
		return
	}
	if _, err = db.Exec("INSERT INTO invites (invite, guild_id) VALUES ($1, $2)", invite.Invite, invite.Guild); err != nil {
		reportError(http.StatusBadRequest, w, err)
		return
	}
	bodyBytes, err = json.Marshal(invite)
	if err != nil {
		reportError(http.StatusBadRequest, w, err)
		return
	}
	w.WriteHeader(http.StatusOK)
	w.Write(bodyBytes)
}

func deleteGuild(w http.ResponseWriter, r *http.Request, user *session) {
	params := r.URL.Query()
	guild, err := strconv.Atoi(params.Get("guild"))
	if err != nil {
		reportError(http.StatusBadRequest, w, err)
		return
	}
	var valid bool
	row := db.QueryRow("SELECT EXISTS (SELECT id FROM guilds WHERE id=$1 AND owner_id=$2)", guild, user.Id)
	if row.Err() != nil {
		reportError(http.StatusInternalServerError, w, row.Err())
		return
	}
	row.Scan(&valid)
	if !valid { //user is a fraud
		reportError(http.StatusBadRequest, w, errorNotGuildOwner)
		return
	}
	_, err = db.Exec("DELETE FROM messages WHERE guild_id=$1", guild) //start deleting
	if err != nil {
		reportError(http.StatusInternalServerError, w, err)
		return
	}
	_, err = db.Exec("DELETE FROM invites WHERE guild_id=$1", guild) //delete all existing invites
	if err != nil {
		reportError(http.StatusInternalServerError, w, err)
		return
	}
	_, err = db.Exec("DELETE FROM userguilds WHERE guild_id=$1", guild) //delete from users guilds
	if err != nil {
		reportError(http.StatusInternalServerError, w, err)
		return
	}
	_, err = db.Exec("DELETE FROM guilds WHERE id=$1", guild)
	if err != nil {
		reportError(http.StatusInternalServerError, w, err)
		return
	}

	w.WriteHeader(http.StatusOK)
}

func getGuild(w http.ResponseWriter, r *http.Request, user *session) {
	rows, err := db.Query(
		`
		SELECT g.id, g.name, g.icon 
		FROM userguilds u 
		INNER JOIN guilds g ON g.id = u.guild_id WHERE u.user_id=$1`,
		user.Id,
	)
	if err != nil {
		reportError(http.StatusInternalServerError, w, err)
		return
	}
	var guilds []infoGuild
	for rows.Next() {
		var guild infoGuild
		err = rows.Scan(&guild.Id, &guild.Name, &guild.Icon)
		if err != nil {
			reportError(http.StatusInternalServerError, w, err)
			return
		}
		guilds = append(guilds, guild)
	}
	bodyBytes, err := json.Marshal(guilds)
	if err != nil {
		reportError(http.StatusInternalServerError, w, err)
		return
	}
	w.WriteHeader(http.StatusOK)
	w.Write(bodyBytes)
}

func getGuildUsers(w http.ResponseWriter, r *http.Request, user *session) {
	params := r.URL.Query()
	guild, err := strconv.Atoi(params.Get("guild"))
	if err != nil {
		reportError(http.StatusBadRequest, w, err)
		return
	}

	var valid bool
	row := db.QueryRow("SELECT EXISTS (SELECT * FROM userguilds WHERE guild_id=$1 AND user_id=$2 AND banned=false)", guild, user.Id)
	if row.Err() != nil {
		reportError(http.StatusInternalServerError, w, row.Err())
		return
	}
	row.Scan(&valid)
	if !valid {
		reportError(http.StatusInternalServerError, w, errorNotInGuild)
		return
	}
	rows, err := db.Query("SELECT users.username, users.id FROM userguilds INNER JOIN users ON userguilds.user_id=users.id WHERE guild_id=$1", guild)
	if err != nil {
		reportError(http.StatusInternalServerError, w, err)
		return
	}
	userlist := []userGuild{}
	for rows.Next() {
		var user userGuild
		err = rows.Scan(&user.Username, &user.Id)
		user.Icon = 0 //placeholder until upload is implemented
		if err != nil {
			reportError(http.StatusInternalServerError, w, err)
			return
		}
		userlist = append(userlist, user)
	}
	bodyBytes, err := json.Marshal(userlist)
	if err != nil {
		reportError(http.StatusInternalServerError, w, err)
		return
	}
	w.WriteHeader(http.StatusOK)
	w.Write(bodyBytes)
}

func editGuild(w http.ResponseWriter, r *http.Request, user *session) {
	var newSettings changeGuild
	bodyBytes, err := ioutil.ReadAll(r.Body)
	if err != nil {
		reportError(http.StatusBadRequest, w, err)
		return
	}
	err = json.Unmarshal(bodyBytes, &newSettings) //a error really shouldnt occur here i am only
	//going to remove this after i know this works
	if err != nil {
		reportError(http.StatusInternalServerError, w, err)
		return
	}
	_, err = db.Exec(
		"UPDATE guilds SET public=$1, KeepHistory=$2, name=$3, icon=$4 WHERE id=$5 AND owner_id=$6",
		newSettings.Public,
		newSettings.KeepHistory,
		newSettings.Name,
		newSettings.Icon,
		newSettings.Guild,
		user.Id,
	)
	if err != nil {
		reportError(http.StatusBadRequest, w, err)
		return
	}
	broadcastGuild(newSettings.Guild, newSettings)
	w.WriteHeader(http.StatusOK)
}

func genGuildInvite(w http.ResponseWriter, r *http.Request, user *session) {
	params := r.URL.Query()
	guild, err := strconv.Atoi(params.Get("guild"))
	if err != nil {
		reportError(http.StatusBadRequest, w, err)
		return
	}
	invite := sendInvite{
		Invite: generateRandString(10),
		Guild:  guild,
	}
	if _, err := db.Exec("INSERT INTO invites (invite, guild_id) VALUES ($1, $2)", invite.Invite, invite.Guild); err != nil {
		reportError(http.StatusBadRequest, w, err)
		return
	}
	bodyBytes, err := json.Marshal(invite)
	if err != nil {
		reportError(http.StatusInternalServerError, w, err)
		return
	}
	w.WriteHeader(http.StatusOK)
	w.Write(bodyBytes)
}

func deleteInvGuild(w http.ResponseWriter, r *http.Request, user *session) {
	params := r.URL.Query()
	invite := params.Get("invite")
	guild, err := strconv.Atoi(params.Get("guild"))
	if err != nil || invite == "" {
		reportError(http.StatusBadRequest, w, err)
		return
	}
	var valid bool
	row := db.QueryRow("SELECT EXISTS (SELECT * FROM guilds WHERE id=$1 AND owner_id=$2)", guild, user.Id)
	if row.Err() != nil {
		reportError(http.StatusInternalServerError, w, row.Err())
		return
	}
	row.Scan(&valid)
	if !valid {
		reportError(http.StatusBadRequest, w, errorNotGuildOwner)
		return
	}
	_, err = db.Exec("DELETE FROM guilds WHERE guild_id=$1 AND invite=$2", guild, invite)
	if err != nil {
		reportError(http.StatusInternalServerError, w, err)
		return
	}
	w.WriteHeader(http.StatusOK)
}

func joinGuild(w http.ResponseWriter, r *http.Request, user *session) {
	params := r.URL.Query()
	invite := params.Get("invite")
	if invite == "" {
		reportError(http.StatusBadRequest, w, errorNoInvite)
		return
	}
	row := db.QueryRow("SELECT guild_id FROM invites WHERE invite=$1", invite)
	if err := row.Err(); err == sql.ErrNoRows {
		reportError(http.StatusBadRequest, w, errorInvalidInvite)
		return
	} else if err != nil {
		reportError(http.StatusInternalServerError, w, err)
		return
	}
	var guild int
	row.Scan(&guild)
	_, err := db.Exec("INSERT INTO userguilds (guild_id, user_id) VALUES ($1, $2) ", guild, user.Id)
	if err != nil {
		reportError(http.StatusInternalServerError, w, err)
		return
	}
	broadcastClient(user.Id, movedGuild{DataType: 0, Guild: guild})

	var username string
	err = db.QueryRow("SELECT username FROM users WHERE id=$1", user.Id).Scan(&username)
	if err != nil {
		reportError(http.StatusInternalServerError, w, err)
		return
	}

	broadcastGuild(guild, userGuild{Username: username, Id: user.Id})
	w.WriteHeader(http.StatusOK)
}

func kickGuildUser(w http.ResponseWriter, r *http.Request, user *session) {
	params := r.URL.Query()
	guild, err := strconv.Atoi(params.Get("guild"))
	if err != nil {
		reportError(http.StatusBadRequest, w, err)
		return
	}
	userId, err := strconv.Atoi(params.Get("user"))
	if err != nil {
		reportError(http.StatusBadRequest, w, err)
		return
	}
	var valid bool
	row := db.QueryRow("SELECT EXISTS (SELECT * FROM guilds WHERE id=$1 AND owner_id=$2)", guild, user.Id)
	if row.Err() != nil {
		reportError(http.StatusInternalServerError, w, row.Err())
		return
	}
	row.Scan(&valid)
	if !valid {
		reportError(http.StatusBadRequest, w, errorNotGuildOwner)
		return
	}
	_, err = db.Exec("DELETE FROM userguilds WHERE guild_id=$1 AND user_id=$2", guild, userId)
	if err != nil {
		reportError(http.StatusInternalServerError, w, err)
		return
	}
	broadcastClient(userId, movedGuild{DataType: 1, Guild: guild})
	w.WriteHeader(http.StatusOK)
}

func banGuildUser(w http.ResponseWriter, r *http.Request, user *session) {
	params := r.URL.Query()
	guild, err := strconv.Atoi(params.Get("guild"))
	if err != nil {
		reportError(http.StatusBadRequest, w, err)
		return
	}
	userId, err := strconv.Atoi(params.Get("user"))
	if err != nil {
		reportError(http.StatusBadRequest, w, err)
		return
	}
	var valid bool
	row := db.QueryRow("SELECT EXISTS (SELECT * FROM guilds WHERE id=$1 AND owner_id=$2)", guild, user.Id)
	if row.Err() != nil {
		reportError(http.StatusInternalServerError, w, row.Err())
		return
	}
	row.Scan(&valid)
	if !valid {
		reportError(http.StatusBadRequest, w, errorNotGuildOwner)
		return
	}
	_, err = db.Exec("UPDATE userguilds SET banned=true WHERE guild_id=$1 AND user_id=$2", guild, userId)
	if err != nil {
		reportError(http.StatusInternalServerError, w, err)
		return
	}
	broadcastClient(userId, movedGuild{DataType: 2, Guild: guild})
	w.WriteHeader(http.StatusOK)
}
