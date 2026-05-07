#!/bin/bash

AM="#ARRAY_MARKER#"

apps=("brave-bin" "firefox" "code" "nvim" "obsidian" "discord" "telegram-desktop" "vlc" "spotify") #ARRAY_MARKER#

usage() {
    echo "Usage: $0 [-a] [-d]"
    echo "  -a    Add new app"
    echo "  -d    Delete app"
    exit 1
}

Apps() {
    echo "Available apps:"
    for app in "${apps[@]}"; do
        echo "- $app"
    done
    echo "--------------"
}

Addapps() {
    local class=$1
    
    #Add to list
    sed -i "/$AM/s/)/ \"$class\")/" "$0"
    
    echo "App '$class' added successfully!"
}

Deleteapps() {
    local class=$1

    #Delete from a list 
    sed -i "/$AM/s/ \"$class\"//" "$0"

    #Delete line
    sed -i "/$class | /d" "$0"

    echo "App '$class' deleted successfully!"
}

while getopts "ad" opt; do
    case $opt in 
        a)
            read -p "Enter app class (Terminal Command): " class_app
            Addapps "$class_app"
            ;;
        d)
            read -p "Enter app class to delete: " d_class
            Deleteapps "$d_class"
            ;;
        *) 
            usage
            ;;
    esac   
done

if [ $# -eq 0 ]; then
    Apps
fi