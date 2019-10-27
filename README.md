# Fusion Asset Management for Windows
Here you will find the exported Fusion objects (data sources, pipelines, profiles, jobs, etc.) for each search environment (DEV, QA, PROD). A [PowerShell script](export-fusion-objects.ps1) to export them is included in the project. This script works with Fusion 4.2.x.

## Edit the PowerShell Script
Adjust the values for **$USER**, **$PASS**, **$PROJECT_HOME** and **$VERSION** with the values for your environment.
- `$USER = "admin"`

- `$PASS = "password123"`

- `$PROJECT_HOME = "C:\fusion\dev"`

- `$VERSION = "422"`

Then configure the values for each environment - **DEV**, **QA** and **PROD**.
- `$DEV_VERSION = $VERSION` - Inherit or hard set the version for each environment

- `$DEV_HOSTNAME = "search-dev.company.com"` - IP or hostname of Fusion host

- `$DEV_DATASOURCES = "site1_WEB","site2_WEB"` - List of data sources

- `$DEV_INDEX_PIPELINES = "intranet","site_search"` - List of Index Pipelines

- `$DEV_QUERY_PIPELINES = "intranet_suggest_v1"` - List of Query Pipelines

- `$DEV_QUERY_PROFILES = "intranet","intranet_suggest"` - List of Query Profiles

- `$DEV_SPARK_JOBS = "Site_Search_suggestions"` - List of Spark Jobs

Run the [PowerShell script](export-fusion-objects.ps1)...
- `$PROJECT_HOME\export-fusion-objects.ps1 -env DEV`

- `$PROJECT_HOME\export-fusion-objects.ps1 -env QA`

- `$PROJECT_HOME\export-fusion-objects.ps1 -env PROD`

## Set Up Version Control Using GIT
First, run the [PowerShell script](export-fusion-objects.ps1) across all environments and get all of the Fusion objects:

Next, set up a new project in [Bitbucket](https://bitbucket.org) or other remote repository. 

Then...
- `cd $PROJECT_HOME`

- run `git init` to initialize a new GIT project

Add the remote repository as the **origin**:
- `git remote add origin https://repo.com/path/to/project.git`

- run `git add .` to add all files into the project

- run `git commit -m "initial commit"`

- run `git push -u origin master` to update the remote repository

## Managing the Changes
Run the [PowerShell script](export-fusion-objects.ps1) after things change to capture the updates:

- `$PROJECT_HOME\export-fusion-objects.ps1 -env DEV`

Then save the changes to your version control repository:

- `cd $PROJECT_HOME`

- run `git status` to see what changed

- run `git commit -a -m "comments"` and enter some comments about what changed

- run `git push -u origin master` to send the changes to the remote repository

---
###### 10/2019 - ccook@onixnet.com