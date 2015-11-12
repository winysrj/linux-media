Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:23755 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752556AbbKLUwV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Nov 2015 15:52:21 -0500
From: Graham Whaley <graham.whaley@linux.intel.com>
To: mchehab@osg.samsung.com, linux-media@vger.kernel.org
Cc: Graham Whaley <graham.whaley@linux.intel.com>
Subject: [PATCH] [media] DocBook/media/Makefile: Do not fail mkdir if dir already exists
Date: Thu, 12 Nov 2015 20:51:51 +0000
Message-Id: <1447361511-7994-1-git-send-email-graham.whaley@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit 5240f4e68d42 ("[media] DocBook/media/Makefile: Avoid make htmldocs
to fail") introduced a mkdir which is always called through
install_media_images from the Documentation/DocBook/Makefile htmldocs rule.
If you run 'make htmldocs' more than once you get:

 mkdir: cannot create directory ‘./Documentation/DocBook//media_api’:
  File exists

Add -p to the mkdir to continue no matter if the dir already exists.

Signed-off-by: Graham Whaley <graham.whaley@linux.intel.com>
---
This error happens for me even on a 'make cleandocs; make htmldocs', so I'm
not sure how it got through - maybe if you only rebuild a single file each
time then it does not show up. Odd, maybe it is a specific thing on my system,
but I can't think of anything that would cause that?

 Documentation/DocBook/media/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/Makefile b/Documentation/DocBook/media/Makefile
index 08527e7ea4d0..02848146fc3a 100644
--- a/Documentation/DocBook/media/Makefile
+++ b/Documentation/DocBook/media/Makefile
@@ -199,7 +199,7 @@ DVB_DOCUMENTED = \
 #
 
 install_media_images = \
-	$(Q)-mkdir $(MEDIA_OBJ_DIR)/media_api; \
+	$(Q)-mkdir -p $(MEDIA_OBJ_DIR)/media_api; \
 	cp $(OBJIMGFILES) $(MEDIA_SRC_DIR)/*.svg $(MEDIA_SRC_DIR)/v4l/*.svg $(MEDIA_OBJ_DIR)/media_api
 
 $(MEDIA_OBJ_DIR)/%: $(MEDIA_SRC_DIR)/%.b64
-- 
2.4.3

