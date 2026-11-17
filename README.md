# builder-stack

**English** | [简体中文](README.zh-CN.md)

A lean, verification-first Claude Code skill pack for small and medium projects. It is trimmed from [pstack-claude](https://github.com/michael-denyer/pstack-claude), the Claude Code port of Lauren Tan's [pstack](https://github.com/cursor/plugins/tree/main/pstack), and keeps only the core loop: plan, build, prove it works.

## Install

```text
/plugin marketplace add yongtao-wang/builder-stack
/plugin install builder@builder-stack
```

Restart Claude Code or open a new session afterward. For a private repository, Claude Code needs access to your GitHub (for example, `gh` signed in locally or git credentials configured).

To update, run `/plugin marketplace update builder-stack`. If the plugin does not update on its own, update it from `/plugin`. To uninstall, run `/plugin uninstall builder@builder-stack`.

Then run this once from the project root:

```text
/builder:init
```

Init does the following, and asks before it writes any file:

1. Configures models and the SessionStart hook (via `setup-builder`).
2. Offers to generate a verify skill and feature map (via `create-verification-skill`).
3. Looks for an architecture doc and a known-issues doc. When one is missing, it asks whether to create a stub or leave out the matching rule.
4. Appends a section wrapped in `<!-- builder:start -->` and `<!-- builder:end -->` to `AGENTS.md`, and makes `CLAUDE.md` import `@AGENTS.md`. It shows the diff first.

The section holds a Commands table, a Patterns table, conditional "When…" rules, and an empty Do-not-touch list. Commands and Patterns start as `TODO`, because init does not assume a language or framework. The agent fills a row the first time that command succeeds. Re-running init replaces only the text between the markers. Everything else you wrote stays untouched.

## Everyday use

```text
/builder:builder-mode Login sometimes bounces back to the home page. Reproduce it first, then fix and verify.
/builder:builder-mode Add CSV export. Don't change the existing API.
/builder:builder-mode Find out why the cache survives logout. Don't change code yet.
```

builder-mode matches the request to a playbook, copies its steps into the task list verbatim, and requires evidence before it reports done.

**Plan first, then build.** The Bug fix and Feature playbooks do read-only research, write a plan, and wait for your approval before they change code. The plan covers the goal, falsifiable done criteria, the files to change, the failing test to write first, how it will be verified, the docs to update, and the risks. To skip approval, say "autonomous" or "no plan approval" in the prompt. You can also press Shift+Tab to enter Claude Code's plan mode before you invoke builder-mode.

The mode is sticky: "continue" stays on the same playbook. Say "new task" when you switch topics.

A good prompt states three things: the goal, what done looks like, and what must not change.

## What's included

**Core**

| Skill | Purpose |
| --- | --- |
| `init` | Sets up builder in a project in one pass, including the AGENTS.md section |
| `builder-mode` | Entry point and router, with the Investigation, Bug fix, and Feature playbooks and the closing Opening a PR step |
| `create-verification-skill` | Generates `.claude/skills/verify/` and its feature map for the project |
| `correct` | Finds a mistake the agent keeps making and blocks it with architecture, types, lint, or tests |
| `tdd` | Writes the failing test first, then the fix |
| `how` | Explains how a subsystem works and where a change belongs |

**Skills the core references directly**

| Skill | Referenced by |
| --- | --- |
| `why` | Bug fix, Investigation |
| `architect` | builder-mode, Bug fix, Feature |
| `arena` | Feature (required when the implementation has several valid shapes), architect |
| `interrogate` | builder-mode, Feature |
| `in-your-own-words` | interrogate |
| `swarm` | builder-mode |
| `figure-it-out` | builder-mode (when no playbook fits) |
| `show-me-your-work` | builder-mode (long or unattended runs) |
| `unslop`, `technical-writing`, `deslop`, `no-comments` | builder-mode, Opening a PR |
| `benchmark-checklist` | builder-mode (before reporting a performance number) |
| `maintain-verification-skill` | create-verification-skill, init |
| `setup-builder` | builder-mode model configuration, init |
| 24 `principle-*` skills | builder-mode's principles index |
| Subagents `builder-agent`, `comment-sicko` | builder-mode, no-comments |

## Keeping costs down

`arena`, `architect`, and `interrogate` run several models at once. By default that is one run each on opus, fable, sonnet, and haiku. For a small or medium project, cut these roles to one or two models in `/builder:setup-builder`, or say "don't use arena" in the prompt.

Small tasks, such as a contained change to one file with an obvious check or a one-line edit, don't need builder-mode.

## License

MIT. All upstream copyright notices and license files are kept. See [NOTICE.md](NOTICE.md).
