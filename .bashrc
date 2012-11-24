#!/bin/bash
# Wulf Solter's accumulated bash hacks 20121124
# .bashrc



##### Define options
export EDITOR="vim"
export GREP_COLOR="1;33"
export VISUAL=$EDITOR
export PAGER="/bin/sh -c \"unset PAGER;col -b -x | \
    vim -R -c 'set ft=man nomod nolist' -c 'map q :q<CR>' \
    -c 'map <SPACE> <C-D>' -c 'map b <C-U>' \
    -c 'nmap K :Man <C-R>=expand(\\\"<cword>\\\")<CR><CR>' -\""
PATH=$PATH:~/code/scripts
export PATH


# Bash options, some of these are already set by default, but to be safe I've defined them here again.
shopt -s cdspell                 	# Try to correct spelling errors in the cd command.
shopt -s checkjobs               	# Warn if there are stopped jobs when exiting - May not work on all versions of Bash.
shopt -s checkwinsize            	# Check window size after each command and update as nescessary.
shopt -s cmdhist                	# Try to save all multi-line commands to one history entry.
shopt -s dirspell               	# Try to correct spelling errors for glob matching - May not work on all versions.
shopt -s dotglob                	# include files beginning with a dot in pathname expansion (pressing TAB).
shopt -s expand_aliases          	# Self explanatory.
shopt -s extglob                 	# Enable extended pattern matching.
shopt -s extquote                	# Command line quoting stuff.
shopt -s force_fignore           	# Force ignore for files if FIGNORE is set.
shopt -s hostcomplete            	# Complete hostnames (TAB).
shopt -s interactive_comments    	# Allowing commenting, in an interactive shell.
shopt -s login_shell             	# Bash is the login shell, obviously.
shopt -s no_empty_cmd_completion 	# Self explanatory.
shopt -s nocaseglob              	# Case insensitive pathname expansion (TAB) some may want to turn this off.
shopt -s progcomp                	# Programmable completion stuff.
shopt -s promptvars              	# Expansion stuff for prompt strings.
shopt -s sourcepath              	# The source command will use the PATH variable.


##### History management section
# Don't laugh, it actually works
HISTFILESIZE=100000000
HISTSIZE=100000

# autocompletion
complete -cf sudo
# SSH Hostname tab autocomplete from history
complete -W "$(echo `cat ~/.bash_history | egrep '^ssh ' | sort | uniq | sed 's/^ssh //'`;)" ssh

# history management
shopt -s histappend
shopt -s histverify
set -b

# stop the noisey bell!!
set bell-style none

# make me slutty - all my friends can play with my bits
umask 002

# History across sessions
PROMPT_COMMAND="history -n; history -a"

##### Aliases and commands
# modified commands
alias diff='colordiff'              # requires colordiff package
alias grep='grep --color=auto'
alias more='less'
alias df='df -h'
alias du='du -c -h'
alias mkdir='mkdir -p -v'
alias nano='nano -w'
alias ping='ping -c 5'
alias ..='cd ..'
alias grep='grep --color=auto'
alias vi='vim'
alias nano='vim'
alias visudo='sudo -E visudo'

# new commands
# count inodes: find . -xdev -type f | cut -d "/" -f 2 | sort | uniq -c | sort –n
alias srcbashrc='source ~/.bashrc'
alias aptiupdate='sudo aptitude update && sudo aptitude safe-upgrade'
alias fact="elinks -dump randomfunfacts.com | sed -n '/^│ /p' | tr -d \│"
alias da='date "+%A, %B %d, %Y [%T]"'
alias du1='du --max-depth=1'
alias hist='history | grep $1'      # requires an argument
alias openports='netstat --all --numeric --programs --inet'
alias whoshitting="sudo netstat -anp | grep 'tcp\|upd' | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -n"
alias pg='ps -Af | grep $1'         # requires an argument

alias gitrds="git reset -- *.DS_Store"
alias gits="git status"
alias ginit="git init && git add . && git commit -m 'Initial commit'"
alias gitp="git pull"

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
    alias update='sudo pacman -Su'
    alias netcfg='sudo netcfg2'
fi

# Make myself slutty for social environs
umask 002

##### Make myself at home...
function getsetup {
    mv ~/.bashrc ~/code/temp
    mv ~/.vimrc ~/code/temp
    mv ~/.gitconfig ~/code/temp
    mv ~/.inputrc ~/code/temp
    rm -fv {~/.bashrc, ~/.vimrc, ~/.gitconfig, ~/.inputrc} 
    ln -s ~/code/dotfiles/.bashrc ~ ;
    ln -s ~/code/dotfiles/.vimrc ~ ;
    ln -s ~/code/dotfiles/.gitconfig ~ ;
    ln -s ~/code/dotfiles/.inputrc ~ ;
}

#### Gimme some weather
current_weather(){

  local API_KEY='760eb0350915a62d'

  php -r '$json = json_decode(file_get_contents("http://api.wunderground.com/api/'${API_KEY}'/geolookup/q/autoip.json")); $zip = $json->location->zip; $json = json_decode(file_get_contents("http://api.wunderground.com/api/'${API_KEY}'/conditions/forecast/q/$zip.json")); $w = $json->current_observation; $location = $w->display_location->full; $f = $json->forecast->txt_forecast; echo "Weather for $location: " . PHP_EOL; echo "----------------------------" . PHP_EOL; echo "Current temperature: {$w->temp_f}F ({$w->temp_c}C)" . PHP_EOL . PHP_EOL; foreach($f->forecastday as $day){ echo "{$day->title}: {$day->fcttext}". PHP_EOL . PHP_EOL; }'

}

# Turn on colours.
#case "$TERM" in
#    xterm-color)
#    color_prompt=yes;;
#esac

function prompt_command {
    # Run this function every time a prompt is displayed. 
    # Set GUI terminal title
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
	# Make history happen
    history -n
    history -a
}

# Set GUI terminal titles, self explanatory.
case "$TERM" in *xterm*|rxvt*|Eterm|aterm|kterm|gnome*|interix)
	bind '"\e[A": history-search-backward' >/dev/null 2>/dev/null
	bind '"\e[B": history-search-forward' >/dev/null 2>/dev/null
    color_prompt=yes
	PROMPT_COMMAND=prompt_command
    ;;
*)
    ;;
esac

# Set tmux/screen window titles
case "$TERM" in
    screen)
        export PROMPT_COMMAND='echo -ne "\033]2;${USER}@${HOSTNAME}: ${PWD}\007\033k${USER}@${HOSTNAME}\033\\"'
        ;;
esac

# Prompt, Looks like: 
# ┌─[username@host]-[time date]-[directory]
# └─[$]-> 

PS1='\n\[\e[0;36m\]┌─[\[\e[0;32m\]\u\[\e[0;34m\]@\[\e[0;31m\]\h\[\e[0m\e[0;36m\]]-[\[\e[0m\]`date +%Y%m%d\ %R`\[\e[0;36m\]]-[\[\e[33;1m\]\w\[\e[0;36m\]]\n\[\e[0;36m\]└─[\[\e[35m\]\$\[\e[0;36m\]]->\[\e[0m\] '

#eof
