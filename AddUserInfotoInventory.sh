#!/bin/bash

# Add user details to specific casper computer record

# Author      : r.purves@arts.ac.uk

# Version 1.0 : 1-11-2013 - Initial Version
# Version 1.1 : 6-01-2014 - Now interrogates AD directly instead of cached user data

# Get the logged in users username
loggedInUser=`/bin/ls -l /dev/console | /usr/bin/awk '{print $3}'`

# Get UniqueID
accountType=`dscl "/Active Directory/DOMAIN/domain.local" -read /Users/$loggedInUser | grep UniqueID | awk '{print $2}'`

# If UniqueID is over 1000 then account will be a network account
if [[ $accountType -gt 1000 ]];
then
        
	# Get logged in users realname
	userRealName=`dscl "/Active Directory/DOMAIN/domain.local" -read /Users/$loggedInUser | awk 'f{print;f=0} /RealName:/{f=1}'`
			
	# Get logged in users email address
	userEMail=`dscl "/Active Directory/DOMAIN/domain.local" -read /Users/$loggedInUser | grep EMailAddress: | cut -c14-`
	
	# Get logged in users position
	userPosition=`dscl "/Active Directory/DOMAIN/domain.local" -read /Users/$loggedInUser | awk 'f{print;f=0} /JobTitle:/{f=1}'`
	
	# Get logged in users Phone Number
	userPhoneNumber=`dscl "/Active Directory/DOMAIN/domain.local" -read /Users/$loggedInUser | awk 'f{print;f=0} /PhoneNumber:/{f=1}'`

# Now program it into this computer's JSS record
sudo jamf recon -endUsername "$loggedInUser" -realname "$userRealName" -email "$userEMail" -position "$userPosition" -phone "$userPhoneNumber"

fi