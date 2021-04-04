# --------------------------------------------------------------------------------------------
# Course: Developing Data Products
# Assignment: Final Course project
# Author: Javier Chang
# Date: April 3, 2021
# 
# This application will show the evolution of the sale prices of the apartments located in Lima
# with characteristics similar to the chosen variables (district, total floor area, number of 
# rooms and age of the building). Likewise, this application will predict the sale price of an
# apartment with similar characteristics to your input on these factors using a linear model
# --------------------------------------------------------------------------------------------

# Load needed libraries
library(shiny)
library(dplyr)
library(ggplot2)
library(readxl)

# Load libraries
source('loaddata.R', local = TRUE)

# UI application
shinyUI(fluidPage(
    
    # Application title
    titlePanel("Real state market in Lima Peru"),
    
    # Sidebar with the input of the variables
    sidebarLayout(
        sidebarPanel(
            h4("Please select the characteristics of an apartment"),
            selectInput("Distrito", "District:", (sort(unique(venta$Distrito), decreasing = FALSE)), selected="miraflores"),
            sliderInput("Superficie", "Total floor area (m2)", min=50, max=650, value=100),
            sliderInput("Nro_habitaciones", "Number of rooms:", min=min(venta$Nro_habitaciones), max=max(venta$Nro_habitaciones), value=2),
            sliderInput("Anos_antiguedad", "Age of the building (years):", min=min(venta$Anos_antiguedad), max=30, value=0)
        ),
        
        # Show the sales prices evolution and the estimated sales price for a similar apartment
        mainPanel(
            
            tabsetPanel(type = "tabs",
                        
                        tabPanel("Results",
                        h4("Evolution of the sale price per square meter of the apartments with similar characteristics to the selected variables. A boxplot is displayed for each quarter."),
                        plotOutput("distPlot"),
                        h4("Estimated sale price for an apartment with similar characteristics"),
                        h4(span(textOutput("estprice")), align="center")
                        ),
                        
                        tabPanel("Documentation",
                        h4("Real state market is very dynamic. The price of the apartments in Lima-Peru depends on several variables:"),
                        h5("- District: where the apartment is locared"),
                        h5("- Total floor area: the size of the apartment"),
                        h5("- Number of rooms: the number of rooms in the apartment"),
                        h5("- Age of the building: how old is the building"),
                        h4("This Shiny App will show the evolution of the sale prices of apartments in Lima. Likewise, this application will predict the sale price of an apartment with similar characteristics to your input on these factors using a linear model")
                    )
            )
        )
    )
)
)
