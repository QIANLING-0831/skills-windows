# Human-in-the-loop reproduction loop.
# Copy this file, edit the steps below, and run it.
# The agent runs the script; the user follows prompts in their terminal.
#
# Usage:
#   powershell -NoProfile -ExecutionPolicy Bypass -File .\hitl-loop.template.ps1
#
# Two helpers:
#   Step "<instruction>"            -> show instruction, wait for Enter
#   Capture VAR "<question>"        -> show question, read response into VAR
#
# At the end, captured values are printed as KEY=VALUE for the agent to parse.

$ErrorActionPreference = 'Stop'

function Step {
  param([string]$Instruction)
  Write-Host "`n>>> $Instruction"
  Read-Host '    [Enter when done] ' | Out-Null
}

function Capture {
  param([string]$Name, [string]$Question)
  Write-Host "`n>>> $Question"
  $answer = Read-Host '    > '
  Set-Variable -Name $Name -Value $answer -Scope 1
}

# --- edit below ---------------------------------------------------------

Step "Open the app at http://localhost:3000 and sign in."

Capture ERRORED "Click the 'Export' button. Did it throw an error? (y/n)"

Capture ERROR_MSG "Paste the error message (or 'none'):"

# --- edit above ---------------------------------------------------------

Write-Host "`n--- Captured ---"
Write-Host "ERRORED=$ERRORED"
Write-Host "ERROR_MSG=$ERROR_MSG"
