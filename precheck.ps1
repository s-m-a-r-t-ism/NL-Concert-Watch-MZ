# Snelle voorcheck voor de nl-concert-watch routine (STAP 1 + 1b in één keer).
# Doet: git pull, SKILL.md-zelf-sync, machinenaam lezen, dubbel-werk-check.
# Gebruik: powershell -NoProfile -ExecutionPolicy Bypass -File precheck.ps1
# Laatste regel is altijd "RESULT: SKIP ..." of "RESULT: GO".

$ErrorActionPreference = 'Continue'
$repo = $PSScriptRoot
Set-Location $repo
$utf8 = New-Object System.Text.UTF8Encoding($false)
$taskDir = Join-Path $env:USERPROFILE '.claude\scheduled-tasks\nl-concert-watch'

"REPO: $repo"

# 1. Laatste stand ophalen
$pull = git pull --rebase --autostash origin main 2>&1 | ForEach-Object { "$_" } | Out-String
if ($LASTEXITCODE -eq 0) { "PULL: ok" } else { "PULL: FAILED - $($pull.Trim())" }

# 2. Zelf-sync: routine-sectie (t/m de "---" vóór INSTALLATIE) vergelijken met lokale SKILL.md
$promptText = [IO.File]::ReadAllText((Join-Path $repo 'scheduled-task-prompt.md'), $utf8) -replace "`r", ''
$lines = $promptText -split "`n"
$dashes = @(); for ($i = 0; $i -lt $lines.Count; $i++) { if ($lines[$i].Trim() -eq '---') { $dashes += $i } }
if ($dashes.Count -ge 3) {
    $routine = ($lines[0..($dashes[2] - 1)] -join "`n").Trim()
    $skillPath = Join-Path $taskDir 'SKILL.md'
    $skill = if (Test-Path $skillPath) { ([IO.File]::ReadAllText($skillPath, $utf8) -replace "`r", '').Trim() } else { '' }
    if ($routine -eq $skill) { "SKILL: up-to-date" }
    else { [IO.File]::WriteAllText($skillPath, $routine + "`n", $utf8); "SKILL: UPDATED (verouderd t.o.v. repo, bijgewerkt voor volgende run)" }
} else { "SKILL: WARN - routine-sectie niet gevonden in scheduled-task-prompt.md" }

# 3. Machinenaam
$machinePath = Join-Path $taskDir 'machine-name.txt'
if (Test-Path $machinePath) { "MACHINE: $(([IO.File]::ReadAllText($machinePath, $utf8)).Trim())" } else { "MACHINE: MISSING" }

# 4. Dubbel-werk-check op last_run
$state = [IO.File]::ReadAllText((Join-Path $repo 'concert-watch-state.json'), $utf8) | ConvertFrom-Json
if ($state.last_run) {
    $age = ([DateTimeOffset]::Now - [DateTimeOffset]::Parse($state.last_run)).TotalDays
    if ($age -lt 6) {
        "RESULT: SKIP last_run=$($state.last_run) by=$($state.last_run_by) ($([Math]::Round($age, 1)) dagen geleden)"
        exit 0
    }
}
"RESULT: GO last_run=$($state.last_run) by=$($state.last_run_by)"
