Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43120 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbaKSPa1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Nov 2014 10:30:27 -0500
From: Markus Pargmann <mpa@pengutronix.de>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Jonathan Corbet <corbet@lwn.net>
Cc: linux-media@vger.kernel.org, linux-doc@vger.kernel.org,
	Markus Pargmann <mpa@pengutronix.de>
Subject: [PATCH] DocBook: media: Fix Makefile clean target
Date: Wed, 19 Nov 2014 16:29:52 +0100
Message-Id: <1416410992-24950-1-git-send-email-mpa@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The cleanmediadocs target will fail if the given files do not exist.
This should not happen, instead we want the cleaning to be successful
even if the files do not exist.

Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
---
 Documentation/DocBook/media/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/Makefile b/Documentation/DocBook/media/Makefile
index df2962d9e11e..8bf7c6191296 100644
--- a/Documentation/DocBook/media/Makefile
+++ b/Documentation/DocBook/media/Makefile
@@ -25,7 +25,7 @@ GENFILES := $(addprefix $(MEDIA_OBJ_DIR)/, $(MEDIA_TEMP))
 PHONY += cleanmediadocs
 
 cleanmediadocs:
-	-@rm `find $(MEDIA_OBJ_DIR) -type l` $(GENFILES) $(OBJIMGFILES) 2>/dev/null
+	-@rm -f `find $(MEDIA_OBJ_DIR) -type l` $(GENFILES) $(OBJIMGFILES) 2>/dev/null
 
 $(obj)/media_api.xml: $(GENFILES) FORCE
 
-- 
2.1.1

