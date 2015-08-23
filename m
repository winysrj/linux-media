Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58974 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582AbbHWUSL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Aug 2015 16:18:11 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-doc@vger.kernel.org
Subject: [PATCH v7 36/44] [media] DocBook: update descriptions for the media controller entities
Date: Sun, 23 Aug 2015 17:17:53 -0300
Message-Id: <b85bdf6bb272424ee7b0b494adc6103a01056605.1440359643.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440359643.git.mchehab@osg.samsung.com>
References: <cover.1440359643.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440359643.git.mchehab@osg.samsung.com>
References: <cover.1440359643.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cleanup the media controller entities description:
- remove MEDIA_ENT_T_DEVNODE and MEDIA_ENT_T_V4L2_SUBDEV entity
  types, as they don't mean anything;
- add MEDIA_ENT_T_UNKNOWN with a proper description;
- remove ALSA and FB entity types. Those should not be used, as
  the types are deprecated. We'll soon be adidng ALSA, but with
  a different entity namespace;
- improve the description of some entities.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml b/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
index 32a783635649..a2f5704fb1dd 100644
--- a/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
+++ b/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
@@ -179,70 +179,59 @@
         <colspec colname="c2"/>
 	<tbody valign="top">
 	  <row>
-	    <entry><constant>MEDIA_ENT_T_DEVNODE</constant></entry>
-	    <entry>Unknown device node</entry>
+	    <entry><constant>MEDIA_ENT_T_UNKNOWN</constant></entry>
+	    <entry>Unknown entity. That generally indicates that
+	    a driver didn't initialize properly the entity, with is a Kernel bug</entry>
 	  </row>
 	  <row>
 	    <entry><constant>MEDIA_ENT_T_V4L2_VIDEO</constant></entry>
-	    <entry>V4L video, radio or vbi device node</entry>
-	  </row>
-	  <row>
-	    <entry><constant>MEDIA_ENT_T_DEVNODE_FB</constant></entry>
-	    <entry>Frame buffer device node</entry>
-	  </row>
-	  <row>
-	    <entry><constant>MEDIA_ENT_T_DEVNODE_ALSA</constant></entry>
-	    <entry>ALSA card</entry>
+	    <entry>V4L video streaming input or output entity</entry>
 	  </row>
 	  <row>
 	    <entry><constant>MEDIA_ENT_T_DVB_DEMOD</constant></entry>
-	    <entry>DVB frontend devnode</entry>
+	    <entry>DVB demodulator entity</entry>
 	  </row>
 	  <row>
 	    <entry><constant>MEDIA_ENT_T_DVB_DEMUX</constant></entry>
-	    <entry>DVB demux devnode</entry>
+	    <entry>DVB demux entity. Could be implemented on hardware or in Kernelspace</entry>
 	  </row>
 	  <row>
 	    <entry><constant>MEDIA_ENT_T_DVB_TSOUT</constant></entry>
-	    <entry>DVB DVR devnode</entry>
+	    <entry>DVB Transport Stream output entity</entry>
 	  </row>
 	  <row>
 	    <entry><constant>MEDIA_ENT_T_DVB_CA</constant></entry>
-	    <entry>DVB CAM devnode</entry>
+	    <entry>DVB Conditional Access module (CAM) entity</entry>
 	  </row>
 	  <row>
 	    <entry><constant>MEDIA_ENT_T_DVB_DEMOD_NET_DECAP</constant></entry>
-	    <entry>DVB network devnode</entry>
-	  </row>
-	  <row>
-	    <entry><constant>MEDIA_ENT_T_V4L2_SUBDEV</constant></entry>
-	    <entry>Unknown V4L sub-device</entry>
+	    <entry>DVB network ULE/MLE desencapsulation entity. Could be implemented on hardware or in Kernelspace</entry>
 	  </row>
 	  <row>
 	    <entry><constant>MEDIA_ENT_T_V4L2_SUBDEV_SENSOR</constant></entry>
-	    <entry>Video sensor</entry>
+	    <entry>Camera video sensor entity</entry>
 	  </row>
 	  <row>
 	    <entry><constant>MEDIA_ENT_T_V4L2_SUBDEV_FLASH</constant></entry>
-	    <entry>Flash controller</entry>
+	    <entry>Flash controller entity</entry>
 	  </row>
 	  <row>
 	    <entry><constant>MEDIA_ENT_T_V4L2_SUBDEV_LENS</constant></entry>
-	    <entry>Lens controller</entry>
+	    <entry>Lens controller entity</entry>
 	  </row>
 	  <row>
 	    <entry><constant>MEDIA_ENT_T_V4L2_SUBDEV_DECODER</constant></entry>
-	    <entry>Video decoder, the basic function of the video decoder is to
-	    accept analogue video from a wide variety of sources such as
+	    <entry>Analog video decoder, the basic function of the video decoder
+	    is to accept analogue video from a wide variety of sources such as
 	    broadcast, DVD players, cameras and video cassette recorders, in
-	    either NTSC, PAL or HD format and still occasionally SECAM, separate
-	    it into its component parts, luminance and chrominance, and output
+	    either NTSC, PAL, SECAM or HD format, separating the stream
+	    into its component parts, luminance and chrominance, and output
 	    it in some digital video standard, with appropriate embedded timing
 	    signals.</entry>
 	  </row>
 	  <row>
 	    <entry><constant>MEDIA_ENT_T_V4L2_SUBDEV_TUNER</constant></entry>
-	    <entry>TV and/or radio tuner</entry>
+	    <entry>Digital TV, analog TV, radio and/or software radio tuner</entry>
 	  </row>
 	</tbody>
       </tgroup>
-- 
2.4.3

