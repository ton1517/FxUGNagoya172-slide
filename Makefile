index.html : slide.md
	markdown2impress.pl --width=1200 --height=800 slide.md

clean :
	rm index.html
