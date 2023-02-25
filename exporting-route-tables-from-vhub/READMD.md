# Exporting Route Tables from vHub

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
$ bash export_route_tables.sh
```

5. The script will create a directory with the format `VHUB_NAME-YYYYMMDD` and save each route table to a separate JSON file in that directory.

## Demo

```
phil [ ~ ]$ ./get-effective-routes.sh
Directory vhub-cc-20230225 already exists
Save defaultRouteTable-20230225-022901.json
Save noneRouteTable-20230225-022901.json

phil [ ~ ]$ ls
exporting-route-tables-from-vhub.sh vhub-cc-20230225

phil [ ~ ]$ ls -la vhub-cc-20230225/
total 32
drwxr-xr-x 2 phil phil 4096 Feb 25 02:29 .
drwxr-xr-x 6 phil phil 4096 Feb 25 02:22 ..
-rw-r--r-- 1 phil phil 1090 Feb 25 02:29 defaultRouteTable-20230225-022901.json
-rw-r--r-- 1 phil phil   18 Feb 25 02:29 noneRouteTable-20230225-022901.json
```


## Requirements

Make sure that you have installed the Azure CLI and jq command-line JSON processor before running the script.

- Azure CLI
- `jq` command-line JSON processor

