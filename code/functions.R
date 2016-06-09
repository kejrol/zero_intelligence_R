library(data.table)

decide <- function(nOfPlayers, sellTreshold = 1/3, buyTreshold = 2/3)
{ # Returns vector of random decisions. "" means no action, "b" = buy, "s" = sell
  # convention: [0, sellTreshold, buyTreshold, 1]
  # alternatively:
  # --------0-|-SSSSSSSSSSS-|-no_decision_land-|-BBBBBBBBB-|-1----->
  
  if (class(nOfPlayers) != "integer")
    stop("Class of nOfPlayers must be integer.")
  
  if (length(nOfPlayers) != 1)
    stop("Length of nOfPlayers should be equal 1")
  
  if (any(c(sellTreshold, buyTreshold) < 0 | any(c(sellTreshold, buyTreshold) > 1)))
     stop("Tresholds should be between 0 and 1")
  
  if (sellTreshold > buyTreshold)
    stop("sellTreshold should be smaller than buyTreshold")
  
  probs <- runif(nOfPlayers, 0, 1)
  
  return(ifelse(probs > buyTreshold, yes = "b",
                no = ifelse(probs < sellTreshold, yes = "s",
                            no = "")
                )
         )
}

buy <- function(rationality, decision, budget, lastSoldPrice)
{ # Returns a data.table with info about IDs of bots and buy prices (bids).
  # Examines wether decision would make a bot bancrupt.
  
  if (class(rationality) != boolean)
    stop("Don't understand the rationality vector.")
  
  if (class(decision) != boolean)
    stop("Don't understand the decision vector.")
  
  if (length(rationality) != length(decision))
    stop("Lengths of vectors aren't the same.")
  # which(c(T, F, T, F) == T
  ids <- which(decision == "b")
  temp <- data.table(id = ids,
                     rational = rationality[ids],
                     budget = budget[ids],
                     maxPrice = lastSoldPrice[ids],
                     random = runif(length(ids), min = 0, max = 1))
  
  temp[,bid := ifelse(rational,
                      random * maxPrice, # yes
                      random * budget)]
  
  return(temp[,.(id, price)])
}

sell <- function(rationality, decision, stack, lastBoughtPrice, maximum = 200)
{ # Returns a data.table with info about IDs of bots and their sell prices (asks).
  # Examines wether decision would make a bot bancrupt.
  
  if (class(rationality) != boolean)
    stop("Don't understand the rationality vector.")
  
  if (class(decision) != boolean)
    stop("Don't understand the decision vector.")
  
  if (length(rationality) != length(decision))
    stop("Lengths of vectors aren't the same.")

  
  # which(c(T, F, T, F) == T
  ids <- which(decision == "s")
  temp <- data.table(id = ids,
                     rational = rationality[ids],
                     stack = stack[ids],
                     minPrice = lastBoughtPrice[ids],
                     random = runif(length(ids), min = 0, max = maximum))
  
  temp[,ask := ifelse(rational,
                      minPrice + (random * (maximum - random)) / 200, # yes
                      random)] # no
  
  return(temp[,.(id, ask)])
}

clearMarket <- function()
{ # https://en.wikipedia.org/wiki/Double_auction#Natural_ordering
  if (!(class(prices) %in% c("integer", "numeric")))
    stop("Prices should be numbers, don't you think?")
  
  if (any(prices) < 0)
    stop("Some prices are negative. Nonsense!")
}

summarize <- function()
{
  
}

next_round <- function()
{
  
}

