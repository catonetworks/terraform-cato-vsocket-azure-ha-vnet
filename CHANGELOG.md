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

### Features
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

### Features 
- Fix typo in Module call in main.tf

## 0.1.2 (2025-06-10)

### Features
- fix typo in readme

## 0.1.3 (2025-06-25)

### Features
- Added SiteLocation Lookup based on Cloud Region

## 0.1.4 (2025-07-16)

### Features 
 - Updated SiteLocation (v0.0.2)
 - Version Lock Cato Provider to V0.0.30 or greater
 - Version Lock Terraform to 1.5 or Greater
