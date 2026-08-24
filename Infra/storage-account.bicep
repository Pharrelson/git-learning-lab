@description('Name of the storage account (globally unique, lowercase, no dashes)')
param storageAccountName string

@description('Azure region for the storage account')
param location string = resourceGroup().location

@description('SKU for the storage account')
param skuName string = 'Standard_LRS'

resource backupStorage 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: skuName
  }
  kind: 'StorageV2'
  properties: {
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
  }
}

output storageAccountId string = backupStorage.id
