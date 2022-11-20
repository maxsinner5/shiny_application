ui <- function(request){
  fluidPage(

    titlePanel("Unemployment in Luxembourg"),

    sidebarLayout(

      sidebarPanel(
        selectizeInput("place_name_selected", "Select place:",
                       choices=unique(unemp$place_name),
                       multiple = TRUE,
                       selected = c("Rumelange", "Dudelange"),
                       options = list(
                         plugins = list("remove_button"),
                         create = TRUE,
                         persist = FALSE # keep created choices in dropdown
                       )
        ),
        hr(),
        # To allow users to select the variable, we add a selectInput
        # (not selectizeInput, like above)
        # don’t forget to use input$variable_selected in the
        # server function later!
        selectInput("variable_selected", "Select variable to plot:",
                    choices = setdiff(unique(colnames(unemp)), c("year", "place_name", "level")),
                    multiple = FALSE,
                    selected = "unemployment_rate_in_percent",
        ),
        hr(),
        # Just for illustration purposes, these radioButtons will not be bound
        # to the actionButton.
        radioButtons(inputId = "legend_position",
                     label = "Choose legend position",
                     choices = c("top", "bottom", "left", "right"),
                     selected = "right",
                     inline = TRUE),
        hr(),
        actionButton(inputId = "render_plot",
                     label = "Click here to generate plot"),
        hr(),
        helpText("Original data from STATEC"),
        hr(),
        bookmarkButton()
      ),

      mainPanel(
        # We add a tabsetPanel with two tabs. The first tab show
        # the plot made using ggplot the second tab
        # shows the plot using g2r
        tabsetPanel(
          tabPanel("ggplot version", plotOutput("unemp_plot")),
          tabPanel("g2r version", g2Output("unemp_plot_g2r"))
        )
      )
    )
  )

}
