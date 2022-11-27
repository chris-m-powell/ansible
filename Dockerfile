FROM ubuntu

RUN apt update; \
    apt upgrade; \
    apt install -y git python3-pip sshpass; \
    apt clean; \
    python3.10 -m pip install ansible; \
    mkdir -p /git; \
    git clone https://github.com/chris-m-powell/ansible.git /git/ansible \
      --single-branch \
      --branch master \
      --depth 1; \
