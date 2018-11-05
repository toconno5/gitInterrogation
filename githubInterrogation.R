library(jsonlite)
library(httpuv)
library(httr)

#Interrogates github
oauth_endpoints("github")

#Change based on what you 
myapp <- oauth_app(appname = "gitInterrogation",
                   key = "13be9ef2c3fd7874d6b7",
                   secret = "eac1a3a55bab0b0d4a2f85356a795fc851be9137")

# Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

# Use API
gtoken <- config(token = github_token)
req <- GET("https://api.github.com/users/jtleek/repos", gtoken)

# Take action on http error
stop_for_status(req)

# Extract content from a request
json1 = content(req)

# Convert to a data.frame
gitDF = jsonlite::fromJSON(jsonlite::toJSON(json1))

# Subset data.frame
gitDF[gitDF$full_name == "jtleek/datasharing", "created_at"] 

#above code sourced from https://towardsdatascience.com/accessing-data-from-github-api-using-r-3633fb62cb08

#Interrogate the Github API to extract data from my own github account
myData = fromJSON("https://api.github.com/users/toconno5")
myData$followers #dispalys number of followers
myData$following #displays number of people I am following
myData$public_repos #displays the number of repositories I have
myData$bio #Displays my bio

#Interrogate the Github API to extract data from another account by switching the username
kennyc11Data = fromJSON("https://api.github.com/users/kennyc11")
kennyc11Data$followers
kennyc11Data$following 
kennyc11Data$public_repos 
kennyc11Data$bio 
