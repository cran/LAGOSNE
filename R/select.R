#' Select and filter LAGOSNE data
#'
#' Select and filter LAGOSNE data with keyword helpers.
#'
#' @param dt data.frame of local copy of LAGOSNE data.  Can be loaded with \code{\link{lagosne_load}} and will use version as specified in \code{\link{lagosne_version}}.
#' @param table character name of a dt table
#' @param vars character vector of specific column names to select from table
#' @param categories what type of variables should be kept. Note not all scale-category options are available. Variable categories include:
#' \itemize{
#'     \item "waterquality" - includes all in-situ chemistry, chlorophyll, and water clarity measurements from the epi_nutr table.
#'     \item "deposition" - all atmospheric deposition variables from the .chag tables
#'     \item "hydrology" - baseflow, groundwater, runoff, and overland flow variables from the .chag tables
#'     \item "climate" - 30-year normal precipitation and temperature variables from the .chag tables
#'     \item "geology" - all surficial geology variables from the .chag tables
#'     \item "topography" - Terrain Roughness Index and slope variables from the .lulc tables
#'     \item "lulc1992" - all 1992 land use/land cover variables from the .lulc tables
#'     \item "lulc2001" - all 2001 land use/land cover variables from the .lulc tables
#'     \item "lulc2006" - all 2006 land use/land cover variables from the .lulc tables
#'     \item "lulc2011" - all 2011 land use/land cover variables from the .lulc tables
#'     \item "lakes" - all lake connectivity metrics from the .conn tables
#'     \item "wetlands" - all wetland connectivity metrics from the .conn tables
#'     \item "streams" - all stream/river connectivity metrics from the .conn tables
#' }
#' @export
#' @importFrom stats setNames
#' @examples \dontrun{
#' dt <- lagosne_load("1.087.3")
#'
#' # specific variables
#' head(lagosne_select(table = "epi_nutr", vars = c("tp", "tn")))
#' head(lagosne_select(table = "iws.lulc", vars = c("iws_nlcd2011_pct_95")))
#'
#' # categories
#' head(lagosne_select(table = "epi_nutr", categories = "waterquality"))
#' head(lagosne_select(table = "county.chag", categories = "hydrology"))
#' head(lagosne_select(table = "hu4.chag", categories = "deposition"))
#'
#' # mix of specific variables and categories
#' head(lagosne_select(table = "epi_nutr", vars = "lagoslakeid", categories = c("waterquality")))
#'
#' }

lagosne_select <- function(table = NULL, vars = NULL, categories = NULL,
                         dt = lagosne_load(lagosne_version())){

  # sanitize inputs ####
  is_not_char_args <- c(!(is.null(table) | is.character(table)),
                        !(is.null(vars) | is.character(vars)),
                        !(is.null(categories) | is.character(categories)))
  is_not_char_args <- setNames(is_not_char_args,
                               c("table", "vars", "categories"))

  if(any(is_not_char_args)){
    stop(paste0("'", names(which(is_not_char_args)),
                "' must be entered as a character string"))
  }

  is_vars_empty       <- is.null(vars)
  is_categories_empty <- is.null(categories)

  if(length(table) > 1){
    stop("Can only select from a single table at a time")
  }
  # if all are empty throw error or return all of dt?
  # if(all(is_vars_empty, is_categories_empty, is_scales_empty)){
  #   return(dt)
  # }

  available_vars <- names(dt[[table]])

  if(!is_categories_empty){
    category_vars <- expand_categories(categories, available_vars)
    vars <- c(vars, category_vars)
  }

  vars_dont_exist <- !(vars %in% available_vars)

  if(any(vars_dont_exist)){
    warning(paste0("The '", table, "' table does not contain a '",
                paste(vars[vars_dont_exist], collapse = ", or "), "' column!"))
  }

  vars <- vars[!vars_dont_exist]



  # select from dt ####
  res <- data.frame(dt[[table]][,vars])
  names(res) <- vars
  res
}


# given a list of categories return all vars in lagos that grep to their partial key value
expand_categories <- function(categories, available_vars){
  categories_dont_exist <- !(categories %in% keyword_partial_key()$keyword) &
    !(categories %in% keyword_full_key()$keyword)

  if(any(categories_dont_exist)){
    stop(paste0("The '", categories[categories_dont_exist],
                "' category does not exist!"))
  }

  key_subset <- unlist(lapply(
    categories,
    function(x) keyword_partial_key()[
      grep(x, keyword_partial_key()[,1]), "definition"]
    ))

  key_full   <- unlist(lapply(
    categories,
    function(x) keyword_full_key()[
      grep(x, keyword_full_key()[,1]), "definition"]))

  if(length(key_subset) > 0){
    key_subset <- unlist(lapply(
      key_subset,
      function(x) available_vars[grep(x, available_vars)]))

    key_full <- c(key_full, key_subset)
  }

key_full
}
