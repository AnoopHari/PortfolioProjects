# installing necessary packages
install.packages(c("tidyverse", "plotly", "ggthemes", "tinytex"),
                 repos = "https://cran.rstudio.com/")
library(tinytex)
library(tidyverse)
library(plotly)
library(ggthemes)
library(lubridate)
library(knitr)

# importing the dataset
on_shop <- read.csv("F:\\R practice\\R Projects\\Project 6\\Online Shopping Dataset\\Online_shopping.csv")

# Checking head and str()
str(on_shop)
head(on_shop)

# Checking for missing values
any(is.na(on_shop)) #there are NA"s

# Let's look for column wise missing values
nulls <- colSums(is.na(on_shop))
nulls[nulls > 0]

#Dealing missing values
# Substituting 400 missing Discount_pct values with zeros prevented significant 
# data loss, avoiding the need to delete those rows.
on_shop$Discount_pct[is.na(on_shop$Discount_pct)] <- 0

any(is.na(on_shop$Discount_pct))

# Dropping rows with null values in key fields preserved essential data integrity.
on_shop <- na.omit(on_shop)
any(is.na(on_shop))

# Effectively managed missing values within the dataset.

#Checking summary 
summary(on_shop)

#Converting date from 'character' to 'date' format    
on_shop$Transaction_Date <- mdy(on_shop$Transaction_Date)


#extracting transaction day, month, year, week day.
on_shop <- on_shop %>% 
  mutate(trans_day = day(Transaction_Date),
         trans_month = month(Transaction_Date),
         trans_year = year(Transaction_Date),
         trans_week = wday(Transaction_Date))

#'Transaction_date' and 'Date' columns share identical values; thus, 
# 'Date' column deletion is necessary.
on_shop <- on_shop %>% 
  select(-Date)

# Analysis
#1)	Customer Behavior and Product Insights:
  
#  •	Which product categories are most frequently purchased? 
# Can we visualize this trend over time?
  
#  •	Is there any correlation between tenure (length of association) and the 
# average price or quantity of products purchased?

theme_set(theme_solarized())

prod_cat <- on_shop %>% 
  group_by(Product_Category) %>% 
  summarise(Product_Count = n()) %>% 
  arrange(-Product_Count)

 ggplot(prod_cat, aes(x = Product_Category, y = Product_Count)) +
  geom_bar(stat = "identity", fill = "#76D7C4") +
  theme(axis.text.x = element_text(angle = 45)) +
  labs(title = "Purchase trend across product categories",
       x = "Category", y = "Count", subtitle = "Apparel stands as the top-selling category, while Android ranks as the least sold") +
  theme(axis.text.x = element_text(size = 8, color = "#39858C", face = "bold")) +
  theme(plot.title = element_text(color = "#3498DB", face = "bold")) +
  theme(plot.subtitle = element_text(size = 8, color = "#5F75CE", face = "italic"))

# Visualizing trend over time
prod_cat2 <- on_shop %>% 
  group_by(Transaction_Date, Product_Category) %>% 
  summarise(Count = n()) %>% 
  arrange(- Count)

k <- ggplot(prod_cat2, aes(x = Transaction_Date, y = Count)) +
  geom_line(aes(color = Product_Category), size = 0.2) +
  labs(title = "Trend analysis of product categories over time",
       x = "Transaction Date", color = "Category") +
  theme(plot.title = element_text(color = "#3498DB", face = "bold",
                                  size = 12)) +
  theme(legend.text = element_text(size = 8))
  
# Interactive Viz
ggplotly(k)

# correlation between tenure and quantity purchased
cor(on_shop$Quantity, on_shop$Tenure_Months) # 0.006867134

# correlation between tenure and avg_price purchased
cor(on_shop$Tenure_Months, on_shop$Avg_Price) # -0.0007849942

# there is a weak to no correlation between tenure and quantity purchased, 
# and there seems to be a negative correlation between tenure and average price

# 2)	Coupon Analysis:
  
#  •	What is the distribution of coupon usage among different product categories
#     or locations?
  
