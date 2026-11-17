---
name: setup-builder
description: Configure which models the builder pack uses per role. Detects available models and writes the override sheet. Use for /setup-builder, "configure builder models", changing the builder pack's model choices, or turning the SessionStart hook on or off.
---

# Setup builder

Write the per-role model override sheet. Each builder skill names a default model inline; the override sheet adapts those defaults to the models you actually have access to.

On Claude Code the config directory is `$CLAUDE_CONFIG_DIR` when that variable is set and `~/.claude` otherwise. This skill calls it `<config>`, and the user sheet is `<config>/builder-models.md`. A project sheet, `.claude/builder-models.md` at the repository root (`git rev-parse --show-toplevel`; outside a repository, the directory Claude Code starts in), is committed with the repository and replaces the user sheet in that project. The session hook reads it whenever it exists. The model rows defer to it through the line step 6 writes under its heading, so a hand-written project sheet needs that line too. Claude Code has no auto-applied "rules" mechanism like Cursor's `.mdc`, so inclusion is explicit: the user adds a line to `<config>/CLAUDE.md` such as:

```text
@<config>/builder-models.md
```

with `<config>` written as the resolved path, so the file is loaded as context for every session. A project sheet loads from `@.claude/builder-models.md` in the `CLAUDE.md` at the repository root.

## Steps

### 1. Detect available models

Enumerate the model names the `Agent` tool's `model` parameter accepts in this session. That is the dependable source. On Claude Code they are the family names listed in [Models](#models) below, each running that family's current model, and a full model ID is rejected. The default panel is listed there too. The panel is chosen for cross-family diversity. Ask the user to confirm or paste any additional slugs they want available. Never write a real slug you have not confirmed is available. The aliases `inherit-parent` and `auto` are always valid even though they are not detected slugs. Both mean the role runs on the parent session's model, which the `Agent` call expresses by omitting `model`.

### 2. Load current state

On Claude Code, first ask whether to configure the user sheet, for every project, or the project sheet, for this repository on any machine. The rest of the steps use the chosen sheet.

The default role-to-model mapping is the rule shape shown in the Write the override sheet step below. If the sheet already exists, read it and treat its values as the current choices. Otherwise start from those defaults. A line whose role is not in that shape, such as `how critics`, is from a retired role. Drop it. An older sheet may name full model IDs that start with `claude-`, which the `Agent` tool rejects. Replace each with its family name, the word after `claude-`.

### 3. Map and confirm

Show every role with its current model, marking any real slug not in the detected set as needing a choice. Also list each line step 2 dropped or rewrote. Ask whether to accept as-is or change specific roles, offering the detected models plus `inherit-parent` and `auto` as the options. Prefer `AskUserQuestion` over free text. For panel roles (arena runners, architect runners, interrogate reviewers) the value is a list, and one subagent runs per entry, alias entries included, so the list length sets the count. `arena cross-judge pool` is also a list, but Arena runs one judge. It tries only values from a family other than the parent's, in list order, so order it by preference. An `inherit-parent` or `auto` value never judges. `swarm workers` is the default model for every worker unless a race or comparison assigns another model per arm.

Then ask for the default reasoning effort, the `default effort` line. It is `session`, which keeps the parent session's effort, or one of the levels in [Models](#models). Start from the default listed there. Every role value without a suffix runs at it. Then ask whether any role should run at another level. A role value may carry one after its slug, as in `<slug> @xhigh`; panel entries take their own, as in `<slug> @xhigh, <slug> @max`. Each level is passed as the dispatch's effort, so the choice holds without changing the session. Leave the suffix off for the default effort.

### 4. Choose whether the session hook routes tasks

On Claude Code, the plugin's `SessionStart` hook injects the builder-mode mandate on startup, resume, clear, and compact. Ask whether to keep the hook. The default is on. The answer is the `session hook` line in the sheet: `on` or `off`. With no sheet or no line, the hook injects. 

### 5. Validate

Every real slug written must be in the detected set. `inherit-parent` and `auto` always pass. Validate the slug without any `@<level>` suffix, and the level against the effort levels in [Models](#models). The `default effort` value is one of those levels or `session`. If a chosen real slug or level is not available, stop and ask again.

### 6. Write the override sheet

Write the sheet with the shape below. Overwrite the whole file so re-runs stay idempotent. A project sheet also gets this line under its heading, so a session that loads both sheets knows which one counts: `This project's sheet. In this repository it replaces the user's builder-models.md; ignore that sheet's lines.`

```markdown
# builder model configuration

Per-role model overrides for builder skills. Each builder SKILL.md names its defaults in a Models section; the values here override those defaults. Delete a line to fall back to the skill default. A value of `inherit-parent` or `auto` runs that role on the parent session's model (the `Agent` call omits `model`); an alias entry in a panel list still counts toward that panel's fan-out. A model may carry a reasoning effort, as in `opus @xhigh` (levels: low, medium, high, xhigh, max); the role's subagent then runs at that level, each entry of a panel list on its own. `default effort` sets the level for a value without one; `session` keeps the parent session's effort. `session hook: off` stops the builder routing hook from injecting the builder-mode mandate; any other value, or no line, leaves it on.

feature, refactoring: sonnet
bug-fix: opus
judgment and prose: opus
strongest judgment: fable
how explorer: opus
how explainer: opus
why investigators: opus
why synthesizer: opus
arena runners: opus, fable, sonnet, haiku
arena cross-judge pool: opus, fable, sonnet, haiku
swarm workers: opus
architect runners: opus, fable, sonnet, haiku
interrogate reviewers: opus, fable, sonnet, haiku
no-comments reviewer: opus

default effort: session
session hook: on
```

### 7. Wire it in

On Claude Code, if `<config>/CLAUDE.md` does not already include `<config>/builder-models.md`, append an `@` line naming the sheet's resolved path, such as `@~/.claude/builder-models.md`, so the model rows load on every session. For a project sheet, append `@.claude/builder-models.md` to the `CLAUDE.md` at the repository root instead, if it is not there, and tell the user to commit both files.

### 8. Confirm

Tell the user where the override was written, how its model rows load, and whether the plugin hook is on. Re-running this skill updates the override sheet.

### 9. Offer a verification skill (optional)

Check whether the project has a way to drive the real app for proof (a project `verify` or `verify-*` skill, or an existing harness). If not, offer once: "want a project-local verification skill, so agents can drive the app the way a user does and prove changes work? I can generate one with /create-verification-skill." On yes, invoke [`/create-verification-skill`](../create-verification-skill/SKILL.md). On no, move on without pushing.

## Models

- Available Claude models: `opus`, `fable`, `sonnet`, `haiku`
- Default panel: `opus`, `fable`, `sonnet`, `haiku`
- Reasoning effort levels: `low`, `medium`, `high`, `xhigh`, `max`
- Default reasoning effort: `session`
- Single-role default: `opus`
