# NOTICE

builder-stack is a trimmed derivative of MIT-licensed work. Every upstream work uses the same MIT text, so [LICENSE](LICENSE) carries all of their copyright notices in one file.

## Upstream sources

| Included work | Upstream | Copyright | License |
| --- | --- | --- | --- |
| `builder-mode` (from `poteto-mode`), its playbooks and `bugbot-triage.md`, `how`, `why`, `architect`, `arena`, `interrogate`, `swarm`, `unslop`, `technical-writing`, `no-comments`, `benchmark-checklist`, `show-me-your-work`, `figure-it-out`, `tdd`, `correct`, `in-your-own-words`, `create-verification-skill`, `maintain-verification-skill`, every `principle-*` skill, `builder-agent` (from `poteto-agent`), `comment-sicko` | [cursor/plugins/pstack](https://github.com/cursor/plugins/tree/main/pstack) | (c) 2026 Lauren Tan | MIT |
| `deslop` | [cursor/plugins/cursor-team-kit](https://github.com/cursor/plugins/tree/main/cursor-team-kit) | (c) 2026 Cursor | MIT |
| Claude Code port of all of the above, `setup-builder` (from `setup-pstack`), the SessionStart hook design | [michael-denyer/pstack-claude @ a12b047](https://github.com/michael-denyer/pstack-claude/tree/a12b04786023e762f12f5de7bb5fafb8c23f8c36) | (c) 2026 Michael Denyer | MIT |

## What changed

The modifications are (c) 2026 yongtao-wang under the same MIT license ([LICENSE](LICENSE)).

- Renamed `poteto-mode` to `builder-mode`, `poteto-agent` to `builder-agent`, `setup-pstack` to `setup-builder`, the plugin namespace `pstack:` to `builder:`, and the model sheet `pstack-models.md` to `builder-models.md`.
- Kept three playbooks (Investigation, Bug fix, Feature) and the Opening a PR step they call. Removed the other playbooks and every trigger that routed to them. `figure-it-out` is the fallback when no playbook fits.
- Kept only skills that the core set references directly. Removed every non-Claude-Code platform mapping.
- Rewrote the SessionStart hook as a small shell script with the same `session hook: off` switch.
- Added `init`, which writes a managed builder section into AGENTS.md after the user approves the diff.
- Added a plan-approval gate to the Bug fix and Feature playbooks, a known-issues lookup to Bug fix, a docs-update step to both, and a failing-test-first step to Feature. Broadened `tdd` to cover behavior changes.
- Moved `claude-project-dir.mjs` from `reflect` to `show-me-your-work`, the only included skill that calls it.
