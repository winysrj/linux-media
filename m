Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53548 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212AbcGTOLL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2016 10:11:11 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-doc@vger.kernel.org
Subject: [PATCH] doc-rst: get rid of warnings at kernel-documentation.rst
Date: Wed, 20 Jul 2016 11:11:05 -0300
Message-Id: <610951ea382e015f178bb55391ea21bd80132d70.1469023848.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sphinx 1.4.5 complains about some literal blocks at
kernel-documentation.rst:

	Documentation/kernel-documentation.rst:373: WARNING: Could not lex literal_block as "C". Highlighting skipped.
	Documentation/kernel-documentation.rst:378: WARNING: Could not lex literal_block as "C". Highlighting skipped.
	Documentation/kernel-documentation.rst:576: WARNING: Could not lex literal_block as "C". Highlighting skipped.

Fix it by telling Sphinx to consider them as "none" type.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/kernel-documentation.rst | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/kernel-documentation.rst b/Documentation/kernel-documentation.rst
index 391decc66a18..1dd97478743e 100644
--- a/Documentation/kernel-documentation.rst
+++ b/Documentation/kernel-documentation.rst
@@ -370,11 +370,15 @@ To cross-reference the functions and types defined in the kernel-doc comments
 from reStructuredText documents, please use the `Sphinx C Domain`_
 references. For example::
 
+.. code-block:: none
+
   See function :c:func:`foo` and struct/union/enum/typedef :c:type:`bar`.
 
 While the type reference works with just the type name, without the
 struct/union/enum/typedef part in front, you may want to use::
 
+.. code-block:: none
+
   See :c:type:`struct foo <foo>`.
   See :c:type:`union bar <bar>`.
   See :c:type:`enum baz <baz>`.
@@ -573,6 +577,8 @@ converted to Sphinx and reStructuredText. For most DocBook XML documents, a good
 enough solution is to use the simple ``Documentation/sphinx/tmplcvt`` script,
 which uses ``pandoc`` under the hood. For example::
 
+.. code-block:: none
+
   $ cd Documentation/sphinx
   $ ./tmplcvt ../DocBook/in.tmpl ../out.rst
 
-- 
2.7.4


