#!/bin/bash

# Extract firewall policies using awk
policies=$(awk '/config firewall policy/,/end/ {print}' fortigate_config.txt)

# Define the CSV file
csv_file="firewall_policies.csv"

# Write the policies to the CSV file
echo "Name,Source Interface,Destination Interface,Source Address,Destination Address,Action,Schedule,Service" > "$csv_file"
echo "$policies" | awk '/edit/ {name=""; srcintf=""; dstintf=""; srcaddr=""; dstaddr=""; action=""; schedule=""; service="";}
    /set name/ {name=$3;}
    /set srcintf/ {srcintf=$3;}
    /set dstintf/ {dstintf=$3;}
    /set srcaddr/ {srcaddr=$3;}
    /set dstaddr/ {dstaddr=$3;}
    /set action/ {action=$3;}
    /set schedule/ {schedule=$3;}
    /set service/ {service=$3; printf("%s,%s,%s,%s,%s,%s,%s,%s\n", name, srcintf, dstintf, srcaddr, dstaddr, action, schedule, service) >> "'$csv_file'";}
' 

echo "Firewall policies extracted and saved to $csv_file"
