#!/bin/sh
#start.sh

docker run -d -p 80:80 -p 443:443 \
        -v /etc/nginx/certs:/etc/nginx/certs:ro \
        -v /var/run/docker.sock:/tmp/docker.sock:ro \
        -v /etc/nginx/vhost.d \
        -v /usr/share/nginx/html \
        --label com.github.jrcs.letsencrypt_nginx_proxy_companion.nginx_proxy \
        --name nginx-proxy \
        --restart=always \
        jwilder/nginx-proxy:alpine

docker run -d \
        -v /etc/nginx/certs:/etc/nginx/certs:rw \
        -v /var/run/docker.sock:/var/run/docker.sock:ro \
        --volumes-from nginx-proxy \
        --name letsencrypt-companion \
        --restart=always \
        jrcs/letsencrypt-nginx-proxy-companion

