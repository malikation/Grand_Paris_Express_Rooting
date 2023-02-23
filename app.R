#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(ggplot2)
library(dplyr)
library(shiny)
library(shinydashboard)

# Define UI for application that draws a histogram
ui <- dashboardPage(
  dashboardHeader(title = "Grand Paris Express"),
  dashboardSidebar(
    sidebarMenu(id = "sidebar",
                menuItem("Plot #1", tabName = "item1"),
                menuItem("Plot #2", tabName = "item2 "),
                menuItem("Plot #3", tabName = "item3 "),
                menuItem("Plot #4", tabName = "item4 "),
                menuItem("Plot #5", tabName = "item5 "),
                menuItem("Plot #6", tabName = "item6 "),
                menuItem("Plot #7", tabName = "item7")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "item1", h1("Congestion and total_Duration in function of itinerary"),plotOutput("congestPlot")),
      tabItem(tabName = "item2", h1("Congestion and Duration in function of itinerary"),plotOutput("carplot")),
      tabItem(tabName = "item3", h1("Duration in function of itinerary"),plotOutput("dureplot")),
      tabItem(tabName = "item4", h1("conjestion car in function of itinerary"),plotOutput("congestcarplot")),
      tabItem(tabName = "item5", h1("duration in function de l'itinerary"),plotOutput("dureitplot")),
      tabItem(tabName = "item6", h1("Sum of duration and total wait in function of itinerary "),
              plotOutput("sumdureplot")
      ),
      tabItem(tabName = "item7", h1("waiting time in function of itinerary"),plotOutput("waitingplot"))
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  data_final_transit_modif_20_02_2023_filtered <- data_final_transit_modif_20_02_2023 %>%
    mutate(sum_duration_total_wait = duration + total_wait) %>%
    filter(sum_duration_total_wait > 2000 & sum_duration_total_wait < 6000)
  
    output$congestPlot <- renderPlot({

      
      ggplot(data_final_transit_modif_20_02_2023_filtered, aes(x = itinerary)) +
        geom_line(aes(y = conjestion, color = "Congestion"), size = 1) +
        geom_line(aes(y = sum_duration_total_wait, color = "Total_Duration"), size = 1) +
        xlab("itinerary") +
        ylab("total_Duration-Conjestion") +
        ggtitle("Congestion and total_Duration in function of itinerary") +
        scale_x_continuous(breaks = seq(1, max(data_final_transit_modif_20_02_2023_filtered$itinerary), 5)) +
        scale_y_continuous(limits = c(0, max(data_final_transit_modif_20_02_2023_filtered$sum_duration_total_wait, na.rm = TRUE)),
                           breaks = seq(0, max(data_final_transit_modif_20_02_2023_filtered$sum_duration_total_wait, na.rm = TRUE), 500)) +
        scale_color_manual(name = "Color Legend", values = c("blue", "red"), 
                           labels = c("Congestion", "Total_Duration"))
    })
    output$carplot <- renderPlot({
      ggplot(data_final_car_20_02_2023, aes(x = itinerary)) +
        geom_line(aes(y = conjestion, color = "Congestion"), size = 1) +
        geom_line(aes(y = duration, color = "Duration"), size = 1) +
        xlab("itinerary") +
        ylab("Duration-Conjestion") +
        ggtitle("Congestion and Duration in function of itinerary") +
        scale_x_continuous(breaks = seq(1, max(data_final_car_20_02_2023$itinerary), 5)) +
        scale_y_continuous(breaks = seq(500, max(data_final_car_20_02_2023$conjestion), 200)) +
        scale_color_manual(name = "Color Legend", values = c("blue", "red"), 
                           labels = c("Congestion", "Duration"))
    
      })
    output$dureplot <- renderPlot({
      ggplot(data_final_car_20_02_2023, aes(x = itinerary, y = duration, color = "Duration")) +
        geom_line(size = 1.5) +
        xlab("itinerary") +
        ylab("duration") +
        ggtitle("Duration in function of itinerary") +
        scale_x_continuous(breaks = seq(1, max(data_final_car_20_02_2023$itinerary), 5)) +
        scale_y_continuous(breaks = seq(500, max(data_final_car_20_02_2023$duration), 200)) +
        scale_color_manual(name = "Color Legend", values = c("red"),
                           labels = c("Duration"))
    })
    output$congestcarplot <- renderPlot({
      ggplot(data_final_car_20_02_2023, aes(x = itinerary, y = conjestion)) +
        geom_line(color = "blue") +
        xlab("itinerary") +
        ylab("conjestion") +
        ggtitle("conjestion car in function of itinerary") +
        scale_x_continuous(breaks = seq(1, max(data_final_car_20_02_2023$itinerary), 5)) +
        scale_y_continuous(breaks = seq(500, max(data_final_car_20_02_2023$conjestion), 200))
    })
    output$dureitplot <- renderPlot({
      ggplot(data_final_transit_20_02_2023 %>% filter(duration > 2000 & duration < 6000),
             aes(x = itinerary, y = duration)) +
        geom_line(color = "blue") +
        xlab("itinerary") +
        ylab("duration") +
        ggtitle("duration in function de l'itinerary") +
        scale_x_continuous(breaks = seq(1, max(data_final_transit_20_02_2023$itinerary), 5))+
        scale_y_continuous(breaks = seq(0, max(data_final_transit_20_02_2023$duration), 500))
    })
    output$sumdureplot <- renderPlot({
      data_final_transit_20_02_2023 <- data_final_transit_20_02_2023 %>%
        mutate(sum_duration_total_wait = duration + total_wait) %>%
        filter(sum_duration_total_wait > 2000 & sum_duration_total_wait < 6000)
      
      ggplot(data_final_transit_20_02_2023, aes(x = itinerary, y = sum_duration_total_wait, color = "Sum of duration and total wait")) +
        geom_line(size = 1) +
        xlab("itinerary") +
        ylab("Sum of duration and total wait") +
        ggtitle("Sum of duration and total wait in function of itinerary") +
        scale_x_continuous(breaks = seq(1, max(data_final_transit_20_02_2023$itinerary), 5)) +
        scale_y_continuous(breaks = seq(2000, 6000, 500)) +
        scale_color_manual(name = "Color Legend", values = c("blue"),
                           labels = c("Sum of duration and total wait"))
    })
    
    output$waitingplot <-renderPlot({
      ggplot(data_final_transit_20_02_2023, aes(x = itinerary, y = total_wait)) +
        geom_line(color = "blue") +
        xlab("itinerary") +
        ylab("waiting time") +
        ggtitle("waiting time in function of itinerary") +
        scale_x_continuous(breaks = seq(1, max(data_final_transit_20_02_2023$itinerary), 5)) +
        scale_y_continuous(breaks = seq(0, max(data_final_transit_20_02_2023$total_wait), 500))
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
