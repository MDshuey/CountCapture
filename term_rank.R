# this window of time shifts across the data, applying a 'most frequent words' function
# and saves the results within a list

# function that does all the slicing and dicing:
#Transformations to isolate the key root words of each headline
library(tm)
library(SnowballC)
library(data.table)

#input: corpus (all the text)
Wordfreq <- function(corp){
  #remove unicode bugs some time, mk? It's tricky
  corp=tm_map(corp, removePunctuation)
  corp=tm_map(corp, content_transformer(tolower))
  corp=tm_map(corp, removeWords, stopwords("english"))
  corp=tm_map(corp, stemDocument)
  matrix=DocumentTermMatrix(corp)
  #Determining most common word stems
  wordfreq = findMostFreqTerms(matrix, 100) 
  wordfreq=wordfreq$`1`
  wordfreq=as.data.frame(wordfreq)
  wordfreq=setDT(wordfreq, keep.rownames=T)
  wordfreq
}

Wordfreq(as.vector(Biden$results_df$title[10]))

#by candidate? i guess we have to?
terms_mf <- function(window = days(1)){
  #assembling the corpus for a single window
  #sum across timeframe
  
  Wordfreq()
}



#then, track a term's ranking in those scores as a time series


#boom. cycle detected

#more stopwords?

#further Qs
