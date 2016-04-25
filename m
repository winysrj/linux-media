Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-2.cisco.com ([173.38.203.52]:2778 "EHLO
	aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbcDYJBV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Apr 2016 05:01:21 -0400
From: Martin Bugge <marbugge@cisco.com>
To: linux-media@vger.kernel.org
Cc: Martin Bugge <marbugge@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH] [media] v4l2-dv-timings.h: CEA-861-F 4K timings have positive sync polarities
Date: Mon, 25 Apr 2016 10:51:04 +0200
Message-Id: <1461574264-1321-1-git-send-email-marbugge@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Corrected sync polarities for CEA-861-F timings
3840x2160p24/25/30/50/60 and 4096x2160p24/25/30/50/60.

Cc: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Martin Bugge <marbugge@cisco.com>
---
 include/uapi/linux/v4l2-dv-timings.h | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

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
-- 
2.4.11

