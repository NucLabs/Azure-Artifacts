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

    Import-DscResource -ModuleName PSDesiredStateConfiguration, xComputerManagement, xExchange, xPendingReboot
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
            Path = "\\$PDCName.$DomainName\Install\UcmaRuntimeSetup.exe"
            ProductID = 'ED98ABF5-B6BF-47ED-92AB-1CDCAB964447'
            Arguments = '/norestart /passive'
        }

        WindowsFeature NETFramework45Features {
            Ensure = 'Present'
            Name = 'NET-Framework-45-Features'
        }

        WindowsFeature RPCoverHTTPproxy {
            Ensure = 'Present'
            Name = 'RPC-over-HTTP-proxy'
        }

        WindowsFeature RSATClustering {
            Ensure = 'Present'
            Name = 'RSAT-Clustering'
        }

        WindowsFeature RSATClusteringCmdInterface {
            Ensure = 'Present'
            Name = 'RSAT-Clustering-CmdInterface'
        }

        WindowsFeature RSATClusteringMgmt {
            Ensure = 'Present'
            Name = 'RSAT-Clustering-Mgmt'
        }

        WindowsFeature RSATClusteringPowerShell {
            Ensure = 'Present'
            Name = 'RSAT-Clustering-PowerShell'
        }

        WindowsFeature WebMgmtConsole {
            Ensure = 'Present'
            Name = 'Web-Mgmt-Console'
        }

        WindowsFeature WASProcessModel {
            Ensure = 'Present'
            Name = 'WAS-Process-Model'
        }

        WindowsFeature WebAspNet45 {
            Ensure = 'Present'
            Name = 'Web-Asp-Net45'
        }

        WindowsFeature WebBasicAuth {
            Ensure = 'Present'
            Name = 'Web-Basic-Auth'
        }

        WindowsFeature WebClientAuth {
            Ensure = 'Present'
            Name = 'Web-Client-Auth'
        }

        WindowsFeature WebDigestAuth {
            Ensure = 'Present'
            Name = 'Web-Digest-Auth'
        }

        WindowsFeature WebDirBrowsing {
            Ensure = 'Present'
            Name = 'Web-Dir-Browsing'
        }

        WindowsFeature WebDynCompression {
            Ensure = 'Present'
            Name = 'Web-Dyn-Compression'
        }

        WindowsFeature WebHttpErrors {
            Ensure = 'Present'
            Name = 'Web-Http-Errors'
        }

        WindowsFeature WebHttpLogging {
            Ensure = 'Present'
            Name = 'Web-Http-Logging'
        }

        WindowsFeature WebHttpRedirect {
            Ensure = 'Present'
            Name = 'Web-Http-Redirect'
        }

        WindowsFeature WebHttpTracing {
            Ensure = 'Present'
            Name = 'Web-Http-Tracing'
        }

        WindowsFeature WebISAPIExt {
            Ensure = 'Present'
            Name = 'Web-ISAPI-Ext'
        }

        WindowsFeature WebISAPIFilter {
            Ensure = 'Present'
            Name = 'Web-ISAPI-Filter'
        }

        WindowsFeature WebLgcyMgmtConsole {
            Ensure = 'Present'
            Name = 'Web-Lgcy-Mgmt-Console'
        }

        WindowsFeature WebMetabase {
            Ensure = 'Present'
            Name = 'Web-Metabase'
        }

        WindowsFeature WebMgmtService {
            Ensure = 'Present'
            Name = 'Web-Mgmt-Service'
        }

        WindowsFeature WebNetExt45 {
            Ensure = 'Present'
            Name = 'Web-Net-Ext45'
        }

        WindowsFeature WebRequestMonitor {
            Ensure = 'Present'
            Name = 'Web-Request-Monitor'
        }

        WindowsFeature WebServer {
            Ensure = 'Present'
            Name = 'Web-Server'
        }

        WindowsFeature WebStatCompression {
            Ensure = 'Present'
            Name = 'Web-Stat-Compression'
        }

        WindowsFeature WebStaticContent {
            Ensure = 'Present'
            Name = 'Web-Static-Content'
        }

        WindowsFeature WebWindowsAuth {
            Ensure = 'Present'
            Name = 'Web-Windows-Auth'
        }

        WindowsFeature WebWMI {
            Ensure = 'Present'
            Name = 'Web-WMI'
        }

        WindowsFeature WindowsIdentityFoundation {
            Ensure = 'Present'
            Name = 'Windows-Identity-Foundation'
        }

        WindowsFeature RSATADDS {
            Ensure = 'Present'
            Name = 'RSAT-ADDS'
        }

        xPendingReboot BeforeExchangeInstall {
            Name = "BeforeExchangeInstall"
        }

        xExchInstall InstallExchange {
            Path = "\\$PDCName.$DomainName\EXInstall\Setup.exe"
            Arguments = "/mode:Install /role:Mailbox /OrganizationName:ExOrg /Iacceptexchangeserverlicenseterms"
            Credential = $DomainCreds
            DependsOn = '[xPendingReboot]BeforeExchangeInstall'
        }

        xPendingReboot AfterExchangeInstall {
            Name = "AfterExchangeInstall"
            DependsOn = '[xExchInstall]InstallExchange'
        }
    }
}