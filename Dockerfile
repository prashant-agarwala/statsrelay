FROM golang:1.12.1-alpine AS builder

RUN apk add --no-cache git tzdata

WORKDIR /go/src/statsrelay

ADD . .

RUN go get
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build

FROM alpine:latest
WORKDIR /root

# Copy our static executable.
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /go/src/statsrelay/statsrelay .

ENTRYPOINT ["./statsrelay"]