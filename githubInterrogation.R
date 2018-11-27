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


#Part 2 - Visualisations

myData = GET("https://api.github.com/users/toconno5/followers?per_page=100;", gtoken)
stop_for_status(myData)
extract = content(myData)
#converts into dataframe
githubDB = jsonlite::fromJSON(jsonlite::toJSON(extract))
githubDB$login

# Retrieve a list of usernames
id = githubDB$login
user_ids = c(id)

# Create an empty vector and data.frame
users = c()
usersDB = data.frame(
  username = integer(),
  following = integer(),
  followers = integer(),
  repos = integer(),
  dateCreated = integer()
)

#loops through users and adds to list
for(i in 1:length(user_ids))
{

  followingURL = paste("https://api.github.com/users/", user_ids[i], "/following", sep = "")
  followingRequest = GET(followingURL, gtoken)
  followingContent = content(followingRequest)
  
  #Does not add users if they have no followers
  if(length(followingContent) == 0)
  {
    next
  }
  
  followingDF = jsonlite::fromJSON(jsonlite::toJSON(followingContent))
  followingLogin = followingDF$login
  
  #Loop through 'following' users
  for (j in 1:length(followingLogin))
  {
    #Check that the user is not already in the list of users
    if (is.element(followingLogin[j], users) == FALSE)
    {
      #Add user to list of users
      users[length(users) + 1] = followingLogin[j]
      
      #Retrieve data on each user
      followingUrl2 = paste("https://api.github.com/users/", followingLogin[j], sep = "")
      following2 = GET(followingUrl2, gtoken)
      followingContent2 = content(following2)
      followingDF2 = jsonlite::fromJSON(jsonlite::toJSON(followingContent2))
      
      #Retrieve each users following
      followingNumber = followingDF2$following
      
      #Retrieve each users followers
      followersNumber = followingDF2$followers
      
      #Retrieve each users number of repositories
      reposNumber = followingDF2$public_repos
      
      #Retrieve year which each user joined Github
      yearCreated = substr(followingDF2$created_at, start = 1, stop = 4)
      
      #Add users data to a new row in dataframe
      usersDB[nrow(usersDB) + 1, ] = c(followingLogin[j], followingNumber, followersNumber, reposNumber, yearCreated)
      
    }
    next
  }
  #Stop when there are more than 400 users
  if(length(users) > 400)
  {
    break
  }
  next
}

#Use plotly to graph
Sys.setenv("plotly_username"="toconno5")
Sys.setenv("plotly_api_key"="p8ytNJyBqfStHGdBUAxa")

plot1 = plot_ly(data = usersDB, x = ~repos, y = ~followers, 
                text = ~paste("Followers: ", followers, "<br>Repositories: ", 
                              repos, "<br>Date Created:", dateCreated), color = ~dateCreated)
plot1
