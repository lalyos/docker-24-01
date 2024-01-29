
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