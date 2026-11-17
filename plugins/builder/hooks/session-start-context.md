<builder-routing>
The builder skill pack is installed.

Invoke the `builder:builder-mode` skill and follow it when a task meets any of these:

- it touches more than one file, or changes a signature other files call
- it involves a design or architecture choice
- it is a bug whose cause is not yet known

For smaller tasks, such as a contained change to one file with an obvious check, a question, or a one-line edit, work directly and verify on the real artifact.

When the intent is already specific, enter that skill directly: `builder:init`, `builder:tdd`, `builder:how`, `builder:why`, `builder:correct`, `builder:create-verification-skill`.

User instructions (CLAUDE.md, AGENTS.md, direct requests) take precedence. Run `/builder:setup-builder` to turn this hook off.
</builder-routing>
