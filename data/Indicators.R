#Country variables 

setwd("/Users/nomko/Development/E-government/data")

library(data360r)

indicators <- get_data360(indicator_id = c(760, #access to electricity 
                                    944, #Foreign Direct Investment
                                    778, #Mobile Cellular Subscriptions
                                    804, #Urban
                                    839, #GDP Per Capita
                                    364, #Control of Corruption
                                    370, #Rule of Law
                                    376, #Political Stability 
                                    382, #Voice and Accountability 
                                    388, #Government Effectiveness
                                    394 #Regulatory Quality
                                    ),
                   timeframes = c(2019, 2020),
                   output_type = "long") %>% 
  select (-4) %>% 
  pivot_wider(names_from = Indicator ,
               values_from = Observation) 
  rename(electicity=4,
         FDI = 5,
         mobile = 6,
         urban = 7,
         GDP_per = 8,
         corruption = 9,
         rule_of_law = 10,
         pol_stab = 11,
         accountability = 12,
         effectiveness = 13,
         reg_qual = 14
         )

WWBI <- get_data360(indicator_id = c(42285, #Individuals with secondary education as a share of private paid employee
                                    42286, #Individuals with secondary education as a share of public paid employee
                                    42291, #Median age of private paid employees
                                    42292, #Median age of public paid employees
                                    42300, #Public sector employment as a share of paid employment
                                    42309 #Public sector employment as a share of total employment by location (Urban)
),
timeframes = c(2005:2018),
output_type = "long") %>%  
  pivot_wider(names_from = Indicator ,
              values_from = Observation)

data_full <- merge(data_EGOV, indicators, by.x=c("year","ID"), by.y = c("Period", "Country ISO3")) %>% 
  distinct(year, ID,.keep_all= TRUE)

#add data from the WB website 
young_pop <- read.csv("young_population.csv") %>% 
  select(2,"X2020") %>% 
  rename(young_population= X2020) 

pop_dens <- read.csv("population density.csv") %>% 
  select(2,"X2020") %>% 
  rename(pop_dens= X2020) 

internet_use <- read.csv("internet_users.csv") %>% 
  select(2,"X2019") %>% 
  rename(internet_users= X2019) 

#merge 
add_data <- list(young_pop, pop_dens, internet_use)
add_data <- add_data %>% reduce(full_join, by='Country.Code')


data_full <- merge(data_full, add_data, by.x=c("ID"), by.y = c("Country.Code"))
  

write.csv(data_full,'dataset.csv')


