Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49445 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250AbcHPQZv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Aug 2016 12:25:51 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 8/9] docs-rst: Don't go to interactive mode on errors
Date: Tue, 16 Aug 2016 13:25:42 -0300
Message-Id: <bf05471620bd541ae0ed0c995f840cb37d735a2c.1471364025.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471364025.git.mchehab@s-opensource.com>
References: <cover.1471364025.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471364025.git.mchehab@s-opensource.com>
References: <cover.1471364025.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When building for LaTeX, it stops and enters into interactive
mode on errors. Don't do that, as there are some non-fatal errors
on media books when using Sphinx 1.4.x that we don't know how fix
yet.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/Makefile.sphinx | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/Makefile.sphinx b/Documentation/Makefile.sphinx
index 16a3502c9e40..ba4efb1f68f3 100644
--- a/Documentation/Makefile.sphinx
+++ b/Documentation/Makefile.sphinx
@@ -72,7 +72,7 @@ ifeq ($(HAVE_PDFLATEX),0)
 	@echo "  SKIP    Sphinx $@ target."
 else # HAVE_PDFLATEX
 	@$(call loop_cmd,sphinx,latex,.,latex,.)
-	$(Q)$(MAKE) PDFLATEX=xelatex -C $(BUILDDIR)/latex
+	$(Q)$(MAKE) PDFLATEX=xelatex LATEXOPTS="-interaction=nonstopmode" -C $(BUILDDIR)/latex
 endif # HAVE_PDFLATEX
 
 epubdocs:
-- 
2.7.4


