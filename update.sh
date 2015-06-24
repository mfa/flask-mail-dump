#!/bin/sh

set -e

git pull
docker build --tag=flaskdump-prod .
docker rm -f flaskdump
docker rm -f flaskdump-nginx
docker run -d --restart=always -v `pwd`/flaskdump/data:/opt/code/flaskdump/data --name flaskdump flaskdump-prod
# expose on port 8080, because we have another nginx on the system
docker run --name flaskdump-nginx --link flaskdump:flaskdump -p 8080:80 -v `pwd`/nginx.conf:/etc/nginx/nginx.conf -d nginx

echo "Cleaning up old docker images..."
docker rmi $(docker images | grep "<none>" | awk '{print($3)}')

