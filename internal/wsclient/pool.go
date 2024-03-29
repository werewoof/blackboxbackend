package wsclient

import (
	"sync"

	"github.com/asianchinaboi/backendserver/internal/events"
)

type pools struct {
	guildsMutex  sync.RWMutex
	clientsMutex sync.RWMutex
	guilds       map[int64]*guildPool
	clients      map[int64]map[string]brcastEvents
}

var Pools *pools

func NewPools() *pools {
	return &pools{
		guilds:  make(map[int64]*guildPool),
		clients: make(map[int64]map[string]brcastEvents),
	}
}

func (p *pools) RemoveAll() {
	p.guildsMutex.Lock()
	defer p.guildsMutex.Unlock()
	p.clientsMutex.Lock()
	defer p.clientsMutex.Unlock()
	for _, pool := range p.guilds {
		pool.quit()
	}
	for _, client := range p.clients {
		for _, ch := range client {
			ch <- DataFrame{
				Op:    TYPE_DISPATCH,
				Event: events.LOG_OUT,
			}
		}
	}
	p.guilds = make(map[int64]*guildPool)
	p.clients = make(map[int64]map[string]brcastEvents)
}

func init() {
	Pools = NewPools()
}
