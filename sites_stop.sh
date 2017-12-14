#!/bin/sh
for d in ./sites/*/ ; do (cd "$d" && /usr/local/bin/docker-compose stop); done
