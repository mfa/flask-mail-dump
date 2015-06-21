# purpose

save emails send by mailgun via http POST to files on harddrive

# development

```
docker-compose build
docker-compose up -d
```

# production deployment

```
docker build --tag=flaskdump-prod .
docker run -d --name flaskdump flaskdump-prod
docker run --name flaskdump-nginx --link flaskdump:flaskdump -p 8080:80 -v `pwd`/nginx.conf:/etc/nginx/nginx.conf -d nginx
```
