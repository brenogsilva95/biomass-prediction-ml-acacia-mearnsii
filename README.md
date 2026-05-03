# biomass-prediction-ml-acacia-mearnsii
End-to-end machine learning pipeline for biomass prediction in Acacia mearnsii using regression, tree-based models, and hyperparameter tuning with tidymodels.

# Machine Learning for Biomass Prediction in Acacia mearnsii

## Overview

Accurate biomass estimation is essential for sustainable forest management, carbon stock assessment, and industrial applications. Traditional empirical models rely on dendrometric variables such as diameter at breast height (DBH) and tree height, but may fail to capture nonlinear relationships.

This project presents a **reproducible machine learning pipeline** for biomass prediction in *Acacia mearnsii*, comparing classical statistical models and modern machine learning algorithms.

---

## Dataset

The dataset consists of forest inventory data collected in Rio Grande do Sul (Brazil), including:

- Diameter at Breast Height (DBH)
- Total height ($h$)
- Biomass ($bt$)
- Location (Cristal, Encruzilhada do Sul, Piratini)

The data were split into:
- **80% training set**
- **20% testing set**

---

## Problem Formulation

We model biomass prediction as a supervised learning problem:

$$
\hat{Y} = f(X)
$$

where:

- $X$ represents the input variables (DBH, height, etc.)
- $Y$ represents the observed biomass
- $\hat{Y}$ represents the predicted biomass

---

## Models Implemented

### Linear Models
- Linear Regression
- Lasso Regression (regularization)

### Tree-Based Models
- Decision Tree
- Random Forest
- XGBoost

These models allow comparison between:
- Interpretability (linear models)
- Predictive performance (machine learning models)

---

## Modeling Pipeline

The workflow was implemented using **tidymodels**, including:

- Data preprocessing (`recipe`)
- Train/test split
- Cross-validation (5-fold)
- Hyperparameter tuning (XGBoost)
- Parallel processing

---

## Evaluation Metrics

### RMSE

$$
RMSE = \sqrt{\frac{1}{N}\sum_{i=1}^{N}(y_i - \hat{y}_i)^2}
$$

### R²

$$
R^2 = 1 - \frac{\sum_{i=1}^{N}(y_i - \hat{y}_i)^2}{\sum_{i=1}^{N}(y_i - \bar{y})^2}
$$

---

## Results

| Model              | RMSE | R²   |
|-------------------|------|------|
| Linear Regression | 20.80| 0.87 |
| Lasso             | 21.50| 0.86 |
| Decision Tree     | 19.50| 0.90 |
| Random Forest     | 20.70| 0.88 |
| XGBoost           | **15.70** | **0.93** |

### Key Insights

- DBH is the most important predictor of biomass
- Tree-based models outperform linear models
- XGBoost achieved the best predictive performance
- Nonlinear relationships are crucial in forest modeling

---

## Visualization

Model comparison plots (Observed vs Predicted) show:

- XGBoost predictions closest to the ideal line
- Random Forest with strong performance
- Linear models underestimating higher biomass values

---

## Tech Stack

- R
- tidymodels
- glmnet
- rpart
- randomForest
- xgboost
- doParallel

---

## Reproducibility

- Fixed seeds (`set.seed`)
- Structured pipeline
- Cross-validation
- Hyperparameter tuning

---

## Conclusion

This project demonstrates that machine learning significantly improves biomass prediction in forest data.

Tree-based models, especially XGBoost, are more effective at capturing nonlinear relationships and variability, outperforming traditional statistical approaches.

Additionally, this work provides a **tutorial-driven and reproducible framework**, enabling practitioners to apply machine learning in forest biometrics.

---

## Author

Breno Gabriel da Silva  
USP / ESALQ – Data Science & Analytics

---

## Citation

If you use this work, please cite:

Silva, B. G. (2025).  
Machine learning models applied to biomass prediction in *Acacia mearnsii*.

## References

