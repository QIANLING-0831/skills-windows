param([string]$Command)

$ErrorActionPreference = 'Stop'

if (-not $Command) {
  $json = [Console]::In.ReadToEnd()
  if (-not $json) {
    exit 0
  }
  $payload = $json | ConvertFrom-Json
  if (-not $payload -or -not $payload.tool_input) {
    exit 0
  }
  $Command = [string]$payload.tool_input.command
}

if ([string]::IsNullOrWhiteSpace($Command)) {
  exit 0
}

$patterns = @(
  'git push',
  'git reset --hard',
  'git clean -fd',
  'git clean -f',
  'git branch -D',
  'git checkout .',
  'git restore .',
  'push --force',
  'reset --hard'
)

foreach ($pattern in $patterns) {
  if ($Command -match [regex]::Escape($pattern)) {
    [Console]::Error.WriteLine(
      "BLOCKED: '$Command' matches dangerous pattern '$pattern'. The user has prevented you from doing this."
    )
    exit 2
  }
}

exit 0
