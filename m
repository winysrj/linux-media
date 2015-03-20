Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:40926 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750916AbbCTRF3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Mar 2015 13:05:29 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Martin Bugge <marbugge@cisco.com>,
	Mats Randgaard <mats.randgaard@cisco.com>
Subject: [PATCH 2/5] videodev2.h/v4l2-dv-timings.h: add V4L2_DV_FL_IS_CE_VIDEO flag
Date: Fri, 20 Mar 2015 18:05:03 +0100
Message-Id: <1426871106-31914-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1426871106-31914-1-git-send-email-hverkuil@xs4all.nl>
References: <1426871106-31914-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

In the past the V4L2_DV_BT_STD_CEA861 standard bit was used to
determine whether the format is a CE (Consumer Electronics) format
or not. However, the 640x480p59.94 format is part of the CEA-861
standard, but it is *not* a CE video format.

Add a new flag to make this explicit. This information is needed
in order to determine the default R'G'B' encoding for the format:
for CE video this is limited range (16-235) instead of full range
(0-255).

The header with all the timings has been updated with this new
flag.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Martin Bugge <marbugge@cisco.com>
Cc: Mats Randgaard <mats.randgaard@cisco.com>
---
 include/uapi/linux/v4l2-dv-timings.h | 64 ++++++++++++++++++++++--------------
 include/uapi/linux/videodev2.h       |  6 ++++
 2 files changed, 45 insertions(+), 25 deletions(-)

