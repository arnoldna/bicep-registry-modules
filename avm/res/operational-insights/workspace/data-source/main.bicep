metadata name = 'Log Analytics Workspace Datasources'
metadata description = 'This module deploys a Log Analytics Workspace Data Source.'

@description('Conditional. The name of the parent Log Analytics workspace. Required if the template is used in a standalone deployment.')
param logAnalyticsWorkspaceName string

@description('Required. Name of the data source.')
param name string

@description('Optional. The kind of the data source.')
@allowed([
  'AzureActivityLog'
  'WindowsEvent'
  'WindowsPerformanceCounter'
  'IISLogs'
  'LinuxSyslog'
  'LinuxSyslogCollection'
  'LinuxPerformanceObject'
  'LinuxPerformanceCollection'
])
param kind string = 'AzureActivityLog'

@description('Optional. Tags to configure in the resource.')
param tags resourceInput<'Microsoft.OperationalInsights/workspaces/dataSources@2025-02-01'>.tags?

@description('Optional. Resource ID of the resource to be linked.')
param linkedResourceId string?

@description('Optional. Windows event log name to configure when kind is WindowsEvent.')
param eventLogName string?

@description('Optional. Windows event types to configure when kind is WindowsEvent.')
param eventTypes array = []

@description('Optional. Name of the object to configure when kind is WindowsPerformanceCounter or LinuxPerformanceObject.')
param objectName string?

@description('Optional. Name of the instance to configure when kind is WindowsPerformanceCounter or LinuxPerformanceObject.')
param instanceName string = '*'

@description('Optional. Interval in seconds to configure when kind is WindowsPerformanceCounter or LinuxPerformanceObject.')
param intervalSeconds int = 60

@description('Optional. List of counters to configure when the kind is LinuxPerformanceObject.')
param performanceCounters array = []

@description('Optional. Counter name to configure when kind is WindowsPerformanceCounter.')
param counterName string?

@description('Optional. State to configure when kind is IISLogs or LinuxSyslogCollection or LinuxPerformanceCollection.')
param state string?

@description('Optional. System log to configure when kind is LinuxSyslog.')
param syslogName string?

@description('Optional. Severities to configure when kind is LinuxSyslog.')
param syslogSeverities array = []

resource workspace 'Microsoft.OperationalInsights/workspaces@2025-02-01' existing = {
  name: logAnalyticsWorkspaceName
}

resource dataSource 'Microsoft.OperationalInsights/workspaces/dataSources@2025-02-01' = {
  name: name
  parent: workspace
  kind: kind
  tags: tags
  properties: {
    linkedResourceId: !empty(kind) && kind == 'AzureActivityLog' ? linkedResourceId : null
    eventLogName: !empty(kind) && kind == 'WindowsEvent' ? eventLogName : null
    eventTypes: !empty(kind) && kind == 'WindowsEvent' ? eventTypes : null
    objectName: !empty(kind) && (kind == 'WindowsPerformanceCounter' || kind == 'LinuxPerformanceObject')
      ? objectName
      : null
    instanceName: !empty(kind) && (kind == 'WindowsPerformanceCounter' || kind == 'LinuxPerformanceObject')
      ? instanceName
      : null
    intervalSeconds: !empty(kind) && (kind == 'WindowsPerformanceCounter' || kind == 'LinuxPerformanceObject')
      ? intervalSeconds
      : null
    counterName: !empty(kind) && kind == 'WindowsPerformanceCounter' ? counterName : null
    state: !empty(kind) && (kind == 'IISLogs' || kind == 'LinuxSyslogCollection' || kind == 'LinuxPerformanceCollection')
      ? state
      : null
    syslogName: !empty(kind) && kind == 'LinuxSyslog' ? syslogName : null
    syslogSeverities: !empty(kind) && (kind == 'LinuxSyslog' || kind == 'LinuxPerformanceObject')
      ? syslogSeverities
      : null
    performanceCounters: !empty(kind) && kind == 'LinuxPerformanceObject' ? performanceCounters : null
  }
}

@description('The resource ID of the deployed data source.')
output resourceId string = dataSource.id

@description('The resource group where the data source is deployed.')
output resourceGroupName string = resourceGroup().name

@description('The name of the deployed data source.')
output name string = dataSource.name
