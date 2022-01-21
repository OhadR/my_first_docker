# my first docker

## phase 1 - simple scenario: build code and run in docker

`-t` for tag. 
`-f` to specify the docker file (default is PATH/Dockerfile). https://docs.docker.com/engine/reference/commandline/build/
The Dockerfile *copies* all sources to the docker, and upon docker-build it runs `npm install` and then *builds* the code.

    docker build -t ohads-test-0001 -f Dockerfile .
    docker build -t ohads-test-0001 .

    docker run -it ohads-test-0001 sh

...and then in the docker itself, run the program:


    /app # npm run start


### containers

to list all containers:

    docker container ls -a

deleting a container by its ID:

    docker container rm 8302e58726ed

note that if a container is deleted, we can still call docker run and run it!

### images

to list all images:

    docker images

deleting an image by its tag:

    docker image rm -f ohads-test-0001

## phase 2 - same, but connect to another docker

I wanted to see how dockers can interact. So I ran Kafka docker (see https://github.com/OhadR/kafka-sandbox), and to place
in my docker here a publisher that would send messages to Kafka.

It appears not to be simple at all, and 2 were learnt:
1. when I worked with Kafka docker from my *localhost* I used http://localhost:9092. But using it from another docker is 
by using http://kafka:29092.
2. must read [maximorlov post](https://maximorlov.com/4-reasons-why-your-docker-containers-cant-talk-to-each-other/
   ) about dockers interactions! TLDR: Kafka and zookeeper are running on a seperate network. I had to **add the publisher 
   docker to this network** (see commands below, `docker network connect`)  

## Networking

add code for kafka-producer (from https://github.com/OhadR/kafka-sandbox)

https://maximorlov.com/4-reasons-why-your-docker-containers-cant-talk-to-each-other/

To find out if two containers share a network, first list all the networks of the container. See above how to get the list of containers. 

    docker inspect -f "{{range $key, $value := .NetworkSettings.Networks}}{{$key}} {{end}}" 314cbaf66828

and i get `bridge`

    docker network ls    
    docker network inspect -f "{{range .Containers}}{{.Name}} {{end}}" bed0d2cae838


```
C:\Ohads\Dev\projects\my_first_docker>docker container ls
CONTAINER ID        IMAGE                      COMMAND                  CREATED             STATUS              PORTS                                                  NAMES
2911b2abf8ce        ohads-test-0002            "docker-entrypoint.s…"   2 minutes ago       Up 2 minutes                                                               friendly_lederberg
42c6a1d63f05        bitnami/kafka:latest       "/opt/bitnami/script…"   12 minutes ago      Up 12 minutes       0.0.0.0:9092->9092/tcp, 0.0.0.0:29092->29092/tcp       kafka-broker
420899ff9c5b        bitnami/zookeeper:latest   "/opt/bitnami/script…"   12 minutes ago      Up 12 minutes       2888/tcp, 3888/tcp, 0.0.0.0:2181->2181/tcp, 8080/tcp   zookeeper

C:\Ohads\Dev\projects\my_first_docker>docker network ls
NETWORK ID          NAME                    DRIVER              SCOPE
bed0d2cae838        bridge                  bridge              local
5cc9f2d68b07        exercisefiles_default   bridge              local
d92121e49dcf        host                    host                local
2f6968fe3d8d        kafka-sandbox_default   bridge              local
5e3f8da18953        none                    null                local
0e7ad2c1778a        prems2_default          bridge              local

C:\Ohads\Dev\projects\my_first_docker>docker network connect 2f6968fe3d8d 2911b2abf8ce

```