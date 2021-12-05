#!/bin/sh

echo "
 ██████╗ ██████╗ ██████╗ ███████╗   ██████╗  █████╗            ████████╗███████╗ ██████╗██╗  ██╗
██╔════╝██╔═══██╗██╔══██╗██╔════╝   ╚════██╗██╔══██╗           ╚══██╔══╝██╔════╝██╔════╝██║  ██║
██║     ██║   ██║██║  ██║█████╗      █████╔╝╚█████╔╝   █████╗     ██║   █████╗  ██║     ███████║
██║     ██║   ██║██║  ██║██╔══╝     ██╔═══╝ ██╔══██╗   ╚════╝     ██║   ██╔══╝  ██║     ██╔══██║
╚██████╗╚██████╔╝██████╔╝███████╗   ███████╗╚█████╔╝              ██║   ███████╗╚██████╗██║  ██║
 ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝   ╚══════╝ ╚════╝               ╚═╝   ╚══════╝ ╚═════╝╚═╝  ╚═╝
"

if [ ! "${REMOTE_HOST}" ]; then
  echo "REMOTE_HOST is undefined but mandatory. use --env REMOTE_HOST=\"myserver\"" 1>&2
  exit
fi

if [ ! "${SSH_DIR}" ]; then
  echo "SSH_DIR undefined, using default /ssh"
  echo "set SSH_DIR: docker --env SSH_DIR=\"/ssh\""
  $SSH_DIR=~/.ssh
fi

if [ ! "${REMOTE_USER}" ]; then
  REMOTE_USER=$USERNAME
fi

if [ ! -f "${SSH_DIR}/id_rsa" ]; then
  echo "SSH KEY NOT FOUND : ${SSH_DIR}/id_rsa"
  echo "> generating ssh key to ${SSH_DIR}"
  ssh-keygen -t rsa -b 4096 -f ${SSH_DIR}/id_rsa -N ''
  echo""
  echo "> install the public key ${SSH_DIR}/id_rsa.pub on HOST server"
  cat ${SSH_DIR}/id_rsa.pub
  echo ""
fi

if [ ! -f "$SSH_DIR/known_hosts" ]; then
  echo "Adding host to known_hosts"
  ssh-keyscan -t rsa "${REMOTE_HOST}" | tee key-temp | ssh-keygen -lf - &&
    cat key-temp >>$SSH_DIR/known_hosts && rm key-temp
fi

chmod 400 "${SSH_DIR}/id_rsa"
chmod 400 "${SSH_DIR}/id_rsa.pub"
chmod 644 "${SSH_DIR}/known_hosts"

# Publish public key to remote host
echo ""
echo "Initialization done :)"
echo "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
echo ""
echo "You need to publish your public key to remote host ${REMOTE_HOST}"
echo "copy (and adapt) the following command :"
echo ""
echo "cat [PATH_TO_SSH_DIR]/id_rsa.pub | ssh [${REMOTE_USER}@]${REMOTE_HOST} \"cat >> /home/${REMOTE_USER}/.ssh/authorized_keys\""
echo ""
