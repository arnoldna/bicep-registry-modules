metadata name = 'Network Watchers Connection Monitors'
metadata description = 'This module deploys a Network Watcher Connection Monitor.'

@description('Optional. Name of the network watcher resource. Must be in the resource group where the Flow log will be created and same region as the NSG.')
param networkWatcherName string = 'NetworkWatcher_${resourceGroup().location}'

@description('Required. Name of the resource.')
param name string

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. List of connection monitor endpoints.')
param endpoints array = []

@description('Optional. List of connection monitor test configurations.')
param testConfigurations array = []

@description('Optional. List of connection monitor test groups.')
param testGroups array = []

@description('Optional. Specify the Log Analytics Workspace Resource ID.')
param workspaceResourceId string = ''

resource networkWatcher 'Microsoft.Network/networkWatchers@2024-05-01' existing = {
  name: networkWatcherName
}

resource connectionMonitor 'Microsoft.Network/networkWatchers/connectionMonitors@2024-05-01' = {
  name: name
  parent: networkWatcher
  tags: tags
  location: location
  properties: {
    endpoints: endpoints
    testConfigurations: testConfigurations
    testGroups: testGroups
    outputs: !empty(workspaceResourceId)
      ? [
          {
            type: 'Workspace'
            workspaceSettings: {
              workspaceResourceId: workspaceResourceId
            }
          }
        ]
      : null
  }
}

@description('The name of the deployed connection monitor.')
output name string = connectionMonitor.name

@description('The resource ID of the deployed connection monitor.')
output resourceId string = connectionMonitor.id

@description('The resource group the connection monitor was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = connectionMonitor.location
