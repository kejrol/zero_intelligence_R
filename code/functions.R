

runSimulation <- function(conditions = "ticks < maxNumberOfTrades",
                          report = c("ticks", "efficiency",
                                     "transactionPrice", "actualSurplus"))
{
  NLCommand("setup")
  NLDoCommandWhile(condition = conditions,
                   command = "go")
  
  temp <- data.frame(NLReport(reporter = report))
  colnames(temp) <- report
  
  return(temp)
}

runSimulationConstReport <- function(conditions = "ticks < maxNumberOfTrades",
                                     report = c("ticks", "efficiency",
                                                "transactionPrice", "actualSurplus"))
{
  NLCommand("setup")
  temp <- NLDoReportWhile(condition = conditions,
                          command = "go",
                          reporter = report,
                          as.data.frame = T,
                          df.col.names = report,
                          max.minutes = 10,
                          nl.obj = NULL)
  return(temp)
}

parametrize <- function(constrained = T, nBuyers = 70, nSellers = 60,
                        maxBVal = 170, maxSCost = 180,
                        conditions = "ticks < maxNumberOfTrades",
                        report = c("ticks", "efficiency",
                                   "transactionPrice", "actualSurplus"),
                        constReport = F)
{
  if (constrained) {constr <- "true"} else {constr <- "false"}
  NLCommand(paste0("set constrained ", constr))
  
  NLCommand(paste0("set numberOfBuyers ", nBuyers))
  
  NLCommand(paste0("set numberOfSellers ", nSellers))
  
  NLCommand(paste0("set maxBuyerValue ", maxBVal))
  
  NLCommand(paste0("set maxSellerCost ", maxSCost))
}