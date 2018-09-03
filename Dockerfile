FROM golang:1.10

RUN mkdir /echo
COPY ./main.go /echo

CMD ["go", "run", "/echo/main.go"]