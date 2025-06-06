## 0.0.5 (2025-05-02)

### Features
- Updating module to fix siteAddSecondaryAzureVSocket null resource

## 0.0.6 (2025-05-07)

### Features
- Added sleep null resources between primary socket creation and siteAddSecondaryAzureVSocket API to ensure enough time for socket to finish provisioning and upgrading.

## 0.0.7 (2025-05-07)

### Features
- Added optional license resource and inputs used for commercial site deployments

## 0.1.0 (2025-06-03)

## Features
- Setup to use Azure HA vSocket Module from Cato Networks 
- Setup to be able to take a resource group / vnet as inputs 
- Added Tag handling for Azure Resources 
- Added Additional Dependancies for Resources 
- Added LifeCycle ignore-changes for several resources 
- Added Firewall Rules to SGs for Cato Deployment per PS Recommendations 
- Adjusted Resource naming to fit naming convention 
- Removed Code which built Socket and Socket site, instead leveraging sub-module per standard practice. 
- Updated Outputs to reference submodule outputs 
- Updated ReadMe to incorporate new updates and tfdocs 

## 0.1.1 (2025-06-06)

## Features 
- Fix typo in Module call in main.tf