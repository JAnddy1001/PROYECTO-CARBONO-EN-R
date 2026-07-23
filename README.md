# Análisis Exploratorio de Datos de Carbono Negro y Carbono Marrón

## 1. Descripción del proyecto

El presente proyecto desarrolla un Análisis Exploratorio de Datos (EDA) utilizando R y el paquete ggplot2, aplicado a información sobre carbono negro y carbono marrón registrada en la Cordillera Huaytapallana, en el Centro de Monitoreo de Glaciares y Ecosistemas de Montaña (CEMGEM), ubicado en Huancayo, Junín.

El objetivo principal es explorar las características de los datos, identificar posibles problemas de calidad, obtener estadísticas descriptivas, analizar su comportamiento temporal y visualizar la relación entre las principales variables de interés.

El análisis fue desarrollado como parte del proyecto final del curso de R Studio.

---

## 2. Fuente de datos

Los datos utilizados provienen de la Plataforma Nacional de Datos Abiertos del Estado Peruano.

El conjunto de datos corresponde a:

"Datos de carbono negro en la cordillera Huaytapalla en el Centro de Monitoreo de Glaciares y Ecosistemas de Montaña (CEMGEM) Huancayo, Junín".

La información fue generada mediante un equipo de monitoreo denominado Aethalómetro, marca Magee Scientific Corporation, modelo AE33.

El periodo analizado comprende desde mayo de 2022 hasta abril de 2024, con registros de frecuencia horaria.

---

## 3. Contexto del conjunto de datos

El carbono negro y el carbono marrón forman parte de los componentes asociados al material particulado atmosférico y pueden estar relacionados con procesos de combustión y otras fuentes de emisiones.

La base de datos utilizada contiene registros obtenidos mediante monitoreo instrumental en la zona de la Cordillera Huaytapallana.

El conjunto original contiene más de un millón de observaciones y 16 variables. Para el análisis exploratorio se seleccionaron principalmente las variables relacionadas con las mediciones de carbono negro, carbono marrón y otras variables instrumentales.

---

## 4. Variables analizadas

Las principales variables consideradas en el análisis fueron:

- `FECHA_CORTE`: fecha y hora del registro de medición.
- `BLACK_CARBON`: medición de carbono negro.
- `BROWN_CARBON`: medición de carbono marrón.
- `SPOT_A`: variable asociada al canal A del equipo de medición.
- `SPOT_B`: variable asociada al canal B del equipo de medición.
- `FACTOR`: factor asociado al registro instrumental.
- `FLUJO_SPOT_A`: flujo correspondiente al canal A.
- `FLUJO_SPOT_B`: flujo correspondiente al canal B.

Las variables de ubicación y características del equipo también fueron revisadas durante la exploración inicial de la base.

---

## 5. Importación y limpieza de datos

La base de datos fue importada en R mediante la función `read_csv()` del paquete `tidyverse`.

Durante la revisión inicial se identificó que la base no presentaba valores `NA` originalmente. Sin embargo, se encontraron valores negativos utilizados como códigos o valores no válidos para algunas variables.

En particular, se identificó el valor `-999` en varias variables numéricas. Estos valores fueron tratados como datos faltantes y transformados en `NA`.

Asimismo, se revisaron valores negativos en las variables de carbono marrón y las variables SPOT, los cuales fueron considerados no válidos para el análisis descriptivo.

Posteriormente, se verificó la existencia de registros duplicados y se revisó la frecuencia temporal de las observaciones.

Los registros presentaron una frecuencia aproximada de un minuto entre observaciones consecutivas.

---

## 6. Construcción de la base diaria

Debido al elevado número de observaciones de frecuencia horaria, se realizó una agregación temporal de los datos.

Se construyó una nueva base denominada `datos_diarios`, en la cual se calculó el promedio diario de:

- Carbono negro.
- Carbono marrón.

La base diaria resultante contiene 729 días entre el 1 de mayo de 2022 y el 28 de abril de 2024.

De los 729 días, 681 presentaron información válida para el cálculo de los promedios de carbono negro y carbono marrón, mientras que 48 días no presentaron datos válidos para estas variables.

---

## 7. Análisis exploratorio de datos

El análisis exploratorio permitió estudiar:

- La distribución de las concentraciones de carbono negro.
- La distribución del carbono marrón.
- La evolución temporal de ambas variables.
- La relación entre carbono negro y carbono marrón.
- La presencia de valores extremos.
- La disponibilidad de información a nivel diario.

Se utilizaron gráficos elaborados mediante el paquete `ggplot2`.

---

## 8. Principales hallazgos del EDA

