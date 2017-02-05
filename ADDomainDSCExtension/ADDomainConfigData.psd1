#
# ADDomainConfigData.psd1
#
@{
    AllNodes = @(
        @{
            NodeName="*"
            RetryCount = 20
            RetryIntervalSec = 30
            PSDscAllowPlainTextPassword=$true
            PSDscAllowDomainUser = $true
        },
        @{ 
            Nodename = "localhost"
            Role = "DC"
			PSDscAllowPlainTextPassword=$true
            PSDscAllowDomainUser = $true
        }
    )
}