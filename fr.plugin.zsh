# fr-fzf — interactive file browser + grep, both powered by fzf.
# https://github.com/eugene/fr-fzf

# Make bundled scripts (findtext) callable from inside fr's binds.
FR_FZF_DIR="${0:A:h}"
path=("$FR_FZF_DIR/bin" $path)

fr() {
  local search_cmd='(echo ..; fd --max-depth 1 --hidden --exclude .git 2>/dev/null || find . -maxdepth 1) | sort -f'
  while true; do
    rm -f /tmp/fr_action /tmp/fr_item
    local selected
    selected=$(eval "$search_cmd" | fzf \
      --delimiter / --with-nth -1 \
      --preview 'if [ -d {} ]; then tree -C {} | head -200; else bat --color=always --style=numbers --line-range :500 {}; fi' \
      --header "ENTER: Go In/Edit | CTRL-E: CD Here | CTRL-F: Grep Here | CTRL-G: Copy Path | CTRL-\\\\: Toggle Preview Size | ESC: Quit" \
      --bind 'ctrl-g:execute-silent(p={}; p=${p#./}; printf "%s" "$PWD/$p" | pbcopy)' \
      --bind 'ctrl-e:execute-silent(echo __CD__ > /tmp/fr_action; echo -n {} > /tmp/fr_item)+abort' \
      --bind 'ctrl-f:execute(findtext-live .)' \
      --bind 'ctrl-\:change-preview-window(99%|hidden|)' \
      --expect=enter
    )

    if [ -f /tmp/fr_action ]; then
      local action=$(cat /tmp/fr_action)
      if [ "$action" = "__CD__" ]; then
        local item=$(cat /tmp/fr_item 2>/dev/null)
        if [ -d "$item" ]; then
          cd "$item"
        elif [ -f "$item" ]; then
          cd "$(dirname "$item")"
        fi
        break
      fi
    fi

    local key=$(echo "$selected" | head -1)
    local item=$(echo "$selected" | tail -1)
    [ -z "$item" ] && break
    if [ -d "$item" ]; then
      cd "$item"
    elif [ -f "$item" ]; then
      micro "$item"
    fi
  done
}
