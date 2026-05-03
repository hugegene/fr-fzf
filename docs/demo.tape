# vhs script for fr-fzf demo.
# Render with:  vhs docs/demo.tape
# Output:       docs/demo.gif
#
# Prereqs:
#   - vhs            : brew install vhs
#   - fr-fzf sourced : source ~/.fr-fzf/fr.plugin.zsh
#   - bat, fzf, micro on PATH
#
# Tweak FontSize / Width / Height to taste.

Output docs/demo.gif

Set Shell        "zsh"
Set FontSize     14
Set Width        1100
Set Height       650
Set TypingSpeed  80ms
Set Theme        "Catppuccin Mocha"

# ---------- setup (hidden from the GIF) ----------
Hide
Type "source ~/.fr-fzf/fr.plugin.zsh && cd ~/.fr-fzf && clear"
Enter
Sleep 1s
Show

# ---------- demo ----------

# 1. Launch fr — the file browser appears with live preview.
Type "fr"
Sleep 500ms
Enter
Sleep 4s

# 2. Fuzzy-filter to README, showing the preview pane updating.
Type "fr.plug"
Sleep 4s

Ctrl+\
Ctrl+\
Sleep 4s

# 3. Hit ctrl-f to open the nested live-grep picker.
Ctrl+f
Sleep 500ms

# 4. Type a pattern slowly — watch results update per keystroke.
Type "softwrap"
Sleep 4s

# 5. Arrow down a couple of matches to show preview tracking.
Up
Up
Sleep 4s

Ctrl+\
Ctrl+\
Sleep 4s

# 6. Enter to open the match in micro at the exact line.
Enter
Sleep 4s

# 7. Quit micro back to the live-grep picker.
Ctrl+q
Sleep 500ms

# 8. Esc out of live-grep, then esc out of fr.
Escape
Sleep 500ms
Escape
Sleep 4s
