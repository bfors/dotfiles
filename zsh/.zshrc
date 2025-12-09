cd ~/dev
cd -

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"


# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# af-magic
ZSH_THEME="af-magic"
#robbyrussell.zsh-theme
#ZSH_THEME="random"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"


# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git virtualenv)

source $ZSH/oh-my-zsh.sh

export HISTCONTROL=ignoredups

autoload -U +X bashcompinit && bashcompinit

export LANG=en_US.UTF-8
export EDITOR='nvim'
alias ohmyzsh="mate ~/.oh-my-zsh"

export PATH=$HOME/dotfiles/scripts:$PATH
touch ~/.zsh_profile
source ~/.zsh_profile

########

alias ez="nvim +138 ~/.zshrc"
alias ep="nvim ~/.zprofile"
alias rz="source ~/.zshrc"
alias rp="source ~/.zprofile"
alias et="nvim ~/.tmux.conf"
alias rt="tmux source-file ~/.tmux.conf"

alias t="lsd --tree"
alias s="source"
alias vim="nvim"
alias ls="lsd"
alias ll="lsd -la"
alias size="df -h"
alias ..="cd .."

##### GIT
alias gw="git worktree"

toplevel() {
	local dir=$(git rev-parse --show-toplevel)
	cd $dir
}
alias tl="toplevel"
alias bare="toplevel && .."
alias main="bare && cd main"

setup_worktree() {
	git config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*' 
	git fetch 
	git for-each-ref --format='%(refname:short)' refs/heads | xargs -n1 -I{} git branch --set-upstream-to=origin/{}
}

root() {
	dir=$(gw list | head -1 | awk '{print $1}') && cd "$dir"
	if [[ -d "develop" ]]; then
		cd develop
		return
	fi
	if [[ -d "main" ]]; then
		cd main
		return
	fi
	if [[ -d "master" ]]; then
		cd master
		return
	fi
}

clone() {
	cd ~/dev
	git clone --bare $(pbpaste)
	cd $(basename $(pbpaste))
	gwa main
	cd main
}

gw_update_main() {
	export current=$PWD
	root
	cd ../main
	git pull
	echo $current
	cd $current
}
alias gwu="gw_update_main"

gw_merge() {
	gw_update_main
	git merge main
}

gwa() {
	gw_update_main
	git worktree add $1 && cd $1
}

changebranch() {
	dir=$(gw list | fzf | awk '{print $1}') && cd "$dir"
}
bindkey -s ^g "changebranch\n"


##### DOCKER
alias up="docker-compose up --remove-orphans"
alias down="docker-compose down"
alias build="docker-compose build"
alias bup="build && up"

##### PYTHON
alias create_venv="uv venv --python 3.12 && activate"
alias delete_venv="deactivate && rm -rf .venv"
alias activate="source .venv/bin/activate"
alias install="uv pip install -r requirements.txt"
alias init="create_venv && install"
alias pip="uv pip"
alias run_jupyter="uv run --with jupyter jupyter notebook"
alias llm="uv run --isolated --with mlx-lm python -m mlx_lm chat"


##### OTHER
alias remove_swap="cd /home/bfors/.local/state/nvim/swap && rm * && cd -"

c() {
    local tmpfile=$(mktemp)
    nvim +startinsert "$tmpfile" < /dev/tty > /dev/tty
    local content=$(cat "$tmpfile")
    echo "$content"
    claude -p "$content"
    rm "$tmpfile"
}


check_cert() {
	openssl s_client -connect $1:443 -showcerts
}

port() {
	lsof -i -P | grep LISTEN | grep :$1
}

format_json() {
	jq . $1 | sponge $1
}

format_yaml() {
	yq . $1 | sponge $1
}


changedir() {
	deactivate &> /dev/null
	activate &> /dev/null
	search_paths=("$HOME/dev" "$HOME")
	if [ $(whoami) = 'bforsberg' ]; then
		search_paths=("$HOME/dev" "$HOME/" "$HOME/dev/go/src" "$HOME/dev/go/src/github.com/*")
	fi
	dir=$(find "${search_paths[@]}" -mindepth 1 -maxdepth 2 -type d | fzf) && cd "$dir"
}
bindkey -s ^f "changedir\n^l"


open_session() {
	activate &> /dev/null 
	nvim .
}
bindkey -s ^n "open_session\n^l"

open_tmux() {
	if tmux ls &>/dev/null; then
		tmux attach
	else
		local cwd=$(pwd)
		tmux new-session "cd $(pwd); exec zsh"\; split-window -h \; split-window -v
	fi
}
bindkey -s ^b "open_tmux\n"

on_change ()
{
	activate &> /dev/null
}

to_clipboard()
{
	cat $1 | pbcopy
}


chpwd_functions+=("on_change")


eval "$(fzf --zsh)"
fpath=(~/.zsh.d/ $fpath)

alias scripts="l ~/dotfiles/scripts"
alias ip="curl https://checkip.amazonaws.com"

# Other stuff

tempe () {
  cd "$(mktemp -d)"
  chmod -R 0700 .
  if [[ $# -eq 1 ]]; then
    \mkdir -p "$1"
    cd "$1"
    chmod -R 0700 .
  fi
}

boop () {
  local last="$?"
  if [[ "$last" == '0' ]]; then
    sfx good
  else
    sfx bad
  fi
  $(exit "$last")
}

alias cpwd="pwd | pbcopy"

# Timing
function preexec() {
	timer=$(($(gdate +%s%0N)/1000000))
}

function precmd() {
	if [ "$timer" ]; then
		now=$(($(gdate +%s%0N)/1000000))
		elapsed=$now-$timer

		reset_color=$'\e[00m'
		# RPROMPT="%F{cyan} $(converts "$elapsed") %{$reset_color%}"
		echo $(converts "$elapsed")
		unset timer
	fi
}

converts() {
	local t=$1

	local d=$((t/1000/60/60/24))
	local h=$((t/1000/60/60%24))
	local m=$((t/100/60%60))
	local s=$((t/1000%60))
	local ms=$((t%1000))

	if [[ $d -gt 0 ]]; then
			echo -n " ${d}d"
	fi
	if [[ $h -gt 0 ]]; then
			echo -n " ${h}h"
	fi
	if [[ $m -gt 0 ]]; then
			echo -n " ${m}m"
	fi
	if [[ $s -gt 0 ]]; then
		echo -n " ${s}s"
	fi
	if [[ $ms -gt 0 ]]; then
		echo -n " ${ms}ms"
	fi
	echo
}
