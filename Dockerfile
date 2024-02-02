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

# Cache go modules
COPY ./tester/go.mod /app/go.mod
COPY ./tester/go.sum /app/go.sum
RUN go mod download
COPY ./tester /app

# Cache rust dependencies
COPY ./docker/Cargo.toml /app/docker/Cargo.toml
COPY ./docker/Cargo.lock /app/docker/Cargo.lock
RUN mkdir /app/docker/src
RUN echo 'fn main() { println!("Hello World!"); }' > /app/docker/src/main.rs
RUN cargo build --release --target-dir=/tmp/codecrafters-docker-target --manifest-path=/app/docker/Cargo.toml
RUN cargo clean -p docker-starter-rust --release --target-dir=/tmp/codecrafters-docker-target --manifest-path=/app/docker/Cargo.toml

# Pre-Compile rust docker command
COPY ./docker /app/docker
RUN sed -i -e 's/\r$//' /app/docker/your_docker.sh
ENV CODECRAFTERS_SUBMISSION_DIR="/app/docker"
