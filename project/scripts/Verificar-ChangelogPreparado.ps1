[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$ProjectDirectory
)

$ErrorActionPreference = 'Stop'
$repo = ((@(& git -c safe.directory=* -C $ProjectDirectory rev-parse --show-toplevel 2>$null) -join "`n").Trim())
if ($LASTEXITCODE -ne 0) { throw "'$ProjectDirectory' no pertenece a un repositorio Git." }

$repoFull = [IO.Path]::GetFullPath($repo).TrimEnd('\')
$projectFull = [IO.Path]::GetFullPath($ProjectDirectory).TrimEnd('\')
if ($projectFull.Equals($repoFull, [System.StringComparison]::OrdinalIgnoreCase)) {
    $relativeProject = ''
}
elseif (-not $projectFull.StartsWith($repoFull + '\', [System.StringComparison]::OrdinalIgnoreCase)) {
    throw "'$ProjectDirectory' no está dentro de '$repo'."
}
else {
    $relativeProject = $projectFull.Substring($repoFull.Length + 1).Replace('\', '/')
}
$changelog = if ($relativeProject) { "$relativeProject/changelog.md" } else { 'changelog.md' }
$changed = @(& git -c safe.directory=* -C $repo diff --cached --name-only)
$codeChanged = @($changed | Where-Object { $_ -notmatch '(^|/)(project|docs?)/' -and $_ -match '\.(cs|vb|fs|ts|tsx|js|jsx|py|java|cpp|c|h|sql)$' })
if ($codeChanged.Count -eq 0) { return }
if ($changelog -notin $changed) {
    throw "Un commit con código debe incluir '$changelog'."
}

$addedBullet = @(& git -c safe.directory=* -C $repo diff --cached -U0 -- $changelog | Where-Object { $_ -match '^\+\s*-\s+\S' })
if ($addedBullet.Count -eq 0) {
    throw "'$changelog' debe contener al menos una entrada nueva para el commit de código."
}
