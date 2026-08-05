param(
  [string]$Target = (Join-Path $env:USERPROFILE '.codex\skills'),
  [switch]$NoOverwrite
)

$ErrorActionPreference = 'Stop'

$linkScript = Join-Path $PSScriptRoot 'scripts\link-skills.ps1'

& $linkScript -Mode Copy -Destination $Target -Force:(-not $NoOverwrite)

Write-Host ''
Write-Host "Installed skills to: $Target"
