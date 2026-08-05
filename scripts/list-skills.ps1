$ErrorActionPreference = 'Stop'

$repo = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
$skillRoot = Join-Path $repo 'skills'

Get-ChildItem -LiteralPath $skillRoot -Recurse -Filter SKILL.md -File |
  Where-Object {
    $_.FullName -notmatch '\\deprecated\\' -and
    $_.FullName -notmatch '\\node_modules\\'
  } |
  ForEach-Object { $_.FullName.Substring($skillRoot.Length + 1) } |
  Sort-Object
