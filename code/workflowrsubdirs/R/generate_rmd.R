#' @title Generate temporary .Rmd files
#'
#' @description
#' This is one of functions serving as optional extension for workflowr package in order to be able to generate .html files from .Rmd files saved in subdirectories and not only in directory "analysis".
#' \code{generate_rmd} generates .Rmd files from original .Rmd files that are saved in subdirectories and save them into directory "analysis".
#' These generated .Rmd files are meant to be temporary and they will be deleted after \code{\link{generate_subdir}} generates final .html files.
#' If you want to use this function in other way than call it from \code{\link{generate_subdir}} then you have to set a correct workflowr project to be your working directory,
#' e.g. by running: setwd("D:/Cloud/Sync/Study/Programming/R/Work/Projects/GitHub/workflowrSubfolders")
#' @param dir
#' character (default: "codeRmd") path to a directory, under a main workflowr subdirectory, where an original Rmd file is saved.
#' @param path
#' character (default: NULL). Path to an original .Rmd file saved in a dir or in a dir's subdirectory.
#' @param temp_file
#' character (default: NULL).
#' Name ("--" is usually part of it's name) of a temporary .Rmd file that will be saved into directory "analysis".
#' This temporary file is generated from its original Rmd file specified in path, then it will be deleted within generate.subdir.
#' @keywords workflowr, subdirectory
#' @return
#' @export
#' @examples
#' generate_rmd("codeRmd", "subPages1/testPrint1.Rmd", "subPages1--testPrint1.Rmd")


#' https://www.youtube.com/watch?v=79s3z0gIuFU time 07:30 - 07:40 - upravim???
#' used literature: _preparationSubfolders.R


generate_rmd <- function(dir = "codeRmd", path = NULL, temp_file = NULL) {
  relPath <- base::file.path(".", dir, path)               # relative path to an original .Rmd file that will be rendered to .html file inside function wflow_build_dir(), "." is used for setting a correct path in parameter "child" of "r chunk" below
  base::cat(
    "---\n",
    yaml::as.yaml(rmarkdown::yaml_front_matter(relPath)),  # YAML header from an original .Rmd file
    "---\n\n",
    "**Source file:** ", base::file.path(dir, path),       # link to original .Rmd file from workflowr subdirectory
    "\n\n",

    # r chunk code (not YAML header)
    "```{r child = base::file.path(knitr::opts_knit$get(\"output.dir\"), \".", relPath, "\")}\n```",  # [lit 4]; ...\".",... - this dot is REQUIRED here because knitr::opts_knit$get(\"output.dir\") returns "analysis" as output directory in this case so "child" parameter of "r chunk" has to firstly go one directory up (relPath starts with "./")

    file = base::file.path("analysis", temp_file),  # a name of file that will be created
    sep = "",
    append = F                                      # overwrite a content of a file
  )
}
