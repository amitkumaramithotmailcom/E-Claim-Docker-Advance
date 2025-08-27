# See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

# Official .NET Full SDK + runtime as the base image
FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine AS base
WORKDIR /app
EXPOSE 8080

# Configure Kestrel to listen on port 8080
ENV ASPNETCORE_URLS=http://+:8080

# Build stage (SDK with compiler)
FROM mcr.microsoft.com/dotnet/sdk:8.0-alpine AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src

# Copy only project files first (improves caching of NuGet restore)
COPY ["EClaim.Application/EClaim.Application.csproj", "EClaim.Application/"]

# Restore dependencies (cached unless csproj changes)
RUN dotnet restore "EClaim.Application/EClaim.Application.csproj" --disable-parallel

# Copy everything else
COPY . .

# Build the project (skip restore since it's already done)
WORKDIR /src/EClaim.Application
RUN dotnet build "EClaim.Application.csproj" -c $BUILD_CONFIGURATION -o /app/build --no-restore

# Publish stage - no restore as we already did that
FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "EClaim.Application.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false --no-restore

# Final image: only runtime + published output - copy from publish stage
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "EClaim.Application.dll"]
