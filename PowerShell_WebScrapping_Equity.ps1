 ### Focus       		: This file is for downloading csv files from web. (Web_Scrapping)
 ### CreatedOn   		: 07-06-2017 
 ### Author      		: Ravindranadh 
 ### Location    		: GreatLakes Institute of Managment, Chennai
 ### ProjectName 		:
 ### Latest Revision 	: V 0.1
 
 
 
 ### ============================INDEX Auto Download==============================================================
 
 
 ## Contants & Variable declearation
 $DataCounter = 700                                          ## IN days.
 $URL="https://www.nseindia.com/archives/equities/mkt/" ## defining static part of the URL to hit
 $FileEndPart = ".csv"
 $DestFolder = "G:\BHAV\Equity\"
 $DownloadedFilesCounter = 0
 $MissedDaysCount =0
 ## For, to loop from today to $dataCounter days back 
 
 for($i=0;$i -le $DataCounter;$i++){
    try{
        $Year=(get-date).AddDays(-$i).ToString("yy")    ## defining year,day, MONTH in capital format for dynamic component in the URL File name part
        $Day=(get-date).AddDays(-$i).ToString("dd")          
        $Month =(get-date).AddDays(-$i).ToString("MM")

        $source=$URL+"MA"+$Day+$MONTH+$Year+$FileEndPart    ## Complete URL 
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

