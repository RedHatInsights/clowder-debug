#!/usr/bin/env bash

if [[ "$1" == "" ]]; then
    echo "Please specify app name"
    exit 1
fi

pod_name="clowder-debug-$(uuid | cut -f 1 -d -)"

oc get secret $1 > /dev/null 2> /dev/null

if [[ $? != 0 ]]; then
    echo "App doesn't exist"
    exit 1
fi

oc process --local -f pod.yml -p POD_NAME=$pod_name -p SECRET_NAME=$1 -p IMAGE_TAG=$(git rev-parse --short=7 HEAD) | oc create -f -

echo Waiting for pod to become ready...
while [[ "$(oc get pod $pod_name -o json | jq -r '.status.phase')" != "Running" ]]; do
    sleep 2
done

oc exec -it $pod_name -- /usr/bin/bash

echo Dumping psql log to $pod_name-psql-history.log
oc exec $pod_name -- cat /tmp/db_output.txt > $pod_name-psql-history.log

oc delete pod $pod_name
