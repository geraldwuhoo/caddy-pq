# hadolint global ignore=DL3018
FROM docker.io/library/alpine:3.20.0 AS builder

WORKDIR /
RUN apk add --no-cache --virtual pack git && \
    git clone https://github.com/cloudflare/go && \
    git clone https://github.com/caddyserver/caddy && \
    apk del pack

WORKDIR /go/src
RUN apk add --no-cache --virtual pack bash go && \
    ./make.bash && \
    apk del pack

WORKDIR /caddy/cmd/caddy
COPY main.go /caddy/cmd/caddy/main.go
RUN ../../../go/bin/go mod tidy && \
    ../../../go/bin/go build -v -ldflags "-w -s" -trimpath

FROM docker.io/library/caddy:2.7.6-alpine

COPY --from=builder /caddy/cmd/caddy/caddy /usr/bin/caddy
