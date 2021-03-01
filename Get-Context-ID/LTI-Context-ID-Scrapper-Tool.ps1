# Script to locate the context ID of Canvas Courses and produce a file to import into Zoom LTI Pro
# Version 1.0
# Working as of 2/28/2021
# Created by Justin Carrell
# Error handling style provided by https://github.com/kajigga
# This is an unsupported, community-created project. Keep that in mind.
# Instructure won't be able to help you fix or debug this. 
# All software, code, and information contained herein is provided as-is with no warranty.

# Configuration Variables
$canvasURL = 'canvas.instructure.com' # Canvas Instance URL do not include https:// (Example: canvas.instructure.com)
$token = '' # An API token for a user with adequate permission to navigate to all courses
$inputFile = 'C:\canvas\zoom\courses.csv' # Full Path to file to process. The file should contain a header with 'canvas_course_id' and 'meeting_id'
$exportZoomFile = "C:\canvas\zoom\zoom.csv" # Location to Export the Data
$ltiID = '175' # LTI ID Number of Zoom. LAunch zoom from a course. ID will be in the URL.
$launch_type = 'course_navigation' # When doing a sessionless launch, we want it to act like a course navigation launch
$zoomExportHeader = "Meeting ID,Context ID,Domain,custom_canvas_course_id" # Header file of the Zoom file

#************ Do Not Edit Below This Line ************

#Check for file
if(!(Test-Path $inputFile)){
  Write-Host Input file does not exist!
  exit
}

#Check for Zoom export file. Remove if it already exists.
if((Test-Path $exportZoomFile)){
  Remove-Item $exportZoomFile
}

Add-Content $exportZoomFile -Value $zoomExportHeader

$headers = @{"Authorization"="Bearer "+$token}
$in_data = Import-CSV($inputFile);

forEach($item in $in_data){
  $course_id = $item.canvas_course_id
  $meeting_id = $item.meeting_id
  $url = 'https://'+$canvasURL+'/api/v1/courses/'+$course_id+'/external_tools/sessionless_launch?id='+$ltiID+'&launch_type='+$launch_type+''
    Write-Host Generating Session Launch URL for $course_id
  Try {
    $results = (Invoke-WebRequest -Headers $headers -Method GET -Uri $url)
    Try{
      $jresults = ($results.Content | ConvertFrom-Json)
      if($jresults.id){
        $HTML = Invoke-WebRequest $jresults.url
        $HTML -match '<input type="hidden" name="context_id" id="context_id" value=".*" />' |out-null
        $context_id = $Matches.Values -replace '.*value="' -replace '" />'
        Write-Host "   Context ID:" $context_id

              $file_contents = ''+$meeting_id+','+$context_id+',https://'+$canvasURL+','+$course_id+''
              Add-Content $exportZoomFile -Value $file_contents

        Write-Host "   Context ID Added to Excel File"
        Write-Host "   "
      }
    }Catch{
      Write-Host "   Unable to complete request. An error occured: " + $_.Exception
    }
  } Catch {
    $errorMsg = $_.Exception
    $terminate = $false
    if($errorMsg.Response.StatusCode -eq 'unauthorized'){
      $msg = "The provided token is not from a user with sufficient permission to complete the action."
      $terminate = $true
    }elseif($errorMsg.Response.StatusCode.Value__ -eq "400"){
      $msg = "Unable to start copy."
      $terminate = $false
    }else{
      $msg = "An error occured: " + $errorMsg
      $terminate = $true
    }
    Write-Host "   ERROR:" $msg
    if($terminate){ break }
  }
}
Write-Host "   "
Write-Host "Script Complete"
