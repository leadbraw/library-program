# library-program
A simple program made with the Open Database Connectivity interface via [pyodbc](https://github.com/mkleehammer/pyodbc) to execute sql queries on a database made to model a library, complete with inventory, holds, event bookings, and more.

### Setup
Create a new Microsoft SQL Server installation, or just use an existing one. Whatever you choose, it should use Windows Authentication (not mixed mode) to make things simpler, and the TCP/IP and Named Pipes protocols should be enabled. This can be done in SQL Server Configuration Manager -> SQL Server Network Configuration -> Protocols for [server name]. Run the db_setup.sql file as a query, it should work like a charm. Make sure you have a Microsoft ODBC Driver for SQL Server installed. Anything 17.10 and up should work for SQL Server 2022, which is what I'm using.
<pre>
 Download driver: https://learn.microsoft.com/en-us/sql/connect/odbc/windows/release-notes-odbc-sql-server-windows
 Check compatibility: https://learn.microsoft.com/en-us/sql/connect/odbc/windows/system-requirements-installation-and-driver-files
</pre>

 
Make sure Python is installed, just the latest version should do, the project was coded in 3.12. The only dependency is pyodbc, do a quick "pip install pyodbc" in the terminal to take care of that. Now go into main.py and update the string on lines 17-22 (connection = pyodbc.connect(...)). Replace the server name that I used with the one on your machine (check what it is by going into the properties of the server in SSMS). If you installed a ODBC driver that is version 18.x, then change the 17 to an 18 in the driver part of the string. Everything else you should be able to leave alone.

Open a terminal, cd into where the .py files are, and run `python main.py` to start the program.
