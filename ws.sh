#!/bin/bash

# Marker for the apps array
AM="#ARRAY_MARKER#"
# Marker for the open queue array
OA="#OPEN APP ARRAY#"

#Apps list
apps=("brave" "firefox" "code" "nvim" "obsidian" "discord" "telegram-desktop" "vlc" "spotify") #ARRAY_MARKER#

#Queue list
open_app_list=( ) #OPEN APP ARRAY#

# Display usage information
usage() {
    echo "Usage: $0 [-a] [-d]"
    echo "  -a    Add new app"
    echo "  -d    Delete app"
    echo "  -o    Open app"
    exit 1
}

# List all available apps
Apps() {
    echo "Available apps:"
    for app in "${apps[@]}"; do
        echo "- $app"
    done
    echo "--------------"
}

# Add a new app to the apps list
Addapp() {
    local class=$1
    
    #Add to list
    sed -i "/$AM/s/)/ \"$class\")/" "$0"
    
    echo "App '$class' added successfully!"
}

# Remove an app from the apps list
Deleteapp() {
    local class=$1

    #Delete from a list 
    sed -i "/$AM/s/ \"$class\"//" "$0"

    #Delete line
    sed -i "/$class | /d" "$0"

    echo "App '$class' deleted successfully!"
}

Open_app() {
    local openapp=$1
    local out=$2
    #Add app to queue list
    sed -i "/$OA/s/)/ \"$openapp\")/" "$0"

    if [ "$out" == "1" ]
    then
        echo "Launching all selected apps..."
        
        #Grep app from queue list
        list=$(grep ".*(.*$OA" "$0" | sed 's/.*(//;s/).*//' | tr -d '"')

        #Open app
        for op in $list; do
            if [ -n "$op" ]; then
                echo "Starting $op..."
                $op &> /dev/null &
            fi
        done
        
        #Remove queue list
        sed -i "/$OA/s/([^)]*)/( )/" "$0"
    fi
        
}

while getopts "ado" opt; do
    case $opt in 
        a)
            read -p "Enter app name (terminal command): " class_app
            Addapp "$class_app"
            ;;
        d)
            read -p "Enter app name to delete: " d_class
            Deleteapp "$d_class"
            ;;
        o)
            out=0
            Apps
            while [ "$out" != "1" ]; do

                read -p "Enter app to open: " op_app
                read -p "Done? (1 to finish, any key to continue): " out
                Open_app "$op_app" "$out"

            done
            ;;
        *) 
            usage
            ;;
    esac   
done

if [ $# -eq 0 ]; then
    Apps
fi