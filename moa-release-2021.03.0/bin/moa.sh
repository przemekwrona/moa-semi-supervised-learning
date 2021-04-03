#!/bin/bash

BASEDIR=`dirname $0`/..
BASEDIR=`(cd "$BASEDIR"; pwd)`
MEMORY=512m
java -Xmx$MEMORY -cp "$BASEDIR/lib/moa-2018.07.0-SNAPSHOT:$BASEDIR/lib/*" -javaagent:$BASEDIR/lib/sizeofag-1.0.4.jar moa.gui.GUI

