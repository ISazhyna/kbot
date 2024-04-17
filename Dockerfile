FROM quay.io/projectquay/golang:1.20 as builder

ARG OS


WORKDIR /go/src/app
COPY . .
RUN make build OS=${OS} 

FROM scratch
WORKDIR /
COPY --from=builder /go/src/app/kbot .
COPY --from=alpine:latest /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENTRYPOINT ["./kbot"]