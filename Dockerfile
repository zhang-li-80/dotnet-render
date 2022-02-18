#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:5.0-alpine AS base
WORKDIR /app
EXPOSE 80
EXPOSE 5000

FROM mcr.microsoft.com/dotnet/sdk:5.0-alpine AS build
WORKDIR /src
COPY ["src/DotNetRender.Web/DotNetRender.Web.csproj", "."]
RUN dotnet restore "./DotNetRender.Web.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "DotNetRender.Web.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "DotNetRender.Web.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
RUN ls
ENTRYPOINT ["dotnet", "DotNetRender.Web.dll"]