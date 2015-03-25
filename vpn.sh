#! /usr/bin/env bash

if (( EUID != 0 )); then
  echo "Please run this command with sudo" 1>&2
  exit 1
fi
WIRELESS_INTERFACE=en1
TUNNEL_INTERFACE=ppp0
GATEWAY=$(netstat -nrf inet | grep default | grep $WIRELESS_INTERFACE | awk '{print $2}')

echo "Resetting routes with gateway => $GATEWAY"
echo

route -n delete default -ifscope $WIRELESS_INTERFACE
route -n delete -net default -interface $TUNNEL_INTERFACE
route -n delete -net 0/1 -interface $TUNNEL_INTERFACE

route -n delete 10.84.16.1

route -n add -net default $GATEWAY

for subnet in 10.99.55 10.99.30
do
  route -n add -net $subnet -interface $TUNNEL_INTERFACE
done
