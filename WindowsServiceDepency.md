# Windows Service

Problem: SPTimer needs SQL Server for one computer sharepoint farm.

To show:

```PowerShell
get-service SPTimerV4 | ft name,ServicesDependedOn
$names=('SPAdminV4','SPInsights','SPSearchHostCo*','SPTimerV4','SPTraceV4','SPUserCodeV4','SPWriterV4')
get-service $names | ft name,ServicesDependedOn
```

To change:

```CMD
sc query sptimerv4
sc query mssqlserver
sc config sptimerv4 depend= MSSQLSERVER
```


