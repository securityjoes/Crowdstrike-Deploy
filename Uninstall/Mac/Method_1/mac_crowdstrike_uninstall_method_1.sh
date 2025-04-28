#!/bin/bash
expect <<- DONE
spawn /Applications/Falcon.app/Contents/Resources/falconctl uninstall -t
expect "Falcon Maintenance Token:"
send -- "PASTE_TOKEN_IN_HERE"
send -- "\r"
expect eof
DONE
