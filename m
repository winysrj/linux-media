Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52607 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755963Ab2JQNHU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Oct 2012 09:07:20 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9HD7K8K027971
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 17 Oct 2012 09:07:20 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	David Howells <dhowells@redhat.com>
Subject: [PATCH] DocBook/media/Makefile: Fix build due to uapi breakage
Date: Wed, 17 Oct 2012 10:07:17 -0300
Message-Id: <1350479237-30430-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The uapi changeset forgot to fix the header locations, needed
for the DocBook specs. Fix it.

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 Documentation/DocBook/media/Makefile | 76 ++++++++++++++++++------------------
 1 file changed, 38 insertions(+), 38 deletions(-)

diff --git a/Documentation/DocBook/media/Makefile b/Documentation/DocBook/media/Makefile
index 9b7e4c5..f9fd615 100644
--- a/Documentation/DocBook/media/Makefile
+++ b/Documentation/DocBook/media/Makefile
@@ -56,15 +56,15 @@ FUNCS = \
 	write \
 
 IOCTLS = \
-	$(shell perl -ne 'print "$$1 " if /\#define\s+([^\s]+)\s+_IO/' $(srctree)/include/linux/videodev2.h) \
-	$(shell perl -ne 'print "$$1 " if /\#define\s+([^\s]+)\s+_IO/' $(srctree)/include/linux/dvb/audio.h) \
-	$(shell perl -ne 'print "$$1 " if /\#define\s+([^\s]+)\s+_IO/' $(srctree)/include/linux/dvb/ca.h) \
-	$(shell perl -ne 'print "$$1 " if /\#define\s+([^\s]+)\s+_IO/' $(srctree)/include/linux/dvb/dmx.h) \
-	$(shell perl -ne 'print "$$1 " if /\#define\s+([^\s]+)\s+_IO/' $(srctree)/include/linux/dvb/frontend.h) \
-	$(shell perl -ne 'print "$$1 " if /\#define\s+([A-Z][^\s]+)\s+_IO/' $(srctree)/include/linux/dvb/net.h) \
-	$(shell perl -ne 'print "$$1 " if /\#define\s+([^\s]+)\s+_IO/' $(srctree)/include/linux/dvb/video.h) \
-	$(shell perl -ne 'print "$$1 " if /\#define\s+([^\s]+)\s+_IO/' $(srctree)/include/linux/media.h) \
-	$(shell perl -ne 'print "$$1 " if /\#define\s+([^\s]+)\s+_IO/' $(srctree)/include/linux/v4l2-subdev.h) \
+	$(shell perl -ne 'print "$$1 " if /\#define\s+([^\s]+)\s+_IO/' $(srctree)/include/uapi/linux/videodev2.h) \
+	$(shell perl -ne 'print "$$1 " if /\#define\s+([^\s]+)\s+_IO/' $(srctree)/include/uapi/linux/dvb/audio.h) \
+	$(shell perl -ne 'print "$$1 " if /\#define\s+([^\s]+)\s+_IO/' $(srctree)/include/uapi/linux/dvb/ca.h) \
+	$(shell perl -ne 'print "$$1 " if /\#define\s+([^\s]+)\s+_IO/' $(srctree)/include/uapi/linux/dvb/dmx.h) \
+	$(shell perl -ne 'print "$$1 " if /\#define\s+([^\s]+)\s+_IO/' $(srctree)/include/uapi/linux/dvb/frontend.h) \
+	$(shell perl -ne 'print "$$1 " if /\#define\s+([A-Z][^\s]+)\s+_IO/' $(srctree)/include/uapi/linux/dvb/net.h) \
+	$(shell perl -ne 'print "$$1 " if /\#define\s+([^\s]+)\s+_IO/' $(srctree)/include/uapi/linux/dvb/video.h) \
+	$(shell perl -ne 'print "$$1 " if /\#define\s+([^\s]+)\s+_IO/' $(srctree)/include/uapi/linux/media.h) \
+	$(shell perl -ne 'print "$$1 " if /\#define\s+([^\s]+)\s+_IO/' $(srctree)/include/uapi/linux/v4l2-subdev.h) \
 	VIDIOC_SUBDEV_G_FRAME_INTERVAL \
 	VIDIOC_SUBDEV_S_FRAME_INTERVAL \
 	VIDIOC_SUBDEV_ENUM_MBUS_CODE \
@@ -74,32 +74,32 @@ IOCTLS = \
 	VIDIOC_SUBDEV_S_SELECTION \
 
 TYPES = \
-	$(shell perl -ne 'print "$$1 " if /^typedef\s+[^\s]+\s+([^\s]+)\;/' $(srctree)/include/linux/videodev2.h) \
-	$(shell perl -ne 'print "$$1 " if /^}\s+([a-z0-9_]+_t)/' $(srctree)/include/linux/dvb/frontend.h)
+	$(shell perl -ne 'print "$$1 " if /^typedef\s+[^\s]+\s+([^\s]+)\;/' $(srctree)/include/uapi/linux/videodev2.h) \
+	$(shell perl -ne 'print "$$1 " if /^}\s+([a-z0-9_]+_t)/' $(srctree)/include/uapi/linux/dvb/frontend.h)
 
 ENUMS = \
