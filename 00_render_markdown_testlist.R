# Render Markdown Files in Project ----------------------------------------

if (!require(here)) install.packages("here")
library(here)
library(rmarkdown)
library(dplyr)
library(sendtg)
library(telegram.bot)

# rmarkdown::render(
#   input = here::here("_markdown_eda", "eda_test1.Rmd"),
#   output_format = NULL,
#   output_file = "eda_test1.html",
#   output_dir = here::here("_reports"),
#   params = "ask",
#   quiet = TRUE)

# test data ---------------------------------------------------------------
data("mtcars", "airquality", "starwars", "swiss", "iris")

test_list <- list(
  mtcars, 
  airquality, 
  starwars, 
  tibble::rownames_to_column(swiss) %>% rename(location=rowname),
  iris) %>% 
  setNames(c("mtcars", "airquality", "starwars", "swiss", "iris"))

# parameterized markdown rendering ----------------------------------------
render_list <- function(input, clear = FALSE, rmd = NULL) {
  if (!is.list(input)) stop("'input' argument must be a list")
  
  if (is.null(names(input))) stop("'input' should be a named list")
  
  if (length(input) == 0) stop("list length must be > 0")
  
  if (is.null(rmd)) {
    rmd <- here::here("_markdown", "eda_test2.Rmd")
  }

  for (i in seq_len(length(input))) {
    rmarkdown::render(
      input = rmd,
      output_file = paste0("eda_test2_", names(input)[i], ".html"),
      output_dir = here::here("_reports"),
      quiet = FALSE,
      params = list(
        set_title = paste0("Exploratory Data Analysis: `", names(input)[i], "`"),
        data = input[[i]],
        name_i = names(input)[i],
        continuous = TRUE,
        categorical = TRUE
      )
    )
    # sendtg::tg_send_msg(text = paste0("Completed Rendering EDA Report: ", names(input)[i]))  
  }

  if (clear) rm(list=setdiff(ls(), "render_list")) #child document causes problems if not cleared from ls()

}


# Render ------------------------------------------------------------------
render_list(test_list[3]); list.files(here::here("_reports"))


# Reset -------------------------------------------------------------------
rm(list=setdiff(ls(), "render_list"))



# Test list #2 -----------------------------------------------------------
source("00_con_db.R") #connect to db

drown <- dplyr::tbl(con, dbplyr::in_schema("public", "drowning_deaths_mds")) %>% collect()
dlhs3 <- dplyr::tbl(con, dbplyr::in_schema("public", "dlhs3v")) %>% collect()
srs_pop1113 <- dplyr::tbl(con, dbplyr::in_schema("public", "srs_pop_11_13_v2")) %>% collect()
un_pop_deaths <- dplyr::tbl(con, dbplyr::in_schema("public", "un_pop_deaths_ind_16")) %>% collect()
ahs_10_dist <- dplyr::tbl(con, dbplyr::in_schema("public", "ahs_10_dist")) %>% collect()

rn_list <- list(drown, dlhs3, srs_pop1113, un_pop_deaths) %>% 
  setNames(c("drowning_deaths_mds", "dlhs3v", "srs_pop_11_13_v2", "un_pop_deaths_ind_16"))

# render markdown files
render_list(rn_list)

