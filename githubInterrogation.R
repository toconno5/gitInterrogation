#install.packages("jsonlite")
library(jsonlite)
#install.packages("httpuv")
library(httpuv)
#install.packages("httr")
library(httr)

# Can be github, linkedin etc depending on application
oauth_endpoints("github")
# Change based on what your application is

# Change based on what you 
myapp <- oauth_app(appname = "gitInterrogation",
                  key = "b8e681e367792e61c7cb",
                 secret = "03aef5aadcba1e164865cedc44f3c6f4fb35d3d5")

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

#gets my data 
myData = fromJSON("https://api.github.com/users/toconno5")

#displays number of followers
myData$followers

followers = fromJSON("https://api.github.com/users/toconno5/followers")
followers$login #gives user names of all my followers

myData$following #displays number of people I am following

following = fromJSON("https://api.github.com/users/toconno5/following")
following$login #gives the names of all the people i am following

myData$public_repos #displays the number of repositories I have

repos = fromJSON("https://api.github.com/users/toconno5/repos")
repos$name #Details of the names of my public repositories
repos$created_at #Gives details of the date the repositories were created 
repos$full_name #gives names of repositiories

myData$bio #Displays my bio

lcaRepos <- fromJSON("https://api.github.com/repos/toconno5/LCA/commits")
lcaRepos$commit$message #The details I included describing each commit to LCA assignment repository 

#Interrogate the Github API to extract data from another account by switching the username
kennyc11Data = fromJSON("https://api.github.com/users/kennyc11")
kennyc11Data$followers #lists the number of followers kennyc11 has
kennyc11Data$following #lists the number of people kennyc11 is following
kennyc11Data$public_repos #lists the number of repositories they have
