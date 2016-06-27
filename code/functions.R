# library(data.table)
library(reshape2)


# install packages if necessary and load all of them ----------------------

installAndLoadPackages <- function(packageList)
{
  for (i in packageList) {
    if (!(i %in% installed.packages()[,1])) { # check if package was installed
      print(paste0('Installing package ', i, '...'))
      install.packages(i)
    } else print(paste0('Package ', i, ' already installed.'))
  }
  lapply(packageList, require, character.only = TRUE)
}


# run the simulation ------------------------------------------------------

runSimulation <- function(conditions = "ticks < maxNumberOfTrades",
                          report = c("ticks", "efficiency",
                                     "transactionPrice", "actualSurplus"))
{
  NLDoCommand(1, "setup")
  NLDoCommandWhile(condition = conditions,
                   command = "go")
  
  temp <- data.frame(NLReport(reporter = report))
  colnames(temp) <- report
  
  return(temp)
}


# set the parameters of the simulation -----------------------------------

parametrizeAndRun <- function(constrained = T, nOfBuyers = 70, nOfSellers = 60,
                        maxBuyVal = 170, maxSellCost = 180,
                        conditions = "ticks < maxNumberOfTrades",
                        report = c("ticks", "efficiency",
                                   "transactionPrice", "actualSurplus"))
{
  if (constrained) {constr <- "true"} else {constr <- "false"}
  NLCommand(paste0("set constrained ", constr))
  
  count <- 0
  for (nBuyers in nOfBuyers)
  {
    # nBuyers <- 133
    NLCommand(paste0("set numberOfBuyers ", nBuyers))
    
    for (nSellers in nOfSellers)
    {
      # nSellers <- 143
      NLCommand(paste0("set numberOfSellers ", nSellers))
      
      for (maxBVal in maxBuyVal)
      {
        # maxBVal <- 101
        NLCommand(paste0("set maxBuyerValue ", maxBVal))
        
        for (maxSCost in maxSellCost)
        {
          # maxSCost <- 30
          NLCommand(paste0("set maxSellerCost ", maxSCost))
          nBuyersV <- c(nBuyersV, nBuyers)
          nSellersV <- c(nSellersV, nSellers)
          maxSCostV <- c(maxSCostV, maxSCost)
          maxBValV <- c(maxBValV, maxBVal)
          
          count <- count + 1
          print(paste("Iteracja:", count, "| Parametry:", nBuyers, nSellers, maxBVal, maxSCost))
          
          df <- rbind(df, runSimulation(conditions,
                                        report))
        }
      }
    }
  }
  return(df)
}
