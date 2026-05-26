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

Die linke Pane **setzt deine letzte Konversation des Projekts fort**, sobald es
eine gibt (Resume-Picker), sonst startet sie frisch — du machst pro Projekt
nahtlos weiter. Sind [Agent-Teams](#agent-teams--subagents) aktiv, erscheinen
gespawnte Teammates automatisch als zusätzliche tmux-Panes neben deiner Session.

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
| `dev init [name]` | macht ein Projekt „team-ready“: legt `CLAUDE.md` und `.claude/agents/` (Beispiel-Subagents) an. Ohne `name` das aktuelle Verzeichnis. Idempotent — überschreibt nichts. |
| `dev -l`        | listet die gefundenen Projekte samt erkanntem Stack                  |
| `dev -h`        | Hilfe                                                                |

- Die tmux-**Session** und das **Fenster** heißen wie der Projektordner.
- Läuft die Session bereits, wird nur angedockt (kein Neustart).
- Mehrere Treffer → Hinweis; kein Treffer → Liste der verfügbaren Projekte.

### tmux-Basics

- abdocken: `Strg-b d`
- später wieder ran: erneut `dev <name>` (oder `tmux attach -t <repo>`)
- zwischen Panes wechseln: `Strg-b ←/→`

## Agent-Teams & Subagents

Damit Claude pro Projekt maximal nützt:

- **Agent-Teams** (experimentell) per `~/.claude/settings.json` global einschalten:

  ```json
  { "env": { "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1" } }
  ```

  Danach „erstelle ein Agent-Team, das …“ in der linken Pane sagen. Da `dev` in
  tmux läuft, spawnt Claude die Teammates als eigene Panes (`teammateMode: auto`).

- **`dev init`** legt projektspezifische **Subagents** unter `.claude/agents/` an
  (`code-reviewer`, `test-runner`) sowie einen `CLAUDE.md`-Stub. Claude delegiert
  anhand der `description` automatisch und nutzt sie als Teammate-Typen. Erweitere
  die Vorlagen je Projekt — sie liegen im Repo und werden mitversioniert.

## Konfiguration

Steuerung per Umgebungsvariable:

| Variable           | Default      | Wirkung                                                            |
| ------------------ | ------------ | ------------------------------------------------------------------ |
| `DEV_PROJECTS_DIR` | `~/projects` | Projektwurzel                                                      |
| `DEV_RESUME`       | `auto`       | linke Pane: `auto` (fortsetzen wenn Verlauf da, sonst frisch), `resume`, `continue`, `fresh` |
| `DEV_PANE_DELAY`   | `2`          | Sekunden, die die Agents-Pane wartet (Race-Schutz beim Config-Patch) |
| `DEV_AGENT_ARGS`   | –            | Extra-Flags für `claude agents`, z.B. `--model opus --effort high` |

```bash
DEV_PROJECTS_DIR=~/code dev
DEV_RESUME=fresh dev api          # bewusst neue Konversation
DEV_AGENT_ARGS="--model opus" dev api
```

## Lizenz

MIT
