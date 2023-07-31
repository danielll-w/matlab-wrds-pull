function WRDS = open_wrds

% Server info
driver = eval('org.postgresql.Driver');
dbURL = ['jdbc:postgresql://wrds-pgdata.wharton.upenn.edu:9737/wrds?ssl=' ... 
    'require&sslfactory=org.postgresql.ssl.NonValidatingFactory'];

% Get username and password from user
prompt = {'WRDS Username','WRDS Password'};
dlgtitle = 'WRDS Credentials';
dims = [1 35];

answer = inputdlg(prompt, dlgtitle, dims);
username = answer{1};
password = answer{2};

% Establish and return WRDS connection
WRDS = java.sql.DriverManager.getConnection(dbURL, username, password);

end

