# ============================================================
# PROYECTO FINAL - ANÁLISIS FINAL
# ============================================================
#
# Pregunta de análisis:
#
# ¿Los días con mayores concentraciones promedio de carbono
# negro también presentan mayores concentraciones promedio
# de carbono marrón en Huaytapallana durante 2022-2024?
#
# Fuente:
# Plataforma Nacional de Datos Abiertos 
# DATATÓN
#
# Lugar:
# Centro de Monitoreo de Glaciares y Ecosistemas de Montaña
# (CEMGEM) - Huancayo, Junín
#
# ============================================================
# ============================================================
# 1. CARGA DE PAQUETES
# ============================================================

library(tidyverse)
library(lubridate)
library(ggplot2)
# ============================================================
# 2. IMPORTACIÓN DE DATOS
# ============================================================

datos <- read_csv(
  "data/datos_carbono_negro.csv"
)
# ============================================================
# 3. LIMPIEZA DE DATOS
# ============================================================

datos_limpios <- datos %>%
  mutate(
    BLACK_CARBON = ifelse(
      BLACK_CARBON == -999,
      NA,
      BLACK_CARBON
    ),
    
    BROWN_CARBON = ifelse(
      BROWN_CARBON < 0,
      NA,
      BROWN_CARBON
    ),
    
    SPOT_A = ifelse(
      SPOT_A < 0,
      NA,
      SPOT_A
    ),
    
    SPOT_B = ifelse(
      SPOT_B < 0,
      NA,
      SPOT_B
    ),
    
    FACTOR = ifelse(
      FACTOR == -999,
      NA,
      FACTOR
    ),
    
    FLUJO_SPOT_A = ifelse(
      FLUJO_SPOT_A == -999,
      NA,
      FLUJO_SPOT_A
    ),
    
    FLUJO_SPOT_B = ifelse(
      FLUJO_SPOT_B == -999,
      NA,
      FLUJO_SPOT_B
    ),
    
    FLUJO_SPOT_B = ifelse(
      FLUJO_SPOT_B < 0,
      NA,
      FLUJO_SPOT_B
    )
  )

# ============================================================
# 4. CONSTRUCCIÓN DE LA BASE DIARIA
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


# ============================================================
# 5. CLASIFICACIÓN DE LOS DÍAS SEGÚN NIVEL DE CARBONO NEGRO
# ============================================================

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

# ============================================================
# 6. COMPARACIÓN ENTRE GRUPOS
# ============================================================

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
    
    mediana_BrC = median(
      carbono_marron_promedio,
      na.rm = TRUE
    ),
    
    .groups = "drop"
  )

tabla_grupos

# ============================================================
# 7. DIFERENCIA ENTRE LOS GRUPOS EXTREMOS
# ============================================================

promedio_BrC_bajo <- tabla_grupos %>%
  filter(
    grupo_BC == "Bajo"
  ) %>%
  pull(
    promedio_BrC
  )

promedio_BrC_alto <- tabla_grupos %>%
  filter(
    grupo_BC == "Alto"
  ) %>%
  pull(
    promedio_BrC
  )

diferencia_BrC <- 
  promedio_BrC_alto -
  promedio_BrC_bajo

incremento_porcentual <- 
  (diferencia_BrC /
     promedio_BrC_bajo) * 100

cat(
  "Diferencia promedio de BrC entre grupos Alto y Bajo:",
  round(diferencia_BrC, 1),
  "ng/m³\n"
)

cat(
  "Incremento porcentual del BrC:",
  round(incremento_porcentual, 1),
  "%\n"
)


# ============================================================
# 7. DIFERENCIA ENTRE LOS GRUPOS EXTREMOS
# ============================================================

promedio_BrC_bajo <- tabla_grupos %>%
  filter(
    grupo_BC == "Bajo"
  ) %>%
  pull(
    promedio_BrC
  )

promedio_BrC_alto <- tabla_grupos %>%
  filter(
    grupo_BC == "Alto"
  ) %>%
  pull(
    promedio_BrC
  )

diferencia_BrC <- 
  promedio_BrC_alto -
  promedio_BrC_bajo

incremento_porcentual <- 
  (diferencia_BrC /
     promedio_BrC_bajo) * 100

cat(
  "Diferencia promedio de BrC entre grupos Alto y Bajo:",
  round(diferencia_BrC, 1),
  "ng/m³\n"
)

cat(
  "Incremento porcentual del BrC:",
  round(incremento_porcentual, 1),
  "%\n"
)


# ============================================================
# 9. EXPORTACIÓN DEL GRÁFICO FINAL
# ============================================================

ggsave(
  "figures/grafico_final_analisis.png",
  grafico_final,
  width = 10,
  height = 6,
  dpi = 300
)


# ============================================================
# 10. CORRELACIÓN
# ============================================================

correlacion_BC_BrC <- cor(
  datos_diarios$carbono_negro_promedio,
  datos_diarios$carbono_marron_promedio,
  use = "complete.obs"
)

cat(
  "Correlación entre carbono negro y carbono marrón:",
  round(
    correlacion_BC_BrC,
    3
  )
)


#r = 0.453


# ============================================================
# 11. CONCLUSIONES
# ============================================================

cat(
  "\nCONCLUSIONES DEL ANÁLISIS\n"
)

cat(
  "\n1. Los días clasificados con niveles altos de carbono negro"
)

cat(
  " presentaron un promedio de carbono marrón superior"
)

cat(
  " al observado en los días clasificados con niveles bajos."
)

cat(
  "\n2. El carbono marrón promedio pasó de aproximadamente"
)

cat(
  " 141 ng/m³ en el grupo bajo a 351 ng/m³ en el grupo alto."
)

cat(
  "\n3. La diferencia entre ambos grupos fue de aproximadamente"
)

cat(
  " 210 ng/m³."
)

cat(
  "\n4. La correlación de 0.453 muestra una asociación positiva"
)

cat(
  " moderada entre ambas variables."
)

cat(
  "\n5. Los resultados muestran una asociación descriptiva y"
)

cat(
  " no permiten establecer una relación causal entre"
)

cat(
  " el carbono negro y el carbono marrón."
)



