Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36581 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759591AbcJRKGh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 06:06:37 -0400
Date: Tue, 18 Oct 2016 08:06:28 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Jonathan Corbet <corbet@lwn.net>,
        Jani Nikula <jani.nikula@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/4] doc-rst: reST-directive kernel-cmd / include
 contentent from scripts
Message-ID: <20161018080628.439a0f40@vento.lan>
In-Reply-To: <BF4516DA-435D-4469-B968-D8F5858DC9CF@darmarit.de>
References: <1475738420-8747-1-git-send-email-markus.heiser@darmarit.de>
        <1475738420-8747-2-git-send-email-markus.heiser@darmarit.de>
        <20161017144638.139491ad@vento.lan>
        <BF4516DA-435D-4469-B968-D8F5858DC9CF@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sorry, I missed part of your comments on my last reply...


Em Tue, 18 Oct 2016 09:03:28 +0200
Markus Heiser <markus.heiser@darmarit.de> escreveu:

> +-	``T:`` SCM tree type and location.
> +
> > +	- Type is one of: **git**, **hg**, **quilt**, **stgit**, **topgit**
> > +  
> 
> Hmm, why is the last line a bullet list, shouldn't it be:
> 
> +- ``T:`` SCM tree type and location
> +  Type is one of: git, hg, quilt, stgit, topgit

IMHO, it is better to output it as:

	- T: SCM tree type and location.

	  *  Type is one of: git, hg, quilt, stgit, topgit

Putting the explanation on a separate line, then merging the description
of the tag with the details about the valid values.

> 
> 
> > +-	``S:`` Status, one of the following:
> > +
> > +	   - Supported:
> > +			Someone is actually paid to look after this.  
> 
> Sorry, but I will never understand why you using mixed tabs and space 
> for the same thing ;-) ... what I mean; why is the top-list indented by 
> a tab after the bullet and the sub-list by two spaces ... 
> 
> We had the tab discussion already ... and IMO calling the CodeStyle is not
> helpful when using ASCII markup ... lets take the ASCI documentation compact
> and forget the tab ;-)

Well, my text editor is set to replace 8 spaces by tabs, as this is the
Kernel CodingStyle. I suspect other Kernel hackers do the same.
Using a different style just for documentation is really odd and will
cause problems, and make the maintainers life like hell if they would
need to manually check if a documentation hunk is not using tabs.

> 
> > +	   - Maintained:
> > +			Someone actually looks after it.
> > +	   - Odd Fixes:
> > +			It has a maintainer but they don't have time to do
> > 			much other than throw the odd patch in. See below..
> > -	   Orphan:	No current maintainer [but maybe you could take the
> > +	   - Orphan:
> > +			No current maintainer [but maybe you could take the
> > 			role as you write your new code].
> > -	   Obsolete:	Old code. Something tagged obsolete generally means
> > +	   - Obsolete:
> > +			Old code. Something tagged obsolete generally means
> > 			it has been replaced by a better system and you
> > 			should be using that.  
> 
> Hmm, here its the same with the indent. List, list-items, paragraphs etc. are all
> "body elements". 
> 
> * http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#body-elements
> 
> A body element is always introduced by a leading empty line. E.g:
> 
> - ``S:`` Status, one of the following:
> 
>  - Supported:
> 
>    Someone is actually paid to look after this.
> 
>  - Maintained:
> 
>    Someone actually looks after it.
> 
> or even more compact (which I do prefer), without paragraphs in the list items:
> 
> - ``S:`` Status, one of the following:
> 
>  - Supported: Someone is actually paid to look after this.
> 
>  - Maintained: Someone actually looks after it.

Hmm... we actually use a lot of markups on the media books like:

- foo
  - bar

when we want to put the first line in **bold**, as this seems to be the
only way to make the first line bold if it contains a verbatim.

There's an additional advantage of the above... it requires less typing
than:

- **foo**

  - bar

:-)

> 
> > -	F: Files and directories with wildcard patterns.
> > +-	``F:`` Files and directories with wildcard patterns.
> > +
> > 	   A trailing slash includes all files and subdirectory files.
> > -	   F:	drivers/net/	all files in and below drivers/net
> > -	   F:	drivers/net/*	all files in drivers/net, but not below
> > -	   F:	*/net/*		all files in "any top level directory"/net
> > -	   One pattern per line.  Multiple F: lines acceptable.
> > -	N: Files and directories with regex patterns.
> > -	   N:	[^a-z]tegra	all files whose path contains the word tegra
> > -	   One pattern per line.  Multiple N: lines acceptable.
> > -	   scripts/get_maintainer.pl has different behavior for files that
> > -	   match F: pattern and matches of N: patterns.  By default,
> > -	   get_maintainer will not look at git log history when an F: pattern
> > -	   match occurs.  When an N: match occurs, git log history is used
> > -	   to also notify the people that have git commit signatures.
> > -	X: Files and directories that are NOT maintained, same rules as F:
> > -	   Files exclusions are tested before file matches.
> > -	   Can be useful for excluding a specific subdirectory, for instance:
> > -	   F:	net/
> > -	   X:	net/ipv6/
> > -	   matches all files in and below net excluding net/ipv6/
> > -	K: Keyword perl extended regex pattern to match content in a
> > +
> > +	   ============================== ======================================
> > +	   ``F:``	``drivers/net/``	all files in and below
> > +						``drivers/net``
> > +	   ``F:``	``drivers/net/*``	all files in ``drivers/net``,
> > +						but not below
> > +	   ``F:``	``*/net/*``		all files in "any top level
> > +						directory" ``/net``
> > +	   ============================== ======================================
> > +
> > +	   One pattern per line.  Multiple ``F:`` lines acceptable.
> > +-	``N:`` Files and directories with regex patterns.  
> 
> Between the last two lines, a empty line is required ... I fond this more times
> (will not comment each).

Surely we can improve the markups here. Yet, the point is that the html
produced via kernel-cmd is completely different than he one produced by
calling the perl script directly. When kernel-cmd is used, lots of tags are 
not parsed.

That's said, if I add a logic at the script to expand the tabs before
output (patch enclosed), everything looks OK.

> 
> OK, I will stop here, if you are interested in I can prepare a patch for
> illustration ....
> 

Thanks,
Mauro


diff --git a/Documentation/sphinx/format_maintainers.pl b/Documentation/sphinx/format_maintainers.pl
index fb3af2a30c36..c3174c2b180a 100755
--- a/Documentation/sphinx/format_maintainers.pl
+++ b/Documentation/sphinx/format_maintainers.pl
@@ -1,4 +1,5 @@
 #!/usr/bin/perl
+use Text::Tabs;
 
 my $is_rst = 1;
 
@@ -15,18 +16,20 @@ my %tags = (
 );
 
 while (<>) {
+	my $s = expand($_);
+
 	if ($is_rst) {
-		if (m/^\s+\-+$/) {
+		if ($s =~ m/^\s+\-+$/) {
 			$is_rst = 0;
 			next;
 		}
-		print $_;
+		print $s;
 		next;
 	}
 
-	next if (m/^$/);
+	next if ($s =~ m/^\s*$/);
 
-	if (m/^([A-Z])\:(.*)/) {
+	if ($s =~ m/^([A-Z])\:(.*)/) {
 		my $tag = $1;
 		my $value = $2;
 
@@ -38,7 +41,7 @@ while (<>) {
 		next;
 	}
 
-	print "\n$_";
+	print "\n$s";
 }
 
 print "\n";



