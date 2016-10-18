Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:40188 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758303AbcJRGHH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 02:07:07 -0400
From: Jani Nikula <jani.nikula@intel.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Markus Heiser <markus.heiser@darmarit.de>
Cc: Jonathan Corbet <corbet@lwn.net>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-doc@vger.kernel.org, Joe Perches <joe@perches.com>
Subject: Re: [PATCH 1/4] doc-rst: reST-directive kernel-cmd / include contentent from scripts
In-Reply-To: <20161017144638.139491ad@vento.lan>
References: <1475738420-8747-1-git-send-email-markus.heiser@darmarit.de> <1475738420-8747-2-git-send-email-markus.heiser@darmarit.de> <20161017144638.139491ad@vento.lan>
Date: Tue, 18 Oct 2016 09:07:03 +0300
Message-ID: <87lgxmxkag.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 17 Oct 2016, Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
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

Soon I'm going to stop fighting the windmills...

If you're going to insist on getting kernel-cmd upstream (and I haven't
changed my opinion on that) please at least have the sense to have just
*one* perl script to parse MAINTAINERS, not many. The one script should
be scripts/get_maintainer.pl.


BR,
Jani.

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
>     java
>     bad_memory
>     basic_profiling
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
>  Please try to follow the guidelines below.  This will make things
>  easier on the maintainers.  Not all of these guidelines matter for every
>  trivial patch so apply some common sense.
>  
> -1.	Always _test_ your changes, however small, on at least 4 or
> +Tips for patch submitters
> +-------------------------
> +
> +1.	Always **test** your changes, however small, on at least 4 or
>  	5 people, preferably many more.
>  
>  2.	Try to release a few ALPHA test versions to the net. Announce
> @@ -15,7 +17,7 @@ trivial patch so apply some common sense.
>  	you will find things like the fact version 3 firmware needs
>  	a magic fix you didn't know about, or some clown changed the
>  	chips on a board and not its name.  (Don't laugh!  Look at the
> -	SMC etherpower for that.)
> +	SMC ``etherpower`` for that.)
>  
>  3.	Make sure your changes compile correctly in multiple
>  	configurations. In particular check that changes work both as a
> @@ -25,7 +27,7 @@ trivial patch so apply some common sense.
>  	testing and await feedback.
>  
>  5.	Make a patch available to the relevant maintainer in the list. Use
> -	'diff -u' to make the patch easy to merge. Be prepared to get your
> +	``diff -u`` to make the patch easy to merge. Be prepared to get your
>  	changes sent back with seemingly silly requests about formatting
>  	and variable names.  These aren't as silly as they seem. One
>  	job the maintainers (and especially Linus) do is to keep things
> @@ -33,28 +35,34 @@ trivial patch so apply some common sense.
>  	your driver to get around a problem actually needs to become a
>  	generalized kernel feature ready for next time.
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
>  6.	Make sure you have the right to send any changes you make. If you
>  	do changes at work you may find your employer owns the patch
> @@ -66,64 +74,103 @@ trivial patch so apply some common sense.
>  
>  8.	Happy hacking.
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
> +-	``S:`` Status, one of the following:
> +
> +	   - Supported:
> +			Someone is actually paid to look after this.
> +	   - Maintained:
> +			Someone actually looks after it.
> +	   - Odd Fixes:
> +			It has a maintainer but they don't have time to do
>  			much other than throw the odd patch in. See below..
> -	   Orphan:	No current maintainer [but maybe you could take the
> +	   - Orphan:
> +			No current maintainer [but maybe you could take the
>  			role as you write your new code].
> -	   Obsolete:	Old code. Something tagged obsolete generally means
> +	   - Obsolete:
> +			Old code. Something tagged obsolete generally means
>  			it has been replaced by a better system and you
>  			should be using that.
> -	F: Files and directories with wildcard patterns.
> +-	``F:`` Files and directories with wildcard patterns.
> +
>  	   A trailing slash includes all files and subdirectory files.
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
>  	   patch or file.  For instance:
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
>  Maintainers List (try to look for most precise areas first)
> +-----------------------------------------------------------
>  
>  		-----------------------------------
>  
> +
>  3C59X NETWORK DRIVER
>  M:	Steffen Klassert <klassert@mathematik.tu-chemnitz.de>
>  L:	netdev@vger.kernel.org

-- 
Jani Nikula, Intel Open Source Technology Center
