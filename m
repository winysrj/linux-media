Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55805 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754343AbcHSDRi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Aug 2016 23:17:38 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Michal Marek <mmarek@suse.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Markus Heiser <markus.heiser@darmarIT.de>,
        Ben Hutchings <ben@decadent.org.uk>, linux-doc@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: [PATCH] docs-rst: add support for LaTeX output
Date: Thu, 18 Aug 2016 11:53:39 -0300
Message-Id: <f3deb42c0019bde27f0f92fb885a76aa1a0a561c.1471532014.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sphinx supports LaTeX output. Sometimes, it is interesting to
call it directly, instead of also generating a PDF. As it comes
for free, add a target for it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/DocBook/Makefile | 1 +
 Documentation/Makefile.sphinx  | 7 ++++++-
 Makefile                       | 2 +-
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/Makefile b/Documentation/DocBook/Makefile
index a91c96522379..a558dfcc9e2d 100644
--- a/Documentation/DocBook/Makefile
+++ b/Documentation/DocBook/Makefile
@@ -72,6 +72,7 @@ installmandocs: mandocs
 
 # no-op for the DocBook toolchain
 epubdocs:
+latexdocs:
 
 ###
 #External programs used
diff --git a/Documentation/Makefile.sphinx b/Documentation/Makefile.sphinx
index ba4efb1f68f3..894cfaa41f55 100644
--- a/Documentation/Makefile.sphinx
+++ b/Documentation/Makefile.sphinx
@@ -66,12 +66,16 @@ quiet_cmd_sphinx = SPHINX  $@ --> file://$(abspath $(BUILDDIR)/$3/$4);
 htmldocs:
 	@$(foreach var,$(SPHINXDIRS),$(call loop_cmd,sphinx,html,$(var),,$(var)))
 
-pdfdocs:
+latexdocs:
 ifeq ($(HAVE_PDFLATEX),0)
 	$(warning The 'xelatex' command was not found. Make sure you have it installed and in PATH to produce PDF output.)
 	@echo "  SKIP    Sphinx $@ target."
 else # HAVE_PDFLATEX
 	@$(call loop_cmd,sphinx,latex,.,latex,.)
+endif # HAVE_PDFLATEX
+
+pdfdocs: latexdocs
+ifneq ($(HAVE_PDFLATEX),0)
 	$(Q)$(MAKE) PDFLATEX=xelatex LATEXOPTS="-interaction=nonstopmode" -C $(BUILDDIR)/latex
 endif # HAVE_PDFLATEX
 
@@ -95,6 +99,7 @@ endif # HAVE_SPHINX
 dochelp:
 	@echo  ' Linux kernel internal documentation in different formats (Sphinx):'
 	@echo  '  htmldocs        - HTML'
+	@echo  '  latexdocs       - LaTeX'
 	@echo  '  pdfdocs         - PDF'
 	@echo  '  epubdocs        - EPUB'
 	@echo  '  xmldocs         - XML'
diff --git a/Makefile b/Makefile
index 70de1448c571..0fa3feb6f74e 100644
--- a/Makefile
+++ b/Makefile
@@ -1432,7 +1432,7 @@ $(help-board-dirs): help-%:
 
 # Documentation targets
 # ---------------------------------------------------------------------------
-DOC_TARGETS := xmldocs sgmldocs psdocs pdfdocs htmldocs mandocs installmandocs epubdocs cleandocs
+DOC_TARGETS := xmldocs sgmldocs psdocs latexdocs pdfdocs htmldocs mandocs installmandocs epubdocs cleandocs
 PHONY += $(DOC_TARGETS)
 $(DOC_TARGETS): scripts_basic FORCE
 	$(Q)$(MAKE) $(build)=scripts build_docproc build_check-lc_ctype
-- 
2.7.4

