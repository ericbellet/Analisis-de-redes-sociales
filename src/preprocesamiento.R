library('ProjectTemplate')
library('tm')
library(wordcloud)
library(ggplot2)

#CAMBIAR DIRECCION
setwd("C:/Users/EricBellet/Documents/Asignacion1/Asignacion1")

load.project()

#Data Import
#load(file = "C:/Users/EricBellet/Desktop/Asignacion1/data/tw.Rdata" )
#Transformamos el .Rdata a .csv
write.csv(tw,file="data/twitters.csv")
#Leemos el .csv
tweets <- read.csv ("data/twitters.csv", stringsAsFactors=FALSE)

#str(tweets) = 'data.frame':	6750 obs. of  17 variables

#Separamos por espacio.
tweets_text <- paste(tweets$text, collapse=" ")

#Ahora creamos un corpus.
tweets_source <- VectorSource(tweets_text)
corpus <- Corpus(tweets_source)

#-------------------------------------------
#Comenzamos con la limpieza de los textos.

#Convierte todo en minusculas.
corpus <- tm_map(corpus, content_transformer(tolower))
#Elimina los signos de puntuacion.
corpus <- tm_map(corpus, removePunctuation)
#Elimina los espacios.
corpus <- tm_map(corpus, stripWhitespace)
#Elimina palabras vacías (stopwords) en español
corpus <- tm_map(corpus, removeWords, stopwords("spanish"))
#Elimina los URL.
removeURL <- function(x) gsub("http[^[:space:]]*", "", x)
corpus <- tm_map(corpus, content_transformer(removeURL))
removeURL <- function(x) gsub("https[^[:space:]]*", "", x)
corpus <- tm_map(corpus, content_transformer(removeURL))


#Hay muchos tweets que tienen htt..., lo cual no significa nada y no aporta nada para nuestro analisis.
corpus <- tm_map(corpus, removeWords, c("htt...", "htt. ","ht."))
#-------------------------------------------
#Creamos el document-term matrix.
dtm <- DocumentTermMatrix(corpus)

#Lo convertimos en una matriz
dtm2 <- as.matrix(dtm)
#Calculamos las mas frecuentes.
frequency <- colSums(dtm2)

#Ordenamos el vector por las palabras mas frecuentes.
frequency <- sort(frequency, decreasing=TRUE)
#head(frequency)
#frequency[1:100]

#Mostramos los 100 mas frecuentes.
words <- names(frequency)
wordcloud(words[1:100], frequency[1:100],colors=brewer.pal(8, "Dark2"))

#Puede ser de utilidad para lematizar
## carga mi archivo de palabras vacías personalizada y lo convierte a ASCII
## sw <- readLines("D:/stopwords.es.txt",encoding="UTF-8")
## sw = iconv(sw, to="ASCII//TRANSLIT")
