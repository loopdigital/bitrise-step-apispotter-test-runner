#!/bin/bash
set -ex

#Absolute path of the project dir.
STEP_DIR=$( cd "$(dirname "$0")" ; pwd -P )


#install gems
gem install json


#Execute the main.rb
e=$(ruby "${STEP_DIR}/app/main.rb" $apispotter_api_token $apispotter_test_group_id $abort_build )


#Finalize
r='^[0-9]+$'

if ! [[ $e  =~ $r ]]; then
    #Fatal error
    echo "An error occured: ${e}"
    exit 1
else
    
    echo "Test group runned."
    exit 0
   
fi
