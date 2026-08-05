# Links every skill in this repo into local agent skill directories.
# Windows edition: copies by default, or creates directory junctions with -Mode Junction.

param(
  [ValidateSet('Copy', 'Junction')]
  [string]$Mode = 'Copy',
  [string[]]$Destination = @((Join-Path $env:USERPROFILE '.codex\skills')),
  [switch]$IncludeClaude,
  [switch]$IncludeAgents,
  [switch]$Force
)

$ErrorActionPreference = 'Stop'

$repo = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
$skillRoot = Join-Path $repo 'skills'

if ($IncludeClaude) {
  $Destination += Join-Path $env:USERPROFILE '.claude\skills'
}
if ($IncludeAgents) {
  $Destination += Join-Path $env:USERPROFILE '.agents\skills'
}

$skills = Get-ChildItem -LiteralPath $skillRoot -Directory -Recurse |
  Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName 'SKILL.md') -PathType Leaf } |
  Where-Object {
    $_.FullName -notmatch '\\deprecated\\' -and
    $_.FullName -notmatch '\\node_modules\\'
  } |
  Sort-Object { $_.Name }

foreach ($destRoot in ($Destination | Select-Object -Unique)) {
  New-Item -ItemType Directory -Path $destRoot -Force | Out-Null

  foreach ($skill in $skills) {
    $target = Join-Path $destRoot $skill.Name

    if (Test-Path -LiteralPath $target) {
      if (-not $Force) {
        throw "Target already exists: $target. Re-run with -Force to replace it."
      }
      $existing = Get-Item -LiteralPath $target -Force
      if ($existing.Attributes -band [System.IO.FileAttributes]::ReparsePoint) {
        [System.IO.Directory]::Delete($target)
      } else {
        Remove-Item -LiteralPath $target -Recurse -Force
      }
    }

    if ($Mode -eq 'Junction') {
      New-Item -ItemType Junction -Path $target -Target $skill.FullName | Out-Null
      Write-Host "jlinked $($skill.Name) -> $($skill.FullName) ($destRoot)"
    } else {
      Copy-Item -LiteralPath $skill.FullName -Destination $target -Recurse -Force
      Write-Host "copied $($skill.Name) -> $target"
    }
  }
}
