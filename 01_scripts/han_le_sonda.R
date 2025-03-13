han_le_sonda <- function(pasta_data) {
  library(dplyr)
  library(stringr)
  library(readxl)
  library(lubridate)
  library(purrr)

  pasta_sonda <- file.path(pasta_data, "SONDA")
  lista_caminhos_sonda <- list.files(pasta_sonda, pattern = "LOG", full.names = TRUE)

  le_arquivo_sonda <- function(arquivo_sonda) {
    # Lê a planilha 2 do arquivo com os tipos de coluna especificados
    dados_arquivo <-
      read_excel(arquivo_sonda,
                 sheet = 2,
                 col_types = c("date", "date", "numeric", "numeric", "numeric",
                               "numeric", "numeric", "numeric", "numeric", "numeric",
                               "numeric", "numeric", "numeric", "numeric", "numeric",
                               "numeric", "text", "text", "numeric", "numeric")) %>%
      mutate(data_hora = ymd_hms(str_c(as.character(Date), str_sub(as.character(Time), 12, 19))),
             data = date(data_hora),
             lng = as.numeric(str_sub(`GPS Long.`, 1,8))*-1,
             lat = as.numeric(str_sub(`GPS Lat.`, 1,8))*-1) %>%
      suppressWarnings() %>%
      select(21,22,
             Pres = 13,
             Temp = 3,
             Turb = 16,
             Sal = 11,
             OD = 15,
             4,
             23,
             24)

    return(dados_arquivo)
  }
  dados_pasta <- map_df(lista_caminhos_sonda, le_arquivo_sonda)
  cat("-> OK - leitura da sonda\n")
  return(dados_pasta)
}
