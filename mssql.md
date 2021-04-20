# MS SQL Server

I try to eplain how a MS SQL Server works - from the view point of a programmer that uses the server - I skip things if I think their are not so important.

## Execution of an SQL Statement

This will happend if you want to execute an sql statement. (not the complete truth)

1. A client opens a connection to the MS SQL Server
2. The SQL statement is send (over the network) to the server.
3. The SQL server add this to an queue and wait for an free worker.
4. The SQL statement is analysed and a execution plan will be created.
5. The execution plan will be executed.
6. The results are sended to the client.


### Execution plan get the idea
The execution plan is a graph (a tree) that descripe the operations and their connections.
The different operations reads the result from their child operations and return the operation specific computed result. Think as different implementations of an interface ISQLOperation { SqlRecord GetNext(); }

If you read from a table the result is returned one by one record.

If you sort an table than all data are read from the child operation, sorting, returning the sorted records one by one.

So if you want data from SQL Server that are sorted or grouped than you have alwas a pause before the first record returns, a longer execution time and higher memory usage.

The MS SQL Server has different ways to read from data from the file.
- Clustered Index Scan
- Clustered Index Seek
- Index Scan
- Index Seek
- ...

Clusted Index Scan read the complete table from top to the bottom (or reversed). Sometimes this is called table scan.

Clusted Index Seek means find quick a specified record and read.


The MS SQL Server has different ways to execute a join.
- Nested Loop Join - two foreach loops returning the 2 matching records as one record - You can run this in paralell.
- Hash Join - read the first table into a hashtable than loop over the second table and return the 2 matching records as one record - So the first result needs time.
- Merge Join - both childs are sorted in the same way read child compare, return if matched and read the next depending on the compare result - This is super fast an needs almost no memory.

### So how is the execution plan build?
To decide which operation is used. The SQL Server needs to know the shape of the data. The statistics are build for that. Answer the question: Guess how many records may return for this operation? 

If the first table of an join is very small the hash join has not too much overhead.
If you want exactly one result of an join the HashJoin is slower than the nested loop join.

So the same SQL Statement can be executed with different execution plans depending on how many records are in the tables, or is their a big cluster (90% of the names start with demo).
