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

## Requirements

Make sure that you have installed the Azure CLI and jq command-line JSON processor before running the script.

- Azure CLI
- `jq` command-line JSON processor
- Azure Virtual Hub

## Demo

### 1. Remove static route from route table

``` bash
#
# Before
#

phil [ ~ ]$ ./snapshot-route-tables-from-vhub.sh
Create directory vhub-cc-20230225-220656
Save vhub-cc-20230225-220656/RouteTable/defaultRouteTable.json
Save vhub-cc-20230225-220656/RouteTable/noneRouteTable.json
Save vhub-cc-20230225-220656/VpnConnection/yyyyyyyyyyyyyyyyyyyy-canadacentral-gw.json

#
# Action
# Remove static route "192.168.80.0/24" into route table "defaultRouteTable"
# Time Estimation: ~2 minutes
#

#
# After
#
phil [ ~ ]$ ./snapshot-route-tables-from-vhub.sh
Create directory vhub-cc-20230225-220958
Save vhub-cc-20230225-220958/RouteTable/defaultRouteTable.json
Save vhub-cc-20230225-220958/RouteTable/noneRouteTable.json
Save vhub-cc-20230225-220958/VpnConnection/yyyyyyyyyyyyyyyyyyyy-canadacentral-gw.json

#
# Diff route tables
#
# Command: diff -bur before_dir after_dir
#

phil [ ~ ]$ diff -bur vhub-cc-20230225-220656 vhub-cc-20230225-220958
diff -bur vhub-cc-20230225-220656/RouteTable/defaultRouteTable.json vhub-cc-20230225-220958/RouteTable/defaultRouteTable.json
--- vhub-cc-20230225-220656/RouteTable/defaultRouteTable.json   2023-02-25 14:07:10.710361608 +0000
+++ vhub-cc-20230225-220958/RouteTable/defaultRouteTable.json   2023-02-25 14:10:13.485471902 +0000
@@ -21,17 +21,6 @@
         "/subscriptions/xxxx-xxxx-xxxx-xxxx/resourceGroups/rg-pinhuang/providers/Microsoft.Network/vpnGateways/yyyyyyyyyyyyyyyyyyyy-canadacentral-gw"
       ],
       "routeOrigin": "/subscriptions/xxxx-xxxx-xxxx-xxxx/resourceGroups/rg-pinhuang/providers/Microsoft.Network/vpnGateways/yyyyyyyyyyyyyyyyyyyy-canadacentral-gw"
-    },
-    {
-      "addressPrefixes": [
-        "192.168.80.0/24"
-      ],
-      "asPath": "",
-      "nextHopType": "VPN_S2S_Gateway",
-      "nextHops": [
-        "/subscriptions/xxxx-xxxx-xxxx-xxxx/resourceGroups/rg-pinhuang/providers/Microsoft.Network/vpnGateways/yyyyyyyyyyyyyyyyyyyy-canadacentral-gw"
-      ],
-      "routeOrigin": "/subscriptions/xxxx-xxxx-xxxx-xxxx/resourceGroups/rg-pinhuang/providers/Microsoft.Network/vpnGateways/yyyyyyyyyyyyyyyyyyyy-canadacentral-gw"
     }
   ]
 }
```

### 2. Disable Propagate Default Route

