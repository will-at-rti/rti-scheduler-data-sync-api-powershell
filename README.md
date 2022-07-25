# Example Powershell implementation of RTI Scheduler's Data Sync API

## Using this script
1) Download/Extract these files to a directory you'd like to run your script from.
1) Fill out your `rti-scheduler-config.ps1` with the values from your RTI Scheduler school's account
1) Export data from your SIS and create `courses.csv`, `instructors.csv`, `students.csv`, `schedule.csv`, and `performance.csv` in this same directory. You can create these CSVs through your own powershell script, or by adding to `rti-scheduler-integration.ps1` in the section labeled "Step 2"
1) Push the CSV data to RTI Scheduler by executing the script `.\rti-scheduler-integration.ps1`

## Recommendations
- You can schedule this script to run as often as you want, but you should run it at an off-peak time. We recommend some time between 8pm and 6am.

## rti-scheduler-config.ps1
This file contains the integration values needed for your script to communicate with RTI Scheduler.

Where these values come from:
   1) Login to rtischeduler.com
   2) Choose 'Data Sync API' from the left navigation menu
   3) Under Authentication, 'Generate New Token.' Paste your token into the RTI Token variable below
   4) Paste the correct school's "RTI School ID" from this same page into the RtiSchoolIdentifier variable below.
   
   *Note: Safeguard your Token like a password*
   
   
## rti-scheduler-integration.ps1
This file takes the values from your config file and pushes each CSV to RTI Scheduler
