# ============================================================
# PROYECTO FINAL - ANÁLISIS EXPLORATORIO DE DATOS (EDA)
# ============================================================
#
# Título:
# Datos de carbono negro en la cordillera Huaytapallana
# en el Centro de Monitoreo de Glaciares y Ecosistemas
# de Montaña (CEMGEM), Huancayo, Junín
#
# Periodo de análisis: 2022-2024
# Fuente: Plataforma Nacional de Datos Abiertos
#
# ============================================================


# ============================================================
# 1. CARGA DE PAQUETES
# ============================================================

library(tidyverse)
library(lubridate)
library(ggplot2)
install.packages("patchwork")
library(patchwork)


# ============================================================
# 2. IMPORTACIÓN DE DATOS
# ============================================================
setwd("F:/ANDY/UNI/Bachiller/Ofimática/Clases Módulo 4/Trabajo/PROYECTO CARBONO EN R")
getwd()
list.files("data")

datos <- read_csv(
  "data/datos_carbono_negro.csv"
)


datos <- read_delim(
  "data/datos_carbono_negro.csv",
  delim = ";",
  show_col_types = FALSE
)

# Ver estructura de la base
str(datos)

# Visualizar primeras observaciones
head(datos)

# Dimensiones de la base
dim(datos)

# ============================================================
# 3. EXPLORACIÓN INICIAL DE LOS DATOS
# ============================================================

# Resumen estadístico inicial
summary(datos)

# Nombres de las variables
names(datos)

# Tipo de variable
sapply(datos, class)

# Cantidad de valores faltantes
colSums(is.na(datos))

# Limpiar espacios en los nombres de las variables
names(datos) <- trimws(names(datos))

# Verificar nombres corregidos
names(datos)

# ============================================================
# 4. CONTROL DE CALIDAD
# ============================================================

# Cantidad de valores -999 en variables numéricas

datos %>%
  summarise(
    across(
      where(is.numeric),
      ~ sum(.x == -999, na.rm = TRUE)
    )
  )

datos %>%
  summarise(
    BLACK_CARBON_negativos =
      sum(BLACK_CARBON < 0, na.rm = TRUE),
    
    BROWN_CARBON_negativos =
      sum(BROWN_CARBON < 0, na.rm = TRUE),
    
    SPOT_A_negativos =
      sum(SPOT_A < 0, na.rm = TRUE),
    
    SPOT_B_negativos =
      sum(SPOT_B < 0, na.rm = TRUE),
    
    FACTOR_negativos =
      sum(FACTOR < 0, na.rm = TRUE),
    
    FLUJO_SPOT_A_negativos =
      sum(FLUJO_SPOT_A < 0, na.rm = TRUE),
    
    FLUJO_SPOT_B_negativos =
      sum(FLUJO_SPOT_B < 0, na.rm = TRUE)
  )

datos %>%
  summarise(
    BLACK_CARBON_negativos =
      sum(BLACK_CARBON < 0, na.rm = TRUE),
    
    BROWN_CARBON_negativos =
      sum(BROWN_CARBON < 0, na.rm = TRUE),
    
    SPOT_A_negativos =
      sum(SPOT_A < 0, na.rm = TRUE),
    
    SPOT_B_negativos =
      sum(SPOT_B < 0, na.rm = TRUE),
    
    FACTOR_negativos =
      sum(FACTOR < 0, na.rm = TRUE),
    
    FLUJO_SPOT_A_negativos =
      sum(FLUJO_SPOT_A < 0, na.rm = TRUE),
    
    FLUJO_SPOT_B_negativos =
      sum(FLUJO_SPOT_B < 0, na.rm = TRUE)
  )

# Duplicados en toda la base
sum(duplicated(datos))

# Duplicados en la fecha
sum(duplicated(datos$FECHA_CORTE))

datos %>%
  arrange(FECHA_CORTE) %>%
  mutate(
    diferencia_minutos = as.numeric(
      difftime(
        FECHA_CORTE,
        lag(FECHA_CORTE),
        units = "mins"
      )
    )
  ) %>%
  count(
    diferencia_minutos,
    sort = TRUE
  )

# ============================================================
# 5. LIMPIEZA Y PREPARACIÓN DE LOS DATOS
# ============================================================

