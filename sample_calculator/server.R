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
library(ggplot2)


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
    
    get_ss <- function(power, alpha, relative_effect, baseline){
        effect <- relative_effect*baseline 
        new_prob <- baseline - effect 
        p <- (baseline+new_prob)/2
        q <- 1-p
        q1 <- 1-baseline
        q2 <- 1-new_prob 
        n <- (sqrt(p*q*2)*qnorm(1-alpha/2) + sqrt(baseline*q1 + new_prob*q2)*qnorm(power))^2/effect^2
        round(n)
    }
    
    ss <- reactive({
        get_ss(power(), alpha(), effectsize(), p1())
    })
    
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
        # sim_x <- runif(20, 0, 2*ss())
        sim_x <- seq(from=0, to=2*ss(), 20)
        x <- c(ss(), sim_x)
        dat <- data.frame(x)
        if(input$plot_y == 'power') {
            get_power <- function(sampsize) {
                power <- pnorm((sqrt(sampsize*effect()^2) - sqrt(p()*q()*(1+1/k))*qnorm(1-alpha()/2))/sqrt(p1()*q1() + p2()*q2()/k))
                return(power)
            }
            dat <- dat %>% mutate(y = get_power(x))
            # print(dat)
            # plot(x = dat$x, y = dat$y, col=ifelse(x==ss(), "red", "black"),
            #      pch=ifelse(x==ss(), 19, 1), cex=ifelse(x==ss(), 2, 1), ylab = 'power')
            ggplot(data=dat, aes(x=x, y=y)) +
                geom_line()+
                annotate("point", x = ss(), y = power(), colour = "red", size=3)+
                xlab("sample size")+ylab("power")
        }
        else if(input$plot_y == 'effect size'){
            get_effect <- function(sampsize) {
                effect_size <- sqrt((sqrt(p()*q()*(1+1/k))*qnorm(1-alpha()/2) + sqrt(p1()*q1() + p2()*q2()/k)*qnorm(power()))^2/sampsize)/p1()
            }
            dat <- dat %>% mutate(y = get_effect(x))
            # print(dat)
            # plot(x = dat$x, y = dat$y, col=ifelse(x==ss(), "red", "black"),
            #      pch=ifelse(x==ss(), 19, 1), cex=ifelse(x==ss(), 2, 1), ylab = 'effect size')
            ggplot(data=dat, aes(x=x, y=y)) +
                geom_line()+
                annotate("point", x = ss(), y = effectsize(), colour = "red", size=3)+
                xlab("sample size")+ylab("effect size")
        }
    })
    
})


#Things to do 

# - validate that baseline probability is not less than 0 or more than 100 
# - add explanation below power and effectsize plot 
# - clean up plot 
# - when user hits calculate - freeze x axis of all plots and any changes in inputs should only change plot interior 
# when user hits calculate - freeze MDE and Baseline - calculate sample size for all
# 


