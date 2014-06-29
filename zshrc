# Fix for pyenv & tmux
# http://yowatari.hatenablog.com/entry/2013/12/19/223201
if [ -x /usr/libexec/path_helper ]; then
    if [ -z "$TMUX" ]; then
        eval `/usr/libexec/path_helper -s`
    fi
fi

############################################################
###  functions
############################################################
prepend_path () {
    export PATH=$1:$PATH
}

load_if_exists () {
    local file=$1
    if [ -f $file ]; then
        source $file
    fi
}

lw () {
    perl -pe 's/\&/\&amp;/g' |\
    perl -pe 's/</\&lt;/g' |\
    perl -pe 's/>/\&gt;/g' |\
    perl -pe 's/^([^:]+):(.+)$/<a href="$1">$1<\/a>:$2/' |\
    perl -pe 's/$/<br\/>/' |\
    EDITOR='vim' w3m -T text/html
}

# execute command or function only when using mac
if_mac () {
    if [[ $(uname) = "Darwin" ]] then
        "$@"
    fi
}

# execute command or function only when using linux
if_linux () {
    if [[ $(uname) = "Linux" ]] then
        "$@"
    fi
}

############################################################
###  .zshrc
############################################################

# 重複を取り除く
typeset -U PATH

# Created by newuser for 4.3.10
autoload -U compinit
compinit

export LANG=ja_JP.UTF-8

# Configuration for *nix commands
GREP_OPTIONS='--color=auto'


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
    if_linux ls --color=auto
    if_mac ls -G
}

# http://subtech.g.hatena.ne.jp/secondlife/20110222/1298354852
# これを設定すると glob (*) での履歴のインクリメンタル検索ができる
bindkey '^R' history-incremental-pattern-search-backward
bindkey '^S' history-incremental-pattern-search-forward


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
cdd() {
  emacsclient -e "(dired \"$PWD\")"
}

## Chdir to the ``default-directory'' of currently opened in Emacs buffer.
cde () {
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
edit() {
  emacsclient -e "(find-file \"$1\")"
}


load_if_exists ~/.zsh_private
load_if_exists ~/.zsh_aliases

# /usr/local/bin と $HOME/bin を /usr/bin より前にしたい
export PATH=$HOME/bin:/usr/local/bin:$PATH
