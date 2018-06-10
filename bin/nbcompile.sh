#!/bin/bash

# Check what version of nbcompile is running
if [ "$1" == "--version" ] || [ "$1" == "-v" ]; then
  echo "1.3.0"
  exit 0
fi

# Check if PWD is a NetBeans Project
if [ ! -d "./nbproject" ] || [ ! -d "./src" ]; then
  echo "Not a netbeans project"
  exit 1
fi

# Get the main class and build directory from the project properties
properties="./nbproject/project.properties"
mainClassProperty=$(cat $properties | grep "main.class=")
mainClass="${mainClassProperty/main.class=/}"

# Compile source
if [ ! -f "./src/$(echo $mainClass | tr . /).java" ]; then
  echo "The main class ${mainClass} wasn't found"
  exit 1
fi

command="ant -f $(pwd)"
args="| grep '\[java\]' | sed -E 's/\[java\]+/ /g' | sed -E 's/(\.\.\.).[0-9].(\bmore\b)?.*/ /g' | sed -E 's/       //g'"

# Run clean
if [ "$1" == "clean" ]; then
  eval "$command -Dnb.internal.action.name=rebuild clean jar $args"
fi

# run program
eval "$command -Dnb.internal.action.name=run run $args"
