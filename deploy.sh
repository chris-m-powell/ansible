#!/usr/bin/env bash

podman unshare chown 1000:1000 -R ~/.ssh/ansible_id_rsa
podman pull ghcr.io/chris-m-powell/ansible-controller:latest
podman run -it -v ~/.ssh/ansible_id_rsa:/app/.ssh/ansible_id_rsa:ro ansible-controller:latest
podman unshare chown 0:0 ~/.ssh/ansible_id_rsa
