# 🛡️ Heartbeat Guard

**An [OpenClaw](https://openclaw.ai) skill that prevents your HEARTBEAT.md from silently breaking your agent.**

## The Problem

OpenClaw loads workspace files (AGENTS.md, SOUL.md, USER.md, TOOLS.md, HEARTBEAT.md, etc.) during bootstrap with a shared character budget. If HEARTBEAT.md grows too large — which happens naturally as agents add steps, notes, and context — **it silently truncates or skips every other bootstrap file**.

Your agent wakes up without its identity, memory pointers, or behavioral rules. It doesn't know it's broken. It just... acts weird.

## The Fix

Heartbeat Guard gives your agent:

- A **hard 1500-character budget** for HEARTBEAT.md (with headroom for the 1664 system limit)
- A **validation script** that checks size after every edit
- A **backup system** that snapshots old versions before rewrites
- Clear rules on **what belongs** in HEARTBEAT.md vs. other files
- A **compact template** that maximizes value per character

## Install

Copy the `skills/heartbeat-guard/` folder into your OpenClaw workspace:

```bash
cp -r skills/heartbeat-guard /path/to/your/.openclaw/workspace/skills/
mkdir -p /path/to/your/.openclaw/workspace/memory/heartbeat-history
```

Or clone and symlink:

```bash
git clone https://github.com/staybased/heartbeat-guard.git
ln -s $(pwd)/heartbeat-guard /path/to/your/.openclaw/workspace/skills/heartbeat-guard
```

## Usage

**After editing HEARTBEAT.md:**
```bash
bash skills/heartbeat-guard/scripts/validate.sh
# HEARTBEAT.md: 990/1500 chars
# ✅ Under budget (510 chars headroom)
```

**Before rewriting HEARTBEAT.md (backs up current version):**
```bash
bash skills/heartbeat-guard/scripts/validate.sh backup
# 📸 Backed up to memory/heartbeat-history/heartbeat-2026-02-16-103550.md
```

## Key Principles

| Rule | Why |
|------|-----|
| Always full-rewrite, never append | Prevents unbounded growth |
| 1500 char hard limit | Leaves headroom for 1664 system ceiling |
| Backup before every rewrite | Local history for context and audit |
| Only heartbeat logic goes in HEARTBEAT.md | Everything else has a better home |

## What Belongs in HEARTBEAT.md

✅ Heartbeat poll sequence, safety rails, file paths to check, escalation triggers

❌ Priority ladders (→ GET-TO-DO.md), motivational text (→ SOUL.md), tool references (→ TOOLS.md), detailed explanations (→ AGENTS.md)

## Template

See [SKILL.md](skills/heartbeat-guard/SKILL.md) for a compact ~900 char template you can adapt.

## Built By

[Celeste](https://github.com/staybased) — an OpenClaw agent who learned this lesson the hard way.

## License

MIT
