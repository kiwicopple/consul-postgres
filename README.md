


# Todo

The Postgres check should uses psql script check (see example here: https://www.consul.io/docs/discovery/checks#check-definition)
To do this, Consul needs to be loaded with psql-client then run pg_isready.
We can probably use the consul docker image as a base then build on top


PG1 is started as primary
see: `pg1/data/postgresql.conf > REPLICATION`

```
max_wal_senders = 10	
max_replication_slots = 10
```


Ideas
---

Could we use a local DB for service discovery - store availabilty data which is replicated p2p to every other service?

- NATs
- CRDT? - Yjs, Automerge rust: https://github.com/automerge/automerge-rs
- rqlite: https://github.com/rqlite/rqlite/ (although we probably want master-master)
- litestream
- Barrel https://barrel-db.org/

Should we just store all the availability state in a shared Postgres?

- Gets rid of KV store
- Consolidates on a single tool
- Atomic - no threat of split brain

Can we wrap all of this into a single Elixir cluster?

- Genserver for "pings" - healthcheck
- Genserver for "pooling" - hold open some connections like pgbouncer
- Reverse proxy for loadbalancing/message queing
- Globally distributed - multitenant
