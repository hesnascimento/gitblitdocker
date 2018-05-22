# gitblitdocker
GitBlit Server for Docker in production mode and volume percistence.
This repository is based on [GitBlit](https://github.com/gitblit/gitblit-docker) Dockerfile.

## Basic Understanding

The major differences from original GitBlit repository are the configurable volumes.

*  The repository folder is internally mapped to `/opt/gitblit-repository`
*  The base folder is internally mapped to `/opt/gitblit-data`
*  This repository cames with the basic configuration for a good start of your base folder
*  The auto redirect to SSL is disabled, so if you want to use please set server.redirectToHttpsPort on Dockerfile line 39 to `TRUE`

This repository was made for a production GitBlit with minimun effort.

## Installation

First of all you must clone this repository

```sh
git clone https://github.com/henriquenascimento/gitblitdocker gitblit
```

Then you will build the dockerfile 

```sh
    docker build -t henriquenascimento-gitblit .
```

and run your docker container

```sh
    docker run -v /path/to/your/repository:/opt/gitblit-repository \
    -v /path/to/your/data:/opt/gitblit-data \
    -p 9418:9418 -p 29418:29418 -p 443:443 \
    -p 80:80 -d henriquenascimento-gitblit
```

As seen about, this container will need ports: `80`, `443`, `9418` and `29418`.


After running the Dockerfile and start you container you can use by accessing http://localhost

Username: admin
Password: admin

**PLEASE CHANGE IT**