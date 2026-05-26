# claude-dev-launcher

Ein globaler **tmux-Launcher** für die Arbeit mit [Claude Code](https://claude.com/claude-code)
an mehreren Projekten. Ein einziger Befehl `dev` startet (oder dockt an) eine
projektspezifische tmux-Session mit festem Layout:

```
┌─────────────────────┬───────────────┐
│  claude (Pane 0)    │ claude agents │   links: interaktive Claude-Session
│  — Interaktion      │  — Status     │   rechts: Live-Status der Team-Agenten
└─────────────────────┴───────────────┘
```

- **links** eine interaktive `claude`-Session zum Arbeiten,
- **rechts** `claude agents` mit dem Live-Status der Background-/Team-Agenten dieses Projekts.

Ersetzt das frühere Muster, in jedem Projekt eine eigene `dev.sh` zu pflegen —
eine Quelle der Wahrheit für alle Projekte.

## Voraussetzungen

- [`tmux`](https://github.com/tmux/tmux) (getestet mit 3.6)
- die [Claude Code CLI](https://claude.com/claude-code) (`claude` im PATH)

## Installation

```bash
git clone https://github.com/mschabhuettl/claude-dev-launcher.git
cd claude-dev-launcher
./install.sh            # legt einen Symlink ~/.local/bin/dev -> ./dev an
```

Stelle sicher, dass `~/.local/bin` in deinem `PATH` liegt (in `~/.zshrc`/`~/.bashrc`):

```bash
export PATH="$HOME/.local/bin:$PATH"
```

## Verwendung

| Befehl          | Wirkung                                                              |
| --------------- | ------------------------------------------------------------------- |
| `dev`           | Nummern-Menü aller Projekte unter `~/projects` → Nummer wählen       |
| `dev <name>`    | startet/dockt an; Teilstring genügt (z.B. `dev api` → `my-api-service`) |
| `dev -l`        | listet die gefundenen Projekte samt erkanntem Stack                  |
| `dev -h`        | Hilfe                                                                |

- Die tmux-**Session** und das **Fenster** heißen wie der Projektordner.
- Läuft die Session bereits, wird nur angedockt (kein Neustart).
- Mehrere Treffer → Hinweis; kein Treffer → Liste der verfügbaren Projekte.

### tmux-Basics

- abdocken: `Strg-b d`
- später wieder ran: erneut `dev <name>` (oder `tmux attach -t <repo>`)
- zwischen Panes wechseln: `Strg-b ←/→`

## Konfiguration

Standardmäßig werden Projekte unter `~/projects` gesucht. Überschreibbar per
Umgebungsvariable:

```bash
DEV_PROJECTS_DIR=~/code dev
```

## Lizenz

MIT
