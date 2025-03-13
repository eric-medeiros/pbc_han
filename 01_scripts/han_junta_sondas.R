# Função junta_sondas para combinar dados de sonda com dados de avistagens
han_junta_sondas <- function(dados_excel_sub, dados_sondas) {

  # Juntando dados da sonda com dados de avistagens
  dados_sondas_processadas <-
    dados_sondas %>%
    mutate(data_hora = force_tz(data_hora, tzone = "America/Sao_Paulo")) %>%
    left_join(dados_excel_sub$saidas %>% select(saida, data), by = "data") %>%
    left_join(dados_excel_sub$avistagens %>% select(grupo, datahora_I, datahora_F),
              by = join_by("data_hora" >= "datahora_I", "data_hora" <= "datahora_F")) %>%
    group_by(saida, grupo) %>% # Agrupando por 'saida' e 'grupo'
    arrange(data_hora) %>% # Ordenando pelas datahora_SONDA
    ungroup() %>%
    select(saida, grupo, datahora_SONDA = data_hora, Temp, Sal, OD, Turb, pH, Pres, lng, lat) # Selecionando as colunas relevantes

  # Adicionando os resultados das sondas à lista dados_excel_sub$sonda
  dados_excel_sub$sonda <- dados_sondas_processadas

  # # Atualizando $caminhos
  # dados_excel_sub$caminhos <- dados_sondas_processadas %>%
  #   select(saida, caminho_arquivo = arquivo) %>%
  #   unique() %>%
  #   nest(id = saida) %>%
  #   transmute(tipo = "sonda",
  #             id = id,
  #             arquivo = basename(caminho_arquivo),
  #             pasta = dirname(caminho_arquivo)) %>%
  #   bind_rows(dados_excel_sub$caminhos)

  cat("-> OK - junção das sonda\n")

  return(dados_excel_sub)
}
