FROM golang:1.14 as build-env

WORKDIR /go/src/app
ADD . /go/src/app

RUN go build -o /go/bin/snykly

FROM gcr.io/distroless/base
EXPOSE 8080
COPY --from=build-env /go/bin/snykly /
CMD ["/snykly"]
