# plsql php_deserialize
function fot plsql to deserialize php arrays. complient with postgre sql 9.4+ and greenplum 6.22+


Decode a php serialized value to json. This function only supports basic 
data types:
- arrays (will always become a json object)
- booleans
- integers
- floats
- strings
- double 
- NULL
 
objects semi supported. objects are converted to key value, where value is is body of the object.

example: 

```
input: 'a:1:{
	s:12:"new_date_end";O:10:"TPDateTime":3:{
     s:4:"date";s:26:"2023-02-15 12:30:00.000000";
     s:13:"timezone_type";i:3;
     s:8:"timezone";s:13:"Europe/Moscow";
     }
}'

output: 
{
	"new_date_end":
	{
		"date":"2023-02-15 12:30:00.000000",
		"timezone_type":"3",
		"timezone":"Europe/Moscow"
	}
} 

```

if invalid array is given then null is returned.
