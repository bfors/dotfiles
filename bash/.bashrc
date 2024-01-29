alias ll="ls -la"
alias edit_bashrc="vi ~/.bashrc"
alias edit_nvim="vim ~/.config/nvim/init.lua"
alias reload_bashrc="source ~/.bashrc"
alias vim=nvim

alias activate="source ./.venv/bin/activate"
alias create_venv="python3 -m venv .venv"

export host='206.81.0.24'
alias nyc_root="ssh root@$host"
alias nyc="ssh bfors@$host"

update_site () {
	now=$(date)
	echo "<b>$1</b> - \t(<i>$now</i>)<br>\n" | ssh root@$host 'cat >> /data/www/index.html'
}

export HISTCONTROL=ignoredups
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
