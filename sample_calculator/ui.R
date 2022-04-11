#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/

library(shiny)
library(shinythemes)


# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    navbarPage(title='Sample Size Calculator', id = "ss_app",
                     theme = bslib::bs_theme(bootswatch = "journal"),
               tabPanel(title="Introduction", value="tab1",
                        wellPanel(
                          HTML(paste0("<h3>Introduction</h3>", "Hypothesis testing allows us to compare statistics between groups of data and determine if there is a significant difference or not. 
                              A crucial step in the process of hypothesis testing is sample size calculation. The size of the sample on which the test is conducted affects the power and significance level of the results. 
                            ", "<br></br>", "Let's say we're evaluating the effectiveness of a new email marketing campaign for an e-commerce company. We want to conduct a hypothesis test to see if the click-through-rate (CTR) on a new version of an email advertisement is higher than the old version. 
                              We know that the CTR on the old version is 10%. This is called the",  "<b>", " Baseline Probability", "</b>", ". Let's say we only care about a relative difference of 10% or more in CTR, i.e. only an absolute change of 1 percentage point or higher is worth looking into. 
                              This is the ", "<b>", "Relative Minimum Detetctable Effect Size", "</b>", ". This value 
                              is decided based on business context such that any smaller effect is considered negligible. Let's assume we also want a ", "<b>confidence level</b> of 95% and <b>power</b> of 80% on this test since this is conventional. 
                              Now we need to know how many participants to include in this study so that we can achieve the desired power and detect a significant difference if there is one. ", 
                              "<br></br>", "You <em>could</em> try and calculate the required sample size using this formula..", "<br></br>", "<figure>", "<img src='ss_formula.png', height=400, width=600>",
                              "<figcaption><em>Source: <a href='https://towardsdatascience.com/required-sample-size-for-a-b-testing-6f6608dd330a', style='color:blue'>Towards Data Science</a></em></figcaption>", "</figure>",
                              "<b>OR</b> you could use our handy tool that does all the crazy math for you!", 
                              "<h4>Try it yourself..</h4>", "Use the next tab to calculate your sample size. <ul> <li> First, think of a hypothesis test you'd like to conduct. </li> 
                              <li>Then, specify a baseline probability and minimum detectable effect size. </li>
                              <li>Use the sliders to set the desired power and confidence level of your test. </li>  
                              <li>Finally, press calculate to find out your required sample size! </li> </ul>", "<h5>What are the plots for? </h5>",
                              "Sometimes, the estimated sample size may be too large or not feasible due to resource constraints. In such situations, it is good to know how you can change the required sample size by altering other parameters. 
                              For example, maybe you can increase the minimum detectable effect to be able to work with smaller sample? Or maybe you wouldn't mind reducing the power of the test slightly?
                              You can use the plots generated to understand the relationship between sample size and other parameters, and make such decisions. <br></br>")),
                          actionButton('ready', "I'm ready!", class="btn btn-primary", style="align:center; padding:5px 80px")
                        )),
                     tabPanel(title='Calculate Sample Size', value="tab2",
                              sidebarLayout(
                                  sidebarPanel(
                                    sliderInput(inputId = "baseline",
                                                label = "Baseline Probability", 
                                                value = 10,
                                                min = 0, max = 100),
                                      br(),
                                      sliderInput(inputId = "effectsize", 
                                                   label = "Minimum Detectable Effect (Relative)", 
                                                   value = 10, 
                                                   min = 0, max = 100),
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
                                                   style="align:center; padding:5px 80px")
                                  ),
                                  mainPanel(
                                      fluidRow(
                                          sidebarPanel(width = 12,
                                                       h4("Required Sample Size:"),
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
