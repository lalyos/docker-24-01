
## First container

```
docker run -i -t ubuntu
```

inside

```
ps -ef
apt-get update -qq
apt-get install -y curl

curl 444.hu -L
exit
```

on-host

```
docker ps
docker ps -a

docker rename dc ubul
docker start ubul
docker attach ubul
```

detach: CTRL-p CTRL-q

## next container

```
docker run -it --name masik  ubuntu
exit
docker rm masik
docker ps -a
```

## create "artisan" image

```
docker commit ubul kurl
docker images
```

## add webserver

```
docker run -it kurl
apt-get install -y nginx
nginx

curl localhost
curl 127.0.0.1
curl 127.1

echo coffe break > /var/www/html/index.html
curl 127.1
```

new image

```
docker stop bc
docker stop -t 0 bc

docker commit bc coffee
docker images
```

```
alias dps='docker ps -a'
alias dnuke='docker rm -f $(docker ps -qa)'
```

```
docker run -it coffee
nginx
curl 127.1
```

## Command attach/detach

```
docker run ubuntu echo hello
docker logs ad6

docker run -d --name loop ubuntu bash -c "while true; do date; sleep 1; done"
docker logs loop

```

## Network

```
docker inspect d9 | grep IPA
docker run -it -p 8080:80  coffee
```

## Build

```
# create Dockerfile
docker build -t lunch .

docker history lunch
```

## image naming
ubuntu = docker.io/library/ubuntu:latest

- server: docker.io [default]
- repository/owner: library [default]
- name: ubuntu
- tag/version: latest [default]


## Lunch image

```
docker build -t lunch:v2 .
```

add CMD to Dockerfile
```
docker build -t lunch:v3 .

docker run -d  lunch:v3
```

add `-g "daemon off"` to nginx

```
docker build -t lunch:v4 .
# expose port
docker run -d -p 8080:80 lunch:v4
```

add `EXPOSE 80` to Dockerfile
expose variants:
- docker run -d -p 8080:80 lunch:v4 # explicit host port: 8080
- docker run -d -p 80 lunch:v4      # host port: random high port 
- docker run -d -P lunch:v4         # only if EXPOSE defined in Dockerfile


```
docker build -t lunch:v5 .
docker run -dP lunch:v5
```

## Configuration

https://12factor.net/


### Env variables

```
FOOD=pacal
# expose to subprocesses
export FOOD 

# 2 steps in 1
export FOOD=pacal

# clear env var
unset FOOD

# list env vars
env
set
printenv

# canical env substitution
echo ${FOOD}

# with default
echo ${FOOD:-pacal}

# default with set sideffect
echo ${FOOD:=pacal}

# error message if unset
echo ${FOOD:? required}

```


## use start.sh as PID1

```
docker build -t lunch:v6 .
```

```
docker run -dP \
  -e TITLE='coffe break for lalyos' \
  -e COLOR=lightgreen \
  -e BODY='...'
  lunch:v7
```

## Image from git repo

```
docker build -t lunch:lalyos https://github.com/lalyos/docker-24-01.git
```

## Publish image

```
docker build -t lalyos/lunch:v7 .
```

When using Github or Google Oauth, you need to create a
docker hub access token at: https://hub.docker.com/settings/security

It will be yout "password" for `docker login`
```
docker login
docker push lalyos/lunch:v7
```


"It was working on my machine" (tm)
```
docker run -dP -e TITLE=public-image lalyos/lunch:v7
```

## Private registry

```
docker run -d -p 5000:5000 registry:2
```

push to local registry
```
docker build -t 127.0.0.1:5000/lunch:v7 .
docker push 127.0.0.1:5000/lunch:v7
curl 127.1:5000/v2/_catalog
```


## Volume

Named volume
```
docker run -it --rm -v data1:/var/data ubuntu

 cd /var/data
 date > a.txt
 echo i was here >> a.txt
 exit
```

new container
```
ls -l /var/data/
echo second >> /var/data/a.txt
exit
```

list volumes
```
docker volume ls
```

## Postgres

```
docker run -d postgres
docker logs
docker run --name mydb -d -e POSTGRES_PASSWORD=secret  postgres
```

```
docker exec -it mydb bash
psql -U postgres

create table vip (name varchar(20), age int, money int);
insert into vip values('elon', 45, 2000 );
insert into vip values('lorinc', 65, 200);
insert into vip values('klara', 55, 20);
exit
exit
```

```
docker exec -it mydb psql -U postgres -c 'select * from vip'

docker stop mydb
docker start
docker exec -it mydb psql -U postgres -c 'select * from vip'

docker rm -f mydb
## @$!%^@
```

new container with old data
```
 docker run -d \
   --name mydb \
   -v 1d14f5da5898ffecdc98f6a76df5de1c28873b16b7b8f82ede14e9894e85771b:/var/lib/postgresql/data \
   -e POSTGRES_PASSWORD=secret  \
   postgres
```

delete all containers and volumes
```
docker rm -f mydb
docker run -d \
   --name mydb \
   -v vipdb:/var/lib/postgresql/data \
   -e POSTGRES_PASSWORD=secret  \
   postgres
```

final solution
```
docker run -d \
   --name mydb \
   -v vipdb:/var/lib/postgresql/data \
   -v $PWD/sql:/docker-entrypoint-initdb.d \
   -e POSTGRES_PASSWORD=secret \
   postgres
```

## Network

Networks:
- bridge
  - default (bridge): DNS is coming host
  - custom: DNS 127.0.0.11 (DNS provided by docker)
- host: interfaces "stealed from host"
- none: 127.0.0.1 only
- container:c1 interfaces "stealed from c1"

```
docker network ls
```

## Compose

```
docker compose up
docker compose up -d
docker compose up --build -d 
## this the default in VSCode
```

tear down keeping persistence
```
docker compose down
```

clear everything including names volumes
```
docker compose down -v
```

## use env variables


replace all hardcoded env in docker-compose.yaml to ${DOMEVAR:-withdefault}

use custom .env file
```
docker compose --env-file .env.prod up -d
```