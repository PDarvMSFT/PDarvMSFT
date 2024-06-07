$tenantId = '' # Paste your directory (tenant) ID between the quotes here
$appId = '' # Paste your application (client) ID between the quotes here
$appSecret = '' # Paste your own app secret between the quotes here to test, then store it in a safe place, such as the Azure Key Vault!

$resourceAppIdUri = 'https://api.security.microsoft.com'
$oAuthUri = "https://login.windows.net/$tenantId/oauth2/token"

$authBody = [Ordered] @{
    resource = $resourceAppIdUri
    client_id = $appId
    client_secret = $appSecret
    grant_type = 'client_credentials'
}
$authResponse = Invoke-RestMethod -Method Post -Uri $oAuthUri -Body $authBody -ErrorAction Stop
$token = $authResponse.access_token

$resourceAppIdUri = 'https://api.security.microsoft.com'
    $oAuthUri = "https://login.microsoftonline.com/$TenantId/oauth2/token"
    $authBody = [Ordered] @{
    resource = "$resourceAppIdUri"
    client_id = "$appId"
    client_secret = "$appSecret"
    grant_type = 'client_credentials'
}
    $authResponse = Invoke-RestMethod -Method Post -Uri $oAuthUri -Body $authBody -ErrorAction Stop
    $token = $authResponse.access_token

    Write-Host "Paste your Advanced Hunting Query here:"
    $query = Read-Host  
    $url = "https://api.security.microsoft.com/api/advancedhunting/run" 
$headers = @{ 
    'Content-Type' = 'application/json'
    Accept = 'application/json'
    Authorization = "Bearer $token" 
}
$body = ConvertTo-Json -InputObject @{ "Query" = $query}
$webResponse = Invoke-WebRequest -Method Post -Uri $url -Headers $headers -Body $body -ErrorAction Stop -UseBasicParsing
$response =  $webResponse | ConvertFrom-Json
$results = $response.Results

Write-Host "`r`n"
$OutputSelection = Read-Host "Would you like to output to a file? (y/n)" 
switch ($OutputSelection)
{
'y' {
$ahOutputFilePath = Read-Host "Enter file name and full path. Must be a CSV file."
$results | ConvertTo-Csv -NoTypeInformation | Set-Content $ahOutputFilePath -Force}

'n' {$results}
}