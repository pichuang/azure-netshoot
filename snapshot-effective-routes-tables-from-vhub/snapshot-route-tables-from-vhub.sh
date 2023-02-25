#!/bin/bash

# Specify the resource group and vhub names
RESOURCE_GROUPNAME="rg-pinhuang"
VHUB_NAME="vhub-cc"
TIMEZONE="Asia/Taipei"
DEBUG_OUTPUT=false # true or false

# Get the current timestamp
timestamp="$(TZ=${TIMEZONE} date +%Y%m%d-%H%M%S)"

# Get the resource ID
resource_id=$(az network vhub list --resource-group ${RESOURCE_GROUPNAME} --output tsv --query '[].id')
if [ $? -ne 0 ]; then
    echo "Failed to get resource ID"
    exit 1
else
    if $DEBUG_OUTPUT; then
        echo "vHub Resource ID: $resource_id"
    fi
    dir_name="${VHUB_NAME}-${timestamp}"

    # if the directory doesn't exist, create it
    if [ ! -d $dir_name ]; then
        mkdir -p $dir_name
        echo "Create directory $dir_name"
    else
        echo "Directory $dir_name already exists"
    fi
fi

# Get the list of route table IDs
route_tables=$(az network vhub route-table list --resource-group ${RESOURCE_GROUPNAME} --vhub-name ${VHUB_NAME} --output json --query "[].{name: name, id: id}" | jq -c ".[]")
if [ $? -ne 0 ]; then
    echo "Failed to get route table IDs"
    exit 1
fi

# Loop over the route table IDs and get the effective routes for each
for rt in $route_tables; do
    # Get the route table name and ID
    rt_name=$(echo $rt | jq -r '.name')
    rt_id=$(echo $rt | jq -r '.id')

    if $DEBUG_OUTPUT; then
        echo "Route table name: $rt_name"
        echo "Route table ID: $rt_id"
    fi

    # Create the output filename
    filename="${rt_name}.json"

    # Call the get-effective-routes command and output the results in JSON format
    az network vhub get-effective-routes --resource-type RouteTable --resource-id ${rt_id} --resource-group ${RESOURCE_GROUPNAME} --name ${VHUB_NAME} --output json > $dir_name/$filename

    # Check the status of the previous command
    if [ $? -ne 0 ]; then
        echo "Failed to get effective routes for route table $rt_name"
        exit 1
    else
        echo "Save ${filename}"
    fi
done
# End of script
