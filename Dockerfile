# Create "build" image
FROM golang:alpine AS builder

# Build the app
WORKDIR /app
COPY main.go /app
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o api main.go
EXPOSE 8080

# Run from builder
FROM alpine
WORKDIR /app
COPY --from=builder /app/api /app/
CMD [ "./api" ]