-	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/linux/videodev2.h) \
-	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/linux/dvb/audio.h) \
-	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/linux/dvb/ca.h) \
-	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/linux/dvb/dmx.h) \
-	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/linux/dvb/frontend.h) \
-	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/linux/dvb/net.h) \
-	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/linux/dvb/video.h) \
-	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/linux/media.h) \
-	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/linux/v4l2-mediabus.h) \
-	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/linux/v4l2-subdev.h)
+	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/uapi/linux/videodev2.h) \
+	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/uapi/linux/dvb/audio.h) \
+	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/uapi/linux/dvb/ca.h) \
+	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/uapi/linux/dvb/dmx.h) \
+	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/uapi/linux/dvb/frontend.h) \
+	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/uapi/linux/dvb/net.h) \
+	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/uapi/linux/dvb/video.h) \
+	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/uapi/linux/media.h) \
+	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/uapi/linux/v4l2-mediabus.h) \
+	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/uapi/linux/v4l2-subdev.h)
 
 STRUCTS = \
-	$(shell perl -ne 'print "$$1 " if /^struct\s+([^\s]+)\s+/' $(srctree)/include/linux/videodev2.h) \
-	$(shell perl -ne 'print "$$1 " if (/^struct\s+([^\s\{]+)\s*/)' $(srctree)/include/linux/dvb/audio.h) \
-	$(shell perl -ne 'print "$$1 " if (/^struct\s+([^\s]+)\s+/)' $(srctree)/include/linux/dvb/ca.h) \
-	$(shell perl -ne 'print "$$1 " if (/^struct\s+([^\s]+)\s+/)' $(srctree)/include/linux/dvb/dmx.h) \
-	$(shell perl -ne 'print "$$1 " if (!/dtv\_cmds\_h/ && /^struct\s+([^\s]+)\s+/)' $(srctree)/include/linux/dvb/frontend.h) \
-	$(shell perl -ne 'print "$$1 " if (/^struct\s+([A-Z][^\s]+)\s+/)' $(srctree)/include/linux/dvb/net.h) \
-	$(shell perl -ne 'print "$$1 " if (/^struct\s+([^\s]+)\s+/)' $(srctree)/include/linux/dvb/video.h) \
-	$(shell perl -ne 'print "$$1 " if /^struct\s+([^\s]+)\s+/' $(srctree)/include/linux/media.h) \
-	$(shell perl -ne 'print "$$1 " if /^struct\s+([^\s]+)\s+/' $(srctree)/include/linux/v4l2-subdev.h) \
-	$(shell perl -ne 'print "$$1 " if /^struct\s+([^\s]+)\s+/' $(srctree)/include/linux/v4l2-mediabus.h)
+	$(shell perl -ne 'print "$$1 " if /^struct\s+([^\s]+)\s+/' $(srctree)/include/uapi/linux/videodev2.h) \
+	$(shell perl -ne 'print "$$1 " if (/^struct\s+([^\s\{]+)\s*/)' $(srctree)/include/uapi/linux/dvb/audio.h) \
+	$(shell perl -ne 'print "$$1 " if (/^struct\s+([^\s]+)\s+/)' $(srctree)/include/uapi/linux/dvb/ca.h) \
+	$(shell perl -ne 'print "$$1 " if (/^struct\s+([^\s]+)\s+/)' $(srctree)/include/uapi/linux/dvb/dmx.h) \
+	$(shell perl -ne 'print "$$1 " if (!/dtv\_cmds\_h/ && /^struct\s+([^\s]+)\s+/)' $(srctree)/include/uapi/linux/dvb/frontend.h) \
+	$(shell perl -ne 'print "$$1 " if (/^struct\s+([A-Z][^\s]+)\s+/)' $(srctree)/include/uapi/linux/dvb/net.h) \
+	$(shell perl -ne 'print "$$1 " if (/^struct\s+([^\s]+)\s+/)' $(srctree)/include/uapi/linux/dvb/video.h) \
+	$(shell perl -ne 'print "$$1 " if /^struct\s+([^\s]+)\s+/' $(srctree)/include/uapi/linux/media.h) \
+	$(shell perl -ne 'print "$$1 " if /^struct\s+([^\s]+)\s+/' $(srctree)/include/uapi/linux/v4l2-subdev.h) \
+	$(shell perl -ne 'print "$$1 " if /^struct\s+([^\s]+)\s+/' $(srctree)/include/uapi/linux/v4l2-mediabus.h)
 
 ERRORS = \
 	E2BIG \
