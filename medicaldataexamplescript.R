library("jsonlite")
library("xlsx")
library("tm")
library("SnowballC")
library("wordcloud")
library("RColorBrewer")

# Save data from a JSON file
setwd("C:/")
json_file <- "https://raw.githubusercontent.com/LasseRegin/medical-question-answer-data/master/questionDoctorQAs.json"
json_data <- fromJSON(json_file, flatten=TRUE)
write.xlsx(json_data$question_text, file = "medical_questions.xlsx")
write.table(json_data$question_text, file = "medical_questions.txt", append = FALSE, sep = " ", dec = ".",row.names = TRUE, col.names = TRUE)

# Open the file
text <- readLines(file.choose())
docs <- Corpus(VectorSource(text))
inspect(docs)

#Do some text cleaning

# Convert the text to lower case
docs <- tm_map(docs, content_transformer(tolower))
# Remove numbers
docs <- tm_map(docs, removeNumbers)
# Remove english common stopwords
docs <- tm_map(docs, removeWords, stopwords("english"))
# Remove your own stop word
# specify your stopwords as a character vector
docs <- tm_map(docs, removeWords, c("blabla1", "blabla2")) 
# Remove punctuations
docs <- tm_map(docs, removePunctuation)
# Eliminate extra white spaces
docs <- tm_map(docs, stripWhitespace)
# Text stemming
# docs <- tm_map(docs, stemDocument)

# Create term document matrix

dtm <- TermDocumentMatrix(docs)
m <- as.matrix(dtm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)
head(d, 10)


# Create a word cloud

set.seed(12)
wordcloud(words = d$word, freq = d$freq, min.freq = 1,
          max.words=200, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2"))