[![progress-banner](https://backend.codecrafters.io/progress/docker/7ed4e8df-c68b-46db-b040-76de15f9482e)](https://app.codecrafters.io/users/codecrafters-bot?r=2qF)

This is a starting point for Rust solutions to the
["Build Your Own Docker" Challenge](https://codecrafters.io/challenges/docker).

In this challenge, you'll build a program that can pull an image from
[Docker Hub](https://hub.docker.com/) and execute commands in it. Along the way,
we'll learn about [chroot](https://en.wikipedia.org/wiki/Chroot),
[kernel namespaces](https://en.wikipedia.org/wiki/Linux_namespaces), the
[docker registry API](https://docs.docker.com/registry/spec/api/) and much more.

# Quick Start

## Setup Environment

Please ensure you have [Docker installed](https://docs.docker.com/get-docker/)
locally.

Next, add a [shell alias](https://shapeshed.com/unix-alias/):

```sh
alias mydocker='docker build -t mydocker . && docker run --cap-add="SYS_ADMIN" mydocker'
```

(The `--cap-add="SYS_ADMIN"` flag is required to create
[PID Namespaces](https://man7.org/linux/man-pages/man7/pid_namespaces.7.html))

## Run mydocker

You can now execute your program like this:

```sh
mydocker run ubuntu:latest /usr/local/bin/docker-explorer echo hey
```

This command compiles your Rust project, so it might be slow the first time you
run it. Subsequent runs will be fast.

## Run Tests

You can test your program like this:

```sh
# Test shell output
./test_shell_output.sh

# Test your docker command
./test_your_docker.sh
```
