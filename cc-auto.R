#ccautomate
library(stringr)
library(lubridate)
library(newsanchor)
library(rlist)
library(taskscheduleR)

Sys.setenv(CC ="C:\\Users\\mds-nuc\\Documents\\GitHub\\CountCapture\\cc")
NewsAPI_key <- "XXXXX"
pol_c <- c("Biden","Buttigieg","Sanders","Warren", "Klobuchar", "Bloomberg","Steyer", "Yang", "Bennet", "Sestak")

countcapture <- function(day_ = Sys.Date() - days(1), account_type = "developer") {
  output <- lapply(pol_c, function(pol) {
    polpull <- get_everything(qInTitle = pol,
                              from = day_, to = day_,
                              language = "en", sort_by = "popularity",
                              api_key = NewsAPI_key)
    if (polpull$metadata$status_code != 200) {stop(paste("Error:", polpull$metadata$status_code, "during candidate:", pol))}
    if (account_type != "developer"){
      if (polpull$metadata$total_results > 100) {
        times <- ceiling((polpull$metadata$total_results)/100)
        for (i in 2:length(times)){
          polpull <- list.rbind(polpull, get_everything(qInTitle = pol,
                                                        from = day_, to = day_,
                                                        language = "en", sort_by = "popularity",
                                                        page = i, api_key = NewsAPI_key)
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
#Countcapture day
ccday <- Sys.Date() - days(1)
capture <- countcapture()
#save file
filename <- file.path(Sys.getenv("CC"), paste0('cc', ccday, '.Rdata'))
save(capture, file = filename)


# The below method I'm not into right now. I need to learn how to store data better first.
#
# mediapath <- "C:/Users/mds-nuc/Documents/GitHub/Portfolio/Part 1- Media Monitoring/countcapture/media.Rdata"
# load(mediapath)
# media[[as.character(ccday)]] <- countcapture(day_ = ccday)
# save(media, file = mediapath)
