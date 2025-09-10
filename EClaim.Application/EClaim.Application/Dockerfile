# See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

# Base runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine AS base

# Create non-root user and group
RUN addgroup -S eclaimgroup && adduser -S eclaimuser -G eclaimgroup

WORKDIR /app
EXPOSE 8080

# Configure Kestrel to listen on port 8080
ENV ASPNETCORE_URLS=http://+:8080

# Switch to non-root user
USER eclaimuser

# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0-alpine AS build

WORKDIR /src

# Copy only the csproj and restore (better caching)
COPY ["EClaim.Application/EClaim.Application.csproj", "EClaim.Application/"]
RUN dotnet restore "EClaim.Application/EClaim.Application.csproj" --disable-parallel

# Copy everything else
COPY . .

# Build
WORKDIR /src/EClaim.Application
RUN dotnet build "EClaim.Application.csproj" -c Release -o /app/build --no-restore

# This stage is used to publish the service project to be copied to the final stage
FROM build AS publish
RUN dotnet publish "EClaim.Application.csproj" -c Release -o /app/publish /p:UseAppHost=false --no-restore

# This stage is used in production or when running from VS in regular mode (Default when not using the Debug configuration)
FROM base AS final
WORKDIR /app

# Copy published output
COPY --from=publish /app/publish .

# Start app as non-root user
ENTRYPOINT ["dotnet", "EClaim.Application.dll"]
