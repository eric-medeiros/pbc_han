han_junta <- function(pasta_data) {
  library(dplyr)
  library(stringr)
  library(readxl)
  library(lubridate)
  library(here)

  source(here("01_scripts", "han_le_planilha.R"))
  source(here("01_scripts", "han_le_wps.R"))
  source(here("01_scripts", "han_sub_wps.R"))
  source(here("01_scripts", "han_le_sonda.R"))
  source(here("01_scripts", "han_junta_sondas.R"))

  dados_excel <- han_le_planilha(pasta_data)
  dados_wps <- han_le_wps(pasta_data)
  dados_excel_sub <- han_sub_wps(dados_excel, dados_wps)

  dados_sondas <- han_le_sonda(pasta_data)
  dados_juntos <- han_junta_sondas(dados_excel_sub, dados_sondas)

  return(dados_juntos)
}
