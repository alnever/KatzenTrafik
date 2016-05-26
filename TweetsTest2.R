
library(twitteR)

consumerKey    <<- "98MiQg0cF48napb4dVqY44AOe"
consumerSecret <<- "FcgWqaEfrKxE2J4l9DdtRwOLcDbKkUy21zsg35qcjvxiocPN71"
tokenKey       <<- "2328474228-AnefTnuZdXJNf6Ocb61ImGoGuogSEN6zf6yM6qD"
tokenSecret    <<- "azE9pv7rDLTYJ37990D1lbem28eIUgqQ9ZKbehnwri9zj"


getTweets <- function(numTweets, hashTag) {
     
      setup_twitter_oauth(consumer_key = consumerKey, consumer_secret = consumerSecret, 
                          access_token = tokenKey, access_secret = tokenSecret)
      # token <- get("oauth_token", twitteR:::oauth_cache)
      # token$cache()
      
      tweets = ""
      tweets <- searchTwitter(hashTag, n = numTweets)
      
      d <- data.frame(t[[1]]$toDataFrame())
      for (i in 2:length(t)) {
            d <- rbind(d,t[[i]]$toDataFrame())
      }
      return(d)
}


tweets <- getTweets(200,"#cat")

R <- leaflet(tweets) %>% 
      # fitBounds(~min(longitude), ~min(latitude), ~max(longitude), ~max(latitude)) %>%
      clearShapes() %>%
      addCircles(radius = 10, weight = 1, color = "#777777",
                 fillColor = "#FFCCCC", fillOpacity = 0.7)

library(googleVis)

long <- tweets$longitude
lat  <- tweets$latitude

loc <- cbind(long, lat)
loc <- loc[!is.null(long)&!is.null(lat),]
loc <- loc[!is.na(long)&!is.na(lat),]

G <- gvisGeoMap(tweets, locationvar = paste(tweets$longitude,tweets$latitude,sep=":"))

