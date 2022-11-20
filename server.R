server <- function(session, input, output) {

  # Because I want the plots to only render once the user clicks the
  # actionButton, I need to move every interactive, or reactive, element into
  # an eventReactive() function. eventReactive() waits for something to "happen"
  # in order to let the reactive variables run. If you don’t do that, then
  # when the user interacts with app, these reactive variables will run
  # which we do not want.

  # Data only gets filtered once the user clicks on the actionButton
  filtered_data <- eventReactive(input$render_plot, {
    unemp %>%
      filter(place_name %in% input$place_name_selected)
  })


  # The variable the user selects gets passed down to the plot only once the user
  # clicks on the actionButton.
  # If you don’t do this, what will happen is that the variable will then update the plot
  # even when the user does not click on the actionButton
  variable_selected <- eventReactive(input$render_plot, {
    input$variable_selected
  })

  # The plot title only gets generated once the user clicks on the actionButton
  # If you don’t do this, what will happen is that the title of the plot will get
  # updated even when the user does not click on the actionButton
  plot_title <- eventReactive(input$render_plot, {
    paste(variable_selected(), "for", paste(input$place_name_selected, collapse = ", "))
  })

  #The legend gets generated once the user clicks on the action button
  legend <- eventReactive(input$render_plot, {
    input$legend_position
  })

  output$unemp_plot <- renderPlot({

    ggplot(data = filtered_data()) +
      theme_minimal() +
      # Because the selected variable is a string, we need to convert it to a symbol
      # using rlang::sym and evaluate it using !!. This is because the aes() function
      # expects bare variable names, and not strings.
      # Because this is something that developers have to use often in shiny apps,
      # there is a version of aes() that works with strings, called aes_string()
      # You can use both approaches interchangeably.
      #geom_line(aes(year, !!rlang::sym(variable_selected()), color = place_name)) +
      geom_line(aes_string("year", variable_selected(), color = "place_name")) +
      labs(title = plot_title()) +
      theme(legend.position = legend())


  })

  output$unemp_plot_g2r <- renderG2({

    g2(data = filtered_data()) %>%
      # g2r’s asp() requires bare variable names
      fig_line(asp(year, !!rlang::sym(variable_selected()), color = place_name)) %>%
      # For some reason, the title does not show...
      subject(plot_title()) %>%
      legend_color(position = legend())

  })
}
