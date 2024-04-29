#!/bin/sh

docker system prune --force
docker build -t docker-tester-dev . && docker run --cap-add "SYS_ADMIN" -e "TERM=xterm-256color" docker-tester-dev make test
