#!/bin/bash

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
if [ ! -f "./src/${mainClass}.java" ]; then
  echo "The main class ${mainClass} wasn't found"
  exit 1
fi

# Create the build directory if it doesn't exist
if [ ! -d "$buildDir" ]; then
  mkdir -p $buildDir
fi

# Compile files
cd ./src
javac -d "../${buildDir}" "${mainClass}.java"
cd ..

# Execute the compiled files
cd $buildDir && java $mainClass
