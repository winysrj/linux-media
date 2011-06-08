Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:53672 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500Ab1FHUZH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Jun 2011 16:25:07 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p58KP519015539
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 8 Jun 2011 16:25:06 -0400
Received: from pedra (vpn-10-126.rdu.redhat.com [10.11.10.126])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p58KP4Ud024316
	for <linux-media@vger.kernel.org>; Wed, 8 Jun 2011 16:25:05 -0400
Date: Wed, 8 Jun 2011 17:22:57 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 01/13] [media] DocBook: Add the other DVB API header files
Message-ID: <20110608172257.054a26b6@pedra>
In-Reply-To: <cover.1307563765.git.mchehab@redhat.com>
References: <cover.1307563765.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/Documentation/DocBook/media/Makefile b/Documentation/DocBook/media/Makefile
index eb64087..a747f2a 100644
--- a/Documentation/DocBook/media/Makefile
+++ b/Documentation/DocBook/media/Makefile
@@ -11,7 +11,13 @@ MEDIA_TEMP =  media-entities.tmpl \
 	      media-indices.tmpl \
 	      videodev2.h.xml \
 	      v4l2.xml \
-	      frontend.h.xml
+	      audio.h.xml \
+	      ca.h.xml \
+	      dmx.h.xml \
+	      frontend.h.xml \
+	      net.h.xml \
+	      osd.h.xml \
+	      video.h.xml \
 
 IMGFILES := $(addprefix $(MEDIA_OBJ_DIR)/media/, $(notdir $(shell ls $(MEDIA_SRC_DIR)/*/*.gif $(MEDIA_SRC_DIR)/*/*.png)))
 GENFILES := $(addprefix $(MEDIA_OBJ_DIR)/, $(MEDIA_TEMP))
@@ -51,7 +57,13 @@ FUNCS = \
 
 IOCTLS = \
 	$(shell perl -ne 'print "$$1 " if /\#define\s+([^\s]+)\s+_IO/' $(srctree)/include/linux/videodev2.h) \
+	$(shell perl -ne 'print "$$1 " if /\#define\s+([^\s]+)\s+_IO/' $(srctree)/include/linux/dvb/audio.h) \
+	$(shell perl -ne 'print "$$1 " if /\#define\s+([^\s]+)\s+_IO/' $(srctree)/include/linux/dvb/ca.h) \
+	$(shell perl -ne 'print "$$1 " if /\#define\s+([^\s]+)\s+_IO/' $(srctree)/include/linux/dvb/dmx.h) \
 	$(shell perl -ne 'print "$$1 " if /\#define\s+([^\s]+)\s+_IO/' $(srctree)/include/linux/dvb/frontend.h) \
+	$(shell perl -ne 'print "$$1 " if /\#define\s+([A-Z][^\s]+)\s+_IO/' $(srctree)/include/linux/dvb/net.h) \
+	$(shell perl -ne 'print "$$1 " if /\#define\s+([^\s]+)\s+_IO/' $(srctree)/include/linux/dvb/osd.h) \
+	$(shell perl -ne 'print "$$1 " if /\#define\s+([^\s]+)\s+_IO/' $(srctree)/include/linux/dvb/video.h) \
 	$(shell perl -ne 'print "$$1 " if /\#define\s+([^\s]+)\s+_IO/' $(srctree)/include/linux/media.h) \
 	$(shell perl -ne 'print "$$1 " if /\#define\s+([^\s]+)\s+_IO/' $(srctree)/include/linux/v4l2-subdev.h) \
 	VIDIOC_SUBDEV_G_FRAME_INTERVAL \
@@ -66,14 +78,26 @@ TYPES = \
 
 ENUMS = \
 	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/linux/videodev2.h) \
+	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/linux/dvb/audio.h) \
+	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/linux/dvb/ca.h) \
+	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/linux/dvb/dmx.h) \
 	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/linux/dvb/frontend.h) \
+	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/linux/dvb/net.h) \
+	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/linux/dvb/osd.h) \
+	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/linux/dvb/video.h) \
 	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/linux/media.h) \
 	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/linux/v4l2-mediabus.h) \
 	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/linux/v4l2-subdev.h)
 
 STRUCTS = \
 	$(shell perl -ne 'print "$$1 " if /^struct\s+([^\s]+)\s+/' $(srctree)/include/linux/videodev2.h) \
