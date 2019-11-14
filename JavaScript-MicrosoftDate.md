/Date(ticks)/

```javascript
var d= new Date();
var s="/Date(" + d.valueOf().toString() + ")/"
var jsonDate = new Date(parseInt(s.replace(/\/Date\((\d+)\)\//, '$1'),10))
console.log("", d, s , jsonDate)
```

https://weblog.west-wind.com/posts/2014/Jan/06/JavaScript-JSON-Date-Parsing-and-real-Dates
https://github.com/RickStrahl/json.date-extensions/