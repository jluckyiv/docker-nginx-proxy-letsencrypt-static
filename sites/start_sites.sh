#!/bin/sh
for d in ./*/ ; do (cd "$d" && /usr/local/bin/docker-compose up -d); done
