#Wulf Sőlter's accumulated bash hacks 2022-07-20
# .bashrc / .bash_profile

##### Define options
export EDITOR="vim"
export GREP_COLORS="mt=1;33"
export VISUAL=$EDITOR

# Set locale
export LC_ALL=en_NZ.UTF-8
export LANG=en_NZ.UTF-8
export LC_MESSAGES="C"

# Node.js
export NODE_PATH="/usr/local/lib/node:/usr/local/share/npm/lib/node_modules:/usr/local/opt/ruby/bin"
export NODE_PATH=$NODE_PATH:/usr/local/lib/node_modules
export PATH=$PATH:/usr/local/bin:/usr/local/share/npm/bin:/usr/local/sbin

# WW HelperScript
export PATH=$PATH:~/code/wherewolf/helperscripts
export WW_CODE_DIR=/home/wulf/code/wherewolf

# Clone Row
export PATH="$PATH:$HOME/code/clone-row";

if [ "$HOSTNAME" = thinkpad ]; then
    alias logstalgiaWherewolf='ssh wherewolf-WORKER0001 "tail -f /var/log/nginx/wherewolf.log" | logstalgia --sync --full-hostnames --update-rate 1 -g "API,URI=.*,100"'
    # alias logstalgiaWherewolf='ssh wherewolf-WORKER0001 "tail -f /var/log/nginx/wherewolf.log" | grep -v "uptimeCheck" | logstalgia --sync --full-hostnames --update-rate 1 -g "API,URI=.*,100"'
fi

# Bash options, some of these are already set by default, but to be safe I've defined them here again.
shopt -s cdspell                    # Try to correct spelling errors in the cd command.
# shopt -s checkjobs                # Warn if there are stopped jobs when exiting - May not work on all versions of Bash.
shopt -s checkwinsize               # Check window size after each command and update as nescessary.
shopt -s cmdhist                    # Try to save all multi-line commands to one history entry.
# shopt -s dirspell                 # Try to correct spelling errors for glob matching - May not work on all versions.
shopt -s dotglob                    # include files beginning with a dot in pathname expansion (pressing TAB).
shopt -s expand_aliases             # Self explanatory.
shopt -s extglob                    # Enable extended pattern matching.
shopt -s extquote                   # Command line quoting stuff.
shopt -s force_fignore              # Force ignore for files if FIGNORE is set.
shopt -s interactive_comments       # Allowing commenting, in an interactive shell.
shopt -s login_shell                # Bash is the login shell, obviously.
shopt -s nocaseglob                 # Case insensitive pathname expansion (TAB) some may want to turn this off.
shopt -s progcomp                   # Programmable completion stuff.
shopt -s promptvars                 # Expansion stuff for prompt strings.
shopt -s sourcepath                 # The source command will use the PATH variable.

##### History management section
HISTFILESIZE=100000000
HISTSIZE=100000000
# Avoid duplicates
HISTCONTROL=ignoredups:erasedups
# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend
shopt -s histverify
set -b

# Completion
complete -cf sudo
complete -C aws_completer aws
shopt -s no_empty_cmd_completion    # Self explanatory.
shopt -s hostcomplete               # Complete hostnames (TAB).
set completion-ignore-case on       # turn off case sensitivity

complete -W "$(echo `cat ~/.bash_history | egrep '^ssh ' | sort | uniq | sed 's/^ssh //'`;)" ssh    # SSH Hostname autocomplete
complete -W "$(echo `cat ~/.bash_history | egrep '^mosh ' | sort | uniq | sed 's/^mosh //'`;)" mosh

# stop the noisey bell!!
# bind 'set bell-style none'

# make me slutty - all my friends can play with my bits
umask 002

##### Aliases and commands
# modified commands

alias ..='cd ..'
alias df='df -h'
alias diff='colordiff'              # requires colordiff package
alias du='du -c -h'
alias grep='grep --color=auto'
alias mkdir='mkdir -p -v'
alias ping='ping -c 5'
alias visudo='sudo -E visudo'
alias vi='vim'

# Stop doing dumb things
alias more='less'
alias nano='vim'

# Make VSCode open a file in parent workspace
code() {
  # Get root of current git directory
  # https://unix.stackexchange.com/a/6470
  # Currently breaks if running "code ../../some/path" from a different PWD
  # What I really want is to scan parents of the target to see if any of the parents have a "vscode.code-workspace" file
  CURRENT_WORKSPACE_DIR=$(git rev-parse --show-toplevel 2>/dev/null)

  # wrap the whole shit in double quotes and then more escaped double quotes around that
  VSCODE_PATH=\""/snap/bin/code"\"

  # If CURRENT_WORKSPACE_DIR returned a path and that path has a vscode.code-workspace file
  if ! [[ $CURRENT_WORKSPACE_DIR == *"fatal: not a git repository" ]] && [ -f "${CURRENT_WORKSPACE_DIR}/vscode.code-workspace" ]; then
    eval $VSCODE_PATH "${CURRENT_WORKSPACE_DIR}/vscode.code-workspace" \""$@"\"

  # Not in a repo with a vscode.code-workspace file, or file does not exist - run plain VSCode
  else
    eval $VSCODE_PATH \""$@"\"

  fi
}

