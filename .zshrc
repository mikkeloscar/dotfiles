HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
unsetopt HIST_FIND_NO_DUPS
# setopt append_history share_history
setopt append_history no_inc_append_history no_share_history
bindkey -v

#-- Key bindings --#
#

source ~/.config/zsh/func/zsh-history-substring-search.zsh

zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward

# editing
# delete
if [[ -n $terminfo[kdch1] ]]; then
    bindkey          "$terminfo[kdch1]" delete-char
    # bindkey -M vicmd "$terminfo[kdch1]" vi-delete-char
fi
# insert
if [[ -n $terminfo[kich1] ]]; then
    bindkey          "$terminfo[kich1]" overwrite-mode
    # bindkey -M vicmd "$terminfo[kich1]" vi-insert
fi
# home
if [[ -n $terminfo[khome] ]]; then
    bindkey          "$terminfo[khome]" beginning-of-line
    # bindkey -M vicmd "$terminfo[khome]" vi-beginning-of-line
fi
# end
if [[ -n $terminfo[khome] ]]; then
    bindkey          "$terminfo[kend]"  end-of-line
    # bindkey -M vicmd "$terminfo[kend]"  vi-end-of-line
fi
# backspace (and <C-h>)
if [[ -n $terminfo[kbs] ]]; then
    bindkey          "$terminfo[kbs]"   backward-delete-char
    # bindkey -M vicmd "$terminfo[kbs]"   backward-char
fi

