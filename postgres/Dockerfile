FROM pgvector/pgvector:0.8.7-pg16@sha256:7b822b0aac60967beb1ea5e576b8602c94c300a157d187f385ae3e0da199b90a

COPY --chmod=755 init-db.sh /docker-entrypoint-initdb.d/10-latitude-runtime-user.sh

CMD ["postgres", "-c", "wal_level=logical"]
