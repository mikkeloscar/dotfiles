#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

export EDITOR=nvim

alias vim='nvim'
alias vimdiff='nvim -d'

alias u='cd ..'
alias uu='cd ../..'
alias uuu='cd ../../..'

alias pc='sudo pacman'
alias pcc='pacman'
_completion_loader pacman
complete -o default -F _pacman pacman pc pcc
alias pacs='sudo pacman-optimize && sudo reflector --verbose -l 10 --sort rate --save /etc/pacman.d/mirrorlist'

# GOPATH
export GOPATH=$HOME/projects/go
export PATH=$PATH:$GOPATH/bin
