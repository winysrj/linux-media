Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53894 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbbIFRbk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Sep 2015 13:31:40 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-doc@vger.kernel.org
Subject: [PATCH 16/18] [media] DocBook: update entities documentation
Date: Sun,  6 Sep 2015 14:30:59 -0300
Message-Id: <e9e68d5f66f8c9c626eafc2fafd235b8276bc0ac.1441559233.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1441559233.git.mchehab@osg.samsung.com>
References: <cover.1441559233.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1441559233.git.mchehab@osg.samsung.com>
References: <cover.1441559233.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to the rename, the documentation became outdated.

Update it to reflect what's there at media.h.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml b/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
index bc101516e372..f9bfe8094d6d 100644
--- a/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
+++ b/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
@@ -179,54 +179,60 @@
         <colspec colname="c2"/>
 	<tbody valign="top">
 	  <row>
-	    <entry><constant>MEDIA_ENT_T_UNKNOWN</constant> and <constant>MEDIA_ENT_T_V4L2_SUBDEV_UNKNOWN</constant></entry>
+	    <entry><constant>MEDIA_ENT_F_UNKNOWN</constant> and <constant>MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN</constant></entry>
 	    <entry>Unknown entity. That generally indicates that
 	    a driver didn't initialize properly the entity, with is a Kernel bug</entry>
 	  </row>
 	  <row>
-	    <entry><constant>MEDIA_ENT_T_V4L2_VIDEO</constant></entry>
-	    <entry>V4L video streaming input or output entity</entry>
+	    <entry><constant>MEDIA_ENT_F_IO</constant></entry>
+	    <entry>Data streaming input and/or output entity.</entry>
 	  </row>
-	    <entry><constant>MEDIA_ENT_T_V4L2_VBI</constant></entry>
-	    <entry>V4L VBI streaming input or output entity</entry>
+	  <row>
+	    <entry><constant>MEDIA_ENT_F_DTV_DEMOD</constant></entry>
+	    <entry>Digital TV demodulator entity.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>MEDIA_ENT_F_MPEG_TS_DEMUX</constant></entry>
+	    <entry>MPEG Transport stream demux entity. Could be implemented on hardware or in Kernelspace by the Linux DVB subsystem.</entry>
 	  </row>
-	    <entry><constant>MEDIA_ENT_T_V4L2_SWRADIO</constant></entry>
-	    <entry>V4L Sofware Digital Radio (SDR) streaming input or output entity</entry>
+	  <row>
+	    <entry><constant>MEDIA_ENT_F_DTV_CA</constant></entry>
+	    <entry>Digital TV Conditional Access module (CAM) entity</entry>
 	  </row>
 	  <row>
-	    <entry><constant>MEDIA_ENT_T_DVB_DEMOD</constant></entry>
-	    <entry>DVB demodulator entity</entry>
+	    <entry><constant>MEDIA_ENT_F_DTV_NET_DECAP</constant></entry>
+	    <entry>Digital TV network ULE/MLE desencapsulation entity. Could be implemented on hardware or in Kernelspace</entry>
 	  </row>
 	  <row>
-	    <entry><constant>MEDIA_ENT_T_DVB_DEMUX</constant></entry>
-	    <entry>DVB demux entity. Could be implemented on hardware or in Kernelspace</entry>
+	    <entry><constant>MEDIA_ENT_F_CONN_RF</constant></entry>
+	    <entry>Connector for a Radio Frequency (RF) signal.</entry>
 	  </row>
 	  <row>
-	    <entry><constant>MEDIA_ENT_T_DVB_TSOUT</constant></entry>
-	    <entry>DVB Transport Stream output entity</entry>
+	    <entry><constant>MEDIA_ENT_F_CONN_SVIDEO</constant></entry>
+	    <entry>Connector for a S-Video signal.</entry>
 	  </row>
 	  <row>
-	    <entry><constant>MEDIA_ENT_T_DVB_CA</constant></entry>
-	    <entry>DVB Conditional Access module (CAM) entity</entry>
+	    <entry><constant>MEDIA_ENT_F_CONN_COMPOSITE</constant></entry>
+	    <entry>Connector for a RGB composite signal.</entry>
 	  </row>
 	  <row>
-	    <entry><constant>MEDIA_ENT_T_DVB_DEMOD_NET_DECAP</constant></entry>
-	    <entry>DVB network ULE/MLE desencapsulation entity. Could be implemented on hardware or in Kernelspace</entry>
+	    <entry><constant>MEDIA_ENT_F_CONN_TEST</constant></entry>
+	    <entry>Connector for a test generator.</entry>
 	  </row>
 	  <row>
-	    <entry><constant>MEDIA_ENT_T_V4L2_SUBDEV_SENSOR</constant></entry>
-	    <entry>Camera video sensor entity</entry>
+	    <entry><constant>MEDIA_ENT_F_CAM_SENSOR</constant></entry>
+	    <entry>Camera video sensor entity.</entry>
 	  </row>
 	  <row>
-	    <entry><constant>MEDIA_ENT_T_V4L2_SUBDEV_FLASH</constant></entry>
-	    <entry>Flash controller entity</entry>
+	    <entry><constant>MEDIA_ENT_F_FLASH</constant></entry>
+	    <entry>Flash controller entity.</entry>
 	  </row>
 	  <row>
-	    <entry><constant>MEDIA_ENT_T_V4L2_SUBDEV_LENS</constant></entry>
-	    <entry>Lens controller entity</entry>
+	    <entry><constant>MEDIA_ENT_F_LENS</constant></entry>
+	    <entry>Lens controller entity.</entry>
 	  </row>
 	  <row>
-	    <entry><constant>MEDIA_ENT_T_V4L2_SUBDEV_DECODER</constant></entry>
+	    <entry><constant>MEDIA_ENT_F_ATV_DECODER</constant></entry>
 	    <entry>Analog video decoder, the basic function of the video decoder
 	    is to accept analogue video from a wide variety of sources such as
 	    broadcast, DVD players, cameras and video cassette recorders, in
@@ -236,8 +242,8 @@
 	    signals.</entry>
 	  </row>
 	  <row>
-	    <entry><constant>MEDIA_ENT_T_V4L2_SUBDEV_TUNER</constant></entry>
-	    <entry>Digital TV, analog TV, radio and/or software radio tuner</entry>
+	    <entry><constant>MEDIA_ENT_F_TUNER</constant></entry>
+	    <entry>Digital TV, analog TV, radio and/or software radio tuner.</entry>
 	  </row>
 	</tbody>
       </tgroup>
-- 
2.4.3


