#!/bin/sh
#stop.sh

docker container stop letsencrypt-companion
docker container rm letsencrypt-companion
docker container stop nginx-proxy
docker container rm nginx-proxy
