library(shiny)
library(tidyverse)
library(finalfit)

# Dataset from medicaldata::licorice_gargle 
licodata_raw = read_csv("licodata_raw.csv")

# reading in 0,1, recoding
licodata = licodata_raw %>% 
  mutate(preOp_gender.factor = preOp_gender %>% 
           factor() %>% 
           fct_recode("Male" = "0",
                      "Female" = "1"),
         preOp_asa.factor = preOp_asa %>% 
           factor() %>% 
           fct_recode("a normal healthy patient" = "1",
                      "a patient with mild systemic disease" = "2",
                      "a patient with severe systemic disease" = "3"),
         treat.factor = treat %>% 
           factor() %>% 
           fct_recode("Sugar 5g" = "0",
                      "Licorice 0.5g" = "1") %>% 
           ff_label("Treatment"),
         preOp_smoking.factor = preOp_smoking %>% 
           factor() %>% 
           fct_recode("Current" = "1",
                      "Past" = "2",
                      "Never" = "3"),
         
         pod1am_throatPain.factor = pod1am_throatPain %>% 
           factor() %>% 
           fct_collapse("No Pain" = "0",
                        other_level = "Pain") %>% ff_label("Throat Pain"),
         pod1am_cough.factor = pod1am_cough %>% 
           factor() %>% 
           fct_collapse("No Cough" = "0",
                        other_level = "Cough") %>% 
           ff_label("Cough"),
         
         pacu30min_swallowPain.factor = pacu30min_swallowPain %>% 
           factor() %>% 
           fct_collapse("No Pain" = "0",
                        other_level = "Pain") %>% 
           ff_label("Swallow Pain")) 

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Licorice Data"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      radioButtons("radio", label = h3("Variable Select"),
                   choices = list("Throat Pain" = "pod1am_throatPain.factor",
                                  "Swallow Pain (30 min post-op)" = "pacu30min_swallowPain.factor", 
                                  "Cough" = "pod1am_cough.factor"), 
                   selected = "pacu30min_swallowPain.factor")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("barplot_output"),
      tableOutput("table_lico")
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$barplot_output <- renderPlot({
      licodata %>% 
        drop_na(!!sym(input$radio)) %>% 
        ggplot(aes(x = treat.factor, fill = !!sym(input$radio)))+
        geom_bar() +
        theme_bw() + 
        scale_fill_brewer()
      
  })
    
    output$table_lico <- renderTable({
      
      licodata %>% 
        summary_factorlist(dependent = input$radio,
                           explanatory = "treat.factor")
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
