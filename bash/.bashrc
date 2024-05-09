alias vim="nvim"
alias af="airflow"
alias ls="exa"
alias ll="exa -la"

alias edit_bashrc="nvim ~/.bashrc"
alias reload_bashrc="source ~/.bashrc"
alias size="df -h"

alias remove_swap="cd /home/bfors/.local/state/nvim/swap && rm * && cd -"
alias create_venv="python3 -m venv .venv && activate"
alias activate="source .venv/bin/activate"

alias activate="source ./.venv/bin/activate"
alias create_venv="python3 -m venv .venv"

export host='206.81.0.24'
alias nyc_root="ssh root@$host"
alias nyc="ssh bfors@$host"

fzf_select_path() {
	local selected_path
	selected_path=$(fzf) 
	# Output the selected path
	echo "$selected_path"
	cd $selected_path
}

nono() {
	#selected=$(find ~/dev ~/  -mindepth 1 -maxdepth 1 -type d | fzf)
	cd $(find ~/dev ~/  -mindepth 1 -maxdepth 1 -type d | fzf)
	pwd
	return 0
}

#bind -x '"\C-f": "cd $(find ~/dev ~/  -mindepth 1 -maxdepth 1 -type d | fzf)"'

bind -x '"\C-f": nono'

function fhir() {
	fhirbase -d fhirbase --host /var/run/postgresql -p 5432 -U bfors -W postgrespass $1 $2 $3 $4
}

function journal() {
   journalctl -u $1 -f --no-pager
}

export HISTCONTROL=ignoredups

. "$HOME/.cargo/env"

# UNUSED extra stuff
#alias edit_bashrc_system="sudo vim /etc/bash.bashrc"
#alias reload_bashrc_system="source /etc/bash.bashrc"
#alias edit_bfors="vim /etc/nginx/sites-available/bfors"
#alias reload_nginx="nginx -s reload"


# System-wide .bashrc file for interactive bash(1) shells.

# To enable the settings / commands in this file for login shells as well,
# this file has to be sourced in /etc/profile.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, overwrite the one in /etc/profile)
# but only if not SUDOing and have SUDO_PS1 set; then assume smart user.
if ! [ -n "${SUDO_USER}" -a -n "${SUDO_PS1}" ]; then
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi

# Commented out, don't overwrite xterm -T "title" -n "icontitle" by default.
# If this is an xterm set the title to user@host:dir
#case "$TERM" in
#xterm*|rxvt*)
#    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
#    ;;
#*)
#    ;;
#esac

# enable bash completion in interactive shells
#if ! shopt -oq posix; then
#  if [ -f /usr/share/bash-completion/bash_completion ]; then
#    . /usr/share/bash-completion/bash_completion
#  elif [ -f /etc/bash_completion ]; then
#    . /etc/bash_completion
#  fi
#fi

# sudo hint
if [ ! -e "$HOME/.sudo_as_admin_successful" ] && [ ! -e "$HOME/.hushlogin" ] ; then
    case " $(groups) " in *\ admin\ *|*\ sudo\ *)
    if [ -x /usr/bin/sudo ]; then
	cat <<-EOF
	To run a command as administrator (user "root"), use "sudo <command>".
	See "man sudo_root" for details.
	
	EOF
    fi
    esac
fi

# if the command-not-found package is installed, use it
if [ -x /usr/lib/command-not-found -o -x /usr/share/command-not-found/command-not-found ]; then
	function command_not_found_handle {
	        # check because c-n-f could've been removed in the meantime
                if [ -x /usr/lib/command-not-found ]; then
		   /usr/lib/command-not-found -- "$1"
                   return $?
                elif [ -x /usr/share/command-not-found/command-not-found ]; then
		   /usr/share/command-not-found/command-not-found -- "$1"
                   return $?
		else
		   printf "%s: command not found\n" "$1" >&2
		   return 127
		fi
	}
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac
force_color_prompt=yes
if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh
eval "$(atuin init bash)"


eval "$(fzf --bash)"
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
