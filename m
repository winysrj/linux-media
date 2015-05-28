Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51450 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932170AbbE1Vtu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2015 17:49:50 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	David Howells <dhowells@redhat.com>, linux-doc@vger.kernel.org
Subject: [PATCH 16/35] DocBook: Add xref links for DTV propeties
Date: Thu, 28 May 2015 18:49:19 -0300
Message-Id: <08a24962454a3d571e64256b9665e6a519d70153.1432844837.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Create xref links for all DTV properties and link the frontend.h
to each. Also use them at the DVB frontent API example.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/Makefile b/Documentation/DocBook/media/Makefile
index f8380219afbb..723932f85fb6 100644
--- a/Documentation/DocBook/media/Makefile
+++ b/Documentation/DocBook/media/Makefile
@@ -73,6 +73,9 @@ IOCTLS = \
 	VIDIOC_SUBDEV_G_SELECTION \
 	VIDIOC_SUBDEV_S_SELECTION \
 
+DEFINES = \
+	$(shell perl -ne 'print "$$1 " if /\#define\s+(DTV_[^\s]+)\s+/' $(srctree)/include/uapi/linux/dvb/frontend.h) \
+
 TYPES = \
 	$(shell perl -ne 'print "$$1 " if /^typedef\s+[^\s]+\s+([^\s]+)\;/' $(srctree)/include/uapi/linux/videodev2.h) \
 	$(shell perl -ne 'print "$$1 " if /^}\s+([a-z0-9_]+_t)/' $(srctree)/include/uapi/linux/dvb/frontend.h)
@@ -187,8 +190,10 @@ DVB_DOCUMENTED = \
 	-e "s,\(audio-mixer\|audio-karaoke\|audio-status\|ca-slot-info\|ca-descr-info\|ca-caps\|ca-msg\|ca-descr\|ca-pid\|dmx-filter\|dmx-caps\|video-system\|video-highlight\|video-spu\|video-spu-palette\|video-navi-pack\)-t,\1,g" \
 	-e "s,DTV-ISDBT-LAYER[A-C],DTV-ISDBT-LAYER,g" \
 	-e "s,\(define\s\+\)\([A-Z0-9_]\+\)\(\s\+_IO\),\1\<link linkend=\"\2\">\2\<\/link\>\3,g" \
+	-e "s,\(define\s\+\)\(DTV_[A-Z0-9_]\+\)\(\s\+\),\1\<link linkend=\"\2\">\2\<\/link\>\3,g" \
 	-e "s,<link\s\+linkend=\".*\">\(__.*_OLD\)<\/link>,\1,g" \
 	-e "s/\(linkend\=\"\)FE_SET_PROPERTY/\1FE_GET_PROPERTY/g" \
+	-e "s,<link\s\+linkend=\".*\">\(DTV_ISDBS_TS_ID_LEGACY\|DTV_MAX_COMMAND\|DTV_IOCTL_MAX_MSGS\)<\/link>,\1,g" \
 
 #
 # Media targets and dependencies
@@ -306,6 +311,15 @@ $(MEDIA_OBJ_DIR)/media-entities.tmpl: $(MEDIA_OBJ_DIR)/v4l2.xml
 	  >>$@ ;							\
 	done)
 	@(								\
+	echo -e "\n<!-- Defines -->") >>$@
+	@(								\
+	for ident in $(DEFINES) ; do					\
+	  entity=`echo $$ident | tr _ -` ;				\
+	  echo "<!ENTITY $$entity \"<link"				\
+	    "linkend='$$entity'><constant>$$ident</constant></link>\">"	\
+	  >>$@ ;							\
+	done)
+	@(								\
 	echo -e "\n<!-- Types -->") >>$@
 	@(								\
 	for ident in $(TYPES) ; do					\
diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index c10ed0636d02..bb86a74ed7fe 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -20,12 +20,12 @@
     rate of 5.217 Mbauds, those properties should be sent to
     <link linkend="FE_GET_PROPERTY"><constant>FE_SET_PROPERTY</constant></link> ioctl:</para>
     <itemizedlist>
-	<listitem>DTV_FREQUENCY = 651000000</listitem>
-	<listitem>DTV_MODULATION = QAM_256</listitem>
-	<listitem>DTV_INVERSION = INVERSION_AUTO</listitem>
-	<listitem>DTV_SYMBOL_RATE = 5217000</listitem>
-	<listitem>DTV_INNER_FEC = FEC_3_4</listitem>
-	<listitem>DTV_TUNE</listitem>
+	<listitem>&DTV-FREQUENCY; = 651000000</listitem>
+	<listitem>&DTV-MODULATION; = QAM_256</listitem>
+	<listitem>&DTV-INVERSION; = INVERSION_AUTO</listitem>
+	<listitem>&DTV-SYMBOL-RATE; = 5217000</listitem>
+	<listitem>&DTV-INNER-FEC; = FEC_3_4</listitem>
+	<listitem>&DTV-TUNE;</listitem>
     </itemizedlist>
 <para>NOTE: This section describes the DVB version 5 extension of the DVB-API,
 also called "S2API", as this API were added to provide support for DVB-S2. It
-- 
2.4.1

