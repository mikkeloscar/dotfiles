HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
unsetopt HIST_FIND_NO_DUPS
bindkey -v

#-- Key bindings --#

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

# The following lines were added by compinstall
zstyle :compinstall filename "/home/$HOME/.zshrc"

autoload -Uz compinit && compinit
autoload -U colors && colors

alias ls='ls --color=auto'
# http://geoff.greer.fm/lscolors/
export LS_COLORS='ow=0;44:ln=36;40:'

export GREP_OPTIONS='--color=auto'
export GREP_COLOR='31'

alias pc='sudo pacman'
alias pcc='pacman'

# Webserver
alias webserver="sudo systemctl start httpd.service mysqld.service"

# ATI
alias atitemp="aticonfig --odgt"
alias atifan="aticonfig --pplib-cmd 'get fanspeed 0'"

# ssh to diku
alias diku="ssh mikkell@tyr.diku.dk"
alias diku-proxy='ssh -C2qTnN -D 8080 mikkell@tyr.diku.dk & chromium --proxy-server="socks5://localhost:8080"'

alias ct-cu="sudo stty -F /dev/ttyUSB0 -crtscts && sudo cu -s 115200 -l /dev/ttyUSB0"

# cd up dir
alias u="cd .."
alias uu="cd ../.."
alias uuu="cd ../../.."

# Paste services
alias ix="curl -sF 'f:1=<-' ix.io"
alias sprunge='curl -F "sprunge=<-" http://sprunge.us'

# less coloring
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;30m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# # ----- GIT STATUS SCRIPT -------
# Allow for functions in the prompt.
setopt PROMPT_SUBST

# Autoload zsh functions.
fpath=(~/.zsh/func $fpath)
autoload -U ~/.zsh/func/*(:t)

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
PROMPT=$'%{$fg[magenta]%}%n%{$fg[cyan]%}@%{$fg[yellow]%}%m %{$fg[blue]%}$(prompt_git_info)
%{$fg[green]%}%~ %{$fg[white]%}$ %{$reset_color%}'

RPROMPT="[%{$fg[cyan]%}%?%{$reset_color%}]"


# -------------- custom stuff ----------------------------------
#

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

# Use caching so that commands like apt and dpkg complete are useable
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path $OMZ/cache/

# Fuzzy matching of completions for when you mistype them
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3))numeric)'

# Ignore completion functions
zstyle ':completion:*:functions' ignored-patterns '_*'

# Don't complete uninteresting users
zstyle ':completion:*:*:*:users' ignored-patterns \
        adm amanda apache avahi beaglidx bin cacti canna clamav daemon \
        dbus distcache dovecot fax ftp games gdm gkrellmd gopher \
        hacluster haldaemon halt hsqldb ident junkbust ldap lp mail \
        mailman mailnull mldonkey mysql nagios \
        named netdump news nfsnobody nobody nscd ntp nut nx openvpn \
        operator pcap postfix postgres privoxy pulse pvm quagga radvd \
        rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs

# ... unless we really want to.
zstyle '*' single-ignored show

if [ "x$COMPLETION_WAITING_DOTS" = "xtrue" ]; then
  expand-or-complete-with-dots() {
    echo -n "\e[31m......\e[0m"
    zle expand-or-complete
    zle redisplay
  }
  zle -N expand-or-complete-with-dots
  bindkey "^I" expand-or-complete-with-dots
fi

# General purpose aliases ---------------------------------------
# Basic directory operations
alias ...='cd ../..'

# Show history
alias history='fc -l 1'

# List direcory contents
alias lsa='ls -lah'
alias l='ls -la'
alias ll='ls -l'
alias sl=ls # often screw this up

# git
alias g='git'
compdef g=git
alias gst='git status'
compdef _git gst=git-status

# rvm
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# pkgfile
[ -r /usr/share/doc/pkgfile/command-not-found.zsh ] && . /usr/share/doc/pkgfile/command-not-found.zsh

# python virtualenvwrap
source /usr/bin/virtualenvwrapper.sh

# Android SDK
export PATH=${PATH}:android-sdks/tools:android-sdks/platform-tools

export CHROOT_STANDARD=/media/chroots/standard

# # zsh-autosuggestions
# source ~/.zsh-autosuggestions/autosuggestions.zsh
#
# zle-line-init() {
#     zle autosuggest-start
# }
# zle -N zle-line-init
# export linaro toolchain (gcc 4.9)
export PATH=/usr/local/gcc-linaro-arm-linux-gnueabihf-4.9-2014.05_linux/bin/:$PATH

. <(npm completion)

# GOPATH
export GOPATH=$HOME/projects/go
export PATH=$PATH:$GOPATH/bin
