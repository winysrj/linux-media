Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:18511 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755801AbcHDIvG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Aug 2016 04:51:06 -0400
From: Jani Nikula <jani.nikula@intel.com>
To: Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Ben Hutchings <ben@decadent.org.uk>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Jani Nikula <jani.nikula@intel.com>,
	Daniel Baluta <daniel.baluta@intel.com>,
	Danilo Cesar Lemes de Paula <danilo.cesar@collabora.co.uk>
Subject: [PATCH] DocBook: use DOCBOOKS="" to ignore DocBooks instead of IGNORE_DOCBOOKS=1
Date: Thu,  4 Aug 2016 11:48:26 +0300
Message-Id: <1470300506-10151-1-git-send-email-jani.nikula@intel.com>
In-Reply-To: <872c1d8d911f1d4ee48b2185554a63aa9026dc1a.1468080758.git.mchehab@s-opensource.com>
References: <872c1d8d911f1d4ee48b2185554a63aa9026dc1a.1468080758.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of a separate ignore flag, use the obvious DOCBOOKS="" to ignore
all DocBook files. This is also in line with the Sphinx build being
ignored if a non-empty DOCBOOKS make variable is specified on the make
command line.

This replaces the IGNORE_DOCBOOKS introduced in

commit 547218864afb2745d9d137f005f3380ef96b26ab
Author: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Date:   Sat Jul 9 13:12:45 2016 -0300

    doc-rst: add an option to ignore DocBooks when generating docs

and aligns with

commit 6387872c86ea6698ed8faa3ccad1d1bd60f762f7
Author: Jani Nikula <jani.nikula@intel.com>
Date:   Fri Jul 1 15:24:44 2016 +0300

    Documentation/sphinx: skip build if user requested specific DOCBOOKS

Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>

---

Jon, if we agree on the change, I'd like to have this for 4.8 before
IGNORE_DOCBOOKS use proliferates.
---
 Documentation/DocBook/Makefile | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/Documentation/DocBook/Makefile b/Documentation/DocBook/Makefile
index 01bab5014a4a..fb32ab85ea3a 100644
--- a/Documentation/DocBook/Makefile
+++ b/Documentation/DocBook/Makefile
@@ -6,8 +6,6 @@
 # To add a new book the only step required is to add the book to the
 # list of DOCBOOKS.
 
-ifeq ($(IGNORE_DOCBOOKS),)
-
 DOCBOOKS := z8530book.xml device-drivers.xml \
 	    kernel-hacking.xml kernel-locking.xml deviceiobook.xml \
 	    writing_usb_driver.xml networking.xml \
@@ -19,6 +17,14 @@ DOCBOOKS := z8530book.xml device-drivers.xml \
 	    tracepoint.xml gpu.xml media_api.xml w1.xml \
 	    writing_musb_glue_layer.xml crypto-API.xml iio.xml
 
+ifeq ($(DOCBOOKS),)
+
+# Skip DocBook build if the user explicitly requested no DOCBOOKS.
+.DEFAULT:
+	@echo "  SKIP    DocBook $@ target (DOCBOOKS=\"\" specified)."
+
+else
+
 include Documentation/DocBook/media/Makefile
 
 ###
@@ -217,19 +223,7 @@ silent_gen_xml = :
 	       -e "s/>/\\&gt;/g";     \
 	   echo "</programlisting>")  > $@
 
-else
-
-# Needed, due to cleanmediadocs
-include Documentation/DocBook/media/Makefile
-
-htmldocs:
-pdfdocs:
-psdocs:
-xmldocs:
-installmandocs:
-
-endif # IGNORE_DOCBOOKS
-
+endif # DOCBOOKS=""
 
 ###
 # Help targets as used by the top-level makefile
@@ -246,7 +240,7 @@ dochelp:
 	@echo  '  make DOCBOOKS="s1.xml s2.xml" [target] Generate only docs s1.xml s2.xml'
 	@echo  '  valid values for DOCBOOKS are: $(DOCBOOKS)'
 	@echo
-	@echo  "  make IGNORE_DOCBOOKS=1 [target] Don't generate docs from Docbook"
+	@echo  "  make DOCBOOKS=\"\" [target] Don't generate docs from Docbook"
 	@echo  '     This is useful to generate only the ReST docs (Sphinx)'
 
 
-- 
2.1.4

