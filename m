Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.goneo.de ([85.220.129.30]:37432 "EHLO smtp1.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751953AbcJRHDq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 03:03:46 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH 1/4] doc-rst: reST-directive kernel-cmd / include contentent from scripts
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <20161017144638.139491ad@vento.lan>
Date: Tue, 18 Oct 2016 09:03:28 +0200
Cc: Jonathan Corbet <corbet@lwn.net>,
        Jani Nikula <jani.nikula@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-doc@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <BF4516DA-435D-4469-B968-D8F5858DC9CF@darmarit.de>
References: <1475738420-8747-1-git-send-email-markus.heiser@darmarit.de> <1475738420-8747-2-git-send-email-markus.heiser@darmarit.de> <20161017144638.139491ad@vento.lan>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 17.10.2016 um 18:46 schrieb Mauro Carvalho Chehab <mchehab@infradead.org>:

> Hi Markus,
> 
> Em Thu,  6 Oct 2016 09:20:17 +0200
> Markus Heiser <markus.heiser@darmarit.de> escreveu:
> 
>> From: Markus Heiser <markus.heiser@darmarIT.de>
>> 
>> The ``kernel-cmd`` directive includes contend from the stdout of a
>> command-line. With the ``kernel-cmd`` directive we can include the
>> output of any (Perl or whatever) script. This is a more general solution
>> for other workarounds like the "kernel_include + parseheaders" solution.
> 
> Unfortunately, there are some problems with kernel-cmd: it seems
> that it only partially parses the ReST file, not accepting several ReST tags.
> 
> See the enclosed patch and see the produced html file at:
> 	Documentation/output/user/MAINTAINERS.html
> 
> Then run the script manually with:
> 	./Documentation/sphinx/format_maintainers.pl MAINTAINERS >Documentation/user/MAINTAINERS.rst
> 
> And see the produced html output after re-building the user book.

Hmm, I can't see what you mean ... the MAINTAINERS.html is formated
according to the markup in the MAINTAINERS.html ... could you 
be more precise?  But before ... I added some comments in the patch
below to clarify.

OT but as I'am looking at:

/share/linux-docs-next/Documentation/user/BUG-HUNTING.rst:247: WARNING: undefined label: submittingpatches (if the link has no caption the label must precede a section header)
/share/linux-docs-next/Documentation/user/MAINTAINERS.rst:42: WARNING: undefined label: codingstyle (if the link has no caption the label must precede a section header)
/share/linux-docs-next/Documentation/user/MAINTAINERS.rst:47: WARNING: undefined label: submittingpatches (if the link has no caption the label must precede a section header)
/share/linux-docs-next/Documentation/user/MAINTAINERS.rst:61: WARNING: undefined label: submittingpatches (if the link has no caption the label must precede a section header)
/share/linux-docs-next/Documentation/user/README.rst:92: WARNING: undefined label: applying_patches (if the link has no caption the label must precede a section header)
/share/linux-docs-next/Documentation/user/README.rst:121: WARNING: undefined label: changes (if the link has no caption the label must precede a section header)
/share/linux-docs-next/Documentation/user/README.rst:256: WARNING: undefined label: changes (if the link has no caption the label must precede a section header)
/share/linux-docs-next/Documentation/user/devices.rst:9: WARNING: undefined label: submittingpatches (if the link has no caption the label must precede a section header)

.. this is why I think;  "links are the beginning of babylon" ;-)