diff --git a/include/uapi/linux/v4l2-dv-timings.h b/include/uapi/linux/v4l2-dv-timings.h
index 6c8f159..c039f1d 100644
--- a/include/uapi/linux/v4l2-dv-timings.h
+++ b/include/uapi/linux/v4l2-dv-timings.h
@@ -48,14 +48,15 @@
 	.type = V4L2_DV_BT_656_1120, \
 	V4L2_INIT_BT_TIMINGS(720, 480, 1, 0, \
 		13500000, 19, 62, 57, 4, 3, 15, 4, 3, 16, \
-		V4L2_DV_BT_STD_CEA861, V4L2_DV_FL_HALF_LINE) \
+		V4L2_DV_BT_STD_CEA861, \
+		V4L2_DV_FL_HALF_LINE | V4L2_DV_FL_IS_CE_VIDEO) \
 }
 
 #define V4L2_DV_BT_CEA_720X480P59_94 { \
 	.type = V4L2_DV_BT_656_1120, \
 	V4L2_INIT_BT_TIMINGS(720, 480, 0, 0, \
 		27000000, 16, 62, 60, 9, 6, 30, 0, 0, 0, \
-		V4L2_DV_BT_STD_CEA861, 0) \
+		V4L2_DV_BT_STD_CEA861, V4L2_DV_FL_IS_CE_VIDEO) \
 }
 
 /* Note: these are the nominal timings, for HDMI links this format is typically
@@ -64,14 +65,15 @@
 	.type = V4L2_DV_BT_656_1120, \
 	V4L2_INIT_BT_TIMINGS(720, 576, 1, 0, \
 		13500000, 12, 63, 69, 2, 3, 19, 2, 3, 20, \
-		V4L2_DV_BT_STD_CEA861, V4L2_DV_FL_HALF_LINE) \
+		V4L2_DV_BT_STD_CEA861, \
+		V4L2_DV_FL_HALF_LINE | V4L2_DV_FL_IS_CE_VIDEO) \
 }
 
 #define V4L2_DV_BT_CEA_720X576P50 { \
 	.type = V4L2_DV_BT_656_1120, \
 	V4L2_INIT_BT_TIMINGS(720, 576, 0, 0, \
 		27000000, 12, 64, 68, 5, 5, 39, 0, 0, 0, \
-		V4L2_DV_BT_STD_CEA861, 0) \
+		V4L2_DV_BT_STD_CEA861, V4L2_DV_FL_IS_CE_VIDEO) \
 }
 
 #define V4L2_DV_BT_CEA_1280X720P24 { \
@@ -88,7 +90,7 @@
 	V4L2_INIT_BT_TIMINGS(1280, 720, 0, \
 		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
 		74250000, 2420, 40, 220, 5, 5, 20, 0, 0, 0, \
-		V4L2_DV_BT_STD_CEA861, 0) \
+		V4L2_DV_BT_STD_CEA861, V4L2_DV_FL_IS_CE_VIDEO) \
 }
 
 #define V4L2_DV_BT_CEA_1280X720P30 { \
@@ -96,7 +98,8 @@
 	V4L2_INIT_BT_TIMINGS(1280, 720, 0, \
 		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
 		74250000, 1760, 40, 220, 5, 5, 20, 0, 0, 0, \
-		V4L2_DV_BT_STD_CEA861, V4L2_DV_FL_CAN_REDUCE_FPS) \
+		V4L2_DV_BT_STD_CEA861, \
+		V4L2_DV_FL_CAN_REDUCE_FPS | V4L2_DV_FL_IS_CE_VIDEO) \
 }
 
 #define V4L2_DV_BT_CEA_1280X720P50 { \
@@ -104,7 +107,7 @@
 	V4L2_INIT_BT_TIMINGS(1280, 720, 0, \
 		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
 		74250000, 440, 40, 220, 5, 5, 20, 0, 0, 0, \
-		V4L2_DV_BT_STD_CEA861, 0) \
+		V4L2_DV_BT_STD_CEA861, V4L2_DV_FL_IS_CE_VIDEO) \
 }
 
 #define V4L2_DV_BT_CEA_1280X720P60 { \
@@ -112,7 +115,8 @@
 	V4L2_INIT_BT_TIMINGS(1280, 720, 0, \
 		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
 		74250000, 110, 40, 220, 5, 5, 20, 0, 0, 0, \
-		V4L2_DV_BT_STD_CEA861, V4L2_DV_FL_CAN_REDUCE_FPS) \
+		V4L2_DV_BT_STD_CEA861, \
+		V4L2_DV_FL_CAN_REDUCE_FPS | V4L2_DV_FL_IS_CE_VIDEO) \
 }
 
 #define V4L2_DV_BT_CEA_1920X1080P24 { \
@@ -120,7 +124,8 @@
 	V4L2_INIT_BT_TIMINGS(1920, 1080, 0, \
 		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
 		74250000, 638, 44, 148, 4, 5, 36, 0, 0, 0, \
-		V4L2_DV_BT_STD_CEA861, V4L2_DV_FL_CAN_REDUCE_FPS) \
+		V4L2_DV_BT_STD_CEA861, \
+		V4L2_DV_FL_CAN_REDUCE_FPS | V4L2_DV_FL_IS_CE_VIDEO) \
 }
 
 #define V4L2_DV_BT_CEA_1920X1080P25 { \
@@ -128,7 +133,7 @@
 	V4L2_INIT_BT_TIMINGS(1920, 1080, 0, \
 		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
 		74250000, 528, 44, 148, 4, 5, 36, 0, 0, 0, \
-		V4L2_DV_BT_STD_CEA861, 0) \
+		V4L2_DV_BT_STD_CEA861, V4L2_DV_FL_IS_CE_VIDEO) \
 }
 
 #define V4L2_DV_BT_CEA_1920X1080P30 { \
@@ -136,7 +141,8 @@
 	V4L2_INIT_BT_TIMINGS(1920, 1080, 0, \
 		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
 		74250000, 88, 44, 148, 4, 5, 36, 0, 0, 0, \
-		V4L2_DV_BT_STD_CEA861, V4L2_DV_FL_CAN_REDUCE_FPS) \
+		V4L2_DV_BT_STD_CEA861, \
+		V4L2_DV_FL_CAN_REDUCE_FPS | V4L2_DV_FL_IS_CE_VIDEO) \
 }
 
 #define V4L2_DV_BT_CEA_1920X1080I50 { \
@@ -144,7 +150,8 @@
 	V4L2_INIT_BT_TIMINGS(1920, 1080, 1, \
 		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
 		74250000, 528, 44, 148, 2, 5, 15, 2, 5, 16, \
-		V4L2_DV_BT_STD_CEA861, V4L2_DV_FL_HALF_LINE) \
+		V4L2_DV_BT_STD_CEA861, \
+		V4L2_DV_FL_HALF_LINE | V4L2_DV_FL_IS_CE_VIDEO) \
 }
 
 #define V4L2_DV_BT_CEA_1920X1080P50 { \
@@ -152,7 +159,7 @@
 	V4L2_INIT_BT_TIMINGS(1920, 1080, 0, \
 		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
 		148500000, 528, 44, 148, 4, 5, 36, 0, 0, 0, \
-		V4L2_DV_BT_STD_CEA861, 0) \
+		V4L2_DV_BT_STD_CEA861, V4L2_DV_FL_IS_CE_VIDEO) \
 }
 
 #define V4L2_DV_BT_CEA_1920X1080I60 { \
@@ -161,7 +168,8 @@
 		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
 		74250000, 88, 44, 148, 2, 5, 15, 2, 5, 16, \
 		V4L2_DV_BT_STD_CEA861, \
-		V4L2_DV_FL_CAN_REDUCE_FPS | V4L2_DV_FL_HALF_LINE) \
+		V4L2_DV_FL_CAN_REDUCE_FPS | \
+		V4L2_DV_FL_HALF_LINE | V4L2_DV_FL_IS_CE_VIDEO) \
 }
 
 #define V4L2_DV_BT_CEA_1920X1080P60 { \
@@ -170,77 +178,83 @@
 		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
 		148500000, 88, 44, 148, 4, 5, 36, 0, 0, 0, \
 		V4L2_DV_BT_STD_DMT | V4L2_DV_BT_STD_CEA861, \
-		V4L2_DV_FL_CAN_REDUCE_FPS) \
+		V4L2_DV_FL_CAN_REDUCE_FPS | V4L2_DV_FL_IS_CE_VIDEO) \
 }
 
 #define V4L2_DV_BT_CEA_3840X2160P24 { \
 	.type = V4L2_DV_BT_656_1120, \
 	V4L2_INIT_BT_TIMINGS(3840, 2160, 0, V4L2_DV_HSYNC_POS_POL, \
 		297000000, 1276, 88, 296, 8, 10, 72, 0, 0, 0, \
-		V4L2_DV_BT_STD_CEA861, V4L2_DV_FL_CAN_REDUCE_FPS) \
+		V4L2_DV_BT_STD_CEA861, \
+		V4L2_DV_FL_CAN_REDUCE_FPS | V4L2_DV_FL_IS_CE_VIDEO) \
 }
 
 #define V4L2_DV_BT_CEA_3840X2160P25 { \
 	.type = V4L2_DV_BT_656_1120, \
 	V4L2_INIT_BT_TIMINGS(3840, 2160, 0, V4L2_DV_HSYNC_POS_POL, \
 		297000000, 1056, 88, 296, 8, 10, 72, 0, 0, 0, \
-		V4L2_DV_BT_STD_CEA861, 0) \
+		V4L2_DV_BT_STD_CEA861, V4L2_DV_FL_IS_CE_VIDEO) \
 }
 
 #define V4L2_DV_BT_CEA_3840X2160P30 { \
 	.type = V4L2_DV_BT_656_1120, \
 	V4L2_INIT_BT_TIMINGS(3840, 2160, 0, V4L2_DV_HSYNC_POS_POL, \
 		297000000, 176, 88, 296, 8, 10, 72, 0, 0, 0, \
-		V4L2_DV_BT_STD_CEA861, V4L2_DV_FL_CAN_REDUCE_FPS) \
+		V4L2_DV_BT_STD_CEA861, \
+		V4L2_DV_FL_CAN_REDUCE_FPS | V4L2_DV_FL_IS_CE_VIDEO) \
 }
 
 #define V4L2_DV_BT_CEA_3840X2160P50 { \
 	.type = V4L2_DV_BT_656_1120, \
 	V4L2_INIT_BT_TIMINGS(3840, 2160, 0, V4L2_DV_HSYNC_POS_POL, \
 		594000000, 1056, 88, 296, 8, 10, 72, 0, 0, 0, \
-		V4L2_DV_BT_STD_CEA861, 0) \
+		V4L2_DV_BT_STD_CEA861, V4L2_DV_FL_IS_CE_VIDEO) \
 }
 
 #define V4L2_DV_BT_CEA_3840X2160P60 { \
 	.type = V4L2_DV_BT_656_1120, \
 	V4L2_INIT_BT_TIMINGS(3840, 2160, 0, V4L2_DV_HSYNC_POS_POL, \
 		594000000, 176, 88, 296, 8, 10, 72, 0, 0, 0, \
-		V4L2_DV_BT_STD_CEA861, V4L2_DV_FL_CAN_REDUCE_FPS) \
+		V4L2_DV_BT_STD_CEA861, \
+		V4L2_DV_FL_CAN_REDUCE_FPS | V4L2_DV_FL_IS_CE_VIDEO) \
 }
 
 #define V4L2_DV_BT_CEA_4096X2160P24 { \
 	.type = V4L2_DV_BT_656_1120, \
 	V4L2_INIT_BT_TIMINGS(4096, 2160, 0, V4L2_DV_HSYNC_POS_POL, \
 		297000000, 1020, 88, 296, 8, 10, 72, 0, 0, 0, \
-		V4L2_DV_BT_STD_CEA861, V4L2_DV_FL_CAN_REDUCE_FPS) \
+		V4L2_DV_BT_STD_CEA861, \
+		V4L2_DV_FL_CAN_REDUCE_FPS | V4L2_DV_FL_IS_CE_VIDEO) \
 }
 
 #define V4L2_DV_BT_CEA_4096X2160P25 { \
 	.type = V4L2_DV_BT_656_1120, \
 	V4L2_INIT_BT_TIMINGS(4096, 2160, 0, V4L2_DV_HSYNC_POS_POL, \
 		297000000, 968, 88, 128, 8, 10, 72, 0, 0, 0, \
-		V4L2_DV_BT_STD_CEA861, 0) \
+		V4L2_DV_BT_STD_CEA861, V4L2_DV_FL_IS_CE_VIDEO) \
 }
 
 #define V4L2_DV_BT_CEA_4096X2160P30 { \
 	.type = V4L2_DV_BT_656_1120, \
 	V4L2_INIT_BT_TIMINGS(4096, 2160, 0, V4L2_DV_HSYNC_POS_POL, \
 		297000000, 88, 88, 128, 8, 10, 72, 0, 0, 0, \
-		V4L2_DV_BT_STD_CEA861, V4L2_DV_FL_CAN_REDUCE_FPS) \
+		V4L2_DV_BT_STD_CEA861, \
+		V4L2_DV_FL_CAN_REDUCE_FPS | V4L2_DV_FL_IS_CE_VIDEO) \
 }
 
 #define V4L2_DV_BT_CEA_4096X2160P50 { \
 	.type = V4L2_DV_BT_656_1120, \
 	V4L2_INIT_BT_TIMINGS(4096, 2160, 0, V4L2_DV_HSYNC_POS_POL, \
 		594000000, 968, 88, 128, 8, 10, 72, 0, 0, 0, \
-		V4L2_DV_BT_STD_CEA861, 0) \
+		V4L2_DV_BT_STD_CEA861, V4L2_DV_FL_IS_CE_VIDEO) \
 }
 
 #define V4L2_DV_BT_CEA_4096X2160P60 { \
 	.type = V4L2_DV_BT_656_1120, \
 	V4L2_INIT_BT_TIMINGS(4096, 2160, 0, V4L2_DV_HSYNC_POS_POL, \
 		594000000, 88, 88, 128, 8, 10, 72, 0, 0, 0, \
-		V4L2_DV_BT_STD_CEA861, V4L2_DV_FL_CAN_REDUCE_FPS) \
+		V4L2_DV_BT_STD_CEA861, \
+		V4L2_DV_FL_CAN_REDUCE_FPS | V4L2_DV_FL_IS_CE_VIDEO) \
 }
 
 
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index fbdc360..f62bd34 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1187,6 +1187,12 @@ struct v4l2_bt_timings {
    exactly the same number of half-lines. Whether half-lines can be detected
    or used depends on the hardware. */
 #define V4L2_DV_FL_HALF_LINE			(1 << 3)
+/* If set, then this is a Consumer Electronics (CE) video format. Such formats
+ * differ from other formats (commonly called IT formats) in that if RGB
+ * encoding is used then by default the RGB values use limited range (i.e.
+ * use the range 16-235) as opposed to 0-255. All formats defined in CEA-861
+ * except for the 640x480 format are CE formats. */
+#define V4L2_DV_FL_IS_CE_VIDEO			(1 << 4)
 
 /* A few useful defines to calculate the total blanking and frame sizes */
 #define V4L2_DV_BT_BLANKING_WIDTH(bt) \
-- 
2.1.4

