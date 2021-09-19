# combine up the tables from the ShortHand Guides export
# by Jon Sullivan (jon.sullivan@lincoln.ac.nz)
# created 14 September 2021

# this script imports the WildCounts Shorthand count syntax (and WildCounts Spoken syntax) from database tables
# it simplifies and sorts this data (eg removing deprecated syntax)
# it then creates a markdown page that is used at https://www.wildcounts.org/count/wildcounts-shorthand-vocab/

# created 2021-09-14

# load in data (exported from a Filemaker Pro database)
ShorthandGuideExport_anatomy <- read.csv ("original_database-tables/ShorthandGuideExport_anatomy.mer", as.is=TRUE, fileEncoding = "macintosh")
ShorthandGuideExport_categories <- read.csv ("original_database-tables/ShorthandGuideExport_categories.mer", as.is=TRUE, fileEncoding = "macintosh")
ShorthandGuideExport_position <- read.csv ("original_database-tables/ShorthandGuideExport_position.mer", as.is=TRUE, fileEncoding = "macintosh")
ShorthandGuideExport_syntax <- read.csv ("original_database-tables/ShorthandGuideExport_syntax.mer", as.is=TRUE, fileEncoding = "macintosh")
ShorthandGuideExport_types <- read.csv ("original_database-tables/ShorthandGuideExport_types.mer", as.is=TRUE, fileEncoding = "macintosh")
ShorthandGuideExport_values <- read.csv ("original_database-tables/ShorthandGuideExport_values.mer", as.is=TRUE, fileEncoding = "macintosh")

# merge them all into one flat file for export
ShorthandGuide <- merge (ShorthandGuideExport_syntax, ShorthandGuideExport_values, by = "valueID", all=TRUE)
ShorthandGuide <- merge (ShorthandGuide , ShorthandGuideExport_types, by = "typeID", all=TRUE)
ShorthandGuide <- merge (ShorthandGuide , ShorthandGuideExport_position, by = "typeID", all=TRUE)
ShorthandGuide <- merge (ShorthandGuide , ShorthandGuideExport_categories, by = "category", all=TRUE)
ShorthandGuide <- merge (ShorthandGuide , ShorthandGuideExport_anatomy, by.x = "where", by.y = "sorted.shorthand.unit", all=TRUE)

# make a sorted set of just the WildCounts Shorthand syntax

# uncomment to check that there are no NA values or blanks in these (there shouldn't be)
#ShorthandGuide_sorted [is.na(ShorthandGuide_sorted$format) | ShorthandGuide_sorted$format == "",]
#ShorthandGuide_sorted [is.na(ShorthandGuide_sorted$valueCurrent) | ShorthandGuide_sorted$valueCurrent == "",]
#ShorthandGuide_sorted [is.na(ShorthandGuide_sorted$typeID),]
#ShorthandGuide_sorted [is.na(ShorthandGuide_sorted$sorting.from.left),]
#ShorthandGuide_sorted [is.na(ShorthandGuide_sorted$syntax),]

# remove the rows for shorthand units without syntax (like opening and closing brackets)
# and remove all but the shorthand syntax
# and remove all deprecated syntax

ShorthandGuide_sorted <- ShorthandGuide [!is.na(ShorthandGuide$category) & ShorthandGuide$format == "shorthand" & ShorthandGuide$valueCurrent != "deprecated",]

# sort by syntax (to alphabetically order syntax)
ShorthandGuide_sorted <- ShorthandGuide_sorted [order(ShorthandGuide_sorted$syntax),]

# sort by typeID (to keep all syntax from one type together)
ShorthandGuide_sorted <- ShorthandGuide_sorted [order(ShorthandGuide_sorted$typeID),]

# sort by sorting.from.left
# sorting.from.left describes the order of the syntax from left to right across a line of WildCounts Shorthand
ShorthandGuide_sorted <- ShorthandGuide_sorted [order(ShorthandGuide_sorted$sorting.from.left),]