> 
> PS.: You can test it on my git tree, with has the code to produce
> it at the lkml-books branch, at
> 	http:://git.linuxtv.org/mchehab/experimental.git
> 
> Regards,
> Mauro
> 
> 
> [PATCH] docs-rst: user: add MAINTAINERS
> 
> including MAINTAINERS using ReST is tricky, because all
> maintainer's entries are like:
> 
> FOO SUBSYSTEM:
> M: My Name <my@name>
> L: mailing@list
> S: Maintained
> F: foo/bar
> 
> On ReST, this would be displayed on a single line. Using
> alias, like |M|, |L|, ... won't solve, as an alias in
> Sphinx doesn't accept breaking lines.
> 
> So, instead of changing every line at MAINTAINERS, let's
> use kernel-cmd extension in order to parse it via a script.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> 
> diff --git a/Documentation/sphinx/format_maintainers.pl b/Documentation/sphinx/format_maintainers.pl
> new file mode 100755
> index 000000000000..fb3af2a30c36
> --- /dev/null
> +++ b/Documentation/sphinx/format_maintainers.pl
> @@ -0,0 +1,44 @@
> +#!/usr/bin/perl
> +
> +my $is_rst = 1;
> +
> +# For now, ignore file tags, like F, N, X, K.
> +my %tags = (
> +	'P' => 'Person',
> +	'M' => 'Mail',
> +	'R' => 'Designated reviewer',
> +	'L' => 'Mailing list',
> +	'W' => 'Web page',
> +	'Q' => 'Patchwork',
> +	'T' => 'Develoment tree',
> +	'S' => 'Status',
> +);
> +
> +while (<>) {
> +	if ($is_rst) {
> +		if (m/^\s+\-+$/) {
> +			$is_rst = 0;
> +			next;
> +		}
> +		print $_;
> +		next;
> +	}
> +
> +	next if (m/^$/);
> +
> +	if (m/^([A-Z])\:(.*)/) {
> +		my $tag = $1;
> +		my $value = $2;
> +
> +		my $meaning;
> +
> +		next if (!defined($tags{$tag}));
> +
> +		printf " - %s:\n   %s\n\n", $tags{$tag}, $value;
> +		next;
> +	}
> +
> +	print "\n$_";
> +}
> +
> +print "\n";

OK, its a starting point, but it is IMO a bit poor.
I missed the 'F' section and the markup arguable

|3C59X NETWORK DRIVER
| - Mail:
|   	Steffen Klassert <klassert@mathematik.tu-chemnitz.de>
|
| - Mailing list:
|   	netdev@vger.kernel.org
|
| - Status:
|   	Maintained

I prefer would prefer an indent of zero/two spaces and no tabs:

|3C59X NETWORK DRIVER
|--------------------
|
|- Mail:
|
|  * Steffen Klassert <klassert@mathematik.tu-chemnitz.de>
|
|- Mailing list:
| 
|  * netdev@vger.kernel.org
|
|- Status:
| 
|  * Maintained

Anyway, the first time I thought MAINTAINERS is a database,
I also thought, the scripts/get_maintainers.pl is "the parser".
But my perl is poor and I have not yet looked closer / did you?


