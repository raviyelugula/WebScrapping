# Read Me ####
# This script is to download all the SAS DB files from NHTSA 
# - https://www.nhtsa.gov/node/97996/179871
# NHTSA - National Highway Traffic Safety Administration maintains 
# all the details about 4 wheeler automobile crashes...

# Package Installations ####
# xml2 and rvest are required to extract the html info from urls
install.packages("xml2") 
install.packages("rvest") 
# stringr is needed to match the hyperlink format to understand if it is 
# donwload file link or subfolder
install.packages("stringr")


# Loading libraries ####
require(xml2)
require(rvest)
require(stringr)
# Set this to a path where you want to have all your downloads 
setwd("C://Users//ravin//Documents//NHTSA//")
getwd()

# Function Definition ####
# Recursive function to search folder by folder and download .sas7bdat files
search_download_recursive <- function(link, name){
  # Here we will read the page and extract all the hyperlinks.
  # create a DB with Hyperlinks and their icon names.
  urlData = read_html(as.character(link))
  homeHyperLinks = data.frame(links=html_attr(html_nodes(urlData, "a"), "href"))
  homeHyperLinks$name = str_match(html_nodes(urlData, "a"), ">\\s*(.*?)\\s*<")[,2]
  
  # As the webpage contains multiple links (navigation, contact, etc..)
  # Here we will only serach for the subfolder links. 
  # Luckly all subfolders are having similar prefix part,
  # Creating a DB for hyperlinks and names of only the subfolders.
  sfindex = which(nchar(str_match(homeHyperLinks$links, 
                                "https://www.nhtsa.gov/node/97996\\s*(.*?)")[,1])>1)
  subfolders = homeHyperLinks[sfindex,]
  
  # Loop to deepdive into each of the subfolder and call the same function 
  # RECURSIVE !!!!!
  for(i in c(1:dim(subfolders)[1])){
    # Need to do a small check if the link is 'NA' to handle exceptions
    ifelse(is.na(subfolders$link[i]),
           print('subfolder na'),
           search_download_recursive(subfolders$links[i],paste(sep = "_", name,subfolders$name[i])))
  }
  
  # If there are any download files in the folder, we need to see if they 
  # have sas7bdat format. If yes, create a dataframe of all downloadable sas7bdat links and names
  dindex = which(nchar(str_match(homeHyperLinks$name, "s*(.*?)\\s*sas7bdat")[,1])>1)
  downloadlinks = homeHyperLinks[dindex,]
  
  # Loop to download each of the link we stored above
  for(i in c(1:dim(downloadlinks)[1])){
    # As the file names are same in most of the folder, to avoid overwritting and
    # also understand its path we are keep tracking the root folder to all the subfolders
    # names by appending them and storing in dest variable.
    dest = paste(sep = "_", name,downloadlinks$name[i])
    ifelse(is.na(downloadlinks$name[i]),
           print("EOD of folder"),
           download.file(as.character(downloadlinks$links[i]), destfile = dest,
                  method = "libcurl"))
    
  }
  # To end the recursive function.
  return(0)
}

# For this script this is the root folder I am strating with you can change it 
# based on your requirements.
url = "https://www.nhtsa.gov/node/97996/179871"
# Reading the html and storing the hyperlinks and names in dataframe
urlData = read_html(url)
homeHyperLinks = data.frame(links=html_attr(html_nodes(urlData, "a"), "href"))
homeHyperLinks$name = str_match(html_nodes(urlData, "a"), ">\\s*(.*?)\\s*<")[,2]

# My requirement is only to download data for years 2000-2015, you can change this part too
latest = homeHyperLinks[homeHyperLinks$name %in% c(2000:2015),]

# loop to call recursuive function on 2000 -2015 folders
for(i in c(dim(latest)[1]:1)){
  search_download_recursive(latest$links[i],latest$name[i])
}

