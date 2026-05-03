# fr-fzf — interactive file browser + grep, both powered by fzf.
# https://github.com/hugegene/fr-fzf

# Make bundled scripts (findtext) callable from inside fr's binds.
FR_FZF_DIR="${0:A:h}"
path=("$FR_FZF_DIR/bin" $path)

fr() {
  local search_cmd='(echo ..; fd --max-depth 1 --hidden --exclude .git 2>/dev/null || find . -maxdepth 1) | sort -f'
  local current_dir="$PWD"
  while true; do
    rm -f /tmp/fr_action /tmp/fr_item
    local selected
    selected=$( (cd "$current_dir" && eval "$search_cmd") | fzf \
      --delimiter / --with-nth -1 \
      --preview "cd ${(q)current_dir} && if [ -d {} ]; then tree -C {} | head -200; else bat --color=always --style=numbers --line-range :500 {}; fi" \
      --preview-window=wrap \
      --header "ENTER: Go In/Edit | CTRL-E: CD Here | CTRL-F: Grep Here | CTRL-G: Copy Path | CTRL-\\\\: Toggle Preview Size | ESC: Quit" \
      --bind "ctrl-g:execute-silent(cd ${(q)current_dir} && p={}; p=\${p#./}; printf '%s' \"\$PWD/\$p\" | pbcopy)" \
      --bind 'ctrl-e:execute-silent(echo __CD__ > /tmp/fr_action; echo -n {} > /tmp/fr_item)+abort' \
      --bind "ctrl-f:execute(cd ${(q)current_dir} && findtext .)" \
      --bind 'ctrl-\:change-preview-window(99%|hidden|)' \
      --expect=enter
    )

    if [ -f /tmp/fr_action ]; then
      local action=$(cat /tmp/fr_action)
      if [ "$action" = "__CD__" ]; then
        local item=$(cat /tmp/fr_item 2>/dev/null)
        local resolved
        resolved=$(cd "$current_dir" 2>/dev/null && cd "$item" 2>/dev/null && pwd)
        if [ -n "$resolved" ]; then
          cd "$resolved"
        elif [ -f "$current_dir/$item" ]; then
          cd "$(dirname "$current_dir/$item")"
        fi
        break
      fi
    fi

    local key=$(echo "$selected" | head -1)
    local item=$(echo "$selected" | tail -1)
    [ -z "$item" ] && break
    local resolved
    resolved=$(cd "$current_dir" 2>/dev/null && cd "$item" 2>/dev/null && pwd)
    if [ -n "$resolved" ]; then
      current_dir="$resolved"
    elif [ -f "$current_dir/$item" ]; then
      micro -softwrap true "$current_dir/$item"
    fi
  done
}
