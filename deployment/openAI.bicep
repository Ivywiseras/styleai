﻿@description('Azure Location for the Storage Account')
param location string = resourceGroup().location

@description('Name for the OpenAI Chat Service')
@minLength(2)
@maxLength(64)
param openAIserviceName string = 'grocer-gpt'

@description('Specifies the name of the key vault.')
param keyVaultName string

resource openAIaccount 'Microsoft.CognitiveServices/accounts@2023-05-01' = {
  name: openAIserviceName
  location: location
  sku: {
    name: 'S0'
  }
  kind: 'OpenAI'
  properties: {
    customSubDomainName: openAIserviceName
    networkAcls: {
      defaultAction: 'Allow'
    }
    publicNetworkAccess: 'Enabled'
  }
}

resource openAIdeployment 'Microsoft.CognitiveServices/accounts/deployments@2023-05-01' = {
  parent: openAIaccount
  name: 'virtual-grocer-chat'
  sku: {
    name: 'Standard'
    capacity: 10
  }
  properties: {
    model: {
      format: 'OpenAI'
      name: 'gpt-35-turbo'
      version: '0613'
    }
  }
}

resource keyVault 'Microsoft.KeyVault/vaults@2023-02-01' existing = {
  name: keyVaultName
}

resource openAIkey 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = {
  parent: keyVault
  name: 'azure-openai-key'
  properties: {
    contentType: 'Azure OpenAI Key'
    value: openAIaccount.listKeys().key1
  }
}

output openAIendpoint string = openAIaccount.properties.endpoint
