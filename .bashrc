source ~/code/dotfiles/.bash_profile

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# From https://wherewolf.zendesk.com/hc/en-gb/articles/4405622143762-Setting-up-Windows-Subsystem-for-Linux-Version-2-WSL-2-
# WSL 2 specific settings.
# set DISPLAY variable to the IP automatically assigned to WSL2
export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):0.0
# LibGL
export LIBGL_ALWAYS_INDIRECT=1

# add Pulumi to the PATH
export PATH=$PATH:$HOME/.pulumi/bin
