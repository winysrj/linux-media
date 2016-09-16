Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:60839 "EHLO
        lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1765721AbcIPK5V (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Sep 2016 06:57:21 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 1/8] videodev2.h: checkpatch cleanup
Date: Fri, 16 Sep 2016 12:57:04 +0200
Message-Id: <1474023431-32533-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1474023431-32533-1-git-send-email-hverkuil@xs4all.nl>
References: <1474023431-32533-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Format comments according to what checkpatch wants.

No other changes.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/uapi/linux/videodev2.h | 50 +++++++++++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 20 deletions(-)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 5529741..3a2d94f 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1277,33 +1277,43 @@ struct v4l2_bt_timings {
 
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
 
 /* A few useful defines to calculate the total blanking and frame sizes */
-- 
2.8.1

