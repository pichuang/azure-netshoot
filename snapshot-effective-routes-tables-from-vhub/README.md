# Snapshot Effective Routes Tables from vHub

This bash script allows you to export all of the route tables associated with an Azure virtual hub to individual JSON files. The script uses the Azure CLI to retrieve the route table IDs and associated information and then calls the get-effective-routes command to export the routes to JSON.

## Usage

1. Clone or download the repository containing the script.
2. Open a terminal and navigate to the directory containing the script.
3. Modify the variables at the top of the script as necessary:

   - `RESOURCE_GROUPNAME`: The name of the resource group containing the virtual hub.
   - `VHUB_NAME`: The name of the virtual hub.
   - `DEBUG_OUTPUT`: Set this to `true` or `false` to output debugging information.
   - `TIMEZONE`: Set this to your local timezone.

4. Run the script using the following command:

``` bash
$ bash snapshot-route-tables-from-vhub.sh
```

5. The script will create a directory with the format `VHUB_NAME-YYYYMMDD` and save each route table to a separate JSON file in that directory.

## Demo

``` bash
#
# Before
#

phil [ ~ ]$ ./snapshot-route-tables-from-vhub.sh
Create directory vhub-cc-20230225-105605
Save defaultRouteTable.json
Save noneRouteTable.json

#
# REMOVE static route "192.168.80.0/24" into route table "defaultRouteTable"
#

#
# After
#
phil [ ~ ]$ ./snapshot-route-tables-from-vhub.sh
Create directory vhub-cc-20230225-105915
Save defaultRouteTable.json
Save noneRouteTable.json

#
# Diff route tables
#
# Command: diff -bur before_dir after_dir
#

phil [ ~ ]$ diff -bur vhub-cc-20230225-105605 vhub-cc-20230225-105915/
diff -bur vhub-cc-20230225-105605/defaultRouteTable.json vhub-cc-20230225-105915/defaultRouteTable.json
--- vhub-cc-20230225-105605/defaultRouteTable.json      2023-02-25 02:56:21.512825866 +0000
+++ vhub-cc-20230225-105915/defaultRouteTable.json      2023-02-25 02:59:31.551231895 +0000
@@ -21,17 +21,6 @@
         "/subscriptions/xxxx-xxxx-xxxx-xxxx/resourceGroups/rg-pinhuang/providers/Microsoft.Network/vpnGateways/yyyy-yyyy-yyyy-yyyy-canadacentral-gw"
       ],
       "routeOrigin": "/subscriptions/xxxx-xxxx-xxxx-xxxx/resourceGroups/rg-pinhuang/providers/Microsoft.Network/vpnGateways/yyyy-yyyy-yyyy-yyyy-canadacentral-gw"
-    },
-    {
-      "addressPrefixes": [
-        "192.168.80.0/24"
-      ],
-      "asPath": "",
-      "nextHopType": "VPN_S2S_Gateway",
-      "nextHops": [
-        "/subscriptions/xxxx-xxxx-xxxx-xxxx/resourceGroups/rg-pinhuang/providers/Microsoft.Network/vpnGateways/yyyy-yyyy-yyyy-yyyy-canadacentral-gw"
-      ],
-      "routeOrigin": "/subscriptions/xxxx-xxxx-xxxx-xxxx/resourceGroups/rg-pinhuang/providers/Microsoft.Network/vpnGateways/yyyy-yyyy-yyyy-yyyy-canadacentral-gw"
     }
   ]
 }

```


## Requirements

Make sure that you have installed the Azure CLI and jq command-line JSON processor before running the script.

- Azure CLI
- `jq` command-line JSON processor
- Azure Virtual Hub
