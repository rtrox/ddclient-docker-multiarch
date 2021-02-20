#!/bin/bash
cp /defaults/ddclient.conf /ddclient.conf
trap 'exit 0' TERM SIGINT
/usr/bin/ddclient --foreground $@
