# installing packages
install.packages("tidyverse", repos = "https:\\cran.rstudio.com")
library(tidyverse)

# loading the data
batting_mb <- read.csv("F:\\R practice\\R Projects\\Project 4\\Money Ball Project\\Batting.csv")

# checking head() and str()
head(batting_mb)

str(batting_mb)

# Call the head() of the first five rows of AB (At Bats) column
head(batting_mb$AB, 5)

# Call the head of the doubles (X2B) column
head(batting_mb$X2B)

# We need to add three more statistics that were used in Moneyball! These are:
  
# Batting Average
# On Base Percentage
# 1B (Singles)
# Slugging Percentage

# creating new columns
batting_mb$BA <- batting_mb$H / batting_mb$AB #Batting Average

batting_mb <- batting_mb %>% 
  mutate(OBG = (H+BB+HBP) / (AB+BB+HBP+SF)) #On-base percentage
batting_mb <- batting_mb %>% rename("OBP" = "OBG")

batting_mb <- batting_mb %>%  #1B (Singles)
  mutate(X1B = H-X2B-X3B-HR)

batting_mb <- batting_mb %>% 
  mutate(SLG = (X1B) + (2*X2B) + (3*X3B) + (4*HR) / AB) #Slugging Percentage

colnames(batting_mb)

# Merging Salary Data with Batting Data
sal <- read.csv("F:\\R practice\\R Projects\\Project 4\\Money Ball Project\\Salaries.csv")

# Use summary to get a summary of the batting data frame and notice the minimum year 
# in the yearID column
summary(batting_mb$yearID) #1871 is the minimum year

summary(sal$yearID) #1985 is the minimum year

# to merge we need to filter out years less than 1985 from batting dataset
batting_mb_adj <- batting_mb %>% 
  subset(yearID >= 1985)

summary(batting_mb_adj$yearID)

# merging
combo <- merge(batting_mb_adj, sal, by =  c('playerID','yearID'))

summary(combo)

# Analyzing the Lost Players

# lost players player id :
# giambja01
# damonjo01
# saenzol01

# Create a data frame called lost_players from the combo data frame consisting of these 3 players
lp <- c ("giambja01" , "damonjo01", "saenzol01")

lost_players <- combo %>% 
  subset(playerID %in% lp)

# Since all these players were lost in after 2001 in the off-season, let's only 
# concern ourselves with the data from 2001
lost_players <- lost_players %>% 
  subset(yearID == 2001)

# Reduce the lost_players data frame to the following columns:
# playerID,H,X2B,X3B,HR,OBP,SLG,BA,AB
lost_players <- lost_players %>% 
  select(playerID, H, X2B, X3B, HR, OBP, SLG, BA, AB)


# Find Replacement Players for the key three players we lost! However, you have 
# three constraints:
  
# 1. The total combined salary of the three players can not exceed 15 million dollars.
# 2. Their combined number of At Bats (AB) needs to be equal to or greater than the 
# lost players.
# 3. Their mean OBP had to equal to or greater than the mean OBP of the lost players

combo_without_lp <- combo %>% 
  subset(!(playerID %in% lp)) %>% 
  filter(yearID == 2001)

ggplot(combo_without_lp, aes(x = OBP, y = salary)) +
  geom_point()

# Looks like there is no point in paying above 8 million or so (I'm just eyeballing this number). I'll choose that as a cutt off point. There are also a lot of players with OBP==0. Let's get rid of them too.

combo_without_lp <- filter(combo_without_lp, salary < 8000000, OBP > 0)


sum(lost_players$AB) # 1469
mean(lost_players$OBP) # 0.363

# The total AB of the lost players is 1469. This is about 1500, meaning I should probably cut off my avail.players at 1500/3= 500 AB.
combo_without_lp <- filter(combo_without_lp, AB >= 500)

# Now let's sort by OBP and see what we've got!
shortlist <- head(arrange(combo_without_lp, desc(OBP)), 10)

shortlist <- shortlist %>% 
  select(playerID, salary, AB, OBP)

selected_players <- shortlist[2:4, ]

print(selected_players)
