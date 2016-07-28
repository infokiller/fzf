# Keybindings functions common to bash and zsh

function _remove_date_from_command_history() {
  awk '{ s = ""; for (i = 4; i <= NF; i++) s = s $i " "; print s }'
}

function fzf-select-persistent-history-line() {
  local max_num_history_lines
  max_num_history_lines=${MAX_NUM_PERSISTENT_HISTORY_SELECTED_LINES:-30000}
  if [[ $# -gt 0 ]]; then
    initial_query="${LBUFFER//$/\\$}"
  else
    initial_query=""
  fi
  local selected_line
  selected_line=$( tail -"$max_num_history_lines" ~/.config/history-files/persistent_shell_history |
    $(__fzfcmd) --tac +s +m -n3..,.. --tiebreak=index --toggle-sort=ctrl-r -q "$initial_query" --exact |
    \grep '^ *[0-9]' | _remove_date_from_command_history )
  echo "$selected_line"
}

