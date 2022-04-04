#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
    observeEvent(input$numA, {
        updateSliderInput(session, "XA", max = input$numA)
    })
    
    observeEvent(input$numB, {
        updateSliderInput(session, "XB", max = input$numA)
    })
    
    alpha <- reactive({1-input$conflevel/100})
    power <- reactive({input$power/100})
    p1 <- reactive({input$baseline/100})
    effectsize <- reactive({input$effectsize/100})
    effect <- reactive(effectsize()*p1())
    p2 <- reactive({p1()-effect()})
    
    ss <- eventReactive(input$calculate,{
        k <- 1 
        p <- (p1()+k*p2())/(1+k)
        q <- (1-p)
        q1 <- 1-p1()
        q2 <- 1-p2()
        n1 <- (sqrt(p*q*(1+1/k))*qnorm(1-alpha()/2) + sqrt(p1()*q1 + p2()*q2/k)*qnorm(power()))^2/effect()^2
        n2 <- k*n1
        #from towardsdatascience article 
        round(n1)
    }
    )
    
    output$samplesize <- renderText({
        paste(ss())
    })
    
    #plot 
    
})
