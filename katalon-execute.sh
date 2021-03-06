#!/usr/bin/env bash

set -xe

XVFB=/usr/bin/Xvfb
XVFBARGS="$DISPLAY -screen 0 $DISPLAY_CONFIGURATION -fbdir /var/run -ac"
PIDFILE=/var/run/xvfb.pid

echo "Starting Katalon Studio"

current_dir=$(pwd)

# create tmp directory
tmp_dir=$KATALON_KATALON_ROOT_DIR/tmp
mkdir -p $tmp_dir
chmod -R 777 $tmp_dir

# project source code
project_dir=$KATALON_KATALON_ROOT_DIR/project
mkdir -p $project_dir
cp -r $KATALON_KATALON_ROOT_DIR/source/. $project_dir
# create .classpath if not exist
touch $project_dir/.classpath || exit
chmod -R 777 $project_dir

# report
report_dir=$KATALON_KATALON_ROOT_DIR/report
mkdir -p $report_dir

# build command line
# project_file=$(find $project_dir -maxdepth 1 -type f -name "*.prj")
# cmd="$KATALON_KATALON_INSTALL_DIR/katalon -runMode=console -reportFolder=$report_dir -projectPath=$project_file $KATALON_OPTS"

echo -n "Starting virtual X frame buffer $DISPLAY $DISPLAY_CONFIGURATION"
start-stop-daemon --start --quiet --pidfile $PIDFILE --make-pidfile --background --exec $XVFB -- $XVFBARGS
echo "."

cd $tmp_dir
# eval "$cmd"

chmod -R 777 $report_dir

cd $current_dir