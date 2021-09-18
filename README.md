# WildCounts-Shorthand-Vocabulary

This is a shorthand for quickly typing in observations of species when doing ecological surveys of organisms. See [WildCounts](https://www.wildcounts.org) for more context.

WildCounts Shorthand syntax is divided into five categories. **Count** is the general syntax for counting individual organisms. **Observation connector** is the syntax for connecting together organisms of different species, which is useful when you see species interacting. **Phenology** is the syntax specifically for recording the reproductive stages present on plants. **Roadkill**, as the name suggests, is the syntax for counting roadkill, and its condition and location on roads. Lastly, **Survey** is the syntax used for describing the environment at the time of your count.

Within each category are **types**, **values**, and **syntax**. **Types** are the different concepts, like "taxon name", "age", and "initial position compass bearing". Within each type are one or more **values**. For example, the type "age" has the values "adult", "juvenile", and "baby". Within each value is then one, or sometimes several, shorthand syntax options for entering that value. For example, the shorthand syntax for "adult" is `a`. 

The `original_database-tables` folder contains exported tables from a database. 

The `wrangled-data` folder contains a sorted, flattened, and simplified version of these data (for just the typed counts, removing the vocabulary for spoken counts and removing deprecated syntax).

The markdown page `wildcounts-shorthand-vocab.md` is designed to slot into [WildCounts](https://www.wildcounts.org), which is a Jekyll site on Github Pages.

The R script `export_wrangler.R` takes the data in the `original_database-tables` folder, and converts it into the spreadsheet in the `wrangled-data` folder and makes the `wildcounts-shorthand-vocab.md` markdown page.