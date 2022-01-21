# my first docker


`-t` for tag. 
`-f` to specify the docker file (default is PATH/Dockerfile). https://docs.docker.com/engine/reference/commandline/build/

    docker build -t ohads-test-0001 -f Dockerfile .

    docker run -it ohads-test-0001 sh




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

deleting a container by its ID:

    docker image rm -f ohads-test-0001



add code for kafka-producer (from https://github.com/OhadR/kafka-sandbox)