# Make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        printf '%s' "${terminfo[smkx]}"
    }
    function zle-line-finish () {
        printf '%s' "${terminfo[rmkx]}"
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi

autoload -Uz compinit && compinit
# autoload -Uz compinit && compinit
autoload -U colors && colors

alias ls='ls --color=auto'

export GREP_COLOR='31'

alias grep='grep --color=auto'

alias pc='sudo pacman'
alias pcc='pacman'
alias pacs='sudo pacman-optimize && sudo reflector --verbose -l 10 --sort rate --save /etc/pacman.d/mirrorlist'

# user nvim in place of vim
alias vim='nvim'
alias vimdiff='nvim -d'

# ssh proxy to diku
alias diku-proxy='ssh -C2qTnN -D 8080 mikkell@tyr.diku.dk & chromium --proxy-server="socks5://localhost:8080"'

alias ct-cu="sudo stty -F /dev/ttyUSB0 -crtscts && sudo cu -s 115200 -l /dev/ttyUSB0"

alias django="source /usr/bin/virtualenvwrapper.sh && workon django"

# cd up dir
alias u="cd .."
alias uu="cd ../.."
alias uuu="cd ../../.."

# static webserver
alias static="python -m http.server 3001"
alias calc='python -ic "from math import *; import cmath"'

# Paste services
alias ix="curl -sF 'f:1=<-' ix.io"
alias sprunge='curl -F "sprunge=<-" http://sprunge.us'
alias pb='curl -F c=@- https://ptpb.pw'

alias steam="LD_PRELOAD='/usr/lib32/libstdc++.so.6' steam"

# less coloring
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;30m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

terminfo() {
    ssh $1 mkdir -p .terminfo/x
    scp /usr/share/terminfo/x/xterm-termite $1:~/.terminfo/x/
}


# # ----- GIT STATUS SCRIPT -------
# Allow for functions in the prompt.
setopt PROMPT_SUBST

# Autoload zsh functions.
fpath=(~/.config/zsh/func $fpath)
autoload -U ~/.config/zsh/func/*(:t)

# Enable auto-execution of functions.
typeset -ga preexec_functions
typeset -ga precmd_functions
typeset -ga chpwd_functions

# Append git functions needed for prompt.
preexec_functions+='preexec_update_git_vars'
precmd_functions+='precmd_update_git_vars'
chpwd_functions+='chpwd_update_git_vars'

# Set the prompt.
light_green=$'%{\e[1;32m%}'
light_cyan=$'%{\e[1;36m%}'
rst=$'%{\e[0m%}'

# GIT_PROMPT_BRANCH_C="%{$fg[magenta]%}"
# GIT_PROMPT_COMMIT_C="%{$fg[magenta]%}"
# GIT_PROMPT_STATUS_C=""
# GIT_PROMPT_SUFFIX_C=""


# PROMPT=$'${light_green}%n${rst}%{$fg[red]%}@%{$fg[green]%}%m %{$fg[blue]%}$(prompt_git_info)
# ${light_cyan}%~ %{$fg[white]%}> %{$reset_color%}'
PROMPT=$'%{$fg_bold[red]%}%n%{$fg[cyan]%}@%{$fg[yellow]%}%m %{$reset_color%}%{$fg[blue]%}$(prompt_git_info)
%{$fg_bold[green]%}%~ %{$fg[white]%}$ %{$reset_color%}'

RPROMPT="[%{$fg[cyan]%}%?%{$reset_color%}]"


# -------------- custom stuff ----------------------------------
#
compdef _pdf atril

# Good stuff from oh-my-zsh
#
# fixme - the load process here seems a bit bizarre

unsetopt menu_complete   # do not autoselect the first completion entry
unsetopt flowcontrol
setopt auto_menu         # show completion menu on succesive tab press
setopt complete_in_word
setopt always_to_end

WORDCHARS=''

zmodload -i zsh/complist

zstyle ':completion:*' matcher-list 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' squeeze-slashes true

if [[ -n $LS_COLORS ]]; then
  zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
else
  zstyle ':completion:*' list-colors ''
fi

# should this be in keybindings?
bindkey -M menuselect '^o' accept-and-infer-next-history

#zstyle  ':completion:*:*:*:*:*' menu yes select
zstyle   ':completion:*:*:*:*:*' menu select
zstyle   ':completion:*:kill:*'  force-list always
# zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
# zstyle ':completion:*:*:*:*:processes' command "ps -u $(whoami) -o pid,user,comm -w -w"

# disable named-directories autocompletion
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*:cd:*' ignore-parents parent pwd
cdpath=(.)

# use /etc/hosts and known_hosts for hostname completion
[ -r ~/.ssh/known_hosts ] && _ssh_hosts=(${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[\|]*}%%\ *}%%,*}) || _ssh_hosts=()
[ -r /etc/hosts ] && : ${(A)_etc_hosts:=${(s: :)${(ps:\t:)${${(f)~~"$(</etc/hosts)"}%%\#*}##[:blank:]#[^[:blank:]]#}}} || _etc_hosts=()
hosts=(
  $_ssh_hosts[@]
  $_etc_hosts[@]
  $HOST
  localhost
)
zstyle ':completion:*:hosts' hosts $hosts

# General purpose aliases ---------------------------------------
# Show history
alias history='fc -l 1'

# List direcory contents
alias lsa='ls -lah'
alias l='ls -la'
alias ll='ls -l'
alias sl=ls # often screw this up

# git
# alias g='git'
# compdef g=git
alias git=hub
alias gst='git status'
compdef _git gst=git-status

# pkgfile
[ -r /usr/share/doc/pkgfile/command-not-found.zsh ] && . /usr/share/doc/pkgfile/command-not-found.zsh

# export CHROOT_STANDARD=/media/chroots/standard

# export linaro toolchain (gcc 4.9)
export PATH=/usr/local/gcc-linaro-arm-linux-gnueabihf-4.9-2014.05_linux/bin/:$PATH

# GOPATH
export GOPATH=$HOME/projects/go
export PATH=$PATH:$GOPATH/bin

gocover () {
    t="/tmp/go-cover.$$.tmp"
    go test -coverprofile=$t $@ && go tool cover -html=$t && unlink $t
}

# golang working dir
gowork() { cd $HOME/projects/go/src/github.com/mikkeloscar/$1; }
compctl -W $HOME/projects/go/src/github.com/mikkeloscar/ -/ gowork

# golang (gitlab) working dir
goworklab() { cd $HOME/projects/go/src/gitlab.com/mikkeloscar/$1; }
compctl -W $HOME/projects/go/src/gitlab.com/mikkeloscar/ -/ goworklab

# Get latest package sources for Arch linux repo packages
arch_src() {
    repo="git://projects.archlinux.org/svntogit/packages.git"

    git clone $repo --branch "packages/$1" --single-branch $1
}

# get rid of x11-ssh-askpass
unset SSH_ASKPASS

# Initialize new github repo
hubify() {
    user=$(git config --get github.user)
    token=$(cat ~/.github.token)
    curl -H "Authorization: token $token" https://api.github.com/user/repos -d "{\"name\":\"$1\"}"
    git remote add origin git@github.com:$user/$1.git
    git push -u origin master
}

# Initialize new gitlab repo (private)
labify() {
    user="mikkeloscar"
    token=$(cat ~/.gitlab.token)
    curl --data "name=$1" --header "PRIVATE-TOKEN: $token" https://gitlab.com/api/v3/projects
    git remote add origin git@gitlab.com:$user/$1.git
    git push -u origin master
}

# Initialize new bitbucket repo (private)
bitbucket() {
    user="mikkeloscar"
    curl -X POST -u $user -H "Content-Type: application/json" \
        https://api.bitbucket.org/2.0/repositories/$user/$1 \
        -d '{"scm": "git", "is_private": "true", "fork_policy": "no_public_forks"}'
    git remote add origin git@bitbucket.org:$user/$1.git
    git push -u origin --all
    git push -u origin --tags
}

# sourcing shitty scripts (only enable when used, makes startup 7x slower)
# rvm
# [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# python virtualenvwrap
# source /usr/bin/virtualenvwrapper.sh
