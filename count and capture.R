---
title: "Media Monitoring of the 2020 Democratic Primaty Race"
  date: Sys.Date()
  output:
    html_document:
---
```{r setup}
library(stringr)
library(lubridate)
library(newsanchor)
library(rlist)
usethis::edit_r_environ()
#list of candidates and their names. 
# Having names don't occur often but I'm not sure if the keyword function checks article body too.
```
```{r example, eval=FALSE}
Biden <- get_everything(qInTitle = "Biden",
                        from = Sys.Date() - days(1),
                        to = Sys.Date() - days(1),
                        language = "en")
Biden
```
We make the cutoff of 100 results per query useful by sorting by popularity.
```{r cc}
pol_c <- c("Biden","Buttigieg","Sanders","Warren", "Klobuchar", "Bloomberg","Steyer", "Yang", "Bennet", "Sestak")

countcapture <- function(day_ = Sys.Date() - days(1), account_type = "developer") {
  output <- lapply(pol_c, function(pol) {
    polpull <- get_everything(qInTitle = pol,
                              from = day_, to = day_,
                              language = "en", sort_by = "popularity")
    if (polpull$metadata$status_code != 200) {stop(paste("Error:", polpull$metadata$status_code, "during candidate:", pol))}
    if (account_type != "developer"){
      if (polpull$metadata$total_results > 100) {
        times <- ceiling((polpull$metadata$total_results)/100)
        for (i in 2:length(times)){
          polpull <- list.rbind(polpull, get_everything(qInTitle = pol,
                                                        from = day_, to = day_,
                                                        language = "en", sort_by = "popularity",
                                                        page = i)
          )
        }
      }
      
    }
    polpull
  }
  )
  #finalizing output
  names(output) <- pol_c
  output
}
```

```{r testinggrounds}
#test
cc <- countcapture(day_ = '2020-01-26')
cc2 <- countcapture(day_ = "2020-01-27")
cc3 <- countcapture(day_ = "2020-01-28")
cc4 <- countcapture(day_ = "2020-01-29")
cc5 <- countcapture(day_ = "2020-01-30")
cc6 <- countcapture(day_ = "2020-01-31")

superMap <- function(...) {

}

daymerge <- Map(c, cc, cc2)
daymerge <- Map(c, daymerge, cc3,cc4,cc5,cc6)

save(daymerge, file = january_cc)

cc0201 <- countcapture(day_ = "2020-02-01")


#FEBRUARY
for (i in 1:24) {
  capture <- countcapture(day_ = paste0("2020-02-", i))
  febmerge <- lapply(capture, function(pol) {
    Map(c, febmerge[[pol]], capture[[pol]])
  })
}
#MARCH
marchget <- function(){
  lastday <- Sys.Date() - days(1)
for (i in lastday:5) {
  capture <- countcapture(day_ = paste0("2020-03-", i))
  febmerge <- lapply(capture, function(pol) {
    Map(c, febmerge[[pol]], capture[[pol]])
  })
}
}
march <- marchget()

t_cc <- get_everything(qInTitle = "Trump",
                                  from = '2020-02-02', to = '2020-02-02',
                                  language = "en", sort_by = "popularity")
save(t_cc, file ="~/GitHub/Portfolio/Part 1- Media Monitoring/trump02-02.Rdata")
```
