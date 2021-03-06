###############################################################################
# Using R to calculate combinations                                           #
#                                                                             #
# Given a bridge hand a=c(s,h,d,c) calculates probability no fit of fit+cards #
# i.e. partner holds b=c(s2,h2,d2,c2) and a[i]+b[i] < fit,                    #
# also that opponents have no fit of fit+ cards                               #
# fit should be >= max(hand[i]) and <= 13.                                    #
# helper function findshapes returns list of possible shapes opposite         #
# helper function handprob calculates probability of a given shape            #
# main function nofit sums all probabilities                                  #
###############################################################################
# for 2245, function finds 70 shapes where our side has no 9+ card fit        #
# for 2245, function finds 44 shapes where neither side has 9+ fit            # 
# probability(neither side has 9 card fit | 2245 shape held) = 0.48           #
###############################################################################
# 
#  Example Usage:
#> nofit(c(2,2,4,5),9)
#44 patterns found
#[1] 0.4828198
#> nofit(c(2,2,4,5),8)
#6 patterns found
#[1] 0.1021703
#> nofit(c(3,3,4,3),7)
#0 patterns found
#[1] 0

findshapes <- function(hand,fit){
  # creates a list of all patterns opposite hand that have fit < fit cards
  # also ensure that opponents have no fit of fit+ cards
  # max(hand[i]) <= fit <= 13
  cards <- 0:13
  # compute range of all four suits (assumes fit >= max(hand[i]))
  # this version: NEITHER SIDE TO HAVE FIT, as lower limit on cards
  # to calculate: JUST YOUR SIDE TO HAVE FIT, remove lower limit here
  # e.g. s <- subset(cards, cards < (fit- hand[1]))
  s <- subset(cards, cards>(13-fit-hand[1]) & cards < (fit- hand[1]))
  h <- subset(cards, cards>(13-fit-hand[2]) & cards < (fit- hand[2]))
  d <- subset(cards, cards>(13-fit-hand[3]) & cards < (fit- hand[3]))
  c <- subset(cards, cards>(13-fit-hand[4]) & cards < (fit- hand[4]))
  # all combinations, return only hands with 13 cards
  combs <- expand.grid(s,h,d,c)
  shapes <- combs[rowSums(combs)==13,]
  # return list with each element a possible pattern
  shapelist <- as.list(as.data.frame(t(shapes)))
  message( paste(length(shapelist),"patterns found"))
  return (shapelist)
}
handprob <- function(shape,hand){
  # probability of shape c(s,d,h,c) opposite, given you hold hand c(s,d,h,c) 
  specified <- choose(13-hand[1],shape[1])*choose(13-hand[2],shape[2])*
    choose(13-hand[3],shape[3])*choose(13-hand[4],shape[4])
  allpossible <- choose(39,13)
  return (specified/allpossible)
}
nofit <- function(hand,fit){
  # input hand as a vector c(spades,hearts,diamonds,clubs) e.g. c(4,3,3,3)
  # calls findshapes to exhaustively list all possible shapes
  # uses lapply and handprob to find probability for each shape
  # returns sum of probabilities
  shapelist <- findshapes(hand,fit)
  cumulativeprob <- sum(unlist(lapply(shapelist,handprob,hand=hand)))
  return (cumulativeprob)
}

