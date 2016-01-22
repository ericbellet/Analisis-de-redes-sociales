library(FactoMineR)
library(rattle)
library(cluster)
library(reshape2)
library(ggplot2)
#Integrantes:
#Eric Bellet
#Hillary Cañas
#Jean García

#CAMBIAR DIRECCION
#setwd("C:/Users/Wilmer/")
setwd("C:/Users/EricBellet/Documents/Asignacion1/Asignacion1/Data")

#load("C:/Users/Wilmer/data/preprocess.RData")
loadedObj <- load("C:/Users/EricBellet/Documents/Asignacion1/Asignacion1/data/preprocess.RData")
Datos=get(loadedObj)
head(Datos)

#Calculamos la cantidad de palabras para crear el hash table.
n<-length(Datos$palabra)

#Creamos un hash table, para tener todo el dataframe numerico y asi poder aplicar PCA.
#Es decir cada palabra representa un numero. Ej: 1->votar, 2->chiabe, etc.
IDpalabra = array(1:n)

#Creamos un nuevo dataframe con todos los valores numericos.
newDatos = data.frame(IDpalabra,Datos$repetida)
colnames(newDatos)[2] <- "repetida"

#Colocamos nombres a las filas
rownames(newDatos) <- Datos[,1]
#-----------------------------------------------PCA---------------------------------------------------
#Llamamos al metodo usando la funcion prcomp de stats
modelo = prcomp(newDatos)

#--------------------------------

#--------------------------------
biplot(modelo)

#Aplicamos PCA
#Evaluar el valor del ncp.

suppressMessages(library(FactoMineR))
modelo <- PCA(newDatos, scale.unit = TRUE, ncp = 5, graph = FALSE)

#AUTOVALORES.
modelo$eig

#OBSERVAMOS LOS COMPONENENTES
#modelo$ind$coord

#Graficamos el plano principal y el círculo de correlaciones por separado para las componentes principales 1 y 2
par(mfrow = c(1, 2)) # dividimos la pantalla para recibir dos gráficos.
plot(modelo, axes = c(1, 2), choix = "ind", col.ind = "red", new.plot = TRUE)
plot(modelo, axes = c(1, 2), choix = "var", col.var = "blue", new.plot = TRUE)


#Creo que estan bien representados.(Borrar comentario)
# Cálculo de representatividad con los componentes 1 y 2
cos2.ind <- (modelo$ind$cos2[, 1] + modelo$ind$cos2[, 2]) * 100
cos2.ind

# Gráfica los individuos que tengan cos2 >= 0.7 (70%)
par(mfrow = c(1, 1))
plot(modelo, axes = c(1, 2), choix = "ind", col.ind = "red", new.plot = TRUE, select = "cos2 0.7")

# Cálculo de representatividad con los componentes 1 y 2
cos2.var <- (modelo$var$cos2[, 1] + modelo$var$cos2[, 2]) * 100
cos2.var

#Se consideran mal representados los cos2 < 60%
cos2.var <- (modelo$var$cos2[, 1] + modelo$var$cos2[, 2]) * 100
cos2.var

# Grafica las variables que tengan cos2 >= 0.9 (90%)
plot(modelo, axes = c(1, 2), choix = "var", col.var = "blue", new.plot = TRUE, select = "cos2 0.9")

#-----------------------------------------------Clustering------------------------------
#Esto no creo que haga falta, pero se pueden observar cosas para analizar. (Borrar comentario)
#Clustering sobre las componentes Principales
#desplegar los cluster 
res.hcpc <- HCPC(modelo, nb.clust = -1, consol = TRUE, min = 3, max = 3, graph = FALSE)
res.hcpc

res.hcpc$data.clust

#Graficando los cluster con el árbol clasificador
plot(res.hcpc, axes=c(1,2), choice="tree", rect=TRUE,
     draw.tree=TRUE, ind.names=TRUE, t.level="all", title=NULL,
     new.plot=FALSE, max.plot=15, tree.barplot=TRUE,
     centers.plot=FALSE)

