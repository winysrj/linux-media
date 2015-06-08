Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54760 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513AbbFHTyc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2015 15:54:32 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 01/26] [media] DocBook: handle enums on frontend.h
Date: Mon,  8 Jun 2015 16:53:45 -0300
Message-Id: <4eacb793809d953b9eccf9840d08f9db3d8f5ee6.1433792665.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1433792665.git.mchehab@osg.samsung.com>
References: <cover.1433792665.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1433792665.git.mchehab@osg.samsung.com>
References: <cover.1433792665.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In order to be sure that all enum definitions will be documented,
let's parse the enum values and add xref links to them.

Lots of missing references will be risen as we miss adding
id's to those symbols at the documentation. Next patches will
fix this.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/Makefile b/Documentation/DocBook/media/Makefile
index ae9d5a0404aa..226152952f58 100644
--- a/Documentation/DocBook/media/Makefile
+++ b/Documentation/DocBook/media/Makefile
@@ -74,16 +74,26 @@ TYPES = \
 	$(shell perl -ne 'print "$$1 " if /^typedef\s+.*\s+(\S+)\;/' $(srctree)/include/uapi/linux/dvb/frontend.h)
 
 ENUMS = \
-	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/uapi/linux/videodev2.h) \
-	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/uapi/linux/dvb/audio.h) \
-	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/uapi/linux/dvb/ca.h) \
-	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/uapi/linux/dvb/dmx.h) \
-	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/uapi/linux/dvb/frontend.h) \
-	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/uapi/linux/dvb/net.h) \
-	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/uapi/linux/dvb/video.h) \
-	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/uapi/linux/media.h) \
-	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/uapi/linux/v4l2-mediabus.h) \
-	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/uapi/linux/v4l2-subdev.h)
+	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' \
+		$(srctree)/include/uapi/linux/videodev2.h \
+		$(srctree)/include/uapi/linux/dvb/audio.h \
+		$(srctree)/include/uapi/linux/dvb/ca.h \
+		$(srctree)/include/uapi/linux/dvb/dmx.h \
+		$(srctree)/include/uapi/linux/dvb/frontend.h \
+		$(srctree)/include/uapi/linux/dvb/net.h \
+		$(srctree)/include/uapi/linux/dvb/video.h \
+		$(srctree)/include/uapi/linux/media.h \
+		$(srctree)/include/uapi/linux/v4l2-mediabus.h \
+		$(srctree)/include/uapi/linux/v4l2-subdev.h)
+
+ENUM_DEFS = \
+	$(shell perl -e 'while (<>) { if ($$enum) {print "$$1\n" if (/\s*([A-Z]\S+)\b/); } $$enum = 0 if ($enum && /^\}/); $$enum = 1 if(/^\s*enum\s/); }' \
+		$(srctree)/include/uapi/linux/dvb/audio.h \
+		$(srctree)/include/uapi/linux/dvb/ca.h \
+		$(srctree)/include/uapi/linux/dvb/dmx.h \
+		$(srctree)/include/uapi/linux/dvb/frontend.h \
+		$(srctree)/include/uapi/linux/dvb/net.h \
+		$(srctree)/include/uapi/linux/dvb/video.h)
 
 STRUCTS = \
 	$(shell perl -ne 'print "$$1 " if /^struct\s+([^\s]+)\s+/' $(srctree)/include/uapi/linux/videodev2.h) \
@@ -252,9 +262,14 @@ $(MEDIA_OBJ_DIR)/frontend.h.xml: $(srctree)/include/uapi/linux/dvb/frontend.h $(
 	@(					\
 	echo "<programlisting>") > $@
 	@(					\
+	for ident in $(ENUM_DEFS) ; do		\
+	  entity=`echo $$ident | tr _ -` ;	\
+	  r="$$r s/([^\w\-])$$ident([^\w\-])/\1\&$$entity\;\2/g;";\
+	done;					\
 	expand --tabs=8 < $< |			\
 	  sed $(ESCAPE) $(DVB_DOCUMENTED) |	\
-	  sed 's/i\.e\./&ie;/') >> $@
+	  sed 's/i\.e\./&ie;/' |		\
+	  perl -ne "$$r print $$_;") >> $@
 	@(					\
 	echo "</programlisting>") >> $@
 
@@ -331,6 +346,15 @@ $(MEDIA_OBJ_DIR)/media-entities.tmpl: $(MEDIA_OBJ_DIR)/v4l2.xml
 	    "linkend='$$entity'>$$ident</link>\">" >>$@ ;		\
 	done)
 	@(								\
+	echo -e "\n<!-- Enum definitions -->") >>$@
+	@(								\
+	for ident in $(ENUM_DEFS) ; do					\
+	  entity=`echo $$ident | tr _ -` ;				\
+	  echo "<!ENTITY $$entity \"<link"				\
+	    "linkend='$$entity'><constant>$$ident</constant></link>\">"	\
+	  >>$@ ;							\
+	done)
+	@(								\
 	echo -e "\n<!-- Structures -->") >>$@
 	@(								\
 	for ident in $(STRUCTS) ; do					\
-- 
2.4.2