#  •	Can we analyze the impact of different coupon codes on the average 
#     transaction amount or quantity purchased?
  
colnames(on_shop)

coup_loc <- on_shop %>% 
  group_by(Coupon_Status, Location) %>% 
  summarise(Count = n()) %>% 
  arrange(- Count)

 ggplot(coup_loc, aes(x = Coupon_Status, y = Count)) +
  geom_col(aes(fill = Location), color = "black") +
  labs(title = "Distribution of Coupon Status across Locations", 
       x = "Coupon Status",
       subtitle = "Chicago tops coupon usage, while Washington DC ranks lowest") +
  theme(plot.subtitle = element_text(size = 8, color = "#5F75CE", face = "italic")) +
  scale_fill_manual(values = c("#2B3E67", "#2D7246", 
                               "#F4FC4A", "#E91601", "#71522A")) +
   theme(plot.title = element_text(color = "#3498DB", face = "bold", size = 11))

# Coupon Status of the majority is 'Clicked'
# Most number of Coupons are used by the people of Chicago and least being Washington DC
 
 
# Product category and coupon code
pcc <- on_shop %>% 
  group_by(Coupon_Code) %>% 
  summarise(Count = n()) %>% 
  arrange(-Count)

# Top 10 most used coupon code
top_10_cc <- head(pcc, 10)

kable(top_10_cc, full_width = FALSE)

# Least used Coupon Codes
least_cc <- tail(pcc, 5)

kable(least_cc, full_width = FALSE)

# Product Category and Coupon
top_codes <- on_shop %>% 
  group_by(Product_Category, Coupon_Code) %>% 
  summarise(Count = n()) %>% 
  arrange(- Count) %>% 
  head(30)

interactive <- ggplot(top_codes, aes(x = Product_Category, y = Count)) +
  geom_col(color = "black", aes(fill = Coupon_Code)) +
  labs(title = "Top Coupon Codes used for Product Purchases",
       x = "Product Category", fill = "Coupon Code") +
  theme(axis.text.x = element_text(angle = 45)) +
  theme(axis.text.x = element_text(size = 8)) +
  scale_fill_manual(values = c(
    "#336600", "#FF9900", "#000066", "#FF3399", "#660099",
    "#66CCFF", "#993200", "#00CC66", "#663300", "#FFCC00",
    "#333333", "#FF0033", "#F5F5F5", "#9966CC", "#FAFAFA",
    "#3333FF", "#F0F8FF", "#009999", "#E5B7B7", "#66FF33",
    "#F08080", "#CC6699", "#DE3B3B", "#FFCC99", "#CD5C5C",
    "#FFFF00", "#993232", "#FF99CC", "#8B0000", "#9900FF"
  )) +
  guides(fill = FALSE) +
  theme(plot.title = element_text(color = "#3498DB", face = "bold",
                                  size = 11))
  
ggplotly(interactive)

# impact of different coupon codes on the average 
#     transaction amount or quantity purchased?

ggplot(on_shop, aes(x = Coupon_Code, y = Avg_Price)) +
  geom_boxplot(fill = "#FB3F03", 
               color = "#714702", 
               alpha = 0.6) +
  theme(axis.text.x = element_text(size = 7, 
                                   angle = 90, 
                                   color = "#363744")) +
  labs(title = "Distribution of Average Price across Coupon Codes",
       x = "Coupon Code", y = "Average Price") +
  theme(plot.title = element_text(color = "#3498DB", face = "bold",
                                  size = 11))

# Larger variation in Average prices for coupon codes GC10, GC20 and GC30
# the average price distribution among all other coupon codes are some what similar 
# coupon code ACC30 is the only coupon code which doesn't have any coupon pairs 
# all other coupon codes have 3 different categories 
# maximum average prices are for coupon codes NE10, NE20 and NE30

# 3)	Geographical Patterns and Spending Habits:
  
#  •	How does customer spending behavior vary across different locations?
  
#  •	Can we visualize the distribution of offline versus online spending 
#     across different regions or customer segments?

