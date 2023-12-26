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

RUN python3.11 -m pip install ansible-core --user --break-system-packages \
  && ansible-galaxy collection install community.general ansible.posix \
  && git clone https://github.com/chris-m-powell/ansible.git "$DATA_DIR" \
    --single-branch \
    --branch master \
    --depth 1

USER root

RUN find /bin /etc /lib /sbin /usr -xdev -type f -regex '.*apk.*' ! -name apk -exec rm -fr {} + \
  && sed -i -r 's#^(.*):[^:]*$#\1:/sbin/nologin#' /etc/passwd \
  && while IFS=: read -r username _; do passwd -l "$username"; done < /etc/passwd || true \
  && rm -rf /var/spool/cron /etc/crontabs /etc/periodic \
  && find /sbin /usr/sbin ! -type d -a ! -name ln -delete \
  && find /bin /etc /lib /sbin /usr -xdev \( \
    -iname hexdump -o \
    -iname chgrp -o \
    -iname ln -o \
    -iname od -o \
    -iname strings -o \
    -iname su -o \
    -iname sudo \
    \) -delete \
  && sed -i -r "/^($APP_USER|root|nobody)/!d" /etc/group \
  && sed -i -r "/^($APP_USER|root|nobody)/!d" /etc/passwd \
  && find /bin /etc /lib /sbin /usr -xdev -type f -regex '.*-$' -exec rm -f {} + \
  && find /bin /etc /lib /sbin /usr -xdev -type d \
    -exec chown root:root {} \; \
    -exec chmod 0755 {} \; \
  && find / -xdev -type d -perm +0002 -exec chmod o-w {} + \
	&& find / -xdev -type f -perm +0002 -exec chmod o-w {} + \
	&& chmod 777 /tmp \
  && chown $APP_USER:root /tmp \
  && find /bin /etc /lib /sbin /usr -xdev -type f -a \( -perm +4000 -o -perm +2000 \) -delete \
  &&  rm -rf /etc/init.d \
    /lib/rc \
    /etc/conf.d \
    /etc/inittab \
    /etc/runlevels \
    /etc/rc.conf \
    /etc/logrotate.d \
    /etc/sysctl* \
    /etc/modprobe.d \
    /etc/modules \
    /etc/mdev.conf \
    /etc/acpi \
    /root \
    /etc/fstab \
  && chmod -R u=rwx "$DATA_DIR/" \
  && find /bin /etc /lib /sbin /usr -xdev -type l -exec test ! -e {} \; -delete

WORKDIR $DATA_DIR

USER "$APP_USER"
ENTRYPOINT ["ansible-playbook", "playbooks/deploy.yml", "-i", "inventories/lan.yml", "-u"]
CMD ["chris"]
