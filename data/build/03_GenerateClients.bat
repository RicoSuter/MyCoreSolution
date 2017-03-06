CALL ./01_Build.bat

CMD /c dotnet publish "%~dp0/../src/{projectname}.Web/{projectname}.Web.csproj"
CMD /c nswag run "%~dp0/../src/{projectname}.Web/nswag.json"