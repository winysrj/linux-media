Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50359 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932517AbcGOK6O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2016 06:58:14 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jani Nikula <jani.nikula@intel.com>, linux-doc@vger.kernel.org
Subject: [PATCH] doc-rst: Fix compilation of the pdf docbook
Date: Fri, 15 Jul 2016 07:58:07 -0300
Message-Id: <520a247760f750307b53db905a10a17df1700f3b.1468580259.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The rst2pdf tool is a very broken toolchain, with is not capable
of parsing complex documents. As such, it doesn't build the
media book, failing with:

	[ERROR] pdfbuilder.py:130 too many values to unpack

(using rst2pdf version 0.93.dev-r0 and Sphinx version 1.4.5)

So, make it build only the books we know that are safe to build.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

--

Btw, with the standard Sphinx version shipped on Fedora 24 (Sphinx
1.3.1), rst2pdf doesn't build even the simple kernel-documentation,
failing with this error:
    writing Kernel... [ERROR] pdfbuilder.py:130 list index out of range

This is a known bug:
    https://github.com/sphinx-doc/sphinx/issues/1844

So, maybe we should just disable pdf generation from RST for good,
as I suspect that maintaining it with a broken toolchain will be a
big headache.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/conf.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/conf.py b/Documentation/conf.py
index 224240b5bc50..96b7aa66c89c 100644
--- a/Documentation/conf.py
+++ b/Documentation/conf.py
@@ -411,7 +411,7 @@ epub_exclude_files = ['search.html']
 # multiple PDF files here actually tries to get the cross-referencing right
 # *between* PDF files.
 pdf_documents = [
-    ('index', u'Kernel', u'Kernel', u'J. Random Bozo'),
+    ('kernel-documentation', u'Kernel', u'Kernel', u'J. Random Bozo'),
 ]
 
 # kernel-doc extension configuration for running Sphinx directly (e.g. by Read
-- 
2.7.4


