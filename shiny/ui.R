library(shiny)

shinyUI(
      pageWithSidebar(
            headerPanel("Katzen Trafik"),
            sidebarPanel(
                  selectInput('appFunc','Function:',c('Popularity','Prediction','Comparison'), selected = "Popularity"),
                  conditionalPanel(
                        condition = "input.appFunc == 'Popularity'",
                        sliderInput("numTweets","Number of tweets",
                                    min = 15, max = 1000, value = 100
                                    ),
                        radioButtons('Feature','Features:',c('Tweet language','Location'),selected = 'Tweet language')
                  ),
                  conditionalPanel(
                        condition = "input.appFunc == 'Prediction'", 
                        dateInput('preDate','Date to Predict')
                  ),
                  conditionalPanel(
                        condition = "input.appFunc == 'Comparison'",
                        textInput('altHashtag','Alternative Hashtag', width = '100%')
                  ),
                  actionButton('actBtn',"Show results")
                  
            ),
            mainPanel(
                  h3(textOutput('outText')),
                  textOutput('appFuncNum')
            )
      )
)