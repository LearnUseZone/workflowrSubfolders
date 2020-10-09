#' @title Generate temporary .Rmd files
#' @description
#' This is one of functions serving as optional extension for workflowr package in order to be able to generate .html files from .Rmd files saved in subdirectories and not only in directory "analysis".
#' \code{generate_rmd} generates .Rmd files from original .Rmd files that are saved in subdirectories and save them into directory "analysis".
#' These generated .Rmd files are meant to be temporary and they will be deleted after \code{\link{generate_subdir}} generates final .html files.
#' If you want to use this function in other way than call it from \code{\link{generate_subdir}} then you have to set a correct workflowr project to be your working directory,
#' e.g. by running: setwd("D:/Cloud/Sync/Study/Programming/R/Work/Projects/GitHub/workflowrSubfolders")
#' example: #' generate_rmd("codeRmd", "subPages1/testPrint1.Rmd", "subPages1--testPrint1.Rmd")
#' @param dir
#' character (default: "codeRmd") path to a directory, under a main workflowr subdirectory, where an original Rmd file is saved.
#' @param path
#' character (default: NULL). Path to an original .Rmd file saved in a dir or in a dir's subdirectory.
#' @param temp_file
#' character (default: NULL).
#' Name ("--" is usually part of it's name) of a temporary .Rmd file that will be saved into directory "analysis".
#' This temporary file is generated from its original Rmd file specified in path, then it will be deleted within generate.subdir.
#' @keywords workflowr, subdirectory
#' @return <return>
#' @export generate_rmd
#' @examples
#' \dontrun{
#'   xxxgenerate_rmd("codeRmd", "subPages1/testPrint1.Rmd", "subPages1--testPrint1.Rmd")
#' }


# render .html files from their original .Rmd files stored in subdirectories
generate_subdir <- function(files = NULL, dir = "codeRmd", commit = F, ...) {
  setwd(here::here())           # set workflowr project directory as a working directory (just in case it's not set already)
  if (base::is.null(files)) {
    files <- list.files(        # generate paths (not only file names) to .Rmd files in subdirectories under directory in parameter "dir"
      dir,
      recursive = T,
      include.dirs = T,
      pattern = "./*.(r|R)md"
    )
  }

  # check existence of files manually specified in variable "files"
  else {
    for (file in files) {
      path <- base::file.path(dir, file)
      if (!base::file.exists(path))
        stop(base::paste0("File doesn't exist: ", path))  # if a file doesn't exist a message is written and code stops
    }
  }

  file_aliases <- base::gsub("/", "--", files)                                            # change "/" in paths to .Rmd files to generate file names (not paths) with "--", these are new file names of .Rmd files that will be generated in directory "analysis"
  file_aliasesPath <- base::file.path("analysis", file_aliases)                           # paths to temporary .Rmd files that will be also deleted after .html files are rendered from them
  file.remove(file.path("analysis", dir(path = "analysis", pattern = ".*\\-\\-.*.Rmd")))  # ensure that there are no temporary .Rmd files in directory "analysis" otherwise you may receive message like following one after trying to run function wflow_git_commit(...): Error: Commit failed because no files were added. Attempted to commit the following files: (list of file paths) Any untracked files must manually specified even if `all = TRUE`.

  base::mapply(generate_rmd, files, file_aliases, dir)                                    # generate temporary .Rmd files
  if (commit == T) {
    workflowr::wflow_git_commit("analysis/*--*Rmd", "separate commit of temporary .Rmd files", all = T)
  }
  workflowr::wflow_build(files = file_aliasesPath)  # generate .html files from temporary .Rmd files
  file.remove(file_aliasesPath)                     # delete temporary .Rmd files from directory "analysis"

  # input parameters
  # files = vector of paths to original .Rmd files; these paths start with a name of the 1st subdirectory of a directory specified in variable "dir"; example: files = c("subPages2/testPrint2.Rmd", "subPages3/testPrint3.Rmd")
  # dir - a directory in workflowr project directory; it can contain also subdirectories
  # commit - TRUE = commit of temporary .Rmd files will be made; choose this commit after these temporary .Rmd files are completely ready
}
