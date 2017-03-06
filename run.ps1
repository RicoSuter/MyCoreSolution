$projectname = read-host "Project name"
$webtemplate = read-host "Frontend template (e.g. 'angular', 'aurelia')"

$repository = Get-Location; 

# Install dev packages
dotnet new --install Microsoft.AspNetCore.SpaTemplates::*

# Create base directories
mkdir "$repository/docs"
mkdir "$repository/build"
mkdir "$repository/src"

Copy-Item ".\data\build\*" ".\build"
$files = Get-ChildItem -Path ".\build\*" -rec
foreach ($file in $files)
{
    (Get-Content $file.PSPath) |
    Foreach-Object { $_ -replace "{projectname}", $projectname } |
    Set-Content $file.PSPath
}

# Create *.Data
mkdir "$repository/src/$projectname.Data"
cd "$repository/src/$projectname.Data"
dotnet new classlib
dotnet add package "Microsoft.EntityFrameworkCore.SqlServer"

# Create *.Business
mkdir "$repository/src/$projectname.Business"
cd "$repository/src/$projectname.Business"
dotnet new classlib
dotnet add reference "../$projectname.Data/$projectname.Data.csproj"

# Create *.Api
mkdir "$repository/src/$projectname.Api"
cd "$repository/src/$projectname.Api"
dotnet new classlib
dotnet add package "Microsoft.AspNetCore.Mvc"
dotnet add reference "../$projectname.Data/$projectname.Data.csproj"
dotnet add reference "../$projectname.Business/$projectname.Business.csproj"

# Create *.Client
mkdir "$repository/src/$projectname.Client"
cd "$repository/src/$projectname.Client"
dotnet new classlib

# Create *.Web
mkdir "$repository/src/$projectname.Web"
cd "$repository/src/$projectname.Web"
dotnet new $webtemplate

cd "$repository"
If ($webtemplate -eq "aurelia") { $webtemplate = "Aurelia" } Else { $webtemplate = "Angular2" }
Copy-Item ".\data\nswag.json" "$repository\src\$projectname.Web\nswag.json"
(Get-Content "$repository\src\$projectname.Web\nswag.json").replace("{projectname}", $projectname) | Set-Content "$repository\src\$projectname.Web\nswag.json"
(Get-Content "$repository\src\$projectname.Web\nswag.json").replace("{webtemplate}", $webtemplate) | Set-Content "$repository\src\$projectname.Web\nswag.json"

# Create solution
cd "$repository/src/"

dotnet new sln -n "$projectname"
dotnet sln add "$projectname.Web/$projectname.Web.csproj"
dotnet sln add "$projectname.Client/$projectname.Client.csproj"
dotnet sln add "$projectname.Api/$projectname.Api.csproj"
dotnet sln add "$projectname.Business/$projectname.Business.csproj"
dotnet sln add "$projectname.Data/$projectname.Data.csproj"

# Remove unused files
Remove-Item "$repository/src/*/Class1.cs"

cd "$repository"
