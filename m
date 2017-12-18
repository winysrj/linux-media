Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:45484 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759027AbdLRMag (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Dec 2017 07:30:36 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Tom Saeger <tom.saeger@oracle.com>
Subject: [PATCH v4 01/18] docs: kernel-doc.rst: better describe kernel-doc arguments
Date: Mon, 18 Dec 2017 10:30:02 -0200
Message-Id: <016aaf0abc1b0e89e1765a6a2d761a7c17d41330.1513599193.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1513599193.git.mchehab@s-opensource.com>
References: <cover.1513599193.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1513599193.git.mchehab@s-opensource.com>
References: <cover.1513599193.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a new section to describe kernel-doc arguments,
adding examples about how identation should happen, as failing
to do that causes Sphinx to do the wrong thing.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/doc-guide/kernel-doc.rst | 44 +++++++++++++++++++++++++++++++---
 1 file changed, 41 insertions(+), 3 deletions(-)

diff --git a/Documentation/doc-guide/kernel-doc.rst b/Documentation/doc-guide/kernel-doc.rst
index 0268335414ce..f1c03c16f03b 100644
--- a/Documentation/doc-guide/kernel-doc.rst
+++ b/Documentation/doc-guide/kernel-doc.rst
@@ -112,16 +112,17 @@ Example kernel-doc function comment::
 
   /**
    * foobar() - Brief description of foobar.
-   * @arg: Description of argument of foobar.
+   * @argument1: Description of parameter argument1 of foobar.
+   * @argument2: Description of parameter argument2 of foobar.
    *
    * Longer description of foobar.
    *
    * Return: Description of return value of foobar.
    */
-  int foobar(int arg)
+  int foobar(int argument1, char *argument2)
 
 The format is similar for documentation for structures, enums, paragraphs,
-etc. See the sections below for details.
+etc. See the sections below for specific details of each type.
 
 The kernel-doc structure is extracted from the comments, and proper `Sphinx C
 Domain`_ function and type descriptions with anchors are generated for them. The
@@ -130,6 +131,43 @@ cross-references. See below for details.
 
 .. _Sphinx C Domain: http://www.sphinx-doc.org/en/stable/domains.html
 
+
+Parameters and member arguments
+-------------------------------
+
+The kernel-doc function comments describe each parameter to the function and
+function typedefs or each member of struct/union, in order, with the
+``@argument:`` descriptions. For each non-private member argument, one
+``@argument`` definition is needed.
+
+The ``@argument:`` descriptions begin on the very next line following
+the opening brief function description line, with no intervening blank
+comment lines.
+
+The ``@argument:`` descriptions may span multiple lines.
+
+.. note::
+
+   If the ``@argument`` description has multiple lines, the continuation
+   of the description should be starting exactly at the same column as
+   the previous line, e. g.::
+
+      * @argument: some long description
+      *       that continues on next lines
+
+   or::
+
+      * @argument:
+      *		some long description
+      *		that continues on next lines
+
+If a function or typedef parameter argument is ``...`` (e. g. a variable
+number of arguments), its description should be listed in kernel-doc
+notation as::
+
+      * @...: description
+
+
 Highlights and cross-references
 -------------------------------
 
-- 
2.14.3
