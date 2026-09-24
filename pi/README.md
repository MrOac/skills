# Pi Coding Agent Setup

This repo's skills follow the [Agent Skills spec](https://agentskills.io/specification), and [Pi](https://github.com/earendil-works/pi-coding-agent) implements that spec natively — so the whole set works in Pi out of the box, with one small adapter for the harness-specific wording some skills use.

## One-step setup (per machine)

```bash
bash pi/setup.sh
```

The script:

1. Copies `pi/APPEND_SYSTEM.md` into `~/.pi/agent/` (backing up any existing file) — this is the terminology adapter, appended to Pi's system prompt every session.
2. Runs `pi install git:github.com/MrOac/skills` — declares the skill package in `~/.pi/agent/settings.json`.
3. Runs `pi update --extensions` — reconciles the checkout.

Restart Pi (or run `/reload`) and the skills are live: `/skill:ask-matt`, `/skill:grill-with-docs`, `/skill:tdd`, …

## Why the adapter is needed

Some skills were written for Claude Code/Codex and say things like "call the Skill tool with X" or "/clear". Pi has no Skill tool; it lists every skill's name and path in the system prompt and loads a skill when the model reads its `SKILL.md` (or via `/skill:name`). The adapter (`pi/APPEND_SYSTEM.md`) maps the wording once, in one place:

- "call the Skill tool with X" → load skill X (read its `SKILL.md`, or `/skill:X`)
- "/clear" → `/new` (or `/compact`)
- interactive `.sh` scripts → run with `bash <script>` (works on Windows via Git Bash)
- missing `gh`/`glab` → fall back to the local-markdown tracker (`.scratch/`)

Keeping the mapping in config instead of patching each skill means this fork can stay a pure mirror of upstream and re-sync without conflicts.

## Loading only the promoted skills

By default Pi discovers every `SKILL.md` under `skills/`, including `in-progress/` and `misc/`. To load only the promoted sets, use the package object form in `~/.pi/agent/settings.json`:

```json
{
  "packages": [
    {
      "source": "git:github.com/MrOac/skills",
      "skills": ["skills/engineering/*", "skills/productivity/*"]
    }
  ]
}
```

## Multi-machine sync

Keep this fork a pure mirror (no local commits), put the adapter in a separate git-tracked config (a small `pi-config` repo containing `APPEND_SYSTEM.md` + `settings.json` + the same `setup.sh` pattern), and each new machine is:

```bash
git clone https://github.com/<you>/pi-config && bash pi-config/setup.sh
```

Updates flow one way: upstream → fork (`git merge upstream/main`), then `pi update --extensions` on each machine.

## Caveats

- Skills with `disable-model-invocation: true` (`grill-me`, `triage`, `wait-what`, …) are intentional: call them explicitly via `/skill:name`.
- `triage`, `to-tickets`, and `wayfinder` need the `gh` CLI for GitHub Issues (`glab` for GitLab); without it, choose the local-markdown tracker in `/skill:setup-matt-pocock-skills`.
- `wizard` and `diagnosing-bugs` generate interactive bash scripts; on Windows run them with Git Bash.
