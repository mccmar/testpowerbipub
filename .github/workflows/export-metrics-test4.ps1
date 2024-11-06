# Configura il tuo token GitHub
$token = "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"
$headers = @{
    Authorization = "token $token"
    Accept = "application/vnd.github.v3+json"
}

# Fai una richiesta API per ottenere i repository
$response = Invoke-RestMethod -Uri "https://api.github.com/repos/mccmar/testpowerbipub/actions/runs" -Headers $headers

$repos = $response | ForEach-Object {
    $_.workflow_runs | ForEach-Object {
        [PSCustomObject]@{
            id = $_.id
            name = $_.name
            status = $_.status
            conclusion = $_.conclusion
            actor = $_.actor.login
            repository = $_.repository.name
        }
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