# Adding up values of Offline Spend and Online Spend and creating a new column called total_spending
on_shop <- on_shop %>% 
  mutate(total_spending = Offline_Spend + Online_Spend)

# Combination of violin and boxplot is ideal for understanding the data distribution
ggplot(on_shop, aes(x = Location, y = total_spending)) +
  geom_violin(color ="#59905B", fill = "#E0FEAF") +
  geom_boxplot(color = "#D08115", width = 0.4, 
               fill = "#B06860", alpha = 0.5) +
  labs(title = "Spendings distribution across locations",
       y = "Total Spending (Online + Offline)") +
  theme(plot.title = element_text(color = "#3498DB", face = "bold", size = 11))


# The minimum spending in Washington DC is notably higher than in other locations
# All other locations have similar spending patterns
# California has the highest maximum density spending and New Jersey being the lowest


# offline vs online
on_off <- on_shop %>% 
  select(Location, Online_Spend, Offline_Spend) %>% 
  group_by(Location) %>% 
  summarise(Total_Online_Spend = sum(Online_Spend),
            Total_Offline_Spend = sum(Offline_Spend))

# Reshaping data to long format for plotting
on_off_long <- on_off %>% 
  pivot_longer(cols = c(Total_Online_Spend, Total_Offline_Spend),
               names_to = "Spend_Type",
               values_to = "Total_Spend")

ggplot(on_off_long, aes(x = Location, y = Total_Spend, fill = Spend_Type)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Offline vs Online spending distribution by location",
       x = "Location",
       y = "Total Spending",
       fill = "Spend Type") +
  theme(axis.text.x = element_text(angle = 40, hjust = 1)) +
  scale_fill_manual(values = c("#0D126C", "#F701FE")) +
  theme(plot.title = element_text(size = 12, color = "#3498DB", 
                                  face = "bold")) +
  theme(legend.text = element_text(size = 7, face = "bold"),
        legend.title = element_text(size = 8))

# maximum spending are done by offline transactions

# 4)	Temporal Trends and Seasonality:
  
#  •	Are there seasonal trends in purchases? How do they vary across product 
#     categories?
  
#  •	Can we identify any patterns in offline or online spending behavior 
#     over the months?
  
purchase_trends <- ggplot(on_shop, aes(x = Product_Category)) +
  geom_bar(aes(fill = Product_Category)) +
  facet_wrap(~ factor(trans_month), nrow = 4) +
  theme(axis.text.x = element_blank()) +
  labs(title = "Monthly purchase trends by product category",
       x = "Product Category",
       y = "Total Purchases") +
  theme(plot.title = element_text(size = 8, color = "#3498DB", 
                                  face = "bold")) +
  theme(legend.text = element_text(size = 7, face = "bold"),
        legend.title = element_text(size = 8))

ggplotly(purchase_trends)

# Category wise trends: 
  
# Apprel tends to have higher sales during July and August, lowest during november
# Nest_USA tends to have higher sales during January and December
# Bags have higher sales on July and August
# Drinkware have higher sales on March and August
# Lifestyle products have a steady increase in sales from March to October, the trend drops after october
# Nest category have increasing trend from August to December


# Finding patterns in offline and online spending behavior 
# over the months?
spend_by_month <- on_shop %>% 
  group_by(trans_month) %>% 
  summarise(Total_Online_Spend = sum(Online_Spend),
            Total_Offline_Spend = sum(Offline_Spend))

# Reshaping data to long format for plotting
spend_by_month_long <- spend_by_month %>% 
  pivot_longer(cols = c(Total_Online_Spend, Total_Offline_Spend),
               names_to = "Spend_Type",
               values_to = "Total_Spend")


