FROM golang:1.23.4 AS builder
WORKDIR /app
COPY . .
RUN go mod download
RUN GOOS=linux CGO_ENABLED=0 go build -ldflags="-w -s" -o go-cep main.go

FROM scratch
WORKDIR /app
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /app/go-cep .
ENTRYPOINT ["./go-cep"]