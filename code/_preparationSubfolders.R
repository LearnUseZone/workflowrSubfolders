# 20-09-26
# Additional information is in [lit 1]
# ----


# step 1 - ensure that index.html is already created in folder "docs" (using workflowr::wflow_build())
#   - otherwise you can receive error like follows:
#   Error in wflow_view(index, project = project) :
#     No HTML files were able to viewed.  Try running
#   `wflow_build()` first.
#   In addition: Warning message:
#     In wflow_view(index, project = project) :
#
#     Error in wflow_view(index, project = project) :
#     No HTML files were able to viewed.  Try running
#   `wflow_build()` first.

# step 2 - create suitable subfolders
#  Folder "workflowr project directory/code": This directory is for code that might not be appropriate to include
#    in R Markdown format (e.g. for pre-processing the data, or for long-running code). [lit 2]
#    For organizational purposes: don't write save .Rmd files here, create suitable subfolders here. [me]
#  Create "workflowr project directory/codeRmd" folder (with further additional subfolder names that are same as "workflowr project directory/code" subfolder names)
#    for .Rmd files associated to files within relevant "workflowr project directory/code" subfolders. [me]
#    Important: Don't use "analysis/codeRmd" otherwise following error pops-up when using workflowr::wflow_publish(...)
#      Error in to_html(files_analysis, outdir = o$docs) : Invalid file extension

# step 3 - ensure that ./analysis is the working directory

# step 4 - execute generate_rmd() and wflow_build_dir() that are edited codes from [lit 3a]
# generate temporary .Rmd files from original .Rmd files (saved in subfolders) into folder "analysis"
generate_rmd <- function(path, alias, dir) {
  relPath <- file.path(".", dir, path)                     # relative path to an original .Rmd file that will be rendered to .html file inside function wflow_build_dir(), "." is used for setting a correct path in parameter "child" of "r chunk" below
  base::cat(
    "---\n",
    yaml::as.yaml(rmarkdown::yaml_front_matter(relPath)),  # YAML header from an original .Rmd file
    "---\n\n",
    "**Source file:** ", file.path(dir, path),             # link to original .Rmd file from workflowr subdirectory
    "\n\n",

    # r chunk code (not YAML header)
    "```{r child = file.path(knitr::opts_knit$get(\"output.dir\"), \".", relPath, "\")}\n```",  # [lit 4]; ...\".",... - this dot is REQUIRED here because knitr::opts_knit$get(\"output.dir\") returns "analysis" as output directory in this case so "child" parameter of "r chunk" has to firstly go one directory up (relPath starts with "./")

    file = file.path("analysis", alias),             # a name of file that will be created
    sep = "",
    append = F                                             # overwrite a content of a file
  )
}

# render .html files from their original .Rmd files stored in subdirectories
wflow_build_dir <- function(files = NULL, dir = "codeRmd", commit = F, ...) {
  setwd(here::here())           # set workflowr project directory as a working directory (just in case it's not set already)
  if (base::is.null(files)) {
    files <- list.files(        # generate paths (not only file names) to .Rmd files in subfolders under folder in parameter "dir"
      dir,
      recursive = T,
      include.dirs = T,
      pattern = "./*.(r|R)md"
    )
  }
  # currently not used
  # else {
  #   for (file in files) {
  #     path<-base::paste0(dir, "/", file)
  #     if (!file.exists(paste0('../', path)))
  #       stop(base::paste0("File doesn't exist: ./", path))
  #   }
  # }

  file_aliases <- base::gsub("/", "--", files)           # change "/" in paths to .Rmd files to generate file names (not paths) with "--", these are new file names of .Rmd files that will be generated in folder "analysis"
  base::mapply(generate_rmd, files, file_aliases, dir)   # generate temporary .Rmd files

  file_aliasesPath <- paste0("analysis/", file_aliases)  # paths to temporary .Rmd files that will be also deleted after .html files are rendered from them
  if (commit == T) {
    workflowr::wflow_git_commit("analysis/*--*Rmd", "commit new .Rmd files from subfolders separately", all = T)
    ###workflowr::wflow_publish("analysis/*--*Rmd", "commit new .Rmd files from subfolders separately")
  }

  workflowr::wflow_build(files = file_aliasesPath)       # generate .html files from temporary .Rmd files
  base::invisible(file.remove(file_aliasesPath))         # delete temporary .Rmd files from folder "analysis"


  # parameters
  # dir - a directory in workflowr project directory; it can contain also subfolders
  # commit - TRUE = commit of temporary .Rmd files will be made; choose this commit after these temporary .Rmd files are completely ready
}


# step 5 - execute wflow_build_dir()
wflow_build_dir(commit = F)

# step 6 - at this point
#   - folder "code" contains subfolders with (e.g.) development codes, ...
#   - folder "codeRmd" contains subfolders with .Rmd files associated with development codes, ...
#   - more efficient way (less manual work) of creating .html files is prepared in comparison with steps on 19-09-17
#     plus a potential problem with the workflowr reproducibility checks [lit 1a] is resolved.
#   - folder "docs" contains .html files created from .Rmd files from folder "codeRmd" but although I'd like to have them in an appropriate subfolders instead of using delimiters like "--"
#     (so maybe similar steps like on 19-09-17 in "step 4" and "step 5" should be applied), I will accept usage of these delimiters
#     because critical is to have perfectly organized .Rmd files rather than .html files and let workflowr to take care of these .html files.
#   - keep in mind to use correct hyperlinks to future .html files (this shouldn't be a problem)


print("stop")

# step 7 - commit/publish, push
 workflowr::wflow_publish(".", "changes related to better usage of cat() - uncommited check will be fixed later")
## workflowr::wflow_use_github("LearnUseZone", "workflowrSubfolders")    # choose 1 to create a remote repository automatically -> sign-in in loaded web browser to authenticate; choose 2 if a remote repository is already created
## workflowr::wflow_git_push()  # enter username and password (if SSH is not set)


# used literature
# [lit 1]  https://github.com/jdblischak/workflowr/issues/220
# [lit 1a] https://github.com/jdblischak/workflowr/issues/220#issuecomment-694924738
# [lit 2]  https://jdblischak.github.io/workflowr/articles/wflow-01-getting-started.html
# [lit 3]  https://github.com/jdblischak/workflowr/issues/95
# [lit 3a] https://github.com/jdblischak/workflowr/issues/95#issuecomment-360094662
# [lit 4]  https://github.com/jdblischak/workflowr/issues/111#issuecomment-407861132 - explanation of usage knitr::opts_knit$get("output.dir") for creating of a relative path in parameter "child"

