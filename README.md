# Local Port Forwarding [ Non root]

This is a simple image to create a Local Port Forwarding 

## Features

    - Non-root user.  
    - Auto reconnect on error or connection lost
    - Super easy to use. Just 2 mandatory env variable to define

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

Have a look to docker-compose.yml

### instance a port forwarding
<code>
  docker-compose up -d
</code>

### stop port forwarding
<code>
  docker-compose down
</code>

### update image
<code>
  docker-compose pull
</code>

### see logs
<code>
  docker-compose logs -f
</code>

