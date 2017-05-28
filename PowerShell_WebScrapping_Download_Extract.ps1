 ### Focus       		: This file is for downloading zip files from a website 
 ### 		       	  	  And unziping them to destination and deleting the zip files. (Web_Scrapping)
 ### CreatedOn   		: 29-05-2017 
 ### Author      		: Ravindranadh 
 ### Location    		: GreatLakes Institute of Managment, Chennai
 ### ProjectName 		:
 ### Latest Revision 	: V 0.1
 
 
 
 ### ===========================================Auto Download==============================================================
 
 
 ## Contants & Variable declearation
 $DataCounter = 730                                           ## IN days.
 $URL="https://www.nseindia.com/content/historical/EQUITIES/" ## defining statuc part of the URL to hit
 $FileEndPart = "bhav.csv.zip"
 $DestFolder = "G:\BHAV\ZipDownloads\cm"
 $DownloadedFilesCounter = 0
 $MissedDaysCount =0
 ## For, to loop from today to $dataCounter days back 
 
 for($i=1;$i -le $DataCounter;$i++){
	try{
		$Year=(get-date).AddDays(-$i).ToString("yyyy")    ## defining year,day, MONTH in capital format for dynamic component in the URL File name part
		$Day=(get-date).AddDays(-$i).ToString("dd")		  
		$Month =(get-date).AddDays(-$i).ToString("MMM").ToUpper()

		$source=$URL+$Year+"/"+$MONTH+"/"+"cm"+$Day+$MONTH+$Year+$FileEndPart    ## Complete URL 
		$destination = $DestFolder+$Day+$MONTH+$Year+$FileEndPart                 ## Destination Location
		
		Invoke-WebRequest $source -OutFile $destination                          ## Invoking page request which inturn auto downloads defined ziip to destination.
		
		$DownloadedFilesCounter++
		#write-Host "$Day-$MONTH-$Year's file has downloaded sucessfully :) "
	}
	catch{
		#write-Host "$Day-$MONTH-$Year's file is not found :( "
		$MissedDaysCount++
	}

 }
 
 Write-Host "$DownloadedFilesCounter number of files has been successfully downloaded :)"
 Write-Host "$MissedDaysCount number of NO file days out of $DataCounter number of days."
 

 ### ==================================================Unzipping the files========================================================

 
 $SourceLocation = "G:\BHAV\"                       ### Compressed and unzipped file path locations
 $DestinationLocation = "G:\BHAV\UnZipped\" 
 $UnZippedCount = 0

 $list = Get-childitem -recurse $SourceLocation -include *.zip  ### reading all the files exenstion with zip from source.
 $shell = new-object -com shell.application

 foreach($file in $list){										### looping all the zips read.
    $zip = $shell.NameSpace($file.FullName)
    foreach($item in $zip.items()){								### looping all the individual files in each zip file.
        try{
			$shell.Namespace($DestinationLocation).copyhere($item)
			$UnZippedCount++
		}
		catch{
			Write-Host "Unexpected issue -- kindly debug"
		}
    }
    Remove-Item $file      										### deletes the zipped file
 }
 
 Write-Host "$UnZippedCount number of files unzipped out of $DownloadedFilesCounter downloaded files (Y)"
  
 Start-Sleep 5                                           ## waits for 5 seconds.

