
library(httr)
library(jsonlite)

consumerKey <- "98MiQg0cF48napb4dVqY44AOe"
consumerSecret <- "FcgWqaEfrKxE2J4l9DdtRwOLcDbKkUy21zsg35qcjvxiocPN71"
tokenKey <- "2328474228-AnefTnuZdXJNf6Ocb61ImGoGuogSEN6zf6yM6qD"
tokenSecret <- "azE9pv7rDLTYJ37990D1lbem28eIUgqQ9ZKbehnwri9zj"

options(httr_oauth_cache=T)
myapp = oauth_app("twitter", key=consumerKey, secret=consumerSecret)
sig = sign_oauth1.0(myapp, token = tokenKey, token_secret = tokenSecret)
# homeTL = GET("https://api.twitter.com/1.1/statuses/home_timeline.json?count=200", sig)
# homeTL = GET("https://api.twitter.com/1.1/statuses/user_timeline.json?count=200", sig)
homeTL = GET("https://api.twitter.com/1.1/search/tweets.json?q=%23cat", sig)

json1 = content(homeTL)
json2 = fromJSON(toJSON(json1))
tweets <- json2$statuses

new_url <- paste("https://api.twitter.com/1.1/search/tweets.json",json2$search_metadata$next_results, sep = "")
homeTL = GET(new_url, sig)
json1 = content(homeTL)
json3 = fromJSON(toJSON(json1))
tweets2 <- json3$statuses

tweets <- tweets[,names(tweets2)]
row.names(tweets) <- paste('1',row.names(tweets),sep="")
row.names(tweets2) <- paste('2',row.names(tweets2),sep="")
tweetsAll <- rbind(tweets, tweets2)




row.user.lang <- unlist(tweets$user.lang)
ulang <- reshape2::melt(table(user.lang))
G <- gvisGeoChart(ulang, locationvar = "user.lang", colorvar = "value", 
                  options = list(width = 600, 
                                 height = 400,
                                 colorAxis="{colors:['#91BFDB', '#FC8D59']}")
)
plot(G)

tweet.lang <- unlist(tweets$lang)
tlang <- reshape2::melt(table(tweet.lang))
Bar5 <- gvisBarChart(tlang, options=list(
      chartArea="{left:250,top:50,width:\"100%\",height:\"100%\"}",
      legend="bottom",
      title="Top Kantzen Trafik tweet's langusges"))
plot(Bar5)


user.location <- unlist(tweets$user.location)
reshape2::melt(table(user.location))->uloc
uloc <- uloc[uloc$user.location != "",]

G <- gvisGeoChart(uloc, locationvar = "user.location", colorvar = "value", 
                   options = list(width = 600, 
                                  height = 400,
                                  colorAxis="{colors:['#91BFDB', '#FC8D59']}")
                  )
plot(G)

# nrow(json2$statuses)
# nrow(json2)
# json2[1,1:4]
# json2$statuses[1,"user"]
# 
# 
# json_data <- sapply(json2, function(x) {
#       x[sapply(x, is.null)] <- NA
#       unlist(x)
# })
# 
# 
# unlistAll <- function(x) {
#       for(i in length(names(x))) {
#             print(names(x)[i])
#             x[sapply(x, is.null)] <- NA 
#             x[,i] <- unlist(x[,i])
#       }
#       x
# }
# 
# do.call("rbind", json_data)
# 