> diff --git a/Documentation/user/MAINTAINERS.rst b/Documentation/user/MAINTAINERS.rst
> new file mode 100644
> index 000000000000..9b01b51749bd
> --- /dev/null
> +++ b/Documentation/user/MAINTAINERS.rst
> @@ -0,0 +1 @@
> +.. kernel-cmd:: format_maintainers.pl $srctree/MAINTAINERS
> diff --git a/Documentation/user/index.rst b/Documentation/user/index.rst
> index 6fbb2dc4b3b7..c4bfd45f0649 100644
> --- a/Documentation/user/index.rst
> +++ b/Documentation/user/index.rst
> @@ -32,3 +32,4 @@ Contents:
>   java
>   bad_memory
>   basic_profiling
> +   MAINTAINERS
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 1cd38a7e0064..d46ffec4e682 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1,12 +1,14 @@
> -
> -
> -	List of maintainers and how to submit kernel changes
> +List of maintainers and how to submit kernel changes
> +====================================================
> 
> Please try to follow the guidelines below.  This will make things
> easier on the maintainers.  Not all of these guidelines matter for every
> trivial patch so apply some common sense.
> 
> -1.	Always _test_ your changes, however small, on at least 4 or
> +Tips for patch submitters
> +-------------------------
> +
> +1.	Always **test** your changes, however small, on at least 4 or
> 	5 people, preferably many more.
> 
> 2.	Try to release a few ALPHA test versions to the net. Announce
> @@ -15,7 +17,7 @@ trivial patch so apply some common sense.
> 	you will find things like the fact version 3 firmware needs
> 	a magic fix you didn't know about, or some clown changed the
> 	chips on a board and not its name.  (Don't laugh!  Look at the
> -	SMC etherpower for that.)
> +	SMC ``etherpower`` for that.)
> 
> 3.	Make sure your changes compile correctly in multiple
> 	configurations. In particular check that changes work both as a
> @@ -25,7 +27,7 @@ trivial patch so apply some common sense.
> 	testing and await feedback.
> 
> 5.	Make a patch available to the relevant maintainer in the list. Use
> -	'diff -u' to make the patch easy to merge. Be prepared to get your
> +	``diff -u`` to make the patch easy to merge. Be prepared to get your
> 	changes sent back with seemingly silly requests about formatting
> 	and variable names.  These aren't as silly as they seem. One
> 	job the maintainers (and especially Linus) do is to keep things
> @@ -33,28 +35,34 @@ trivial patch so apply some common sense.
> 	your driver to get around a problem actually needs to become a
> 	generalized kernel feature ready for next time.
> 
> -	PLEASE check your patch with the automated style checker
> -	(scripts/checkpatch.pl) to catch trivial style violations.
> -	See Documentation/CodingStyle for guidance here.
> +	.. attention::
> +
> +	  **PLEASE:**
> +
> +	  - check your patch with the automated style checker
> +	    (``scripts/checkpatch.pl``) to catch trivial style violations.
> +	    See :ref:`Documentation/CodingStyle <codingstyle>` for guidance
> +	    here.
> 
> -	PLEASE CC: the maintainers and mailing lists that are generated
> -	by scripts/get_maintainer.pl.  The results returned by the
> -	script will be best if you have git installed and are making
> -	your changes in a branch derived from Linus' latest git tree.
> -	See Documentation/SubmittingPatches for details.
> +	  - CC: the maintainers and mailing lists that are generated
> +	    by ``scripts/get_maintainer.pl``.  The results returned by the
> +	    script will be best if you have git installed and are making
> +	    your changes in a branch derived from Linus' latest git tree.
> +	    See :ref:`Documentation/SubmittingPatches <submittingpatches>`
> +	    for details.
> 
> -	PLEASE try to include any credit lines you want added with the
> -	patch. It avoids people being missed off by mistake and makes
> -	it easier to know who wants adding and who doesn't.
> +	  - try to include any credit lines you want added with the
> +	    patch. It avoids people being missed off by mistake and makes
> +	    it easier to know who wants adding and who doesn't.
> 
> -	PLEASE document known bugs. If it doesn't work for everything
> -	or does something very odd once a month document it.
> +	  - document known bugs. If it doesn't work for everything
> +	    or does something very odd once a month document it.
> 
> -	PLEASE remember that submissions must be made under the terms
> -	of the Linux Foundation certificate of contribution and should
> -	include a Signed-off-by: line.  The current version of this
> -	"Developer's Certificate of Origin" (DCO) is listed in the file
> -	Documentation/SubmittingPatches.
> +	  - remember that submissions must be made under the terms
> +	    of the Linux Foundation certificate of contribution and should
> +	    include a Signed-off-by: line.  The current version of this
> +	    "Developer's Certificate of Origin" (DCO) is listed in the file
> +	    :ref:`Documentation/SubmittingPatches <submittingpatches>`.
> 
> 6.	Make sure you have the right to send any changes you make. If you
> 	do changes at work you may find your employer owns the patch
> @@ -66,64 +74,103 @@ trivial patch so apply some common sense.
> 
> 8.	Happy hacking.
> 
> -Descriptions of section entries:
> -
> -	P: Person (obsolete)
> -	M: Mail patches to: FullName <address@domain>
> -	R: Designated reviewer: FullName <address@domain>
> -	   These reviewers should be CCed on patches.
> -	L: Mailing list that is relevant to this area
> -	W: Web-page with status/info
> -	Q: Patchwork web based patch tracking system site
> -	T: SCM tree type and location.
> -	   Type is one of: git, hg, quilt, stgit, topgit
> -	S: Status, one of the following:
> -	   Supported:	Someone is actually paid to look after this.
> -	   Maintained:	Someone actually looks after it.
> -	   Odd Fixes:	It has a maintainer but they don't have time to do
> +Descriptions of section entries
> +-------------------------------
> +
> +-	``P:`` Person (obsolete)
> +-	``M:`` Mail patches to: FullName <address@domain>
> +-	``R:`` Designated reviewer: FullName <address@domain>
> +
> +	- These reviewers should be CCed on patches.
> +
> +-	``L:`` Mailing list that is relevant to this area
> +-	``W:`` Web-page with status/info
> +-	``Q:`` Patchwork web based patch tracking system site
> +-	``T:`` SCM tree type and location.
> +
> +	- Type is one of: **git**, **hg**, **quilt**, **stgit**, **topgit**
> +

