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
    # The type of the specified resource like RouteTable, ExpressRouteConnection, HubVirtualNetworkConnection, VpnConnection and P2SConnection.
    if [ ! -d $dir_name ]; then
        mkdir -p $dir_name/RouteTable
        mkdir -p $dir_name/VpnConnection
        mkdir -p $dir_name/ExpressRouteConnection
        mkdir -p $dir_name/HubVirtualNetworkConnection
        mkdir -p $dir_name/P2SConnection
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
    az network vhub get-effective-routes \
        --resource-type RouteTable \
        --resource-id ${rt_id} \
        --resource-group ${RESOURCE_GROUPNAME} \
        --name ${VHUB_NAME} \
        --query "value[].{addressPrefixes:addressPrefixes[0], asPath:asPath, nextHopType:nextHopType}" \
        --output table > $dir_name/RouteTable/$filename

    # Check the status of the previous command
    if [ $? -ne 0 ]; then
        echo "Failed to get effective routes for route table $rt_name"
        exit 1
    else
        echo "Save $dir_name/RouteTable/$filename"
        cat $dir_name/RouteTable/$filename
        echo
    fi
done


# Get VPN gateway resource id
vpn_gateways=$(az network vpn-gateway list --resource-group ${RESOURCE_GROUPNAME} --query "[].{name: name, id: id}" --output json | jq -c ".[]")
if [ $? -ne 0 ]; then
    echo "Failed to get VPN gateway IDs"
    exit 1
fi

for vpn_gateway in $vpn_gateways; do
    # Get the route table name and ID
    vpn_gateway_name=$(echo $vpn_gateway | jq -r '.name')
    vpn_gateway_id=$(echo $vpn_gateway | jq -r '.id')

    if $DEBUG_OUTPUT; then
        echo "VPN gateway name: $vpn_gateway_name"
        echo "VPN gateway ID: $vpn_gateway_id"
    fi

    # Create the output filename
    filename="${vpn_gateway_name}.json"

    # Call the get-effective-routes command and output the results in JSON format
    az network vhub get-effective-routes \
        --resource-type VpnConnection \
        --resource-id ${vpn_gateway_id} \
        --resource-group ${RESOURCE_GROUPNAME} \
        --name ${VHUB_NAME} \
        --query "value[].{addressPrefixes:addressPrefixes[0], asPath:asPath, nextHopType:nextHopType}" \
        --output table > $dir_name/VpnConnection/$filename

    # Check the status of the previous command
    if [ $? -ne 0 ]; then
        echo "Failed to get effective routes for VPN gateway $vpn_gateway_name"
        exit 1
    else
        echo "Save $dir_name/VpnConnection/$filename"
        cat $dir_name/VpnConnection/$filename
        echo
    fi
done


# Get ExpressRoute gateway resource id
express_route_gateways=$(az network express-route gateway list --resource-group ${RESOURCE_GROUPNAME} --query "value[].{name: name, id: id}" --output json | jq -c ".[]")
if [ $? -ne 0 ]; then
    echo "Failed to get ExpressRoute gateway IDs"
    exit 1
fi

for express_route_gateway in $express_route_gateways; do
    # Get the route table name and ID
    express_route_gateway_name=$(echo $express_route_gateway | jq -r '.name')
    express_route_gateway_id=$(echo $express_route_gateway | jq -r '.id')

    if $DEBUG_OUTPUT; then
        echo "ExpressRoute gateway name: $express_route_gateway_name"
        echo "ExpressRoute gateway ID: $express_route_gateway_id"
    fi

    # Create the output filename
    filename="${express_route_gateway_name}.json"

    # Call the get-effective-routes command and output the results in JSON format
    az network vhub get-effective-routes \
        --resource-type ExpressRouteConnection \
        --resource-id ${express_route_gateway_id} \
        --resource-group ${RESOURCE_GROUPNAME} \
        --name ${VHUB_NAME} \
        --query "value[].{addressPrefixes:addressPrefixes[0], asPath:asPath, nextHopType:nextHopType}" \
        --output table > $dir_name/ExpressRouteConnection/$filename

    # Check the status of the previous command
    if [ $? -ne 0 ]; then
        echo "Failed to get effective routes for ExpressRoute gateway $express_route_gateway_name"
        exit 1
    else
        echo "Save $dir_name/ExpressRouteConnection/$filename"
        cat $dir_name/ExpressRouteConnection/$filename
        echo
    fi
done

# Get the list of virtual network connection IDs
virtual_network_connections=$(az network vhub connection list --resource-group ${RESOURCE_GROUPNAME} --vhub-name ${VHUB_NAME} --output json --query "[].{name: name, id: id}" | jq -c ".[]")
if [ $? -ne 0 ]; then
    echo "Failed to get virtual network connection IDs"
    exit 1
fi

# Loop over the virtual network connection IDs and get the effective routes for each
for vnc in $virtual_network_connections; do
    # Get the virtual network connection name and ID
    vnc_name=$(echo $vnc | jq -r '.name')
    vnc_id=$(echo $vnc | jq -r '.id')

    if $DEBUG_OUTPUT; then
        echo "Virtual network connection name: $vnc_name"
        echo "Virtual network connection ID: $vnc_id"
    fi

    # Create the output filename
    filename="${vnc_name}.json"

    # Call the get-effective-routes command and output the results in JSON format
    az network vhub get-effective-routes \
        --resource-type HubVirtualNetworkConnection \
        --resource-id ${vnc_id} \
        --resource-group ${RESOURCE_GROUPNAME} \
        --name ${VHUB_NAME} \
        --query "value[].{addressPrefixes:addressPrefixes[0], asPath:asPath, nextHopType:nextHopType}" \
        --output table > $dir_name/HubVirtualNetworkConnection/$filename

    # Check the status of the previous command
    if [ $? -ne 0 ]; then
        echo "Failed to get effective routes for virtual network connection $vnc_name"
        exit 1
    else
        echo "Save $dir_name/HubVirtualNetworkConnection/$filename"
        cat $dir_name/HubVirtualNetworkConnection/$filename
        echo
    fi
done


# Get the list of P2S connection IDs
p2s_connections=$(az network vpn-connection list --resource-group ${RESOURCE_GROUPNAME} --output json --query "[].{name: name, id: id}" | jq -c ".[]")
if [ $? -ne 0 ]; then
    echo "Failed to get P2S connection IDs"
    exit 1
fi

# Loop over the P2S connection IDs and get the effective routes for each
for p2s in $p2s_connections; do
    # Get the P2S connection name and ID
    p2s_name=$(echo $p2s | jq -r '.name')
    p2s_id=$(echo $p2s | jq -r '.id')

    if $DEBUG_OUTPUT; then
        echo "P2S connection name: $p2s_name"
        echo "P2S connection ID: $p2s_id"
    fi

    # Create the output filename
    filename="${p2s_name}.json"

    # Call the get-effective-routes command and output the results in JSON format
    az network vhub get-effective-routes \
        --resource-type P2SConnection \
        --resource-id ${p2s_id} \
        --resource-group ${RESOURCE_GROUPNAME} \
        --name ${VHUB_NAME} \
        --output table > $dir_name/P2SConnection/$filename

    # Check the status of the previous command
    if [ $? -ne 0 ]; then
        echo "Failed to get effective routes for P2S connection $p2s_name"
        exit 1
    else
        echo "Save $dir_name/P2SConnection/$filename"
        cat $dir_name/P2SConnection/$filename
        echo
    fi
done

# End of script
