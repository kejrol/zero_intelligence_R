
rm(list = ls())
# .rs.restartR()


source("code/functions.R")
installAndLoadPackages(c("data.table", "RNetLogo", "ggplot2"))
library(ggplot2)
# paths to NetLogo stuff --------------------------------------------------

path <- "/home/kejrol/netlogo/app"
modelPath <- "models/Downloaded/ZITrading/ZITrading.nlogo"


# starting the NetLogo session --------------------------------------------

getwd()
NLStart(nl.path = path) #, gui = F) # watch out, this changes the woking directory path
getwd()
# .rs.restartR()
NLLoadModel(model.path = modelPath)



# data generation ---------------------------------------------------------

df <- data.frame(NULL)
temp <- data.frame(NULL)
nBuyersV = c(); nSellersV = c(); maxBValV = c(); maxSCostV = c()


# NLDoCommand(1, "setup")
# NLDoWhile(condition = "(efficiency < 90) and (ticks < maxNumberOfTrades)",
#           command = "go")
df <- data.frame()
# parametrizeAndRun()
df <- rbind(df, parametrizeAndRun())
print(df)
df <- rbind(df, parametrizeAndRun())
print(df)
df <- rbind(df, parametrizeAndRun())
print(df)

temp <- data.frame(NLReport(reporter = c("ticks", "efficiency", "transactionPrice", "actualSurplus")))
colnames(df) <- c()



ggplot(df) +
  geom_line(aes(x = tick,
                 y = eff)) +
  coord_cartesian(ylim = c(0, 100)) +
  theme_bw()

NLQuit(all = T)


