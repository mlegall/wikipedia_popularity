#1 - Packages ------------------------------------
install.packages('pageviews')
require(pageviews)

install.packages('readr')

require(readr)
#2 - Input------------------------------------
data <- read_csv("https://raw.githubusercontent.com/mlegall/wikipedia_popularity/master/data.csv",
                 
                 col_names = TRUE,
                 cols(
                   Nom. = col_character(),
                   CodeInsee. = col_character(),
                   Code.postal. = col_character(),
                   Arrondissement. = col_character(),
                   Canton. = col_character(),
                   Intercommunalit??.. = col_character(),
                   Superficie.km2.. = col_character(),
                   Population.derni??.re.pop..l??.gale.. = col_character(),
                   Densit??..hab..km2.. = col_character(),
                   Modifier. = col_logical(),
                   url = col_character(),
                   page_name = col_character()
                   ),
                 
                 locale = locale(date_names = "fr",encoding = "ISO-8859-1"))

#3 - Fonction de r??cup??ration ------------------------------------
total_vues=function(page_name,  min_date , max_date, langue){

  temp=tryCatch({
    
    a=article_pageviews(
      project = paste0(langue,'.wikipedia'),
      article = page_name,
      platform = "all",
      user_type = "all",
      start = min_date,
      end = max_date,
      reformat = TRUE,
      granularity = "daily")
    
    tot=sum(a$views)
    
  }
  , error=function(e) e)
  
  if(inherits(temp, "error")){tot=0}
  return(tot=tot)
  
}

total_vues


#4 - R??cup??ration ------------------------------------
#temp

#min_date = "2020010100"
#max_date = "2020010100"

#Ete 2020
##Francais
#ete_fr=as.character(lapply(data$page_name[1200], function(x) total_vues(page_name=x, min_date="2020070100",max_date="2020082000", langue='fr')))
##Anglais
#ete_en=as.character(lapply(data$page_name, function(x) total_vues(page_name=x, min_date="2020070100",max_date="2020083100", langue='en')))

#Ann??e 2019
##Francais
#a19_fr=as.character(lapply(data$page_name, function(x) total_vues(page_name=x, min_date="2019010100",max_date="2020010100", langue='fr')))
#length(a19_fr)      
##Anglais
#a19_en=as.character(lapply(data$page_name, function(x) total_vues(page_name=x, min_date="2019010100",max_date="2020010100",


## 4.1 Vues ann??es 2019 --------------------------
a19_fr=as.numeric()

for(i in 1:36){

  Sys.sleep(1)
  
  min =  i*1000 - 999
  max =  i*1000
  
  if(max> 35000){max=nrow(data)}
  
  cat(i,' : ', Sys.time(), '\n', min, ':', max, '\n')
  a19_fr[min:max]=as.numeric(lapply(data$page_name[min:max], function(x) total_vues(page_name=x, min_date="2019010100",max_date="2020010100", langue='fr')))

}

data$a19_fr = a19_fr
write.csv(data, "data2.csv")



## 4.2 Vues ??t?? 2020  --------------------------
ete20_fr=as.numeric()

for(i in 1:36){

  Sys.sleep(1)

  min =  i*1000 - 999
  max =  i*1000
  
  if(max> 35000){max=nrow(data)}

  cat(i,' : ', Sys.time(), '\n', min, ':', max, '\n')
  ete20_fr[min:max]=as.numeric(lapply(data$page_name[min:max], function(x) total_vues(page_name=x, min_date="2020060100",max_date="2020082300", langue='fr')))
  
}

data$ete20_fr = ete20_fr



#5 -  Export --------------------------
write.csv(data, "data_v2.csv")
