# Configura il tuo token GitHub
$token = $env:GH_METRICS_STORE
$headers = @{
    Authorization = "token $token"
    Accept = "application/vnd.github.v3+json"
}

# Fai una richiesta API per ottenere i repository
$response = Invoke-RestMethod -Uri "https://api.github.com/orgs/SVC-STGHE-CENTRAL/copilot/usage" -Headers $headers

$repos = $response | ForEach-Object {
    [PSCustomObject]@{
            day = $_.day
            total_suggestions_count = $_.total_suggestions_count
            total_acceptances_count = $_.total_acceptances_count
            total_lines_suggested = $_.total_lines_suggested
            total_lines_accepted = $_.total_lines_accepted
            total_active_users = $_.total_active_users
            total_chat_acceptances = $_.total_chat_acceptances
            total_chat_turns = $_.total_chat_turns
            total_active_chat_users = $_.total_active_chat_users
        }
    }

# Salva i dati in un file CSV
#$repos | Export-Csv -Path "github_repos4.csv" -NoTypeInformation
#Write-Output "Dati esportati con successo in github_repos4.csv"

# Esporta i dati in un file CSV
$csvFilePath = "github_repos4.csv"
if ($repos.Count -gt 0) {
    $repos | Export-Csv -Path $csvFilePath -NoTypeInformation
} else {
    "No data available" | Out-File -FilePath $csvFilePath
}

Write-Output "I dati sono stati esportati in $csvFilePath"
