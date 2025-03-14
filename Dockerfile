# hadolint global ignore=DL3018
FROM docker.io/library/alpine:3.21.3 AS builder

WORKDIR /
RUN apk add --no-cache --virtual pack git && \
    git clone --depth 1 --branch v2.9.1 https://github.com/caddyserver/caddy && \
    apk del pack

WORKDIR /caddy/cmd/caddy
COPY main.go /caddy/cmd/caddy/main.go
RUN apk add --no-cache --virtual pack go && \
    go mod tidy && \
    go build -v -ldflags "-w -s" -trimpath && \
    apk del pack

FROM docker.io/library/caddy:2.9.1-alpine

COPY --from=builder /caddy/cmd/caddy/caddy /usr/bin/caddy