ggplot(spend_by_month_long, aes(x = trans_month, 
                                y = Total_Spend, 
                                color = Spend_Type)) +
  geom_line(linewidth = 1) +
  geom_point(size = 4) +
  scale_x_continuous(breaks = 1:12, labels = month.abb[1:12]) +
  labs(title = "Montly Offline vs Online Purchase Trend", 
       x = "Transaction Month", y = "Total Spend",
       subtitle = "Sales peak notably in August and December",
       color = "Spend Type") +
  theme(axis.text.x = element_text(size = 7, face = "bold")) +
  theme(plot.subtitle = element_text(size = 9, face = "italic",
                                     color = "#5F75CE")) +
  scale_color_brewer(palette = "Set1") +
  theme(plot.title = element_text(color = "#3498DB", face = "bold", size = 11)) +
  theme(legend.text = element_text(size = 7),
        legend.title = element_text(size = 8))

# Offline transactions are made higher than online transactions
# Sales is maximum on August and December
# Sales is minimum on February, June and September

#  5)	Impact of Discounts and GST:
  
#  •	Is there a noticeable relationship between the discount percentage 
#     applied and the quantity or total spend in transactions?
  
#  •	How does the GST affect the total transaction amount, and is there 
#     a variation across locations?
  
# discount percentage
# quantity or total spend in transactions


analysis_5 <-on_shop %>% 
  select(Discount_pct, Quantity, Offline_Spend, Online_Spend, Location, GST) %>% 
  mutate(Total_Spend = Offline_Spend + Online_Spend) %>% 
  filter(Discount_pct > 0)

attach(analysis_5)

cor(Discount_pct, Total_Spend) # 0.04769603

cor(Discount_pct, Quantity) # -0.01138081

# There is little to no relationship between Discount Percentage and Total_Spend
# There is a negative correlation between Discount Percentage and Quantity

# GST
# Total_Spend

# Finding the total Amount including GST

# Add GST: GST amount = (Original cost x GST%)/100. 
# Net price = original cost + GST amount.

analysis_5 <- analysis_5 %>% 
  mutate(GST_Amount = (Total_Spend * GST))

analysis_5$GST_Amount <- analysis_5$Total_Spend + analysis_5$GST_Amount

gst_locate <- analysis_5 %>% 
  group_by(Location) %>% 
  summarise(Without_GST = sum(Total_Spend),
            With_GST = sum(GST_Amount)) 

# Reshaping for visualization purpose
gst_locate <- gst_locate %>% 
  pivot_longer(cols = c(Without_GST, With_GST),
               names_to = "Amount_Type",
               values_to = "Total_Amount")

ggplot(gst_locate, aes(x = Location, y = Total_Amount, fill = Amount_Type)) +
  geom_bar(stat = "identity", position = "dodge") +
  theme(axis.text.x = element_text(size = 8),
        plot.title = element_text(size = 13, face = "bold")) +
  labs(title = "Comparing total amounts with and without GST",
       y = "Total Amount", fill = "Amount Type") +
  scale_fill_manual(values = c("#D42626", "#169483")) +
  theme(plot.title = element_text(color = "#3498DB", face = "bold")) +
  theme(legend.text = element_text(size = 8))

# Impact of GST was highest on New Jersey with a 13.73% of increase from the original amount
# Lowest being California and New York with 13.58 %

# 6)	Performance Metrics:
  
#  •	What are the key performance indicators (KPIs) that can be derived from 
#     this dataset, such as average revenue per customer, 
#     average transaction value, or customer acquisition trends over time?

# Average Transaction Value
avg_transaction_value <- mean(on_shop$total_spending)

print(avg_transaction_value)

# Customer Acquisition Trends Over Time
c_aq_trend <- on_shop %>% 
  group_by(Transaction_Date) %>% 
  summarise(New_Customers = n_distinct(CustomerID)) %>% 
  arrange(- New_Customers)


# Plotting Customer Acquisition Trends Over Time
ggplot(c_aq_trend, aes(x = Transaction_Date, y = New_Customers)) +
  geom_line(color = "#2C3E50", size = 1) +
    labs(title = "Customer Acquisition Trend Over Time",
         x = "Transaction Date", y = "New Customers",
         subtitle = "August saw the highest influx of new customers") +
  theme(plot.title = element_text(color = "#3498DB", face = "bold")) +
  theme(plot.subtitle = element_text(size = 10, face = "italic",
                                     color = "#5F75CE"))

# The month with the highest number of new customer sign-ups is August