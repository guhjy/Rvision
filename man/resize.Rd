% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/geometry.R
\name{resize}
\alias{resize}
\title{Resize an \code{\link{Image}}}
\usage{
resize(image, height = NULL, width = NULL, fx = NULL, fy = NULL,
  interpolation = "linear")
}
\arguments{
\item{image}{An \code{\link{Image}} object.}

\item{height}{A positive integer representing the new height in pixels of the
image (default: NULL).}

\item{width}{A positive integer representing the new width in pixels of the
image (default: NULL).}

\item{fx}{A positive numeric representing the ratio by which the width of
the image must be resized (default: NULL). Ignored if \code{width} is set.}

\item{fy}{A positive numeric representing the ratio by which the height of
the image must be resized (default: NULL). Ignored if \code{height} is set.}

\item{interpolation}{A character string representing the type of interpolation
to use during resizing (default: "linear"). See notes for all accepted
interpolation methods.}
}
\value{
An \code{\link{Image}} object.
}
\description{
\code{resize} returns a resized version of an \code{\link{Image}}.
}
\note{
The following interpolation methods are supported:
 \itemize{
  \item{"nearest":}{nearest neighbor interpolation.}
  \item{"linear"}{bilinear interpolation.}
  \item{"cubic"}{bicubic interpolation.}
  \item{"area"}{resampling using pixel area relation.}
  \item{"Lanczos"}{Lanczos interpolation over 8x8 neighborhood.}
  \item{"exact"}{bit exact bilinear interpolation}
 }
}
\examples{
# TODO
}
\seealso{
\code{\link{Image}}
}
\author{
Simon Garnier, \email{garnier@njit.edu}
}
