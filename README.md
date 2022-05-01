# Postgres with Consul

Monitoring 2 Postgres databases (see docker-compose), using native PG commands.


https://user-images.githubusercontent.com/10214025/166162293-2b283faf-4469-47f0-87d7-ec720792deba.mov


Both databases are monitored by consul using a healthcheck.

- Consul docker image is built with `postgres-client` so that it can probe Postgres from the server
- Database is checked every 3s [here](https://github.com/kiwicopple/consul-postgres/blob/cb186d3243b86aa4fdd96286c3220c332459c6cc/consul/consul.d/postgres1.json#L7)
    - This script checks `pg_isready` [here](https://github.com/kiwicopple/consul-postgres/blob/main/consul/consul.d/pg_check.sh)
- If the datbase goes down then it triggers a watch script [here](https://github.com/kiwicopple/consul-postgres/blob/cb186d3243b86aa4fdd96286c3220c332459c6cc/consul/consul.d/postgres1.json#L37)
  - This watcher inserts the state change into Consul KV [here](https://github.com/kiwicopple/consul-postgres/blob/main/consul/consul.d/handle_state_change.sh), but it could really call any endpoint.

Notes
---

- There is only a single Consul server running - we should run multiple to ensure HA.
- There is no Postgres failover - this is merely handling the monitoring of 2 databases as a POC.
- There could be a liveness probe sent directly from the server, but I like the idea that we could drop this on top of any system (RDS, DO, GCP, etc), and it will "Just work". Since we are using native Postgres, it works with an Postgres-compatible docker image - no extensions required.
- I've written everything on the consul side in shell scripts for now. Could be moved to Rust/Go/Python/etc for better DX.

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
