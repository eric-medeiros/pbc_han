# pbc_han :ocean:  
**Monitoramento Costeiro Integrado**

Pacote para análise de dados ambientais e biológicos coletados em saídas de campo, integrando:

- :triangular_ruler: **Dados da sonda multiparâmetro** (Temperatura, Salinidade, OD, pH, Turbidez)  
- :whale: **Registros biológicos** (avistagens de fauna e amostragens)  
- :earth_americas: **Georreferenciamento** (tracks GPS e waypoints)  
- :clipboard: **Metadados estruturados** (planilhas de controle de campo)

---

## Funcionalidades Principais

### Processamento Automatizado
- Fusão de dados heterogêneos (sensores, GPS, planilhas)  
- Cálculo automático de velocidades e deslocamentos  
- Correção de fusos horários e formatos de dados  

### Visualização Interativa
<img src="https://raw.githubusercontent.com/[SEU_USUARIO]/[REPOSITORIO]/main/exemplo_grafico.png" width=85% style="display: block; margin: auto;">

- Gráficos temporais multivariados (Plotly)  
- Mapeamento espacial de rotas e eventos  
- Relatórios dinâmicos por saída de campo  

### Saídas Organizadas
- Dados consolidados em formato tidy  
- Metadados de arquivos e processamento  
- Relatórios em HTML/Flexdashboard  

---

## Estrutura do Projeto

pbc_han/
├── 00_data/ # Dados brutos
│ ├── EXCEL/ # Planilhas de controle
│ ├── GPS/ # Arquivos .gpx
│ └── SONDA/ # Logs da sonda
├── 01_scripts/ # Funções R
├── 02_rmrkdwn/ # Relatórios processados
└── README.md # Documentação


---

## Como Usar

1. **Preparar dados**  
   Colete na pasta `00_data`:
   - Planilha `populacional_PBC_sonda.xlsx` em `EXCEL/`  
   - Tracks GPS em `GPS/` (arquivos `.gpx` com sufixo "_Pontos")  
   - Logs da sonda em `SONDA/` (arquivos `.xlsx` com prefixo "LOG")  

2. **Processar dados**  
   - source("01_scripts/han_junta.R")
   - dados_integrados <- han_junta(pasta_data = "00_data")

3. **Gerar relatórios**
- Renderize explora_sonda.Rmd para obter:

	- Gráficos interativos por saída

	- Tabelas filtradas de eventos

	- Análises espaço-temporais
