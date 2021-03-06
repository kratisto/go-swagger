FROM golang:1.14.3-alpine3.11 as builder
WORKDIR /app
ADD . .
RUN GO111MODULE=off go build -o swagger-musl .

FROM golang:1.14.3-alpine3.11

LABEL maintainer="Ivan Porto Carrero <ivan@flanders.co.nz> (@casualjim)"

RUN apk --no-cache add ca-certificates shared-mime-info mailcap git build-base &&\
  go get -u github.com/go-openapi/runtime &&\
  go get -u github.com/asaskevich/govalidator &&\
  go get -u golang.org/x/net/context &&\
  go get -u github.com/jessevdk/go-flags &&\
  go get -u golang.org/x/net/context/ctxhttp


COPY --from=builder /app/swagger-musl /usr/bin/swagger
COPY --from=builder /app/templates/ /templates/contrib/

ENTRYPOINT ["/usr/bin/swagger"]
CMD ["--help"]
