#!/bin/bash

# Check what version of nbcompile is running
if [ "$1" == "--version" ] || [ "$1" == "-v" ]; then
  echo "[version]"
  exit 0
fi

# Check what version of nbcompile is running
if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
  echo "nbcompile [version]"
  echo ""
  echo "Navigate to a NetBeans project and run the nbcompile command within the project root"
  echo ""
  echo "Usage:"
  echo "  nbcompile [command]"
  echo ""
  echo "Commands:"
  echo "  run     (default) Compiles and executes the program."
  echo "  clean   Clean build and dist directories before execution (same as clean and build)."
  echo ""
  echo "Options:"
  echo "  -h, --help      Prints helpful information."
  echo "  -v, --version   Current version."
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
transform="| grep '\[java\]' | sed -E 's/\[java\]+/ /g' | sed -E 's/(\.\.\.).[0-9].(\bmore\b)?.*/ /g' | sed -E 's/       //g'"

# Run clean & build
if [ "$1" == "clean" ]; then
  eval "$command -Dnb.internal.action.name=rebuild clean jar $transform"
fi

# run program
if [ ! -z "$1" ] && [ "$1" != "run" ] && [ "$1" != "clean" ]; then
  echo "Invalid command: $1"
  echo "Need help?"
  echo "   nbcompile --help"
  exit 1;
fi

eval "$command -Dnb.internal.action.name=run run $transform"
