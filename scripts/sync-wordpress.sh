#!/usr/bin/env bash
# Vendor WordPress/agent-skills into plugins/wordpress-skills/skills.
# Usage: scripts/sync-wordpress.sh [--push]
set -euo pipefail

UPSTREAM="https://github.com/WordPress/agent-skills.git"
BRANCH="trunk"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DEST="$ROOT/plugins/wordpress-skills"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

git clone -q --depth 1 --branch "$BRANCH" "$UPSTREAM" "$TMP/up"
SHA="$(git -C "$TMP/up" rev-parse HEAD)"

mkdir -p "$DEST/.claude-plugin"
rm -rf "$DEST/skills"
cp -R "$TMP/up/skills" "$DEST/skills"
cp "$TMP/up/LICENSE" "$DEST/LICENSE"

cat > "$DEST/.claude-plugin/plugin.json" <<EOF
{
  "name": "wordpress-skills",
  "description": "WordPress development skills vendored from WordPress/agent-skills (GPL-2.0-or-later)",
  "author": { "name": "WordPress Contributors" },
  "homepage": "https://github.com/WordPress/agent-skills",
  "license": "GPL-2.0-or-later"
}
EOF

cat > "$DEST/UPSTREAM.md" <<EOF
Vendored from $UPSTREAM
Branch: $BRANCH
Commit: $SHA
Synced by scripts/sync-wordpress.sh. Do not edit files here by hand.
EOF

cd "$ROOT"
git add -A plugins/wordpress-skills
if git diff --cached --quiet; then
  echo "Already up to date at ${SHA:0:7}"
  exit 0
fi
git commit -q -m "Sync wordpress-skills from upstream ${SHA:0:7}"
echo "Committed sync to upstream ${SHA:0:7}"
if [ "${1:-}" = "--push" ]; then git push -q origin HEAD && echo "Pushed"; fi
