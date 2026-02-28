using './main.bicep'

param location = 'japaneast'
param aiServices = 'aiservices'
param modelName = 'gpt-4o'
param modelFormat = 'OpenAI'
param modelVersion = '2024-11-20'
param modelSkuName = 'GlobalStandard'
param modelCapacity = 30
param firstProjectName = 'project'
param projectDescription = 'A project for the AI Foundry account with network secured deployed Agent'
param displayName = 'project'
param peSubnetName = 'snet-pe'

// Resource IDs for existing resources
// If you provide these, the deployment will use the existing resources instead of creating new ones
param existingVnetResourceId = '/subscriptions/0a33aa1b-d8ef-429b-926d-da98db87b7cb/resourceGroups/rg-monitor-demo/providers/Microsoft.Network/virtualNetworks/vnet-spoke'
param vnetName = 'vnet-spoke'
param agentSubnetName = 'snet-agent-f'
param aiSearchResourceId = '/subscriptions/0a33aa1b-d8ef-429b-926d-da98db87b7cb/resourceGroups/rg-foundry-apim-1/providers/Microsoft.Search/searchServices/aiservicesmwedsearch'
param azureStorageAccountResourceId = '/subscriptions/0a33aa1b-d8ef-429b-926d-da98db87b7cb/resourceGroups/rg-foundry-apim-1/providers/Microsoft.Storage/storageAccounts/aiservicesmwedstorage'
param azureCosmosDBAccountResourceId = '/subscriptions/0a33aa1b-d8ef-429b-926d-da98db87b7cb/resourceGroups/rg-foundry-apim-1/providers/Microsoft.DocumentDB/databaseAccounts/aiservicesmwedcosmosdb'

// API Management configuration (optional)
param apiManagementResourceId = '/subscriptions/0a33aa1b-d8ef-429b-926d-da98db87b7cb/resourceGroups/rg-apim/providers/Microsoft.ApiManagement/service/apim-demo-yuichimsauda'

// Pass the DNS zone map here
// Leave empty to create new DNS zone, add the resource group of existing DNS zone to use it
param existingDnsZones = {
  // vnet-spoke is already linked to these zones in rg-monitor-demo.
  // Pointing to rg-monitor-demo avoids overlapping-namespace link conflicts.
  'privatelink.cognitiveservices.azure.com': 'rg-monitor-demo'
  'privatelink.blob.core.windows.net': 'rg-monitor-demo'

  // These zones were created in rg-foundry-apim-a by the previous deployment.
  // Mark them as existing to avoid creating additional VNet links (which would conflict).
  'privatelink.services.ai.azure.com': 'rg-foundry-apim-1'
  'privatelink.openai.azure.com': 'rg-foundry-apim-1'
  'privatelink.search.windows.net': 'rg-foundry-apim-1'
  'privatelink.documents.azure.com': 'rg-foundry-apim-1'
  'privatelink.azure-api.net': 'rg-foundry-apim-1'
}

//DNSZones names for validating if they exist
param dnsZoneNames = [
  'privatelink.services.ai.azure.com'
  'privatelink.openai.azure.com'
  'privatelink.cognitiveservices.azure.com'
  'privatelink.search.windows.net'
  'privatelink.blob.core.windows.net'
  'privatelink.documents.azure.com'
  'privatelink.azure-api.net'
]


// Network configuration: only used when existingVnetResourceId is not provided
// These addresses are only used when creating a new VNet and subnets
// If you provide existingVnetResourceId, these values will be ignored
param vnetAddressPrefix = ''
param agentSubnetPrefix = '10.1.13.0/24'
param peSubnetPrefix = '10.1.1.0/24'

