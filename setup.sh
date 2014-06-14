#!/bin/bash
cd $(dirname $0)
cp -f $(pwd)/tmux.conf ~/.tmux.conf
cp -f $(pwd)/zshrc ~/.zshrc
cp -f $(pwd)/zsh_aliases ~/.zsh_aliases
cp -f $(pwd)/ackrc ~/.ackrc
cp -f $(pwd)/vimrc ~/.vimrc
cp -f $(pwd)/sbtrc ~/.sbtrc
cp -f $(pwd)/gitconfig ~/.gitconfig

git config --global user.name "Toshiyuki Takahashi"
/bin/echo -n 'email (for gitconfig): ' && read email
git config --global user.email "$email"