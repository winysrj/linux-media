Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:40635 "EHLO
        lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1765182AbcIPK5Y (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Sep 2016 06:57:24 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 2/8] videodev2.h: add VICs and picture aspect ratio
Date: Fri, 16 Sep 2016 12:57:05 +0200
Message-Id: <1474023431-32533-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1474023431-32533-1-git-send-email-hverkuil@xs4all.nl>
References: <1474023431-32533-1-git-send-email-hverkuil@xs4all.nl>
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
 include/uapi/linux/videodev2.h | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 3a2d94f..784bfeb 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1229,6 +1229,9 @@ struct v4l2_standard {
  *		(aka field 2) of interlaced field formats
  * @standards:	Standards the timing belongs to
  * @flags:	Flags
+ * @picture_aspect: The picture aspect ratio (hor/vert).
+ * @cea861_vic:	VIC code as per the CEA-861 standard.
+ * @hdmi_vic:	VIC code as per the HDMI standard.
  * @reserved:	Reserved fields, must be zeroed.
  *
  * A note regarding vertical interlaced timings: height refers to the total
@@ -1258,7 +1261,10 @@ struct v4l2_bt_timings {
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
@@ -1315,6 +1321,23 @@ struct v4l2_bt_timings {
  * except for the 640x480 format are CE formats.
  */
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

