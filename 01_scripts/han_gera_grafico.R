han_gera_grafico <- function(dados_juntos, lista_saidas_c_sonda, i) {
  library(plotly)
  library(dplyr)
  library(sf)

  numero_saida <- lista_saidas_c_sonda[i]

  dados_sonda <-
    dados_juntos$sonda %>%
    filter(saida == numero_saida) %>%
    filter(!is.na(lng)) %>%
    st_as_sf(coords = c("lng", "lat"), crs = 4326) %>%
    st_transform(3857) %>%
    arrange(datahora_SONDA) %>%
    mutate(
      dt = as.numeric(difftime(datahora_SONDA, lag(datahora_SONDA), units = "secs")),
      d = as.numeric(st_distance(geometry, lag(geometry), by_element = TRUE)),
      speed = d / dt
    )

  limites_x <-
    dados_juntos$amostragens %>%
    filter(saida == numero_saida) %>%
    summarise(x_min = min(datahora_I), x_max = max(datahora_F))

  # Calcula os intervalos de tempo para cada grupo (considerando somente valores não-NA em 'grupo')
  group_intervals <-
    dados_sonda %>%
    as_tibble() %>%
    filter(!is.na(grupo)) %>%
    group_by(grupo) %>%
    summarise(x0 = min(datahora_SONDA),
              x1 = max(datahora_SONDA))

  # Paleta de cores suaves para os retângulos de fundo dos grupos
  cores <- c("rgba(200,200,200,0.3)", "rgba(180,180,180,0.3)", "rgba(160,160,160,0.3)")

  # Cria uma lista de shapes (retângulos) para cada grupo
  shapes_list <- lapply(seq_len(nrow(group_intervals)), function(numero_saida) {
    list(
      type = "rect",
      xref = "x",
      yref = "paper",  # O retângulo ocupa toda a altura do gráfico
      x0 = group_intervals$x0[numero_saida],
      x1 = group_intervals$x1[numero_saida],
      y0 = 0,
      y1 = 1,
      fillcolor = cores[(numero_saida - 1) %% length(cores) + 1],
      line = list(color = "darkgray", width = 1)
    )
  })

  # Cria o gráfico com as linhas e adiciona a linha de velocidade (fina, discreta e "apagadinha")
  p <-
    plot_ly() %>%
    add_lines(data = dados_sonda, x = ~datahora_SONDA, y = ~Pres,
              name = "Pressão (psi)", line = list(color = "red")) %>%
    add_lines(data = dados_sonda, x = ~datahora_SONDA, y = ~Temp,
              name = "Temperatura (°C)", yaxis = "y2", line = list(color = "blue")) %>%
    add_lines(data = dados_sonda, x = ~datahora_SONDA, y = ~pH,
              name = "pH", yaxis = "y3", line = list(color = "orange")) %>%
    add_lines(data = dados_sonda, x = ~datahora_SONDA, y = ~Turb,
              name = "Turbidez (FNU)", yaxis = "y4", line = list(color = "green")) %>%
    add_lines(data = dados_sonda, x = ~datahora_SONDA, y = ~OD,
              name = "Oxigênio dissolvido (ppm)", yaxis = "y5", line = list(color = "purple")) %>%
    add_lines(data = dados_sonda, x = ~datahora_SONDA, y = ~Sal,
              name = "Salinidade (psu)", yaxis = "y6", line = list(color = "brown")) %>%
    add_lines(data = dados_sonda, x = ~datahora_SONDA, y = ~speed,
              name = "Velocidade (m/s)", yaxis = "y7", line = list(color = "gray", width = 1, dash = "dot"),
              opacity = 0.5) %>%
    layout(
      shapes = shapes_list,
      title = paste0("Saída número ", unique(dados_sonda$saida), " - ", unique(as.Date(dados_sonda$datahora_SONDA)), "\n",
                     "Número de grupos - ", dados_sonda$grupo %>% as.numeric() %>% max(na.rm = TRUE)),
      xaxis = list(title = "Data hora", domain = c(0.15, 0.79), showgrid = FALSE, range = c(limites_x$x_min, limites_x$x_max)),
      yaxis = list(
        title = "Pressão (psi)",
        titlefont = list(color = "red"),
        tickfont = list(color = "red"),
        position = 0,
        showgrid = FALSE
      ),
      yaxis2 = list(
        title = "Temperatura (°C)",
        titlefont = list(color = "blue"),
        tickfont = list(color = "blue"),
        overlaying = "y",
        side = "left",
        position = 0.06,
        anchor = "free",
        showgrid = FALSE
      ),
      yaxis3 = list(
        title = "pH",
        titlefont = list(color = "orange"),
        tickfont = list(color = "orange"),
        overlaying = "y",
        side = "left",
        position = 0.12,
        anchor = "free",
        showgrid = FALSE
      ),
      yaxis4 = list(
        title = "Turbidez (FNU)",
        titlefont = list(color = "green"),
        tickfont = list(color = "green"),
        overlaying = "y",
        side = "right",
        position = 0.8,
        anchor = "free",
        showgrid = FALSE
      ),
      yaxis5 = list(
        title = "Oxigênio dissolvido (ppm)",
        titlefont = list(color = "purple"),
        tickfont = list(color = "purple"),
        overlaying = "y",
        side = "right",
        position = 0.86,
        anchor = "free",
        showgrid = FALSE
      ),
      yaxis6 = list(
        title = "Salinidade (psu)",
        titlefont = list(color = "brown"),
        tickfont = list(color = "brown"),
        overlaying = "y",
        side = "right",
        position = 0.92,
        anchor = "free",
        showgrid = FALSE
      ),
      yaxis7 = list(
        title = "Velocidade (m/s)",
        titlefont = list(color = "gray"),
        tickfont = list(color = "gray"),
        overlaying = "y",
        side = "right",
        position = 0.98,
        anchor = "free",
        showgrid = FALSE
      ),
      legend = list(orientation = 'h', x = 0.1, y = -0.2)
    )
  return(p)
}
