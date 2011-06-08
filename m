Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:1124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752832Ab1FHBpv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Jun 2011 21:45:51 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p581jpGM028936
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 7 Jun 2011 21:45:51 -0400
Received: from pedra (vpn-236-210.phx2.redhat.com [10.3.236.210])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p581jnc2007506
	for <linux-media@vger.kernel.org>; Tue, 7 Jun 2011 21:45:50 -0400
Date: Tue, 7 Jun 2011 22:45:29 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 01/15] [media] DocBook/Makefile: add references for several
 dvb structures
Message-ID: <20110607224529.142473c4@pedra>
In-Reply-To: <cover.1307496835.git.mchehab@redhat.com>
References: <cover.1307496835.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

With this change, it is now possible to discover the gap between
the API defined inside include/dvb/frontend.h and the one documented
into the specs.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/Documentation/DocBook/media/Makefile b/Documentation/DocBook/media/Makefile
index baeea17..d9a21d3 100644
--- a/Documentation/DocBook/media/Makefile
+++ b/Documentation/DocBook/media/Makefile
@@ -51,6 +51,7 @@ FUNCS = \
 
 IOCTLS = \
 	$(shell perl -ne 'print "$$1 " if /\#define\s+([^\s]+)\s+_IO/' $(srctree)/include/linux/videodev2.h) \
+	$(shell perl -ne 'print "$$1 " if /\#define\s+([^\s]+)\s+_IO/' $(srctree)/include/linux/dvb/frontend.h) \
 	$(shell perl -ne 'print "$$1 " if /\#define\s+([^\s]+)\s+_IO/' $(srctree)/include/linux/media.h) \
 	$(shell perl -ne 'print "$$1 " if /\#define\s+([^\s]+)\s+_IO/' $(srctree)/include/linux/v4l2-subdev.h) \
 	VIDIOC_SUBDEV_G_FRAME_INTERVAL \
@@ -60,16 +61,19 @@ IOCTLS = \
 	VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL \
 
 TYPES = \
-	$(shell perl -ne 'print "$$1 " if /^typedef\s+[^\s]+\s+([^\s]+)\;/' $(srctree)/include/linux/videodev2.h)
+	$(shell perl -ne 'print "$$1 " if /^typedef\s+[^\s]+\s+([^\s]+)\;/' $(srctree)/include/linux/videodev2.h) \
+	$(shell perl -ne 'print "$$1 " if /^}\s+([a-z0-9_]+_t)/' $(srctree)/include/linux/dvb/frontend.h)
 
 ENUMS = \
 	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/linux/videodev2.h) \
+	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/linux/dvb/frontend.h) \
 	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/linux/media.h) \
 	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/linux/v4l2-mediabus.h) \
 	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/linux/v4l2-subdev.h)
 
 STRUCTS = \
 	$(shell perl -ne 'print "$$1 " if /^struct\s+([^\s]+)\s+/' $(srctree)/include/linux/videodev2.h) \
+	$(shell perl -ne 'print "$$1 " if /^struct\s+([^\s]+)\s+/' $(srctree)/include/linux/dvb/frontend.h) \
 	$(shell perl -ne 'print "$$1 " if /^struct\s+([^\s]+)\s+/' $(srctree)/include/linux/media.h) \
 	$(shell perl -ne 'print "$$1 " if /^struct\s+([^\s]+)\s+/' $(srctree)/include/linux/v4l2-subdev.h) \
 	$(shell perl -ne 'print "$$1 " if /^struct\s+([^\s]+)\s+/' $(srctree)/include/linux/v4l2-mediabus.h)
@@ -116,9 +120,11 @@ DOCUMENTED = \
 	-e "s/v4l2\-mpeg\-vbi\-ITV0/v4l2-mpeg-vbi-itv0-1/g"
 
 DVB_DOCUMENTED = \
-	-e "s,\(define \)\([A-Z0-9_]\+\)\(\s\+_IO\),\1\<link linkend=\"\2\">\2\<\/link\>\3,g" \
-	-e "s/\(linkend\=\"\)FE_SET_PROPERTY/\1FE_GET_PROPERTY/g"
-
+	-e "s,\(define\s\+\)\([A-Z0-9_]\+\)\(\s\+_IO\),\1\<link linkend=\"\2\">\2\<\/link\>\3,g" \
+	-e "s/\(linkend\=\"\)FE_SET_PROPERTY/\1FE_GET_PROPERTY/g" \
+	-e "s,\(struct\s\+\)\([a-z0-9_]\+\)\(\s\+{\),\1\<link linkend=\"\2\">\2\<\/link\>\3,g" \
+	-e "s,\(}\s\+\)\([a-z0-9_]\+_t\+\),\1\<link linkend=\"\2\">\2\<\/link\>,g" \
+#	-e "s,\(\s\+\)\(FE_[A-Z0-9_]\+\)\([\s\=\,]*\),\1\<link linkend=\"\2\">\2\<\/link\>\3,g" \
 
 #
 # Media targets and dependencies
-- 
1.7.1


