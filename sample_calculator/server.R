#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(sortable)
library(shinyWidgets)
library(GGally)


shinyServer(function(input, output, session) {
    
    #show alert if user inputs invalid effect size 
    observeEvent(input$calculate, {
        if(input$effectsize > 100 | input$effectsize <= 0){
            show_alert(title = 'Input Error', 
                       text = 'Please enter an effect size between 0 and 100 (inclusive).', 
                       type = 'error')
        }
    })
    
    alpha <- reactive({1-input$conflevel/100})
    power <- reactive({input$power/100})
    p1 <- reactive({input$baseline/100})
    effectsize <- reactive({input$effectsize/100})
    effect <- reactive(effectsize()*p1())
    p2 <- reactive({p1()-effect()})
    p <- reactive((p1()+k*p2())/(1+k))
    q <- reactive((1-p()))
    q1 <- reactive(1-p1())
    q2 <- reactive(1-p2())
    k <- 1
    
    
    ss <- eventReactive(input$calculate,{

        k <- 1 
        p <- (p1()+k*p2())/(1+k)
        q <- (1-p)
        q1 <- 1-p1()
        q2 <- 1-p2()
        print(power())
        print(qnorm(power()))
        n1 <- (sqrt(p*q*(1+1/k))*qnorm(1-alpha()/2) + sqrt(p1()*q1 + p2()*q2/k)*qnorm(power()))^2/effect()^2
        n2 <- k*n1
        #from towardsdatascience article 
        round(n1)
    }
    )
    
    output$samplesize <- renderText({
        req(input$effectsize < 100 & input$effectsize > 0)
        paste(ss())
    })
    
    #use uniform distribution to generate 10 data points from 0 -> 2 * sample size
    #calculate power, CI, etc for those 10 data points
    #plot on like of sample size vs. y axis
    #highlight data point associated with what original output of sample size was 
    #plot 
    output$plot <- renderPlot({
        req(input$plot_y)
        req(input$effectsize < 100 & input$effectsize > 0)
        sim_x <- runif(20, 0, 2*ss())
        x <- c(ss(), sim_x)
        dat <- data.frame(x)
        if(input$plot_y == 'power') {
            get_power <- function(sampsize) {
                power <- pnorm((sqrt(sampsize*effect()^2) - sqrt(p()*q()*(1+1/k))*qnorm(1-alpha()/2))/sqrt(p1()*q1() + p2()*q2()/k))
                return(power)
            }
            dat <- dat %>% mutate(y = get_power(x))
            print(dat)
            plot(x = dat$x, y = dat$y, col=ifelse(x==ss(), "red", "black"),
                 pch=ifelse(x==ss(), 19, 1), cex=ifelse(x==ss(), 2, 1))
        }
    })
    
})


