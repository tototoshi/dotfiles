############################################################
###  functions
############################################################
command_exists () {
    which "$1" &> /dev/null ;
}

prepend_path () {
    export PATH=$1:$PATH
}

loop-compile () {
    mvn compile
    while inotifywait -r -e modify -e create -e delete src/main --exclude '\#|\.jspx?|\.js'
    do
        mvn compile
    done
}

function lw {
    sed -e 's/</\&lt;/g' |\
    sed -e 's/>/\&gt;/g' |\
    sed -e 's/\&/\&amp;/g' |\
    sed -e 's/[^:]*/<a href="\0">\0<\/a>/' |\
    sed -e 's/$/<br\/>/' |\
    EDITOR='vim' w3m -T text/html
}

function find-grep {
    find . | grep -v '\.svn\|\.git' | xargs grep $1
}

############################################################
###  .zshrc
############################################################

# Created by newuser for 4.3.10
autoload -U compinit
compinit

export LANG=ja_JP.UTF-8

OSNAME=$(uname)
if echo $OSNAME | grep -i linux > /dev/null 2>&1
then
    alias ls='ls --color=auto'
elif echo $OSNAME | grep -i darwin > /dev/null 2>&1
then
    alias ls='ls -G'
fi

# Configuration for *nix commands
GREP_OPTIONS='--color=auto'

alias la='ls -a'
alias ll='ls -l'
alias vi='vim'

#プロンプトの設定
#local LEFTC=$'%{\e[38;5;30m%}'
#local RIGHTC=$'%{\e[38;5;88m%}'
local LEFTC=""
local RIGHTC=""
local DEFAULTC=$'%{\e[m%}'
local CURRENT_DIR=$'%/%%'
export PROMPT=$LEFTC"$USER@$CURRENT_DIR "$DEFAULTC
export RPROMPT=$RIGHTC"[%~]"$DEFAULTC
#PROMPT="%/%% "
#PROMPT2="%_%% "
SPROMPT="%r is correct? [n,y,a,e]: "

#コマンド履歴機能

HISTFILE=~/.zsh_history
HISTSIZE=100000000
SAVEHIST=100000000
setopt hist_ignore_dups     # ignore duplication command history list
setopt share_history        # share command history data

# Emacsライクキーバインド設定
bindkey -e

# 履歴検索機能のショートカット設定
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# auto_cdを設定
setopt auto_cd

# 移動したディレクトリを記録しておくと、いざというときに便利
setopt auto_pushd

# 入力したコマンド名が間違っている場合には修正
setopt correct

# 補完のときプロンプトの位置を変えない
setopt always_last_prompt

# tabキーの節約
setopt menu_complete

# 補完候補の表示を親切に ls -F
setopt list_types

# 補完候補を詰めて表示する設定
setopt list_packed

# 色つきの補完
zstyle ':completion:*' list-colors di=34 fi=0

# 補完候補をカーソルで選択できる
#zstyle ':completion:*:default' menu select=1
zstyle ':completion:*:default' menu select true

# 補完候補表示時などにピッピとビープ音をならないように設定
setopt nolistbeep

# 先方予測機能を有効に設定
#autoload predict-on
#predict-on

# stop backword-kill-word on directory delimiter
autoload -U select-word-style
select-word-style bash

################################
### Functions ###
################################

# Extract files from any archive
# Usage: ex

function ex ()
{
if [ -f "$1" ] ; then
case "$1" in
*.tar) tar xvf $1 ;;
*.tar.bz2 | *.tbz2 ) tar xjvf $1 ;;
*.tar.gz | *.tgz ) tar xzvf $1 ;;
*.bz2) bunzip2 $1 ;;
*.rar) unrar x $1 ;;
*.gz) gunzip $1 ;;
*.zip) unzip $1 ;;
*.Z) uncompress $1 ;;
*.7z) 7z x $1 ;;
*.xz) tar xJvf $1 ;;
*) echo ""${1}" cannot be extracted via extract()" ;;
esac
else
echo ""${1}" is not a valid file"
fi
}

###################################################
###  get a prompt which indicates Git-branch
###################################################
setopt prompt_subst
autoload -Uz vcs_info
zstyle ':vcs_info:*' actionformats \
    '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats       \
    '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{5}]%f '
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'

zstyle ':vcs_info:*' enable git cvs svn

# or use pre_cmd, see man zshcontrib
vcs_info_wrapper() {
  vcs_info
  if [ -n "$vcs_info_msg_0_" ]; then
    echo "%{$fg[grey]%}${vcs_info_msg_0_}%{$reset_color%}$del"
  fi
}
RPROMPT=$'$(vcs_info_wrapper)'

# chpwd
function chpwd() {
    ls
}

# http://subtech.g.hatena.ne.jp/secondlife/20110222/1298354852
# これを設定すると glob (*) での履歴のインクリメンタル検索ができる
bindkey '^R' history-incremental-pattern-search-backward
bindkey '^S' history-incremental-pattern-search-forward


############################################################
###  Start xbindkeys if it is found.
############################################################
if command_exists xbindkeys; then
    if ! ps x | grep xbindkeys | grep -v grep > /dev/null 2>&1 ; then
        xbindkeys
    fi
fi

############################################################
###  set DJANGO_SETTINGS_MODULE
############################################################
function setdsm() {
    export PYTHONPATH=$PYTHONPATH:$PWD/..
    export PYTHONPATH=$PYTHONPATH:$PWD
    if [ -z "$1" ]; then
        x=${PWD/\/[^\/]*\/}
        export DJANGO_SETTINGS_MODULE=$x.settings
    else
        export DJANGO_SETTINGS_MODULE=$1
    fi

    echo "DJANGO_SETTINGS_MODULE set to $DJANGO_SETTINGS_MODULE"
}

############################################################
###  read python startup file
############################################################
if [ -f ~/.pythonstartup ]; then
    export PYTHONSTARTUP=~/.pythonstartup
fi

############################################################
###  for emacsclient
############################################################
## http://masutaka.net/chalow/2011-09-28-1.html
## Invoke the ``dired'' of current working directory in Emacs buffer.
function cdd() {
  emacsclient -e "(dired \"$PWD\")"
}

## Chdir to the ``default-directory'' of currently opened in Emacs buffer.
function cde () {
    EMACS_CWD=`emacsclient -e "
     (expand-file-name
      (with-current-buffer
          (nth 1
               (assoc 'buffer-list
                      (nth 1 (nth 1 (current-frame-configuration)))))
        default-directory))" | sed 's/^"\(.*\)"$/\1/'`

    echo "chdir to $EMACS_CWD"
    cd "$EMACS_CWD"
}

## Open a file in emacs using emacsclient
function edit() {
  emacsclient -e "(find-file \"$1\")"
}

##########################################################
## alias for javac
## http://www.eva.ie.u-ryukyu.ac.jp/~koji/ie/Tips/javac.html
##########################################################
alias javac='LC_ALL=ja_JP.UTF-8 javac -J-Dfile.encoding=utf-8'
alias java='java -Dfile.encoding=UTF-8'


if [ -f ~/.zsh_private ]; then
    source ~/.zsh_private
fi

if [ -f ~/.zsh_aliases ]; then
   source ~/.zsh_aliases
fi


##########################################################
## rvm
##########################################################
if [ -f ~/.profile ]
then
    source ~/.profile
fi
