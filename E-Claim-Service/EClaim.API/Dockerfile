# ------------------------------
# Stage 1: Build
# ------------------------------
FROM mcr.microsoft.com/dotnet/sdk:8.0-alpine AS build

# Set environment variables to avoid Windows paths issues
ENV NUGET_PACKAGES=/root/.nuget/packages
ENV DOTNET_CLI_TELEMETRY_OPTOUT=1

WORKDIR /src

# Copy csproj files first to leverage Docker cache
COPY EClaim.API/EClaim.API.csproj EClaim.API/
COPY EClaim.Infrastructure/EClaim.Infrastructure.csproj EClaim.Infrastructure/
COPY EClaim.Domain/EClaim.Domain.csproj EClaim.Domain/

# Restore dependencies (cached unless csproj changes)
RUN dotnet restore "EClaim.API/EClaim.API.csproj" --disable-parallel

# Copy all source files
COPY . .

# Build the project in Release mode
WORKDIR /src/EClaim.API
RUN dotnet build "EClaim.API.csproj" -c Release -o /app/build

# Publish (self-contained if needed, or framework-dependent)
RUN dotnet publish "EClaim.API.csproj" -c Release -o /app/publish /p:UseAppHost=false --no-restore

# ------------------------------
# Stage 2: Runtime
# ------------------------------
FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine AS runtime

# Install ICU for globalization (required for dates, cultures, etc.)
RUN apk add --no-cache icu-libs

# Create non-root user
RUN addgroup -S eclaimgroup && adduser -S eclaimuser -G eclaimgroup

# Set environment variables
ENV DOTNET_RUNNING_IN_CONTAINER=true
ENV DOTNET_USE_POLLING_FILE_WATCHER=1
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false
ENV DOTNET_ENVIRONMENT=Development
ENV ASPNETCORE_URLS=http://+:80
ENV HOME=/home/eclaimuser

WORKDIR /app

# Copy published app from build stage
COPY --from=build /app/publish ./

# Change ownership of files
RUN chown -R eclaimuser:eclaimgroup /app

# Switch to non-root user
USER eclaimuser

# Expose port
EXPOSE 80

# Start app
ENTRYPOINT ["dotnet", "EClaim.API.dll"]
