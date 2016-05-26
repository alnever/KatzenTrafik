
library(shiny)

library(httr)
library(jsonlite)

consumerKey    <<- "98MiQg0cF48napb4dVqY44AOe"
consumerSecret <<- "FcgWqaEfrKxE2J4l9DdtRwOLcDbKkUy21zsg35qcjvxiocPN71"
tokenKey       <<- "2328474228-AnefTnuZdXJNf6Ocb61ImGoGuogSEN6zf6yM6qD"
tokenSecret    <<- "azE9pv7rDLTYJ37990D1lbem28eIUgqQ9ZKbehnwri9zj"

options(httr_oauth_cache=T)
myapp <<- oauth_app("twitter", key=consumerKey, secret=consumerSecret)
sig   <<- sign_oauth1.0(myapp, token = tokenKey, token_secret = tokenSecret)

getTweets <- function(numTweets, hashTag) {
      
      needTweets <- 0
      restTweets <- 0
      
      if (numTweets < 100) {
            needTweets <- numTweets      
      } else {
            needTweets <- 100
            restTweets <- numTweets - 100
      }
            
      someTweets <- GET(paste("https://api.twitter.com/1.1/search/tweets.json?q=%23cat&count=",needTweets, sep = ""), sig)
      json1 <- content(someTweets)
      json2 <- fromJSON(toJSON(json1))
      tweets <- json2$statuses
      
      while (restTweets > 0) {
            needTweets <- ifelse(restTweets < 100, restTweets, 100)
            new_url <- paste("https://api.twitter.com/1.1/search/tweets.json",
                                 json2$search_metadata$next_results,
                                 '&count=',
                                 needTweets,                                   
                                 sep = "")
            someTweets <- GET(new_url, sig)
            json1 <- content(someTweets)
            json2 <- fromJSON(toJSON(json1))
            tweets2 <- json2$statuses
            
            if (names(tweets2) != names(tweets))
            {
                  tweets <- tweets[,names(tweets2)]
                  row.names(tweets) <- paste('1',row.names(tweets),sep="")
                  row.names(tweets2) <- paste('2',row.names(tweets2),sep="")
                  tweets <- rbind(tweets, tweets2)                  
            }
            
            restTweets <- restTweets - needTweets
      }
      return(tweets)
}

shinyServer(
      function(input, output) {
            
            appFunc <- reactive({
                  switch(input$appFunc,
                         'Popularity' = 1,
                         'Prediction' = 2,
                         'Comparison' = 3)
            })
            
            
            if (x == 1) {
                  output$outText <- renderText('Popularity of the #cat')
            } else if (x == 2) {
                  output$outText <- renderText('Prediction of the further #cat-tweets')
            } else  if (x == 3) {
                  output$outText <- renderText({paste('Comparision of the #cat-tweets popularity with ',input$altHashtag)})
            }
      }
)