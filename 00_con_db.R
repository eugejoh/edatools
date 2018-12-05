
# Connection to PostgreSQL Database using R --------------------

# Load Packages
if (!require(here)) install.packages("here")
library(DBI)
library(RPostgreSQL)
library(dplyr)
library(dbplyr)


# Setup Connection to DB --------------------------------------------------
# Set driver for PostgreSQL DB
drv <- dbDriver("PostgreSQL")

# connect to india_gdb3
con <- RPostgres::dbConnect(drv, host = Sys.getenv("db_ip"),
                            port = 5432, dbname = Sys.getenv("db_name"),
                            user = Sys.getenv("db_user"), 
                            password = Sys.getenv("db_pw"))

