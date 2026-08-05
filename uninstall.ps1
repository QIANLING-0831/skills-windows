param(
  [string]$Target = (Join-Path $env:USERPROFILE '.codex\skills'),
  [switch]$WhatIf
)

$ErrorActionPreference = 'Stop'

$expectedRoot = Join-Path $env:USERPROFILE '.codex\skills'
if (-not (Test-Path -LiteralPath $Target -PathType Container)) {
  Write-Host "Nothing to uninstall: $Target does not exist."
  exit 0
}

$resolvedTarget = (Resolve-Path -LiteralPath $Target).Path
$isExpectedRoot = $resolvedTarget -eq $expectedRoot
$isUnderExpectedRoot = $resolvedTarget.StartsWith($expectedRoot + '\', [System.StringComparison]::OrdinalIgnoreCase)
if (-not ($isExpectedRoot -or $isUnderExpectedRoot)) {
  throw "Refusing to uninstall outside $expectedRoot : $resolvedTarget"
}

$skillRoot = Join-Path $PSScriptRoot 'skills'
$skillNames = Get-ChildItem -LiteralPath $skillRoot -Directory -Recurse |
  Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName 'SKILL.md') -PathType Leaf } |
  ForEach-Object { $_.Name } |
  Sort-Object -Unique

$removed = 0
foreach ($name in $skillNames) {
  $path = Join-Path $resolvedTarget $name
  if (Test-Path -LiteralPath $path) {
    if ($WhatIf) {
      Write-Host "Would remove: $path"
    } else {
      $existing = Get-Item -LiteralPath $path -Force
      if ($existing.Attributes -band [System.IO.FileAttributes]::ReparsePoint) {
        [System.IO.Directory]::Delete($path)
      } else {
        Remove-Item -LiteralPath $path -Recurse -Force
      }
      Write-Host "Removed: $path"
    }
    $removed++
  }
}

Write-Host "Uninstalled $removed skill folder(s) from $resolvedTarget"
