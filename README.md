<code>

         ██████╗ ██████╗ ██████╗ ███████╗   ██████╗  █████╗   
        ██╔════╝██╔═══██╗██╔══██╗██╔════╝   ╚════██╗██╔══██╗  
        ██║     ██║   ██║██║  ██║█████╗      █████╔╝╚█████╔╝  
        ██║     ██║   ██║██║  ██║██╔══╝     ██╔═══╝ ██╔══██╗  
        ╚██████╗╚██████╔╝██████╔╝███████╗   ███████╗╚█████╔╝  
         ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝   ╚══════╝ ╚════╝   
        
                ████████╗███████╗ ██████╗██╗  ██╗  
                ╚══██╔══╝██╔════╝██╔════╝██║  ██║  
                   ██║   █████╗  ██║     ███████║  
                   ██║   ██╔══╝  ██║     ██╔══██║  
                   ██║   ███████╗╚██████╗██║  ██║  
                   ╚═╝   ╚══════╝ ╚═════╝╚═╝  ╚═╝  
</code>
# Local Port Forwarding [ Non root, Auto Reconnect ]

This is a simple image to create a Local Port Forwarding 

## Features

* Non-root user.  
* Auto generate KeyPairs and command to publish publick key on host 
* Auto reconnect on error or connection lost
* Super easy to use. Just 2 mandatory env variable to define

## Environment Variable

Define the following environment variables to configure port-forwarding.

Variable | Description | Optional
-------- | ----------- | --------
USERNAME | non-root username (default code28)
HOME | user home (default | No  /home/code28)
LOCAL_TO | Local ip binding | No  (default 0.0.0.0)
LOCAL_PORT | Local port | No (default 8180)
REMOTE_TO | Remote ip binding | No (default 127.0.0.1)
REMOTE_PORT | Remote port | Yes
REMOTE_HOST | Remote hostname or ip | Yes
SSH_DIR | SSH directory where live id_rsa | No (default ${HOME}/.ssh)
SSH_FORCE_IP4 | Force ssh to use only ip4 | No (default false)
SSH_FORCE_IP6 | Force ssh to use only ip6 | No (default false)
SSH_ARGS | Use to pass additional arguments to ssh | No 
SSH_RECONNECT_TIMEOUT | reconnect timeout if connection lost or error occured | No (default 5s) 

## Environment Variable

Define the following environment variables to configure port-forwarding.

Volume | Description | Optional
-------- | ----------- | --------
ssh | define via the environment variable SSH_DIR. Its where live private key | Yes (default )

## Usage

### Initialization

Before running this image, you should run "ini" script

ssh directory is a folder where you will drop your keypairs (id_rsa, id_rsa.pub) or generate new one with ini script

    cd /path/to/my/project  
    mkdir ssh  

then

    docker run --rm -i -e REMOTE_HOST=[hostname] -v /path/to/my/project/ssh:/home/code28/.ssh code28tech/local-port-forwarding ini  


### Docker Compose
  
Have a look to docker-compose.yml  

    version: "2.4"  
      
    services:  
      
      port_8180_81:  
        image: code28tech/local-port-forwarding:latest  
        container_name: "port_81_8180"  
        restart: unless-stopped  
        environment:  
          - REMOTE_HOST=hostserver.ltd  
          - REMOTE_PORT=81  
        volumes:  
          - $STACK_DIR/ssh:/home/code28/.ssh  
        ports:  
          - 8180:8180/tcp  

#### Start container

    docker-compose up -d  

#### Stop container

    docker-compose down  

#### Update image

    docker-compose pull  

#### logs

    docker-compose logs -f  


### Docker

#### initialize container

    docker run --rm -i -e REMOTE_HOST=[hostname] \  
      -v [/path/to/my/project/ssh]:/home/code28/.ssh \  
      code28tech/local-port-forwarding ini

#### run container

    docker run --rm -d -e REMOTE_PORT=81 -e REMOTE_HOST=[hostname] \
      -v /path/to/keypairs/folder:/home/code28/.ssh -p 8180:8180 \ 
      --name port-8180-81 code28tech/local-port-forwarding

#### stop container

    docker stop port-8180-81

#### udpate container 

    docker pull code28tech/local-port-forwarding:latest

#### logs

    docker logs -f port-8180-81


## Links

- Github: https://github.com/vbuzzano/docker-local-port-forwarding

- Docker Hub: https://hub.docker.com/r/code28tech/local-port-forwarding
