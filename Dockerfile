FROM alpine

LABEL me.code28.image.authors="Vincent Buzzano <dev@code28.me>"

ENV USERNAME="code28"
ENV HOME="/home/${USERNAME}"
ENV LOCAL_TO=0.0.0.0
ENV LOCAL_PORT=8180
ENV REMOTE_TO=127.0.0.1
ENV REMOTE_PORT=80
ENV SSH_DIR="${HOME}/.ssh"
ENV SSH_FORCE_IP4=false
ENV SSH_FORCE_IP6=false
ENV SSH_ARGS=""
ENV UP_SCRIPT="/scripts/up.sh"
ENV INIT_SCRIPT="/scripts/ini.sh"
ENV SSH_RECONNECT_TIMEOUT=5

ARG USER_UID=1000
ARG USER_GID=1000

RUN apk --no-cache add shadow openssh busybox-extras

ADD ./scripts /scripts
RUN ln -s "${UP_SCRIPT}" /usr/bin/up && \ 
    ln -s "${INIT_SCRIPT}" /usr/bin/ini

RUN groupadd -g $USER_GID $USERNAME && \
    useradd -m -d "${HOME}" -g ${USER_GID} -u ${USER_UID} ${USERNAME}

USER ${USERNAME}
WORKDIR ${HOME}


RUN mkdir -p ${SSH_DIR}
VOLUME "${SSH_DIR}"

EXPOSE "${LOCAL_PORT}"

CMD "${UP_SCRIPT}"
