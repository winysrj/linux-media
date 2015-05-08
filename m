Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36598 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbbEHBMy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 May 2015 21:12:54 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-doc@vger.kernel.org
Subject: [PATCH 18/18] DocBook: update descriptions for the media controller entities
Date: Thu,  7 May 2015 22:12:40 -0300
Message-Id: <30735ac038b943d6b8219df6bd4d870ed2fd7654.1431046915.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1431046915.git.mchehab@osg.samsung.com>
References: <cover.1431046915.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1431046915.git.mchehab@osg.samsung.com>
References: <cover.1431046915.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cleanup the media controller entities description:
- remove MEDIA_ENT_T_DEVNODE and MEDIA_ENT_T_V4L2_SUBDEV;
- improve the description of some entities;
- add MEDIA_ENT_T_UNKNOWN with a proper description.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml b/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
index 5c7f366bb1f4..fca305b60b10 100644
--- a/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
+++ b/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
@@ -179,48 +179,37 @@
         <colspec colname="c2"/>
 	<tbody valign="top">
 	  <row>
-	    <entry><constant>MEDIA_ENT_T_DEVNODE</constant></entry>
-	    <entry>Unknown device node</entry>
+	    <entry><constant>MEDIA_ENT_T_UNKNOWN</constant></entry>
+	    <entry>Unknown device node. That generally indicates that
+	    a device driver didn't initialize properly</entry>
 	  </row>
 	  <row>
 	    <entry><constant>MEDIA_ENT_T_AV_DMA</constant></entry>
-	    <entry>V4L video, radio or vbi device node</entry>
-	  </row>
-	  <row>
-	    <entry><constant>MEDIA_ENT_T_DEVNODE_FB</constant></entry>
-	    <entry>Frame buffer device node</entry>
-	  </row>
-	  <row>
-	    <entry><constant>MEDIA_ENT_T_DEVNODE_ALSA</constant></entry>
-	    <entry>ALSA card</entry>
+	    <entry>V4L Audio/Video DMA engine, used for video, vbi or SDR radio data transfer</entry>
 	  </row>
 	  <row>
 	    <entry><constant>MEDIA_ENT_T_DTV_DEMOD</constant></entry>
-	    <entry>DVB frontend devnode</entry>
+	    <entry>DVB demodulator, associated with a frontend device node</entry>
 	  </row>
 	  <row>
 	    <entry><constant>MEDIA_ENT_T_DTV_DEMUX</constant></entry>
-	    <entry>DVB demux devnode</entry>
+	    <entry>DVB demux hardware or Kernel emulation</entry>
 	  </row>
 	  <row>
 	    <entry><constant>MEDIA_ENT_T_DTV_DVR</constant></entry>
-	    <entry>DVB DVR devnode</entry>
+	    <entry>DVB DVR streaming output device node</entry>
 	  </row>
 	  <row>
 	    <entry><constant>MEDIA_ENT_T_DTV_CA</constant></entry>
-	    <entry>DVB CAM devnode</entry>
+	    <entry>DVB Conditional Access Module (CAM)</entry>
 	  </row>
 	  <row>
 	    <entry><constant>MEDIA_ENT_T_DTV_NET</constant></entry>
-	    <entry>DVB network devnode</entry>
-	  </row>
-	  <row>
-	    <entry><constant>MEDIA_ENT_T_V4L2_SUBDEV</constant></entry>
-	    <entry>Unknown V4L sub-device</entry>
+	    <entry>DVB network device node</entry>
 	  </row>
 	  <row>
 	    <entry><constant>MEDIA_ENT_T_CAM_SENSOR</constant></entry>
-	    <entry>Video sensor</entry>
+	    <entry>Camera video sensor</entry>
 	  </row>
 	  <row>
 	    <entry><constant>MEDIA_ENT_T_CAM_FLASH</constant></entry>
@@ -232,7 +221,7 @@
 	  </row>
 	  <row>
 	    <entry><constant>MEDIA_ENT_T_ATV_DECODER</constant></entry>
-	    <entry>Video decoder, the basic function of the video decoder is to
+	    <entry>Analog TV video decoder, the basic function of the video decoder is to
 	    accept analogue video from a wide variety of sources such as
 	    broadcast, DVD players, cameras and video cassette recorders, in
 	    either NTSC, PAL or HD format and still occasionally SECAM, separate
@@ -242,7 +231,7 @@
 	  </row>
 	  <row>
 	    <entry><constant>MEDIA_ENT_T_TUNER</constant></entry>
-	    <entry>TV and/or radio tuner</entry>
+	    <entry>Digital TV, analog TV and/or radio tuner</entry>
 	  </row>
 	</tbody>
       </tgroup>
-- 
2.1.0

