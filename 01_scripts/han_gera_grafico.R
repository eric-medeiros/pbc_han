han_gera_grafico <- function(caminho) {
  library(plotly)
  library(dplyr)

  # Cria o gráfico com múltiplos eixos y
  p <-
    plot_ly() %>%
    add_lines(data = dados, x = ~data_hora, y = ~Pres, name = "Pressão (psi)", line = list(color = "red")) %>%
    add_lines(data = dados, x = ~data_hora, y = ~Temp, name = "Temperatura (°C)", yaxis = "y2", line = list(color = "blue")) %>%
    add_lines(data = dados, x = ~data_hora, y = ~pH, name = "pH", yaxis = "y3", line = list(color = "orange")) %>%
    add_lines(data = dados, x = ~data_hora, y = ~Turb, name = "Turbidez (FNU)", yaxis = "y4", line = list(color = "green")) %>%
    add_lines(data = dados, x = ~data_hora, y = ~OD, name = "Oxigênio dissolvido (ppm)", yaxis = "y5", line = list(color = "purple")) %>%
    add_lines(data = dados, x = ~data_hora, y = ~Sal, name = "Salinidade (psu)", yaxis = "y6", line = list(color = "brown")) %>%
    layout(
      title = paste0(basename(caminho), " - Múltiplos Eixos Y"),
      xaxis = list(title = "Data hora", domain = c(0.15, 0.80)),
      yaxis = list(
        title = "Pressão (psi)",
        titlefont = list(color = "red"),
        tickfont = list(color = "red")
      ),
      yaxis2 = list(
        title = "Temperatura (°C)",
        titlefont = list(color = "blue"),
        tickfont = list(color = "blue"),
        overlaying = "y",
        side = "right",
        position = 0.90,
        anchor = "free"
      ),
      yaxis3 = list(
        title = "pH",
        titlefont = list(color = "orange"),
        tickfont = list(color = "orange"),
        overlaying = "y",
        side = "right",
        position = 0.85,
        anchor = "free"
      ),
      yaxis4 = list(
        title = "Turbidez (FNU)",
        titlefont = list(color = "green"),
        tickfont = list(color = "green"),
        overlaying = "y",
        side = "left",
        position = 0.05,
        anchor = "free"
      ),
      yaxis5 = list(
        title = "Oxigênio dissolvido (ppm)",
        titlefont = list(color = "purple"),
        tickfont = list(color = "purple"),
        overlaying = "y",
        side = "left",
        position = 0.10,
        anchor = "free"
      ),
      yaxis6 = list(
        title = "Salinidade (psu)",
        titlefont = list(color = "brown"),
        tickfont = list(color = "brown"),
        overlaying = "y",
        side = "right",
        position = 0.95,
        anchor = "free"
      ),
      legend = list(orientation = 'h', x = 0.1, y = -0.2)
    )

  return(p)
}
