#!/bin/sh
set -eu
# A project sheet replaces the user sheet. `session hook: off` in either one silences the hook.
sheet="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/builder-models.md"
if [ -n "${CLAUDE_PROJECT_DIR:-}" ]; then
  root=$(git -C "$CLAUDE_PROJECT_DIR" rev-parse --show-toplevel 2>/dev/null) || root=$CLAUDE_PROJECT_DIR
  [ ! -f "$root/.claude/builder-models.md" ] || sheet="$root/.claude/builder-models.md"
fi
if [ -r "$sheet" ] && grep -Eiq '^[[:space:]]*session hook:[[:space:]]*off[[:space:]]*$' "$sheet"; then
  exit 0
fi
cat "$(dirname "$0")/session-start-context.md"
