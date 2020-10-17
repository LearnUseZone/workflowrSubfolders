#' @title Render .html files from their original .Rmd files stored in subdirectories
#' @description
#' Similarly as for workflowr package, when specifying path to folders or files in function generate_subdir(), you can start by typing folder name, so for example, you can write "analysis" instead of "./analysis".
#' Processed steps:
#' 1. Check existence of .Rmd file in a chosen subdirectory.
#' - If it doesn't exist, inform about it and stop processing.
#' 2. Prepare temporary file names by substitution  of "/" in file path by "&#8208;&#8208;".
#' 3. Function generate_rmd() is used to generate temporary .Rmd files from their original .Rmd files that are saved in subdirectories and save them into directory "analysis".
#' 4. If commit = TRUE, create a commit of these temporary .Rmd files with text "separate commit of temporary .Rmd files".
#' 5. Generate .html files from temporary .Rmd files.
#'    - So the resulting .html files are associated with their original .Rmd files (temporary .Rmd files are simply product of a helping step).
#' 6. Delete temporary .Rmd files from directory "analysis".
#' @param dir
#' character (default: "codeRmd").
#' Path to a directory, under a main workflowr subdirectory, where original Rmd files are saved.
#' @param file_path
#' character (default: NULL).
#' Vector of paths to original .Rmd files. These file paths start with a name of the 1st subdirectory of a directory specified in variable "dir".
#' Example when directories subPagesX are saved in folder dir = "codeRmd": file_path = c("subPages2/testPrint2.Rmd", "subPages3/testPrint3.Rmd")
#' @param commit
#' character (default: FALSE).
#' commit = TRUE creates a separate commit of temporary .Rmd files (temporary saved in directory "analysis").
#' Suggestion: Use commit = TRUE only after your original .Rmd files saved in subdirectories are tested properly and so are completely ready, otherwise you could have pointlessly many commits.
#' @keywords workflowr, subdirectory
#' @return <return>
#' @export generate_subdir
#' @examples
#' \dontrun{
#'   generate_subdir("codeRmd", c("subPages1/testPrint1.Rmd", "subPages2/testPrint2.Rmd"), T)
#' }

generate_subdir <- function(dir = "codeRmd", file_path = NULL, commit = F) {
  base::setwd(here::here())          # set workflowr project directory as a working directory (just in case it's not set already)
  if (base::is.null(file_path)) {
    file_path <- base::list.files(    # generate paths (not only file names) to .Rmd files in subdirectories under directory in parameter "dir"
      dir,
      recursive = T,
      include.dirs = T,
      pattern = "./*.(r|R)md"
    )
  }

  # check existence of files manually specified in variable "files"
  else {
    for (file in file_path) {
      path <- base::file.path(dir, file)
      if (!base::file.exists(path))
        stop(base::paste0("File doesn't exist: ", path))      # if a file doesn't exist a message is written and code stops
    }
  }

  temp_file <- base::gsub("/", "--", file_path)               # change "/" in paths to .Rmd files to generate file names (not paths) with "--", these are new file names of .Rmd files that will be generated in directory "analysis"
  temp_file_path <- base::file.path("analysis", temp_file)    # paths to temporary .Rmd files that will be also deleted after .html files are rendered from them
  base::file.remove(base::file.path("analysis", dir(path = "analysis", pattern = ".*\\-\\-.*.Rmd")))  # ensure that there are no temporary .Rmd files in directory "analysis" otherwise you may receive message like following one after trying to run function wflow_git_commit(...): Error: Commit failed because no files were added. Attempted to commit the following files: (list of file paths) Any untracked files must manually specified even if `all = TRUE`.

  base::mapply(generate_rmd, dir, file_path, temp_file)       # generate temporary .Rmd files
  if (commit == T) {
    workflowr::wflow_git_commit("analysis/*--*Rmd", "separate commit of temporary .Rmd files", all = T)
  }
  workflowr::wflow_build(temp_file_path)  # generate .html files from temporary .Rmd files
  base::file.remove(temp_file_path)       # delete temporary .Rmd files from directory "analysis"
}
