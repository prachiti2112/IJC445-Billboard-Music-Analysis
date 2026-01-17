# IJC445-Billboard-Music-Analysis
This project examines the ways in which the song characteristics of Hot-100 hits have been progressing from the year 2000 up until the current year of 2023, and the ways in which it correlates to the popularity of said songs upon the charts of Billboard.
How have measures of a song’s danceability, energy levels, loudness, tempo, and valence altered over the years in the Billboard Hot-100 songs? Are the aforementioned characteristics correlated with ranking in the Billboard chart?
## Dataset
The first dataset is the Billboard Hot-100 (2000-2023) dataset supplemented by audio features obtained from Spotify. This dataset includes the rankings on the charts alongside measurable musical properties and is useful for EDA.
## Methodology
This analysis was done using R and consists of:
- Data cleaning and preparation with tidyverse tools.
- Exploratory Visualization for Musical Trends Over Time - Level analysis by feature relationships and graph ranking - Predictive modeling with linear regression and random forests
- # Key Findings
– The average danceability of songs in the Billboard Hot 100 has increased over time.
- Loudness and energy are increasing, while acousticness is reducing.
- Musicianscinsics weak but regular correlations towards a song position in the charts.
- The performance of the random forest models surpasses the linear regression model, which obviously indicates the existence of non-linear interactions among the music attributes and their
