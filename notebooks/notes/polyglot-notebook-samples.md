# polyglot notes




## nuget packages

```csharp
// Install the Microsoft.ML package used by ML.NET
#r "nuget:Microsoft.ML"
// Gain access to the namespace
using Microsoft.ML;
// Create the MLContext ML.NET revolves around
MLContext context = new();
// Create an IDataView from our states data
IDataView stateDataView = context.Data.LoadFromEnumerable<string>(states);
// Display data from the stateDataView
stateDataView // or stateDataView.Preview() for more info
```

## sqlserver

See: [.NET interactive with SQL!](https://devblogs.microsoft.com/dotnet/net-interactive-with-sql-net-notebooks-in-visual-studio-code/)

```csharp
#r "nuget:Microsoft.DotNet.Interactive.SqlServer,*-*"
#!connect mssql ...
```

Can now access SQLServer from SQL cells.

## psql

```csharp
#r "nuget: Npgsql, 7.0.4"
```

```csharp
var connString = "Host=myserver;Username=mylogin;Password=mypass;Database=mydatabase";

await using var conn = new NpgsqlConnection(connString);
await conn.OpenAsync();

// Insert some data
await using (var cmd = new NpgsqlCommand("INSERT INTO data (some_field) VALUES (@p)", conn))
{
    cmd.Parameters.AddWithValue("p", "Hello world");
    await cmd.ExecuteNonQueryAsync();
}

// Retrieve all rows
await using (var cmd = new NpgsqlCommand("SELECT some_field FROM data", conn))
await using (var reader = await cmd.ExecuteReaderAsync())
{
while (await reader.ReadAsync())
    Console.WriteLine(reader.GetString(0));
}
```
