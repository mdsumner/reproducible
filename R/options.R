#' \code{reproducible} options
#'
#' These provide top-level, powerful settings for a comprehensive
#' reproducible workflow. To see defaults, run \code{reproducibleOptions()}.
#' See Details below.
#'
#' @export
#' @details
#'
#' Below are options that can be set with \code{options("reproducible.xxx" = newValue)},
#' where \code{xxx} is one of the values below, and \code{newValue} is a new value to
#' give the option. Sometimes these options can be placed in the user's \code{.Rprofile}
#' file so they persist between sessions.
#'
#' The following options are likely of interest to most users
#' \tabular{lcl}{
#'   \emph{OPTION} \tab \emph{DEFAULT VALUE} \tab \emph{DESCRIPTION} \cr
#'   \code{ask} \tab \code{TRUE} \tab Used in \code{\link{clearCache}} and
#'                                    \code{\link{keepCache}}\cr
#'   \code{cachePath} \tab \code{.reproducibleTempCacheDir}
#'                    \tab Used in \code{\link{Cache}} and many others.
#'                    The default path for repositories if not passed as an argument.\cr
#'   \code{cacheSaveFormat} \tab "rds" \tab What save format to use; currently,
#'                          "qs" or "rds" \cr
#'   \code{cacheSpeed} \tab "slow" \tab either "slow" or "fast" (1 or 2). "slow" uses
#'                        digest::digest internally, which is transferable across Operating
#'                        systems, but much slower than fastdigest::fastdigest. So,
#'                        if all caching is happening on a single machine, "fast" would
#'                        be a good setting \cr
#'   \code{conn} \tab \code{NULL} \tab Sets a specific connection to a database, e.g.,
#'                       \code{dbConnect(drv = RSQLite::SQLite())} or
#'                       \code{dbConnect(drv = RPostgres::Postgres()}. For remote
#'                       database servers, setting one connection may be far faster than using
#'                       \code{drv} which must make a new connection every time. \cr
#'   \code{destinationPath} \tab \code{NULL} \tab Used in \code{\link{prepInputs}},
#'                               \code{\link{preProcess}}. Can be set globally here. \cr
#'   \code{drv} \tab \code{RSQLite::SQLite()} \tab Sets the default driver for the backend
#'                       database system. Only tested with \code{RSQLite::SQLite()} and
#'                       \code{RPostgres::Postgres()} \cr
#'   \code{futurePlan} \tab \code{FALSE} \tab On Linux OSs, \code{Cache} and \code{cloudCache}
#'                          have some functionality that uses the \code{future} package.
#'                          Default is to not use these, as they are experimental. They may,
#'                          however, be very effective in speeding up some things, specifically,
#'                          uploading cached elements via googledrive in \code{cloudCache}\cr
#'   \code{inputPaths} \tab \code{NULL} \tab Used in \code{\link{prepInputs}},
#'                               \code{\link{preProcess}}. If set to a path, this
#'                               will cause these functions to save their downloaded
#'                               and preprocessed file to this location, with a hardlink
#'                               (via \code{file.link}) to the file
#'                               created in the \code{destinationPath}. This can be used
#'                               so that individual projects that use common data sets
#'                               can maintain modularity (by placing downloaded objects
#'                               in their \code{destinationPath}, but also minimize
#'                               re-downloading the same (perhaps large) file over and over
#'                               for each project. Because the files are hardlinks, there
#'                               is no extra space taken up by the apparently duplicated files.\cr
#'   \code{inputPathsRecursive} \tab \code{FALSE} \tab Used in \code{\link{prepInputs}},
#'                               \code{\link{preProcess}}. Should the \code{reproducible.inputPaths}
#'                               be searched recursively for existence of a file.\cr
#'   \code{nThreads} \tab \code{1} \tab The number of threads to use for reading/writing cache files.\cr
#'   \code{overwrite} \tab \code{FALSE} \tab Used in \code{\link{prepInputs}}, \code{\link{preProcess}},
#'                         \code{\link{downloadFile}}, and \code{\link{postProcess}}.\cr
#'   \code{quick} \tab \code{FALSE} \tab Used in \code{\link{Cache}}. This will cause
#'                 \code{Cache} to use \code{file.size(file)}
#'                 instead of the \code{digest::digest(file)}.
#'                 Less robust to changes, but faster. NOTE: this will only affect objects
#'                 on disk.\cr
#'   \code{showSimilar} \tab Passed to \code{Cache}. Default \code{FALSE}.\cr
#'   \code{useCache} \tab \code{TRUE} \tab Used in \code{\link{Cache}}. If \code{FALSE}, then
#'                         the entire \code{Cache} machinery is skipped and the functions
#'                         are run as if there was no Cache occurring. Can also take 2 other values:
#'                         \code{'overwrite'} and \code{'devMode'}. \code{'overwrite'} will
#'                         cause no recovery of objects from the cache repository, only new
#'                         ones will be created. If the hash is identical to a previous one,
#'                         then this will overwrite the previous one. \code{'devMode'} will
#'                         function as normally \code{Cache} except it will use the \code{userTags}
#'                         to determine if a previous function has been run. If the \code{userTags}
#'                         are identical, but the digest value is different, the old value will
#'                         be deleted from the cache repository and this new value will be added.
#'                         This addresses a common situation during the development stage: functions
#'                         are changing frequently, so any entry in the cache repository will
#'                         be stale following changes to functions, i.e., they will likely never
#'                         be relevant again. This will therefore keep the cache repository
#'                         clean of stale objects. If there is ambiguity in the \code{userTags},
#'                         i.e., they do not uniquely identify a single entry in the
#'                         \code{cacheRepo}, then this option will default back to the non-dev-mode
#'                         behaviour to avoid deleting objects.
#'                         This, therefore, is most useful if the user is using unique values for
#'                         \code{userTags}\cr
#'   \code{useCloud} \tab Passed to \code{Cache}. Default \code{FALSE}.\cr
#'   \code{useDBI} \tab \code{TRUE} \tab As of reproducible 0.3, the backend is now \pkg{DBI}
#'                      package instead of \pkg{archivist}\cr
#'   \code{useGDAL} \tab Passed to \code{useGDAL} in \code{projectInputs.Raster}.
#'                   Default \code{TRUE}.\cr
#'   \code{useMemoise} \tab \code{FALSE} \tab Used in \code{\link{Cache}}. If \code{TRUE},
#'                   recovery of cached elements from the \code{cacheRepo} will use
#'                   \code{memoise::memoise}. This means that the 3rd time running a function
#'                   will be much faster than the 1st (create cache entry) or 2nd (recover
#'                   from the SQLite database on dist). NOTE: memoised values are removed
#'                   when the R session is restarted. \strong{This option will use more RAM} and
#'                   so may need to be turned off if RAM is limiting.  \code{clearCache}
#'                   of any sort will cause all memoising to be 'forgotten'
#'                   (\code{memoise::forget})\cr
#'   \code{useNewDigestAlgorithm} \tab \code{TRUE} \tab This will mean that previous
#'                    cache repositories
#'                    will be defunct. This new algorithm will make \code{Cache} less
#'                    sensitive to minor but irrelevant changes (like changing the
#'                    order of arguments) and will work successfully across operating
#'                    systems (especially relevant for the new \code{cloudCache} function \cr
#'   \code{verbose} \tab \code{FALSE} \tab If set to \code{TRUE} then every Cache
#'      call will show a summary of the objects being cached, their \code{object.size}
#'      and the time it took to digest them and also the time it took to run
#'      the call and save the call to the cache repository or load the cached
#'      copy from the repository. This may help diagnosing some problems that may occur.\cr
#' }
#'
#' @section Advanced:
#' The following options are likely not needed by a user.
#' \tabular{lcl}{
#'   \code{cloudChecksumsFilename} \tab \code{file.path(dirname(.reproducibleTempCacheDir()), "checksums.rds")}
#'                      \tab Used in \code{\link{cloudCache}} \cr
#'   \code{length} \tab \code{Inf} \tab Used in \code{\link{Cache}}, specifically to the internal
#'                      calls to \code{\link{CacheDigest}}. This is passed to \code{digest::digest}.
#'                      Mostly this would be changed from default \code{Inf} if the digesting is
#'                      taking too long. Use this with caution, as some objects will have MANY
#'                      NA values in their first MANY elements\cr
#'   \code{useragent} \tab \code{"https://github.com/PredictiveEcology/reproducible"}
#'           \tab User agent for downloads using this package.\cr
#' }
reproducibleOptions <- function() {
  list( # nolint
    reproducible.ask = TRUE,
    reproducible.cachePath = .reproducibleTempCacheDir(),
    reproducible.cacheSaveFormat = "rds",
    reproducible.cacheSpeed = "slow",
    reproducible.conn = NULL,
    reproducible.destinationPath = NULL,
    reproducible.drv = RSQLite::SQLite(),
    reproducible.futurePlan = FALSE, #future::plan("multiprocess"), #memoise
    reproducible.inputPaths = NULL,
    reproducible.inputPathsRecursive = FALSE,
    reproducible.length = Inf,
    reproducible.nThreads = 1,
    reproducible.overwrite = FALSE,
    reproducible.quick = FALSE,
    reproducible.showSimilar = FALSE,
    reproducible.showSimilarDepth = 3,
    reproducible.tempPath = .reproducibleTempPath(),
    reproducible.useCache = TRUE, # override Cache function
    reproducible.useCloud = FALSE, #
    reproducible.useDBI = TRUE,
    reproducible.useGDAL = TRUE, #
    reproducible.useMemoise = FALSE, #memoise
    reproducible.useNewDigestAlgorithm = TRUE,
    reproducible.useragent = "https://github.com/PredictiveEcology/reproducible",
    reproducible.verbose = FALSE
  )
}
