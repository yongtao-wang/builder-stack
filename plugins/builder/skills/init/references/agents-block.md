<!-- builder:start -->
<!-- Managed by /builder:init. Re-running init replaces only the text between these markers. Edit freely; init shows a diff before it overwrites anything. -->

## Commands

<!-- Fill a row once the command has run successfully in this repo. Add rows for other tasks you run often. -->
| Task | Command |
|---|---|
| Setup | `TODO` |
| Test (one file) | `TODO` |
| Test (full suite) | `TODO` |
| Lint / format | `TODO` |
| Run the app | `TODO` |

## Patterns

<!-- One row per pattern a typical change needs. Point to a real file that shows it. Full rationale goes in the architecture doc. Enforce a rule with lint or a test when you can (`/builder:correct`). -->
| When you... | Follow |
|---|---|
| add an API endpoint | `TODO` (example file) |
| register a service or dependency | `TODO` |
| read or write data | `TODO` |

## Rules

- When you change behavior and a cheap local test exists: write the failing test first, watch it fail, then make it pass (`builder:tdd`). When no practical test exists, say why and verify with the `verify` skill instead.
- When you fix a bug: reproduce it first, confirm the cause with runtime evidence, then fix. The same reproduction must pass afterward.
{{KNOWN_ISSUES_RULES}}- When you change an existing feature: read its file under `.claude/skills/verify/features/` first.
{{ARCHITECTURE_RULE}}- When you finish a feature or change user-visible behavior, a command, a config option, or a public API: update the affected docs and the feature's file under `.claude/skills/verify/features/` in the same change.
- When a refactor or cleanup outside the task looks worthwhile: mention it, don't do it.
- When a task spans several files, needs a design choice, or is a bug with an unknown cause: use `/builder:builder-mode`, which plans and asks for approval before building. Otherwise work directly.
- When a command succeeds and its Commands row is `TODO` or wrong: update that row in the same change.
- When you are about to report done: show evidence from the real artifact (test output, a `verify` run). "It compiles" is not evidence.

## Do not touch

<!-- Add paths agents must not edit, one per line, with the reason. Example: - `migrations/`: generated, never hand-edit -->
<!-- builder:end -->
