############################################################################
################################## Pacotes #################################
############################################################################
library(dplyr)
library(rlang)
library(cli)
library(vctrs)
library(tibble)
library(tidyverse)
library(glmnet)
library(randomForest)
library(xgboost)
library(patchwork)
library(tidyverse)
library(paletteer)
library(statip)
library(summarytools)
library(ggplot2)
library(yardstick)
library(recipes)
library(tidymodels)
#####################################################################################
########################## Leitura do Banco de Dados ################################
#####################################################################################
biomass = read.table("df_mba.csv", header = T, sep=";", dec = ",")
str(biomass)
#####################################################################################
######################### Organizando as Variáveis ##################################
#####################################################################################
biomass$Parcela=as.factor(biomass$Parcela)
biomass$Local=as.factor(biomass$Local)
#####################################################################################
######################### Gráfico de Correlação #####################################
#####################################################################################
biomass2 = biomass[,c(1,5,6,10)];head(biomass2)
x11()
p <- ggpairs(biomass2, aes(color = Local))
for(i in 1:p$nrow) {
  for(j in 1:p$ncol){
    p[i,j] <- p[i,j] + 
      scale_fill_manual(values=c("#00AFBB", "#E7B800", "#FC4E07")) +
      scale_color_manual(values=c("#00AFBB", "#E7B800", "#FC4E07"))  
  }
}
p
#####################################################################################
######################### Gráfico de Dispersão ######################################
#####################################################################################
p1=ggplot(biomass, aes(x = dap, y = bt, color=Parcela)) +
  geom_point(size=2)+
  labs(x = 'DAP (cm)', y = expression(Biomassa~(kg))) + 
  theme(legend.title = element_text(size = 15),
        legend.text = element_text(size = 17),
        axis.title = element_text(size = 22),
        axis.text.x = element_text(color = "black", hjust=1),
        axis.text.y = element_text(color = "black", hjust=1),
        axis.text = element_text(size = 25),
        plot.title = element_text(size = 22),
        strip.text.x = element_text(size = 18)) + facet_wrap(~Local)
Graph1=p1+scale_color_manual(values=c("#FEB24C","#FD8D3C","#FC4E2A","#E31A1C",
                                      "#7FCDBB","#41B6C4","#1D91C0","#225EA8",
                                      "#BCBDDC","#9E9AC8","#807DBA","#6A51A3"),
                             name = "Parcelas", labels = c("1", "2", "3",
                                                           "4", "5", "6",
                                                           "7", "8", "9",
                                                           "10", "11", "12")) 

p2=ggplot(biomass, aes(x = h, y = bt, color=Parcela)) +
  geom_point(size=2)+
  labs(x = 'Altura (m)', y = expression(Biomassa~(kg))) + 
  theme(legend.title = element_text(size = 15),
        legend.text = element_text(size = 17),
        axis.title = element_text(size = 22),
        axis.text.x = element_text(color = "black", hjust=1),
        axis.text.y = element_text(color = "black", hjust=1),
        axis.text = element_text(size = 25),
        plot.title = element_text(size = 22),
        strip.text.x = element_text(size = 18)) + facet_wrap(~Local)
Graph2=p2+scale_color_manual(values=c("#FEB24C","#FD8D3C","#FC4E2A","#E31A1C",
                                      "#7FCDBB","#41B6C4","#1D91C0","#225EA8",
                                      "#BCBDDC","#9E9AC8","#807DBA","#6A51A3"),
                             name = "Parcelas", labels = c("1", "2", "3",
                                                           "4", "5", "6",
                                                           "7", "8", "9",
                                                           "10", "11", "12")) 

p3=ggplot(biomass, aes(x = h, y = cc, color=Parcela)) +
  geom_point(size=2)+
  labs(x = 'Comprimento de Copa (m)', y = expression(Biomassa~(kg))) + 
  theme(legend.title = element_text(size = 15),
        legend.text = element_text(size = 17),
        axis.title = element_text(size = 22),
        axis.text.x = element_text(color = "black", hjust=1),
        axis.text.y = element_text(color = "black", hjust=1),
        axis.text = element_text(size = 25),
        plot.title = element_text(size = 22),
        strip.text.x = element_text(size = 18)) + facet_wrap(~Local)
Graph3=p3+scale_color_manual(values=c("#FEB24C","#FD8D3C","#FC4E2A","#E31A1C",
                                      "#7FCDBB","#41B6C4","#1D91C0","#225EA8",
                                      "#BCBDDC","#9E9AC8","#807DBA","#6A51A3"),
                             name = "Parcelas", labels = c("1", "2", "3",
                                                           "4", "5", "6",
                                                           "7", "8", "9",
                                                           "10", "11", "12")) 

