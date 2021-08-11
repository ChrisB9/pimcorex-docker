export LS_COLORS="${LS_COLORS}di=1;34:"
export EXA_COLORS="da=1;34:gm=1;34"
alias ls='exa'
alias ll='ls -alh --git --header --group'
export PATH=$PATH:~/.composer/vendor/bin:./bin:./vendor/bin:./node_modules/.bin:/usr/local/cargo/bin
source ~/.git-completion.bash
source ~/.git-prompt.sh
source ~/.completions.bash

export HOST_DISPLAY_NAME=$HOSTNAME

PS1='\033]2;'$(pwd)'\007\[\e[0;36m\][\[\e[1;31m\]\u\[\e[0;36m\]@\[\e[1;34m\]$HOST_DISPLAY_NAME\[\e[0;36m\]: \[\e[0m\]\w\[\e[0;36m\]]\[\e[0m\]\$\[\e[1;32m\]\s\[\e[0;33m\]$(__git_ps1)\[\e[0;36m\]> \[\e[0m\]\n$ '

eval `ssh-agent -s`
if [ -z "$SSH_AUTH_SOCK" ]; then
  ssh-add -t 604800 ~/.ssh/id_rsa
else
  ssh-add
fi

export EDITOR=vim

## this extracts pretty much any archive
function extract() {
  if [ -f $1 ]; then
    case $1 in
    *.tar.bz2) tar xvjf $1 ;;
    *.tar.gz) tar xvzf $1 ;;
    *.bz2) bunzip2 $1 ;;
    *.rar) unrar x $1 ;;
    *.gz) gunzip $1 ;;
    *.tar) tar xvf $1 ;;
    *.tbz2) tar xvjf $1 ;;
    *.tgz) tar xvzf $1 ;;
    *.zip) unzip $1 ;;
    *.Z) uncompress $1 ;;
    *.7z) 7z x $1 ;;
    *) echo "'$1' cannot be extracted via >extract<" ;;
    esac
  else
    echo "'$1' is not a valid file!"
  fi
}
