# Helper Functions for EDA

# Check all data types function (helper function belwo)
check_all <- function(input) {
  .check_numbs_only(input) %>% 
    left_join(.check_digit_length(input), by = c("variable")) %>% 
    left_join(.check_char_only(input), by = c("variable","n_row")) %>% 
    left_join(.check_punc_only(input), by = c("variable","n_row")) %>% 
    left_join(.check_blanks_only(input), by = c("variable","n_row")) %>% 
    left_join(.check_wspace_only(input), by = c("variable","n_row")) %>% 
    select(-matches("^n_row.*"))
}

# Check if number/digit ---------------------------------------------------
.check_numbs_only <- function(input) {
  
  check_numbs_only <- function(x) {
    
    # length(x[grepl("^[0-9]{1,}$", x)]) #only numbers, no decimals
    length(x[grepl("^[0-9]{1,}\\.*[0-9]{1,}$", x)]) #numbers with decimals
  }
  
  map_df(.x = input,.f = check_numbs_only) %>% 
    gather(variable,only_numbs) %>% 
    mutate(n_row = nrow(input)) %>% 
    mutate(numpercent = round(100*only_numbs/n_row,3))
}

# Check digit lengths -----------------------------------------------------
.check_digit_length <- function(input) { #doesn't work with decimal places (converts to character type)
  
  check_digit_lengthmin <- function(x) {
    
    min(nchar(as.character(x[grepl("^[0-9]{1,}$", x)])), na.rm = TRUE)
    
  }
  
  min_out <- map_df(input, check_digit_lengthmin) %>% 
    gather(variable, digits_min)
  
  check_digit_lengthmax <- function(x) {
    
    max(nchar(as.character(x[grepl("^[0-9]{1,}$",x)])), na.rm = TRUE)
    
  }
  
  max_out <- map_df(input, check_digit_lengthmax) %>% 
    gather(variable, digits_max)
  
  left_join(min_out, max_out, by = c("variable")) %>% 
    mutate(digits_eq = if_else(digits_min == digits_max, TRUE, FALSE))
  
}

# Check for Character -----------------------------------------------------
.check_char_only <- function(input) {
  
  check_char_only <- function(x) {
    
    length(x[grepl("^[A-z]{1,}$",toupper(x))]) #only characters at least once (convert all to upper case)
    
  }
  
  map_df(.x = input,.f = check_char_only) %>% 
    gather(variable,only_char) %>% 
    mutate(n_row = nrow(input)) %>% 
    mutate(charpercent = round(100*only_char/n_row,3)) %>% data.frame
  
}

# Check for Non-Digit or Non-Character ------------------------------------
.check_punc_only <- function(input) {
  
  check_punc_only <- function(x) {
    
    length(x[grepl("^\\W+$",x)]) #only non-word character [A-z0-9_]
    
  }
  
  map_df(.x = input,.f = check_punc_only) %>% 
    gather(variable,only_punc) %>% 
    mutate(n_row = nrow(input)) %>% 
    mutate(puncpercent = round(100*only_punc/n_row,3)) %>% data.frame
  
}

.check_blanks_only <- function(input) {
  
  check_blanks_only <- function(x) {
    
    length(x[grepl("^\\s{0}$",x)]) # matches ""
    
  }
  
  map_df(.x = input,.f = check_blanks_only) %>% 
    gather(variable,only_blanks) %>% 
    mutate(n_row = nrow(input)) %>% 
    mutate(blankspercent = round(100*only_blanks/n_row,3)) %>% data.frame
  
}

# Check for White Space
.check_wspace_only <- function(input) {
  
  check_wspace_only <- function(x) {
    
    length(x[grepl("^\\s*$",x)]) #matches "", " ", "   "
  }
  
  map_df(.x = input,.f = check_wspace_only) %>% 
    gather(variable,only_wspace) %>% 
    mutate(n_row = nrow(input)) %>% 
    mutate(wspacepercent = round(100*only_wspace/n_row,3)) %>% data.frame
}