``` bash
#
# Before
#
phil [ ~ ]$ ./snapshot-route-tables-from-vhub.sh
Create directory vhub-cc-20230225-220958
Save vhub-cc-20230225-220958/RouteTable/defaultRouteTable.json
Save vhub-cc-20230225-220958/RouteTable/noneRouteTable.json
Save vhub-cc-20230225-220958/VpnConnection/yyyyyyyyyyyyyyyyyyyy-canadacentral-gw.json

#
# Action
# Disable Propagate Default Route
# Time Estimation: ~2 minutes
#

#
# After
#
phil [ ~ ]$ ./snapshot-route-tables-from-vhub.sh
Create directory vhub-cc-20230225-221412
Save vhub-cc-20230225-221412/RouteTable/defaultRouteTable.json
Save vhub-cc-20230225-221412/RouteTable/noneRouteTable.json
Save vhub-cc-20230225-221412/VpnConnection/yyyyyyyyyyyyyyyyyyyy-canadacentral-gw.json

#
# Diff route tables
#
# Command: diff -bur before_dir after_dir
#

phil [ ~ ]$ diff -bur vhub-cc-20230225-220958 vhub-cc-20230225-221412
diff -bur vhub-cc-20230225-220958/RouteTable/noneRouteTable.json vhub-cc-20230225-221412/RouteTable/noneRouteTable.json
--- vhub-cc-20230225-220958/RouteTable/noneRouteTable.json      2023-02-25 14:10:25.561647902 +0000
+++ vhub-cc-20230225-221412/RouteTable/noneRouteTable.json      2023-02-25 14:14:39.592848956 +0000
@@ -1,3 +1,26 @@
 {
-  "value": []
+  "value": [
+    {
+      "addressPrefixes": [
+        "192.168.79.0/24"
+      ],
+      "asPath": "",
+      "nextHopType": "VPN_S2S_Gateway",
+      "nextHops": [
+        "/subscriptions/xxxx-xxxx-xxxx-xxxx/resourceGroups/rg-pinhuang/providers/Microsoft.Network/vpnGateways/yyyyyyyyyyyyyyyyyyyy-canadacentral-gw"
+      ],
+      "routeOrigin": "/subscriptions/xxxx-xxxx-xxxx-xxxx/resourceGroups/rg-pinhuang/providers/Microsoft.Network/vpnGateways/yyyyyyyyyyyyyyyyyyyy-canadacentral-gw"
+    },
+    {
+      "addressPrefixes": [
+        "192.168.78.0/24"
+      ],
+      "asPath": "",
+      "nextHopType": "VPN_S2S_Gateway",
+      "nextHops": [
+        "/subscriptions/xxxx-xxxx-xxxx-xxxx/resourceGroups/rg-pinhuang/providers/Microsoft.Network/vpnGateways/yyyyyyyyyyyyyyyyyyyy-canadacentral-gw"
+      ],
+      "routeOrigin": "/subscriptions/xxxx-xxxx-xxxx-xxxx/resourceGroups/rg-pinhuang/providers/Microsoft.Network/vpnGateways/yyyyyyyyyyyyyyyyyyyy-canadacentral-gw"
+    }
+  ]
 }
```

### 3. Enable Propagate Default Route

