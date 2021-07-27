#!/usr/bin/env bash

if [[ "$1" == "" ]]; then
    echo "Please specify app name"
    exit 1
fi

oc get secret $1 > /dev/null 2> /dev/null

if [[ $? != 0 ]]; then
    echo "App doesn't exist"
    exit 1
fi

oc process --local -f pod.yml -p SECRET_NAME=$1 | oc create -f -

echo Waiting for pod to become ready...
while [[ "$(oc get pod clowder-debug -o json | jq -r '.status.phase')" != "Running" ]]; do
    sleep 2
done

oc attach -it clowder-debug

oc delete pod clowder-debug
