library(shiny)
library(shinythemes)

ui <- navbarPage(title='A/B Testing Toolkit',
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
        sidebarPanel(width=12, 
                     h3("Formula:"), 
                     tags$img(src='ss_formula.png', height=400, width=600),
                     br(),
                     tags$a(href='https://towardsdatascience.com/required-sample-size-for-a-b-testing-6f6608dd330a', 
                            "Source: Towards Data Science", style="color:blue")))
        )
    )
    )
)

server <- function(input, output, session) {
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
  
}

shinyApp(ui, server)