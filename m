Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49619 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938773AbcHJSrO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Aug 2016 14:47:14 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH] doc-rst: build the dynamic rst files for non-html doc targets
Date: Wed, 10 Aug 2016 05:35:11 -0300
Message-Id: <65c5113d1b9b27f7fd7eae997e034da532f918c9.1470818058.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Right now, the media makefile is called only for html docs.
Call it also for the other documentation targets.

Please notice that, while we added it to pdf target at
Documentation/media/Makefile, it won't actually build
a PDF from media, because rst2pdf can't handle complex
documents.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 Documentation/Makefile.sphinx | 2 ++
 Documentation/media/Makefile  | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/Documentation/Makefile.sphinx b/Documentation/Makefile.sphinx
index 857f1e273418..038559388168 100644
--- a/Documentation/Makefile.sphinx
+++ b/Documentation/Makefile.sphinx
@@ -53,9 +53,11 @@ else # HAVE_RST2PDF
 endif # HAVE_RST2PDF
 
 epubdocs:
+	$(MAKE) BUILDDIR=$(BUILDDIR) -f $(srctree)/Documentation/media/Makefile $@
 	$(call cmd,sphinx,epub)
 
 xmldocs:
+	$(MAKE) BUILDDIR=$(BUILDDIR) -f $(srctree)/Documentation/media/Makefile $@
 	$(call cmd,sphinx,xml)
 
 # no-ops for the Sphinx toolchain
diff --git a/Documentation/media/Makefile b/Documentation/media/Makefile
index 39e2d766dbe3..79784e848fc0 100644
--- a/Documentation/media/Makefile
+++ b/Documentation/media/Makefile
@@ -11,6 +11,9 @@ FILES = audio.h.rst ca.h.rst dmx.h.rst frontend.h.rst net.h.rst video.h.rst \
 TARGETS := $(addprefix $(BUILDDIR)/, $(FILES))
 
 htmldocs: $(BUILDDIR) ${TARGETS}
+epubdocs: $(BUILDDIR) ${TARGETS}
+xmldocs: $(BUILDDIR) ${TARGETS}
+pdfdocs: $(BUILDDIR) ${TARGETS}
 
 $(BUILDDIR):
 	$(Q)mkdir -p $@
-- 
2.7.4

