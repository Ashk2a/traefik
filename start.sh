#!/bin/bash

base="mkcert -cert-file certs/local.pem -key-file certs/local-key.pem $(< domains.txt)"

docker-compose down

echo $base
$base

docker-compose up -d --build
