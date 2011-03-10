#!/bin/bash

# This test ensures that:
# 1) None works as a filter
# 2) You can dynamically change filter and it has effect.
# 3) Config change is persistent.

mv ./canto.xml /tmp/
ln -sf /tmp/canto.xml /tmp/canto2.xml

canto-remote -D ./ script <<EOF
WATCHTAGS [ "Static", "Static 2" ]

# Add feed
SETCONFIGS { "Feed Static" : { "url" : "file:///tmp/canto.xml" } }
SETCONFIGS { "Feed Static 2" : { "url" : "file:///tmp/canto2.xml" } }
UPDATE {}
REMOTE_IGNORE 10

# Get ITEMS, should be all 5
ITEMS [ "Static", "Static 2" ]
REMOTE_WAIT 1

# Set some items to be filtered by filter_read
SETATTRIBUTES { (u'file:///tmp/canto.xml', u'http://codezen.org/canto/news/94') : { "canto-state" : [ "read" ]}, (u'file:///tmp/canto.xml', u'http://codezen.org/canto/news/93') : { "canto-state" : [ "read" ] } }
SETATTRIBUTES { (u'file:///tmp/canto2.xml', u'http://codezen.org/canto/news/92') : { "canto-state" : [ "read" ]}, (u'file:///tmp/canto2.xml', u'http://codezen.org/canto/news/91') : { "canto-state" : [ "read" ] } }

# Get ITEMS, should still be all 5
ITEMS [ "Static", "Static 2" ]
REMOTE_WAIT 1

# Switch the filter.
SETCONFIGS { "defaults" : { "global_transform" : "filter_read" } }
REMOTE_IGNORE 12

# This should be different because of the filterset.
ITEMS [ "Static", "Static 2"]
REMOTE_WAIT 1
EOF