+	$(shell perl -ne 'print "$$1 " if (/^struct\s+([^\s\{]+)\s*/)' $(srctree)/include/linux/dvb/audio.h) \
+	$(shell perl -ne 'print "$$1 " if (/^struct\s+([^\s]+)\s+/)' $(srctree)/include/linux/dvb/ca.h) \
+	$(shell perl -ne 'print "$$1 " if (/^struct\s+([^\s]+)\s+/)' $(srctree)/include/linux/dvb/dmx.h) \
 	$(shell perl -ne 'print "$$1 " if (!/dtv\_cmds\_h/ && /^struct\s+([^\s]+)\s+/)' $(srctree)/include/linux/dvb/frontend.h) \
+	$(shell perl -ne 'print "$$1 " if (/^struct\s+([A-Z][^\s]+)\s+/)' $(srctree)/include/linux/dvb/net.h) \
+	$(shell perl -ne 'print "$$1 " if (/^struct\s+([^\s]+)\s+/)' $(srctree)/include/linux/dvb/osd.h) \
+	$(shell perl -ne 'print "$$1 " if (/^struct\s+([^\s]+)\s+/)' $(srctree)/include/linux/dvb/video.h) \
 	$(shell perl -ne 'print "$$1 " if /^struct\s+([^\s]+)\s+/' $(srctree)/include/linux/media.h) \
 	$(shell perl -ne 'print "$$1 " if /^struct\s+([^\s]+)\s+/' $(srctree)/include/linux/v4l2-subdev.h) \
 	$(shell perl -ne 'print "$$1 " if /^struct\s+([^\s]+)\s+/' $(srctree)/include/linux/v4l2-mediabus.h)
