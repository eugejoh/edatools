#' Install Packages
#'
#' This wrapper function checks whether specified packages are installed and installs if neccessary,
#' otherwise loads the package.
#'
#' @param pkg \code{character} string of package names to install or load.
#'
#' @return loads packages
#' @export
#'
#' @importFrom utils installed.packages install.packages
#'
#'
#' @examples
#'
#' \donttest{
#' packs <- c("utils", "ggplot2")
#'
#' install_packs("utils")
#' }

install_packs <- function(pkg) {
  
  if (!is.character(pkg)) stop("pkg must be character type")
  
  new_pkg <- pkg[!(pkg %in% utils::installed.packages()[,"Package"])]
  if (length(new_pkg)) {
    utils::install.packages(new_pkg, dependencies = TRUE)
  }
  sapply(pkg, require, character.only = TRUE)
}
