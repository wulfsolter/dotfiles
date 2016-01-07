#Wulf Sőlter's accumulated bash hacks 2016-01-07 14:35
# .bashrc



##### Define options
#
export EDITOR="vim"
export GREP_COLOR="1;33"
export VISUAL=$EDITOR

# Node.js
export NODE_PATH="/usr/local/lib/node:/usr/local/share/npm/lib/node_modules:/usr/local/opt/ruby/bin"
export NODE_PATH=$NODE_PATH:/usr/local/lib/node_modules
export PATH=$PATH:/usr/local/bin:/usr/local/share/npm/bin:/usr/local/sbin

# WW HelperScript
export PATH=$PATH:~/Code/helperscripts

# CloneRow.py
export PATH=$PATH:~/Code/mysql-clone-row

# Mongo
export MONGO_PATH=/usr/local/mongodb
export PATH=$PATH:$MONGO_PATH/bin

if [ "$HOSTNAME" = Wulfs-MBP ]; then
    # Python 2.7
    export PYTHONPATH=/usr/local/lib/python2.7/site-packages/

    # Android SDK
    # export PATH="/Users/wulfsolter/SoftwareLibs/adt-bundle/sdk/platform-tools":$PATH
    export ANDROID_HOME=/Applications/ADT/sdk
    export PATH=$PATH:$ANDROID_HOME/bin

    # Perl5 on Homebrew
    export PERL_LOCAL_LIB_ROOT="/home/wulf/perl5";
    export PERL_MB_OPT="--install_base /home/wulf/perl5";
    export PERL_MM_OPT="INSTALL_BASE=/home/wulf/perl5";
    export PERL5LIB="/home/wulf/perl5/lib/perl5/i686-linux-thread-multi:/home/wulf/perl5/lib/perl5";
    export PATH="/home/wulf/perl5/bin:$PATH";

    export PKG_CONFIG_PATH="/usr/local/opt/zlib";

    # Ruby Gems
    # export PATH=/usr/local/Cellar/ruby/2.0.0-p353/lib/ruby/gems/2.0.0:/Users/wulfsolter/.gem/ruby/2.0.0:/usr/local/Cellar/ruby/2.0.0-p353/bin:$PATH
    # export PATH=/usr/local/lib/ruby/gems/2.0.0/gems:$PATH
    # export PATH=/usr/local/Cellar/ruby/2.1.0/lib/ruby/gems/2.1.0:$PATH
    export PATH=$(brew --prefix ruby)/bin:$PATH

    # AWS EC2 Tools
    # export JAVA_HOME="$(/usr/libexec/java_home)"
    # export AWS_AUTO_SCALING_HOME="/usr/local/Cellar/auto-scaling/1.0.61.4/libexec"
    # export AWS_CLOUDFORMATION_HOME="/usr/local/Cellar/aws-cfn-tools/1.0.12/libexec"
    # export EC2_AMITOOL_HOME="/usr/local/Cellar/ec2-ami-tools/1.4.0.9/libexec"
    # export EC2_CERT="$(/bin/ls "$HOME"/.ec2/cert-*.pem | /usr/bin/head -1)"
    # export EC2_HOME="/usr/local/Library/LinkedKegs/ec2-api-tools/jars"
    # export EC2_PRIVATE_KEY="$(/bin/ls "$HOME"/.ec2/pk-*.pem | /usr/bin/head -1)"

    # Google Chrome & Chromium from the command line bitchez
    chrome () {
        /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome $* 2>&1 &
    }
    chromium () {
        /Applications/Chromium.app/Contents/MacOS/Chromium --enable-memory-info $* 2>&1 &
    }

    alias mtr=/usr/local/sbin/mtr
    alias vlc="/Applications/VLC.app/Contents/MacOS/VLC"
    alias logstalgiaWherewolfWORKER0001='ssh wherewolf-WORKER0001 tail -f /var/log/nginx/access.log | logstalgia --sync --full-hostnames --update-rate 1 -g "API,URI=.*,100"'
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