p4=ggplot(biomass, aes(x = log(dap), y = log(h), color=Parcela)) +
  geom_point(size=2)+
  labs(x = 'Diâmetro', y = 'Altura') + 
  theme(legend.title = element_text(size = 15),
        legend.text = element_text(size = 17),
        axis.title = element_text(size = 22),
        axis.text.x = element_text(color = "black", hjust=1),
        axis.text.y = element_text(color = "black", hjust=1),
        axis.text = element_text(size = 25),
        plot.title = element_text(size = 22),
        strip.text.x = element_text(size = 18)) + facet_wrap(~Local)
Graph4=p4+scale_color_manual(values=c("#FEB24C","#FD8D3C","#FC4E2A","#E31A1C",
                                      "#7FCDBB","#41B6C4","#1D91C0","#225EA8",
                                      "#BCBDDC","#9E9AC8","#807DBA","#6A51A3"),
                             name = "Parcelas", labels = c("1", "2", "3",
                                                           "4", "5", "6",
                                                           "7", "8", "9",
                                                           "10", "11", "12")) 
x11()
grid.arrange(Graph1,Graph2, nrow = 2)
#####################################################################################
################################ Histogramas - Gerais ###############################
#####################################################################################
HistA = ggplot(biomass, aes(x = bt)) +
  geom_histogram(color = "white", fill = "#225EA8",binwidth=40) +
  labs(x = expression(Biomassa~(kg)),
       y = 'Frequência') +
  theme(legend.title = element_text(size = 15),
        legend.text = element_text(size = 17),
        axis.title = element_text(size = 22),
        axis.text.x = element_text(color = "black", hjust=1),
        axis.text.y = element_text(color = "black", hjust=1),
        axis.text = element_text(size = 15),
        strip.text.x = element_text(size = 18))
HistB = ggplot(biomass, aes(x = h)) +
  geom_histogram(color = "white", fill = "#225EA8",binwidth=2.44) +
  labs(x = 'Altura (m)',
       y = 'Frequência') +
  theme(legend.title = element_text(size = 15),
        legend.text = element_text(size = 17),
        axis.title = element_text(size = 22),
        axis.text.x = element_text(color = "black", hjust=1),
        axis.text.y = element_text(color = "black", hjust=1),
        axis.text = element_text(size = 15),
        strip.text.x = element_text(size = 18))
HistC = ggplot(biomass, aes(x = dap)) +
  geom_histogram(color = "white", fill = "#225EA8",binwidth=2.84) +
  labs(x = 'DAP (cm)',
       y = 'Frequência') +
  theme(legend.title = element_text(size = 15),
        legend.text = element_text(size = 17),
        axis.title = element_text(size = 22),
        axis.text.x = element_text(color = "black", hjust=1),
        axis.text.y = element_text(color = "black", hjust=1),
        axis.text = element_text(size = 15),
        strip.text.x = element_text(size = 18))
x11()
grid.arrange(HistA,HistB,HistC, ncol = 3)
#####################################################################################
################################ Histogramas - Por Local ############################
#####################################################################################
Hist1 = ggplot(biomass, aes(x = bt)) +
  geom_histogram(color = "white", fill = "#225EA8",binwidth=40) +
  labs(x = expression(Biomassa~(kg)),
       y = 'Frequência') +
  theme(legend.title = element_text(size = 15),
        legend.text = element_text(size = 17),
        axis.title = element_text(size = 22),
        axis.text.x = element_text(color = "black", hjust=1),
        axis.text.y = element_text(color = "black", hjust=1),
        axis.text = element_text(size = 15),
        strip.text.x = element_text(size = 18)) + facet_wrap(~Local)
Hist2 = ggplot(biomass, aes(x = h)) +
  geom_histogram(color = "white", fill = "#225EA8",binwidth=2.44) +
  labs(x = 'Altura (m)',
       y = 'Frequência') +
  theme(legend.title = element_text(size = 15),
        legend.text = element_text(size = 17),
        axis.title = element_text(size = 22),
        axis.text.x = element_text(color = "black", hjust=1),
        axis.text.y = element_text(color = "black", hjust=1),
        axis.text = element_text(size = 15),
        strip.text.x = element_text(size = 18)) + facet_wrap(~Local)
