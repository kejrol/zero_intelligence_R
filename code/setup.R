
rm(list = ls())
# .rs.restartR()
options(strinsAsFactors = F)

source("code/functions.R")
library(reshape2)
library(data.table)
library(RNetLogo)
library(ggplot2)
library(rmarkdown)
library(gridExtra)

ilePowtorzen <- 5 # ile powtorzen dla tych samych parametrow, w miejscach, w ktorych brana jest mediana realizacji
zakresHeatmap <- c(35, 155) # wartosci pomiedzy ktorymi jest wykonywana symulacja do heatmapy

path <- "/home/kejrol/netlogo/app"
modelPath <- "models/Downloaded/ZITrading/ZITrading.nlogo"

oldPath <- getwd()
# .rs.restartR()
NLStart(nl.path = path, gui = F) # uwaga, ta funkcja zmiennia katalog roboczy
getwd()
NLLoadModel(model.path = modelPath)
setwd(oldPath)
# dane do wykresu przykladowego, 
parametrize()
df <- runSimulationConstReport()

df <- melt(df, id.vars = "ticks", measure.vars = c("efficiency", "transactionPrice"),
           factorsAsStrings = F)

# wykres liniowy efektywnosci
parametrize()
ogr <- runSimulationConstReport(report = c("ticks", "efficiency"))
ogr$racjonalnosc <- "agenci o ograniczonej\nracjonalności"
parametrize(constrained = F)
bOgr <- runSimulationConstReport(report = c("ticks", "efficiency"))
bOgr$racjonalnosc <- "agenci nieracjonalni"

ogry <- rbind(ogr, bOgr); rm(ogr, bOgr)

# heatmapa pierwsza
przejscie <- data.frame()
for (i in seq(zakresHeatmap[1], zakresHeatmap[2], by = 10))
{
  # i <- 1
  for (j in seq(zakresHeatmap[1], zakresHeatmap[2], by = 10))
  {
    parametrize(nBuyers = i, nSellers = j)
    przejscie <- rbind(przejscie,
                       data.frame(nOfBuyers = i,
                                  nOfSellers = j,
                                  efficiency = runSimulation(report = "efficiency")))
    print(paste(i, j))
  }
}

# heatmapa druga
przejscie2 <- data.table()
for (i in seq(przejscie[which.min(przejscie$efficiency),]$nOfBuyers - 5,
              przejscie[which.min(przejscie$efficiency),]$nOfBuyers + 5,
              by = 1))
{
  # i <- 1
  for (j in seq(przejscie[which.min(przejscie$efficiency),]$nOfSellers - 5,
                przejscie[which.min(przejscie$efficiency),]$nOfSellers + 5,
                by = 1))
  {
    parametrize(nBuyers = i, nSellers = j)
    for (a in 1:ilePowtorzen)
    przejscie2 <- rbind(przejscie2,
                       data.table(nOfBuyers = i,
                                  nOfSellers = j,
                                  efficiency = runSimulation(report = "efficiency")))
    print(paste(i, j))
  }
}
przejscie2agg <- przejscie2[,
                            .(efficiency = median(efficiency.efficiency)),
                            by = .(nOfBuyers, nOfSellers)]

# efektywnosc a liczba uczestnikow
lUczestnikow <- data.table()
for (i in seq(8, 180, by = 4))
{
  parametrize(nBuyers = i / 2,
              nSellers = i / 2)
  for (a in 1:ilePowtorzen)
  {
    lUczestnikow <- rbind(lUczestnikow,
                          data.table(liczbaUczestnikow = i,
                                     runSimulation(report = "efficiency")))
  }
  print(Sys.time())
  print(i)
}
lUczestnikowAgg <- lUczestnikow[,
                                .(efficiency = median(efficiency)),
                                by = .(liczbaUczestnikow)]

save.image("2.RData")
min(lUczestnikowAgg$efficiency)
which.min(lUczestnikowAgg$efficiency)


# dokladniej
doklUcz <- c()
parametrize(nBuyers = lUczestnikowAgg[which.min(lUczestnikowAgg$efficiency)]$liczbaUczestnikow / 2,
            nSellers = lUczestnikowAgg[which.min(lUczestnikowAgg$efficiency)]$liczbaUczestnikow / 2)
for (a in 1:ilePowtorzen * 4)
{
  doklUcz <- append(doklUcz,
                    runSimulation(report = "efficiency"))
  print(a)
}
dokladn <- data.table(dummy = lUczestnikowAgg[which.min(lUczestnikowAgg$efficiency)]$liczbaUczestnikow, efficiency = as.numeric(doklUcz))

ggplot(dokladn, aes(x = dummy, y = efficiency)) +
  geom_boxplot() + geom_point(size = 4, shape = 4) + theme_bw() +
  ggtitle(paste0("Rozklad realizacji zmiennej dla ",
                 lUczestnikowAgg[which.min(lUczestnikowAgg$efficiency)]$liczbaUczestnikow,
                 " uczestników rynku")) +
  scale_x_continuous(name = "", breaks = c())

czyPrzypadek <- ifelse(min(lUczestnikowAgg$efficiency) < quantile(dokladn$efficiency, .25),
                       yes = "Jak widać, niski wynik był ekstremalną, mało prawdopodobną realizacją zmiennej losowej.",
                       no = "Jak widać, niski wynik nie był jedynie ekstremalną realizacją zmiennej losowej. Można podejrzewać, że  w wyniku interakcji nieoptymalnej liczby agentów dochodzi tutaj do obniżenia efektywności zastosowanego mechanizmu rynkowego.")
czyPrzypadek <- unname(czyPrzypadek)

setwd(path)
NLQuit()
setwd(oldPath)

render(input = "KCiulkin.Rmd")



