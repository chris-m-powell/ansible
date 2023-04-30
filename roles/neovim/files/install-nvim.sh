#!/bin/bash

SRC=github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz
DEST=~/Downloads/nvim-linux64.tar.gz

curl -sfLo "${DEST}" --create-dirs \
    "https://${SRC}" \
  && tar xzvf "${DEST}" -C ~/Downloads \
  && rm -f "${DEST}" \
  && echo "PATH=$PATH:~/Downloads/nvim-linux64/bin" >> ~/.zshrc \
  && curl -sfLo "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim" --create-dirs \
    "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" \
  && curl -sfLo "${HOME}/.config/nvim/init.lua" --create-dirs \
    "https://raw.githubusercontent.com/chris-m-powell/ansible/master/roles/neovim/files/init.lua" \
  && "${HOME}/Downloads/nvim-linux64/bin/nvim" -c PlugInstall -c qa