``` bash
#
# Before
#
phil [ ~ ]$ ./snapshot-route-tables-from-vhub.sh
Create directory vhub-cc-20230225-221412
Save vhub-cc-20230225-221412/RouteTable/defaultRouteTable.json
Save vhub-cc-20230225-221412/RouteTable/noneRouteTable.json
Save vhub-cc-20230225-221412/VpnConnection/yyyyyyyyyyyyyyyyyyyy-canadacentral-gw.json

#
# Action
# Enable Propagate Default Route
# Time Estimation: ~2 minutes
#

#
# After
#
phil [ ~ ]$ ./snapshot-route-tables-from-vhub.sh
Create directory vhub-cc-20230225-221852
Save vhub-cc-20230225-221852/RouteTable/defaultRouteTable.json
Save vhub-cc-20230225-221852/RouteTable/noneRouteTable.json
Save vhub-cc-20230225-221852/VpnConnection/yyyyyyyyyyyyyyyyyyyy-canadacentral-gw.json

#
# Diff route tables
#
# Command: diff -bur before_dir after_dir
#
phil [ ~ ]$ diff -bur vhub-cc-20230225-221412 vhub-cc-20230225-221852
diff -bur vhub-cc-20230225-221412/RouteTable/noneRouteTable.json vhub-cc-20230225-221852/RouteTable/noneRouteTable.json
--- vhub-cc-20230225-221412/RouteTable/noneRouteTable.json      2023-02-25 14:14:39.592848956 +0000
+++ vhub-cc-20230225-221852/RouteTable/noneRouteTable.json      2023-02-25 14:19:19.728150102 +0000
@@ -1,26 +1,3 @@
 {
-  "value": [
-    {
-      "addressPrefixes": [
-        "192.168.79.0/24"
-      ],
-      "asPath": "",
-      "nextHopType": "VPN_S2S_Gateway",
-      "nextHops": [
-        "/subscriptions/xxxx-xxxx-xxxx-xxxx/resourceGroups/rg-pinhuang/providers/Microsoft.Network/vpnGateways/yyyyyyyyyyyyyyyyyyyy-canadacentral-gw"
-      ],
-      "routeOrigin": "/subscriptions/xxxx-xxxx-xxxx-xxxx/resourceGroups/rg-pinhuang/providers/Microsoft.Network/vpnGateways/yyyyyyyyyyyyyyyyyyyy-canadacentral-gw"
-    },
-    {
-      "addressPrefixes": [
-        "192.168.78.0/24"
-      ],
-      "asPath": "",
-      "nextHopType": "VPN_S2S_Gateway",
-      "nextHops": [
-        "/subscriptions/xxxx-xxxx-xxxx-xxxx/resourceGroups/rg-pinhuang/providers/Microsoft.Network/vpnGateways/yyyyyyyyyyyyyyyyyyyy-canadacentral-gw"
-      ],
-      "routeOrigin": "/subscriptions/xxxx-xxxx-xxxx-xxxx/resourceGroups/rg-pinhuang/providers/Microsoft.Network/vpnGateways/yyyyyyyyyyyyyyyyyyyy-canadacentral-gw"
-    }
-  ]
+  "value": []
 }
```

### 4. Add ExpressRoute Circuit

