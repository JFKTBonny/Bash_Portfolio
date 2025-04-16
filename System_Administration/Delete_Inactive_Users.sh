#!/bin/bash
# This script delete users who have not logged in for a certain number of days...
set -e  # Exit on any error

# Define the inactivity period (in days)
INACTIVE_DAYS=90

# Get the username of the current session user (not root if using sudo)
CURRENT_USER=$(logname)

# Get users who haven't logged in in the last $INACTIVE_DAYS days
inactive_users=$(lastlog -b $INACTIVE_DAYS | awk 'NR>1 && $0 !~ /Never logged in/ {print $1}')

# Get users who have never logged in
never_logged_in=$(lastlog | awk '$0 ~ /Never logged in/ {print $1}')

# Combine both lists, removing duplicates
all_inactive_users=$(echo -e "$inactive_users\n$never_logged_in" | sort -u)

# Loop through each user and process deletion
for user in $all_inactive_users; do
    if id "$user" >/dev/null 2>&1; then
        uid=$(id -u "$user")
        
        if [ "$uid" -ge 1000 ] && [ "$user" != "$CURRENT_USER" ]; then
            echo "Deleting inactive user: $user (UID: $uid)"
            # Uncomment the line below to perform deletion:
            # userdel -r "$user"
        elif [ "$user" = "$CURRENT_USER" ]; then
            echo "Skipping currently logged-in user: $user"
        else
            echo "Skipping system user: $user (UID: $uid)"
        fi
    else
        echo "User $user does not exist."
    fi
done
