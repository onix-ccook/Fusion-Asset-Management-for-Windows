<#
.SYNOPSIS
    The purpose of this script is to export Lucidworks Fusion objects.
  
.DESCRIPTION
    This script connects to the Fusion API and downloads the object (pipeline,
    data source, etc.) as a ZIP file. The ZIP file is extracted and the objects.json
    contained therein is left intact on the file system.

.PARAMETER env
    The environment (DEV, QA, PROD) which to connect and download the configured
    objects.

.NOTES
    File Name: export-fusion-objects.ps1
    Author:    Chris Cook, Onix - ccook@onixnet.com
    Released:  2019-10-25
    Updated:   2019-10-27  Added this comment block in the header

.EXAMPLE 
    Run the export-fusion-objects script to dump the objects in development:
    export-fusion-objects -env DEV

.LINK
    https://github.com/onix-ccook/Fusion-Asset-Management-for-Windows

#requires -version 2
#>

[CmdletBinding()]

Param 
( 
    [parameter(
        mandatory=$true, 
        HelpMessage="Which Environment to export? DEV, QA or PROD"
    )]
    [ValidateSet('DEV','QA','PROD')]
    [string] $env
)

#----------------[ Declarations ]------------------------------------------------------

$USER = "admin"
$PASS = "pasword123"
$PROJECT_HOME = "C:\fusion\dev"
$VERSION = "422"

$auth = "${USER}:${PASS}"
$bytes = [System.Text.Encoding]::ASCII.GetBytes($auth)
$base64 = [System.Convert]::ToBase64String($bytes)
$basicAuthValue = "Basic $base64"
$headers = @{ "Authorization" = $basicAuthValue }

# Dev
$DEV_VERSION = $VERSION
$DEV_HOSTNAME = "search-dev.company.com"
$DEV_DATASOURCES = "site1_WEB","file1_SMB"
$DEV_INDEX_PIPELINES = ""
$DEV_QUERY_PIPELINES = "crawlDB","intranet_suggest_v1"
$DEV_QUERY_PROFILES = "intranet","intranet_suggest"
$DEV_SPARK_JOBS = "Site_Search_suggestions"

# QA
$QA_VERSION = $VERSION
$QA_HOSTNAME = ""
$QA_DATASOURCES = ""
$QA_INDEX_PIPELINES = ""
$QA_QUERY_PIPELINES = ""
$QA_QUERY_PROFILES = ""
$QA_SPARK_JOBS = ""

# Prod
$PROD_VERSION = $VERSION
$PROD_HOSTNAME = ""
$PROD_DATASOURCES = ""
$PROD_INDEX_PIPELINES = ""
$PROD_QUERY_PIPELINES = ""
$PROD_QUERY_PROFILES = ""
$PROD_SPARK_JOBS = ""

#----------------[ Functions ]---------------------------------------------------------

function getOBJ($url, $outfile, $dumpdir) {
    New-Item -ItemType Directory -Force -Path $dumpdir
    Invoke-WebRequest -uri $url -Headers $headers -OutFile $outfile
    Expand-Archive -Force -LiteralPath $outfile -DestinationPath $dumpdir
}

function run($ENV) {
    $HN  = Get-Variable -ValueOnly -Name "${ENV}_HOSTNAME"
    $VER = Get-Variable -ValueOnly -Name "${ENV}_VERSION"
    $DS  = Get-Variable -ValueOnly -Name "${ENV}_DATASOURCES"
    $IPL = Get-Variable -ValueOnly -Name "${ENV}_INDEX_PIPELINES"
    $QPL = Get-Variable -ValueOnly -Name "${ENV}_QUERY_PIPELINES"
    $QPR = Get-Variable -ValueOnly -Name "${ENV}_QUERY_PROFILES"
    $JOB = Get-Variable -ValueOnly -Name "${ENV}_SPARK_JOBS"

    if ($HN -eq '') { return }

    # DATASOURCES
    foreach ($a in $DS) {
        if ($a -eq '') { break }
        $dump_dir="$PROJECT_HOME\$ENV\DS-$a"
        $out="$dump_dir\$a-$VER.zip"
        $url="http://${HN}:8764/api/apollo/objects/export?datasource.ids=$a"
        getOBJ $url $out $dump_dir
    }

    # INDEX_PIPELINES
    foreach ($a in $IPL) {
        if ($a -eq '') { break }
        $dump_dir="$PROJECT_HOME\$ENV\IPL-$a"
        $out="$dump_dir\$a-$VER.zip"
        $url="http://${HN}:8764/api/apollo/objects/export?index-pipeline.ids=$a"
        getOBJ $url $out $dump_dir
    }

    # QUERY_PIPELINES
    foreach ($a in $QPL) {
        if ($a -eq '') { break }
        $dump_dir="$PROJECT_HOME\$ENV\QPL-$a"
        $out="$dump_dir\$a-$VER.zip"
        $url="http://${HN}:8764/api/apollo/objects/export?query-pipeline.ids=$a"
        getOBJ $url $out $dump_dir
    }

    # QUERY_PROFILES
    foreach ($a in $QPR) {
        if ($a -eq '') { break }
        $dump_dir="$PROJECT_HOME\$ENV\QPR-$a"
        $out="$dump_dir\$a-$VER.zip"
        $url="http://${HN}:8764/api/apollo/objects/export?query-profile.ids=$a"
        getOBJ $url $out $dump_dir
    }

    # SPARK_JOBS
    foreach ($a in $JOB) {
        if ($a -eq '') { break }
        $dump_dir="$PROJECT_HOME\$ENV\JOB-$a"
        $out="$dump_dir\$a-$VER.zip"
        $url="http://${HN}:8764/api/apollo/objects/export?spark.ids=$a"
        getOBJ $url $out $dump_dir
    }

}

#----------------[ Main Execution ]----------------------------------------------------

run $env