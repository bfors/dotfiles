alias ll="ls -la"
alias edit_bashrc="vim ~/.bashrc"
alias reload_bashrc="source ~/.bashrc"
alias vim=nvim

export host='206.81.0.24'
alias nyc_root="ssh root@$host"
alias nyc="ssh bfors@$host"

update_site () {
	now=$(date)
	echo "<b>$1</b> - \t(<i>$now</i>)<br>\n" | ssh root@$host 'cat >> /data/www/index.html'
}

export HISTCONTROL=ignoredups
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
