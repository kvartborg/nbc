#!/bin/bash

# Check what version of nbcompile is running
if [ "$1" == "--version" ] || [ "$1" == "-v" ]; then
  echo "[version]"
  exit 0
fi

# Check if PWD is a NetBeans Project
if [ ! -d "./nbproject" ] || [ ! -d "./src" ]; then
  echo "Not a netbeans project"
  exit 1
fi

# Get the main class and build directory from the project properties
properties="./nbproject/project.properties"
buildDirProperty=$(cat $properties | grep "build.dir=")
mainClassProperty=$(cat $properties | grep "main.class=")
buildDir="${buildDirProperty/build.dir=/}/classes"
mainClass="${mainClassProperty/main.class=/}"

# Compile source
if [ ! -f "./src/$(echo $mainClass | tr . /).java" ]; then
  echo "The main class ${mainClass} wasn't found"
  exit 1
fi


if [ "$1" == "clean" ]; then
  eval "ant -f $(pwd) -Dnb.internal.action.name=rebuild clean jar > /dev/null"
fi

# run program
eval "ant -f $(pwd) -Dnb.internal.action.name=run run > /dev/null"
