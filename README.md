# fr-fzf

Pair Claude Code with a real terminal-native file browser and find text.

![demo](docs/demo.gif)

- `fr` — browse files/directories with live preview, cd between dirs, edit a file, copy a path.
- `findtext` — live recursive grep: type the pattern, results update per keystroke, with match-aware preview, and copy code snippet.
- `fr` can pivot into `findtext` (ctrl-f) without leaving the loop.

## Why?

You opened a terminal for Claude Code. Then you alt-tabbed to an IDE to find a file. Then you alt-tabbed back to paste it. `fr-fzf` removes the round trip.

- **Made for Claude Code workflows.** `findtext`'s ctrl-g copies `<absolute_path>` + ±10 lines around the match to your clipboard — exactly the shape you paste into a Claude prompt. One keystroke, no manual copy.
- **Discard the IDE.** If your editor already lives in the terminal (micro, vim, helix, nvim), you don't need an Electron file browser too. `fr` is fzf-fast with live previews; `findtext` is instant grep with context. One buffer, full keyboard.
- **Two keystrokes from anywhere on disk to your clipboard.** `fr` → ctrl-f → type pattern → ctrl-g. Done.

## Dependencies

Required:

- [`fzf`](https://github.com/junegunn/fzf)
- [`bat`](https://github.com/sharkdp/bat) — syntax-highlighted previews
- [`tree`](https://formulae.brew.sh/formula/tree) — directory previews in fr
- [`micro`](https://github.com/zyedidia/micro) — opens files from `fr` (enter) and matches from `findtext` (enter)
- `grep` — POSIX, present everywhere
- `zsh` — both `fr` and `findtext` use zsh

Optional (graceful degradation):

- [`fd`](https://github.com/sharkdp/fd) — faster than `find`; fr falls back to `find` if missing

Clipboard: `pbcopy` (macOS). On Linux replace with `xclip -selection clipboard` or `wl-copy` — see [Portability](#portability).

## Install

### oh-my-zsh

```sh
git clone https://github.com/hugegene/fr-fzf ~/.oh-my-zsh/custom/plugins/fr-fzf
```

Then add `fr-fzf` to the `plugins=(...)` line in `~/.zshrc`.

### zinit

```sh
zinit load hugegene/fr-fzf
```

### antigen

```sh
antigen bundle hugegene/fr-fzf
```

### Manual

```sh
git clone https://github.com/hugegene/fr-fzf ~/.fr-fzf
echo 'source ~/.fr-fzf/fr.plugin.zsh' >> ~/.zshrc
```

Reload your shell (`exec zsh`) after install.

## Usage

### `fr`

Run `fr` in any directory.

| Key | Action |
| --- | --- |
| `Enter` | Enter directory / open file in `micro` |
| `Ctrl-E` | `cd` into the highlighted directory and exit fzf |
| `Ctrl-F` | Open `findtext` in the current directory |
| `Ctrl-G` | Copy absolute path to clipboard |
| `Ctrl-\` | Cycle preview window: 99% width / hidden / default |
| `Esc` | Quit |

The first entry is always `..` so you can navigate up.

### `findtext`

```sh
findtext [path]
```

Path defaults to `.`. Type your pattern in the fzf query line — results update per keystroke.

| Key | Action |
| --- | --- |
| `Enter` | Open match in `micro` at the matched line |
| `Ctrl-G` | Copy absolute path + ±10 lines around the match to clipboard |
| `Ctrl-\` | Cycle preview window |
| `Esc` | Quit |

### Inside `micro`

The plugin opens files in `micro` with mouse reporting on, so terminal-native selection (drag with mouse, then `Cmd-C` on macOS) is hijacked by micro. To copy from inside micro: select text with `Shift`+arrow keys (or `Alt`+drag on macOS to bypass mouse reporting), then **`Ctrl-C`** — that's micro's copy keybind, not the macOS clipboard shortcut. Paste with `Ctrl-V`.

## Portability

The bundled binds use `pbcopy` (macOS-only). To run on Linux, edit `fr.plugin.zsh` and `bin/findtext` and replace `pbcopy` with one of:

- `xclip -selection clipboard` (X11)
- `wl-copy` (Wayland)

A future version may auto-detect.

## Troubleshooting

### Ubuntu/Debian: `bat: command not found`

`apt install bat` installs the binary as **`batcat`** (not `bat`) to avoid a naming conflict with another package. The plugin calls `bat`, so symlink it:

```sh
mkdir -p ~/.local/bin && ln -s /usr/bin/batcat ~/.local/bin/bat
```

Make sure `~/.local/bin` is on your `$PATH`. Alternatively, install the `.deb` from [bat's GitHub releases](https://github.com/sharkdp/bat/releases) — that one ships as `bat` directly.

## License

MIT — see [LICENSE](LICENSE).
