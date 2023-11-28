# Gets the Azure DevOps logs using the REST API

function Get-AzureDevOpsAuditLogs {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $OrganizationName,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string] $OutFilePath = "auditlogs.csv",

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string] $LogType = "csv",

        [Parameter(Mandatory=$false, ParameterSetName='TimeRange')]
        [ValidateNotNullOrEmpty()]
        [string] $StartTime,

        [Parameter(Mandatory=$false, ParameterSetName='TimeRange')]
        [ValidateNotNullOrEmpty()]
        [string] $EndTime
    )

    begin {
        Write-Verbose "In Begin Block: Get-AzureDevOpsAuditLogs()"
        $pat = Get-Content -Path ".\token" -Raw
        $user = "admin@MngEnv745628.onmicrosoft.com"
        $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user, $pat)))
    }
    
    process {
        Write-Verbose "In Process Block: Get-AzureDevOpsAuditLogs()"

        switch ($PsCmdlet.ParameterSetName) {
            'TimeRange' {
                $url = "https://auditservice.dev.azure.com/$OrganizationName/_apis/audit/downloadlog?format=$LogType&startTime=$StartTime&endTime=$EndTime&api-version=5.1-preview.1"
                break
            }
            default {
                $url = "https://auditservice.dev.azure.com/$OrganizationName/_apis/audit/downloadlog?format=$LogType&api-version=5.1-preview.1"
                break
            }
        }
        
        try {
            Invoke-RestMethod -Uri $url -Method GET -ContentType "application/json" -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -OutFile $OutFilePath
        }
        catch {
            Write-Error $_.Exception.Message
        }
    }

    end {
        Write-Verbose "In End Block: Get-AzureDevOpsAuditLogs()"
    }
}

# call above function
Get-AzureDevOpsAuditLogs -OrganizationName contosopdarveau
