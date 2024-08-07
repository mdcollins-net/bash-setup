# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

bold=$(tput bold)
normal=$(tput sgr0)

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

#  +-------------------------------------------------------------------+
#  |  Path - begin                                                     |
#  +-------------------------------------------------------------------+

export GOPATH="$HOME/go"

export PATH="/bin:/usr/bin/:/usr/sbin:/usr/local/bin:$PATH"
export PATH="$GOPATH/bin:$PATH"
export PATH="$HOME/bin:$HOME/sbin:$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

#  +-------------------------------------------------------------------+
#  |  Path - end                                                       |
#  +-------------------------------------------------------------------+

#  +-------------------------------------------------------------------+
#  |  Aliases - begin                                                  |
#  +-------------------------------------------------------------------+

alias c='clear'
alias l='exa --group-directories-first --color=always --sort=extension'
alias t='tre'
alias k='sudo fkill -f -v'
alias t='tre'

alias td='tre --directories'
alias fk='sudo fkill -f -v'
alias ll='exa --long --group-directories-first --git --header --color=always --sort=size'
alias lw='exa --group-directories-first --color=always --sort=name'
alias la='exa --group-directories-first --color=always --sort=name --all'
alias ld='exa --only-dirs --color=always --all'
alias df='df --human-readable --total'
alias ..='cd ..'

alias lla='exa --long --group-directories-first --git --header --color=always --sort=size --all'

alias tree='tre'

# Windows WSL

alias x='explorer.exe . &'

#  +-------------------------------------------------------------------+
#  |  Aliases - end                                                    |
#  +-------------------------------------------------------------------+

#  +-------------------------------------------------------------------+
#  |  Functions - begin                                                |
#  +-------------------------------------------------------------------+

function _update_ps1() {
        PS1="$($GOPATH/bin/powerline-go -error $?)"
}

function ff() {
	fff "$@"
	cd "$(cat "${XDG_CACHE_HOME:=${HOME}/.cache}/fff/.fff_d")"
}

function greeting() {
	upSeconds="$(/usr/bin/cut -d. -f1 /proc/uptime)"
	secs=$((${upSeconds}%60))
	mins=$((${upSeconds}/60%60))
	hours=$((${upSeconds}/3600%24))
	days=$((${upSeconds}/86400))
	UPTIME=`printf "%d days, %2d hours, %2d minutes, %2d seconds" "$days" "$hours" "$mins" "$secs"`

	echo "$(tput setaf 2)$bold
`date +"%A, %e %B %Y, %r"`
`uname -srmo`$(tput setaf 1)

Uptime.............: ${UPTIME}
Memory.............: `cat /proc/meminfo | grep MemFree | awk {'print $2/1024/1024'}` GB (Free) / `cat /proc/meminfo | grep MemTotal | awk {'print $2/1024/1024'}` GB (Total)
$(tput sgr0)$normal"

	echo -e "$bold"
	echo -e ""
	echo -e "$normal"
}

function ssh_keychain_init() {

	echo -e "\n Loading SSH keychain ..."
	eval ``keychain --eval --agents ssh id_rsa

}

function ssh_agent_init() {

	echo -e "Starting SSH agent ..."

	env=~/.ssh/agent.env

	#agent_load_env () { test -f "$env" && . "$env" >| /dev/null ; }

	agent_load_env () { test -f "$env" && . "$env"  ; }

	#agent_start () {
		#(umask 077; ssh-agent >| "$env")
		#. "$env" >| /dev/null ;
	#}

	agent_start () {
		(umask 077; ssh-agent >| "$env")
		. "$env" ;
	}

	agent_load_env

	# agent_run_state: 0=agent running w/ key; 1=agent w/o key; 2= agent not running
	agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)

	if [ ! "$SSH_AUTH_SOCK" ] || [ $agent_run_state = 2 ]; then
		agent_start
		ssh-add
	elif [ "$SSH_AUTH_SOCK" ] && [ $agent_run_state = 1 ]; then
		ssh-add
	fi

	unset env

}

#  +-------------------------------------------------------------------+
#  |  Functions - end                                                  |
#  +-------------------------------------------------------------------+

#  ---------------------------------------------------------------------

#
#  Powerline prompt
#

if [ "$TERM" != "linux" ] && [ -f "$GOPATH/bin/powerline-go" ]; then
	PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi

#
#  Autojump
#

[[ -s /home/mark/.autojump/etc/profile.d/autojump.sh ]] && source /home/mark/.autojump/etc/profile.d/autojump.sh

#
#  FASD
#

fasd_cache="$HOME/.fasd-init-bash"

if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
	  fasd --init posix-alias bash-hook bash-ccomp bash-ccomp-install >| "$fasd_cache"
fi

source "$fasd_cache"
unset fasd_cache


#  ---------------------------------------------------------------------


greeting
#ssh_agent_init
#ssh_keychain_init


cd $HOME
