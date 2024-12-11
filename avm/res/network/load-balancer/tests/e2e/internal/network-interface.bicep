@description('Required. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Virtual Network to create.')
param subnetResourceID string

@description('Required. The load balancer backend pool name to attach the NIC to.')
param loadBalancerBackendAddressPoolName string

@description('Required. The name of the load balancer to attach the NIC to.')
param loadBalancerName string

@description('Required. The name of the network interface.')
param networkInterfaceName string

var loadBalancerBackendAddressPoolID = resourceId(
  'Microsoft.Network/loadBalancers/backendAddressPools',
  loadBalancerName,
  loadBalancerBackendAddressPoolName
)
resource networkInterface 'Microsoft.Network/networkInterfaces@2023-09-01' = {
  name: '${networkInterfaceName}-deploy'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: subnetResourceID
          }
          loadBalancerBackendAddressPools: [
            {
              id: loadBalancerBackendAddressPoolID
            }
          ]
        }
      }
    ]
  }
}
