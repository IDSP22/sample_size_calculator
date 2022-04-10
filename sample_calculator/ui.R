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
    
    navbarPage(title='Sample Size Calculator',
                     theme = shinytheme("sandstone"),
               tabPanel(title="Introduction", 
                        wellPanel(
                          h3("Some heading"),
                          h6("Hypothesis testing allows us to compare statistics between groups of data and determine if there is a significant difference or not. 
                             A properly designed hypothesis test has many components including the desired significance level, power, 
                             minimum detectable effect size and baseline probability. 
                             [Define these here]
                             Once we have decided on a hypothesis test and considered the above components, we can calculate the minimum sample 
                             size needed to achieve the desired power and significance level. Proper sample size calculation is therefore a critical step in the 
                             process of running a hypothesis test. 
                            "), 
                          br(), 
                          h6("Let us consider the example of a simple hypothesis test ....."),
                          br(),
                          h6("In this app, you can explore how the minimum sample size required changes with the other 4 components discussed above.")
                        )),
                     tabPanel(title='Calculate Sample Size',
                              sidebarLayout(
                                  sidebarPanel(
                                    numericInput(inputId = "baseline", 
                                                 label = "Baseline Probability", 
                                                 value = 10, min = 0, max = 100),
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
                                                       h4("Estimated Sample Size:"),
                                                       h4(align ="center",style = "font-size: 400%; letter-spacing: 3px;", textOutput(outputId = "samplesize")))),
                                      
                                      fluidRow(
                                          #dropdown menu for variables
                                        sidebarPanel(width = 12,
                                          selectInput(inputId = 'plot_y', 
                                                      label = 'Choose a variable to plot against sample size:',
                                                      choices = c( 'power', 'effect size')),
                                          plotOutput(outputId = 'plot')
                                          )
                                      )
                                  )
                              )
                     )
    )
))
