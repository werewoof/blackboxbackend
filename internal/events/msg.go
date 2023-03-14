package events

type UnreadMsg struct {
	Id    int64 `json:"id"`    //message last read Id
	Count int   `json:"count"` //number of unread messages
	Time  int   `json:"time"`
}

type Msg struct { //id and request id not omitted for checking purposes
	MsgId       int64        `json:"id"`
	Author      User         `json:"author,omitempty"`  // author id aka user id
	Content     string       `json:"content"`           // message content
	GuildId     int64        `json:"guildId,omitempty"` // Chat id
	DmId        int64        `json:"dmId,omitempty"`    // Dm id
	Created     int64        `json:"created,omitempty"`
	Modified    int64        `json:"modified,omitempty"`
	MsgSaved    bool         `json:"msgSaved,omitempty"` //shows if the message is saved or not
	RequestId   string       `json:"requestId"`
	Attachments []Attachment `json:"attachments"`
}

type Attachment struct {
	Id          int64  `json:"id"`
	ContentType string `json:"contentType"` //file type
	Filename    string `json:"filename"`
}