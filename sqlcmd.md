COULD NEVER GET THIS TO WORK IN UBUNTU WITH BUSCHE-SQL
WITH DRIVER 17 OR 18.
https://docs.microsoft.com/en-us/sql/ssms/scripting/sqlcmd-use-the-utility?view=sql-server-ver15

The linux computer can communicate to the server machine and mssql 1433 port. I test this with the linux nc command (netcat).

Linux nc command results:
nc -z -v -w5 10.1.2.74 1433
nc -z -v -w5 busche-sql 1433

sqlcmd -U sa -S busche-sql  
sqlcmd -S busche-sql -U sa -P buschecnc1

SQLCMD -S "busche-sql\MSSQLSERVER" -U sa
sqlcmd -Sxxx.xxx.xxx.xxx -Uxxx -Pxxx
sqlcmd -S10.1.2.74 -Usa -Pbuschecnc1
The sqlcmd utility is a command-line utility for ad hoc, interactive execution of Transact-SQL statements and scripts and for automating Transact-SQL scripting tasks. To use sqlcmd interactively, or to build script files to be run using sqlcmd, users must understand Transact-SQL. The sqlcmd utility is typically used in the following ways:

Users enter Transact-SQL statements in a manner similar to working at the command prompt. The results are displayed at the command prompt. To open a Command Prompt window, enter "cmd" in the Windows search box and click Command Prompt to open. At the command prompt, type sqlcmd followed by a list of options that you want. For a complete list of the options that are supported by sqlcmd, see sqlcmd Utility.

Users submit a sqlcmd job either by specifying a single Transact-SQL statement to execute, or by pointing the utility to a text file that contains Transact-SQL statements to execute. The output is usually directed to a text file, but can also be displayed at the command prompt.

SQLCMD mode in SQL Server Management Studio Query Editor.

SQL Server Management Objects (SMO)

SQL Server Agent CmdExec jobs.

Typically used sqlcmd options
Server option (-S) identifies the instance of Microsoft SQL Server to which sqlcmd connects.

Authentication options (-E, -U, and -P) specify the credentials that sqlcmd uses to connect to the instance of SQL Server. NOTE: The option -E is the default and does not need to be specified.

Input options (-Q, -q, and -i) identify the location of the input to sqlcmd.

The output option (-o) specifies the file in which sqlcmd is to put its output.

Connect to the sqlcmd utility
Connecting to a default instance by using Windows Authentication to interactively run Transact-SQL statements:


Copy
sqlcmd -S <ComputerName>  
NOTE: In the previous example, -E is not specified because it is the default and sqlcmd connects to the default instance by using Windows Authentication.

Connecting to a named instance by using Windows Authentication to interactively run Transact-SQL statements:


Copy
sqlcmd -S <ComputerName>\<InstanceName>  
or


Copy
sqlcmd -S .\<InstanceName>  
Connecting to a named instance by using Windows Authentication and specifying input and output files:


Copy
sqlcmd -S <ComputerName>\<InstanceName> -i <MyScript.sql> -o <MyOutput.rpt>  
Connecting to the default instance on the local computer by using Windows Authentication, executing a query, and having sqlcmd remain running after the query has finished running:


Copy
sqlcmd -q "SELECT * FROM AdventureWorks2012.Person.Person"  
Connecting to the default instance on the local computer by using Windows Authentication, executing a query, directing the output to a file, and having sqlcmd exit after the query has finished running:


Copy
sqlcmd -Q "SELECT * FROM AdventureWorks2012.Person.Person" -o MyOutput.txt  
Connecting to a named instance using SQL Server Authentication to interactively run Transact-SQL statements, with sqlcmd prompting for a password:


Copy
sqlcmd -U MyLogin -S <ComputerName>\<InstanceName>  
HINT!! To see a list of the options that are supported by the sqlcmd utility run: sqlcmd -?.

