#!/bin/bash

UNAMEOUT="$(uname -s)"./

# Verify operating system is supported...
case "${UNAMEOUT}" in
Linux*) MKCERT_BIN=./bin/mkcert ;;
Darwin*) MKCERT_BIN=mkcert ;;
*) MKCERT_BIN="UNKNOWN" ;;
esac

# Unknown OS ? Where are you ?!
if [ "$MKCERT_BIN" == "UNKNOWN" ]; then
    echo "Unsupported operating system [$(uname -s)]. Supports macOS, Linux, and Windows (WSL2)." >&2
    exit 1
fi

# Define Docker Compose command prefix...
docker compose &>/dev/null
if [ $? == 0 ]; then
    DOCKER_COMPOSE="docker compose"
else
    DOCKER_COMPOSE="docker-compose"
fi

# Build command
BASE="$MKCERT_BIN -cert-file certs/local.pem -key-file certs/local-key.pem $(< domains.txt)"

# Down previous container
$DOCKER_COMPOSE down 2>/dev/null

# Register self trusted certificates
$BASE

# Rebuild container
$DOCKER_COMPOSE up -d --build
