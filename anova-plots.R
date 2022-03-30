library(forecast)
library(ggplot2)
library(dplyr)

df1 <- read.csv('~/Desktop/hydra/time-series/data/texas_counties1.csv', sep = ',')
df2 <- read.csv('~/Desktop/hydra/time-series/data/texas_counties2.csv', sep = ',')
df3 <- read.csv('~/Desktop/hydra/time-series/data/texas_counties3.csv', sep = ',')
df <- rbind(df1,df2,df3)
comma_vars <- c('dollar_vol', 'avg_price', 'med_price')
df[, comma_vars] <- sapply(df[, comma_vars],
                           function (x) as.numeric(gsub(',', '', x)))
str(df)

df['date'] <- lapply(as.vector(df['date']),
                     function (x) as.Date(strptime(paste('01', x, sep = ''),
                                                   '%d %b %Y')))

# changing all price/listing columns to numeric
numeric_cols <- c('sales', 'dollar_vol', 'avg_price', 'med_price',
                  'total_listings', 'month_inventory')
df[, numeric_cols] <- sapply(df[, numeric_cols], as.numeric)

# dropping the X column - accidental indexing
df <- df[, names(df) != 'X']

# pulling out a county with a lot of variance 
austin_prices <- df %>% filter(county == 'Austin') %>% select('sales')
austin_ts <- ts(austin_prices, frequency = 12)

# circular annual plot
ggseasonplot(austin_ts, polar = TRUE, 
             main = '', xlab = 'Month', ylab = 'Home Sales') + theme_minimal()

# unstacked annual plot
ggseasonplot(austin_p year.labels = TRUE, main = '', ylab = 'Average Price') +
  theme_minimal()

