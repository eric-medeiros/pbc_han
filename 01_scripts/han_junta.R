han_junta <- function(pasta_data) {
  library(dplyr)
  library(stringr)
  library(readxl)
  library(lubridate)

  source("../01_scripts/han_le_planilha.R")
  source("../01_scripts/han_le_sonda.R")

  dados_excel <- han_le_planilha(pasta_data)
  dados_sonda <- han_le_sonda(pasta_data)

  dados_juntos <-
    dados_sonda %>%
    mutate(data = date(data_hora)) %>%
    left_join(dados_excel$saidas%>% select(saida, data))

  # PAREI AQUI... TEM QUE JUNTAR O gps TAMBÉM!!!
  #  dados_excel$avistagens %>% select(saida, grupo)

  return(dados_juntos)
}