datos_limpios <- datos %>%
  mutate(
    
    # Carbono negro
    BLACK_CARBON = ifelse(
      BLACK_CARBON == -999,
      NA,
      BLACK_CARBON
    ),
    
    # Carbono marrón
    BROWN_CARBON = ifelse(
      BROWN_CARBON < 0,
      NA,
      BROWN_CARBON
    ),
    
    # Spot A
    SPOT_A = ifelse(
      SPOT_A < 0,
      NA,
      SPOT_A
    ),
    
    # Spot B
    SPOT_B = ifelse(
      SPOT_B < 0,
      NA,
      SPOT_B
    ),
    
    # Factor
    FACTOR = ifelse(
      FACTOR == -999,
      NA,
      FACTOR
    ),
    
    # Flujo Spot A
    FLUJO_SPOT_A = ifelse(
      FLUJO_SPOT_A == -999,
      NA,
      FLUJO_SPOT_A
    ),
    
    # Flujo Spot B
    FLUJO_SPOT_B = ifelse(
      FLUJO_SPOT_B == -999,
      NA,
      FLUJO_SPOT_B
    )
  )

datos_limpios <- datos_limpios %>%
  mutate(
    FLUJO_SPOT_B = ifelse(
      FLUJO_SPOT_B < 0,
      NA,
      FLUJO_SPOT_B
    )
  )


# ============================================================
# 6. CREACIÓN DE VARIABLES TEMPORALES
# ============================================================

datos_limpios <- datos_limpios %>%
  mutate(
    año = year(FECHA_CORTE),
    mes = month(FECHA_CORTE),
    mes_nombre = month(
      FECHA_CORTE,
      label = TRUE,
      abbr = FALSE
    ),
    dia = day(FECHA_CORTE),
    hora = hour(FECHA_CORTE),
    dia_semana = wday(
      FECHA_CORTE,
      label = TRUE,
      abbr = FALSE
    )
  )

# ============================================================
# 7. ESTADÍSTICAS DESCRIPTIVAS
# ============================================================

summary(
  datos_limpios %>%
    select(
      BLACK_CARBON,
      BROWN_CARBON,
      SPOT_A,
      SPOT_B,
      FACTOR,
      FLUJO_SPOT_A,
      FLUJO_SPOT_B
    )
)

datos_limpios %>%
  summarise(
    promedio_BC = mean(
      BLACK_CARBON,
      na.rm = TRUE
    ),
    
    mediana_BC = median(
      BLACK_CARBON,
      na.rm = TRUE
    ),
    
    promedio_BrC = mean(
      BROWN_CARBON,
      na.rm = TRUE
    ),
    
    mediana_BrC = median(
      BROWN_CARBON,
      na.rm = TRUE
    )
  )

# ============================================================
# 8. CREACIÓN DE BASE DE DATOS DIARIA
# ============================================================

datos_diarios <- datos_limpios %>%
  mutate(
    fecha = as.Date(FECHA_CORTE)
  ) %>%
  group_by(fecha) %>%
  summarise(
    carbono_negro_promedio = mean(
      BLACK_CARBON,
      na.rm = TRUE
    ),
    
    carbono_marron_promedio = mean(
      BROWN_CARBON,
      na.rm = TRUE
    ),
    
    .groups = "drop"
  )

dim(datos_diarios)

head(datos_diarios)

tail(datos_diarios)

summary(datos_diarios)

datos_diarios %>%
  summarise(
    dias_totales = n(),
    
    dias_con_datos_BC =
      sum(!is.na(carbono_negro_promedio)),
    
    dias_sin_datos_BC =
      sum(is.na(carbono_negro_promedio)),
    
    dias_con_datos_BrC =
      sum(!is.na(carbono_marron_promedio)),
    
    dias_sin_datos_BrC =
      sum(is.na(carbono_marron_promedio))
  )

# ============================================================
# 9. VISUALIZACIÓN DE DATOS
# ============================================================

# ------------------------------------------------------------
# 9.1 Distribución del carbono negro
# ------------------------------------------------------------

grafico_BC <- ggplot(
  datos_limpios,
  aes(x = BLACK_CARBON)
) +
  geom_histogram(
    bins = 50
  ) +
  labs(
    title = "Distribución de la concentración de carbono negro",
    subtitle = "Registros del CEMGEM en Huaytapallana, 2022–2024",
    x = "Concentración de carbono negro (ng/m³)",
    y = "Frecuencia"
  ) +
  theme_minimal()

grafico_BC

ggsave(
  "figures/01_distribucion_carbono_negro.png",
  grafico_BC,
  width = 10,
  height = 6,
  dpi = 300
)

# ------------------------------------------------------------
# 9.2 Distribución del carbono marrón
# ------------------------------------------------------------
grafico_BrC_log <- ggplot(
  datos_limpios,
  aes(x = BROWN_CARBON)
) +
  geom_histogram(
    bins = 50
  ) +
  scale_x_log10() +
  labs(
    title = "Distribución del carbono marrón en escala logarítmica",
    subtitle = "Registros del CEMGEM en Huaytapallana, 2022–2024",
    x = "Concentración de carbono marrón (escala logarítmica)",
    y = "Frecuencia"
  ) +
  theme_minimal()

