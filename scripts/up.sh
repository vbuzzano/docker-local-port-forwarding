#!/bin/sh

echo "
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
"

if [ ! "${REMOTE_PORT}" ]; then
  echo "REMOTE_PORT is undefined but mandatory. use --env REMOTE_PORT=\"8080\"" 1>&2
  exit
fi

if [ ! "${REMOTE_HOST}" ]; then
  echo "REMOTE_HOST is undefined but mandatory. use --env REMOTE_HOST=\"myserver\"" 1>&2
  exit
fi

if [ ! -f "${SSH_DIR}/id_rsa" ]; then
  echo "PORT TUNNELING NOT INITIALIZED" 1>&2
  echo "> execute: docker-compose run --rm port-tunneling ini" 1>&2
  exit
fi

if [ ! "${LOCAL_PORT}" ]; then
  LOCAL_PORT=${REMOTE_PORT}
fi

if [ ! "${LOCAL_TO}" ]; then
  LOCAL_TO="0.0.0.0"
fi

if [ ! "${REMOTE_USER}" ]; then
  REMOTE_USER=${USERNAME}
fi

if [ ! "${REMOTE_TO}" ]; then
  echo "REMOTE_TO is undefined, using default 127.0.0.1"
  echo "set local port: docker --env REMOTE_TO=\"127.0.0.1\""
  REMOTE_TO=127.0.0.1
fi

if [ ! "${SSH_RECONNECT_TIMEOUT}" ]; then
  SSH_RECONNECT_TIMEOUT=5
fi

SSH_CMD="/usr/bin/ssh" # -N"

if [ "${SSH_FORCE_IP4}" ]; then
  SSH_CMD="${SSH_CMD} -4"
elif [ "${SSH_FORCE_IP6}" ]; then
  SSH_CMD="${SSH_CMD} -6"
fi
if [ "${SSH_ARGS}" ]; then
  SSH_CMD="${SSH_CMD} ${SSH_ARGS}"
fi

SSH_CMD="${SSH_CMD} -i ${SSH_DIR}/id_rsa ${REMOTE_USER}@${REMOTE_HOST}"
SSH_CMD="${SSH_CMD} -L ${LOCAL_TO}:${LOCAL_PORT}:${REMOTE_TO}:${REMOTE_PORT} -N"

echo "               Local Port Forwarding"
echo "    \"${REMOTE_HOST}:${REMOTE_TO}:${REMOTE_PORT}\" --> \"${LOCAL_TO}:${LOCAL_PORT}\""
echo "" #> ${SSH_CMD}"
reconnectMsg="try to reconnect in ${SSH_RECONNECT_TIMEOUT} second(s)."
while true; do
  $SSH_CMD &
  pid=$! && echo "$(date -Iseconds) ¬> Forward Port [PID: ${pid}]" &&
    trap "kill $pid" SIGINT && wait $pid
  errcode=$?
  [ $errcode -eq 0 ] && break || [ $errcode -eq 130 ] &&
    echo "$(date -Iseconds) ¬> Interrupted SIGINT" && break ||
    # try to connect if an error occured
    echo "$(date -Iseconds) ¬> Recovery: ${reconnectMsg}" &&
    sleep ${SSH_RECONNECT_TIMEOUT}
done
trap SIGINT
