# Função de leitura de arquivos múltiplos de wps
han_le_wps <- function(pasta_data) {
  suppressPackageStartupMessages({
    library(data.table)
    library(purrr)
    library(abind)
  })

  # Função de leitura de arquivo individual de *.gpx do tipo track
  le_wp <- function(arquivo_wp) {
    suppressPackageStartupMessages({
      library(sf)
      library(dplyr)
      library(data.table)
      library(lubridate)
    })

    wp <- st_read(arquivo_wp, layer = "waypoints", quiet = TRUE)

    saida <- suppressWarnings(as.character(as.integer(str_extract(str_split(arquivo_wp, "/"), "\\d{3}"))))
    lng <- st_coordinates(wp)[,"X"]
    lat <- st_coordinates(wp)[,"Y"]

    wp <- wp %>%
      as_tibble() %>%
      transmute(
        saida = saida,
        datahora = as_datetime(time, tz = Sys.timezone()),
        wp = str_pad(name, 3, pad = "0"),
        lng = as.numeric(lng),
        lat = as.numeric(lat),
        arquivo_wp = arquivo_wp
      )

    return(wp)
  }

  caminho_pasta_gps <- file.path(pasta_data, "GPS")

  # Listagem dos arquivos *.gpx da pasta_GPS
  lista_arquivos_wp <- list.files(
    path = list.dirs(caminho_pasta_gps,
                     recursive = FALSE,
                     full.names = TRUE),
    recursive = FALSE,
    full.names = TRUE,
    pattern = "Pontos"
  )

  # Aplicando a função le_wp para todos arquivos da lista lista_arquivos_wp
  dados_wps <- lista_arquivos_wp %>% map_dfr(le_wp)

  cat("-> OK - leitura dos wps\n")

  return(dados_wps)
}
