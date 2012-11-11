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

# The following lines were added by compinstall
zstyle :compinstall filename '/home/moscar/.zshrc'

autoload -Uz compinit && compinit
autoload -U colors && colors

alias ls='ls --color=auto'
# http://geoff.greer.fm/lscolors/
export LS_COLORS='ow=0;44:'

# Add pacman completion to pacman-color
compdef _pacman pacman-color=pacman
alias pc='sudo pacman-color'
alias pcc='pacman-color'

# Webserver
alias webserver="sudo systemctl start httpd.service mysqld.service"

# ATI
alias atitemp="aticonfig --odgt"
alias atifan="aticonfig --pplib-cmd 'get fanspeed 0'"

# ssh to diku
# cat ~/.ssh/id_rsa.pud | ssh mikkell@tyr.diku.dk 'cat >> .ssh/authorized_keys'
alias diku="ssh mikkell@tyr.diku.dk"
alias diku-browse="ssh -C2qTnN -D 8080 mikkell@tyr.diku.dk & firefox -P diku"

# cd up dir
alias u="cd .."
alias uu="cd ../.."
alias uuu="cd ../../.."

alias lacasa="cd ~/Dropbox/development/github/lacasa"
alias cddiku="cd ~/Dropbox/diku/2/4"

# less coloring
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;30m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

#editor
export EDITOR="vim"

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
PROMPT=$'${light_green}%n ${rst}%{$fg[red]%}➜ %{$fg[green]%}%m %{$fg[blue]%}$(prompt_git_info)
${light_cyan}%~ %{$fg[white]%}> %{$reset_color%}'

RPROMPT="[%{$fg[magenta]%}%?%{$reset_color%}]"



# Android SDK
export PATH=${PATH}:android-sdks/tools:android-sdks/platform-tools

# -------------- custom stuff ----------------------------------
#

# Good stuff from oh-my-zsh
#
# Color grep results
# Examples: http://rubyurl.com/ZXv
#
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='31'

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
# Push and pop directories on directory stack
alias pu='pushd'
alias po='popd'

# Basic directory operations
alias ...='cd ../..'
alias -- -='cd -'

# Super user
alias _='sudo'

#alias g='grep -in'

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
alias gl='git pull'
compdef _git gl=git-pull
alias gup='git fetch && git rebase'
compdef _git gup=git-fetch
alias gp='git push'
compdef _git gp=git-push
gdv() { git-diff -w "$@" | view - }
compdef _git gdv=git-diff
alias gc='git commit -v'
compdef _git gc=git-commit
alias gca='git commit -v -a'
compdef _git gca=git-commit
alias gco='git checkout'
compdef _git gco=git-checkout
alias gb='git branch'
compdef _git gb=git-branch
alias gba='git branch -a'
compdef _git gba=git-branch
alias gcount='git shortlog -sn'
compdef gcount=git
alias gcp='git cherry-pick'
compdef _git gcp=git-cherry-pick
alias glg='git log --stat --max-count=5'
compdef _git glg=git-log
alias glgg='git log --graph --max-count=5'
compdef _git glgg=git-log
alias gss='git status -s'
compdef _git gss=git-status
alias ga='git add'
compdef _git ga=git-add
alias gm='git merge'
compdef _git gm=git-merge

# Git and svn mix
alias git-svn-dcommit-push='git svn dcommit && git push github master:svntrunk'
compdef git-svn-dcommit-push=git

alias gsr='git svn rebase'
alias gsd='git svn dcommit'
#
# Will return the current branch name
# Usage example: git pull origin $(current_branch)
#
function current_branch() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo ${ref#refs/heads/}
}

# these aliases take advantage of the previous function
alias ggpull='git pull origin $(current_branch)'
compdef ggpull=git
alias ggpush='git push origin $(current_branch)'
compdef ggpush=git
alias ggpnp='git pull origin $(current_branch) && git push origin $(current_branch)'
compdef ggpnp=git

# sprunge
# Smart sprunge alias/script.
#
# Contributed and SLIGHTLY modded by Matt Parnell/ilikenwf <parwok -at- gmail>
# Created by the blogger at the URL below...I don't know where to find his/her name
# Original found at http://www.shellperson.net/sprunge-pastebin-script/

sprunge_usage() {
  cat << HERE
Usage:
  sprunge [files]
  sprunge < file
  piped_data | sprunge

Upload data and fetch URL from the pastebin http://sprunge.us.
HERE
}

if (( $+commands[python] )); then
  # use python to attempt to detect the syntax
  sprunge_syntax() {
#    echo "try:
#	from pygments.lexers import get_lexer_for_filename
#	print(get_lexer_for_filename('$1').aliases[0])
#except:
#	print('text')" | python
	  echo ${1##*.}
  }
else
  # if we happen to lack python, just report everything as text
  omz_log_msg "sprunge: syntax highlighting disabled since python isn't available"
  sprunge_syntax() { echo 'text' }
fi

sprunge() {
  local urls url file syntax

  urls=()

  if [[ $1 == '-h' || $1 == '--help' ]]; then
    # print usage information
    sprunge_usage
    return 0
  elif [[ ! -t 0 || $#argv -eq 0 ]]; then
    # read from stdin
    url=$(curl -s -F 'sprunge=<-' http://sprunge.us <& 0)
    urls=(${url//[[:space:]]})
    [[ -z $url ]] || echo "stdin\t$url" >> ~/.sprunge.log
  else
    # treat arguments as a list of files to upload
    for file in $@; do
      if [[ ! -f $file ]]; then
        echo "$file isn't a file" >&2
        continue
      fi

      syntax=$(sprunge_syntax $file)
      url=$(curl -s -F 'sprunge=<-' http://sprunge.us < $file)
      url=${url//[[:space:]]}
      [[ $syntax != text ]] && url=${url}?${syntax}

      [[ -z $url ]] || echo "$file\t$url" >> $OMZ/sprunge.log
      urls+=(${url})
    done
  fi

  # output each url on its own line
  for url in $urls
    echo $url

  # don't copy to clipboad if piped
  # [[ -t 1 ]] && sendtoclip $urls
}

# rvm
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# python virtualenvwrap
source /usr/bin/virtualenvwrapper.sh
