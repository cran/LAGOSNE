#'@name lagos_ingest
#'@title Ingest LAGOSNE flat files
#'@description Ingest LAGOSNE data from component flat files
#'@param version character LAGOSNE database version string
#'@param limno_folder file.path to limno export folder. optional.
#'@param geo_folder file.path to geo export folder. optional.
#'@param locus_folder file.path to locus export folder. optional.
#'@importFrom utils read.table
#'@importFrom progress progress_bar
#'@examples \dontrun{
#' lagos_ingest("1.087.3",
#'  limno_folder = "~/Downloads/LAGOS-NE-LIMNO-EXPORT",
#'  geo_folder   = "~/Downloads/LAGOS-NE-GEO-EXPORT",
#'  locus_folder = "~/Downloads/LAGOS-NE-LOCUS-EXPORT")
#'}
lagos_ingest <- function(version, limno_folder = NA, geo_folder = NA,
                         locus_folder = NA){

  pb <- progress::progress_bar$new(format = "  Reading :type [:bar]",
                         total = 9,
                         clear = FALSE)

  folder_version <- gsub("\\.", "", version)

  # Set-up paths ####
  limno_prefix <- paste0(limno_folder, "/")
  limno_path   <- function(fname){
                    paste0(limno_prefix,
                           fname, folder_version, ".csv")
                  }

  geo_prefix   <- paste0(geo_folder, "/", "LAGOSNE_")
  geo_path     <- function(fname, geo_prefix){
                    paste0(geo_prefix,
                    fname, "105.csv")
                  }

  locus_prefix <- paste0(locus_folder, "/", "LAGOSNE_")
  locus_path   <- function(fname){
                    paste0(locus_prefix,
                    fname, "101.csv")
                  }

  # Importing LAGOS limno data ####
  pb$tick(tokens = list(type = "limno data"))

  epi_nutr             <- load_lagos_txt(limno_path("epi_waterquality"),
                              sep = ",")
  epi_nutr$sampledate  <- as.Date(strptime(epi_nutr$sampledate,
                                           format = "%Y-%m-%d"))

  lakes_limno          <- read.csv(limno_path("lakeslimno"),
                                   stringsAsFactors = FALSE)
  lakes_limno$legacyid <-
    suppressWarnings(sapply(lakes_limno$legacyid, format_nonscientific))

  lagos_source_program <- load_lagos_txt(limno_path("sourceprogram"),
                                         sep = ",")

  limno <- list(epi_nutr = epi_nutr,
                lakes_limno = lakes_limno,
                lagos_source_program = lagos_source_program)

  # Importing Lagos Geo data ####
  lakes.geo <- load_lagos_txt(
                  geo_path("lakesgeo", paste0(geo_folder, "/", "LAGOSNE_")),
                  sep = ",")

  # Importing Lagos Geo county data
  pb$tick(tokens = list(type = "geo county data"))
  county       <- load_lagos_txt(geo_path("county_", geo_prefix),
                                 sep = ",")
  county.chag  <- load_lagos_txt(geo_path("county_chag", geo_prefix),
                                 sep = ",")
  county.conn  <- load_lagos_txt(geo_path("county_conn", geo_prefix),
                                 sep = ",")
  county.lulc  <- load_lagos_txt(geo_path("county_lulc", geo_prefix),
                                 sep = ",")

  # Importing Lagos Geo edu data
  pb$tick(tokens = list(type = "geo edu data"))
  edu          <- load_lagos_txt(geo_path("edu_", geo_prefix),
                                 sep = ",")
  edu.chag     <- load_lagos_txt(geo_path("edu_chag", geo_prefix),
                                 sep = ",")
  edu.conn     <- load_lagos_txt(geo_path("edu_conn", geo_prefix),
                                 sep = ",")
  edu.lulc     <- load_lagos_txt(geo_path("edu_lulc", geo_prefix),
                                 sep = ",")

  # Importing Lagos Geo huc4 data
  pb$tick(tokens = list(type = "geo huc4 data"))
  hu4          <- load_lagos_txt(geo_path("hu4_", geo_prefix),
                                 colClasses = c("hu4" = "factor"),
                                 sep = ",")
  hu4          <- pad_huc_ids(hu4, "hu4", 4)
  hu4.chag     <- load_lagos_txt(geo_path("hu4_chag", geo_prefix),
                                 sep = ",")
  hu4.conn     <- load_lagos_txt(geo_path("hu4_conn", geo_prefix), as.is = TRUE,
                                 sep = ",")
  hu4.lulc     <- load_lagos_txt(geo_path("hu4_lulc", geo_prefix), as.is = TRUE,
                                 sep = ",")

  # Importing Lagos Geo huc8 data
  pb$tick(tokens = list(type = "geo huc8 data"))
  hu8          <- load_lagos_txt(geo_path("hu8_", geo_prefix),
                                 colClasses = c("hu8" = "factor"),
                                 sep = ",")
  hu8          <- pad_huc_ids(hu8, "hu8", 8)
  hu8.chag     <- load_lagos_txt(geo_path("hu8_chag", geo_prefix), as.is = TRUE,
                                 sep = ",")
  hu8.conn     <- load_lagos_txt(geo_path("hu8_conn", geo_prefix), as.is = TRUE,
                                 sep = ",")
  hu8.lulc     <- load_lagos_txt(geo_path("hu8_lulc", geo_prefix), as.is = TRUE,
                                 sep = ",")

  # Importing Lagos Geo huc12 data
  pb$tick(tokens = list(type = "geo huc12 data"))
  hu12         <- load_lagos_txt(geo_path("hu12_", geo_prefix),
                                 colClasses = c("hu12" = "factor"),
                                 sep = ",")
  hu12          <- pad_huc_ids(hu12, "hu12", 12)
  hu12.chag    <-  load_lagos_txt(geo_path("hu12_chag", geo_prefix),
                                  as.is = TRUE, sep = ",")
  hu12.conn    <-  load_lagos_txt(geo_path("hu12_conn", geo_prefix),
                                  as.is = TRUE, sep = ",")
  hu12.lulc    <-  load_lagos_txt(geo_path("hu12_lulc", geo_prefix),
                                  as.is = TRUE, sep = ",")

  # Importing Lagos Geo iws data
  pb$tick(tokens = list(type = "geo iws data"))
  iws          <- load_lagos_txt(geo_path("iws_", geo_prefix),
                                 sep = ",")
  iws.conn     <- load_lagos_txt(geo_path("iws_conn", geo_prefix),
                                 sep = ",")
  iws.lulc     <- load_lagos_txt(geo_path("iws_lulc", geo_prefix),
                                 sep = ",")

  # Importing Lagos Geo state data
  state        <- load_lagos_txt(geo_path("state_", geo_prefix),
                                 sep = ",")
  state.chag   <- load_lagos_txt(geo_path("state_chag", geo_prefix),
                                 sep = ",")
  state.conn   <- load_lagos_txt(geo_path("state_conn", geo_prefix),
                                 sep = ",")
  state.lulc   <- load_lagos_txt(geo_path("state_lulc", geo_prefix),
                                 sep = ",")

  # Importing lake buffer data ####
  pb$tick(tokens = list(type = "geo buffer data"))
  buffer100m      <- load_lagos_txt(geo_path("buffer100m_", geo_prefix),
                                    sep = ",")
  buffer100m.lulc <- load_lagos_txt(geo_path("buffer100m_lulc", geo_prefix),
                                    sep = ",")
  buffer500m      <- load_lagos_txt(geo_path("buffer500m_", geo_prefix),
                                    sep = ",")
  buffer500m.conn <- load_lagos_txt(geo_path("buffer500m_conn", geo_prefix),
                                    sep = ",")
  buffer500m.lulc <- load_lagos_txt(geo_path("buffer500m_lulc", geo_prefix),
                                    sep = ",")

  geo <- list(county = county,
              county.chag = county.chag,
              county.conn = county.conn,
              county.lulc = county.lulc,
              edu = edu,
              edu.chag = edu.chag,
              edu.conn = edu.conn,
              edu.lulc = edu.lulc,
              hu4 = hu4,
              hu4.chag = hu4.chag,
              hu4.conn = hu4.conn,
              hu4.lulc = hu4.lulc,
              hu8 = hu8,
              hu8.chag = hu8.chag,
              hu8.conn = hu8.conn,
              hu8.lulc = hu8.lulc,
              hu12 = hu12,
              hu12.chag = hu12.chag,
              hu12.conn = hu12.conn,
              hu12.lulc = hu12.lulc,
              iws = iws,
              iws.conn = iws.conn,
              iws.lulc = iws.lulc,
              state = state,
              state.chag = state.chag,
              state.conn = state.conn,
              state.lulc = state.lulc,
              buffer100m = buffer100m,
              buffer100m.lulc = buffer100m.lulc,
              buffer500m = buffer500m,
              buffer500m.conn = buffer500m.conn,
              buffer500m.lulc = buffer500m.lulc,
              lakes.geo = lakes.geo)

  # Importing Lagos Locus data ####
  pb$tick(tokens = list(type = "lake locus data"))
  locus <- load_lagos_txt(locus_path("lakeslocus"), sep = ",")

  list("limno" = limno, "geo" = geo, "locus" = locus)
  }
