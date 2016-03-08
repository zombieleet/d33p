# d33p
web crawler written in bash

#how to use
d33p.sh -l[optional] [-g|-b] "website to crawl or any other random search"


options
- -l [to set the limit of the search] *optional*
- -g [use google for the search]
- -b [use bing for the search]
- -a [use both google and bing for the search]

if limit is not set, the limit defaults to 10;


````

example:-

d33p.sh -l 200 -g "life is game"

d33p.sh -l 200 -g github.com

//google dorks can also be used 

d33p.sh -l 200 -g "site:github.com filetype:php"

d33p.sh -l 200 -g "site:github.com"

````

#google dorks
site:johndoe.com

filetype:php

intitle:"cat pictures"

intext:"i love cats"

inurl:video.php

other list here >>> http://www.hackersforcharity.org/ghdb/?function=summary&cat=7

#bing dorks

site:johndoe.com

ip:ipaddress of the site