#Graficando los cluster con el árbol clasificador en 3D
plot(res.hcpc, axes=c(1,2), choice="3D.map", rect=TRUE,
     draw.tree=TRUE, ind.names=TRUE, t.level="all", title=NULL,
     new.plot=FALSE, max.plot=15, tree.barplot=TRUE,
     centers.plot=FALSE)


#------------------------------------Clasificación Jerárquica Ascendente------------------------
#Para poder hacer analisis utilizamos una muestra menor
CJA <- subset(newDatos, newDatos$repetida > 300)

#Haciendo el analisis con subconjuntos.
#CJA1 <- subset(newDatos, newDatos$repetida > 136 &  newDatos$repetida < 150 )
#CJA2 <- subset(newDatos, newDatos$repetida > 110 &  newDatos$repetida < 120 )
#CJA<- rbind(CJA, CJA1,CJA2)

#Usando la agregación del salto máximo
#modelo = hclust(dist(CJA), method = "complete")

#Usando la agregación por promedios
#modelo = hclust(dist(CJA), method = "average")

#Usando la agregación de Ward
#modelo = hclust(dist(CJA), method = "ward.D")

#Usando la agregación del salto mínimo
modelo = hclust(dist(CJA), method = "single")

#Resaltamos en rojo los grupos.
plot(modelo)
rect.hclust(modelo, k = 3, border = "red")

#Le asignamos un gripo a cada palabra.
Grupo <- cutree(modelo, k = 3)
NDatos <- cbind(CJA, Grupo)
NDatos

#Mostramos los centros de cada clasificacion, visualmente no son los centros.
centros <- centers.hclust(CJA, modelo, nclust = 3, use.median = FALSE)
centros

#Gráfica de los centro para el cluster 1
rownames(centros) <- c("Cluster 1", "Cluster 2", "Cluster 3")
barplot(centros[1, ], col = c(2, 3, 4, 5, 6, 7), las = 2)

#Gráfica de los centro para el cluster 2
barplot(centros[2, ], col = c(2, 3, 4, 5, 6, 7), las = 2)

#Gráfica de los centro para el cluster 3
barplot(centros[3, ], col = c(2, 3, 4, 5, 6, 7), las = 2)

#Gráfica de los centro para todos clusters
barplot(t(centros), beside = TRUE, col = c(2, 3, 4, 5, 6, 7))

#-------------------------------------k-medias-------------------------------------------
#En K-Medias podemos analizar todo el dataset, ya que se puede graficar la nube de puntos de tal forma que se puede analizar.
#Aplicamos Codo de Jambu para seleccionar el K
plot(newDatos, pch = 19)
InerciaIC = rep(0, 30)
for (k in 1:30) {
  grupos = kmeans(newDatos, k)
  InerciaIC[k] = grupos$tot.withinss
}
plot(InerciaIC, col = "blue", type = "b")

#Podemos observar que aparentemente hay 3 grupos utilizando todo el conjunto de las palabras.

grupos <- kmeans(newDatos,3, iter.max = 100)  ## El 2do parametro es el IMPORTANTE

grupos
grupos$cluster
grupos$centers
grupos$totss  # Inercia Total
grupos$withinss  # Inercia Intra-clases por grupo (una para cada grupo)
grupos$tot.withinss  # Inercia Intra-clases
grupos$betweenss  # inercia Inter-clases
# Verificación del Teorema de Fisher
grupos$totss == grupos$tot.withinss + grupos$betweenss
grupos$size  # Tamaño de las clases

#Podemos observar los centroides y los distintos grupos
plot(newDatos, pch = 19)
points(grupos$centers, pch = 19, col = "yellow", cex = 3)
points(newDatos, col = grupos$cluster + 1, pch = 19)

#Podemos observar la interpretacion de los cluster por la comparacion de sus centros.
rownames(grupos$centers) <- c("Cluster 1", "Cluster 2", "Cluster 3")
barplot(t(grupos$centers), beside = TRUE, col = heat.colors(5))

NDatos <- cbind(newDatos, Grupo = grupos$cluster)
head(NDatos)




