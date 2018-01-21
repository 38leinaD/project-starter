#!/bin/bash
set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

usage() {
    echo "usage: $(basename $0) <template-name> <groupid> <artifactid>"
    echo "       $(basename $0) --list"
    echo "example: $(basename $0) war-jee7 de.dplatz webapp"
}

list() {
    find $DIR -maxdepth 1 -type d -print
}

create() {
    local template=$1
    local groupid=$2
    local artifactid=$3

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

    echo "Creating project named '$artifactid' from template '$template' in current folder"
    mkdir -p $artifactid
    cp -r $DIR/$template/* $artifactid/

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
    find $artifactid -type f -name "*.java" -exec sed -i "s/packagename/${java_package_name}/g" {} \;

    # Set groupid/artifactid in pom.xml/build.gradle
    find $artifactid -type f -exec sed -i "s/template-artifactid/${artifactid}/g" {} \;
    find $artifactid -type f -exec sed -i "s/template-groupid/${groupid}/g" {} \;
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