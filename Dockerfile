# hadolint global ignore=DL3018
FROM docker.io/library/alpine:3.22.2 AS builder

WORKDIR /
RUN apk add --no-cache --virtual pack git && \
    git clone --depth 1 --branch v2.10.0-beta.2 https://github.com/caddyserver/caddy && \
    apk del pack

WORKDIR /caddy/cmd/caddy
COPY main.go /caddy/cmd/caddy/main.go
RUN apk add --no-cache --virtual pack go=1.24.0-r0 --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community && \
    go mod tidy && \
    go build -v -ldflags "-w -s" -trimpath && \
    apk del pack

FROM docker.io/library/caddy:2.9.1-alpine

COPY --from=builder /caddy/cmd/caddy/caddy /usr/bin/caddy
