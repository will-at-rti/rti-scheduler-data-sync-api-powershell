##################
# Step 1) Navigate to rti-scheduler-config.ps1 and fill in the integration values 
#         for this school's Data API Sync
#################
$currentPath=(Split-Path ((Get-Variable MyInvocation -Scope 0).Value).MyCommand.Path)
if (!(Test-Path $currentPath\rti-scheduler-config.ps1)) {
    Write-Host "Error: rti-scheduler-config.ps1 file not found. You can find an example file at https://github.com/will-at-rti/rti-scheduler-data-sync-api-powershell"
    exit(1)
}
. $currentPath\rti-scheduler-config.ps1
Write-Host "RTI School ID: $($RtiSchoolIdentifier)"
Write-Host "Current Path: $($currentPath)"

#################
# Step 2) You will need to create separate CSVs containing Course, Teacher, Student, Schedule, 
#         and Performance data. The format for these CSVs can be found by navigating to 
#         rtischeduler.com and choosing "Data Sync API" on the left navigation menu.
#         You must place those CSV files in the same directory as this script with the following 
#         names for the script to work out of the box: 
#           1) courses.csv
#           2) instructors.csv
#           3) students.csv
#           4) schedule.csv
#           5) performance.csv
#
#        If you have a separate script that places those files in here prior to running this script,
#        you do not need to do anything with this portion of the script
#################
try {

    
} catch {
    Write-Error "Failed to assemble CSVs for RTI Scheduler Integration."
    exit 1
}



##############
# This portion of the script sends each of your CSVs to RTI Scheduler and prints out the response from
# the Data Sync API. You should not need to adjust this portion if your filenames adhere to the names
# from step #2
##############
@('courses','instructors','students','schedule','performance') | ForEach-Object {
	$filePath = "$($currentPath)\$PSItem.csv"
    $url = "https://www.rtischeduler.com/sync-api/$RtiSchoolIdentifier/$PSItem"
	if (Test-Path "$filePath") {
		Write-Output "Uploading $filePath to $url..."
		
		$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
		$headers.Add("rti-api-token", "$($RTIToken)")
		
		$fileBytes = [System.IO.File]::ReadAllBytes($filePath);
		$fileEnc = [System.Text.Encoding]::GetEncoding('UTF-8').GetString($fileBytes);
		$boundary = [System.Guid]::NewGuid().ToString();
		$LF = "`r`n";
		$bodyLines = (
			"--$boundary",
			"Content-Disposition: form-data; name=`"upload`"; filename=`"$($PSItem.ToLower()).csv`"",
			"Content-Type: application/octet-stream$LF",
			$fileEnc,
			"--$boundary--$LF"
		) -join $LF
		
		$response = Invoke-RestMethod -Uri $URL -Method Post -ContentType "multipart/form-data; boundary=`"$boundary`"" -Body $bodyLines -Headers $headers

		Write-Output $response.logs
		
	} else {
		Write-Output "$filePath does not exist. Skipping $PSItem sync."		
	}
    
	
}