# wsus



## Preparation:

Update .kitchen.yml with your Azure subscription details per [kitchen-azurerm](https://github.com/test-kitchen/kitchen-azurerm)
```
driver_config:
  subscription_id: '00000000-YOUR-GUID-HERE-000000000000'
  location: 'Central US'
  machine_size: 'Standard_D1'
```

**NOTE: The WSUS Server takes ~30 minutes to spin up**

Before showing someone, make sure you stand up the WSUS server as it takes a while to download the updates
* Run `kitchen converge server`
* Update `kitchen.yml` 
    * Update `image_urn` if needed for platform `windows-2012r2-old`
    ```
      - name: windows2012-r2-old
    driver_config:
    # NOTE: If you don't specify an out of date Azure URN there will not be
    # any updates to apply. You can get a current list of 2012R2 URNs by running
    # az vm image list --all --sku 2012-R2-Datacenter
      image_urn: MicrosoftWindowsServer:WindowsServer:2012-R2-Datacenter:4.127.20170510
      vm_name: 2012r2-old
    transport:
      name: winrm
      elevated: true
    ```
    * Update `wsus_server` attribute to reflect your WSUS Server
    ```
    attributes:
        wsus_client:
        # NOTE: this needs to be set on each run, the DNS entry from the AzureRM driver creates
        # as kitchen-[driver UUID].[location].cloudapp.azure.com 
        # the UUID can be found in .kitchen/server-windows2012-r2.yml
        # Don't forget to include 'http://' and ':8530' in the WSUS server string
            wsus_server: "http://kitchen-9581203fe04897be.centralus.cloudapp.azure.com:8530"
    ```

## Running the show
* Run `kitchen converge client --parallel`
    * This will stand up a current and an old Windows 2012 R2 instance in Azure
    Allowing you to show different levels of patches that would need to be applied
    * This run will be relatively quick as we should not have any approved updates yet
* Login to your WSUS server `kitchen login server`
    * Open Windows Server Update Services
        * Press <kbd>CMD</kbd> or <kbd>WIN</kbd> and type <kbd>WSUS</kbd> to search for Windows Server Update Services
        * Close the tutorial window to launch into WSUS
    * Click on Updates on the left and expand the drop down
    * Select All Updates
    * Switch the Status to Any from the drop down and refresh
        * All updates should be Not Approved
* Check to see that your `kitchen converge client --parallel` has finished
    * Go back to WSUS and expand the left drop down for Computers
        * Select My Server Group
        * Click on each computer to show the updates that are missing
    * Go to All Updates, select all of them **NOTE: Make sure your filters are set to Approval: Any Except Declined and Status: Any
        * From the Actions menu on the right click Approve...
        * Approve for My Server Group
        * This will take a second, remind folks they probably don't want to blindly approve all updates in their systems, but this is just a demo
* Run `kitchen converge client --parallel` again
    * Your output should quickly show 
    </br>`* wsus_client_update[WSUS updates] action download`
    * The update process should take between 10-20 minutes and will eventually reboot
* Login to the older server `kitchen login client-windows2012-r2-old`
    * In the Server Manager go to Local Server
        * Point out that Windows Update shows "Download updates only, using a managed update service"
        * Click on that link to open the Windows Update menu
        * Point out "You recieve updates: Managed by your system administrators"



## TO DO:
* Add a suite with a client that has a scheduled install for patches instead of on demand
