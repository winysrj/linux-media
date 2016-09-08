Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43774 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941744AbcIHMES (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 08:04:18 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Markus Heiser <markus.heiser@darmarit.de>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>
Subject: [PATCH 01/47] kernel-doc: ignore arguments on macro definitions
Date: Thu,  8 Sep 2016 09:03:23 -0300
Message-Id: <db18427370e54fb936ad0786b8a8e49fd2f407c1.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A macro definition is mapped via .. c:function:: at the
ReST markup when using the following kernel-doc tag:

	/**
	 * DMX_FE_ENTRY - Casts elements in the list of registered
	 *               front-ends from the generic type struct list_head
	 *               to the type * struct dmx_frontend
	 *
	 * @list: list of struct dmx_frontend
	 */
	 #define DMX_FE_ENTRY(list) \
	        list_entry(list, struct dmx_frontend, connectivity_list)

However, unlike a function description, the arguments of a macro
doesn't contain the data type.

This causes warnings when enabling Sphinx on nitkpick mode,
like this one:
	./drivers/media/dvb-core/demux.h:358: WARNING: c:type reference target not found: list

That happens because kernel-doc output for the above is:

	.. c:function:: DMX_FE_ENTRY ( list)

	   Casts elements in the list of registered front-ends from the generic type struct list_head to the type * struct dmx_frontend

	**Parameters**

	``list``
	  list of struct dmx_frontend

As the type is blank, Sphinx would think that ``list`` is a type,
and will try to add a cross reference for it, using their internal
representation for c:type:`list`.

However, ``list`` is not a type. So, that would cause either the
above warning, or if a ``list`` type exists, it would create
a reference to the wrong place at the doc.

To avoid that, let's ommit macro arguments from c:function::
declaration. As each argument will appear below the Parameters,
the type of the argument can be described there, if needed.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 scripts/kernel-doc | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index 93721f3c91bf..3db6e6ac83f1 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -1857,14 +1857,15 @@ sub output_function_rst(%) {
 	if ($count ne 0) {
 	    print ", ";
 	}
-	$count++;
 	$type = $args{'parametertypes'}{$parameter};
 
 	if ($type =~ m/([^\(]*\(\*)\s*\)\s*\(([^\)]*)\)/) {
 	    # pointer-to-function
 	    print $1 . $parameter . ") (" . $2;
-	} else {
+	    $count++;
+	} elsif ($type ne "") {
 	    print $type . " " . $parameter;
+	    $count++;
 	}
     }
     if ($args{'typedef'}) {
-- 
2.7.4


