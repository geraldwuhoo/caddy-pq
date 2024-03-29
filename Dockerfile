FROM docker.io/library/alpine:3.19.1 AS builder

WORKDIR /
RUN apk add --no-cache --virtual pack git=2.43.0-r0 && \
    git clone https://github.com/cloudflare/go && \
    git clone https://github.com/caddyserver/caddy && \
    apk del pack

WORKDIR /go/src
RUN apk add --no-cache --virtual pack bash=5.2.21-r0 go=1.21.8-r0 && \
    ./make.bash && \
    apk del pack

WORKDIR /caddy/cmd/caddy
COPY main.go /caddy/cmd/caddy/main.go
RUN ../../../go/bin/go mod tidy && \
    ../../../go/bin/go build -v -ldflags "-w -s" -trimpath

FROM docker.io/library/caddy:2.7.6-alpine

COPY --from=builder /caddy/cmd/caddy/caddy /usr/bin/caddy
