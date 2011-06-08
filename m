Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:50996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753464Ab1FHUZX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Jun 2011 16:25:23 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p58KPNHI012535
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 8 Jun 2011 16:25:23 -0400
Received: from pedra (vpn-10-126.rdu.redhat.com [10.11.10.126])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p58KP4Un024316
	for <linux-media@vger.kernel.org>; Wed, 8 Jun 2011 16:25:22 -0400
Date: Wed, 8 Jun 2011 17:23:08 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 11/13] [media] DocBook/Makefile: Remove osd.h header
Message-ID: <20110608172308.7000fa3c@pedra>
In-Reply-To: <cover.1307563765.git.mchehab@redhat.com>
References: <cover.1307563765.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The av7110 uses an OSD API. Such API is not documented at all. Also,
the osd.h API uses camelCase and some other weird stuff. Also, dvb-core
doesn't recognize it.

I don't see any good reason why we should document it. It seems better
to just let it as-is. If ever needed, it is probably better to write
a different API for dvb-core.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/Documentation/DocBook/media/Makefile b/Documentation/DocBook/media/Makefile
index ab31254..a914eb0 100644
--- a/Documentation/DocBook/media/Makefile
+++ b/Documentation/DocBook/media/Makefile
@@ -16,7 +16,6 @@ MEDIA_TEMP =  media-entities.tmpl \
 	      dmx.h.xml \
 	      frontend.h.xml \
 	      net.h.xml \
-	      osd.h.xml \
 	      video.h.xml \
 
 IMGFILES := $(addprefix $(MEDIA_OBJ_DIR)/media/, $(notdir $(shell ls $(MEDIA_SRC_DIR)/*/*.gif $(MEDIA_SRC_DIR)/*/*.png)))
@@ -62,7 +61,6 @@ IOCTLS = \
 	$(shell perl -ne 'print "$$1 " if /\#define\s+([^\s]+)\s+_IO/' $(srctree)/include/linux/dvb/dmx.h) \
 	$(shell perl -ne 'print "$$1 " if /\#define\s+([^\s]+)\s+_IO/' $(srctree)/include/linux/dvb/frontend.h) \
 	$(shell perl -ne 'print "$$1 " if /\#define\s+([A-Z][^\s]+)\s+_IO/' $(srctree)/include/linux/dvb/net.h) \
-	$(shell perl -ne 'print "$$1 " if /\#define\s+([^\s]+)\s+_IO/' $(srctree)/include/linux/dvb/osd.h) \
 	$(shell perl -ne 'print "$$1 " if /\#define\s+([^\s]+)\s+_IO/' $(srctree)/include/linux/dvb/video.h) \
 	$(shell perl -ne 'print "$$1 " if /\#define\s+([^\s]+)\s+_IO/' $(srctree)/include/linux/media.h) \
 	$(shell perl -ne 'print "$$1 " if /\#define\s+([^\s]+)\s+_IO/' $(srctree)/include/linux/v4l2-subdev.h) \
@@ -83,7 +81,6 @@ ENUMS = \
 	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/linux/dvb/dmx.h) \
 	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/linux/dvb/frontend.h) \
 	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/linux/dvb/net.h) \
-	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/linux/dvb/osd.h) \
 	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/linux/dvb/video.h) \
 	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/linux/media.h) \
 	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/linux/v4l2-mediabus.h) \
@@ -96,7 +93,6 @@ STRUCTS = \
 	$(shell perl -ne 'print "$$1 " if (/^struct\s+([^\s]+)\s+/)' $(srctree)/include/linux/dvb/dmx.h) \
 	$(shell perl -ne 'print "$$1 " if (!/dtv\_cmds\_h/ && /^struct\s+([^\s]+)\s+/)' $(srctree)/include/linux/dvb/frontend.h) \
 	$(shell perl -ne 'print "$$1 " if (/^struct\s+([A-Z][^\s]+)\s+/)' $(srctree)/include/linux/dvb/net.h) \
-	$(shell perl -ne 'print "$$1 " if (/^struct\s+([^\s]+)\s+/)' $(srctree)/include/linux/dvb/osd.h) \
 	$(shell perl -ne 'print "$$1 " if (/^struct\s+([^\s]+)\s+/)' $(srctree)/include/linux/dvb/video.h) \
 	$(shell perl -ne 'print "$$1 " if /^struct\s+([^\s]+)\s+/' $(srctree)/include/linux/media.h) \
 	$(shell perl -ne 'print "$$1 " if /^struct\s+([^\s]+)\s+/' $(srctree)/include/linux/v4l2-subdev.h) \
@@ -232,17 +228,6 @@ $(MEDIA_OBJ_DIR)/net.h.xml: $(srctree)/include/linux/dvb/net.h $(MEDIA_OBJ_DIR)/
 	@(					\
 	echo "</programlisting>") >> $@
 
-$(MEDIA_OBJ_DIR)/osd.h.xml: $(srctree)/include/linux/dvb/osd.h $(MEDIA_OBJ_DIR)/v4l2.xml
-	@$($(quiet)gen_xml)
-	@(					\
-	echo "<programlisting>") > $@
-	@(					\
-	expand --tabs=8 < $< |			\
-	  sed $(ESCAPE) $(DVB_DOCUMENTED) |	\
-	  sed 's/i\.e\./&ie;/') >> $@
-	@(					\
-	echo "</programlisting>") >> $@
-
 $(MEDIA_OBJ_DIR)/video.h.xml: $(srctree)/include/linux/dvb/video.h $(MEDIA_OBJ_DIR)/v4l2.xml
 	@$($(quiet)gen_xml)
 	@(					\
diff --git a/Documentation/DocBook/media/dvb/dvbapi.xml b/Documentation/DocBook/media/dvb/dvbapi.xml
index 5291430..2ab6ddc 100644
--- a/Documentation/DocBook/media/dvb/dvbapi.xml
+++ b/Documentation/DocBook/media/dvb/dvbapi.xml
@@ -134,10 +134,6 @@ Added ISDB-T test originally written by Patrick Boettcher
     <title>DVB Network Header File</title>
     &sub-net-h;
   </appendix>
-  <appendix id="osd_h">
-    <title>DVB OSD Header File</title>
-    &sub-osd-h;
-  </appendix>
   <appendix id="video_h">
     <title>DVB Video Header File</title>
     &sub-video-h;
-- 
1.7.1


