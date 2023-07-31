% Get WRDS connection object
WRDS = open_wrds;

% See libraries
q = WRDS.prepareStatement("select distinct table_schema from information_schema.tables where table_type = 'VIEW' or table_type = 'FOREIGN TABLE' order by table_schema", java.sql.ResultSet.TYPE_SCROLL_INSENSITIVE, java.sql.ResultSet.CONCUR_UPDATABLE);
rs = q.executeQuery();
data_table = query_result_to_table_fast(rs);
rs.close();
clear rs
java.lang.System.gc();

% See datasets within libraries
q = WRDS.prepareStatement("select distinct table_name from information_schema.columns where table_schema = 'ciq' order by table_name", java.sql.ResultSet.TYPE_SCROLL_INSENSITIVE, java.sql.ResultSet.CONCUR_UPDATABLE);
rs = q.executeQuery();
data_table = query_result_to_table_fast(rs);
rs.close();
clear rs
java.lang.System.gc();

% See column headers of datasets
q = WRDS.prepareStatement("select column_name from information_schema.columns where table_schema = 'ciq' and table_name = 'wrds_gvkey' order by column_name", java.sql.ResultSet.TYPE_SCROLL_INSENSITIVE, java.sql.ResultSet.CONCUR_UPDATABLE);
rs = q.executeQuery();
data_table = query_result_to_table_fast(rs);
rs.close();
clear rs
java.lang.System.gc();

% Pull from dataset
tic
q = WRDS.prepareStatement("select * from djones.djdaily limit 1000", java.sql.ResultSet.TYPE_SCROLL_INSENSITIVE, java.sql.ResultSet.CONCUR_UPDATABLE);
rs = q.executeQuery();
data_table = query_result_to_table_slow(rs);
rs.close();
clear rs
java.lang.System.gc();
toc

% Clean up the result and connection objects
WRDS.close();
clear WRDS
