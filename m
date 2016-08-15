Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51011 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902AbcHOVXR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2016 17:23:17 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH RFC v2 3/9] docs-rst: Don't mangle with UTF-8 chars on LaTeX/PDF output
Date: Mon, 15 Aug 2016 18:21:54 -0300
Message-Id: <5ceebc273ff089c275c753c78f6e6c6e732b4077.1471294965.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471294965.git.mchehab@s-opensource.com>
References: <cover.1471294965.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471294965.git.mchehab@s-opensource.com>
References: <cover.1471294965.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

pdflatex doesn't accept using some UTF-8 chars, like
"equal or less than" or "equal or greater than" chars. However,
the media documents use them. So, we need to use XeLaTeX for
conversion, and a font that accepts such characters.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/Makefile.sphinx |  6 +++---
 Documentation/conf.py         | 11 +++++++++++
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/Documentation/Makefile.sphinx b/Documentation/Makefile.sphinx
index fc29e08085aa..aa7ff32be589 100644
--- a/Documentation/Makefile.sphinx
+++ b/Documentation/Makefile.sphinx
@@ -26,7 +26,7 @@ else ifneq ($(DOCBOOKS),)
 else # HAVE_SPHINX
 
 # User-friendly check for pdflatex
-HAVE_PDFLATEX := $(shell if which pdflatex >/dev/null 2>&1; then echo 1; else echo 0; fi)
+HAVE_PDFLATEX := $(shell if which xelatex >/dev/null 2>&1; then echo 1; else echo 0; fi)
 
 # Internal variables.
 PAPEROPT_a4     = -D latex_paper_size=a4
@@ -45,11 +45,11 @@ htmldocs:
 
 pdfdocs:
 ifeq ($(HAVE_PDFLATEX),0)
-	$(warning The 'pdflatex' command was not found. Make sure you have it installed and in PATH to produce PDF output.)
+	$(warning The 'xelatex' command was not found. Make sure you have it installed and in PATH to produce PDF output.)
 	@echo "  SKIP    Sphinx $@ target."
 else # HAVE_PDFLATEX
 	$(call cmd,sphinx,latex)
-	$(Q)$(MAKE) -C $(BUILDDIR)/latex
+	$(Q)$(MAKE) PDFLATEX=xelatex -C $(BUILDDIR)/latex
 endif # HAVE_PDFLATEX
 
 epubdocs:
diff --git a/Documentation/conf.py b/Documentation/conf.py
index bbf2878d9945..f4469cd0340d 100644
--- a/Documentation/conf.py
+++ b/Documentation/conf.py
@@ -260,6 +260,10 @@ latex_elements = {
 # Latex figure (float) alignment
 #'figure_align': 'htbp',
 
+# Don't mangle with UTF-8 chars
+'inputenc': '',
+'utf8extra': '',
+
 # Additional stuff for the LaTeX preamble.
     'preamble': '''
         % Allow generate some pages in landscape
@@ -287,6 +291,13 @@ latex_elements = {
           \\end{graybox}
         }
 	\\makeatother
+
+	% Use some font with UTF-8 support with XeLaTeX
+        \\usepackage{fontspec}
+        \\setsansfont{DejaVu Serif}
+        \\setromanfont{DejaVu Sans}
+        \\setmonofont{DejaVu Sans Mono}
+
      '''
 }
 
-- 
2.7.4