- Batista, JLF. 2014. Biometria florestal segundo o axioma da verossimilhança com aplicações em mensuração florestal. Universidade de São Paulo-USP, Piracicaba-SP.
- Behling, A., Péllico Netto, S., Sanquetta, C. R., Corte, A. P. D., Simon, A. A., Rodrigues, A. L., and Caron, B. O. (2019). Additive and non-additive biomass equations for black wattle. Floresta e Ambiente, 26:e20170439.
- Boehmke, B., & Greenwell, B. M. (2019). Hands-on machine learning with R. Chapman and Hall/CRC.
- Breiman, L. (2001). Random forests. Machine learning, 45, 5-32.
- Chan, J. M., Day, P., Feely, J., Thompson, R., Little, K. M., and Norris, C. H. (2015). Acacia     mearnsii industry overview: current status, key research and development issues. Southern Forests: a Journal of Forest Science, 77(1):19–30.
- Chen, L., Ren, C., Zhang, B., Wang, Z., & Xi, Y. (2018). Estimation of forest above-ground biomass by geographically weighted regression and machine learning with sentinel imagery. Forests, 9(10), 582.
- Demétrio, C. G., Hinde, J., e Moral, R. A. (2014). Models for overdispersed data in entomology. Ecological modelling applied to entomology, pages 219–259. 
- de Plácido, A. C., Bartoszeck, S., do Amaral Machado, S., Filho, A. F., & de Oliveira, E. B. (2002). Modelagem da relação hipsométrica para bracatingais da região metropolitana de Curitiba-PR. Floresta, 32(2), 189-204.
- de São José, J. F. B., Hernandes, M. A. S., Volpiano, C. G., Lisboa, B. B., Beneduzi, A., Bayer, C., Simon, A. A., de Oliveira, J., Passaglia, L. M. P., and Vargas, L. K. (2023). Diversity of rhizobia, symbiotic effectiveness, and potential of inoculation in acacia mearnsii seedling production. Brazilian Journal of Microbiology, 54(1):335–348.
- Fatoretto, M. B., Moral, R. d. A., Demétrio, C. G. B., de Pádua, C. S., Menarin, V., Rojas, V. M. A., D’Alessandro, C. P., e Delalibera Jr, I. (2018). Overdispersed fungus germination data: statistical analysis using r. - Biocontrol Science and Technology, 28(11):1034–1053.
- Finger, C. A. G. (1992). Fundamentos de biometria florestal.
- Friedman, J. H. (2001). Greedy function approximation: a gradient boosting machine. Annals of statistics, 1189-1232.
- García-Gutiérrez, J., Martínez-Álvarez, F., Troncoso, A., & Riquelme, J. C. (2015). A comparison of machine learning regression techniques for LiDAR-derived estimation of forest variables. Neurocomputing, 167, 24-31.
- Géron, A. (2022). Hands-on machine learning with Scikit-Learn, Keras, and TensorFlow. " O'Reilly Media, Inc.".
- Hoerl, A. E., & Kennard, R. W. (1970). Ridge regression: Biased estimation for nonorthogonal problems. Technometrics, 12(1), 55-67.
- IBÁ, R. 2024. Indústria Brasileira de Árvores-IBÁ. São Paulo. 99 p.
- Izbicki, R., & dos Santos, T. M. (2020). Aprendizado de máquina: uma abordagem estatística. 
- James, G., Witten, D., Hastie, T., & Tibshirani, R. (2013). An introduction to statistical learning (Vol. 112, p. 18). New York: springer.
- Koehler, H. S., Watzlawick, L. F., & Kirchner, F. F. (2002). Fontes e níveis de erros nas estimativas do potencial de fixação de carbono. As florestas e o carbono. Curitiba: Imprensa Universitária da UFPR, 251-264.
- Maestri, R., Sanquetta, C. R., Machado, S. A., Scolforo, J. R. S., & CORTE, A. (2004). Viabilidade de um projeto florestal de Eucalyptus grandis considerando o seqüestro de carbono. Floresta, 34(3), 347-360.
- Monteiro, P. H. R., Kaschuk, G., Winagraski, E., Auer, C. G., and Higa, A. R. (2019). Rhizobial inoculation in black wattle plantation (acacia mearnsii de wild.) in production systems of southern brazil. Brazilian Journal of Microbiology, 50:989–998.
- Moral, R.A., J. Hinde, and C.G. Demétrio. 2017. Half-normal plots and overdispersed models in R: the hnp package. Journal of Statistical Software, 81(1):1–23. 
- Moral, R. A., Hinde, J., e Demétrio, C. G. (2020). Bivariate residual plots with simulation polygons. Journal of Computational and Graphical Statistics, 29(1):203–214. 
- R Core Team. (2021). R: A Language and Environment for Statistical Computing. R Foundation for Statistical Computing, Vienna, Austria.
- Sanquetta, C., Behling, A., Corte, A. D., Simon, A., Pscheidt, H., Ruza, M. S., and Mochiutti, S. (2014). Estoques de biomassa e carbono em povoamentos de acácia negra em diferentes idades no rio grande do sul.
- Shataee, S., Kalbi, S., Fallah, A., & Pelz, D. (2012). Forest attribute imputation using machine-learning methods and ASTER data: comparison of k-NN, SVR and random forest regression algorithms. International journal of remote sensing, 33(19), 6254-6280.
- Silva, J. P. M., da Silva, M. L. M., de Mendonça, A. R., da Silva, G. F., de Barros Junior, A. A., da Silva, E. F., ... & Rodrigues, N. M. M. (2023). Prognosis of forest production using machine learning techniques. Information Processing in Agriculture, 10(1), 71-84.
- Vanclay, J. K. (1994). Modelling forest growth and yield: applications to mixed tropical forests.
- Zhao, Q., Yu, S., Zhao, F., Tian, L., & Zhao, Z. (2019). Comparison of machine learning algorithms for forest parameter estimations and application for forest quality assessments. Forest Ecology and Management, 434, 224-234.