``` bash
#
# Before
#
phil [ ~ ]$ ./snapshot-route-tables-from-vhub.sh
Create directory vhub-cc-20230225-221852
Save vhub-cc-20230225-221852/RouteTable/defaultRouteTable.json
Save vhub-cc-20230225-221852/RouteTable/noneRouteTable.json
Save vhub-cc-20230225-221852/VpnConnection/yyyyyyyyyyyyyyyyyyyy-canadacentral-gw.json

# Action
# Add ExpressRourte circuit to Virtual Hub
# Time Estimation: ~7 minutes

#
# After
#
phil [ ~ ]$ ./snapshot-route-tables-from-vhub.sh
Create directory vhub-cc-20230225-230049
Save vhub-cc-20230225-230049/RouteTable/defaultRouteTable.json
Save vhub-cc-20230225-230049/RouteTable/noneRouteTable.json
Save vhub-cc-20230225-230049/VpnConnection/yyyyyyyyyyyyyyyyyyyy-canadacentral-gw.json
Save vhub-cc-20230225-230049/ExpressRouteConnection/zzzzzzzzzzzzzzzzzzzzzzzz-canadacentral-er-gw.json

#
# Diff route tables
#
# Command: diff -bur before_dir after_dir
#
phil [ ~ ]$ diff -bur vhub-cc-20230225-221852 vhub-cc-20230225-230049
Only in vhub-cc-20230225-230049/ExpressRouteConnection: zzzzzzzzzzzzzzzzzzzzzzzz-canadacentral-er-gw.json
diff -bur vhub-cc-20230225-221852/RouteTable/defaultRouteTable.json vhub-cc-20230225-230049/RouteTable/defaultRouteTable.json
--- vhub-cc-20230225-221852/RouteTable/defaultRouteTable.json   2023-02-25 14:19:07.768021059 +0000
+++ vhub-cc-20230225-230049/RouteTable/defaultRouteTable.json   2023-02-25 15:01:04.231665422 +0000
@@ -21,6 +21,149 @@
         "/subscriptions/xxxx-xxxx-xxxx-xxxx/resourceGroups/rg-pinhuang/providers/Microsoft.Network/vpnGateways/yyyyyyyyyyyyyyyyyyyy-canadacentral-gw"
       ],
       "routeOrigin": "/subscriptions/xxxx-xxxx-xxxx-xxxx/resourceGroups/rg-pinhuang/providers/Microsoft.Network/vpnGateways/yyyyyyyyyyyyyyyyyyyy-canadacentral-gw"
+    },
+    {
+      "addressPrefixes": [
+        "10.206.0.0/16"
+      ],
+      "asPath": "12076-12076-12076",
+      "nextHopType": "ExpressRouteGateway",
+      "nextHops": [
+        "/subscriptions/xxxx-xxxx-xxxx-xxxx/resourceGroups/rg-pinhuang/providers/Microsoft.Network/expressRouteGateways/zzzzzzzzzzzzzzzzzzzzzzzz-canadacentral-er-gw"
+      ],
+      "routeOrigin": "/subscriptions/xxxx-xxxx-xxxx-xxxx/resourceGroups/rg-pinhuang/providers/Microsoft.Network/expressRouteGateways/zzzzzzzzzzzzzzzzzzzzzzzz-canadacentral-er-gw"
     }
   ]
 }

diff -bur vhub-cc-20230225-221852/VpnConnection/yyyyyyyyyyyyyyyyyyyy-canadacentral-gw.json vhub-cc-20230225-230049/VpnConnection/yyyyyyyyyyyyyyyyyyyy-canadacentral-gw.json
--- vhub-cc-20230225-221852/VpnConnection/yyyyyyyyyyyyyyyyyyyy-canadacentral-gw.json        2023-02-25 14:19:32.808324522 +0000
+++ vhub-cc-20230225-230049/VpnConnection/yyyyyyyyyyyyyyyyyyyy-canadacentral-gw.json        2023-02-25 15:01:29.564058519 +0000
@@ -21,6 +21,149 @@
         "/subscriptions/xxxx-xxxx-xxxx-xxxx/resourceGroups/rg-pinhuang/providers/Microsoft.Network/vpnGateways/yyyyyyyyyyyyyyyyyyyy-canadacentral-gw"
       ],
       "routeOrigin": "/subscriptions/xxxx-xxxx-xxxx-xxxx/resourceGroups/rg-pinhuang/providers/Microsoft.Network/vpnGateways/yyyyyyyyyyyyyyyyyyyy-canadacentral-gw"
+    },
+    {
+      "addressPrefixes": [
+        "10.206.0.0/16"
+      ],
+      "asPath": "12076-12076-12076",
+      "nextHopType": "ExpressRouteGateway",
+      "nextHops": [
+        "/subscriptions/xxxx-xxxx-xxxx-xxxx/resourceGroups/rg-pinhuang/providers/Microsoft.Network/expressRouteGateways/zzzzzzzzzzzzzzzzzzzzzzzz-canadacentral-er-gw"
+      ],
+      "routeOrigin": "/subscriptions/xxxx-xxxx-xxxx-xxxx/resourceGroups/rg-pinhuang/providers/Microsoft.Network/expressRouteGateways/zzzzzzzzzzzzzzzzzzzzzzzz-canadacentral-er-gw"
     }
   ]
 }

#
# Diff ExpressRouteConnection and rout table
#

phil [ ~ ]$ diff -bur vhub-cc-20230225-230049/RouteTable/defaultRouteTable.json vhub-cc-20230225-230049/VpnConnection/yyyyyyyyyyyyyyyyyyyy-canadacentral-gw.json
phil [ ~ ]$ #There is no difference
```

### 5. Add VNet peering to virtual hub

