Configuration ConfigureExchange {
    param
    (
        [Parameter(Mandatory)]
        [String]$DomainName,

        [Parameter(Mandatory)]
        [String]$ComputerName,

        [Parameter(Mandatory)]
        [String]$PDCName,

        [Parameter(Mandatory)]
        [System.Management.Automation.PSCredential]$Admincreds,

        [Int]$RetryCount = 20,
        [Int]$RetryIntervalSec = 30
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration, xComputerManagement
    [System.Management.Automation.PSCredential ]$DomainCreds = New-Object System.Management.Automation.PSCredential ("${DomainName}\$($Admincreds.UserName)", $Admincreds.Password)

    Node localhost {
        xComputer JoinDomain {
            DomainName = $DomainName
            Credential = $DomainCreds
            Name = $ComputerName
        }
        
        Package UCMAinst {
            Ensure = 'Present'
            Name = 'Microsoft Unified Communications Managed API 4.0, Core Runtime 64-bit'
            Path = "$PDCName\$DomainName\Install\UcmaRuntimeSetup.exe"
            ProductID = 'ED98ABF5-B6BF-47ED-92AB-1CDCAB964447'
            Arguments = '/norestart /passive'
        }
    }
}