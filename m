Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49443 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbcHPQZv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Aug 2016 12:25:51 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 1/9] docs-rst: fix a breakage when building PDF documents
Date: Tue, 16 Aug 2016 13:25:35 -0300
Message-Id: <b870c8132ac4abc4b6b1062dbc5557564befc205.1471364025.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471364025.git.mchehab@s-opensource.com>
References: <cover.1471364025.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471364025.git.mchehab@s-opensource.com>
References: <cover.1471364025.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

changeset 606b9ac81a63 ("doc-rst: generic way to build only sphinx
sub-folders") accidentally broke PDF generation by adding an extra
")". Remove it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/Makefile.sphinx | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/Makefile.sphinx b/Documentation/Makefile.sphinx
index ea0664cece12..fdef3a4bc8c7 100644
--- a/Documentation/Makefile.sphinx
+++ b/Documentation/Makefile.sphinx
@@ -71,7 +71,7 @@ ifeq ($(HAVE_PDFLATEX),0)
 	$(warning The 'pdflatex' command was not found. Make sure you have it installed and in PATH to produce PDF output.)
 	@echo "  SKIP    Sphinx $@ target."
 else # HAVE_PDFLATEX
-	@$(call loop_cmd,sphinx,latex,.,latex,.))
+	@$(call loop_cmd,sphinx,latex,.,latex,.)
 	$(Q)$(MAKE) -C $(BUILDDIR)/latex
 endif # HAVE_PDFLATEX
 
-- 
2.7.4


