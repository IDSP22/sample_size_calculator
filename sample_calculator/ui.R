#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)


# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    navbarPage(title='A/B Testing Toolkit',
                     theme = shinytheme("sandstone"),
                     tabPanel(title='Calculate Sample Size',
                              sidebarLayout(
                                  sidebarPanel(
                                      sliderInput(inputId = "baseline",
                                                  label = "Baseline Probability", 
                                                  value = 10,
                                                  min = 0, max = 100),
                                      br(),
                                      numericInput(inputId = "effectsize", 
                                                   label = "Minimum Detectable Effect Size", 
                                                   value = 10, min = 0, max = 100),
                                      
                                      
                                      br(), 
                                      sliderInput(inputId = "power",
                                                  label = "Power", 
                                                  value = 80,
                                                  min = 0, max = 100),
                                      br(),
                                      sliderInput(inputId = "conflevel", 
                                                  label = "Confidence Level",
                                                  value = 95,
                                                  min = 0, max = 100), 
                                      br(),
                                      actionButton(inputId = "calculate",
                                                   label = "Calculate", 
                                                   class="btn btn-primary", 
                                                   style="align:center; padding:5px 100px")
                                  ),
                                  mainPanel(
                                      fluidRow(
                                          sidebarPanel(width = 12,
                                                       h3("Sample Size:"),
                                                       h2(align ="center",style = "font-size: 400%; letter-spacing: 3px;", textOutput(outputId = "samplesize"))),
                                          #dropdown menu for variables
                                          selectInput(inputId = 'plot_y', 
                                                      label = 'Choose a variable to plot against sample size:',
                                                      choices = c( 'power', 'effect size')),
                                          plotOutput(outputId = 'plot')
                                          )
                                  )
                              )
                     )
    )
))
