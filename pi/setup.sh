#!/usr/bin/env bash
# One-step setup for using this skill set with Pi (pi coding agent).
# Idempotent: safe to re-run. Differing existing files are backed up first.
set -euo pipefail

SRC="$(cd "$(dirname "$0")" && pwd)"
PI_DIR="$HOME/.pi/agent"

command -v pi >/dev/null 2>&1 || {
  echo "ERROR: 'pi' not found on PATH. Install pi first, then re-run." >&2
  exit 1
}

mkdir -p "$PI_DIR"

# 1. Install the terminology adapter (backed up if it differs)
f="APPEND_SYSTEM.md"
if [ -f "$PI_DIR/$f" ] && ! cmp -s "$SRC/$f" "$PI_DIR/$f"; then
  cp "$PI_DIR/$f" "$PI_DIR/$f.bak.$(date +%Y%m%d%H%M%S)"
  echo "backed up existing $f"
fi
cp "$SRC/$f" "$PI_DIR/$f"
echo "installed $f -> $PI_DIR"

# 2. Declare this repo as a Pi package (idempotent for the same source)
pi install git:github.com/MrOac/skills

# 3. Reconcile the checkout
pi update --extensions

echo "Done. Restart pi (or run /reload in an active session) to load the skills."
