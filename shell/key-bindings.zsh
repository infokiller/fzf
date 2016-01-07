# Key bindings
# ------------
if [[ $- == *i* ]]; then

# CTRL-T - Paste the selected file path(s) into the command line
__fsel() {
  local cmd="${FZF_CTRL_T_COMMAND:-"command find -L . \\( -path '*/\\.*' -o -fstype 'dev' -o -fstype 'proc' \\) -prune \
    -o -type f -print \
    -o -type d -print \
    -o -type l -print 2> /dev/null | sed 1d | cut -b3-"}"
  eval "$cmd" | $(__fzfcmd) -m | while read item; do
    printf '%q ' "$item"
  done
  echo
}

__fzfcmd() {
  [ ${FZF_TMUX:-1} -eq 1 ] && echo "fzf-tmux -d${FZF_TMUX_HEIGHT:-40%}" || echo "fzf"
}

fzf-file-widget() {
  LBUFFER="${LBUFFER}$(__fsel)"
  zle redisplay
}
zle     -N   fzf-file-widget
bindkey '^T' fzf-file-widget

# ALT-C - cd into the selected directory
fzf-cd-widget() {
  local cmd="${FZF_ALT_C_COMMAND:-"command find -L . \\( -path '*/\\.*' -o -fstype 'dev' -o -fstype 'proc' \\) -prune \
    -o -type d -print 2> /dev/null | sed 1d | cut -b3-"}"
  cd "${$(eval "$cmd" | $(__fzfcmd) +m):-.}"
  zle reset-prompt
}
zle     -N    fzf-cd-widget
bindkey '\ec' fzf-cd-widget


function remove_date_from_command_history() {
  awk '{ s = ""; for (i = 4; i <= NF; i++) s = s $i " "; print s }'
}

# CTRL-R - Paste the selected command from history into the command line
fzf-history-widget() {
  local line
  line=$( tail -10000 ~/.config/history-files/persistent_shell_history |
    $(__fzfcmd) --tac +s +m -n3..,.. --tiebreak=index --toggle-sort=ctrl-r -q "${LBUFFER//$/\\$}" --exact |
    \grep '^ *[0-9]' | remove_date_from_command_history )
  if [ -n $line ]; then
    LBUFFER="$line"
    RBUFFER=""
  fi
  zle redisplay
}
zle     -N   fzf-history-widget
bindkey '^R' fzf-history-widget

fi

