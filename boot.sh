#!/bin/bash
set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

usage() {
    echo "usage: $(basename $0) <groupid> <artifactid> <template-name>"
    echo "       $(basename $0) --list"
    echo "example: $(basename $0) de.dplatz webapp war-jee7"
}

list() {
    find $DIR -maxdepth 1 -type d -print
}

create() {
    local groupid=$1
    local artifactid=$2
    local template=$3

    if ! [ -d $DIR/$template ]; then
        echo "No template with name '$template'"
        exit 1
    fi

    if [ -z "$groupid" ]; then
        echo "No groupid given"
        exit 1
    fi

    if [ -z "$artifactid" ]; then
        echo "No artifactid given"
        exit 1
    fi
    
    clear
    echo "Creating project named '$artifactid' from template '$template' in current folder"
    cp -r $DIR/$template $artifactid

    find $artifactid -type d -name "packagename" | while read dir; do
        # Derive packagenames from groupid/artifactid
        local parent=$(dirname $dir)
        local artifact_dir="${artifactid//-/}"
        local package_dirs="${groupid//.//}/${artifact_dir}"
        local package_path="$parent/$package_dirs"
        mkdir -p "$package_path"
        mv $dir/* $package_path/ || true
        rm -rf $dir
    done

    # Fix packagenames in Java-code
    local java_package_name="${groupid}.${artifactid//-/}"
    find $artifactid -type f \( -name "*.java" -o -name "build.gradle" \) -exec sed -i "s/packagename/${java_package_name}/g" {} \;

    # Fix subproject folder-names
    find $artifactid -type d -name "template-artifactid-*" -print0
    find $artifactid -type d -name "template-artifactid-*" | while read file; do \
        #dir=$(dirname $f)
        #file=$(basename $f)
        #rename "s/template-artifactid-(.*)\$/$artifactid-\$1/" $f
        newfile=${file/template-artifactid/$artifactid}
        mv $file $newfile
    done;

    # Set groupid/artifactid in pom.xml/build.gradle
    find $artifactid -type f -exec sed -i "s/template-artifactid/${artifactid}/g" {} \;
    find $artifactid -type f -exec sed -i "s/template-groupid/${groupid}/g" {} \;

    if [[ "$artifactid" == *-st ]]; then
        # system-test project
        parentid=${artifactid%-st}
        if [ -d "$parentid" ]; then
            parentpath=$(realpath $parentid)
            echo "Found parent-project @ $parentpath"
            echo "PROJECT=$parentpath" >> $artifactid/.env
            echo "COMPOSE_PROJECT_NAME=$parentid" >> $artifactid/.env
            find $parentpath -type f -exec sed -i "s/appname/${parentid}/g" {} \;
            find $artifactid -type f -exec sed -i "s/appname/${parentid}/g" {} \;
        fi
    fi

    tree -C $artifactid/
}

case $1 in
    -l|--list)
    list
    exit 0
    ;;
    -h|--help)
    usage
    exit 0
    ;;
esac

if [ "$1" == "" ] | [ "$2" == "" ]; then
    usage
    exit 1
fi

create $1 $2 $3