```bash
#
# Before
#
phil [ ~ ]$ ./snapshot-route-tables-from-vhub.sh
Create directory vhub-cc-20230225-230049
Save vhub-cc-20230225-230049/RouteTable/defaultRouteTable.json
Save vhub-cc-20230225-230049/RouteTable/noneRouteTable.json
Save vhub-cc-20230225-230049/VpnConnection/yyyyyyyyyyyyyyyyyyyy-canadacentral-gw.json
Save vhub-cc-20230225-230049/ExpressRouteConnection/zzzzzzzzzzzzzzzzzzzzzzzz-canadacentral-er-gw.json

# Action
# Add VNet peering (a.k.a Virtual Network Connections) "vnet-pinchuang" to virtual hub
# - Propagate to none: No
# - Associate Route Table: Default
# - Bypass Next Hop IP for workloads within this VNet: No
# Time Estimation: ~2 minutes

#
# After
#
phil [ ~ ]$ ./snapshot-route-tables-from-vhub.sh
Create directory vhub-cc-20230225-231720
Save vhub-cc-20230225-231720/RouteTable/defaultRouteTable.json
Save vhub-cc-20230225-231720/RouteTable/noneRouteTable.json
Save vhub-cc-20230225-231720/VpnConnection/yyyyyyyyyyyyyyyyyyyy-canadacentral-gw.json
Save vhub-cc-20230225-231720/ExpressRouteConnection/zzzzzzzzzzzzzzzzzzzzzzzz-canadacentral-er-gw.json
Save vhub-cc-20230225-231720/HubVirtualNetworkConnection/conn-vnet-pinhuang.json

#
# Diff route tables
#
# Command: diff -bur before_dir after_dir
#
phil [ ~ ]$ diff -bur vhub-cc-20230225-230049 vhub-cc-20230225-231720
diff -bur vhub-cc-20230225-230049/ExpressRouteConnection/zzzzzzzzzzzzzzzzzzzzzzzz-canadacentral-er-gw.json vhub-cc-20230225-231720/ExpressRouteConnection/zzzzzzzzzzzzzzzzzzzzzzzz-canadacentral-er-gw.json
--- vhub-cc-20230225-230049/ExpressRouteConnection/zzzzzzzzzzzzzzzzzzzzzzzz-canadacentral-er-gw.json    2023-02-25 15:01:42.940213592 +0000
+++ vhub-cc-20230225-231720/ExpressRouteConnection/zzzzzzzzzzzzzzzzzzzzzzzz-canadacentral-er-gw.json    2023-02-25 15:18:13.456556431 +0000
@@ -164,6 +164,16 @@
         "/subscriptions/xxxx-xxxx-xxxx-xxxx/resourceGroups/rg-pinhuang/providers/Microsoft.Network/expressRouteGateways/zzzzzzzzzzzzzzzzzzzzzzzz-canadacentral-er-gw"
       ],
       "routeOrigin": "/subscriptions/xxxx-xxxx-xxxx-xxxx/resourceGroups/rg-pinhuang/providers/Microsoft.Network/expressRouteGateways/zzzzzzzzzzzzzzzzzzzzzzzz-canadacentral-er-gw"
+    },
+    {
+      "addressPrefixes": [
+        "10.0.0.0/16"
+      ],
+      "nextHopType": "Virtual Network Connection",
+      "nextHops": [
+        "/subscriptions/xxxx-xxxx-xxxx-xxxx/resourceGroups/rg-pinhuang/providers/Microsoft.Network/virtualHubs/vhub-cc/hubVirtualNetworkConnections/conn-vnet-pinhuang"
+      ],
+      "routeOrigin": "/subscriptions/xxxx-xxxx-xxxx-xxxx/resourceGroups/rg-pinhuang/providers/Microsoft.Network/virtualHubs/vhub-cc/hubVirtualNetworkConnections/conn-vnet-pinhuang"
     }
   ]
 }
Only in vhub-cc-20230225-231720/HubVirtualNetworkConnection: conn-vnet-pinhuang.json
diff -bur vhub-cc-20230225-230049/RouteTable/defaultRouteTable.json vhub-cc-20230225-231720/RouteTable/defaultRouteTable.json
--- vhub-cc-20230225-230049/RouteTable/defaultRouteTable.json   2023-02-25 15:01:04.231665422 +0000
+++ vhub-cc-20230225-231720/RouteTable/defaultRouteTable.json   2023-02-25 15:17:34.831948701 +0000
@@ -164,6 +164,16 @@
         "/subscriptions/xxxx-xxxx-xxxx-xxxx/resourceGroups/rg-pinhuang/providers/Microsoft.Network/expressRouteGateways/zzzzzzzzzzzzzzzzzzzzzzzz-canadacentral-er-gw"
       ],
       "routeOrigin": "/subscriptions/xxxx-xxxx-xxxx-xxxx/resourceGroups/rg-pinhuang/providers/Microsoft.Network/expressRouteGateways/zzzzzzzzzzzzzzzzzzzzzzzz-canadacentral-er-gw"
+    },
+    {
+      "addressPrefixes": [
+        "10.0.0.0/16"
+      ],
+      "nextHopType": "Virtual Network Connection",
+      "nextHops": [
+        "/subscriptions/xxxx-xxxx-xxxx-xxxx/resourceGroups/rg-pinhuang/providers/Microsoft.Network/virtualHubs/vhub-cc/hubVirtualNetworkConnections/conn-vnet-pinhuang"
+      ],
+      "routeOrigin": "/subscriptions/xxxx-xxxx-xxxx-xxxx/resourceGroups/rg-pinhuang/providers/Microsoft.Network/virtualHubs/vhub-cc/hubVirtualNetworkConnections/conn-vnet-pinhuang"
     }
   ]
 }
diff -bur vhub-cc-20230225-230049/VpnConnection/yyyyyyyyyyyyyyyyyyyy-canadacentral-gw.json vhub-cc-20230225-231720/VpnConnection/yyyyyyyyyyyyyyyyyyyy-canadacentral-gw.json
--- vhub-cc-20230225-230049/VpnConnection/yyyyyyyyyyyyyyyyyyyy-canadacentral-gw.json        2023-02-25 15:01:29.564058519 +0000
+++ vhub-cc-20230225-231720/VpnConnection/yyyyyyyyyyyyyyyyyyyy-canadacentral-gw.json        2023-02-25 15:17:59.956364682 +0000
@@ -164,6 +164,16 @@
         "/subscriptions/xxxx-xxxx-xxxx-xxxx/resourceGroups/rg-pinhuang/providers/Microsoft.Network/expressRouteGateways/zzzzzzzzzzzzzzzzzzzzzzzz-canadacentral-er-gw"
       ],
       "routeOrigin": "/subscriptions/xxxx-xxxx-xxxx-xxxx/resourceGroups/rg-pinhuang/providers/Microsoft.Network/expressRouteGateways/zzzzzzzzzzzzzzzzzzzzzzzz-canadacentral-er-gw"
+    },
+    {
+      "addressPrefixes": [
+        "10.0.0.0/16"
+      ],
+      "nextHopType": "Virtual Network Connection",
+      "nextHops": [
+        "/subscriptions/xxxx-xxxx-xxxx-xxxx/resourceGroups/rg-pinhuang/providers/Microsoft.Network/virtualHubs/vhub-cc/hubVirtualNetworkConnections/conn-vnet-pinhuang"
+      ],
+      "routeOrigin": "/subscriptions/xxxx-xxxx-xxxx-xxxx/resourceGroups/rg-pinhuang/providers/Microsoft.Network/virtualHubs/vhub-cc/hubVirtualNetworkConnections/conn-vnet-pinhuang"
     }
   ]
 }
```
