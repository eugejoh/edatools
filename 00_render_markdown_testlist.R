# Render Markdown Files in Project ----------------------------------------

if (!require(here)) install.packages("here")
library(here)
library(rmarkdown)
library(dplyr)

# 
# rmarkdown::render(
#   input = here::here("_markdown_eda", "eda_test1.Rmd"),
#   output_format = NULL,
#   output_file = "eda_test1.html",
#   output_dir = here::here("_reports"),
#   params = "ask",
#   quiet = TRUE)



# parameterized markdown rendering ----------------------------------------
render_list <- function(input) {
  if (!is.list(input)) stop("'input' argument must be a list")
  
  if (is.null(names(input))) stop("'input' should be a named list")
  
  if (length(input) == 0) stop("list length must be > 0")

  for (i in seq_len(length(input))) {
    rmarkdown::render(
      input = here::here("_markdown_eda", "eda_test1.Rmd"),
      output_file = paste0("eda_test1_", names(input)[i], ".html"),
      output_dir = here::here("_reports"),
      quiet = FALSE,
      params = list(
        set_title = paste0("EDA: `", names(input)[i], "` dataset"),
        len_i = i,
        dat = input[[i]],
        name_i = names(input)[i]
      )
    )
  }

  
}


# test data ---------------------------------------------------------------
data("mtcars", "airquality", "starwars", "swiss")

test_list <- list(
  mtcars, 
  airquality, 
  starwars, 
  tibble::rownames_to_column(swiss) %>% rename(location=rowname)) %>% 
  setNames(c("mtcars", "airquality", "starwars", "swiss"))

render_list(test_list)