grafico_BrC_log

ggsave(
  "figures/04_distribucion_carbono_marron_log.png",
  grafico_BrC_log,
  width = 10,
  height = 6,
  dpi = 300
)

# ------------------------------------------------------------
# 9.3 Evolución temporal carbón negro
# ------------------------------------------------------------
grafico_temporal_BC <- ggplot(
  datos_diarios,
  aes(
    x = fecha,
    y = carbono_negro_promedio
  )
) +
  geom_line(
    na.rm = TRUE
  ) +
  labs(
    title = "Evolución temporal del carbono negro",
    subtitle = "Promedios diarios registrados en el CEMGEM, 2022–2024",
    x = "Fecha",
    y = "Carbono negro promedio (ng/m³)"
  ) +
  theme_minimal()

grafico_temporal_BC

ggsave(
  "figures/05_evolucion_carbono_negro.png",
  grafico_temporal_BC,
  width = 10,
  height = 6,
  dpi = 300
)

# ------------------------------------------------------------
# 9.4 Evolución temporal carbón marrón
# ------------------------------------------------------------

grafico_temporal_BrC <- ggplot(
  datos_diarios,
  aes(
    x = fecha,
    y = carbono_marron_promedio
  )
) +
  geom_line(
    na.rm = TRUE
  ) +
  labs(
    title = "Evolución temporal del carbono marrón",
    subtitle = "Promedios diarios registrados en el CEMGEM, 2022–2024",
    x = "Fecha",
    y = "Carbono marrón promedio (ng/m³)"
  ) +
  theme_minimal()

grafico_temporal_BrC

ggsave(
  "figures/06_evolucion_carbono_marron.png",
  grafico_temporal_BrC,
  width = 10,
  height = 6,
  dpi = 300
)
  

getwd()
list.files()
list.files("data")

# ------------------------------------------------------------
# 9.3 Relación entre carbono negro y carbono marrón
# ------------------------------------------------------------

grafico_relacion <- ggplot(
  datos_diarios,
  aes(
    x = carbono_negro_promedio,
    y = carbono_marron_promedio
  )
) +
  geom_point(
    alpha = 0.5,
    na.rm = TRUE
  ) +
  geom_smooth(
    method = "lm",
    se = TRUE,
    na.rm = TRUE
  ) +
  labs(
    title = "Relación entre carbono negro y carbono marrón",
    subtitle = "Promedios diarios registrados en el CEMGEM, 2022–2024",
    x = "Carbono negro promedio (ng/m³)",
    y = "Carbono marrón promedio (ng/m³)"
  ) +
  theme_minimal()

grafico_relacion

ggsave(
  "figures/07_relacion_carbonos.png",
  grafico_relacion,
  width = 10,
  height = 6,
  dpi = 300
)

# ------------------------------------------------------------
# 9.4 Correlación entre carbono negro y carbono marrón
# ------------------------------------------------------------

correlacion_BC_BrC <- cor(
  datos_diarios$carbono_negro_promedio,
  datos_diarios$carbono_marron_promedio,
  use = "complete.obs"
)

correlacion_BC_BrC

cat(
  "Correlación entre carbono negro y carbono marrón:",
  round(correlacion_BC_BrC, 3)
)

# ------------------------------------------------------------
# 9.5 Análisis de valores extremos
# ------------------------------------------------------------

umbral_BrC <- quantile(
  datos_diarios$carbono_marron_promedio,
  0.99,
  na.rm = TRUE
)

umbral_BrC



datos_diarios_sin_extremos <- datos_diarios %>%
  filter(
    carbono_marron_promedio <= umbral_BrC
  )

correlacion_sin_extremos <- cor(
  datos_diarios_sin_extremos$carbono_negro_promedio,
  datos_diarios_sin_extremos$carbono_marron_promedio,
  use = "complete.obs"
)

correlacion_sin_extremos




tabla_correlaciones <- tibble(
  escenario = c(
    "Todos los datos",
    "Sin el 1% superior de BrC"
  ),
  
  correlacion = c(
    correlacion_BC_BrC,
    correlacion_sin_extremos
  )
)

tabla_correlaciones



# ------------------------------------------------------------
# 9.6 Clasificación de días según nivel de carbono negro
# ------------------------------------------------------------

datos_grupos <- datos_diarios %>%
  filter(
    !is.na(carbono_negro_promedio)
  ) %>%
  mutate(
    grupo_BC = ntile(
      carbono_negro_promedio,
      3
    ),
    
    grupo_BC = case_when(
      grupo_BC == 1 ~ "Bajo",
      grupo_BC == 2 ~ "Medio",
      grupo_BC == 3 ~ "Alto"
    )
  )


