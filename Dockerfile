FROM golang:alpine as builder

WORKDIR /go/src/app
COPY . .

RUN go env -w GO111MODULE=on \
    && go env -w GOPROXY=https://goproxy.cn,direct \
    && go env -w CGO_ENABLED=0 \
    && go env \
    && go mod tidy \
    && go build -o server .

FROM alpine:latest
WORKDIR /go/src/app
COPY --from=0 /go/src/app/server ./
ENTRYPOINT ./server