El análisis descriptivo de la base diaria mostró que el promedio del carbono negro fue aproximadamente de 35.5, mientras que el promedio del carbono marrón fue aproximadamente de 247.2.

La mediana del carbono negro fue de aproximadamente 32.4 y la mediana del carbono marrón fue de aproximadamente 194.5.

Se identificaron 48 días sin información válida para ambas variables en la base diaria.

También se identificaron valores elevados de carbono marrón en determinados días. El valor promedio diario máximo observado fue de aproximadamente 1462.3.

En el caso del carbono negro, el promedio diario máximo observado fue de aproximadamente 89.7.

La correlación entre los promedios diarios de carbono negro y carbono marrón fue aproximadamente de 0.453, lo que representa una asociación positiva moderada entre ambas variables.

---

## 9. Pregunta de análisis

A partir de los resultados encontrados durante el análisis exploratorio, se formuló la siguiente pregunta:

> ¿Los días con mayores concentraciones promedio de carbono negro también presentan mayores concentraciones promedio de carbono marrón en Huaytapallana durante 2022–2024?

Para responder esta pregunta, los días con información válida de carbono negro fueron clasificados en tres grupos relativos:

- Bajo.
- Medio.
- Alto.

La clasificación se realizó mediante terciles utilizando la función `ntile()`.

Es importante señalar que estos grupos representan una clasificación relativa de los días observados y no corresponden a límites normativos o estándares de calidad ambiental.

---

## 10. Análisis final

Los resultados obtenidos fueron los siguientes:

| Nivel de carbono negro | Número de días | Promedio de carbono negro | Promedio de carbono marrón |
|---|---:|---:|---:|
| Bajo | 227 | 18.6 | 141 |
| Medio | 227 | 32.9 | 249 |
| Alto | 227 | 55.0 | 351 |

Los resultados muestran que los días clasificados con niveles altos de carbono negro presentaron, en promedio, mayores concentraciones de carbono marrón.

El promedio de carbono marrón pasó de aproximadamente 141 ng/m³ en el grupo bajo a aproximadamente 351 ng/m³ en el grupo alto.

La diferencia entre ambos grupos fue de aproximadamente 210 ng/m³.

La correlación entre ambas variables fue de aproximadamente 0.453.

Estos resultados muestran una asociación descriptiva positiva entre las dos variables analizadas.

---

## 11. Principales conclusiones

1. El análisis exploratorio permitió identificar patrones temporales y diferencias importantes en los niveles de carbono negro y carbono marrón registrados en la Cordillera Huaytapallana durante el periodo 2022–2024.

2. La base original presentó más de un millón de registros y una frecuencia temporal aproximada de un minuto. Para facilitar el análisis exploratorio, los datos fueron agregados a una frecuencia diaria.

3. Se identificaron 48 días sin información válida para las variables de carbono negro y carbono marrón, por lo que estos valores fueron considerados durante la interpretación de los resultados.

4. Los días clasificados con niveles altos de carbono negro presentaron un promedio de carbono marrón mayor que los días clasificados con niveles bajos.

5. El promedio diario de carbono marrón fue de aproximadamente 141 ng/m³ en el grupo bajo de carbono negro y de aproximadamente 351 ng/m³ en el grupo alto.

6. La correlación de 0.453 indica una asociación positiva moderada entre las concentraciones promedio diarias de carbono negro y carbono marrón.

7. Los resultados permiten identificar una relación descriptiva entre ambas variables, pero no permiten afirmar la existencia de una relación causal.

---

## 12. Visualizaciones

Los principales gráficos elaborados durante el análisis exploratorio se encuentran disponibles en la carpeta `figures/`.

Entre las principales visualizaciones se incluyen:

- Distribución del carbono negro.
- Distribución del carbono marrón.
- Evolución temporal del carbono negro.
- Evolución temporal del carbono marrón.
- Relación entre carbono negro y carbono marrón.
- Promedio de carbono marrón según nivel de carbono negro.

El gráfico principal del análisis final muestra la comparación del promedio de carbono marrón entre los grupos de días clasificados según su nivel relativo de carbono negro.

---

## 13. Estructura del repositorio

El proyecto se organiza de la siguiente manera:

```text
Proyecto_Final/
│
├── data/
│   ├── datos_carbono_negro.csv
│   └── Formato_Metadatos_CarbonoNegro_0.docx
│
├── figures/
│   ├── collage_graficos.png
│   ├── grafico_final_analisis.png
│   └── otros gráficos generados durante el análisis
│
├── scripts/
│   ├── EDA.R
│   └── 04_analisis_final.R
│   
└── README.md
