---
name: heartbeat-guard
version: 1.0.0
description: Prevents HEARTBEAT.md from exceeding the bootstrap character budget
author: staybased
---

# Heartbeat Guard

HEARTBEAT.md is loaded during bootstrap alongside AGENTS.md, SOUL.md, USER.md, TOOLS.md, and IDENTITY.md. If it exceeds the budget, **all other bootstrap files get truncated or skipped**, breaking your ability to function.

## Hard Limits

- **Max HEARTBEAT.md size: 1500 characters** (budget ceiling is 1664; this leaves headroom)
- Validate AFTER every write: `wc -c HEARTBEAT.md` — if >1500, rewrite immediately
- Run `bash skills/heartbeat-guard/scripts/validate.sh` after any HEARTBEAT.md edit

## What Belongs in HEARTBEAT.md

HEARTBEAT.md answers ONE question: **"What do I do when I get a heartbeat poll?"**

✅ Include:
- Ordered sequence of steps (health check, task pick, log)
- Hard rules (safety rails, budget limits, escalation triggers)
- File paths you need to read (task lists, memory files)

❌ Does NOT belong (put these elsewhere):
- Detailed priority ladders → task list or AGENTS.md
- Motivational text → SOUL.md
- Tool commands/references → TOOLS.md
- Explanations of why steps exist → AGENTS.md
- Sub-agent orchestration details → AGENTS.md

## Writing Rules

1. **Always full-rewrite** — never append to HEARTBEAT.md. Read it, decide what the new version should say, write the whole file.
2. **Use compact format** — terse bullet points, no prose paragraphs, no redundant headers.
3. **Merge related steps** — combine steps that always run together.
4. **No blank lines between bullets** — every line costs bytes.
5. **Abbreviate paths** — use relative paths from workspace root.

## Compact Template (≈900 chars target)

```markdown
# HEARTBEAT.md — Work Loop

## Sequence:
### 1. Health
- Check watchdog/health scripts — run if stale

### 2. Review (every ~4h)
- Check memory files for staleness → refresh if needed
- Check inbox or notes for new input from your human

### 3. One Task
- Read your task list → first active unchecked item
- All done/blocked → promote next queued item. Empty → pick useful work.
- One chunk, max ~5 min. Spawn max 1 sub-agent.
- Needs human input → mark blocked, pick next

### 4. Log
- Update task list, git commit, post to logs channel if shipped

## Rules
- No public posts or spending without human approval
- Stuck 3 heartbeats on same task → flag and move on
- Short responses. Use local LLMs for simple tasks.
```

## Backup Protocol

Before every HEARTBEAT.md rewrite, run:
```
bash skills/heartbeat-guard/scripts/validate.sh backup
```
This snapshots the current version to `memory/heartbeat-history/heartbeat-YYYY-MM-DD-HHMMSS.md` before you overwrite it. Full history is preserved locally for context and audit.

## Recovery

If you discover HEARTBEAT.md is over budget:
1. Run `bash skills/heartbeat-guard/scripts/validate.sh`
2. Rewrite using the template above as a starting point
3. Verify with `wc -c` before committing
