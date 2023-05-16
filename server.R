library(shiny)
library(shinythemes)
library(leaflet)
library(highcharter)
library(dplyr)


shinyServer(function(input, output, session) {
  observeEvent(input$location, {
    x <- input$location
    if (!is.null(x) && x != "") {
      sink("data/locationLog.txt", append = TRUE, split = FALSE)
      cat(paste0(x, "\n"))
      sink()
    }
  })

  output$Map <- renderLeaflet({
    leaflet() %>%
      addProviderTiles("CartoDB.Positron") %>%
      addCircleMarkers(
        data = cities,
        radius = ~sqrt(PopClass),
        color = ~palfun(PopClass),
        stroke = FALSE, fillOpacity = 0.5, layerId = ~Location)
  })

  observeEvent(input$Map_marker_click, {
    p <- input$Map_marker_click
    if (p$id == "Selected") {
      leafletProxy("Map") %>%
        removeMarker(layerId = "Selected")
    } else {
      leafletProxy("Map") %>%
        setView(lng = p$lng, lat = p$lat, zoom = input$Map_zoom) %>%
        addCircleMarkers(
          p$lng, p$lat,
          radius = 10,
          color = "black",
          fillColor = "orange",
          fillOpacity = 1,
          opacity = 1, stroke = TRUE, layerId = "Selected")
    }
  })

  observeEvent(input$Map_marker_click, {
    p <- input$Map_marker_click
    if (!is.null(p$id)) {
      if (is.null(input$location)) updateSelectInput(session, "location", selected = p$id)
      if (!is.null(input$location) && input$location != p$id) updateSelectInput(
        session, "location", selected = p$id)
    }
  })

  observeEvent(input$location, {
    p <- input$Map_marker_click
    p2 <- subset(cities, Location == input$location)
    if (nrow(p2) == 0) {
      leafletProxy("Map") %>%
        removeMarker(layerId = "Selected")
    } else if (is.null(p$id) || input$location != p$id) {
      leafletProxy("Map") %>%
        setView(lng = p2$Lon, lat = p2$Lat, zoom = input$Map_zoom) %>%
        addCircleMarkers(
          p2$Lon, p2$Lat,
          radius = 10,
          color = "black",
          fillColor = "orange",
          fillOpacity = 1,
          opacity = 1, stroke = TRUE, layerId = "Selected")
    }
  })

  Dec <- reactive({
    x <- sort(as.numeric(substr(input$dec, 1, 4)))
    if (any(is.na(x))) return(NULL) else return(c("2010-2099", paste(x, x + 9, sep = "-")))
  })
  nDec <- reactive({ length(Dec()) })
  Colors <- reactive({ if (
    input$variable == "Temperature" & nDec()) c(
    "#666666", colorRampPalette(
      c("gold", "orange", "orangered", "darkred"))(nDec() - 1)) else c(
    "#666666", colorRampPalette(c("aquamarine", "dodgerblue4"))(nDec() - 1)) })
  RCPLabel <- reactive
