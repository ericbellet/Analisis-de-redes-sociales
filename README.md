# [Analísis de Redes Sociales Grupo HEJ](https://github.com/ICDrepository/analisis-de-redes-sociales-grupo-hej)


## Tabla de contenido

* [Inicio rápido](#inicio-rápido)
* [Contenido](#contenido)
* [Referencias](#referencias)
* [Integrantes](#integrantes)


## Inicio rápido

* install.packages('ProjectTemplate')
* install.packages("plyr")
* install.packages("reshape")
* install.packages("ggplot2")
* install.packages("lubridate")
* install.packages("tm")
* install.packages('wordcloud')
* install.packages('FactoMineR')
* install.packages('rattle')
* install.packages('Rstem')
* install.packages("RGtk2", depen=T, type="source")
* install.packages('cluster',dependencies=TRUE)
* install.packages("SnowballC")
* install.packages("reshape2")
* install.packages("twitteR")
* Editar config/global.dcf -> load_libraries: TRUE
* Editar config/global.dcf -> munging: FALSE
* Modificar los setwd y load a las rutas correspondientes.

### Contenido

* preprocesamiento.r -> Script donde se preprocesan los tweets.
* reporte_preprocesamiento.Rm -> Reporte donde se explica el preprocesamiento con los tweets.
* analisis.r -> Script donde se realizan analisis de los tweets.
* reporte_analisis.Rmd -> Reporte donde se explica el analisis realizado con los tweets.
* En la carpeta src se encuentran los script.
* En la carpeta data se encuentran los .Rdata.
* En la carpeta doc se encuentran los reportes, en version .html y .rmd.


## Referencias

* http://stackoverflow.com/questions/26351747/r-transform-web-text-in-spanish-to-ascii
* https://rstudio-pubs-static.s3.amazonaws.com/66739_c4422a1761bd4ee0b0bb8821d7780e12.html
* http://www.rdatamining.com/docs/text-mining-with-r-of-twitter-data-analysis
* https://deltadna.com/blog/text-mining-in-r-for-term-frequency/
* http://www.webmining.cl/2012/03/text-mining-de-un-discurso-presidencial-usando-r/
* http://www.grserrano.net/wp/2011/02/analizando-tuits-en-r-parte-3/



## Integrantes

**Eric Bellet**


**Hillary Cañas**


**Jean García**
