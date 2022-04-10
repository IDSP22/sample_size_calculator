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
                          h3("Introduction"),
                          br(),
                          h5("Hypothesis testing allows us to compare statistics between groups of data and determine if there is a significant difference or not. 
                              A crucial step in the process of hypothesis testing is sample size calculation. The size of the sample on which the test is conducted affects the power and significance level of the results. 
                            "), 
                          br(), 
                          h5("Let's say we want to conduct a hypothesis test to see if ...  
                              We know that the current ... rate is .. This is the Baseline Probability. Let's say we only care about a difference in .. of ..% or more. This is the Relative Minimum Detetctable Effect Size. This value 
                              is decided based on context such that any smaller effect is considered negligible. Let's assume we also want a confidence level of 95% and a power of 80% on this test since this is conventional. 
                              Now we need to know how many participants to include in this study so that we achieve the desired power and detect a significant difference. 
                              This is where a tool to calculate minimum required sample size comes in handy. "),
                          br(),
                          h5("Use the next tab to try out these calculations yourself! First, think of a hypothesis test you'd like to conduct. Then, specify a baseline probability and minimum detectable effect size. 
                              Use the sliders to set the desired power and confidence level of your test and calculate the estimated sample size."), 
                          br(), 
                          h5("Sometimes, the estimated sample size is too large or not feasible due to resource constraints. In such situations, it is good to know how you can change the required sample size by altering other parameters. 
                              For example, maybe you can increase the minimum detectable effect to be able to work with smaller sample? Or maybe you wouldn't mind reducing the power of the test slightly?
                              You can use the plots generated to understand the relationship between sample size and other parameters, and make such decisions. ")
                        )),
                     tabPanel(title='Calculate Sample Size',
                              sidebarLayout(
                                  sidebarPanel(
                                    numericInput(inputId = "baseline", 
                                                 label = "Baseline Probability", 
                                                 value = 10, min = 0, max = 100),
                                      br(),
                                      numericInput(inputId = "effectsize", 
                                                   label = "Minimum Detectable Effect (Relative)", 
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
