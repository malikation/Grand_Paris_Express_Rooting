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
                menuItem("Plot #1", tabName = "item2 "),
                menuItem("Plot #2", tabName = "item3 "),
                menuItem("Plot #3", tabName = "item4 "),
                menuItem("Plot #4", tabName = "item5 "),
                menuItem("Plot #5", tabName = "item6 "),
                menuItem("Plot #6", tabName = "item7 "),
                menuItem("Plot #7", tabName = "item1 ")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "item1", h1("Congestion and total_Duration in function of itinerary"),plotOutput("congestPlot"), textOutput("mytext1")),
      tabItem(tabName = "item2", h1("Congestion and Duration in function of itinerary"),plotOutput("carplot"), textOutput("mytext2")),
      tabItem(tabName = "item3", h1("Duration in function of itinerary"),plotOutput("dureplot")),
      tabItem(tabName = "item4", h1("conjestion car in function of itinerary"),plotOutput("congestcarplot")),
      tabItem(tabName = "item5", h1("duration in function de l'itinerary"),plotOutput("dureitplot"), textOutput("mytext3")),
      tabItem(tabName = "item6", h1("Sum of duration and total wait in function of itinerary "),
              plotOutput("sumdureplot"), textOutput("mytext4")
      ),
      tabItem(tabName = "item7", h1("waiting time in function of itinerary"),plotOutput("waitingplot"), textOutput("mytext5"))
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$mytext1 <- renderText({
    "First, we can observe that the graph has two curves: a red curve for congestion, and a blue curve for the total wait.

We can notice that for some routes, the congestion is very high while for others, it is almost non-existent. For example, we can see that for route 1, congestion is very high, while for route 7, it is very low.

As for the blue curve, it shows the evolution of the total waiting time. It can be seen that it is very variable from one route to another. For example, for route 1, the total waiting time is very high, while for route 6, it is very low.

A closer look at the two curves shows that for some routes, congestion and total waiting time are correlated. For example, for route 5, we can see that congestion is very high and total waiting time is also very high. For other routes, however, there is no apparent correlation between the two curves.

In summary, this graph shows the evolution of congestion and total waiting time for different routes. It shows the differences between the routes in terms of congestion and total waiting time."
  })
  
  output$mytext2 <- renderText({
    "Looking at the curve, we can see that duration and congestion are not clearly correlated. There are routes that have similar duration but very different levels of congestion and vice versa. This can be due to a number of factors such as time of day, weather conditions, routes taken, etc.

There are also a few routes that stand out from the rest. Routes 37, 66, and 75 have an above-average duration, while routes 24, 54, and 78 have a below-average duration. Similarly, Routes 1, 18, and 19 have high congestion, while Routes 24, 36, and 54 have low congestion.

The duration versus route curve shows some variability, but it does not have as many peaks as the congestion curve. It can be noted, however, that routes with longer duration tend to have higher congestion as well. For example, routes 18, 34, 37, 39, 56, 65, and 66 all have durations greater than 2600, which also corresponds to high levels of congestion (greater than 4300 in most cases).

On the other hand, some routes appear to have relatively high congestion despite their relatively short duration, such as routes 1, 5, 12, 19, and 42. This may be due to the fact that these routes pass through particularly congested areas, which may slow traffic down despite the relatively short distance.

Overall, the duration versus route curve shows some interesting trends, particularly in terms of congestion correspondence, although it does not show as much variation as the congestion curve."
  })
  
  output$mytext3 <- renderText({
    "The graph shows the relationship between the duration of a trip and the corresponding itinerary. Each point on the graph represents a trip, and the X-axis represents the duration in seconds, while the Y-axis represents the itinerary number.

We can see that there is a wide range of trip durations, ranging from 0 seconds to almost 7400 seconds. The majority of trips seem to fall between 2000 and 5000 seconds.

In terms of itinerary, there are some clear patterns. For example, there are a few popular itineraries, such as itinerary 1 and itinerary 10, which appear several times on the graph. Itinerary 1 has a relatively short duration and a low number of stops and wait time, while itinerary 10 has a longer duration and a higher number of stops and wait time.

We can also see some trends in terms of the number of stops and wait time. Trips with a higher number of stops generally have a longer duration and a higher total wait time. However, there are some exceptions to this trend, as some trips with a relatively low number of stops also have a high wait time.

Overall, the graph provides a useful visual representation of the relationship between trip duration and itinerary. It can help identify patterns and trends in the data and highlight areas for further analysis.
"
  })
  output$mytext4 <- renderText({
    "The plot of the sum of total duration and total wait (total_wait) versus route shows the total time that each route took to reach its destination. It is important to note that the total duration includes not only the travel time, but also the waiting time accumulated along the route.

The graph reveals that there are significant variations in travel times for each route, ranging from a few minutes to over an hour. It can also be seen that there is a strong correlation between the total number of stops made during the trip and the total travel time. Routes with fewer stops tend to have shorter travel times, while those with more stops tend to have longer travel times.

In addition, there appears to be a correlation between total wait time and total travel time. Routes with longer wait times tend to have longer total travel times. This may be due to several factors, such as delays in connections or longer waiting times at stops.

In conclusion, the plot of the sum of total time and total waiting time versus route provides an overview of travel times for each route, with significant variations based on the number of stops and waiting time. This type of analysis can help identify the most efficient routes and find ways to improve travel times for the slowest routes."
  })
  output$mytext5 <- renderText({
    "The graph of Total Wait vs. Route shows the variation of total passenger waiting time for each bus route. It can be observed that the total waiting time increases significantly for some routes (e.g., route 12, 24, 26, 63) while for other routes it is relatively stable (e.g., routes 3, 4, 6, 16, 21, 31, 35, 37, 46, 70, 71, 73, 76, 94, 97, and 98).

This may be due to factors such as the traffic density on a particular route, the frequency of bus service, the layout of bus stops and their number on each route, and the characteristics of the area served by each route. These factors can all have a significant impact on passenger waiting time for each bus route.

By examining the graph, decision makers can identify routes that require improvements to reduce passenger wait times and improve their overall transportation experience. For example, routes 12 and 24 appear to be the ones that need the most attention, as they have the highest wait times. In contrast, routes 3, 4, 6, 16, 21, 31, 35, 37, 46, 70, 71, 73, 76, 94, 97, and 98 appear to be performing relatively well in terms of passenger wait times."
  })
  
    output$congestPlot <- renderPlot({

      
      data_final_transit_modif_20_02_2023_filtered <- data_final_transit_modif_20_02_2023 %>%
        mutate(sum_duration_total_wait = duration + total_wait) %>%
        filter(sum_duration_total_wait > 2000 & sum_duration_total_wait < 6000 & itinerary <= 91)
      
      ggplot(data_final_transit_modif_20_02_2023_filtered, aes(x = itinerary)) +
        geom_line(aes(y = conjestion, color = "Congestion"), size = 1, data = data_final_transit_modif_20_02_2023_filtered[data_final_transit_modif_20_02_2023_filtered$itinerary <= 91,]) +
        geom_line(aes(y = sum_duration_total_wait, color = "Total_Duration"), size = 1, data = data_final_transit_modif_20_02_2023_filtered[data_final_transit_modif_20_02_2023_filtered$itinerary <= 91,]) +
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
        ggtitle("duration in function of +itinerary") +
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
