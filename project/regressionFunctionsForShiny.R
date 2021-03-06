library(plotly)

# This function takes in covariates and plots the p values for those given covariates and data
# @data CSV file that has been read in, can be "clean", or "illness" etc.
# @covariates vector of covariates in a string format eg c("supervisor", "leave") etc.
# @metric string that we want to measure eg "social_acceptance"
# Returns dataframe with the covariates and their respective p values
getPVals <- function(data, covariates, metric) {
  if(is.null(covariates)) { return(1) }
  
  if (is.null(data) || is.null(metric)) { return(1) }
  
  # Sanity check, make sure that we have at least one covariate
  if (length(covariates) < 1) { return(1) }
  
  if(metric == "") { return(1) }
  
  # Cool, lets slap on the first covariate.
  equation <- paste(metric, covariates[1], sep=" ~ ")

  # If we have more covariates, we want to paste them on with a "+" separator
  if (length(covariates) > 1) {
    for(covariate in covariates[2:length(covariates)]) {
      equation <- paste(equation, covariate, sep=" + ")
    }
  }
  # Finally, we create a model, and return the dataframe of the p values and covariates.
  model <- glm(as.formula(equation), family=binomial(link='logit'), data=data, maxit=100)
  pValVector <- as.vector((coef(summary(model))[,4]))
  
  # print(coef(summary(model))[,4]) # Debug print for checking
  return(data.frame(covariates = covariates, pVals = pValVector[2:length(pValVector)]))
}


# This function takes in a dataframe of covariates and their p values
# @pValDF that is the dataframe
# Returns histogram plotly graph 
createHistogram <- function(pValDF) {
  # Actually create the plot
  p <- plot_ly(data=pValDF,
               x = ~covariates,
               y = ~pVals, 
               type='bar')%>%
    layout(title = "p Values for covariates",
           xaxis = list(title = 'Co Variate',
                        zeroline = TRUE),
           yaxis = list(title = "P Value"))
  return(p)
}

# don't delete this till we ship

# setwd("/Users/calvinkorver/Documents/code/info370/info370-finalproject/project")
# data <- read.csv("./data/raw_data.csv", stringsAsFactors = FALSE)
# covariates <- c('test')
# metric <- NULL
# getPVals(data, covariates, metric)

