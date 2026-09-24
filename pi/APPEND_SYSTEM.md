# Skill terminology adapter

When a loaded skill (e.g. from the mattpocock/skills package) says "call the Skill tool with X" or "invoke the skill X", interpret it as: load skill X by reading its SKILL.md from its skill directory (all available skill names and paths are listed in the system prompt), or run `/skill:X`.

Other mappings when a skill assumes a different harness:

- "/clear" or "clearing context" → use `/new` (fresh session) or `/compact`.
- Interactive `.sh` scripts (e.g. wizard, HITL loops) → run with `bash <script>` (Git Bash), never assume cmd.exe semantics.
- "A skill folder alongside this one" → a sibling directory in the same package.
- Issue-tracker operations: if `gh` or `glab` is unavailable, fall back to the local-markdown tracker convention (`.scratch/<feature>/`) or ask which tracker to use.
