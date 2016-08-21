Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43670 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752487AbcHUMMD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 21 Aug 2016 08:12:03 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Markus Heiser <markus.heiser@darmarit.de>,
        Jani Nikula <jani.nikula@intel.com>, linux-doc@vger.kernel.org
Subject: [PATCH] docs-rst: kernel-doc: better output struct members
Date: Sun, 21 Aug 2016 09:11:57 -0300
Message-Id: <45996a8dc149f7de6ed09d703b76cb65e55b7a9a.1471781478.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Right now, for a struct, kernel-doc produces the following output:

	.. c:type:: struct v4l2_prio_state

	   stores the priority states

	**Definition**

	::

	  struct v4l2_prio_state {
	    atomic_t prios[4];
	  };

	**Members**

	``atomic_t prios[4]``
	  array with elements to store the array priorities

Putting a member name in verbatim and adding a continuation line
causes the LaTeX output to generate something like:
	item[atomic_t prios\[4\]] array with elements to store the array priorities

Everything inside "item" is non-breakable, with may produce
lines bigger than the column width.

Also, for function members, like:

        int (* rx_read) (struct v4l2_subdev *sd, u8 *buf, size_t count,ssize_t *num);

It puts the name of the member at the end, like:

        int (*) (struct v4l2_subdev *sd, u8 *buf, size_t count,ssize_t *num) read

With is very confusing.

The best is to highlight what really matters: the member name; the type
is a secondary information.

So, change kernel-doc, for it to produce the output on a different way:

	**Members**

	``prios[4]``
	  - **type**: ``atomic_t``

	  array with elements to store the array priorities

With such change, the name of the member will be the first visible
thing, and will be in bold style. The type will still be there, inside
a list.

Also, as the type is not part of LaTeX "item[]", LaTeX will split it into
multiple lines, if needed.

So, both LaTeX/PDF and HTML outputs will look good.

It should be noticed, however, that the way Sphinx LaTeX output handles
things like:

	Foo
	   bar

is different than the HTML output. On HTML, it will produce something
like:

	**Foo**
	   bar

While, on LaTeX, it puts both foo and bar at the same line, like:

	**Foo** bar

By starting the second line with a dash, both HTML and LaTeX output
will do the same thing.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 scripts/kernel-doc | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index ba081c7636a2..78e355281e1a 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -2000,7 +2000,8 @@ sub output_struct_rst(%) {
 	($args{'parameterdescs'}{$parameter_name} ne $undescribed) || next;
 	$type = $args{'parametertypes'}{$parameter};
         print_lineno($parameterdesc_start_lines{$parameter_name});
-	print "``$type $parameter``\n";
+	print "``" . $parameter . "``\n";
+	print "  - **type**: ``$type``\n\n";
 	output_highlight_rst($args{'parameterdescs'}{$parameter_name});
 	print "\n";
     }
-- 
2.7.4


