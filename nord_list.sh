#!/bin/bash

# Clean up previous files
rm *.nord_list

# Loop through DNS
base_domain=nordvpn.com
for i in $(seq 2000 30000); do
  domain="us$i.$base_domain"
  #echo "Processing domain: $domain"
  # Perform actions with the domain
  ip_address=$(dig +short "$domain" @8.8.8.8)
  exit_status=$?
  if ! [ -z "$ip_address" ]; then
    api_response=$(curl -sS http://demo.ip-api.com/json/${ip_address})
    city=$(echo "$api_response" | jq -r .city)
    region=$(echo "$api_response" | jq -r .region)
    countryCode=$(echo "$api_response" | jq -r .countryCode)
    echo "${domain}, ${ip_address}, ${city}, ${region}, ${countryCode}"
    echo "${domain}, ${ip_address}, ${city}, ${region}, ${countryCode}" >> compete.nord_list
    if ! [ -z "$countryCode" ]; then
      echo "${ip_address}" >> ${countryCode}-ip.nord_list
      echo "${domain}" >> ${countryCode}-domain.nord_list
    fi
    if ! [ -z "$region" ]; then
      echo "${ip_address}" >> ${region}_${countryCode}-ip.nord_list
      echo "${domain}" >> ${region}_${countryCode}-domain.nord_list
    fi
      sleep 2
  fi
done
