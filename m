Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48438 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294AbbH3DHu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Aug 2015 23:07:50 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-doc@vger.kernel.org
Subject: [PATCH v8 30/55] [media] replace all occurrences of MEDIA_ENT_T_DEVNODE_DVB
Date: Sun, 30 Aug 2015 00:06:41 -0300
Message-Id: <95f10058c1c2e5b511e5eb4ce890b821ed0697f9.1440902901.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440902901.git.mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440902901.git.mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that interfaces and entities are distinct, it makes no sense
of keeping something named as MEDIA_ENT_T_DEVNODE_DVB_foo.

Made via this script:
	for i in $(git grep -l MEDIA_ENT_T|grep -v uapi/linux/media.h); do sed s,MEDIA_ENT_T_DEVNODE_DVB_,MEDIA_ENT_T_DVB_, <$i >a && mv a $i; done
	for i in $(git grep -l MEDIA_ENT_T|grep -v uapi/linux/media.h); do sed s,MEDIA_ENT_T_DVB_DVR,MEDIA_ENT_T_DVB_TSOUT, <$i >a && mv a $i; done
	for i in $(git grep -l MEDIA_ENT_T|grep -v uapi/linux/media.h); do sed s,MEDIA_ENT_T_DVB_FE,MEDIA_ENT_T_DVB_DEMOD, <$i >a && mv a $i; done
	for i in $(git grep -l MEDIA_ENT_T|grep -v uapi/linux/media.h); do sed s,MEDIA_ENT_T_DVB_NET,MEDIA_ENT_T_DVB_DEMOD_NET_DECAP, <$i >a && mv a $i; done

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml b/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
index 910243d4edb8..32a783635649 100644
--- a/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
+++ b/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
@@ -195,23 +195,23 @@
 	    <entry>ALSA card</entry>
 	  </row>
 	  <row>
-	    <entry><constant>MEDIA_ENT_T_DEVNODE_DVB_FE</constant></entry>
+	    <entry><constant>MEDIA_ENT_T_DVB_DEMOD</constant></entry>
 	    <entry>DVB frontend devnode</entry>
 	  </row>
 	  <row>
-	    <entry><constant>MEDIA_ENT_T_DEVNODE_DVB_DEMUX</constant></entry>
+	    <entry><constant>MEDIA_ENT_T_DVB_DEMUX</constant></entry>
 	    <entry>DVB demux devnode</entry>
 	  </row>
 	  <row>
-	    <entry><constant>MEDIA_ENT_T_DEVNODE_DVB_DVR</constant></entry>
+	    <entry><constant>MEDIA_ENT_T_DVB_TSOUT</constant></entry>
 	    <entry>DVB DVR devnode</entry>
 	  </row>
 	  <row>
-	    <entry><constant>MEDIA_ENT_T_DEVNODE_DVB_CA</constant></entry>
+	    <entry><constant>MEDIA_ENT_T_DVB_CA</constant></entry>
 	    <entry>DVB CAM devnode</entry>
 	  </row>
 	  <row>
-	    <entry><constant>MEDIA_ENT_T_DEVNODE_DVB_NET</constant></entry>
+	    <entry><constant>MEDIA_ENT_T_DVB_DEMOD_NET_DECAP</constant></entry>
 	    <entry>DVB network devnode</entry>
 	  </row>
 	  <row>
-- 
2.4.3

