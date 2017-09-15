#!/usr/bin/expect
spawn tightvncserver :1
expect "Password:"
send "2342344\r"
expect "Verify:"
send "2342344\r"
expect "Would you like to enter a view-only password (y/n)?"
send "n\n"
expect off