# Completion
complete -C aws_completer aws
shopt -s no_empty_cmd_completion    # Self explanatory.
shopt -s hostcomplete               # Complete hostnames (TAB).
if [ -f $(brew --prefix)/etc/bash_completion ]; then
(. $(brew --prefix)/etc/bash_completion > /dev/null &)
fi

##### History management section
HISTFILESIZE=100000000
HISTSIZE=100000000

# autocompletion
complete -cf sudo
# SSH Hostname autocomplete
complete -W "$(echo `cat ~/.bash_history | egrep '^ssh ' | sort | uniq | sed 's/^ssh //'`;)" ssh
complete -W "$(echo `cat ~/.bash_history | egrep '^mosh ' | sort | uniq | sed 's/^mosh //'`;)" mosh

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

alias ..='cd ..'
alias df='df -h'
alias diff='colordiff'              # requires colordiff package
alias du='du -c -h'
alias grep='grep --color=auto'
alias mkdir='mkdir -p -v'
alias more='less'
alias nano='vim'
alias ping='ping -c 5'
alias vi='vim'
alias visudo='sudo -E visudo'

# new commands
# count inodes: find . -xdev -type f | cut -d "/" -f 2 | sort | uniq -c | sort –n
alias aptiupdate='sudo aptitude update && sudo aptitude safe-upgrade'
alias du1='du --max-depth=1'
alias hist='history | grep $1'      # requires an argument
alias fact="elinks -dump randomfunfacts.com | sed -n '/^│ /p' | tr -d \│"
alias srcbashrc='source ~/.bashrc'
alias srcbashprofile='source ~/.bash_profile'
alias openports='netstat --all --numeric --programs --inet'
alias whoshitting="sudo netstat -anp | grep 'tcp\|upd' | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -n"
alias apacheloguseragents="tail -n 10 -F /var/log/apache2/access.log | awk -F\" '{print $6}'"
alias aw='tmux attach -t wulf'

# Git shortcuts
alias gitrds="git reset -- *.DS_Store"
alias gits="git status"
alias gitp="git pull"
alias gp="git pull"
alias gpom="git pull origin master"
alias gpdm="git push --set-upstream dev master"
alias gppm="git push prod master"
alias gpam="git push prod master && git push dev master"
alias gd="git difftool"
alias gitbehind="git rev-list --left-right --count origin/master...origin/`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/' | sed 's/[() ]//g'`"

#alias espresso='~/SoftwareLibs/Espresso/bin/espresso.js'

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

if [ -f ~/Code/helperscripts/git-completion.bash ]; then
  . ~/Code/helperscripts/git-completion.bash
fi

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

## get current git branch
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# Turn on colours.
#case "$TERM" in
#    xterm-color)
#    color_prompt=yes;;
#esac

function prompt_command {
    # Run this function every time a prompt is displayed.
    # Make history happen, regardless of windows/panes/tabs/etc
    history -n
    history -a

    # Set term title to user@hostname/pwd
    echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"

    #Give a new line - the -e flag is for echo to enable interpretaion of backslash escapes
    #echo -e "\n"
    echo ''
    if [ -f /var/run/reboot-required ]
        then
	echo -e '\e[1;7m *** RESTART REQUIRED *** \e[0m due to:'
	cat /var/run/reboot-required.pkgs
    fi
}

# Bind up/down arrows history search.
case "$TERM" in *xterm*|rxvt*|Eterm|aterm|kterm|gnome*|interix|screen|screen-256color)
	bind '"\e[A": history-search-backward' >/dev/null 2>/dev/null
	bind '"\e[B": history-search-forward' >/dev/null 2>/dev/null
    color_prompt=yes
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

PS1='\[\e[0;36m\]┌─[\[\e[0;32m\]\u\[\e[0;34m\]@\[\e[0;31m\]\h\[\e[0m\e[0;36m\]]-[\[\e[0m\]`date +%Y-%m-%d\ %R` - `date +%s`\[\e[0;36m\]]-[\[\e[33;1m\]\w\[\e[0;36m\]]\033[32m\]`parse_git_branch`\n\[\e[0;36m\]└─[\[\e[35m\]\$\[\e[0;36m\]]->\[\e[0m\] '

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
