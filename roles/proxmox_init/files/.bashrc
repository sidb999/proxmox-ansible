if [[ $- != *i* ]]; then
	# Shell is non-interactive.  Be done now!
	return
fi

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth
HISTSIZE=10000
HISTFILESIZE=20000

shopt -s checkwinsize
shopt -s no_empty_cmd_completion
shopt -s histappend

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi

# Change the window title of X terminals
case ${TERM} in
[aEkx]term* | rxvt* | gnome* | konsole* | interix | tmux*)
	PS1='\[\033]0;\u@\h:\w\007\]'
	;;
screen*)
	PS1='\[\033_\u@\h:\w\033\\\]'
	;;
*)
	unset PS1
	;;
esac

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.
# We run dircolors directly due to its changes in file syntax and
# terminal name patching.
use_color=false
if type -P dircolors >/dev/null; then
	# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
	LS_COLORS=
	if [[ -f ~/.dir_colors ]]; then
		eval "$(dircolors -b ~/.dir_colors)"
	elif [[ -f /etc/DIR_COLORS ]]; then
		eval "$(dircolors -b /etc/DIR_COLORS)"
	else
		eval "$(dircolors -b)"
	fi
	# Note: We always evaluate the LS_COLORS setting even when it's the
	# default.  If it isn't set, then `ls` will only colorize by default
	# based on file attributes and ignore extensions (even the compiled
	# in defaults of dircolors). #583814
	if [[ -n ${LS_COLORS:+set} ]]; then
		use_color=true
	else
		# Delete it if it's empty as it's useless in that case.
		unset LS_COLORS
	fi
else
	# Some systems (e.g. BSD & embedded) don't typically come with
	# dircolors so we need to hardcode some terminals in here.
	case ${TERM} in
	[aEkx]term* | rxvt* | gnome* | konsole* | screen | tmux | cons25 | *color) use_color=true ;;
	esac
fi

if ${use_color}; then
	if [[ ${EUID} == 0 ]]; then
		PS1+='\[\033[01;31m\]\h\[\033[01;34m\] \w \$\[\033[00m\] '
	else
		PS1+='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
	fi

	#BSD#@export CLICOLOR=1
	#GNU#@alias ls='ls --color=auto'
	alias grep='grep --colour=auto'
	alias ls='ls --color=auto'
	alias ll='ls --color=auto -lh'
	alias lla='ls --color=auto -lah'
	alias rm='rm -i'
	alias cp='cp -i'
	alias mv='mv -i'
else
	# show root@ when we don't have colors
	PS1+='\u@\h \w \$ '
	alias grep='grep'
	alias ls='ls'
	alias ll='ls -lh'
	alias lla='ls -lah'
	alias rm='rm -i'
	alias cp='cp -i'
	alias mv='mv -i'
fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
fi

for sh in /etc/bash/bashrc.d/*; do
	[[ -r ${sh} ]] && source "${sh}"
done

# Try to keep environment pollution down, EPA loves us.
unset use_color sh
