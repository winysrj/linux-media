Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:33644 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751662AbcDVHA4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Apr 2016 03:00:56 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH for v4.6] v4l2-dv-timings.h: fix polarity for 4k formats
Cc: Martin Bugge <marbugge@cisco.com>
Message-ID: <5719CC22.6080301@xs4all.nl>
Date: Fri, 22 Apr 2016 09:00:50 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The VSync polarity was negative instead of positive for the 4k CEA formats.
I probably copy-and-pasted these from the DMT 4k format, which does have a
negative VSync polarity.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Martin Bugge <marbugge@cisco.com>
---
diff --git a/include/uapi/linux/v4l2-dv-timings.h b/include/uapi/linux/v4l2-dv-timings.h
index c039f1d..086168e 100644
--- a/include/uapi/linux/v4l2-dv-timings.h
+++ b/include/uapi/linux/v4l2-dv-timings.h
@@ -183,7 +183,8 @@

 #define V4L2_DV_BT_CEA_3840X2160P24 { \
 	.type = V4L2_DV_BT_656_1120, \
-	V4L2_INIT_BT_TIMINGS(3840, 2160, 0, V4L2_DV_HSYNC_POS_POL, \
+	V4L2_INIT_BT_TIMINGS(3840, 2160, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
 		297000000, 1276, 88, 296, 8, 10, 72, 0, 0, 0, \
 		V4L2_DV_BT_STD_CEA861, \
 		V4L2_DV_FL_CAN_REDUCE_FPS | V4L2_DV_FL_IS_CE_VIDEO) \
@@ -191,14 +192,16 @@

 #define V4L2_DV_BT_CEA_3840X2160P25 { \
 	.type = V4L2_DV_BT_656_1120, \
-	V4L2_INIT_BT_TIMINGS(3840, 2160, 0, V4L2_DV_HSYNC_POS_POL, \
+	V4L2_INIT_BT_TIMINGS(3840, 2160, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
 		297000000, 1056, 88, 296, 8, 10, 72, 0, 0, 0, \
 		V4L2_DV_BT_STD_CEA861, V4L2_DV_FL_IS_CE_VIDEO) \
 }

 #define V4L2_DV_BT_CEA_3840X2160P30 { \
 	.type = V4L2_DV_BT_656_1120, \
-	V4L2_INIT_BT_TIMINGS(3840, 2160, 0, V4L2_DV_HSYNC_POS_POL, \
+	V4L2_INIT_BT_TIMINGS(3840, 2160, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
 		297000000, 176, 88, 296, 8, 10, 72, 0, 0, 0, \
 		V4L2_DV_BT_STD_CEA861, \
 		V4L2_DV_FL_CAN_REDUCE_FPS | V4L2_DV_FL_IS_CE_VIDEO) \
@@ -206,14 +209,16 @@

 #define V4L2_DV_BT_CEA_3840X2160P50 { \
 	.type = V4L2_DV_BT_656_1120, \
-	V4L2_INIT_BT_TIMINGS(3840, 2160, 0, V4L2_DV_HSYNC_POS_POL, \
+	V4L2_INIT_BT_TIMINGS(3840, 2160, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
 		594000000, 1056, 88, 296, 8, 10, 72, 0, 0, 0, \
 		V4L2_DV_BT_STD_CEA861, V4L2_DV_FL_IS_CE_VIDEO) \
 }

 #define V4L2_DV_BT_CEA_3840X2160P60 { \
 	.type = V4L2_DV_BT_656_1120, \
-	V4L2_INIT_BT_TIMINGS(3840, 2160, 0, V4L2_DV_HSYNC_POS_POL, \
+	V4L2_INIT_BT_TIMINGS(3840, 2160, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
 		594000000, 176, 88, 296, 8, 10, 72, 0, 0, 0, \
 		V4L2_DV_BT_STD_CEA861, \
 		V4L2_DV_FL_CAN_REDUCE_FPS | V4L2_DV_FL_IS_CE_VIDEO) \
@@ -221,7 +226,8 @@

 #define V4L2_DV_BT_CEA_4096X2160P24 { \
 	.type = V4L2_DV_BT_656_1120, \
-	V4L2_INIT_BT_TIMINGS(4096, 2160, 0, V4L2_DV_HSYNC_POS_POL, \
+	V4L2_INIT_BT_TIMINGS(4096, 2160, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
 		297000000, 1020, 88, 296, 8, 10, 72, 0, 0, 0, \
 		V4L2_DV_BT_STD_CEA861, \
 		V4L2_DV_FL_CAN_REDUCE_FPS | V4L2_DV_FL_IS_CE_VIDEO) \
@@ -229,14 +235,16 @@

 #define V4L2_DV_BT_CEA_4096X2160P25 { \
 	.type = V4L2_DV_BT_656_1120, \
-	V4L2_INIT_BT_TIMINGS(4096, 2160, 0, V4L2_DV_HSYNC_POS_POL, \
+	V4L2_INIT_BT_TIMINGS(4096, 2160, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
 		297000000, 968, 88, 128, 8, 10, 72, 0, 0, 0, \
 		V4L2_DV_BT_STD_CEA861, V4L2_DV_FL_IS_CE_VIDEO) \
 }

 #define V4L2_DV_BT_CEA_4096X2160P30 { \
 	.type = V4L2_DV_BT_656_1120, \
-	V4L2_INIT_BT_TIMINGS(4096, 2160, 0, V4L2_DV_HSYNC_POS_POL, \
+	V4L2_INIT_BT_TIMINGS(4096, 2160, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
 		297000000, 88, 88, 128, 8, 10, 72, 0, 0, 0, \
 		V4L2_DV_BT_STD_CEA861, \
 		V4L2_DV_FL_CAN_REDUCE_FPS | V4L2_DV_FL_IS_CE_VIDEO) \
@@ -244,14 +252,16 @@

 #define V4L2_DV_BT_CEA_4096X2160P50 { \
 	.type = V4L2_DV_BT_656_1120, \
-	V4L2_INIT_BT_TIMINGS(4096, 2160, 0, V4L2_DV_HSYNC_POS_POL, \
+	V4L2_INIT_BT_TIMINGS(4096, 2160, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
 		594000000, 968, 88, 128, 8, 10, 72, 0, 0, 0, \
 		V4L2_DV_BT_STD_CEA861, V4L2_DV_FL_IS_CE_VIDEO) \
 }

 #define V4L2_DV_BT_CEA_4096X2160P60 { \
 	.type = V4L2_DV_BT_656_1120, \
-	V4L2_INIT_BT_TIMINGS(4096, 2160, 0, V4L2_DV_HSYNC_POS_POL, \
+	V4L2_INIT_BT_TIMINGS(4096, 2160, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
 		594000000, 88, 88, 128, 8, 10, 72, 0, 0, 0, \
 		V4L2_DV_BT_STD_CEA861, \
 		V4L2_DV_FL_CAN_REDUCE_FPS | V4L2_DV_FL_IS_CE_VIDEO) \
