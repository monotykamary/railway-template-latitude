#!/usr/bin/env bash
set -euo pipefail

: "${POSTGRES_RUNTIME_USER:?POSTGRES_RUNTIME_USER is required}"
: "${POSTGRES_RUNTIME_PASSWORD:?POSTGRES_RUNTIME_PASSWORD is required}"

psql \
  --set ON_ERROR_STOP=1 \
  --set runtime_user="$POSTGRES_RUNTIME_USER" \
  --set runtime_password="$POSTGRES_RUNTIME_PASSWORD" \
  --set database="$POSTGRES_DB" \
  --username "$POSTGRES_USER" \
  --dbname "$POSTGRES_DB" <<'SQL'
CREATE USER :"runtime_user" WITH PASSWORD :'runtime_password';
GRANT CONNECT ON DATABASE :"database" TO :"runtime_user";
CREATE EXTENSION IF NOT EXISTS vector;
SQL
