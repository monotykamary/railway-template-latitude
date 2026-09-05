# Deploy and Host Latitude on Railway

Deploy Latitude `v0.3.92`, an open-source observability platform for AI agents and LLM applications. Capture OpenTelemetry traces, inspect sessions and tool calls, evaluate output quality, and use the API or MCP server from a complete Railway-hosted stack.

## About Hosting Latitude

This template deploys the six matching Latitude `0.3.92` application images: the web UI, public API and MCP server, OTLP ingest, BullMQ workers, Temporal workflow workers, and a one-shot migrations job. PostgreSQL with pgvector, ClickHouse, Redis, Temporal, and a Railway object-storage bucket provide the backing infrastructure.

The `web`, `api`, and `ingest` services each own a Railway HTTPS domain. PostgreSQL, ClickHouse, Redis, and Temporal remain private. Secrets and infrastructure passwords are generated per deployment and wired through service references.

A working email transport is required for magic-link sign-in. Configure authenticated SMTP (including SendGrid SMTP) or Mailgun on the `web` service, redeploy the application services, then open the `web` domain, register, follow the emailed link, and create the first organization.

## Common Use Cases

- Observe production AI-agent traces, sessions, tool calls, latency, and token usage.
- Ingest OpenTelemetry from TypeScript, Python, and other compatible runtimes.
- Evaluate LLM output and track regressions against human-aligned criteria.
- Search and inspect traces from the web UI, public API, CLI, or MCP clients.
- Operate a self-hosted Latitude installation with deliberate, pinned upgrades.

## Dependencies for Latitude Hosting

- PostgreSQL 16 with pgvector for users, projects, configuration, and metadata.
- ClickHouse for span and telemetry analytics.
- Redis for caching, locks, rate limits, and durable BullMQ queues.
- Temporal for durable workflows.
- Railway object storage for shared ingest payloads, datasets, and exports.
- An external authenticated SMTP or Mailgun account for production login email.
- Optional AI-provider accounts for generation, embeddings, and reranking features.

### Deployment Dependencies

- [Latitude v0.3.92 source](https://github.com/latitude-dev/latitude-llm/tree/2c129d80d27f2f5c96dec1a889cca38217f862f2)
- [Self-hosting guide](https://docs.latitude.so/deployment/single-host)
- [Configuration reference](https://docs.latitude.so/deployment/configuration)
- [Official service images](https://hub.docker.com/u/latitudedata)
- [Railway template source and maintenance notes](https://github.com/monotykamary/railway-template-latitude)

### Implementation Details

The template pins all six Latitude services to the same stable release and immutable OCI digests. `v0.3.92` is used because its release workflow published a complete matching six-image set; all six image digests are verified in the registry before pinning.

The PostgreSQL and ClickHouse services use small, auditable adapters from the template repository to install the upstream initialization and storage-policy files. A Railway bucket replaces the bundled single-node SeaweedFS service. One persistent Redis service supplies both Redis roles supported by Latitude and runs with AOF plus `noeviction` for queue durability.

Daily backups are configured for PostgreSQL, ClickHouse, and Redis volumes. The bucket provides shared object storage across independently deployed services. Cross-service variables are generated and referenced automatically; do not replace them with public hosts or duplicate passwords.

Core trace ingestion and viewing work without AI credentials. AI-assisted features remain unavailable until supported provider credentials and model selections are configured. This is a resource-intensive, single-instance stateful deployment rather than a high-availability cluster.

### Why Deploy Latitude on Railway?

Railway provides HTTPS routing, private service networking, persistent volumes, object storage, generated secrets, health checks, and coordinated deployment for Latitude's application and data services. The template removes manual Compose networking while retaining the upstream service boundaries and deliberate version pinning.
