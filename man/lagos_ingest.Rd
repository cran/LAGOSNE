% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ingest.R
\name{lagos_ingest}
\alias{lagos_ingest}
\title{Ingest LAGOSNE flat files}
\usage{
lagos_ingest(version, limno_folder = NA, geo_folder = NA, locus_folder = NA)
}
\arguments{
\item{version}{character LAGOSNE database version string}

\item{limno_folder}{file.path to limno export folder. optional.}

\item{geo_folder}{file.path to geo export folder. optional.}

\item{locus_folder}{file.path to locus export folder. optional.}
}
\description{
Ingest LAGOSNE data from component flat files
}
\examples{
\dontrun{
lagos_ingest("1.087.3",
 limno_folder = "~/Downloads/LAGOS-NE-LIMNO-EXPORT",
 geo_folder   = "~/Downloads/LAGOS-NE-GEO-EXPORT",
 locus_folder = "~/Downloads/LAGOS-NE-LOCUS-EXPORT")
}
}