Hist3 = ggplot(biomass, aes(x = dap)) +
  geom_histogram(color = "white", fill = "#225EA8",binwidth=2.84) +
  labs(x = 'DAP (cm)',
       y = 'Frequência') +
  theme(legend.title = element_text(size = 15),
        legend.text = element_text(size = 17),
        axis.title = element_text(size = 22),
        axis.text.x = element_text(color = "black", hjust=1),
        axis.text.y = element_text(color = "black", hjust=1),
        axis.text = element_text(size = 15),
        strip.text.x = element_text(size = 18)) + facet_wrap(~Local)

x11()
grid.arrange(Hist1,Hist2,Hist3, nrow = 3)
####################################################################################
############################################################################
########################## Exploratory analysis ############################
############################################################################
######################## continuos variable ################################
# # Carregar os dados (supondo que estejam em um data frame chamado 'biomass')
dados_filtrados <- biomass[, c("Local", "Parcela", "dap", "h", "bt")]
# # Visualizar os dados filtrados
head(dados_filtrados)############################################################################


dados = dados_filtrados %>% 
  select(-c(Parcela, Local)) %>% 
  descr(order = "preserve",
        stats = c('mean', 'sd', 'min', 'q1', 'med', 'q3', 'max'),
        round.digits = 6)
#------#
numeric_features <- dados_filtrados %>% 
  select(c(h,dap,bt)) %>% 
  pivot_longer(!h, names_to = "features", values_to = "values") %>%
  group_by(features) %>% 
  mutate(Mean = mean(values),
         Median = median(values))
#------# hist for each independent variable
numeric_features %>%
  ggplot() +
  geom_histogram(aes(x = values, fill = features), bins = 15, alpha = 0.7, show.legend = F) +
  facet_wrap(~ features, scales = 'free')+
  paletteer::scale_fill_paletteer_d("ggthemes::excel_Parallax") +
  geom_vline(aes(xintercept = Mean, color = "Mean"), linetype = "dashed", size = 1.3 ) +
  geom_vline(aes(xintercept = Median, color = "Median"), linetype = "dashed", size = 1.3 ) +
  scale_color_manual(name = "", values = c(Mean = "red", Median = "yellow"))

############################################################################
######################## organizing ########################################
############################################################################
dados_select <- biomass2 %>% 
  mutate(across(1, factor))
# look
glimpse(dados_select)
############################################################################
############### Separating the training and testing bases ##################
############################################################################
set.seed(2025)
dados_split <- dados_select %>% 
  initial_split(prop = 0.8)
