library(formattable)
library(DT)
library(dplyr)

cpm_gained <- read.csv("C:/Users/peter/Desktop/alpinepb_website_data/test_data.csv")

sign_formatter <- formatter("span", 
                            style = x ~ style(color = ifelse(x >= 4.0, "green", 
                                                             ifelse(x < 2.5, "red", "black"))))
#sign_formatter(c(-1, 0, 1))

# Let's try just score for now
cpm_gained$bidderSequence <- NULL
cpm_gained$bidderTimeout <- NULL
cpm_gained$priceGranularity <- NULL
cpm_gained$useBidCache <- NULL

# drop dupes
cpm_gained <- unique(cpm_gained)

g <- as.datatable(formattable(cpm_gained, list(
  Score = sign_formatter)))
htmlwidgets::saveWidget(g, "rankings_result.html")

## Full config list
library(formattable)
library(DT)

# load the data
df <- read.csv("C:/Users/peter/Desktop/alpinepb_website_data/full_config_file.csv")
df <- unique(df)

# reorder the dataframe
col_idx <- grep("publisherDomain", names(df))
df <- df[, c(col_idx, (1:ncol(df))[-col_idx])]

# look at the table
# fix some left 2 columns and right 1 column
g <- datatable(
  df, extensions = c('FixedColumns', 'Scroller', 'Buttons'),
  options = list(
    # dom = 't',
    deferRender = TRUE,
    scrollY = 300,
    scroller = TRUE,
    scrollX = TRUE,
    buttons = c('csv', 'excel'),
    dom = 'Bfrtip',
    fixedColumns = list(leftColumns = 2) #, rightColumns = 1
  )
)

htmlwidgets::saveWidget(g, "full_config_result.html")

## Top 25 configurations
df2 <- df
df2$dom <- gsub("https://", "", df2$publisherDomain)
cpm_gained$publisherDomain <- as.character(cpm_gained$publisherDomain)
cpm_gained <- head(cpm_gained, 25)
df2$tmp <- df2$dom %in% cpm_gained$publisherDomain
df2 <- df2[which(df2$tmp == TRUE), ]
df2 <- df2[, colMeans(is.na(df2)) != 1]
df2$publisherDomain <- as.character(df2$publisherDomain)
df2 <- left_join(df2, cpm_gained, by = c('dom'='publisherDomain'))
df2$dom <- NULL
df2$tmp <- NULL
df2 <- df2[order(-df2$Score), ]
df2 <- unique(df2)

g <- datatable(
  df2, extensions = c('FixedColumns', 'Scroller', 'Buttons'),
  options = list(
    # dom = 't',
    deferRender = TRUE,
    scrollY = 300,
    scroller = TRUE,
    scrollX = TRUE,
    buttons = c('csv', 'excel'),
    dom = 'Bfrtip',
    fixedColumns = list(leftColumns = 2) #, rightColumns = 1
  )
)

htmlwidgets::saveWidget(g, "top_config_result.html")



## Installed Modules
library(formattable)
library(DT)

# load the data
df <- read.csv("C:/Users/peter/Desktop/alpinepb_website_data/modules_data.csv")
df <- unique(df)
names(df)[1] <- "publisherDomain"

# remove the extra junk in the domain
df$publisherDomain <- gsub("https://", "", df$publisherDomain)
df$publisherDomain <- sub("\\/.*", "", df$publisherDomain)

# reorder the dataframe
col_idx <- grep("publisherDomain", names(df))
df <- df[, c(col_idx, (1:ncol(df))[-col_idx])]

# make unique
df <- unique(df)

# look at the table
# fix some left 2 columns and right 1 column
g <- datatable(
  df, extensions = c('FixedColumns', 'Scroller', 'Buttons'),
  options = list(
    # dom = 't',
    deferRender = TRUE,
    scrollY = 300,
    scroller = TRUE,
    scrollX = TRUE,
    buttons = c('csv', 'excel'),
    dom = 'Bfrtip',
    fixedColumns = list(leftColumns = 2) #, rightColumns = 1
  )
)

htmlwidgets::saveWidget(g, "modules_result.html")