@@ -205,7 +205,7 @@ $(MEDIA_OBJ_DIR)/v4l2.xml: $(OBJIMGFILES)
 	@(ln -sf $(MEDIA_SRC_DIR)/v4l/*xml $(MEDIA_OBJ_DIR)/)
 	@(ln -sf $(MEDIA_SRC_DIR)/dvb/*xml $(MEDIA_OBJ_DIR)/)
 
-$(MEDIA_OBJ_DIR)/videodev2.h.xml: $(srctree)/include/linux/videodev2.h $(MEDIA_OBJ_DIR)/v4l2.xml
+$(MEDIA_OBJ_DIR)/videodev2.h.xml: $(srctree)/include/uapi/linux/videodev2.h $(MEDIA_OBJ_DIR)/v4l2.xml
 	@$($(quiet)gen_xml)
 	@(					\
 	echo "<programlisting>") > $@
@@ -216,7 +216,7 @@ $(MEDIA_OBJ_DIR)/videodev2.h.xml: $(srctree)/include/linux/videodev2.h $(MEDIA_O
 	@(					\
 	echo "</programlisting>") >> $@
 
-$(MEDIA_OBJ_DIR)/audio.h.xml: $(srctree)/include/linux/dvb/audio.h $(MEDIA_OBJ_DIR)/v4l2.xml
+$(MEDIA_OBJ_DIR)/audio.h.xml: $(srctree)/include/uapi/linux/dvb/audio.h $(MEDIA_OBJ_DIR)/v4l2.xml
 	@$($(quiet)gen_xml)
 	@(					\
 	echo "<programlisting>") > $@
@@ -227,7 +227,7 @@ $(MEDIA_OBJ_DIR)/audio.h.xml: $(srctree)/include/linux/dvb/audio.h $(MEDIA_OBJ_D
 	@(					\
 	echo "</programlisting>") >> $@
 
-$(MEDIA_OBJ_DIR)/ca.h.xml: $(srctree)/include/linux/dvb/ca.h $(MEDIA_OBJ_DIR)/v4l2.xml
+$(MEDIA_OBJ_DIR)/ca.h.xml: $(srctree)/include/uapi/linux/dvb/ca.h $(MEDIA_OBJ_DIR)/v4l2.xml
 	@$($(quiet)gen_xml)
 	@(					\
 	echo "<programlisting>") > $@
@@ -238,7 +238,7 @@ $(MEDIA_OBJ_DIR)/ca.h.xml: $(srctree)/include/linux/dvb/ca.h $(MEDIA_OBJ_DIR)/v4
 	@(					\
 	echo "</programlisting>") >> $@
 
-$(MEDIA_OBJ_DIR)/dmx.h.xml: $(srctree)/include/linux/dvb/dmx.h $(MEDIA_OBJ_DIR)/v4l2.xml
+$(MEDIA_OBJ_DIR)/dmx.h.xml: $(srctree)/include/uapi/linux/dvb/dmx.h $(MEDIA_OBJ_DIR)/v4l2.xml
 	@$($(quiet)gen_xml)
 	@(					\
 	echo "<programlisting>") > $@
@@ -249,7 +249,7 @@ $(MEDIA_OBJ_DIR)/dmx.h.xml: $(srctree)/include/linux/dvb/dmx.h $(MEDIA_OBJ_DIR)/
 	@(					\
 	echo "</programlisting>") >> $@
 
-$(MEDIA_OBJ_DIR)/frontend.h.xml: $(srctree)/include/linux/dvb/frontend.h $(MEDIA_OBJ_DIR)/v4l2.xml
+$(MEDIA_OBJ_DIR)/frontend.h.xml: $(srctree)/include/uapi/linux/dvb/frontend.h $(MEDIA_OBJ_DIR)/v4l2.xml
 	@$($(quiet)gen_xml)
 	@(					\
 	echo "<programlisting>") > $@
@@ -260,7 +260,7 @@ $(MEDIA_OBJ_DIR)/frontend.h.xml: $(srctree)/include/linux/dvb/frontend.h $(MEDIA
 	@(					\
 	echo "</programlisting>") >> $@
 
-$(MEDIA_OBJ_DIR)/net.h.xml: $(srctree)/include/linux/dvb/net.h $(MEDIA_OBJ_DIR)/v4l2.xml
+$(MEDIA_OBJ_DIR)/net.h.xml: $(srctree)/include/uapi/linux/dvb/net.h $(MEDIA_OBJ_DIR)/v4l2.xml
 	@$($(quiet)gen_xml)
 	@(					\
 	echo "<programlisting>") > $@
@@ -271,7 +271,7 @@ $(MEDIA_OBJ_DIR)/net.h.xml: $(srctree)/include/linux/dvb/net.h $(MEDIA_OBJ_DIR)/
 	@(					\
 	echo "</programlisting>") >> $@
 
-$(MEDIA_OBJ_DIR)/video.h.xml: $(srctree)/include/linux/dvb/video.h $(MEDIA_OBJ_DIR)/v4l2.xml
+$(MEDIA_OBJ_DIR)/video.h.xml: $(srctree)/include/uapi/linux/dvb/video.h $(MEDIA_OBJ_DIR)/v4l2.xml
 	@$($(quiet)gen_xml)
 	@(					\
 	echo "<programlisting>") > $@
-- 
1.7.11.7

