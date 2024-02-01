FROM golang:1.17-alpine

RUN apk add curl make gcc musl-dev git openssl-dev

# Download Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:$PATH"

# Download docker-explorer
ARG docker_explorer_version=v18
RUN curl --fail -Lo /usr/local/bin/docker-explorer https://github.com/codecrafters-io/docker-explorer/releases/download/${docker_explorer_version}/${docker_explorer_version}_linux_amd64
RUN chmod +x /usr/local/bin/docker-explorer

WORKDIR /app
COPY ./tester/go.mod /app/go.mod
COPY ./tester/go.sum /app/go.sum

# Cache go modules
RUN go mod download

COPY ./tester /app
COPY ./docker /app/your-docker
ENV CODECRAFTERS_SUBMISSION_DIR="/app/your-docker"
RUN sh /app/your-docker/build_your_docker.sh
