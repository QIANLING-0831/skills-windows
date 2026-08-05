---
name: git-guardrails-claude-code
description: Set up Claude Code hooks to block dangerous git commands (push, reset --hard, clean, branch -D, etc.) before they execute on Windows. Use when user wants to prevent destructive git operations, add git safety hooks, or block git push/reset in Claude Code.
---

# Setup Git Guardrails

Sets up a PreToolUse hook that intercepts and blocks dangerous git commands before Claude executes them.

## What Gets Blocked

- `git push` (all variants including `--force`)
- `git reset --hard`
- `git clean -f` / `git clean -fd`
- `git branch -D`
- `git checkout .` / `git restore .`

When blocked, Claude sees a message telling it that it does not have authority to access these commands.

## Steps

### 1. Ask scope

Ask the user: install for **this project only** (`.claude/settings.json`) or **all projects** (`%USERPROFILE%\.claude\settings.json`)?

### 2. Copy the hook scripts

The bundled scripts are:

- [scripts/block-dangerous-git.cmd](scripts/block-dangerous-git.cmd)
- [scripts/block-dangerous-git.ps1](scripts/block-dangerous-git.ps1)

Copy both files to the target location based on scope:

- **Project**: `.claude/hooks/block-dangerous-git.cmd` and `.ps1`
- **Global**: `%USERPROFILE%\.claude\hooks\block-dangerous-git.cmd` and `.ps1`

No `chmod` is needed on Windows.

### 3. Add hook to settings

Add to the appropriate settings file:

**Project** (`.claude/settings.json`):

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": ".claude\\hooks\\block-dangerous-git.cmd"
          }
        ]
      },
      {
        "matcher": "PowerShell",
        "hooks": [
          {
            "type": "command",
            "command": ".claude\\hooks\\block-dangerous-git.cmd"
          }
        ]
      }
    ]
  }
}
```

**Global** (`%USERPROFILE%\.claude\settings.json`):

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "%USERPROFILE%\\.claude\\hooks\\block-dangerous-git.cmd"
          }
        ]
      },
      {
        "matcher": "PowerShell",
        "hooks": [
          {
            "type": "command",
            "command": "%USERPROFILE%\\.claude\\hooks\\block-dangerous-git.cmd"
          }
        ]
      }
    ]
  }
}
```

If the hook runner does not expand `%USERPROFILE%`, replace it with the user's full home path.

If the settings file already exists, merge the hook into existing `hooks.PreToolUse` array — don't overwrite other settings.

### 4. Ask about customization

Ask if user wants to add or remove any patterns from the blocked list. Edit the copied PowerShell script accordingly.

### 5. Verify

Run a quick test:

```powershell
.\block-dangerous-git.ps1 -Command "git push origin main"
```

Should exit with code 2 and print a BLOCKED message to stderr.
