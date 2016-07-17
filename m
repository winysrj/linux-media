Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:51824 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750808AbcGQJI0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 05:08:26 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/5] videodev2.h: add VICs and picture aspect ratio
Date: Sun, 17 Jul 2016 11:08:13 +0200
Message-Id: <1468746497-46692-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1468746497-46692-1-git-send-email-hverkuil@xs4all.nl>
References: <1468746497-46692-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add picture aspect ratio information, the CEA-861 VIC (Video Identification
Code) and the HDMI VIC to struct v4l2_bt_timings.

The picture aspect was chosen rather than the pixel aspect since 1) the
CEA-861 standard uses picture aspect, and 2) pixel aspect ratio can become
tricky when dealing with pixel repeat timings. While we don't support those
yet at the moment, this might become necessary. And in that case using
picture aspect ratio makes more sense. And converting picture aspect ratio
to pixel aspect ratio is easy enough.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/uapi/linux/videodev2.h | 75 ++++++++++++++++++++++++++++++------------
 1 file changed, 54 insertions(+), 21 deletions(-)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 724f43e..e44b88b6 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1216,6 +1216,9 @@ struct v4l2_standard {
  *		(aka field 2) of interlaced field formats
  * @standards:	Standards the timing belongs to
  * @flags:	Flags
+ * @picture_aspect: The picture aspect ratio (hor/vert).
+ * @cea861_vic:	VIC code as per the CEA-861 standard.
+ * @hdmi_vic:	VIC code as per the HDMI standard.
  * @reserved:	Reserved fields, must be zeroed.
  *
  * A note regarding vertical interlaced timings: height refers to the total
@@ -1245,7 +1248,10 @@ struct v4l2_bt_timings {
 	__u32	il_vbackporch;
 	__u32	standards;
 	__u32	flags;
-	__u32	reserved[14];
+	struct v4l2_fract picture_aspect;
+	__u8	cea861_vic;
+	__u8	hdmi_vic;
+	__u8	reserved[46];
 } __attribute__ ((packed));
 
 /* Interlaced or progressive format */
@@ -1264,34 +1270,61 @@ struct v4l2_bt_timings {
 
 /* Flags */
 
-/* CVT/GTF specific: timing uses reduced blanking (CVT) or the 'Secondary
-   GTF' curve (GTF). In both cases the horizontal and/or vertical blanking
-   intervals are reduced, allowing a higher resolution over the same
-   bandwidth. This is a read-only flag. */
+/*
+ * CVT/GTF specific: timing uses reduced blanking (CVT) or the 'Secondary
+ * GTF' curve (GTF). In both cases the horizontal and/or vertical blanking
+ * intervals are reduced, allowing a higher resolution over the same
+ * bandwidth. This is a read-only flag.
+ */
 #define V4L2_DV_FL_REDUCED_BLANKING		(1 << 0)
-/* CEA-861 specific: set for CEA-861 formats with a framerate of a multiple
-   of six. These formats can be optionally played at 1 / 1.001 speed.
-   This is a read-only flag. */
+/*
+ * CEA-861 specific: set for CEA-861 formats with a framerate of a multiple
+ * of six. These formats can be optionally played at 1 / 1.001 speed.
+ * This is a read-only flag.
+ */
 #define V4L2_DV_FL_CAN_REDUCE_FPS		(1 << 1)
-/* CEA-861 specific: only valid for video transmitters, the flag is cleared
-   by receivers.
-   If the framerate of the format is a multiple of six, then the pixelclock
-   used to set up the transmitter is divided by 1.001 to make it compatible
-   with 60 Hz based standards such as NTSC and PAL-M that use a framerate of
-   29.97 Hz. Otherwise this flag is cleared. If the transmitter can't generate
-   such frequencies, then the flag will also be cleared. */
+/*
+ * CEA-861 specific: only valid for video transmitters, the flag is cleared
+ * by receivers.
+ * If the framerate of the format is a multiple of six, then the pixelclock
+ * used to set up the transmitter is divided by 1.001 to make it compatible
+ * with 60 Hz based standards such as NTSC and PAL-M that use a framerate of
+ * 29.97 Hz. Otherwise this flag is cleared. If the transmitter can't generate
+ * such frequencies, then the flag will also be cleared.
+ */
 #define V4L2_DV_FL_REDUCED_FPS			(1 << 2)
-/* Specific to interlaced formats: if set, then field 1 is really one half-line
-   longer and field 2 is really one half-line shorter, so each field has
-   exactly the same number of half-lines. Whether half-lines can be detected
-   or used depends on the hardware. */
+/*
+ * Specific to interlaced formats: if set, then field 1 is really one half-line
+ * longer and field 2 is really one half-line shorter, so each field has
+ * exactly the same number of half-lines. Whether half-lines can be detected
+ * or used depends on the hardware.
+ */
 #define V4L2_DV_FL_HALF_LINE			(1 << 3)
-/* If set, then this is a Consumer Electronics (CE) video format. Such formats
+/*
+ * If set, then this is a Consumer Electronics (CE) video format. Such formats
  * differ from other formats (commonly called IT formats) in that if RGB
  * encoding is used then by default the RGB values use limited range (i.e.
  * use the range 16-235) as opposed to 0-255. All formats defined in CEA-861
- * except for the 640x480 format are CE formats. */
+ * except for the 640x480 format are CE formats.
+ */
 #define V4L2_DV_FL_IS_CE_VIDEO			(1 << 4)
+/*
+ * If set, then the picture_aspect field is valid. Otherwise assume that the
+ * pixels are square, so the picture aspect ratio is the same as the width to
+ * height ratio.
+ */
+#define V4L2_DV_FL_HAS_PICTURE_ASPECT		(1 << 5)
+/*
+ * If set, then the cea861_vic field is valid and contains the Video
+ * Identification Code as per the CEA-861 standard.
+ */
+#define V4L2_DV_FL_HAS_CEA861_VIC		(1 << 6)
+/*
+ * If set, then the hdmi_vic field is valid and contains the Video
+ * Identification Code as per the HDMI standard (HDMI Vendor Specific
+ * InfoFrame).
+ */
+#define V4L2_DV_FL_HAS_HDMI_VIC			(1 << 7)
 
 /* A few useful defines to calculate the total blanking and frame sizes */
 #define V4L2_DV_BT_BLANKING_WIDTH(bt) \
-- 
2.8.1

