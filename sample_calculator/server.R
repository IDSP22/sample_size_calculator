library(shiny)
library(tidyverse)
library(sortable)
library(shinyWidgets)
library(GGally)
library(ggplot2)


shinyServer(function(input, output, session) {
    
    #function to calculate sample size 
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

    
    observeEvent(input$calculate, {
        #ss <- reactive({
        #    get_ss(power(), alpha(), effectsize(), p1())
        #})
        power <- input$power/100
        alpha <- 1-input$conflevel/100
        p1 <- input$baseline/100
        effectsize <- input$effectsize/100
        effect <- effectsize*p1
        p2 <- p1-effect
        k <- 1
        p <- (p1+k*p2)/(1+k)
        q <- (1-p)
        q1 <- 1-p1
        q2 <- 1-p2
        
        ss <- get_ss(power, alpha, effectsize, p1)

        output$samplesize <- renderText({
            req(input$effectsize < 100 & input$effectsize > 0)
            paste(ss)
        })
        
        sim_x <- seq(from=0, to=2*ss, 20)
        x <- c(ss, sim_x)
        dat <- data.frame(x)
        
        
        output$plot <- renderPlot({
            req(input$plot_y)
            req(input$effectsize < 100 & input$effectsize > 0)

            if(input$plot_y == 'power') {
                get_power <- function(sampsize) {
                    power <- pnorm((sqrt(sampsize*(effect)^2) - sqrt(p*q*(1+1/k))*qnorm(1-alpha/2))/sqrt(p1*q1 + p2*q2/k))
                    return(power)
                }
                dat <- dat %>% mutate(y = get_power(x))

                ggplot(data=dat, aes(x=x, y=y)) +
                    geom_line()+
                    annotate("point", x = ss, y = power, colour = "red", size=3)+
                    xlab("sample size")+ylab("power")+
                    scale_x_continuous(breaks= scales::pretty_breaks(n=10))+
                    theme(
                        panel.border = element_blank(),
                        panel.grid.major = element_blank(),
                        panel.grid.minor = element_blank(),
                        axis.line = element_line(colour = "black")
                    )
            }
            else if(input$plot_y == 'effect size'){
                get_effect <- function(sampsize) {
                    effect_size <- sqrt((sqrt(p*q*(1+1/k))*qnorm(1-alpha/2) + sqrt(p1*q1 + p2*q2/k)*qnorm(power))^2/sampsize)/p1
                }
                dat <- dat %>% mutate(y = get_effect(x))
                ggplot(data=dat, aes(x=x, y=y)) +
                    geom_line()+
                    annotate("point", x = ss, y = effectsize, colour = "red", size=3)+
                    xlab("sample size")+ylab("effect size")+
                    scale_x_continuous(breaks= scales::pretty_breaks(n=10))+
                    theme(
                        panel.border = element_blank(),
                        panel.grid.major = element_blank(),
                        panel.grid.minor = element_blank(),
                        axis.line = element_line(colour = "black")
                    )
            }
        })
        
    
    })
    
})


#Things to do 

# - validate that baseline probability is not less than 0 or more than 100 
# - add explanation below power and effectsize plot (?)
# - freeze plot and only update when user hits calculate 
# - clean up plot 


