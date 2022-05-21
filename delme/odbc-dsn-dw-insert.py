import pyodbc 
import exception 
# https://pynative.com/python-mysql-insert-data-into-database-table/#h-insert-multiple-rows-into-mysql-table-using-the-cursor-s-executemany
# https://docs.microsoft.com/en-us/sql/connect/python/pyodbc/step-1-configure-development-environment-for-pyodbc-python-development?view=sql-server-ver15
# docker run -it --name my-manim-container -v "/home/bgroves@BUSCHE-CNC.COM/srcmanim:/manim" manimcommunity/manim /bin/bash
# Some other example server values are
# server = 'localhost\sqlexpress' # for a named instance
# server = 'myserver,port' # to specify an alternate port

try:
#server = 'tcp:mgsqlmi.public.48d444e7f69b.database.windows.net,3342' 
# database = 'mgdw' 
  username = 'mgadmin' 
  password = 'WeDontSharePasswords1!' 
  conn = pyodbc.connect('DSN=dw;UID='+username+';PWD='+ password + ';DATABASE=mgdw')


  cursor = conn.cursor()
  #Sample select query
  query ='''insert into Validation.Detailed_Production_History (pcn)
  values (2)'''
  # cursor.execute(query) 

  im ='''insert into Validation.Detailed_Production_History (pcn,production_no)
  values (?,?)'''
  print(im)
  rec = [(1, 2),
 (1, 1),
 (1, 1),
 (1, 1),
 (1, 0)]
  cursor.executemany(im,rec)
#   cursor.executemany(im, [(1, 2),
#  (1, 1),
#  (1, 1),
#  (1, 1),
#  (1, 0)])
  # cursor.executemany(im,[(1)]) 
  cursor.commit()
  # cursor.executemany(insert_query, records_to_insert)
  print(cursor.rowcount, "Record inserted successfully into Laptop table")

  # cursor.execute('insert into Validation.Detailed_Production_History (pcn) values (12345)') 
  # cursor.execute("SELECT @@version;") 

  # cursor.execute('insert into Validation.Detailed_Production_History (pcn) values (12345)') 
  # cursor.commit()
  # print(cursor.rowcount)

#   insert_query = """insert into Validation.Detailed_Production_History (pcn)
#                             VALUES (%i) """
#   sql = """
# insert into Table1(field1, field2, field3) values (?, ?, ?)
# """
                          
#   records_to_insert = [(1),(2),(3)]
#   cursor.executemany('insert into Validation.Detailed_Production_History(pcn) VALUES (?)', [1,2,3])
  # cursor.commit()
  # cursor.executemany(insert_query, records_to_insert)
  print(cursor.rowcount, "Record inserted successfully into Laptop table")
# https://towardsdatascience.com/how-i-made-inserts-into-sql-server-100x-faster-with-pyodbc-5a0b5afdba5
# row = cursor.fetchone() 
# while row: 
#     print(row[0])
#     row = cursor.fetchone()

except pyodbc.Error as ex:
  exception.PyODBCError(ex)  
  # sqlstate = ex.args[0]
  # if sqlstate == '28000':
  #     print("LDAP Connection failed: check password")

finally:
  cursor.commit()
  cursor.close()
  conn.close()