---
name: init
description: Set up the builder pack in a project. Configures models and the session hook, offers a verify skill with a feature map, and writes a managed builder section into AGENTS.md (with a CLAUDE.md import) after the user approves the diff. Use for /builder:init, "init builder", or setting up builder in a new or existing repo.
---

# Init

Set up the builder pack for the current repository in one pass. Each step is safe to re-run. Nothing outside the `<!-- builder:start -->` / `<!-- builder:end -->` markers in AGENTS.md is ever changed, and no file is written before the user approves it.

Do not fill in commands or patterns. The template leaves them as `TODO` on purpose: the project's language and framework are not assumed, and rows get filled once a command has actually run (the Commands rule in the block says so).

## Steps

Track these as todolist items. A step you skip stays with `skip: <reason>`.

### 1. Preflight

- Find the repository root (`git rev-parse --show-toplevel`; fall back to the working directory and say so).
- Read the root `AGENTS.md` and `CLAUDE.md` if they exist. Note whether AGENTS.md already has a builder block and whether CLAUDE.md already imports `@AGENTS.md`.
- Look for an architecture doc: `ARCHITECTURE.md`, `docs/ARCHITECTURE.md`, `docs/architecture.md`, or another file under `docs/` whose name contains `architecture`.
- Look for a known-issues doc: `KNOWN_ISSUES.md`, `docs/KNOWN_ISSUES.md`, `docs/known-issues.md`, or a similar name.
- Check for an existing verify skill: `.claude/skills/verify/SKILL.md` or `.claude/skills/verify-*/SKILL.md`.

### 2. Models and hook

Run the **setup-builder** skill (`../setup-builder/SKILL.md`). If its sheet already exists and the user does not want changes, skip with that reason. Stop setup-builder before its own final step that offers a verification skill; step 3 below handles that.

### 3. Verify skill and feature map

If a verify skill exists, skip with `skip: verify skill exists at <path>` and suggest `/builder:maintain-verification-skill` when its feature map looks stale.

Otherwise ask once with `AskUserQuestion`: generate one now with **create-verification-skill** (`../create-verification-skill/SKILL.md`), or skip. It needs the app to build and start; if the checkout cannot start yet, offer to skip and come back. If the user agrees, run that skill to completion, including its end-to-end proof run.

### 4. Ask about the optional docs

Ask both questions in one `AskUserQuestion` call:

- **Architecture doc.** When one was found, its path is used. When none was found, offer: create a short `docs/ARCHITECTURE.md` stub (module boundaries and patterns, left as headings with TODO comments), or omit the architecture rule. Recommend omitting for a repository with no real module boundaries yet.
- **Known-issues doc.** When one was found, its path is used. When none was found, offer: create an empty `docs/KNOWN_ISSUES.md` from the entry format below, or omit the known-issues rules.

Known-issues entry format, used for the stub:

```markdown
# Known issues

<!-- One entry per issue. Newest first. Remove an entry when the fix ships. -->

## <Short symptom>

- Symptom: what you see
- Cause: what is known, or "unknown"
- Workaround: how to get past it today
- Status: open / fix planned / won't fix
- Links: issue, PR, or commit
```

### 5. Build the block

Read [references/agents-block.md](references/agents-block.md). Fill the two placeholders, each with a trailing newline when it is not empty:

- `{{ARCHITECTURE_RULE}}`: with an architecture doc at `<path>`, use
  `- When a change adds a module, crosses module boundaries, or changes a shared interface: read \`<path>\` first and stay inside its boundaries. If a boundary must move, use \`builder:architect\` and update the doc in the same change.`
  Otherwise an empty string.
- `{{KNOWN_ISSUES_RULES}}`: with a known-issues doc at `<path>`, use two lines:
  `- When a behavior looks wrong or a test fails unexpectedly: search \`<path>\` before debugging.`
  `- When you find an issue you won't fix in this task: add an entry to \`<path>\`.`
  Otherwise an empty string.

Leave every `TODO` row and comment as it is.

### 6. Show the diff and get approval

Compute the proposed changes without writing them:

- **AGENTS.md missing:** a new file with `# AGENTS.md` and one line saying what the project is (from the README's first paragraph, or `TODO: one line about this project`), followed by the block.
- **AGENTS.md without a block:** the existing content unchanged, then a blank line, then the block appended at the end.
- **AGENTS.md with a block:** only the text between the markers replaced. When the user edited rows inside the old block (filled commands, patterns, or Do-not-touch entries), carry those edits into the new block instead of resetting them to `TODO`.
- **CLAUDE.md missing:** a new file whose only line is `@AGENTS.md`.
- **CLAUDE.md without the import:** `@AGENTS.md` added as its first line.
- **CLAUDE.md with the import:** no change.
- Any doc stubs chosen in step 4.

Show the user a unified diff of every file (`diff -u` against the current file, or against `/dev/null` for a new one). Ask with `AskUserQuestion`: write all, change something, or cancel. On "change", revise and show the diff again. Write only after "write all".

### 7. Report

Reply with:

- what was written, one line per file
- the verify skill status and which features its map covers
- what is still TODO: the Commands and Patterns rows, the Do-not-touch section, and any stub doc
- the next step: run the first real task with `/builder:builder-mode`, and fill each Commands row the first time that command succeeds

## Models

Init runs in the main session. The skills it calls use their own Models sections.
