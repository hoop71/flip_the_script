# Claude Code Safety Guide

How to use Claude Code safely, and how permissions are structured.

---

## The Three Layers

Claude Code merges permissions from three files. All `allow` lists are unioned together. All `deny` lists are unioned together. **Deny always wins** — no lower layer can override a deny from a higher one.

```
~/.claude/settings.json              YOU, all projects (your developer toolkit)
         +
.claude/settings.json                THIS REPO, all contributors (committed to git)
         +
.claude/settings.local.json          YOU, THIS REPO only (never committed)
─────────────────────────
= Final permissions
```

### Layer 1: Global (`~/.claude/settings.json`)

**What goes here:** Every tool YOU use across any project — your languages, your shell toolkit, your container tools. Set this up once and forget it.

**Who maintains it:** Each developer individually.

**Example — a full-stack developer:**

```json
{
  "permissions": {
    "allow": [
      "Read", "Edit", "Write", "Glob", "Grep",
      "Bash(git *)", "Bash(gh *)",
      "Bash(ls *)", "Bash(mkdir *)", "Bash(cat *)", "Bash(grep *)",
      "Bash(jq *)", "Bash(curl *)",
      "Bash(node *)", "Bash(pnpm *)", "Bash(npm *)", "Bash(npx *)",
      "Bash(python3 *)", "Bash(pip3 *)", "Bash(pytest *)",
      "Bash(cargo *)", "Bash(rustc *)",
      "Bash(docker *)", "Bash(kubectl *)"
    ],
    "deny": [
      "Bash(git push --force*)",
      "Bash(git reset --hard*)",
      "Bash(rm -rf /*)"
    ]
  }
}
```

**Example — a frontend developer:**

```json
{
  "permissions": {
    "allow": [
      "Read", "Edit", "Write", "Glob", "Grep",
      "Bash(git *)", "Bash(gh *)",
      "Bash(ls *)", "Bash(cat *)", "Bash(grep *)",
      "Bash(node *)", "Bash(pnpm *)", "Bash(npx *)", "Bash(bun *)"
    ],
    "deny": [
      "Bash(git push --force*)",
      "Bash(git reset --hard*)"
    ]
  }
}
```

A Rust developer would add `cargo`, `rustc`, `clippy-driver`. A data engineer would add `python`, `uv`, `dbt`. **You only allow what you actually use.**

### Layer 2: Project (`.claude/settings.json`)

**What goes here:** Only tools THIS repo needs. For Olmo, that's pnpm and its specific tooling. A Rust repo would list `cargo`. A Python repo would list `uv` and `pytest`.

**Who maintains it:** The team, via PRs.

**Olmo's project settings:**

```json
{
  "permissions": {
    "allow": [
      "Bash(pnpm *)",
      "Bash(npx *)",
      "Bash(npx prisma *)",
      "Bash(npx biome *)",
      "Bash(npx playwright *)",
      "Bash(npx shadcn@latest *)"
    ],
    "deny": [
      "Bash(git push --force*)",
      "Bash(git reset --hard*)",
      "Bash(rm -rf /*)"
    ]
  }
}
```

This ensures that even a new contributor with zero global settings can at least run the project's own toolchain without friction.

### Layer 3: Local (`.claude/settings.local.json`)

**What goes here:** Personal tools for this repo that don't apply to everyone — secrets managers, kill commands, custom hooks.

**Who maintains it:** Each developer. Never committed.

```json
{
  "permissions": {
    "allow": [
      "Bash(op run *)",
      "Bash(rm *)"
    ]
  },
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "npx biome format --write \"$CLAUDE_FILE_PATH\""
          }
        ]
      }
    ]
  }
}
```

---

## How It Adds Up (Example)

A developer with the full-stack global config working on Olmo gets:

```
Global allows:    git, shell, node, pnpm, npm, npx, python, cargo, docker, kubectl...
Project allows:   pnpm, npx, prisma, biome, playwright, shadcn
Local allows:     op run, rm

Global denies:    git push --force, git reset --hard, rm -rf /
Project denies:   git push --force, git reset --hard, rm -rf /
Local denies:     (none)

Final: union of all allows, union of all denies, deny wins.
```

They can run anything from any layer's allow list, but nothing from any layer's deny list.

---

## What to Put Where (Quick Reference)

| Tool | Where | Why |
|------|-------|-----|
| `git`, `gh` | Global | Everyone uses git |
| Shell basics (`ls`, `grep`, `jq`, etc.) | Global | Language-agnostic |
| `node`, `pnpm`, `cargo`, `python`, `kubectl` | Global | Per-developer skill set |
| `git push --force`, `git reset --hard` | Global deny | Universal guardrails |
| Project package manager (`pnpm *`) | Project | Ensures repo works for all contributors |
| Project-specific tools (`npx prisma *`) | Project | Specific to this codebase |
| K8s namespace deletes, docker prune | Global deny or project deny | Wherever K8s is used |
| Secrets manager (`op run *`) | Local | Personal credential flow |
| Auto-format hooks | Local | Personal editor preference |
| `rm`, `pkill` | Local | Personal risk tolerance |

---

## Permission Modes

Beyond settings, Claude Code has runtime modes:

| Mode | What it does | When to use |
|------|-------------|-------------|
| **Default** | Prompts on anything not in allow-lists | Normal work |
| **Plan mode** (`--mode plan`) | Claude proposes, you approve before execution | Big refactors, unfamiliar code |
| **Accept edits** (`--mode acceptEdits`) | Auto-approves file changes, prompts on bash | If your global settings already cover bash |
| **Bypass** (`--dangerously-skip-permissions`) | No prompts | CI only. **Never for real work.** |

---

## Deny List Philosophy

Deny rules are **team policy**. They should reflect destructive operations that are hard to reverse and affect shared state.

Good deny rules:
- `git push --force` — destroys remote history
- `git reset --hard` — destroys uncommitted work
- `kubectl delete namespace` — nukes everything in a namespace
- `docker system prune` — removes all unused resources
- `rm -rf /` — obvious

Bad deny rules:
- `git push` — too broad, blocks normal workflow
- `docker build` — not destructive
- `Bash(*)` — blocks everything

**To change a deny rule:** Open a PR, explain the rationale, get team consensus.

---

## Onboarding a New Developer

1. **Install Claude Code** — they get zero permissions by default
2. **Clone the repo** — project `.claude/settings.json` gives them the repo toolchain immediately
3. **Set up their global settings** — one-time setup of `~/.claude/settings.json` with their personal toolkit
4. **Optionally create local settings** — for personal tools and hooks

Step 2 is automatic. Steps 3-4 are a 5-minute one-time setup. Share this guide and the example configs above.

---

## Rules of Thumb

1. **Global = your identity as a developer.** Languages you know, tools you use.
2. **Project = what the repo needs.** Minimum viable permissions for any contributor.
3. **Local = your quirks.** Secrets managers, formatters, destructive commands you're comfortable with.
4. **Deny = team policy.** Hard stops that protect shared state.
5. **When in doubt, leave it out.** Developers can always add to their local settings.
6. **Never use bypass mode** for real work.
7. **Review before committing** — `git diff` is your friend.

---

## If Something Goes Wrong

| Situation | Recovery |
|-----------|----------|
| Unwanted file changes | `git checkout -- <file>` or `git stash` |
| Bad commit | `git reset HEAD~1` (keeps changes unstaged) |
| Pushed to wrong branch | `git revert <sha>` and push the revert |
| Runaway process | `Ctrl+C`, then `pkill` if needed |
| Unexpected behavior | Check all three settings files for stale/conflicting rules |
