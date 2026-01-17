#Installing the packages 
install.packages("tidyverse")
install.packages("caret")
install.packages("randomForest")
#Loading the libraries
library(tidyverse)
library(caret)
library(randomForest)
#Loading the Billboard Hot-100 dataset
data <- read_csv("billboard_24years_lyrics_spotify.csv")
#Cleaning and preparing the dataset 
data_clean <- data %>%
  distinct(song,band_singer,year,.keep_all = TRUE) %>%
  drop_na(
    ranking,
    danceability,
    energy,
    loudness,
    tempo,
    valence,
    acousticness
  ) %>%
  mutate(
    decade = floor(year/10)*10
  )
glimpse(data_clean)
#Train testing split 
set.seed(123)
train_index <- createDataPartition(data_clean$ranking, p = 0.7, list = FALSE)
train <- data_clean[train_index, ]
test <- data_clean[-train_index, ]

#Figure 1- Average of danceability over time 
#Creating a png for figure 1
png(
  filename="Figure1_average_danceability.png",
  width= 1200,
  height= 800,
  res= 150
)

ggplot(data_clean,aes(x=year,y=danceability))+
  stat_summary(fun = mean, geom = "line", linewidth = 1)+
  stat_summary(fun = mean, geom = "point")+
  labs(
    title = "Average danceability of Billboard Hot-100 songs",
    x="Year",
    y="Average Dancebility"
  )+
  theme_minimal()
dev.off()
#Figure 2- multiple musical features over the time 
#Converting data to long format to get multiple feature comparison 

png(
  filename="Figure2_musical_features_overtime.png",
  width= 1200,
  height= 800,
  res= 150
)

data_long<- data_clean %>%
  select(year,danceability,energy,loudness,acousticness) %>%
  pivot_longer(
    -year,
    names_to = "feature",
    values_to = "value"
  )
ggplot(data_long,aes(x=year,y=value,color=feature))+
  stat_summary(fun = mean, geom = "line", linewidth = 1)+
  labs(
    title = "Trends in musical features of billboard Hot-100 songs",
    x="Year",
    y="Average feature value",
    color="Feature"
  )+
  theme_minimal()

dev.off()
#Figure 3- Musical features vs chart rank
#Preparing the data for feature vs rank comparison

png(
  filename="Figure3_musical_features_VS_ Chart_rank.png",
  width= 1200,
  height= 800,
  res= 150
)

feature_rank<-data_clean %>%
  select(
    ranking,
    danceability,
    energy,
    loudness,
    tempo,
    valence,
    acousticness
  ) %>%
  pivot_longer(
    -ranking,
    names_to = "feature",
    values_to = "value"
  )
ggplot(feature_rank,aes(x=value,y=ranking))+
  geom_point(alpha = 0.2)+
  geom_smooth(method = "lm", se= FALSE)+
  facet_wrap(~feature,scales = "free_x")+
  labs(
    title = "Relationship between musical features and billboard chart rank",
    x="feature value",
    y="chart rank(lower = higher popularity)"
  )+
  theme_minimal()

dev.off()
#Figure 4-prediction with linear regression and random forest model 
# Linear regression model

png(
  filename="Figure4_linearregression_randomforest.png",
  width= 1200,
  height= 800,
  res= 150
)

lm_model <- lm(
  ranking ~ danceability + energy + loudness + tempo + valence,
  data = train
)

# Random Forest model
rf_model <- randomForest(
  ranking ~ danceability + energy + loudness + tempo + valence,
  data = train
)

# Predictions
pred_lm <- predict(lm_model, test)
pred_rf <- predict(rf_model, test)

# Combining results for plotting
model_results <- tibble(
  Actual = test$ranking,
  Linear_Regression = pred_lm,
  Random_Forest = pred_rf
) %>%
  pivot_longer(
    cols = -Actual,
    names_to = "Model",
    values_to = "Predicted"
  )

# Ploting the predicted vs actual rankings
ggplot(model_results, aes(x = Actual, y = Predicted)) +
  geom_point(alpha = 0.3) +
  geom_abline(linetype = "dashed") +
  facet_wrap(~ Model) +
  labs(
    title = "Predicted vs Actual Billboard Hot-100 Chart Rank",
    x = "Actual Chart Rank",
    y = "Predicted Chart Rank"
  ) +
  theme_minimal()

dev.off()