@@ -151,6 +175,39 @@ $(MEDIA_OBJ_DIR)/videodev2.h.xml: $(srctree)/include/linux/videodev2.h $(MEDIA_O
 	@(					\
 	echo "</programlisting>") >> $@
 
+$(MEDIA_OBJ_DIR)/audio.h.xml: $(srctree)/include/linux/dvb/audio.h $(MEDIA_OBJ_DIR)/v4l2.xml
+	@$($(quiet)gen_xml)
+	@(					\
+	echo "<programlisting>") > $@
+	@(					\
+	expand --tabs=8 < $< |			\
+	  sed $(ESCAPE) $(DVB_DOCUMENTED) |	\
+	  sed 's/i\.e\./&ie;/') >> $@
+	@(					\
+	echo "</programlisting>") >> $@
+
+$(MEDIA_OBJ_DIR)/ca.h.xml: $(srctree)/include/linux/dvb/ca.h $(MEDIA_OBJ_DIR)/v4l2.xml
+	@$($(quiet)gen_xml)
+	@(					\
+	echo "<programlisting>") > $@
+	@(					\
+	expand --tabs=8 < $< |			\
+	  sed $(ESCAPE) $(DVB_DOCUMENTED) |	\
+	  sed 's/i\.e\./&ie;/') >> $@
+	@(					\
+	echo "</programlisting>") >> $@
+
+$(MEDIA_OBJ_DIR)/dmx.h.xml: $(srctree)/include/linux/dvb/dmx.h $(MEDIA_OBJ_DIR)/v4l2.xml
+	@$($(quiet)gen_xml)
+	@(					\
+	echo "<programlisting>") > $@
+	@(					\
+	expand --tabs=8 < $< |			\
+	  sed $(ESCAPE) $(DVB_DOCUMENTED) |	\
+	  sed 's/i\.e\./&ie;/') >> $@
+	@(					\
+	echo "</programlisting>") >> $@
+
 $(MEDIA_OBJ_DIR)/frontend.h.xml: $(srctree)/include/linux/dvb/frontend.h $(MEDIA_OBJ_DIR)/v4l2.xml
 	@$($(quiet)gen_xml)
 	@(					\
@@ -162,6 +219,39 @@ $(MEDIA_OBJ_DIR)/frontend.h.xml: $(srctree)/include/linux/dvb/frontend.h $(MEDIA
 	@(					\
 	echo "</programlisting>") >> $@
 
+$(MEDIA_OBJ_DIR)/net.h.xml: $(srctree)/include/linux/dvb/net.h $(MEDIA_OBJ_DIR)/v4l2.xml
+	@$($(quiet)gen_xml)
+	@(					\
+	echo "<programlisting>") > $@
+	@(					\
+	expand --tabs=8 < $< |			\
+	  sed $(ESCAPE) $(DVB_DOCUMENTED) |	\
+	  sed 's/i\.e\./&ie;/') >> $@
+	@(					\
+	echo "</programlisting>") >> $@
+
+$(MEDIA_OBJ_DIR)/osd.h.xml: $(srctree)/include/linux/dvb/osd.h $(MEDIA_OBJ_DIR)/v4l2.xml
+	@$($(quiet)gen_xml)
+	@(					\
+	echo "<programlisting>") > $@
+	@(					\
+	expand --tabs=8 < $< |			\
+	  sed $(ESCAPE) $(DVB_DOCUMENTED) |	\
+	  sed 's/i\.e\./&ie;/') >> $@
+	@(					\
+	echo "</programlisting>") >> $@
+
+$(MEDIA_OBJ_DIR)/video.h.xml: $(srctree)/include/linux/dvb/video.h $(MEDIA_OBJ_DIR)/v4l2.xml
+	@$($(quiet)gen_xml)
+	@(					\
+	echo "<programlisting>") > $@
+	@(					\
+	expand --tabs=8 < $< |			\
+	  sed $(ESCAPE) $(DVB_DOCUMENTED) |	\
+	  sed 's/i\.e\./&ie;/') >> $@
+	@(					\
+	echo "</programlisting>") >> $@
+
 $(MEDIA_OBJ_DIR)/media-entities.tmpl: $(MEDIA_OBJ_DIR)/v4l2.xml
 	@$($(quiet)gen_xml)
 	@(								\
diff --git a/Documentation/DocBook/media/dvb/dvbapi.xml b/Documentation/DocBook/media/dvb/dvbapi.xml
index 9fad86c..5291430 100644
--- a/Documentation/DocBook/media/dvb/dvbapi.xml
+++ b/Documentation/DocBook/media/dvb/dvbapi.xml
@@ -114,8 +114,32 @@ Added ISDB-T test originally written by Patrick Boettcher
     &sub-examples;
   </chapter>
 <!-- END OF CHAPTERS -->
+  <appendix id="audio_h">
+    <title>DVB Audio Header File</title>
+    &sub-audio-h;
+  </appendix>
+  <appendix id="ca_h">
+    <title>DVB Conditional Access Header File</title>
+    &sub-ca-h;
+  </appendix>
+  <appendix id="dmx_h">
+    <title>DVB Demux Header File</title>
+    &sub-dmx-h;
+  </appendix>
   <appendix id="frontend_h">
     <title>DVB Frontend Header File</title>
     &sub-frontend-h;
   </appendix>
+  <appendix id="net_h">
+    <title>DVB Network Header File</title>
+    &sub-net-h;
+  </appendix>
+  <appendix id="osd_h">
+    <title>DVB OSD Header File</title>
+    &sub-osd-h;
+  </appendix>
+  <appendix id="video_h">
+    <title>DVB Video Header File</title>
+    &sub-video-h;
+  </appendix>
 
diff --git a/Documentation/DocBook/media/dvb/intro.xml b/Documentation/DocBook/media/dvb/intro.xml
index 0dc83f6..8223639 100644
--- a/Documentation/DocBook/media/dvb/intro.xml
+++ b/Documentation/DocBook/media/dvb/intro.xml
@@ -175,10 +175,27 @@ the devices are described in the following chapters.</para>
 The DVB API include files should be included in application sources with
 a partial path like:</para>
 
-
+<programlisting>
+	#include &#x003C;linux/dvb/audio.h&#x003E;
+</programlisting>
+<programlisting>
+	#include &#x003C;linux/dvb/ca.h&#x003E;
+</programlisting>
+<programlisting>
+	#include &#x003C;linux/dvb/dmx.h&#x003E;
+</programlisting>
 <programlisting>
 	#include &#x003C;linux/dvb/frontend.h&#x003E;
 </programlisting>
+<programlisting>
+	#include &#x003C;linux/dvb/net.h&#x003E;
+</programlisting>
+<programlisting>
+	#include &#x003C;linux/dvb/osd.h&#x003E;
+</programlisting>
+<programlisting>
+	#include &#x003C;linux/dvb/video.h&#x003E;
+</programlisting>
 
 <para>To enable applications to support different API version, an
 additional include file <emphasis
-- 
1.7.1


