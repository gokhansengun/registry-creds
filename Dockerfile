FROM golang:1.11-alpine AS builder

RUN apk add --update git ca-certificates && \
  rm -rf /var/cache/apk/*

WORKDIR /go/src/github.com/upmc-enterprises/registry-creds

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -o registry-creds --ldflags '-w' main.go

FROM alpine:3.4
MAINTAINER Steve Sloka <steve@stevesloka.com>

RUN apk add --update ca-certificates && \
  rm -rf /var/cache/apk/*

COPY --from=builder /go/src/github.com/upmc-enterprises/registry-creds/registry-creds /registry-creds

ENTRYPOINT ["/registry-creds"]
