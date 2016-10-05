# Keybindings functions common to bash and zsh

function _remove_date_from_command_history() {
  awk '{ s = ""; for (i = 4; i <= NF; i++) s = s $i " "; print s }'
}

function fzf-select-persistent-history-line() {
  local max_num_history_lines
  max_num_history_lines=${MAX_NUM_PERSISTENT_HISTORY_SELECTED_LINES:-30000}
  if [ -n "$ZSH_VERSION" ]; then
    initial_query="${LBUFFER//$/\\$}"
  else
    initial_query=""
  fi
  local selected_line
  selected_line=$( tail -"$max_num_history_lines" ~/.config/history-files/persistent_shell_history |
    eval "$(__fzfcmd) --tac +s +m -n3..,.. --tiebreak=index --toggle-sort=ctrl-r -q \"$initial_query\" --exact $FZF_CTRL_R_OPTS" |
    \grep '^ *[0-9]' | _remove_date_from_command_history )
  local ret=$?
  echo "$selected_line"
  return $ret
}

