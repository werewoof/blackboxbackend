package events

import (
	"regexp"

	"github.com/asianchinaboi/backendserver/internal/errors"
)

type User struct {
	UserId   int64  `json:"id"`
	Name     string `json:"name,omitempty"`
	Icon     int    `json:"icon,omitempty"`
	Password string `json:"password,omitempty"`
	Email    string `json:"email,omitempty"`
	Flags    *int   `json:"flags,omitempty"`
}

type Member struct { //may use for nicks later
	GuildId  int  `json:"guildId"`
	UserInfo User `json:"userInfo"`
}

/*
* flags
* 0x01 developer
* 0x02 moderator
* 0x04 tester
* 0x08 first user
* 0x10
* 0x20
* 0x40
* 0x80
 */

const (
	FLdeveloper = 1 << iota
	FLmoderator
	FLtester
	FLfirstUser
)

func ValidateUserInput(body User) (errors.StatusCode, error) {

	usernameValid, err := validateUsername(body.Name)
	if err != nil {
		return errors.StatusInternalError, err
	}
	if !usernameValid {
		return errors.StatusInvalidUsername, errors.ErrInvalidUsername
	}

	passwordValid, err := validateUserPassword(body.Password)
	if err != nil {
		return errors.StatusInternalError, err
	}
	if !passwordValid {
		return errors.StatusInvalidPass, errors.ErrInvalidPass
	}

	emailValid, err := validateUserEmail(body.Email)
	if err != nil {
		return errors.StatusInternalError, err
	}
	if !emailValid && len(body.Email) > 0 { //email optional
		return errors.StatusInvalidEmail, errors.ErrInvalidEmail
	}

	return -1, nil
}

func validateUsername(name string) (bool, error) {
	return regexp.MatchString("^[a-zA-Z0-9_]{3,32}$", name)
}

func validateUserEmail(email string) (bool, error) { //128 characters limit fix later in regex
	return regexp.MatchString("^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\\.[a-zA-Z0-9-]+)*$", email)
}

func validateUserPassword(password string) (bool, error) {
	return regexp.MatchString(`^[\x20-\xFF]{6,64}$`, password)
}