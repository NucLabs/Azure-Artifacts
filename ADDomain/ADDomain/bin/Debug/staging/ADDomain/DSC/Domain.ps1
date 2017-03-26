configuration CreateADPDC 
{ 
   param 
   ( 
        [Parameter(Mandatory)]
        [String]$DomainName,

        [Parameter(Mandatory)]
        [System.Management.Automation.PSCredential]$Admincreds,

        [Int]$RetryCount=20,
        [Int]$RetryIntervalSec=30
    ) 
    
    Import-DscResource -ModuleName xActiveDirectory,xDisk, xNetworking, PSDesiredStateConfiguration
    [System.Management.Automation.PSCredential ]$DomainCreds = New-Object System.Management.Automation.PSCredential ("${DomainName}\$($Admincreds.UserName)", $Admincreds.Password)
    $Interface=Get-NetAdapter|Where Name -Like "Ethernet*"|Select-Object -First 1
    $InterfaceAlias=$($Interface.Name)

    Node localhost
    {
        Script AddADDSFeature {
            SetScript = {
                Add-WindowsFeature "AD-Domain-Services" -ErrorAction SilentlyContinue   
            }
            GetScript =  { @{} }
            TestScript = { $false }
        }
	
	    WindowsFeature DNS 
        { 
            Ensure = "Present" 
            Name = "DNS"		
        }

        Script script1
	    {
      	    SetScript =  { 
		        Set-DnsServerDiagnostics -All $true
                Write-Verbose -Verbose "Enabling DNS client diagnostics" 
            }
            GetScript =  { @{} }
            TestScript = { $false }
	        DependsOn = "[WindowsFeature]DNS"
        }

	    WindowsFeature DnsTools
	    {
	        Ensure = "Present"
            Name = "RSAT-DNS-Server"
	    }

        xDnsServerAddress DnsServerAddress 
        { 
            Address        = '127.0.0.1' 
            InterfaceAlias = $InterfaceAlias
            AddressFamily  = 'IPv4'
	        DependsOn = "[WindowsFeature]DNS"
        }

        xWaitforDisk Disk2
        {
             DiskNumber = 2
             RetryIntervalSec =$RetryIntervalSec
             RetryCount = $RetryCount
        }

        WindowsFeature ADDSInstall 
        { 
            Ensure = "Present" 
            Name = "AD-Domain-Services"
	        DependsOn="[cDiskNoRestart]ADDataDisk", "[Script]AddADDSFeature"
        } 
         
        xADDomain FirstDS 
        {
            DomainName = $DomainName
            DomainNetBIOSName = $DomainName.Substring(1,15)
            DomainAdministratorCredential = $DomainCreds
            SafemodeAdministratorPassword = $DomainCreds
            DatabasePath = "C:\NTDS"
            LogPath = "C:\NTDS"
            SysvolPath = "C:\SYSVOL"
	        DependsOn = "[WindowsFeature]ADDSInstall"
        } 

        LocalConfigurationManager 
        {
            ConfigurationMode = 'ApplyOnly'
            RebootNodeIfNeeded = $true
        }
   }
} 