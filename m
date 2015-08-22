Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40384 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092AbbHVR2f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Aug 2015 13:28:35 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 04/39] [media] DocBook/media/Makefile: Avoid make htmldocs to fail
Date: Sat, 22 Aug 2015 14:27:49 -0300
Message-Id: <33d74f5884897ce5a664cddf1f03c6d6851104d4.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If make is called twice like that:
	make V=1 DOCBOOKS=device-drivers.xml htmldocs

Make will fail with:

	make -f ./scripts/Makefile.build obj=scripts/basic
	rm -f .tmp_quiet_recordmcount
	make -f ./scripts/Makefile.build obj=scripts build_docproc
	make -f ./scripts/Makefile.build obj=Documentation/DocBook htmldocs
	rm -rf Documentation/DocBook/index.html; echo '<h1>Linux Kernel HTML Documentation</h1>' >> Documentation/DocBook/index.html && echo '<h2>Kernel Version: 4.2.0-rc2</h2>' >> Documentation/DocBook/index.html && cat Documentation/DocBook/device-drivers.html >> Documentation/DocBook/index.html
	cp ./Documentation/DocBook//bayer.png ./Documentation/DocBook//constraints.png ./Documentation/DocBook//crop.gif ./Documentation/DocBook//dvbstb.png ./Documentation/DocBook//fieldseq_bt.gif ./Documentation/DocBook//fieldseq_tb.gif ./Documentation/DocBook//nv12mt.gif ./Documentation/DocBook//nv12mt_example.gif ./Documentation/DocBook//pipeline.png ./Documentation/DocBook//selection.png ./Documentation/DocBook//vbi_525.gif ./Documentation/DocBook//vbi_625.gif ./Documentation/DocBook//vbi_hsync.gif ./Documentation/DocBook/media/*.svg ./Documentation/DocBook/media/v4l/*.svg ./Documentation/DocBook//media_api
	cp: target './Documentation/DocBook//media_api' is not a directory
	Documentation/DocBook/Makefile:53: recipe for target 'htmldocs' failed

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/Makefile b/Documentation/DocBook/media/Makefile
index 23996f88cd58..08527e7ea4d0 100644
--- a/Documentation/DocBook/media/Makefile
+++ b/Documentation/DocBook/media/Makefile
@@ -199,7 +199,8 @@ DVB_DOCUMENTED = \
 #
 
 install_media_images = \
-	$(Q)-cp $(OBJIMGFILES) $(MEDIA_SRC_DIR)/*.svg $(MEDIA_SRC_DIR)/v4l/*.svg $(MEDIA_OBJ_DIR)/media_api
+	$(Q)-mkdir $(MEDIA_OBJ_DIR)/media_api; \
+	cp $(OBJIMGFILES) $(MEDIA_SRC_DIR)/*.svg $(MEDIA_SRC_DIR)/v4l/*.svg $(MEDIA_OBJ_DIR)/media_api
 
 $(MEDIA_OBJ_DIR)/%: $(MEDIA_SRC_DIR)/%.b64
 	$(Q)base64 -d $< >$@
-- 
2.4.3

