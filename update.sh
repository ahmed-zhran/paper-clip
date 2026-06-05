#!/usr/bin/env bash
# ───────────────────────────────────────────────────────────────
# Paperclip — update script
# Pulls latest changes from the original paperclipai/paperclip
# repo (upstream) into your forked copy (origin).
# ───────────────────────────────────────────────────────────────
set -euo pipefail

cd "$(dirname "$0")"

BRANCH="$(git branch --show-current)"
REMOTE_UPSTREAM="upstream"
REMOTE_ORIGIN="origin"

echo "━━━ Paperclip Update ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " Branch:  $BRANCH"
echo " Upstream: $REMOTE_UPSTREAM (paperclipai/paperclip)"
echo " Origin:   $REMOTE_ORIGIN ($(git remote get-url "$REMOTE_ORIGIN" 2>/dev/null || echo '—'))"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check that both remotes exist
if ! git remote get-url "$REMOTE_UPSTREAM" &>/dev/null; then
  echo "[ERROR] Remote '$REMOTE_UPSTREAM' not found."
  echo "        Add it with: git remote add upstream https://github.com/paperclipai/paperclip.git"
  exit 1
fi

if ! git remote get-url "$REMOTE_ORIGIN" &>/dev/null; then
  echo "[ERROR] Remote '$REMOTE_ORIGIN' not found."
  echo "        Add it with: git remote add origin git@github.com:ahmed-zhran/paper-clip.git"
  exit 1
fi

# Stash any local changes if present
STASHED=false
if ! git diff --quiet || ! git diff --cached --quiet; then
  echo "→ Stashing local changes..."
  git stash push -m "update.sh auto-stash $(date '+%Y-%m-%d %H:%M')"
  STASHED=true
  echo ""
fi

echo "→ Fetching upstream ($REMOTE_UPSTREAM)..."
git fetch "$REMOTE_UPSTREAM" 2>&1 | sed 's/^/  /'
echo ""

echo "→ Rebasing $BRANCH onto $REMOTE_UPSTREAM/$BRANCH..."
git rebase "$REMOTE_UPSTREAM/$BRANCH" 2>&1 | sed 's/^/  /'
echo ""

echo "→ Pushing to origin..."
git push "$REMOTE_ORIGIN" "$BRANCH" 2>&1 | sed 's/^/  /'
echo ""

if [ "$STASHED" = true ]; then
  echo "→ Restoring stashed changes..."
  git stash pop 2>&1 | sed 's/^/  /' || echo "  (no stash to pop — already applied or conflict resolved)"
  echo ""
fi

echo "━━━ Update complete ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Your fork is now up to date with paperclipai/paperclip ($BRANCH)."
echo ""
echo "After updating, if Paperclip's dependencies changed, run:"
echo "  pnpm install && pnpm build"
echo ""
