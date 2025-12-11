# af-magic.zsh-theme
#
# Author: Andy Fleming
# URL: http://andyfleming.com/

# dashed separator size
function afmagic_dashes {
  # check either virtualenv or condaenv variables
  local python_env_dir="${VIRTUAL_ENV:-$CONDA_DEFAULT_ENV}"
  local python_env="${python_env_dir##*/}"

  # if there is a python virtual environment and it is displayed in
  # the prompt, account for it when returning the number of dashes
  if [[ -n "$python_env" && "$PS1" = *\(${python_env}\)* ]]; then
    echo $(( COLUMNS - ${#python_env} - 3 ))
  elif [[ -n "$VIRTUAL_ENV_PROMPT" && "$PS1" = *${VIRTUAL_ENV_PROMPT}* ]]; then
    echo $(( COLUMNS - ${#VIRTUAL_ENV_PROMPT} - 3 ))
  else
    echo $COLUMNS
  fi
}

# execution time tracking
__afmagic_elapsed_time=""

function __afmagic_preexec() {
  __afmagic_timer=$(($(gdate +%s%0N)/1000000))
}

function __afmagic_precmd() {
  if [ "$__afmagic_timer" ]; then
    local now=$(($(gdate +%s%0N)/1000000))
    local elapsed=$(($now-$__afmagic_timer))
    __afmagic_elapsed_time="$(__afmagic_converts "$elapsed")"
    unset __afmagic_timer
  fi
}

autoload -Uz add-zsh-hook
add-zsh-hook preexec __afmagic_preexec
add-zsh-hook precmd __afmagic_precmd

function __afmagic_converts() {
  local t=$1

  local d=$((t/1000/60/60/24))
  local h=$((t/1000/60/60%24))
  local m=$((t/1000/60%60))
  local s=$((t/1000%60))
  local ms=$((t%1000))

  local result=""
  if [[ $d -gt 0 ]]; then
    result+="${d}d "
  fi
  if [[ $h -gt 0 ]]; then
    result+="${h}h "
  fi
  if [[ $m -gt 0 ]]; then
    result+="${m}m "
  fi
  if [[ $s -gt 0 ]]; then
    result+="${s}s "
  fi
  if [[ $ms -gt 0 ]]; then
    result+="${ms}ms"
  fi
  echo -n "$result"
}

function afmagic_exec_time() {
  if [[ -n "$__afmagic_elapsed_time" ]]; then
    echo "${FG[245]}${__afmagic_elapsed_time}%{$reset_color%}"
  fi
}

# primary prompt: dashed separator, directory and vcs info
PS1="${FG[237]}\${(l.\$(afmagic_dashes)..-.)}%{$reset_color%}
${FG[032]}%~\$(git_prompt_info)\$(hg_prompt_info) ${FG[105]}%(!.#.»)%{$reset_color%} "
PS2="%{$fg[red]%}\ %{$reset_color%}"

# right prompt: return code, virtualenv and context (user@host)
RPS1="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"
if (( $+functions[virtualenv_prompt_info] )); then
  RPS1+='$(virtualenv_prompt_info)'
fi
RPS1+=' $(afmagic_exec_time)'
RPS1+=" ${FG[237]}%n@%m%{$reset_color%}"

# git settings
ZSH_THEME_GIT_PROMPT_PREFIX=" ${FG[075]}(${FG[078]}"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="${FG[214]}*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="${FG[075]})%{$reset_color%}"

# hg settings
ZSH_THEME_HG_PROMPT_PREFIX=" ${FG[075]}(${FG[078]}"
ZSH_THEME_HG_PROMPT_CLEAN=""
ZSH_THEME_HG_PROMPT_DIRTY="${FG[214]}*%{$reset_color%}"
ZSH_THEME_HG_PROMPT_SUFFIX="${FG[075]})%{$reset_color%}"

# virtualenv settings
ZSH_THEME_VIRTUALENV_PREFIX=" ${FG[075]}["
ZSH_THEME_VIRTUALENV_SUFFIX="]%{$reset_color%}"

# override virtualenv_prompt_info to strip trailing space
function virtualenv_prompt_info(){
  [[ -n ${VIRTUAL_ENV} ]] || return
  local prompt="${VIRTUAL_ENV_PROMPT:-${VIRTUAL_ENV:t:gs/%/%%}}"
  # strip trailing whitespace
  prompt="${prompt%% }"
  echo "${ZSH_THEME_VIRTUALENV_PREFIX}${prompt}${ZSH_THEME_VIRTUALENV_SUFFIX}"
}