# new commands
# count inodes: find . -xdev -type f | cut -d "/" -f 2 | sort | uniq -c | sort –n
alias aptiupdate='sudo apt update && sudo apt upgrade'
alias dockerstopallremoveall='docker stop $(docker ps -a -q) || true && docker rm $(docker ps -a -q) || true'
alias du1='du --max-depth=1'
alias hist='history | grep $1'      # requires an argument
alias openports='netstat --all --numeric --programs --inet'
alias whoshitting="sudo netstat -anp | grep 'tcp\|upd' | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -n"
alias apacheloguseragents="tail -n 10 -F /var/log/apache2/access.log | awk -F\" '{print $6}'"
alias tmx='tmux a || tmux new'
alias mw1='mosh worker1'
alias mw2='mosh worker2'
alias mw3='mosh worker3'
alias mw4='mosh worker4'
alias mw5='mosh worker5'
alias mw6='mosh worker6'

# Git shortcuts
gitcheckout() {
    git checkout $1
}
alias gc=gitcheckout
alias gitrds="git reset -- *.DS_Store"
alias gits="git status"
alias gp="git pull --all"
alias gpom="git pull origin master"
alias gsppsp="touch stashtempfile.txt && git stash > /dev/null && git pull && git push && git stash pop > /dev/null && rm stashtempfile.txt && git status"
alias gd="git difftool"
alias gitbehind="git rev-list --left-right --count origin/master...origin/`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/' | sed 's/[() ]//g'`"

# ls
#alias ls='ls -hF --color=always'
alias lr='ls -R'                    # recursive ls
alias ll='ls -l'
alias la='ll -A'
alias lx='ll -BX'                   # sort by extension
alias lz='ll -rS'                   # sort by size
alias lt='ll -rt'                   # sort by date
alias lm='la | more'

# privileged access
if [ $UID -ne 0 ]; then
    alias sudo='sudo '
    alias scat='sudo cat'
    alias svim='sudo vim'
    alias root='sudo su'
    alias reboot='sudo reboot'
    alias halt='sudo halt'
    alias netcfg='sudo netcfg2'
fi

### Bash completion for git if available
if [ -f ~/code/wherewolf/helperscripts/git-completion.bash ]; then
  . ~/code/wherewolf/helperscripts/git-completion.bash
fi

### Get docker shit for Wherewolf
if [ -f ~/code/wherewolf/helperscripts/bash/core ]; then
  . ~/code/wherewolf/helperscripts/bash/core
fi

## get current git branch
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# function to run something multiple times
# usage:
# $ run_times 10 cat foo.txt
run_times() {(
    set -e # fail early
    number=$1
    shift
    for i in `seq $number`; do
      $@
    done
)}

function prompt_command {
    # Run this function every time a prompt is displayed.
    # Make history happen, regardless of windows/panes/tabs/etc
    history -n
    history -a
    history -c
    history -r

    # Set term title to user@hostname/pwd
    echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"

    #Give a new line - the -e flag is for echo to enable interpretaion of backslash escapes
    #echo -e "\n"
    echo ''

    ### Check if restart is required
    # Debian/Ubuntu
    if [ -f /var/run/reboot-required ]; then
        echo -e '\e[1;7m *** RESTART REQUIRED *** \e[0m due to:'
        cat /var/run/reboot-required.pkgs
    fi
    # Arch
    NEXTLINE=0
    FIND=""
    for I in `file /boot/vmlinuz*`; do
      if [ ${NEXTLINE} -eq 1 ]; then
        FIND="${I}"
        NEXTLINE=0
       else
        if [ "${I}" = "version" ]; then NEXTLINE=1; fi
      fi
    done
    if [ ! "${FIND}" = "" ]; then
      CURRENT_KERNEL=`uname -r`
      if [ ! "${CURRENT_KERNEL}" = "${FIND}" ]; then
        echo -e '\e[1;7m *** RESTART REQUIRED *** \e[0m'
      fi
    fi

}

# Bind up/down arrows history search.
case "$TERM" in *xterm*|rxvt*|Eterm|aterm|kterm|gnome*|interix|screen|screen-256color)
    # bind '"\e[A": history-search-backward' >/dev/null 2>/dev/null
    # bind '"\e[B": history-search-forward' >/dev/null 2>/dev/null
    bind '"\e[A": history-search-backward'
    bind '"\e[B": history-search-forward'

    ;;
*)
    ;;
esac

# Set tmux/screen window titles
case "$TERM" in
    screen)
      export PROMPT_COMMAND='echo -ne "\033]2;${USER}@${HOSTNAME}: ${PWD}\007\033k${USER}@${HOSTNAME}\033\\";  prompt_command'
      ;;
*)
    export PROMPT_COMMAND='prompt_command;'
    ;;
esac

# Prompt, Looks like:
# ┌─[username@host]-[time date]-[directory]
# └─[$]->

PS1='\[\e[0;36m\]┌─[\[\e[0;32m\]\u\[\e[0;34m\]@\[\e[0;31m\]\h\[\e[0m\e[0;36m\]]-[\[\e[0m\]`date +%Y-%m-%d\ %R` - `date +%s`\[\e[0;36m\]]-[\[\e[33;1m\]\w\[\e[0;36m\]]\[\e[0;32m\]`parse_git_branch`\n\[\e[0;36m\]└─[\[\e[35m\]\$\[\e[0;36m\]]->\[\e[0m\] '
