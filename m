Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.goneo.de ([85.220.129.30]:41478 "EHLO smtp1.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754065AbcHXPhL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 Aug 2016 11:37:11 -0400
From: Markus Heiser <markus.heiser@darmarit.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Markus Heiser <markus.heiser@darmarIT.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Jani Nikula <jani.nikula@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/3] doc-rst: generic way to build PDF of sub-folders
Date: Wed, 24 Aug 2016 17:36:14 +0200
Message-Id: <1472052976-22541-2-git-send-email-markus.heiser@darmarit.de>
In-Reply-To: <1472052976-22541-1-git-send-email-markus.heiser@darmarit.de>
References: <1472052976-22541-1-git-send-email-markus.heiser@darmarit.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Heiser <markus.heiser@darmarIT.de>

This extends the method to build only sub-folders to the targets
"latexdocs" and "pdfdocs". To do so, a conf.py in the sub-folder is
required, where the latex_documents of the sub-folder are
defined. E.g. to build only gpu's PDF add the following to the
Documentation/gpu/conf.py::

  +latex_documents = [
  +    ("index", "gpu.tex", "Linux GPU Driver Developer's Guide",
  +     "The kernel development community", "manual"),
  +]

and run:

  make SPHINXDIRS=gpu pdfdocs

Signed-off-by: Markus Heiser <markus.heiser@darmarIT.de>
---
 Documentation/Makefile.sphinx | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/Makefile.sphinx b/Documentation/Makefile.sphinx
index 894cfaa..92deea3 100644
--- a/Documentation/Makefile.sphinx
+++ b/Documentation/Makefile.sphinx
@@ -71,12 +71,12 @@ ifeq ($(HAVE_PDFLATEX),0)
 	$(warning The 'xelatex' command was not found. Make sure you have it installed and in PATH to produce PDF output.)
 	@echo "  SKIP    Sphinx $@ target."
 else # HAVE_PDFLATEX
-	@$(call loop_cmd,sphinx,latex,.,latex,.)
+	@$(foreach var,$(SPHINXDIRS),$(call loop_cmd,sphinx,latex,$(var),latex,$(var)))
 endif # HAVE_PDFLATEX
 
 pdfdocs: latexdocs
 ifneq ($(HAVE_PDFLATEX),0)
-	$(Q)$(MAKE) PDFLATEX=xelatex LATEXOPTS="-interaction=nonstopmode" -C $(BUILDDIR)/latex
+	$(foreach var,$(SPHINXDIRS), $(MAKE) PDFLATEX=xelatex LATEXOPTS="-interaction=nonstopmode" -C $(BUILDDIR)/$(var)/latex)
 endif # HAVE_PDFLATEX
 
 epubdocs:
-- 
2.7.4

