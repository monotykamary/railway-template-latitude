# Railway Template for Latitude

Deploy a production-oriented [Latitude](https://github.com/latitude-dev/latitude-llm) observability stack on Railway with immutable application and infrastructure sources.

The Deploy on Railway button will be added after the replacement marketplace route is published and independently verified.

## What this deploys

- Latitude `v0.3.72`: web UI, public API/MCP server, OTLP ingest, BullMQ workers, Temporal workflows, and one-shot migrations
- PostgreSQL 16 with pgvector
- ClickHouse 26.2
- Redis 7.4 for cache and durable BullMQ queues
- Temporal 1.27 backed by PostgreSQL
- A Railway object-storage bucket shared by all Latitude services

The web, API, and ingest services receive separate Railway HTTPS domains. All stateful protocols stay private.

## Why v0.3.72

`v0.3.72` is the newest stable Latitude release with a complete six-image publication. The upstream image workflows for `v0.3.73` through `v0.3.76` were cancelled and left incomplete service sets. This template will not mix application versions or substitute a development build.

Upstream release workflow evidence: [v0.3.72 succeeded](https://github.com/latitude-dev/latitude-llm/actions/runs/30359024138); [v0.3.76 was cancelled](https://github.com/latitude-dev/latitude-llm/actions/runs/30553621688).

## Railway adaptations

- `postgres/` installs Latitude's runtime database user during first initialization and enables logical WAL, following the upstream single-host stack.
- `clickhouse/` installs Latitude's upstream tiered storage policy.
- Railway object storage replaces the bundled single-node SeaweedFS service.
- One persistent Redis instance serves both documented Redis roles. Latitude namespaces its keys, and the server uses AOF plus `noeviction` for queue durability.
- Database, ClickHouse, Redis, and bucket state receive platform-managed persistence; database and queue volumes are configured for daily backups.

## Required setup

A working email transport is required for magic-link login. After deployment, set one supported transport on the `web` service; the shared template variables propagate it to the services that need it. Use authenticated SMTP (including SendGrid SMTP) or Mailgun, then redeploy the application services.

Then open the `web` domain, register, follow the emailed magic link, and create the first organization.

AI provider credentials are optional. Core OTLP trace ingestion and trace viewing work without them; AI-assisted evaluation, embeddings, reranking, and issue analysis require supported provider keys.

## Important limitations

- This is a substantial stack: ten services plus object storage. Size it for PostgreSQL, ClickHouse, Temporal, and five long-running application processes.
- Email delivery is intentionally not bundled. Do not expose a development mail catcher in production.
- The template does not provide high availability for stateful dependencies.
- Choose an embedding provider and 2048-dimensional model once; changing vector spaces later requires a migration and re-embedding strategy.

## Pinned sources

| Component | Version |
| --- | --- |
| Latitude applications | `0.3.72` at per-image OCI digests |
| pgvector PostgreSQL | `0.8.1-pg16` |
| ClickHouse | `26.2.19.43` |
| Redis | `7.4.7-alpine` |
| Temporal auto-setup | `1.27.2` |
| Upstream source | [`9890133ce416a5e3dcde3b0d0a3153908f87dab4`](https://github.com/latitude-dev/latitude-llm/tree/9890133ce416a5e3dcde3b0d0a3153908f87dab4) |

## Updating

1. Confirm the proposed Latitude tag is stable and immutable.
2. Require all six official service tags (`web`, `api`, `ingest`, `workers`, `workflows`, `migrations`) and `linux/amd64` manifests.
3. Review upstream migrations, environment contract, and single-host stack changes.
4. Pin every image to its OCI digest.
5. Deploy a disposable Railway stack, run product, persistence, redeploy, delayed-readiness, and exact-log tests.
6. Publish only after the live stack is green.

## Upstream and license

Latitude source and the derived logo asset are MIT-licensed. See [UPSTREAM.md](UPSTREAM.md) and [LICENSE](LICENSE).

- [Latitude source](https://github.com/latitude-dev/latitude-llm)
- [Deployment documentation](https://docs.latitude.so/deployment/overview)
- [Configuration reference](https://docs.latitude.so/deployment/configuration)
- [Stable source tag](https://github.com/latitude-dev/latitude-llm/releases/tag/v0.3.72)
