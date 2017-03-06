CMD /c npm install -g nswag

PUSHD "%~dp0/../src/{projectname}.Web"
CMD /c npm install
POPD

CMD /c dotnet restore "%~dp0/../src/{projectname}.sln"