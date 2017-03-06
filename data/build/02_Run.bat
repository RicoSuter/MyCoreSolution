CALL ./01_Build.bat

CMD /c dotnet run -p "%~dp0/../src/{projectname}.Web/{projectname}.Web.csproj"