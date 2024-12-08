FROM docker.io/library/alpine:latest

LABEL org.opencontainers.images.source https://github.com/chris-m-powell/ansible.git

ENV APP_USER=app
ENV APP_DIR="/$APP_USER"
ENV DATA_DIR "$APP_DIR/data"
ENV CONF_DIR "$APP_DIR/conf"
ENV PATH="$PATH:$APP_DIR/.local/bin"

RUN echo "https://alpine.global.ssl.fastly.net/alpine/v$(cut -d . -f 1,2 < /etc/alpine-release)/main" > /etc/apk/repositories \
	&& echo "https://alpine.global.ssl.fastly.net/alpine/v$(cut -d . -f 1,2 < /etc/alpine-release)/community" >> /etc/apk/repositories \
  && apk update && apk add --no-cache py3-pip git openssh-client sshpass \
  && adduser -s /bin/sh -u 1000 -D -h $APP_DIR $APP_USER \
  && mkdir "$DATA_DIR" "$CONF_DIR" \
  && chown -R "$APP_USER" "$APP_DIR" "$CONF_DIR" \
  && chmod 700 "$APP_DIR" "$DATA_DIR" "$CONF_DIR"

USER "$APP_USER"

RUN python3.12 -m pip install ansible-core --user --break-system-packages \
  && ansible-galaxy collection install community.general ansible.posix \
  && git clone https://github.com/chris-m-powell/ansible.git "$DATA_DIR" \
    --single-branch \
    --branch master \
    --depth 1

WORKDIR $DATA_DIR

USER "$APP_USER"
ENTRYPOINT ["ansible-playbook", "playbooks/deploy.yml", "-i", "inventories/lan.yml", "-u"]
CMD ["chris"]
