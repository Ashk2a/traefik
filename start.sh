#!/bin/bash

base="mkcert -cert-file certs/local.pem -key-file certs/local-key.pem "$(< domains.txt)""

$base
docker-compose down
docker-compose up -d --build
