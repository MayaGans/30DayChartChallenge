all_sets <- read.csv("Data/setlists.csv") %>% 
  dplyr::group_by(Song) %>% 
  dplyr::slice(1) %>%
  dplyr::filter(Song %in% df$title) %>%
  dplyr::mutate(Date = lubridate::ymd(Date)) %>%
  dplyr::mutate(
    era = dplyr::case_when(
      Date < "2002-01-01" ~ "1.0",
      Date > "2009-01-01" ~ "3.0",
      TRUE ~ "2.0"
    )
  ) %>%
  dplyr::mutate(title = Song) %>%
  dplyr::select(title, era)

get_lengths <- function(x) {
  print(x)
  lastshow <- phishr::pi_get_shows(key, x)$set_list[[1]] %>%
    dplyr::select(title, set, duration) %>%
    as.data.frame()
}

sets <- c("2019-12-28","2019-12-29", "2019-12-30", "2019-12-31")
alldat <- purrr::map(sets, ~get_lengths(.x))

df <- do.call("rbind", alldat) %>%
  dplyr::mutate(set = ifelse(set == "E", "3", set)) %>%
  dplyr::mutate(
    length_grp = dplyr::case_when(
      duration < 5 ~ 1,
      duration >= 5 & duration <=10 ~ 2,
      duration >10 & duration <=15 ~ 3,
      duration >15 & duration <= 20 ~ 4,
      TRUE ~ 5,
    )
  ) %>%
  dplyr::left_join(all_sets) %>%
  dplyr::distinct() %>%
  dplyr::mutate(
    group = era,
    outline = length_grp
  ) %>%
  dplyr::select(group, outline, title)

# use this in Observable
jslonlite::toJSON(df)