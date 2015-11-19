Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45783 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756210AbbKSJpU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Nov 2015 04:45:20 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] DocBook: only copy stuff to media_api if media xml is generated
Date: Thu, 19 Nov 2015 07:45:13 -0200
Message-Id: <e99ac34ef0b822ac3007b00a499a67eb1af36d9a.1447926299.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is possible to use:
	make DOCBOOKS=device-drivers.xml htmldocs

To produce just a few docbooks. In such case, the media docs
won't be built, causing the makefile target to return an error.

While this is ok for human eyes, if the above is used on an script,
it would cause troubles.

Fix it by only creating/filling the media_api directory if the
media_api.xml is found at DOCBOOKS.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 Documentation/DocBook/media/Makefile | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/media/Makefile b/Documentation/DocBook/media/Makefile
index 02848146fc3a..2840ff483d5a 100644
--- a/Documentation/DocBook/media/Makefile
+++ b/Documentation/DocBook/media/Makefile
@@ -199,8 +199,10 @@ DVB_DOCUMENTED = \
 #
 
 install_media_images = \
-	$(Q)-mkdir -p $(MEDIA_OBJ_DIR)/media_api; \
-	cp $(OBJIMGFILES) $(MEDIA_SRC_DIR)/*.svg $(MEDIA_SRC_DIR)/v4l/*.svg $(MEDIA_OBJ_DIR)/media_api
+	$(Q)if [ "x$(findstring media_api.xml,$(DOCBOOKS))" != "x" ]; then \
+		mkdir -p $(MEDIA_OBJ_DIR)/media_api; \
+		cp $(OBJIMGFILES) $(MEDIA_SRC_DIR)/*.svg $(MEDIA_SRC_DIR)/v4l/*.svg $(MEDIA_OBJ_DIR)/media_api; \
+	fi
 
 $(MEDIA_OBJ_DIR)/%: $(MEDIA_SRC_DIR)/%.b64
 	$(Q)base64 -d $< >$@
-- 
2.5.0