#------# Extract each split
dados_train <- training(dados_split)
dados_test <- testing(dados_split)
# look
glue::glue(
  'Training Set: {nrow(dados_train)} rows
  Test Set: {nrow(dados_test)} rows')
############################################################################
############### Model 1: Linear Regression #################################
############################################################################
lm_spec <- 
  linear_reg() %>% 
  set_engine("lm") %>% 
  set_mode("regression")
#------# Train a linear regression model
lm_mod <- lm_spec %>% 
  fit(bt ~ ., data = dados_train); lm_mod
#------# Predicted values
results <- dados_test %>% 
  bind_cols(lm_mod %>% 
              predict(new_data = dados_test) %>% 
              rename(predictions = .pred))
#------# Observed value and predicted value
results %>% 
  select(c(bt, predictions)) %>% 
  slice_head(n = 10)
#------# graph observed value and predicted value
results %>% 
  ggplot(mapping = aes(x = bt, y = predictions)) +
  geom_point(size = 1.6, color = "steelblue") +
  geom_smooth(method = "lm", se = F, color = 'magenta') +
  ggtitle("Regressão Linear") +
  xlab("Valores Observados") +
  ylab("Valores Preditos") +
  theme(legend.title = element_text(size = 21),
        legend.text = element_text(size = 21),
        axis.title = element_text(size = 31),
        axis.text.x = element_text(color = "black", hjust=1),
        axis.text.y = element_text(color = "black", hjust=1),
        axis.text = element_text(size = 31),
        plot.title = element_text(size = 25, hjust = 0.5),
        strip.text.x = element_text(size = 15))
#------# Metrics
eval_metrics <- metric_set(rmse, rsq)
eval_metrics(data = results,
             truth = bt,
             estimate = predictions) %>% 
  select(-2)
############################################################################
############### Model 2: Lasso Regression ##################################
############################################################################
lasso_spec <-
  linear_reg(penalty = 1, mixture = 1) %>% 
  set_engine('glmnet') %>% 
  set_mode('regression')
#------# Train a lasso regression model
lasso_mod <- lasso_spec %>% 
  fit(bt ~ ., data = dados_train); lasso_mod

library(broom)
lasso_coefs <- tidy(lasso_mod)
print(lasso_coefs)

#------# Predicted values
results <- dados_test %>% 
  bind_cols(lasso_mod %>% predict(new_data = dados_test) %>% 
              rename(predictions = .pred))
#------# Metrics
lasso_metrics <- eval_metrics(data = results,
                              truth = bt,
                              estimate = predictions) %>%
  select(-2)
#------# graph observed value and predicted value
lasso_plt <- results %>% 
  ggplot(mapping = aes(x = bt, y = predictions)) +
  geom_point(size = 1.6, color = 'darkorchid') +
  geom_smooth(method = 'lm', color = 'black', se = F) +
  ggtitle("Regressão Lasso") +
  xlab("Valores Observados") +
  ylab("Valores Preditos") +
  theme(legend.title = element_text(size = 21),
        legend.text = element_text(size = 21),
        axis.title = element_text(size = 31),
        axis.text.x = element_text(color = "black", hjust=1),
        axis.text.y = element_text(color = "black", hjust=1),
        axis.text = element_text(size = 31),
        plot.title = element_text(size = 25, hjust = 0.5),
        strip.text.x = element_text(size = 15))
#------# Metrics
list(lasso_metrics, lasso_plt)
############################################################################
############### Model 3: Decision Tree Regression ##########################
############################################################################
tree_spec <- decision_tree() %>% 
  set_engine('rpart') %>% 
  set_mode('regression')
#------# Train a decision tree model 
tree_mod <- tree_spec %>% 
  fit(bt ~ ., data = dados_train); tree_mod

library(rpart.plot)
rpart.plot(tree_mod$fit, type = 3, extra = 101)
#------# Predicted values
results <- dados_test %>% 
  bind_cols(tree_mod %>% predict(new_data = dados_test) %>% 
              rename(predictions = .pred))
#------# Metrics
tree_metrics <- eval_metrics(data = results,
                             truth = bt,
                             estimate = predictions) %>% 
  select(-2)
#------# graph observed value and predicted value
tree_plt <- results %>% 
  ggplot(mapping = aes(x = bt, y = predictions)) +
  geom_point(color = 'tomato') +
  geom_smooth(method = 'lm', color = 'steelblue', se = F) +
  ggtitle("Regressão - Árvore de Decisão") +
  xlab("Valores Observados") +
  ylab("Valores Preditos") +
  theme(legend.title = element_text(size = 21),
        legend.text = element_text(size = 21),
        axis.title = element_text(size = 31),
        axis.text.x = element_text(color = "black", hjust=1),
        axis.text.y = element_text(color = "black", hjust=1),
        axis.text = element_text(size = 31),
        plot.title = element_text(size = 25, hjust = 0.5),
        strip.text.x = element_text(size = 15))
#------# Metrics
list(tree_metrics, tree_plt)
############################################################################
############### Model 4: Random Forest Regression ##########################
############################################################################
rf_spec <- rand_forest() %>% 
  set_engine('randomForest') %>% 
  set_mode('regression')
#------# Train a random forest model 
rf_mod <- rf_spec %>% 
  fit(bt ~ ., data = dados_train); rf_mod
#------# Predicted values
results <- dados_test %>% 
  bind_cols(rf_mod %>% predict(new_data = dados_test) %>% 
              rename(predictions = .pred))
#------# Metrics
rf_metrics <- eval_metrics(data = results,
                           truth = bt,
                           estimate = predictions) %>% 
  select(-2)
#------# graph observed value and predicted value
rf_plt <- results %>% 
  ggplot(mapping = aes(x = bt, y = predictions)) +
  geom_point(color = '#6CBE50FF') +
  geom_smooth(method = 'lm', color = '#2B7FF9FF', se = F) +
  ggtitle("Regressão - Floresta Aleatória") +
  xlab("Valores Observados") +
  ylab("Valores Preditos") +
  theme(legend.title = element_text(size = 21),
        legend.text = element_text(size = 21),
        axis.title = element_text(size = 31),
        axis.text.x = element_text(color = "black", hjust=1),
        axis.text.y = element_text(color = "black", hjust=1),
        axis.text = element_text(size = 31),
        plot.title = element_text(size = 25, hjust = 0.5),
        strip.text.x = element_text(size = 15))
#------# Metrics
list(rf_metrics, rf_plt)
############################################################################
##################### Model 5: Xgboost Regression ##########################
############################################################################
boost_spec <- boost_tree() %>% 
  set_engine('xgboost') %>% 
  set_mode('regression')
#------# Train an xgboost model 
boost_mod <- boost_spec %>% 
  fit(bt ~ ., data = dados_train); boost_mod
#------# Predicted values
results <- dados_test %>% 
  bind_cols(boost_mod %>% predict(new_data = dados_test) %>% 
              rename(predictions = .pred))
#------# Metrics
boost_metrics <- eval_metrics(data = results,
                              truth = bt,
                              estimate = predictions) %>% 
  select(-2)
#------# graph observed value and predicted value
boost_plt <- results %>% 
  ggplot(mapping = aes(x = bt, y = predictions)) +
  geom_point(color = '#4D3161FF') +
  geom_smooth(method = 'lm', color = 'black', se = F) +
  ggtitle("XGBoost") +
  xlab("Valores Observados") +
  ylab("Valores Preditos") +
  theme(legend.title = element_text(size = 21),
        legend.text = element_text(size = 21),
        axis.title = element_text(size = 31),
        axis.text.x = element_text(color = "black", hjust=1),
        axis.text.y = element_text(color = "black", hjust=1),
        axis.text = element_text(size = 31),
        plot.title = element_text(size = 25, hjust = 0.5),
        strip.text.x = element_text(size = 15))
#------# Metrics
list(boost_metrics, boost_plt)
############################################################################
################### Now considering the recipes ############################
############################################################################
############################################################################
# Defining the recipe
dados_recipe <- recipe(bt ~ ., data = dados_train) %>% 
  step_normalize(all_numeric_predictors()) %>% 
  step_dummy(all_nominal_predictors()) 
# look
summary(dados_recipe)
############################################################################
##################### Model 6: Xgboost Regression ##########################
############################################################################
boost_spec <- boost_tree() %>% 
  set_engine('xgboost') %>% 
  set_mode('regression')
#------# Create the workflow
boost_workflow <- workflow() %>% 
  add_recipe(dados_recipe) %>% 
  add_model(boost_spec); boost_workflow
#------#  Train the model
boost_workflow <- boost_workflow %>% 
  fit(data = dados_train)
#------# Predicted values
boost_workflow %>% 
  predict(new_data = dados_test %>% dplyr::slice(1:6))
# look
args(boost_tree)
############################################################################
################### Now considering hyperparameters ########################
############################################################################
############################################################################
#------# Defining the recipe again (the same)
dados_recipe <- recipe(bt ~ ., data = dados_train) %>% 
  step_normalize(all_numeric_predictors()) %>% 
  step_dummy(all_nominal_predictors()) 
#------# Make a tunable model specification
boost_spec <- boost_tree(trees = 50,
                         tree_depth = tune(),
                         learn_rate = tune()) %>% 
  set_engine('xgboost') %>% 
  set_mode('regression')
#------# Bundle a recipe and model spec using a workflow
boost_workflow <- workflow() %>% 
  add_recipe(dados_recipe) %>% 
  add_model(boost_spec);boost_workflow
#------# Create a grid 
tree_grid <- grid_regular(tree_depth(),
                          learn_rate(range = c(0.01, 0.3),trans = NULL), 
                          levels = 5)
#------# 5 fold CV repeated once
set.seed(2023)
dados_folds <- vfold_cv(data = dados_train, v = 5, repeats = 1); dados_folds
#------#  Fitted model tuning via grid 
doParallel::registerDoParallel()
set.seed(2023)
tree_grid <- tune_grid(
  object = boost_workflow,
  resamples = dados_folds,
  grid = tree_grid
)
#------# Metrics of all models
tree_grid %>% 
  collect_metrics() 
#------# The best model is...
tree_grid %>% 
  collect_metrics() %>% 
  mutate(tree_depth = factor(tree_depth)) %>% 
  ggplot(mapping = aes(x = learn_rate, y = mean,
                       color = tree_depth)) +
  geom_line(size = 0.6) +
  geom_point(size = 2) +
  facet_wrap(~ .metric, scales = 'free', nrow = 2)+
  scale_color_viridis_d(option = "plasma", begin = .9, end = 0)
#------# Observing the best model and its best hyperparameters and lowest bias
tree_grid %>% 
  show_best('rmse')
best_tree <- tree_grid %>% 
  select_best('rmse'); best_tree
final_wf <- boost_workflow %>% 
  finalize_workflow(best_tree); final_wf
#------# Metrics
final_fit <- final_wf %>% 
  last_fit(dados_split)
final_fit %>% 
  collect_metrics()