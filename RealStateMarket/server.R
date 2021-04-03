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

# Load libraries
library(shiny)
library(dplyr)
library(ggplot2)

# Load data source
source('loaddata.R', local = TRUE)

# Server logic shows sales price evolution and estimated price of an apartment with similar characteristics
shinyServer(function(input, output) {
    
    output$distPlot <- renderPlot({
        
        # Filter apartments with similar characteristics as the input variables
        venta_sub <- venta[venta$Distrito==input$Distrito &
                               venta$Nro_habitaciones==input$Nro_habitaciones &
                               venta$Anos_antiguedad==input$Anos_antiguedad &
                               between(venta$Superficie, input$Superficie*.80, input$Superficie*1.20),]
        
        # Draw the evolution of sales price per square meter
        ggplot()+
            geom_boxplot(data=venta_sub, 
                         aes(x=as.character(AnoTrim), 
                             y=Precio_USD_m2 ))+
            ggtitle("Boxplot - Evolution of sales price per square meter") +
            theme(plot.title = element_text(hjust = 0.5))+
            labs(x="Quarter", y="Price per square meter")+
            theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
    })
    
    # Predict sales price for an apartment with similar characteristics as the input variables
    output$estprice <- renderText({ 

        fit <- lm(Precio_USD~Distrito+AnoTrim+Superficie+Nro_habitaciones+Anos_antiguedad, data=venta)

        price <- predict(fit, data.frame(
            Distrito=input$Distrito,
#            AnoTrim=max(venta[venta$Distrito==input$Distrito,]$AnoTrim), 
            AnoTrim=as.yearqtr(Sys.Date()),
            Superficie=input$Superficie, 
            Nro_habitaciones=input$Nro_habitaciones, 
            Anos_antiguedad=input$Anos_antiguedad))
        
        paste("USD",format(round(price,0), big.mark = ","))
    })
    
})
