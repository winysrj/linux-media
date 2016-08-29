Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51650 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757366AbcH2Mz7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Aug 2016 08:55:59 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-doc@vger.kernel.org
Subject: [PATCH v2] docs-rst: ignore arguments on macro definitions
Date: Mon, 29 Aug 2016 09:55:42 -0300
Message-Id: <2bc627fc006b463962b93e0500f44a6f87b88cc1.1472475301.git.mchehab@s-opensource.com>
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

v2: handle the case of macros with multiple arguments


 scripts/kernel-doc | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index d225e178aa1b..47a791cbede3 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -1846,13 +1846,13 @@ sub output_function_rst(%) {
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
 	}
     }
-- 
2.7.4


