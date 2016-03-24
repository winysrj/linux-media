Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40280 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbcCXX1u (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2016 19:27:50 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 01/51] media: Add video processing entity functions
Date: Fri, 25 Mar 2016 01:26:57 +0200
Message-Id: <1458862067-19525-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1458862067-19525-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1458862067-19525-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add composer, format converter and scaler functions, as well as generic
video processing to be used when no other processing function is
applicable.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 Documentation/DocBook/media/v4l/media-types.xml | 34 +++++++++++++++++++++++++
 include/uapi/linux/media.h                      |  8 ++++++
 2 files changed, 42 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/media-types.xml b/Documentation/DocBook/media/v4l/media-types.xml
index 5e3f20fdcf17..a6e171e80bce 100644
--- a/Documentation/DocBook/media/v4l/media-types.xml
+++ b/Documentation/DocBook/media/v4l/media-types.xml
@@ -121,6 +121,40 @@
 	    <entry><constant>MEDIA_ENT_F_AUDIO_MIXER</constant></entry>
 	    <entry>Audio Mixer Function Entity.</entry>
 	  </row>
+	  <row>
+	    <entry><constant>MEDIA_ENT_F_PROC_VIDEO_GENERIC</constant></entry>
+	    <entry>Generic video processing, when no other processing function
+		   is applicable.
+	    </entry>
+	  <row>
+	    <entry><constant>MEDIA_ENT_F_PROC_VIDEO_COMPOSER</constant></entry>
+	    <entry>Video composer (blender). An entity capable of video
+		   composing must have at least two sink pads and one source
+		   pad, and composes input video frames onto output video
+		   frames. Composition can be performed using alpha blending,
+		   color keying, raster operations (ROP), stitching or any other
+		   mean.
+	    </entry>
+	  </row>
+	  </row>
+	    <entry><constant>MEDIA_ENT_F_PROC_VIDEO_CONVERTER</constant></entry>
+	    <entry>Video format converter. An entity capable of video format
+		   conversion must have at least one sink pad and one source
+		   pad, and convert the format of pixels received on its sink
+		   pad(s) to a different format output on its source pad(s).
+	    </entry>
+	  </row>
+	  <row>
+	    <entry><constant>MEDIA_ENT_F_PROC_VIDEO_SCALER</constant></entry>
+	    <entry>Video scaler. An entity capable of video scaling must have
+		   at least one sink pad and one source pad, and scaling the
+		   video frame(s) received on its sink pad(s) to a different
+		   resolution output on its source pad(s). The range of
+		   supported scaling ratios is entity-specific and can differ
+		   between the horizontal and vertical directions. In particular
+		   scaling can be supported in one direction only.
+	    </entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index df59edee25d1..884ec1cae09d 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -95,6 +95,14 @@ struct media_device_info {
 #define MEDIA_ENT_F_AUDIO_MIXER		(MEDIA_ENT_F_BASE + 0x03003)
 
 /*
+ * Processing entities
+ */
+#define MEDIA_ENT_F_PROC_VIDEO_GENERIC		(MEDIA_ENT_F_BASE + 0x4001)
+#define MEDIA_ENT_F_PROC_VIDEO_COMPOSER		(MEDIA_ENT_F_BASE + 0x4002)
+#define MEDIA_ENT_F_PROC_VIDEO_CONVERTER	(MEDIA_ENT_F_BASE + 0x4003)
+#define MEDIA_ENT_F_PROC_VIDEO_SCALER		(MEDIA_ENT_F_BASE + 0x4004)
+
+/*
  * Connectors
  */
 /* It is a responsibility of the entity drivers to add connectors and links */
-- 
2.7.3

