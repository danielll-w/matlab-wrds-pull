# WRDS MATLAB Pull

## Description

Wharton Research Data Services (WRDS) provides a variety of data. One may wish
to pull data into MATLAB from their databases. They use a PostgreSQL so you need
to download an appropriate driver. Specifically, it is a JDBC driver.

## Setup

### Part 1

The install instructions for the Postgres JDBC driver are on the WRDS website.
Two things to note. There is a step where you create a text file with a file
path. The file path does not need quotes. Second, after you finish the step
where you create the text file with the path to the JDBC driver, the
instructions tell you to call a command and check that the driver is in the list
of things that appear in the console. It will not show up unless you restart
MATLAB. Everything else should be self-explanatory.

### Part 2

There are two functions that can pull data at varying speeds. Due to copyright
issues you will have to get the code from Yair Altman's website [Undocumented
MatLab](https://undocumentedmatlab.com/articles/speeding-up-matlab-jdbc-sql-queries)
and implement it in functions yourself. 

To use the Java class for the fast method, it must be saved as a .java file,
compiled, and then packaged in a .jar file. The .java, .class, and .jar files
are in this repo. The .jar should be ready to use. If you wish to recompile the
.java file and then rebuild the .jar package file, you will need to download the
Java 8 JDK from [Adoptium](https://adoptium.net/marketplace?version=8) or
whichever version is compatible with the version of Java your version of MATLAB
has. Compiling and building is fairly easy. Just search online and you should be
able to figure it out.

Assuming your version of MATLAB and version of Java that MATLAB is using are
compatible with the .jar file, you will need to add JDBC_Fetch.jar to your
javaclasspath.txt file.

One last point, Java heap memory fills rapidly and you can get out of memory
errors if you do not do garbage collectoin.

## Usage

### Create query

Here is a sample query.

```matlab
% Get WRDS connection object
WRDS = open_wrds;

% Prepare SQL statement and execute:
q = WRDS.prepareStatement("select * from djones.djdaily LIMIT 10");
rs = q.executeQuery();
```

### Turn the result of the query into a data table

Call ```query_result_to_table_fast.m``` with a result object and get back a
MATLAB data table.

```query_result_to_table_fast(rs)```

Inputs:
- rs: result object from query

Output:
- MATLAB data table

You may also use the slow version if the data pull is not huge.

### Close the connection and result objects (and do Java garbage collection)

You can only have a certain number of connections open to WRDS at a time. It is
good practice in general to close and clear database connections and result
objects when you are done with them. We also will call the Java garbage
collection after closing the results object to avoid the running out of memory
error.

```matlab
% Clean up the result and connection objects
rs.close();
clear rs
java.lang.System.gc();
WRDS.close();
clear WRDS
```

### Full example

```matlab

% Add to path
addpath(genpath('wrds-matlab-pull'));

% Get WRDS connection object
WRDS = open_wrds;

% Prepare SQL statement and execute:
q = WRDS.prepareStatement("select * from djones.djdaily LIMIT 10");
rs = q.executeQuery();

% Clean result and put into MATLAB table form
data_table = query_result_to_table(rs);

% Clean up the result and connection objects
rs.close();
clear rs
java.lang.System.gc();

WRDS.close();
clear WRDS
```

## Sample Pull

See the sample_pull.m file for a potential workflow for exploring WRDS data.

## Author
- Dan Weiss, 2022