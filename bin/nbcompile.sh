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
buildDir="./${buildDirProperty/build.dir=/}/classes"
mainClass="${mainClassProperty/main.class=/}"

# Compile source
if [ ! -f "./src/${mainClass}.java" ]; then
  echo "The main class ${mainClass} wasn't found"
  exit 1
fi

cd ./src
javac "${mainClass}.java"
cd ..

# Move compiled files to build Directory
if [ ! -d "$buildDir" ]; then
  mkdir -p $buildDir
fi

cp -r ./src/* $buildDir

# Clean up
rm $buildDir/*.java
rm $buildDir/**/*.java 2> /dev/null
rm ./src/*.class
rm ./src/**/*.class 2> /dev/null

# Execute the compiled files
cd $buildDir && java $mainClass
