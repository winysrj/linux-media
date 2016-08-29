Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48646 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756632AbcH2MrC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Aug 2016 08:47:02 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-doc@vger.kernel.org
Subject: [PATCH] docs-rst: ignore arguments on macro definitions
Date: Mon, 29 Aug 2016 09:46:55 -0300
Message-Id: <4c17e7ca240665196c187b0d44c97b77fd1d2e3b.1472474795.git.mchehab@s-opensource.com>
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
 scripts/kernel-doc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index d225e178aa1b..040ee75ecfea 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -1852,7 +1852,7 @@ sub output_function_rst(%) {
 	if ($type =~ m/([^\(]*\(\*)\s*\)\s*\(([^\)]*)\)/) {
 	    # pointer-to-function
 	    print $1 . $parameter . ") (" . $2;
-	} else {
+	} elsif ($type ne "") {
 	    print $type . " " . $parameter;
 	}
     }
-- 
2.7.4


