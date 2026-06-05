#!/usr/bin/env bash
# ───────────────────────────────────────────────────────────────
# Paperclip — run script
# All data is stored inside the repo root at .paperclip-data/
# No external paths are used.
# ───────────────────────────────────────────────────────────────
set -euo pipefail

cd "$(dirname "$0")"

# Containerise all runtime data inside the repo
export PAPERCLIP_HOME="$(pwd)/.paperclip-data"
export PAPERCLIP_MIGRATION_AUTO_APPLY="true"
export PORT="8100"

echo "━━━ Paperclip ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " Repo:  $(pwd)"
echo " Data:  $PAPERCLIP_HOME"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

exec pnpm dev:server "$@"
