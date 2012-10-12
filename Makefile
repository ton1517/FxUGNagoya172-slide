index.html : slide.md
	markdown2impress.pl --width=1200 --height=800 --column=8 slide.md

clean :
	rm index.html
