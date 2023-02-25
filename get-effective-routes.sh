#!/bin/bash

# Specify the resource group and vhub names
RESOURCE_GROUPNAME="rg-pinhuang"
VHUB_NAME="vhub-cc"

# Get the current timestamp
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

# Get the resource ID
RESOURCE_ID=$(az network vhub list --resource-group ${RESOURCE_GROUPNAME} --output tsv --query '[].id')
if [ $? -ne 0 ]; then
    echo "Failed to get resource ID"
    exit 1
fi

# Get the list of route table IDs
ROUTE_TABLES=$(az network vhub route-table list --resource-group ${RESOURCE_GROUPNAME} --vhub-name ${VHUB_NAME} --output tsv --query '[].[name, id]')
if [ $? -ne 0 ]; then
    echo "Failed to get route table IDs"
    exit 1
fi

# Loop over the route table IDs and get the effective routes for each
for rt in $ROUTE_TABLES; do
    # Get the route table name and ID
    rt_name=$(echo $rt | awk '{print $1}')
    rt_id=$(echo $rt | awk '{print $2}')
    echo "Route table name: $rt_name"
    echo "Route table ID: $rt_id"

    # Create the output filename
    filename="${rt_name}-${TIMESTAMP}.json"

    # Call the get-effective-routes command and output the results in JSON format
    az network vhub get-effective-routes --resource-type RouteTable --resource-id ${rt} --resource-group ${RESOURCE_GROUPNAME} --name ${VHUB_NAME} --output json > $filename
done
# End of script
