package events

type UnreadMsg struct {
	Id    int `json:"id"`    //message last read Id
	Count int `json:"count"` //number of unread messages
	Time  int `json:"time"`
}

type Msg struct { //id and request id not omitted for checking purposes
	MsgId     int    `json:"id"`
	Author    User   `json:"author,omitempty"` // author id aka user id
	Content   string `json:"content"`          // message content
	GuildId   int    `json:"guildId"`          // Chat id
	Created   int64  `json:"created,omitempty"`
	Modified  int64  `json:"modified,omitempty"`
	MsgSaved  bool   `json:"msgSaved,omitempty"` //shows if the message is saved or not
	RequestId string `json:"requestId"`
}
