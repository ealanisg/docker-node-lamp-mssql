#!/bin/sh

docker-compose up -d --build
docker exec -it docker-node sh
