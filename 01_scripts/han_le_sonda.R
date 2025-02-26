han_le_sonda <- function(pasta_data) {
  library(dplyr)
  library(stringr)
  library(readxl)
  library(lubridate)
  library(purrr)

  lista_caminhos_sonda <- list.files(pasta_data, pattern = "LOG", full.names = TRUE)

  le_arquivo_sonda <- function(arquivo_sonda) {
    # Lê a planilha 2 do arquivo com os tipos de coluna especificados
    dados_arquivo <-
      read_excel(arquivo_sonda,
                 sheet = 2,
                 col_types = c("date", "date", "numeric", "numeric", "numeric",
                               "numeric", "numeric", "numeric", "numeric", "numeric",
                               "numeric", "numeric", "numeric", "numeric", "numeric",
                               "numeric", "text", "text", "numeric", "numeric")) %>%
      mutate(data_hora = ymd_hms(str_c(as.character(Date), str_sub(as.character(Time), 12, 19)))) %>%
      select(data_hora,
             Pres = `Press.[psi]`,
             Temp = `Temp.[°C]`,
             Turb = `Turb.FNU`,
             Sal = `Sal.[psu]`,
             OD = `D.O.[ppm]`,
             pH) %>%
      suppressWarnings()

    return(dados_arquivo)
  }
  dados_pasta <- map_df(lista_caminhos_sonda, le_arquivo_sonda)
  cat("-> OK - leitura da sonda\n")
  return(dados_pasta)
}
