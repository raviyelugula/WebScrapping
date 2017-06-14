### Web Scraping using rvest library
### text extracting from URL


#install.packages('rvest')
data = read.csv("C:/Users/ravin/Downloads/Framework.csv")
length(data$Title)
colnames(data)[1] = 'PubMedID'
names(data)

url_static = "https://www.ncbi.nlm.nih.gov/pubmed?term="
limit =tail(data$PubMedID,300)
Matrix_temp = matrix(ncol=5 ,nrow =length(limit) )

library(rvest)
i = 1

for (Titlename in limit ){
  
  url = paste(url_static,Titlename, sep = "") 
  webpage = read_html(url)
  
  PubMed_ID= Titlename
  
  Title = html_nodes(webpage,'h1')
  Title_text = html_text(Title)
  
  Abstract = html_nodes(webpage,'abstracttext')
  Abstract_text = html_text(Abstract)
  
  Authors = html_nodes(webpage,'.auths')
  Authors_text = html_text(Authors)
  
  
  DP = html_nodes(webpage,'.cit')
  DP_text = html_text(DP)
  index_dot = gregexpr('\\.',DP_text)
  start=index_dot[[1]][1]
  index_col = gregexpr(':',DP_text)
  a=index_col[[1]][1]
  index_Semicol = gregexpr('\\;',DP_text)
  b=index_Semicol[[1]][1]
  
  if(a!=-1 & b!=-1){ 
    end = min(a,b)
  } else{
    end = max(a,b)
  }
  Date_published=substr(DP_text,start+1,end-1)
  
  Matrix_temp[i,1]= PubMed_ID
  Matrix_temp[i,2]= Title_text[2]
  Matrix_temp[i,3]= Abstract_text[1]
  Matrix_temp[i,4]= Authors_text[1]
  Matrix_temp[i,5]= Date_published
  
  i= i+1
  
}
#rm(pubmed_dataframe)

pubmed_dataframe = as.data.frame(Matrix_temp)
names(pubmed_dataframe) = c('PubMed_ID',
                            'Title',
                            'Abstract',
                            'Authors',
                            'Date_published')

write.csv(pubmed_dataframe,'G:/pubmed_test.csv',row.names = F)

# 
# 
# url = 'https://www.ncbi.nlm.nih.gov/pubmed?term=28513296'
# webpage = read_html(url)
# Title = html_nodes(webpage,'h1')
# Title_text = html_text(Title)
# 
# Abstract = html_nodes(webpage,'abstracttext')
# Abstract_text = html_text(Abstract)
# 
# Authors = html_nodes(webpage,'.auths')
# Authors_text = html_text(Keywords)
# 
# DP = html_nodes(webpage,'.cit')
# DP_text = html_text(DP)
# index_dot = gregexpr('\\.',DP_text)
# start=index_dot[[1]][1]
# index_col = gregexpr(':',DP_text)
# a=index_col[[1]][1]
# index_Semicol = gregexpr('\\;',DP_text)
# b=index_Semicol[[1]][1]
# 
# if(a!=-1 & b!=-1){ 
#   end = min(a,b)
# } else{
#     end = max(a,b)
#   }
# Date_published=substr(DP_text,start+1,end-1)
# 
# library(stringr)
# temp=str_sub(str_extract(DP_text, "..*:|;"),1, -1)
# temp
# ?str_extract
# 
# 
# 
# Title_text
# 
# class(Title_text)
# test= c('a',Title_text[2])


