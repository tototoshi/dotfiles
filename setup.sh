#!/bin/bash
cd $(dirname $0)
cp -f $(pwd)/tmux.conf ~/.tmux.conf
cp -f $(pwd)/zshrc ~/.zshrc
cp -f $(pwd)/zsh_aliases ~/.zsh_aliases
cp -f $(pwd)/ackrc ~/.ackrc
cp -f $(pwd)/vimrc ~/.vimrc
cp -f $(pwd)/sbtrc ~/.sbtrc
cp -f $(pwd)/gitconfig ~/.gitconfig
cp -f $(pwd)/gitignore ~/.gitignore
cp -f $(pwd)/gemrc ~/.gemrc
mkdir -p ~/.emacs.d
cp -f $(pwd)/.emacs.d/init.el ~/.emacs.d/init.el

/bin/echo -n 'username (for gitconfig): ' && read username
git config --global user.name "$username"
/bin/echo -n 'email (for gitconfig): ' && read email
git config --global user.email "$email"