tabla_grupos <- datos_grupos %>%
  group_by(grupo_BC) %>%
  summarise(
    dias = n(),
    promedio_BC = mean(
      carbono_negro_promedio,
      na.rm = TRUE
    ),
    promedio_BrC = mean(
      carbono_marron_promedio,
      na.rm = TRUE
    ),
    .groups = "drop"
  )

tabla_grupos


# ------------------------------------------------------------
# 9.7 Gráfico final del EDA: carbono marrón por nivel de carbono negro
# ------------------------------------------------------------


grafico_grupos <- ggplot(
  datos_grupos,
  aes(
    x = grupo_BC,
    y = carbono_marron_promedio
  )
) +
  geom_boxplot(
    na.rm = TRUE
  ) +
  labs(
    title = "Concentración de carbono marrón según nivel de carbono negro",
    subtitle = "Comparación de los promedios diarios registrados en el CEMGEM, 2022–2024",
    x = "Nivel de carbono negro",
    y = "Carbono marrón promedio (ng/m³)"
  ) +
  theme_minimal()

grafico_grupos



ggsave(
  "figures/08_carbono_marron_por_nivel_BC.png",
  grafico_grupos,
  width = 10,
  height = 6,
  dpi = 300
)


# ------------------------------------------------------------
# 9.8 Promedio de carbono marrón según nivel de carbono negro
# ------------------------------------------------------------

grafico_promedios <- ggplot(
  tabla_grupos,
  aes(
    x = grupo_BC,
    y = promedio_BrC
  )
) +
  geom_col() +
  geom_text(
    aes(
      label = round(promedio_BrC, 1)
    ),
    vjust = -0.5
  ) +
  labs(
    title = "Promedio diario de carbono marrón según nivel de carbono negro",
    subtitle = "CEMGEM - Huaytapallana, 2022–2024",
    x = "Nivel de carbono negro",
    y = "Carbono marrón promedio (ng/m³)"
  ) +
  theme_minimal()

grafico_promedios



ggsave(
  "figures/09_promedio_BrC_por_nivel_BC.png",
  grafico_promedios,
  width = 10,
  height = 6,
  dpi = 300
)



write_csv(
  tabla_grupos,
  "figures/tabla_grupos_BC_BrC.csv"
)



# ============================================================
# 10. RESUMEN DE PRINCIPALES HALLAZGOS
# ============================================================

cat(
  "\n================ PRINCIPALES HALLAZGOS ================\n"
)

cat(
  "\nNúmero total de días:",
  nrow(datos_diarios)
)

cat(
  "\nDías con datos válidos:",
  sum(!is.na(datos_diarios$carbono_negro_promedio))
)

cat(
  "\nDías sin datos válidos:",
  sum(is.na(datos_diarios$carbono_negro_promedio))
)

cat(
  "\nPromedio general de carbono negro:",
  round(
    mean(
      datos_diarios$carbono_negro_promedio,
      na.rm = TRUE
    ),
    2
  )
)

cat(
  "\nPromedio general de carbono marrón:",
  round(
    mean(
      datos_diarios$carbono_marron_promedio,
      na.rm = TRUE
    ),
    2
  )
)

cat(
  "\nCorrelación BC-BrC:",
  round(
    correlacion_BC_BrC,
    3
  )
)

cat(
  "\nCorrelación sin el 1% superior de BrC:",
  round(
    correlacion_sin_extremos,
    3
  )
)

cat(
  "\n=========================================================\n"
)







list.files("figures")


# ============================================================
# 12. CREACIÓN DEL COLLAGE DE GRÁFICOS
# ============================================================

collage_graficos <-
  grafico_BC +
  grafico_temporal_BC +
  grafico_relacion +
  grafico_promedios +
  plot_layout(
    ncol = 2
  )

collage_graficos


ggsave(
  "figures/collage_graficos.png",
  collage_graficos,
  width = 14,
  height = 10,
  dpi = 300
)

list.files("figures")
#[1] "01_distribucion_carbono_negro.png"     
#[2] "04_distribucion_carbono_marron_log.png"
#[3] "05_evolucion_carbono_negro.png"        
#[4] "06_evolucion_carbono_marron.png"       
#[5] "07_relacion_carbonos.png"              
#[6] "08_carbono_marron_por_nivel_BC.png"    
#[7] "09_promedio_BrC_por_nivel_BC.png"      
#[8] "collage_graficos.png"                  
#[9] "tabla_grupos_BC_BrC.csv"
