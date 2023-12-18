FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# Copy and restore dependencies
COPY *.csproj .
RUN dotnet restore

# Copy the rest of the source code and build the app
COPY . .
RUN dotnet publish -c Release -o out

# Build the runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/out .

# Thiết lập biến môi trường
ENV ASPNETCORE_URLS=http://*:5000;
EXPOSE 5000

ENTRYPOINT ["dotnet", "myproject.dll"]
# ENTRYPOINT ["dotnet", "ef", "database", "update", "--project", "myproject", "--startup-project", "myproject"]
# ENTRYPOINT ["sh", "-c", "dotnet ef database update --project myproject --startup-project myproject && dotnet myproject.dll"]