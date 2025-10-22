# hadolint global ignore=DL3018

FROM docker.io/library/caddy:2.10.2-builder-alpine AS builder

RUN xcaddy build \
    --with github.com/caddyserver/replace-response \
    --with github.com/caddy-dns/cloudflare

FROM docker.io/library/caddy:2.10.2-alpine

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
