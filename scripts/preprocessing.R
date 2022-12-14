library(tidyverse)
library(corrplot)

data <- read_csv("data/unprocessed/listings.csv") %>%
  glimpse()

data <- data %>%
  rename(host_listings_count = calculated_host_listings_count) %>%
  # remove the 14 rows with price equal to 0 because a listing price of 0 can't be possible
  filter(price != 0) %>%
  filter(availability_365 != 0) %>%
  filter(!is.na(neighbourhood_group)) %>%
  select(-id, -name, -host_id, -host_name, -last_review, -license)

glimpse(data)

set.seed(2022)
data <- data[sample(nrow(data), size=15000), ]

data %>% select(reviews_per_month)

data$reviews_per_month[is.na(data$reviews_per_month)] <- 0

data %>% select(reviews_per_month)
data %>% filter(is.na(reviews_per_month))
data %>% filter(reviews_per_month == 0)

# corrplot(cor(Filter(is.numeric, data), use="pairwise.complete.obs"), method = 'color', )

# include use="pairwise.complete.obs" to exclude NAs
corrplot(cor(Filter(is.numeric, data)), method = 'color', )

# drop neighbourhood, latitude, longitude,
# drop number_of_reviews_ltm and reviews_per_month for being highly correlated with number_of_reviews
data <- data %>%
  select(-neighbourhood, -latitude, -longitude, -number_of_reviews_ltm, -reviews_per_month)

corrplot(cor(Filter(is.numeric, data)), method = 'color')

glimpse(data)

data %>% filter(is.na(neighbourhood_group))

# categorical variables: neighbourhood_group, room_type


NAnalysis <- data %>% 
  group_by(neighbourhood_group) %>% summarise(Mean_Price = mean(price))


ggplot(NAnalysis, aes(x = reorder(neighbourhood_group, -Mean_Price), y = Mean_Price, fill=neighbourhood_group)) + 
  geom_bar(stat="identity", show.legend = FALSE) + 
  labs(title="Average Price of Rooms in each Neighbourhood Group") + 
  theme(plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5), legend.position = c(0.8, 0.5)) + xlab("") + ylab("Mean Price")