Hmm, why is the last line a bullet list, shouldn't it be:

+- ``T:`` SCM tree type and location
+  Type is one of: git, hg, quilt, stgit, topgit


> +-	``S:`` Status, one of the following:
> +
> +	   - Supported:
> +			Someone is actually paid to look after this.

Sorry, but I will never understand why you using mixed tabs and space 
for the same thing ;-) ... what I mean; why is the top-list indented by 
a tab after the bullet and the sub-list by two spaces ... 

We had the tab discussion already ... and IMO calling the CodeStyle is not
helpful when using ASCII markup ... lets take the ASCI documentation compact
and forget the tab ;-)

> +	   - Maintained:
> +			Someone actually looks after it.
> +	   - Odd Fixes:
> +			It has a maintainer but they don't have time to do
> 			much other than throw the odd patch in. See below..
> -	   Orphan:	No current maintainer [but maybe you could take the
> +	   - Orphan:
> +			No current maintainer [but maybe you could take the
> 			role as you write your new code].
> -	   Obsolete:	Old code. Something tagged obsolete generally means
> +	   - Obsolete:
> +			Old code. Something tagged obsolete generally means
> 			it has been replaced by a better system and you
> 			should be using that.

Hmm, here its the same with the indent. List, list-items, paragraphs etc. are all
"body elements". 

* http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#body-elements

A body element is always introduced by a leading empty line. E.g:

- ``S:`` Status, one of the following:

 - Supported:

   Someone is actually paid to look after this.

 - Maintained:

   Someone actually looks after it.

or even more compact (which I do prefer), without paragraphs in the list items:

- ``S:`` Status, one of the following:

 - Supported: Someone is actually paid to look after this.

 - Maintained: Someone actually looks after it.

> -	F: Files and directories with wildcard patterns.
> +-	``F:`` Files and directories with wildcard patterns.
> +
> 	   A trailing slash includes all files and subdirectory files.
> -	   F:	drivers/net/	all files in and below drivers/net
> -	   F:	drivers/net/*	all files in drivers/net, but not below
> -	   F:	*/net/*		all files in "any top level directory"/net
> -	   One pattern per line.  Multiple F: lines acceptable.
> -	N: Files and directories with regex patterns.
> -	   N:	[^a-z]tegra	all files whose path contains the word tegra
> -	   One pattern per line.  Multiple N: lines acceptable.
> -	   scripts/get_maintainer.pl has different behavior for files that
> -	   match F: pattern and matches of N: patterns.  By default,
> -	   get_maintainer will not look at git log history when an F: pattern
> -	   match occurs.  When an N: match occurs, git log history is used
> -	   to also notify the people that have git commit signatures.
> -	X: Files and directories that are NOT maintained, same rules as F:
> -	   Files exclusions are tested before file matches.
> -	   Can be useful for excluding a specific subdirectory, for instance:
> -	   F:	net/
> -	   X:	net/ipv6/
> -	   matches all files in and below net excluding net/ipv6/
> -	K: Keyword perl extended regex pattern to match content in a
> +
> +	   ============================== ======================================
> +	   ``F:``	``drivers/net/``	all files in and below
> +						``drivers/net``
> +	   ``F:``	``drivers/net/*``	all files in ``drivers/net``,
> +						but not below
> +	   ``F:``	``*/net/*``		all files in "any top level
> +						directory" ``/net``
> +	   ============================== ======================================
> +
> +	   One pattern per line.  Multiple ``F:`` lines acceptable.
> +-	``N:`` Files and directories with regex patterns.

Between the last two lines, a empty line is required ... I fond this more times
(will not comment each).

OK, I will stop here, if you are interested in I can prepare a patch for
illustration ....

-- Markus --


> +
> +	   ============================ ========================================
> +	   ``N:``	``[^a-z]tegra``		all files whose path contains
> +						the word ``tegra``
> +	   ============================ ========================================
> +
> +	   One pattern per line.  Multiple ``N:`` lines acceptable.
> +	   ``scripts/get_maintainer.pl`` has different behavior for files that
> +	   match ``F:`` pattern and matches of ``N:`` patterns.  By default,
> +	   get_maintainer will not look at git log history when an ``F:``
> +	   pattern match occurs.  When an ``N:`` match occurs, git log history
> +	   is used to also notify the people that have git commit signatures.
> +-	``X:`` Files and directories that are NOT maintained, same rules as
> +	``F:`` Files exclusions are tested before file matches.
> +	Can be useful for excluding a specific subdirectory, for instance:
> +
> +	   ============================ ========================================
> +	   ``F:``	``net/``	matches all files in and below
> +					``net`` ...
> +	   ``X:``	``net/ipv6/``	... excluding ``net/ipv6/``
> +	   ============================ ========================================
> +
> +-	``K:`` Keyword perl extended regex pattern to match content in a
> 	   patch or file.  For instance:
> -	   K: of_get_profile
> -	      matches patches or files that contain "of_get_profile"
> -	   K: \b(printk|pr_(info|err))\b
> -	      matches patches or files that contain one or more of the words
> -	      printk, pr_info or pr_err
> -	   One regex pattern per line.  Multiple K: lines acceptable.
> 
> -Note: For the hard of thinking, this list is meant to remain in alphabetical
> -order. If you could add yourselves to it in alphabetical order that would be
> -so much easier [Ed]
> +	   =========================================== =========================
> +	   ``K:`` ``of_get_profile``			matches patches or files
> +							that contain
> +							``of_get_profile``
> +	   ``K:`` ``\b(printk|pr_(info|err))\b``	matches patches or
> +							files that contain one
> +							or more of the words
> +							``printk``, ``pr_info``
> +							or ``pr_err``
> +	   =========================================== =========================
> +
> +	   One regex pattern per line.  Multiple ``K:`` lines acceptable.
> +
> +.. note::
> +
> +  For the hard of thinking, this list is meant to remain in alphabetical
> +  order. If you could add yourselves to it in alphabetical order that would be
> +  so much easier [Ed]
> 
> Maintainers List (try to look for most precise areas first)
> +-----------------------------------------------------------
> 
> 		-----------------------------------
> 
> +
> 3C59X NETWORK DRIVER
> M:	Steffen Klassert <klassert@mathematik.tu-chemnitz.de>
> L:	netdev@vger.kernel.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-doc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

