Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56708 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbcGIPpN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Jul 2016 11:45:13 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Ben Hutchings <ben@decadent.org.uk>,
	Jani Nikula <jani.nikula@intel.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Danilo Cesar Lemes de Paula <danilo.cesar@collabora.co.uk>,
	linux-doc@vger.kernel.org
Subject: [PATCH] doc-rst: add an option to ignore DocBooks when generating docs
Date: Sat,  9 Jul 2016 12:44:59 -0300
Message-Id: <e26db814396d9fc73e29e0b3a2397b859f9fd357.1468079076.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sometimes, we want to do a partial build, instead of building
everything. However, right now, if one wants to build just
Sphinx books, it will build also the DocBooks.

Add an option to allow to ignore all DocBooks when building
documentation.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/DocBook/Makefile | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/DocBook/Makefile b/Documentation/DocBook/Makefile
index 496d4295ec38..1d322f2d421e 100644
--- a/Documentation/DocBook/Makefile
+++ b/Documentation/DocBook/Makefile
@@ -6,6 +6,8 @@
 # To add a new book the only step required is to add the book to the
 # list of DOCBOOKS.
 
+ifeq ($(IGNORE_DOCBOOKS),)
+
 DOCBOOKS := z8530book.xml device-drivers.xml \
 	    kernel-hacking.xml kernel-locking.xml deviceiobook.xml \
 	    writing_usb_driver.xml networking.xml \
@@ -17,6 +19,13 @@ DOCBOOKS := z8530book.xml device-drivers.xml \
 	    tracepoint.xml gpu.xml media_api.xml w1.xml \
 	    writing_musb_glue_layer.xml crypto-API.xml iio.xml
 
+else # IGNORE_DOCBOOKS
+
+DOCBOOKS = ""
+
+endif # IGNORE_DOCBOOKS
+
+
 include Documentation/DocBook/media/Makefile
 
 ###
@@ -229,6 +238,9 @@ dochelp:
 	@echo
 	@echo  '  make DOCBOOKS="s1.xml s2.xml" [target] Generate only docs s1.xml s2.xml'
 	@echo  '  valid values for DOCBOOKS are: $(DOCBOOKS)'
+	@echo
+	@echo  "  make IGNORE_DOCBOOKS=1 [target] Don't generate docs from Docbook"
+	@echo  '     This is useful to generate only the ReST docs (Sphinx)'
 
 
 ###
-- 
2.7.4

