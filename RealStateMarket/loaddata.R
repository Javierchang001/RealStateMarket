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

library(dplyr)
library(readxl)
library(zoo)

# Load Real State data from BCRP
dfile <- "precios-inmobiliarios-bd-desagregada-venta-2020-1.xlsx"
if (!file.exists(dfile)) {
      download.file("https://www.bcrp.gob.pe/docs/Estadisticas/inmuebles/precios-inmobiliarios-bd-desagregada-venta-2020-1.xlsx",
                    destfile = dfile)
}
venta <- read_excel(dfile)
names(venta) <- c("Ano", 
                  "Trim", 
                  "Precio_USD", 
                  "Precio_SOL", 
                  "Precio_SOLConst", 
                  "Distrito", 
                  "Superficie", 
                  "Nro_habitaciones",
                  "Nro_banos",
                  "Nro_garages",
                  "Piso_ubicacion",
                  "Vista_al_exterior",
                  "Anos_antiguedad")

# Data cleansing
venta <- na.omit(venta) %>%
      filter(Ano>=2010 & Nro_habitaciones<=10) %>%
      mutate(Nro_habitaciones = as.numeric(Nro_habitaciones),
             Distrito = tolower(Distrito),
             AnoTrim = as.yearqtr(paste(Ano, Trim, sep="-")),
             Precio_USD_m2 = Precio_USD / Superficie
      )
