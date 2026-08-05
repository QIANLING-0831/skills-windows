---
name: obsidian-vault
description: Search, create, and manage notes in the Obsidian vault with wikilinks and index notes. Use when user wants to find, create, or organize notes in Obsidian.
---

# Obsidian Vault

## Vault location

Windows default: `D:\Obsidian Vault\AI Research\`

Override it per machine or per run with the environment variable `OBSIDIAN_VAULT`.

Mostly flat at root level.

## Naming conventions

- **Index notes**: aggregate related topics (e.g., `Ralph Wiggum Index.md`, `Skills Index.md`, `RAG Index.md`)
- **Title case** for all note names
- No folders for organization - use links and index notes instead

## Linking

- Use Obsidian `[[wikilinks]]` syntax: `[[Note Title]]`
- Notes link to dependencies/related notes at the bottom
- Index notes are just lists of `[[wikilinks]]`

## Workflows

### Search for notes

```powershell
$vault = $env:OBSIDIAN_VAULT
if (-not $vault) { $vault = 'D:\Obsidian Vault\AI Research' }

# Search by filename
Get-ChildItem -LiteralPath $vault -Filter *.md -Recurse |
  Where-Object { $_.Name -match 'keyword' }

# Search by content
Get-ChildItem -LiteralPath $vault -Filter *.md -Recurse |
  Select-String -Pattern 'keyword' -List
```

Or use `rg "keyword" "D:\Obsidian Vault\AI Research" -g "*.md"` if `rg` is installed.

### Create a new note

1. Use **Title Case** for filename
2. Write content as a unit of learning (per vault rules)
3. Add `[[wikilinks]]` to related notes at the bottom
4. If part of a numbered sequence, use the hierarchical numbering scheme

### Find related notes

Search for `[[Note Title]]` across the vault to find backlinks:

```powershell
Get-ChildItem -LiteralPath $vault -Filter *.md -Recurse |
  Select-String -SimpleMatch -Pattern '[[Note Title]]' -List
```

### Find index notes

```powershell
Get-ChildItem -LiteralPath $vault -Filter '*Index*.md' -Recurse
```
