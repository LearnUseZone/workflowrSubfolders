generate_rmd <- function(dir = "codeRmd", file_path = NULL, temp_file = NULL) {
  relPath <- base::file.path(".", dir, file_path)               # relative path to an original .Rmd file that will be rendered to .html file inside function wflow_build_dir(), "." is used for setting a correct path in parameter "child" of "r chunk" below
  base::cat(
    "---\n",
    yaml::as.yaml(rmarkdown::yaml_front_matter(relPath)),  # YAML header from an original .Rmd file
    "---\n\n",
    "**Source file:** ", base::file.path(dir, file_path),       # link to original .Rmd file from workflowr subdirectory
    "\n\n",

    # r chunk code (not YAML header)
    "```{r child = base::file.path(knitr::opts_knit$get(\"output.dir\"), \".", relPath, "\")}\n```",  # [lit 4]; ...\".",... - this dot is REQUIRED here because knitr::opts_knit$get(\"output.dir\") returns "analysis" as output directory in this case so "child" parameter of "r chunk" has to firstly go one directory up (relPath starts with "./")

    file = base::file.path("analysis", temp_file),  # a name of file that will be created
    sep = "",
    append = F                                      # overwrite a content of a file
  )
}


generate_subdir <- function(dir = "codeRmd", file_path = NULL, commit = F) {
  ## setwd(here::here())           # set workflowr project directory as a working directory (just in case it's not set already)
  if (base::is.null(file_path)) {
    file_paths <- list.files(        # generate paths (not only file names) to .Rmd files in subdirectories under directory in parameter "dir"
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
  file.remove(file.path("analysis", dir(path = "analysis", pattern = ".*\\-\\-.*.Rmd")))  # ensure that there are no temporary .Rmd files in directory "analysis" otherwise you may receive message like following one after trying to run function wflow_git_commit(...): Error: Commit failed because no files were added. Attempted to commit the following files: (list of file paths) Any untracked files must manually specified even if `all = TRUE`.

  base::mapply(generate_rmd, dir, file_path, temp_file)       # generate temporary .Rmd files
  if (commit == T) {
    workflowr::wflow_git_commit("analysis/*--*Rmd", "separate commit of temporary .Rmd files", all = T)
  }
  workflowr::wflow_build(temp_file_path)  # generate .html files from temporary .Rmd files
  file.remove(temp_file_path)             # delete temporary .Rmd files from directory "analysis"
}


generate_subdir(file_path = c("subPages1/testPrint1.Rmd"), dir = "codeRmd", commit = F)
