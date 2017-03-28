# Work in progress

This template will deploy a new AD Domain and an Exchange Org. One has to set ambitious goals...

Click the button below to deploy

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FNucLabs%2FAzure-Artifacts%2Fmaster%2FPogingVier%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>

Starting point is the only working Azure template I found that works: [active-directory-new-domain-ha-2-dc](https://github.com/Azure/azure-quickstart-templates/tree/master/active-directory-new-domain-ha-2-dc)

I reduced it to create only one DC

History:
2017-3-28: DC installs and downloads Exchange CU4 ISO, which is mounted and shared




# Known Issues

+	This is one big issue ;-)
