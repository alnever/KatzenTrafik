
library(httr)
library(jsonlite)

consumerKey    <<- "98MiQg0cF48napb4dVqY44AOe"
consumerSecret <<- "FcgWqaEfrKxE2J4l9DdtRwOLcDbKkUy21zsg35qcjvxiocPN71"
tokenKey       <<- "2328474228-AnefTnuZdXJNf6Ocb61ImGoGuogSEN6zf6yM6qD"
tokenSecret    <<- "azE9pv7rDLTYJ37990D1lbem28eIUgqQ9ZKbehnwri9zj"


unlistAll <- function(x)
{
      for(i in ncol(x)) {
            x[x[,i] == 'NULL',i] <- NA
            x[,i] <- unlist(x[,i])
      }
      return(x)
}

getTweets <- function(numTweets, hashTag) {
      
      needTweets <- numTweets

      options(httr_oauth_cache=T)
      myapp <- oauth_app("twitter", key=consumerKey, secret=consumerSecret)
      sig   <- sign_oauth1.0(myapp, token = tokenKey, token_secret = tokenSecret)

      someTweets <- GET(paste("https://api.twitter.com/1.1/search/tweets.json?q=%23cat", sep = ""), sig)
      json1 <- content(someTweets)
      json2 <- fromJSON(toJSON(json1))
      tweets <- json2$statuses
      u1 <- unlist(tweets$lang)
      u2 <- unlist(tweets$user$lang)
      u3 <- unlist(tweets$user$location)
      tweets <- cbind(u1,u2,u3)

      needTweets <- needTweets - nrow(tweets)
      
      print(needTweets)
      
      while (needTweets > 0) {
            
            new_url <- paste("https://api.twitter.com/1.1/search/tweets.json",
                             json2$search_metadata$next_results,
                             sep = "")
            
            print(new_url)
            
            someTweets <- GET(new_url, sig)
            json1 <- content(someTweets)
            json2 <- fromJSON(toJSON(json1))
            tweets2 <- json2$statuses

            u1 <- unlist(tweets2$lang)
            u2 <- unlist(tweets2$user$lang)
            u3 <- unlist(tweets2$user$location)
            tweets2 <- cbind(u1,u2,u3)
            
            tweets <- rbind(tweets, tweets2)
            
            rows2 <- nrow(tweets2)
            rows2 <- ifelse(is.null(rows2), needTweets, rows2)
            needTweets <- needTweets - rows2
      }
      names(tweets) <- c("lang","ulang","ulocation")
      return(tweets)
}