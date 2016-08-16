Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49449 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbcHPQZv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Aug 2016 12:25:51 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 5/9] docs-rst: Don't mangle with UTF-8 chars on LaTeX/PDF output
Date: Tue, 16 Aug 2016 13:25:39 -0300
Message-Id: <974887b551803aaaa2fcebe20e050f1455262f9b.1471364025.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471364025.git.mchehab@s-opensource.com>
References: <cover.1471364025.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471364025.git.mchehab@s-opensource.com>
References: <cover.1471364025.git.mchehab@s-opensource.com>
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
index fdef3a4bc8c7..16a3502c9e40 100644
--- a/Documentation/Makefile.sphinx
+++ b/Documentation/Makefile.sphinx
@@ -29,7 +29,7 @@ else ifneq ($(DOCBOOKS),)
 else # HAVE_SPHINX
 
 # User-friendly check for pdflatex
-HAVE_PDFLATEX := $(shell if which pdflatex >/dev/null 2>&1; then echo 1; else echo 0; fi)
+HAVE_PDFLATEX := $(shell if which xelatex >/dev/null 2>&1; then echo 1; else echo 0; fi)
 
 # Internal variables.
 PAPEROPT_a4     = -D latex_paper_size=a4
@@ -68,11 +68,11 @@ htmldocs:
 
 pdfdocs:
 ifeq ($(HAVE_PDFLATEX),0)
-	$(warning The 'pdflatex' command was not found. Make sure you have it installed and in PATH to produce PDF output.)
+	$(warning The 'xelatex' command was not found. Make sure you have it installed and in PATH to produce PDF output.)
 	@echo "  SKIP    Sphinx $@ target."
 else # HAVE_PDFLATEX
 	@$(call loop_cmd,sphinx,latex,.,latex,.)
-	$(Q)$(MAKE) -C $(BUILDDIR)/latex
+	$(Q)$(MAKE) PDFLATEX=xelatex -C $(BUILDDIR)/latex
 endif # HAVE_PDFLATEX
 
 epubdocs:
diff --git a/Documentation/conf.py b/Documentation/conf.py
index f91acc78e20b..e254198b1dbf 100644
--- a/Documentation/conf.py
+++ b/Documentation/conf.py
@@ -254,6 +254,10 @@ latex_elements = {
 # Latex figure (float) alignment
 #'figure_align': 'htbp',
 
+# Don't mangle with UTF-8 chars
+'inputenc': '',
+'utf8extra': '',
+
 # Additional stuff for the LaTeX preamble.
     'preamble': '''
         % Allow generate some pages in landscape
@@ -281,6 +285,13 @@ latex_elements = {
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


