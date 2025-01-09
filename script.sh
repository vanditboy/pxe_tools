#!/bin/bash

set -x

export API_PORT="8001"

# admin-api service
printf "Checking admin-api service:\n\n"
curl -s -H "Kong-Admin-Token: $KONG_PASSWORD" ${KONG_ADMIN_GUI_URL}:${API_PORT}/services | grep "admin-api" > /dev/null 2>&1
CHECK_ADMIN_API_SERVICE=$?
printf "\nService check status: $CHECK_ADMIN_API_SERVICE\n\n"

if [ $CHECK_ADMIN_API_SERVICE -eq 1 ]; then
  printf "Adding admin-api service:\n\n"
  curl -s -X POST -H "Kong-Admin-Token: $KONG_PASSWORD" ${KONG_ADMIN_GUI_URL}:${API_PORT}/services --data name=admin-api --data host=kong-admin-api --data port=8001
fi

# admin-api route
printf "\nChecking admin-api route:\n\n"
curl -s -H "Kong-Admin-Token: $KONG_PASSWORD" ${KONG_ADMIN_GUI_URL}:${API_PORT}/services/admin-api/routes | grep "/admin-api" > /dev/null 2>&1 
CHECK_ADMIN_API_ROUTE=$?
printf "\nRoute check status: $CHECK_ADMIN_API_ROUTE\n\n"

if [ $CHECK_ADMIN_API_ROUTE -eq 1 ]; then
  printf "\n\nAdding admin-api route:\n\n"
  curl -X POST -H "Kong-Admin-Token: $KONG_PASSWORD" ${KONG_ADMIN_GUI_URL}:${API_PORT}/services/admin-api/routes --data "paths[]=/admin-api"
fi

# admin-ui service
printf "\nChecking admin-ui service:\n\n"
curl -s -H "Kong-Admin-Token: $KONG_PASSWORD" ${KONG_ADMIN_GUI_URL}:${API_PORT}/services | grep "admin-ui" > /dev/null 2>&1
CHECK_ADMIN_UI_SERVICE=$?
printf "\nService check status: $CHECK_ADMIN_UI_SERVICE\n\n"

if [ $CHECK_ADMIN_UI_SERVICE -eq 1 ]; then
  printf "\n\nAdding admin-ui service:\n\n"
  curl -X POST -H "Kong-Admin-Token: $KONG_PASSWORD" ${KONG_ADMIN_GUI_URL}:${API_PORT}/services --data name=admin-ui --data host=kong-admin-ui --data port=8002
fi

# admin-ui route
printf "\nChecking admin-ui route:\n\n"
curl -s -H "Kong-Admin-Token: $KONG_PASSWORD" ${KONG_ADMIN_GUI_URL}:${API_PORT}/services/admin-ui/routes | grep "/admin-ui" > /dev/null 2>&1
CHECK_ADMIN_UI_ROUTE=$?
printf "\nService check status: $CHECK_ADMIN_UI_ROUTE\n\n"

if [ $CHECK_ADMIN_UI_ROUTE -eq 1 ]; then
  printf "\n\nAdding admin-ui route:\n\n"
  curl -X POST -H "Kong-Admin-Token: $KONG_PASSWORD" ${KONG_ADMIN_GUI_URL}:${API_PORT}/services/admin-ui/routes --data "paths[]=/admin-ui" --data strip_path=false
fi
