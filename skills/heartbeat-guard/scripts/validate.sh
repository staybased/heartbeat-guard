#!/usr/bin/env bash
# Heartbeat Guard — validates HEARTBEAT.md and backs up before overwrites
set -euo pipefail

WORKSPACE="${OPENCLAW_WORKSPACE:-$(cd "$(dirname "$0")/../../.." && pwd)}"
HB="$WORKSPACE/HEARTBEAT.md"
HISTORY="$WORKSPACE/memory/heartbeat-history"
LIMIT=1500
ACTION="${1:-check}"

mkdir -p "$HISTORY"

# backup: snapshot current HEARTBEAT.md before a rewrite
if [ "$ACTION" = "backup" ] && [ -f "$HB" ]; then
  TS=$(date +%Y-%m-%d-%H%M%S)
  cp "$HB" "$HISTORY/heartbeat-$TS.md"
  echo "📸 Backed up to memory/heartbeat-history/heartbeat-$TS.md"
fi

# validate size
if [ ! -f "$HB" ]; then
  echo "⚠️  HEARTBEAT.md not found at $HB"
  exit 1
fi

SIZE=$(wc -c < "$HB" | tr -d ' ')
echo "HEARTBEAT.md: ${SIZE}/${LIMIT} chars"

if [ "$SIZE" -gt "$LIMIT" ]; then
  echo "🚨 OVER BUDGET by $(( SIZE - LIMIT )) chars — rewrite immediately!"
  exit 1
else
  echo "✅ Under budget ($(( LIMIT - SIZE )) chars headroom)"
  exit 0
fi
