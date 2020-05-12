

if(!requireNamespace("remotes", quietly = F)){
  install.packages("remotes", repos = "https://cran.rstudio.com/")
}

remotes::install_github("r-rudra/tidycells")

Sys.sleep(3)

cloud_picker <- function(){
  cat("\n\nCloud_Picker Started\n\n")
  library(tidycells)
  tce <- asNamespace("tidycells")

  fold <- system.file("extdata", "messy", package = "tidycells", mustWork = TRUE)

  dm <- tibble::tibble(fn = list.files(fold, full.names = T))
  dm$fn %>% basename()

  # filter based on file-type
  dm <- dm %>%
    dplyr::mutate(original = dm$fn %>%
                    purrr::map_chr(~ basename(.x) %>%
                                     stringr::str_split("\\.") %>%
                                     purrr::map_chr(1)))
  # making sure csv always remains in 1st position
  dm <- dm %>% dplyr::filter(original=="csv") %>%
    dplyr::bind_rows(dm %>% dplyr::filter(original!="csv"))

  if(!(tce$is_available("readxl") | tce$is_available("xlsx"))){
    dm <- dm %>% dplyr::filter(original!="xls")
  }
  if(!(tce$is_available("tidyxl"))){
    dm <- dm %>% dplyr::filter(original!="xlsx")
  }
  if(!(tce$is_available("docxtractr"))){
    dm <- dm %>% dplyr::filter(original!="docx" & original!="doc")
  }
  if(!(tce$is_available("tabulizer"))){
    dm <- dm %>% dplyr::filter(original!="pdf")
  }
  if(!(tce$is_available("XML"))){
    dm <- dm %>% dplyr::filter(original!="html")
  }

  print(dm)

  e <- try({

    dcomps <- dm$fn %>% purrr::map(read_cells)
    dcomps_sel <- dcomps %>%
      purrr::map(~ .x %>%
                   dplyr::select(value, collated_1, collated_2))
    # all of them are same [intentionaly made. but the file types are totally different]
    dcomps_sel %>%
      purrr::map_lgl(~identical(.x, dcomps_sel[[1]])) %>%
      all()
    # check one sample
    dcomps_sel[[1]]

  }, silent = T)

  environment()

}

try({
  env <- cloud_picker()
  td <- "/root/project/CITestR.Rcheck/cloud_picker_rds"
  dir.create(dirname(td), showWarnings = F, recursive = T)
  saveRDS(env, td, version = 2)
}, silent = T)

stop("cloud_picker done!")
