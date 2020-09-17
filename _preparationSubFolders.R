# initial notes
#   Following steps
#     are made based on assumption that the most important is to have correctly connected links in a navigation bar,
#     don't focus on other links that links to the navigation bar (even index.html contains a link to this .html file in a subfolder).
#     don't focus on using .css file.

# step 1 - build a basic workflowr web pages
base::setwd("D:/Cloud/Sync/Study/Programming/R/Work/Projects/GitHub")
workflowr::wflow_start("workflowrSubfolders")
workflowr::wflow_build()


# step 2 - prepare subfolders and their content
base::dir.create("./docs/subPages")
base::file.copy("./docs/site_libs", "./docs/subPages", recursive = T)  # to keep a correct format without editing links at the beginning of new generate .html file(s) from a sub folder
base::dir.create("./analysis/subPages")
base::file.copy("./analysis/_site.yml", "./analysis/subPages")
# manual step - create file "aboutSubPages.Rmd" into created folder "./analysis/subPages"

# It’s possible to render files also in subfolders (of folder “docs”) if:  [literature: file "R Markdown websites.docx" -> subtitle 2.4.1]
#   it's done by folder by folder (subfolder by subfolder) and
#   this subfolder contains files "_site.yml" and (any) "index.rmd" regardless of links to files written in "_site.yml".
base::file.copy("./analysis/index.Rmd", "./analysis/subPages")  # index.html file has to exist otherwise: Error in rmarkdown::render_site("./analysis/subPages") : No site generator found.

# the following code returns error:
#   Only files in the analysis directory can be built with wflow_build.
#     Use `rmarkdown::render` to build non-workflowr files.
#   workflowr::wflow_build(files = "./analysis/subPages/aboutSubPages.Rmd")

# Because of previous error, edit ./analysis/subPages/_site.yml
#   output_dir: ../docs     ->  output_dir: "."

# For more precise (easier) replacements (see below) also edit in ./analysis/subPages/_site.yml links to .html files, in this case edit:
# index.html    ->  indexTemp.html
# about.html    ->  aboutTemp.html
# license.html  ->  licenseTemp.html


# step 3 - prepare a required .html file in folder ./docs/subPages
base::setwd("./analysis/subPages")
rmarkdown::render_site()
base::file.remove(c("index.Rmd", "index.html"))
base::unlink("site_libs", recursive = T)  # it's created by render_site() and it's not needed
base::setwd("../../")  # to be in more correct folder for better orientation
base::file.copy("./analysis/subPages/aboutSubPages.html", "./docs/subPages", overwrite = T)

# step 4 - edit .html file(s) pasted in ./docs/subPages e.g. using "Find and Replace.exe"
#   edit "*Temp.html" files defined in "./analysis/subPages/_site.yml", in this case edit:
#     "indexTemp.html" to "../index.html"
#     "aboutTemp.html" to "../about.html"
#     "licenseTemp.html" to "../license.html"

# step 5 - create connections to new .html file(s) in subfolder(s)
# e.g. add to ./analysis/index.Rmd following text:
# Link to [aboutSubPages](./subPages/aboutSubPages.html).

# rebuild if necessary, in this case
workflowr::wflow_build("./analysis/index.Rmd")

# step 6 - commit/publish/push
workflowr::wflow_publish(".", "commit text: initial publish")  # 1stly ensure that correct working directory is set