ShorthandGuide_sorted <- rbind (ShorthandGuide_sorted [ShorthandGuide_sorted$category == "count",],
								ShorthandGuide_sorted [ShorthandGuide_sorted$category == "observation connector",], 
								ShorthandGuide_sorted [ShorthandGuide_sorted$category == "phenology",],
								ShorthandGuide_sorted [ShorthandGuide_sorted$category == "roadkill",],
								ShorthandGuide_sorted [ShorthandGuide_sorted$category == "survey",])

# export out the current shorthand file as one flat CSV file
write.csv (ShorthandGuide_sorted, file = "wrangled-data/ShorthandGuide_sorted.csv", row.names=FALSE)


# now make a formatted markdown page documenting all of the WildCounts Shorthand syntax
# this is built to slot into the WildCounts Jekyll site on Github Pages, based on the Jekyll Docs theme.

textfile <- "wildcounts-shorthand-vocab.md"
writeLines (paste("---
title:  \"WildCounts Shorthand vocab\"
sub_title: \"A complete vocubulary for WildCounts Shorthand.\"
author: Jon Sullivan
date:   2021-09-14 10:30:00 +1300
last_modified_at:   ", as.character(Sys.Date())," 10:30:00 +1300
meta: 
  - Count methods
categorylink:
  - wild-counting
tags:
  - rapid biodiversity monitoring
  - rapid counting with shorthand
  - long-term monitoring of biodiversity
permalink: /count/wildcounts-shorthand-vocab/
---\n", sep=""), con = textfile)

cat ("Here is a complete list of the **WildCounts Shorthand** syntax for quickly typing in wild counts. This lets you enter your counts with as little typing as possible, so that you can spend more time watching the wild and less time watching your screen.\n\n", file = textfile, append = TRUE)

cat ("Having said that, do keep a close eye on your smart phone's spellchecker. When you first start entering WildCounts Shorthand, your phone may \"helpfully\" autocorrect what you enter. After a while, any modern phone will learn the values you enter and stop autocorrecting. There are also options in most phone's settings to enter in your commonly used phrases to avoid them getting caught by the autocorrect. That's recommended for WildCounts Shorthand.\n\n", file = textfile, append = TRUE)

cat ("WildCounts Shorthand syntax below is divided into five categories. **Count** is the general syntax for counting individual organisms. **Observation connector** is the syntax for connecting together organisms of different species, which is useful when you see species interacting. **Phenology** is the syntax specifically for recording the reproductive stages present on plants. **Roadkill**, as the name suggests, is the syntax for counting roadkill, and its condition and location on roads. Lastly, **Survey** is the syntax used for describing the environment at the time of your count.\n\n", file = textfile, append = TRUE)

cat ("Within each category are **types**, **values**, and **syntax**. **Types** are the different concepts, like \"taxon name\", \"age\", and \"initial position compass bearing\". Within each type are one or more **values**. For example, the type \"age\" has the values \"adult\", \"juvenile\", \"baby\", and \"egg\". Within each value is then one, or sometimes several, shorthand syntax options for entering that value. For example, the shorthand syntax for \"adult\" is `a`. \n\n", file = textfile, append = TRUE)

cat ("The types are listed in the order that they appear in a line of **WildCounts Shorthand**, starting with the taxon name. The exact position of each type in the shorthand is also indicated. All syntax is case insensitive unless specified.\n\n", file = textfile, append = TRUE)

cat ("Note that a complete spreadsheet version of all of this syntax (and an archive of old deprecated syntax not displayed here), plus an R script that automatically converts that spreadsheet into this webpage, are [available on Github](https://github.com/mjon/WildCounts-Shorthand-Vocabulary).\n\n---\n\n", file = textfile, append = TRUE)


cat ("## Contents\n\n", file = textfile, append = TRUE)

# Make a contents section
# loop through categories
for (a in 1:length(unique(ShorthandGuide_sorted$category))){
	category <- unique(ShorthandGuide_sorted$category)[a]

	cat (paste("* Category: [**", category, "**](#category-", gsub (" ", "-", category),")\n\n", sep=""), file = textfile, append = TRUE)

	# loop through types
	for (b in 1:length(unique(ShorthandGuide_sorted$typeID[ShorthandGuide_sorted$category == category]))){
		typeID <- unique(ShorthandGuide_sorted$typeID[ShorthandGuide_sorted$category == category])[b]
		type_temp <- unique(ShorthandGuide_sorted [ShorthandGuide_sorted$category == category & ShorthandGuide_sorted$typeID == typeID, c("typeID","type", "typeDescription", "typeExample", "typeExample_explained", "where", "associatedType", "associatedType_leftright")])

		cat (paste("   1. Type: [**", type_temp$type, "**](#type-", gsub (" ", "-", type_temp$type),")\n\n", sep=""), file = textfile, append = TRUE)

		rm(type_temp)
		
		cat ("      * Values: ", file = textfile, append = TRUE)

		# loop through values in type
		for (c in 1:length(unique(ShorthandGuide_sorted$valueID[ShorthandGuide_sorted$category == category & ShorthandGuide_sorted$typeID == typeID]))){
			valueID <- unique(ShorthandGuide_sorted$valueID[ShorthandGuide_sorted$category == category & ShorthandGuide_sorted$typeID == typeID])[c]
			value_temp <- unique(ShorthandGuide_sorted [ShorthandGuide_sorted$category == category & ShorthandGuide_sorted$typeID == typeID & ShorthandGuide_sorted$valueID == valueID, c("valueID", "valueName", "valueDescription", "valueConditional", "caseSensitive")])

			cat (paste("[", value_temp$valueName, "](#value-", gsub (" ", "-", value_temp$valueName),"), ", sep=""), file = textfile, append = TRUE)

			rm(value_temp)
			
		}		

		cat ("\n\n", file = textfile, append = TRUE)
	
	}	
	
}


cat ("---\n\n", file = textfile, append = TRUE)


# loop through categories, creating the markdown text for each
for (a in 1:length(unique(ShorthandGuide_sorted$category))){
	category <- unique(ShorthandGuide_sorted$category)[a]

	cat (paste("## Category: **", category, "**\n\n", sep=""), file = textfile, append = TRUE)

	categoryDescription <- unique(ShorthandGuide_sorted$categoryDescription [ShorthandGuide_sorted$category == category])
	# replace the "\v" linebreaks from Filemaker with \n
	categoryDescription <- gsub ("\v", "\\\n", categoryDescription)
	
	cat (paste(categoryDescription, "\n\n", sep=""), file = textfile, append = TRUE)

	# add appropriate annotation diagram when available
	
	if (category == "count"){
	cat ("<div class=\"indent\">
	<figure>
	<a href=\"/assets/img/Shorthand-Anatomy-Counts.png\"><img src=\"/assets/img/Shorthand-Anatomy-Counts.png\" width=\"90%\" alt=\"WildCounts Shorthand anatomy of counts\"></a>
	  <figcaption>The anatomy of WildCounts Shorthand counts. Note that only the <strong>taxon name</strong> (c00), <strong>shorthand separator</strong> (c01, which is just a space for counts), and <strong>count</strong> (c06) are essential. More complete and detailed wild counts can quickly be entered by adding other syntax in the right places. The description of each <strong>type</strong> contains its required position in this shorthand anatomy.</figcaption>
	</figure>
	</div>\n\n", file = textfile, append = TRUE)
	}

	# loop through types
	for (b in 1:length(unique(ShorthandGuide_sorted$typeID[ShorthandGuide_sorted$category == category]))){
		typeID <- unique(ShorthandGuide_sorted$typeID[ShorthandGuide_sorted$category == category])[b]
		type_temp <- unique(ShorthandGuide_sorted [ShorthandGuide_sorted$category == category & ShorthandGuide_sorted$typeID == typeID, c("typeID","type", "typeDescription", "typeExample", "typeExample_explained", "where", "associatedType", "associatedType_leftright")])

		cat (paste("### Type: **", type_temp$type, "**\n\n", sep=""), file = textfile, append = TRUE)
	
		cat (paste(gsub ("\v", "\\\n", type_temp$typeDescription), "\n\n", sep=""), file = textfile, append = TRUE)

		cat (paste("**Position in shorthand**: ", type_temp$where, "\n\n", sep=""), file = textfile, append = TRUE)

		if (type_temp$associatedType != ""){
			cat (paste("**Fixed position**: ", type_temp$associatedType_leftright, " ", type_temp$associatedType, "\n\n", sep=""), file = textfile, append = TRUE)
			}

		cat (paste("<table class=\"table table-striped table-hover\">
		  <thead>
		    <tr class=\"warning\">
		      <td width=\"40%\"><strong>Example</strong></td>
		      <td width=\"60%\"><strong>Explanation</strong></td>
		    </tr>
		  </thead>
		  <tbody>
		    <tr>
		      <td><code>", gsub ("\v", "<br />", type_temp$typeExample),"</code></td>
		      <td>", type_temp$typeExample_explained, "</td>
		    </tr>
		   </tbody>
		   </table>\n\n", sep=""), file = textfile, append = TRUE)

		rm(type_temp)

		# loop through values in type
		for (c in 1:length(unique(ShorthandGuide_sorted$valueID[ShorthandGuide_sorted$category == category & ShorthandGuide_sorted$typeID == typeID]))){
			valueID <- unique(ShorthandGuide_sorted$valueID[ShorthandGuide_sorted$category == category & ShorthandGuide_sorted$typeID == typeID])[c]
			value_temp <- unique(ShorthandGuide_sorted [ShorthandGuide_sorted$category == category & ShorthandGuide_sorted$typeID == typeID & ShorthandGuide_sorted$valueID == valueID, c("valueID", "valueName", "valueDescription", "valueConditional", "caseSensitive")])

			cat (paste("#### Value: <span style=\"color:purple\">**", value_temp$valueName, "**</span>\n\n", sep=""), file = textfile, append = TRUE)
		
			cat (paste(gsub ("\v", "\\\n", value_temp$valueDescription), "\n\n", sep=""), file = textfile, append = TRUE)
	
			if (value_temp$caseSensitive != "no"){
			cat (paste("**Case sensitive**: ", value_temp$caseSensitive, "\n\n", sep=""), file = textfile, append = TRUE)
				}
	
			if (value_temp$valueConditional != "all"){
				cat (paste("**Conditional**: `", value_temp$valueConditional, "`\n\n", sep=""), file = textfile, append = TRUE)
				}

			cat (paste("**Syntax**: ", sep=""), file = textfile, append = TRUE)
						
			rm(value_temp)

			# loop through syntax in values
			syntax_how_many <- nrow(ShorthandGuide_sorted[ShorthandGuide_sorted$category == category & ShorthandGuide_sorted$typeID == typeID & ShorthandGuide_sorted$valueID == valueID,])
			for (d in 1:syntax_how_many){
				syntax_temp <- ShorthandGuide_sorted [ShorthandGuide_sorted$category == category & ShorthandGuide_sorted$typeID == typeID & ShorthandGuide_sorted$valueID == valueID, c("syntax")][d]
				
				# deal with the "~" syntax which, if sitting alone in markdown, wrecks the Jekyll page. Fixed by added a trailing space.
				if (syntax_temp == "~"){
					syntax_temp <- "~ "
					}

				if (syntax_how_many > 1){
					cat ("\n\n", file = textfile, append = TRUE)
					}
										
				cat (paste("`", syntax_temp, "`\n\n", sep=""), file = textfile, append = TRUE)

			}
			
		}		
	
	}	
	
}



