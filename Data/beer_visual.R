setwd("C:/Users/Warsec/Desktop/Beer")
library(data.table)
library(choroplethr)
library(ggvis)
library(ggplot2)
library(ggmap)
library(plyr)
library(plotly)
library(scales)

brewer <- read.csv("breweries.csv", header = TRUE, na.strings = c("", " ", "NA"))
geo <- read.csv("breweries_geocode.csv")
location <- read.csv("location.csv")

brewer.US <- subset(brewer, country == "United States")


##Breweries by State in United States############

df_location <- read.csv("df_location.csv")
df_location$hover <- with(df_location, paste(region, '<br>', "Number of Breweries", value))

# give state boundaries a white border
l <- list(color = toRGB("white"), width = 2)
# specify some map projection/options
g <- list(
  scope = 'usa',
  projection = list(type = 'albers usa'),
  showlakes = TRUE,
  lakecolor = toRGB('white')
)

plot_ly(df_location, z = value, text = hover, locations = CODE, type = 'choropleth',
        locationmode = 'USA-states', color = value, colors = "Blues",
        marker = list(line = l), colorbar = list(title = "Number of Breweries")) %>%
  layout(title = 'Breweries by State', geo = g)

##Scatterplot of Breweries by State##############
addresses <- brewer.US$name
addresses <- paste0(addresses,", ", brewer.US$address1,", ", brewer.US$city,", ", brewer.US$state,
                    ", ", brewer.US$country, ", ", brewer.US$code)
est_brew_locat <- geocode(addresses)
