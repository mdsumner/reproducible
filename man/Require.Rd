% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/packages.R
\name{Require}
\alias{Require}
\title{Repeatability-safe install and load packages, optionally with specific versions}
\usage{
Require(
  packages,
  packageVersionFile,
  libPath = .libPaths()[1],
  install_githubArgs = list(),
  install.packagesArgs = list(),
  standAlone = FALSE,
  repos = getOption("repos"),
  forget = FALSE
)
}
\arguments{
\item{packages}{Character vector of packages to install via
\code{install.packages}, then load (i.e., with \code{library}). If it is
one package, it can be unquoted (as in \code{require})}

\item{packageVersionFile}{If provided, then this will override all \code{install.package}
calls with \code{versions::install.versions}}

\item{libPath}{The library path where all packages should be installed, and looked for to load
(i.e., call \code{library})}

\item{install_githubArgs}{List of optional named arguments, passed to \code{install_github}.}

\item{install.packagesArgs}{List of optional named arguments, passed to \code{install.packages}.}

\item{standAlone}{Logical. If \code{TRUE}, all packages will be installed and loaded strictly
from the \code{libPaths} only. If \code{FALSE}, all \code{.libPaths} will
be used to find the correct versions. This can be create dramatically faster
installs if the user has a substantial number of the packages already in their
personal library. In the case of \code{TRUE}, there will be a hidden file
place in the \code{libPath} directory that lists all the packages
that were needed during the \code{Require} call. Default \code{FALSE} to
minimize package installing.}

\item{repos}{The remote repository (e.g., a CRAN mirror), passed to either
\code{install.packages}, \code{install_github} or \code{installVersions}.}

\item{forget}{Internally, this function identifies package dependencies using a memoised
function for speed on reuse. But, it may be inaccurate in some cases,
if packages were installed manually by a user. Set this to \code{TRUE} to
refresh that dependency calculation.}
}
\description{
\lifecycle{maturing}
}
\details{
This is an "all in one" function that will run \code{install.packages} for
CRAN packages, \code{remotes::install_github} for \url{https://github.com/} packages and
will install specific versions of each package if there is a
\code{packageVersionFile} supplied. Plus, when \code{packages} is provided as
a character vector, or a \code{packageVersionFile} is supplied, all package
dependencies will be first assessed for \code{unique(dependencies)} so the
same package is not installed multiple times. Finally \code{library} is
called on the \code{packages}. If packages are already installed
(\code{packages} supplied), and their version numbers are exact (when
\code{packageVersionFile} is supplied), then the "install" component will be
skipped very quickly with a message.

\code{standAlone} will either put the \code{Require}d packages and their
dependencies \emph{all} within the libPath (if \code{TRUE}) or if
\code{FALSE} will only install packages and their dependencies that are
otherwise not installed in \code{.libPaths()}, i.e., the personal or base
library paths. Any packages or dependencies that are not yet installed will
be installed in \code{libPath}. Importantly, a small hidden file (named
\code{._packageVersionsAuto.txt}) will be saved in \code{libPath} that will
store the \emph{information} about the packages and their dependencies, even
if the version used is located in \code{.libPaths()}, i.e., not the
\code{libPath} provided. This hidden file will be used if a user runs
\code{pkgSnapshot}, enabling a new user to rebuild the entire dependency
chain, without having to install all packages in an isolated directory (as
does \pkg{packrat}). This will save potentially a lot of time and disk space,
and yet maintain reproducibility. \emph{NOTE}: since there is only one hidden
file in a \code{libPath}, any call to \code{pkgSnapshot} will make a snapshot
of the most recent call to \code{Require}.

To build a snapshot of the desired packages and their versions, first run
\code{Require} with all packages, then \code{pkgSnapshot}.
 If a \code{libPath} is used, it must be used in both functions.

This function works best if all required packages are called within one
\code{Require} call, as all dependencies can be identified together, and all
package versions will be saved automatically (with \code{standAlone = TRUE}
or \code{standAlone = FALSE}), allowing a call to \code{pkgSnapshot} when a
more permanent record of versions can be made.
}
\note{
This function will use \code{memoise} internally to determine the
  dependencies of all \code{packages}. This will speed up subsequent calls to
  \code{Require} dramatically. However, it will not take into account version
  numbers for this memoised step. If package versions are updated manually by
  the user, then this cached element should be wiped, using \code{forget =
  TRUE}.
}
\examples{
\dontrun{
# simple usage, like conditional install.packages then library
Require("stats") # analogous to require(stats), but slower because it checks for
                 #   pkg dependencies, and installs them, if missing
tempPkgFolder <- file.path(tempdir(), "Packages")

# use standAlone, means it will put it in libPath, even if it already exists
#   in another local library (e.g., personal library)
Require("crayon", libPath = tempPkgFolder, standAlone = TRUE)

# make a package version snapshot
packageVersionFile <- file.path(tempPkgFolder, ".packageVersion.txt")
pkgSnapshot(libPath=tempPkgFolder, packageVersionFile)

# confirms that correct version is installed
Require("crayon", packageVersionFile = packageVersionFile)

# Create mismatching versions -- desired version is older than current installed
# This will try to install the older version, overwriting the newer version
desiredVersion <- data.frame(instPkgs="crayon", instVers = "1.3.2", stringsAsFactors = FALSE)
write.table(file = packageVersionFile, desiredVersion, row.names = FALSE)
# won't work because newer crayon is loaded
Require("crayon", packageVersionFile = packageVersionFile)

# unload it first
detach("package:crayon", unload = TRUE)

# run again, this time, correct "older" version installs in place of newer one
Require("crayon", packageVersionFile = packageVersionFile)

# Mutual dependencies, only installs once -- e.g., httr
Require(c("cranlogs", "covr"), libPath = tempPkgFolder)
}

}
