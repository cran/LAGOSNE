% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/load.R
\name{lagosne_load}
\alias{lagosne_load}
\title{Load LAGOSNE data}
\usage{
lagosne_load(version = NULL, fpath = NA)
}
\arguments{
\item{version}{character LAGOSNE database version string. Defaults to \code{\link{lagosne_version}}}

\item{fpath}{file.path optionally specify custom location of LAGOSNE rds file}
}
\description{
Load LAGOSNE data from local system files
}
\examples{
\dontrun{
dt  <- lagosne_load("1.087.3")
}
}
