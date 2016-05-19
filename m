Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56459 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172AbcESXkb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 May 2016 19:40:31 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH v4 1/6] media: Add video processing entity functions
Date: Fri, 20 May 2016 02:40:27 +0300
Message-Id: <1463701232-22008-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1463701232-22008-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1463701232-22008-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add composer, pixel formatter, pixel encoding converter and scaler
functions.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 Documentation/DocBook/media/v4l/media-types.xml | 55 +++++++++++++++++++++++++
 include/uapi/linux/media.h                      |  9 ++++
 2 files changed, 64 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/media-types.xml b/Documentation/DocBook/media/v4l/media-types.xml
index 5e3f20fdcf17..60fe841f8846 100644
--- a/Documentation/DocBook/media/v4l/media-types.xml
+++ b/Documentation/DocBook/media/v4l/media-types.xml
@@ -121,6 +121,61 @@
 	    <entry><constant>MEDIA_ENT_F_AUDIO_MIXER</constant></entry>
 	    <entry>Audio Mixer Function Entity.</entry>
 	  </row>
+	  <row>
+	    <entry><constant>MEDIA_ENT_F_PROC_VIDEO_COMPOSER</constant></entry>
+	    <entry>Video composer (blender). An entity capable of video
+		   composing must have at least two sink pads and one source
+		   pad, and composes input video frames onto output video
+		   frames. Composition can be performed using alpha blending,
+		   color keying, raster operations (ROP), stitching or any other
+		   means.
+	    </entry>
+	  </row>
+	  <row>
+	    <entry><constant>MEDIA_ENT_F_PROC_VIDEO_PIXEL_FORMATTER</constant></entry>
+	    <entry>Video pixel formatter. An entity capable of pixel formatting
+		   must have at least one sink pad and one source pad. Read
+		   pixel formatters read pixels from memory and perform a subset
+		   of unpacking, cropping, color keying, alpha multiplication
+		   and pixel encoding conversion. Write pixel formatters perform
+		   a subset of dithering, pixel encoding conversion and packing
+		   and write pixels to memory.
+	    </entry>
+	  </row>
+	  <row>
+	    <entry><constant>MEDIA_ENT_F_PROC_VIDEO_PIXEL_ENC_CONV</constant></entry>
+	    <entry>Video pixel encoding converter. An entity capable of pixel
+		   enconding conversion must have at least one sink pad and one
+		   source pad, and convert the encoding of pixels received on
+		   its sink pad(s) to a different encoding output on its source
+		   pad(s). Pixel encoding conversion includes but isn't limited
+		   to RGB to/from HSV, RGB to/from YUV and CFA (Bayer) to RGB
+		   conversions.
+	    </entry>
+	  </row>
+	  <row>
+	    <entry><constant>MEDIA_ENT_F_PROC_VIDEO_LUT</constant></entry>
+	    <entry>Video look-up table. An entity capable of video lookup table
+		   processing must have one sink pad and one source pad. It uses
+		   the values of the pixels received on its sink pad to look up
+		   entries in internal tables and output them on its source pad.
+		   The lookup processing can be performed on all components
+		   separately or combine them for multi-dimensional table
+		   lookups.
+	    </entry>
+	  </row>
+	  <row>
+	    <entry><constant>MEDIA_ENT_F_PROC_VIDEO_SCALER</constant></entry>
+	    <entry>Video scaler. An entity capable of video scaling must have
+		   at least one sink pad and one source pad, and scale the
+		   video frame(s) received on its sink pad(s) to a different
+		   resolution output on its source pad(s). The range of
+		   supported scaling ratios is entity-specific and can differ
+		   between the horizontal and vertical directions (in particular
+		   scaling can be supported in one direction only). Binning and
+		   skipping are considered as scaling.
+	    </entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index e226bc35c639..bff3ffdfd55f 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -96,6 +96,15 @@ struct media_device_info {
 #define MEDIA_ENT_F_AUDIO_MIXER		(MEDIA_ENT_F_BASE + 0x03003)
 
 /*
+ * Processing entities
+ */
+#define MEDIA_ENT_F_PROC_VIDEO_COMPOSER		(MEDIA_ENT_F_BASE + 0x4001)
+#define MEDIA_ENT_F_PROC_VIDEO_PIXEL_FORMATTER	(MEDIA_ENT_F_BASE + 0x4002)
+#define MEDIA_ENT_F_PROC_VIDEO_PIXEL_ENC_CONV	(MEDIA_ENT_F_BASE + 0x4003)
+#define MEDIA_ENT_F_PROC_VIDEO_LUT		(MEDIA_ENT_F_BASE + 0x4004)
+#define MEDIA_ENT_F_PROC_VIDEO_SCALER		(MEDIA_ENT_F_BASE + 0x4005)
+
+/*
  * Connectors
  */
 /* It is a responsibility of the entity drivers to add connectors and links */
-- 
2.7.3

