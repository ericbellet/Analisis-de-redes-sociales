library('ProjectTemplate')
library('tm')
library(wordcloud)
library(ggplot2)
#Integrantes:
#Eric Bellet
#Hillary Cañas
#Jean García


#CAMBIAR DIRECCION
#setwd("C:/Users/Wilmer/")
setwd("C:/Users/EricBellet/Documents/Asignacion1/Asignacion1")

load.project()

#Data Import
#CAMBIAR DIRECCION
#load(file ="C:/Users/Wilmer//data/tw.Rdata")
load(file = "C:/Users/EricBellet/Desktop/Asignacion1/data/tw.Rdata" )

#Cargamos los tweets
tweets <- tw$text

#Debido a que el dataset tiene los signos de puntuacion en un formato distinto, hay que transformarlos para poder manejarlos.
tweets = iconv(tweets, to="ASCII//TRANSLIT")

#str(tweets) = 'data.frame':	6750 obs. of  17 variables



#Separamos por espacio.
tweets_text <- paste(tweets, collapse=" ")

#Ahora creamos un corpus.
#tweets_source <- VectorSource(tweets_text)
#corpus <- Corpus(tweets_source)
corpus <- Corpus(VectorSource(tweets_text), readerControl = list(language = "es"))
#-------------------------------------------
#Comenzamos con la limpieza de los textos.


#Elimina los signos de puntuacion.
corpus <- tm_map(corpus, removePunctuation)
#Elimina los espacios.
corpus <- tm_map(corpus, stripWhitespace)
#Convierte todo en minusculas.
corpus <- tm_map(corpus, content_transformer(tolower))


#Elimina palabras vacías (stopwords) en español
corpus <- tm_map(corpus, removeWords, stopwords("spanish"))
#Elimina los URL.
removeURL <- function(x) gsub("http[^[:space:]]*", "", x)
corpus <- tm_map(corpus, content_transformer(removeURL))
removeURL <- function(x) gsub("https[^[:space:]]*", "", x)
corpus <- tm_map(corpus, content_transformer(removeURL))




#Hay muchos tweets que tienen htt..., lo cual no significa nada y no aporta nada para nuestro analisis.
corpus <- tm_map(corpus, content_transformer(removeWords), c("htt...","ht...", "htt. ","ht.","6d","rt","retweet","q","d","i"))

#Segun estas funciones hacen lo mismo, lematizan. Pero lo hacen mal, leyendo blogs dicen que no hay nada que en R que lematice bien.
#corpus <- tm_map(corpus, stemDocument)
#corpus <- wordStem(corpus, "spanish")


#-------------------------------------------
#Creamos el document-term matrix.
dtm <- DocumentTermMatrix(corpus, control = list(wordLengths = c(1, Inf)))

#Lo convertimos en una matriz
dtm2 <- as.matrix(dtm)
#Calculamos las mas frecuentes.
frequency <- colSums(dtm2)

#Ordenamos el vector por las palabras mas frecuentes.
frequency <- sort(frequency, decreasing=TRUE)
#head(frequency)
#-------------------------------------------


term.freq <- frequency
#Vamos a realizar el analisis con las palabras que esten repetidas mas de ...
term.freq <- subset(term.freq, term.freq >=1) #ESTO ES IMPORTANTE.
#Observar las palabras mas frecuentes (100 o mas)
#(frequency <- findFreqTerms(dtm, lowfreq=100))

df <- data.frame(term = names(term.freq), freq = term.freq)
data <- data.frame(df$term, df$freq)
colnames(data)[1] <- "palabra"
colnames(data)[2] <- "repetida"

#Mostramos un grafico de algunas de las palabras y cuantas veces estan repetidas.
term.freq2 <- subset(term.freq, term.freq >=150)
df2 <- data.frame(term = names(term.freq2), freq = term.freq2)

ggplot(df2, aes(x=term, y=freq)) + geom_bar(stat = "identity") + xlab("Terms") + ylab("Count") +coord_flip()


#-------------------------------------------
save (data,file="data/preprocess.RData")

