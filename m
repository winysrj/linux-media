Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:41883 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750808AbcGQJI2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 05:08:28 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/5] v4l2-dv-timings: add VICs and picture aspect ratio
Date: Sun, 17 Jul 2016 11:08:14 +0200
Message-Id: <1468746497-46692-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1468746497-46692-1-git-send-email-hverkuil@xs4all.nl>
References: <1468746497-46692-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add the CEA-861 VIC, the HDMI VIC and the picture aspect ratio information
where applicable.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/uapi/linux/v4l2-dv-timings.h | 97 +++++++++++++++++++++++-------------
 1 file changed, 63 insertions(+), 34 deletions(-)

diff --git a/include/uapi/linux/v4l2-dv-timings.h b/include/uapi/linux/v4l2-dv-timings.h
index 086168e..64c323f 100644
--- a/include/uapi/linux/v4l2-dv-timings.h
+++ b/include/uapi/linux/v4l2-dv-timings.h
@@ -1,7 +1,7 @@
 /*
  * V4L2 DV timings header.
  *
- * Copyright (C) 2012  Hans Verkuil <hans.verkuil@cisco.com>
+ * Copyright (C) 2012-2016  Hans Verkuil <hans.verkuil@cisco.com>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -11,11 +11,6 @@
  * WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
  */
 
 #ifndef _V4L2_DV_TIMINGS_H
@@ -33,13 +28,14 @@
 	.bt = { _width , ## args }
 #endif
 
-/* CEA-861-E timings (i.e. standard HDTV timings) */
+/* CEA-861-F timings (i.e. standard HDTV timings) */
 
 #define V4L2_DV_BT_CEA_640X480P59_94 { \
 	.type = V4L2_DV_BT_656_1120, \
 	V4L2_INIT_BT_TIMINGS(640, 480, 0, 0, \
 		25175000, 16, 96, 48, 10, 2, 33, 0, 0, 0, \
-		V4L2_DV_BT_STD_DMT | V4L2_DV_BT_STD_CEA861, 0) \
+		V4L2_DV_BT_STD_DMT | V4L2_DV_BT_STD_CEA861, \
+		V4L2_DV_FL_HAS_CEA861_VIC, { 0, 0 }, 1) \
 }
 
 /* Note: these are the nominal timings, for HDMI links this format is typically
@@ -49,14 +45,18 @@
 	V4L2_INIT_BT_TIMINGS(720, 480, 1, 0, \
 		13500000, 19, 62, 57, 4, 3, 15, 4, 3, 16, \
 		V4L2_DV_BT_STD_CEA861, \
-		V4L2_DV_FL_HALF_LINE | V4L2_DV_FL_IS_CE_VIDEO) \
+		V4L2_DV_FL_HALF_LINE | V4L2_DV_FL_IS_CE_VIDEO | \
+		V4L2_DV_FL_HAS_PICTURE_ASPECT | V4L2_DV_FL_HAS_CEA861_VIC, \
+		{ 4, 3 }, 6) \
 }
 
 #define V4L2_DV_BT_CEA_720X480P59_94 { \
 	.type = V4L2_DV_BT_656_1120, \
 	V4L2_INIT_BT_TIMINGS(720, 480, 0, 0, \
 		27000000, 16, 62, 60, 9, 6, 30, 0, 0, 0, \
-		V4L2_DV_BT_STD_CEA861, V4L2_DV_FL_IS_CE_VIDEO) \
+		V4L2_DV_BT_STD_CEA861, \
+		V4L2_DV_FL_IS_CE_VIDEO | V4L2_DV_FL_HAS_PICTURE_ASPECT | \
+		V4L2_DV_FL_HAS_CEA861_VIC, { 4, 3 }, 2) \
 }
 
 /* Note: these are the nominal timings, for HDMI links this format is typically
@@ -66,14 +66,18 @@
 	V4L2_INIT_BT_TIMINGS(720, 576, 1, 0, \
 		13500000, 12, 63, 69, 2, 3, 19, 2, 3, 20, \
 		V4L2_DV_BT_STD_CEA861, \
-		V4L2_DV_FL_HALF_LINE | V4L2_DV_FL_IS_CE_VIDEO) \
+		V4L2_DV_FL_HALF_LINE | V4L2_DV_FL_IS_CE_VIDEO | \
+		V4L2_DV_FL_HAS_PICTURE_ASPECT | V4L2_DV_FL_HAS_CEA861_VIC, \
+		{ 4, 3 }, 21) \
 }
 
 #define V4L2_DV_BT_CEA_720X576P50 { \
 	.type = V4L2_DV_BT_656_1120, \
 	V4L2_INIT_BT_TIMINGS(720, 576, 0, 0, \
 		27000000, 12, 64, 68, 5, 5, 39, 0, 0, 0, \
-		V4L2_DV_BT_STD_CEA861, V4L2_DV_FL_IS_CE_VIDEO) \
+		V4L2_DV_BT_STD_CEA861, \
+		V4L2_DV_FL_IS_CE_VIDEO | V4L2_DV_FL_HAS_PICTURE_ASPECT | \
+		V4L2_DV_FL_HAS_CEA861_VIC, { 4, 3 }, 17) \
 }
 
 #define V4L2_DV_BT_CEA_1280X720P24 { \
@@ -82,7 +86,7 @@
 		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
 		59400000, 1760, 40, 220, 5, 5, 20, 0, 0, 0, \
 		V4L2_DV_BT_STD_DMT | V4L2_DV_BT_STD_CEA861, \
-		V4L2_DV_FL_CAN_REDUCE_FPS) \
+		V4L2_DV_FL_CAN_REDUCE_FPS | V4L2_DV_FL_HAS_CEA861_VIC, { 0, 0 }, 60) \
 }
 
 #define V4L2_DV_BT_CEA_1280X720P25 { \
@@ -90,7 +94,8 @@
 	V4L2_INIT_BT_TIMINGS(1280, 720, 0, \
 		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
 		74250000, 2420, 40, 220, 5, 5, 20, 0, 0, 0, \
-		V4L2_DV_BT_STD_CEA861, V4L2_DV_FL_IS_CE_VIDEO) \
+		V4L2_DV_BT_STD_CEA861, \
+		V4L2_DV_FL_IS_CE_VIDEO | V4L2_DV_FL_HAS_CEA861_VIC, { 0, 0 }, 61) \
 }
 
 #define V4L2_DV_BT_CEA_1280X720P30 { \
@@ -99,7 +104,8 @@
 		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
 		74250000, 1760, 40, 220, 5, 5, 20, 0, 0, 0, \
 		V4L2_DV_BT_STD_CEA861, \
-		V4L2_DV_FL_CAN_REDUCE_FPS | V4L2_DV_FL_IS_CE_VIDEO) \
+		V4L2_DV_FL_CAN_REDUCE_FPS | V4L2_DV_FL_IS_CE_VIDEO | \
+		V4L2_DV_FL_HAS_CEA861_VIC, { 0, 0 }, 62) \
 }
 
 #define V4L2_DV_BT_CEA_1280X720P50 { \
@@ -107,7 +113,8 @@
 	V4L2_INIT_BT_TIMINGS(1280, 720, 0, \
 		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
 		74250000, 440, 40, 220, 5, 5, 20, 0, 0, 0, \
-		V4L2_DV_BT_STD_CEA861, V4L2_DV_FL_IS_CE_VIDEO) \
+		V4L2_DV_BT_STD_CEA861, \
+		V4L2_DV_FL_IS_CE_VIDEO | V4L2_DV_FL_HAS_CEA861_VIC, { 0, 0 }, 19) \
 }
 
 #define V4L2_DV_BT_CEA_1280X720P60 { \
@@ -116,7 +123,8 @@
 		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
 		74250000, 110, 40, 220, 5, 5, 20, 0, 0, 0, \
 		V4L2_DV_BT_STD_CEA861, \
-		V4L2_DV_FL_CAN_REDUCE_FPS | V4L2_DV_FL_IS_CE_VIDEO) \
+		V4L2_DV_FL_CAN_REDUCE_FPS | V4L2_DV_FL_IS_CE_VIDEO | \
+		V4L2_DV_FL_HAS_CEA861_VIC, { 0, 0 }, 4) \
 }
 
 #define V4L2_DV_BT_CEA_1920X1080P24 { \
@@ -125,7 +133,8 @@
 		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
 		74250000, 638, 44, 148, 4, 5, 36, 0, 0, 0, \
 		V4L2_DV_BT_STD_CEA861, \
-		V4L2_DV_FL_CAN_REDUCE_FPS | V4L2_DV_FL_IS_CE_VIDEO) \
+		V4L2_DV_FL_CAN_REDUCE_FPS | V4L2_DV_FL_IS_CE_VIDEO | \
+		V4L2_DV_FL_HAS_CEA861_VIC, { 0, 0 }, 32) \
 }
 
 #define V4L2_DV_BT_CEA_1920X1080P25 { \
@@ -133,7 +142,8 @@
 	V4L2_INIT_BT_TIMINGS(1920, 1080, 0, \
 		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
 		74250000, 528, 44, 148, 4, 5, 36, 0, 0, 0, \
-		V4L2_DV_BT_STD_CEA861, V4L2_DV_FL_IS_CE_VIDEO) \
+		V4L2_DV_BT_STD_CEA861, \
+		V4L2_DV_FL_IS_CE_VIDEO | V4L2_DV_FL_HAS_CEA861_VIC, { 0, 0 }, 33) \
 }
 
 #define V4L2_DV_BT_CEA_1920X1080P30 { \
@@ -142,7 +152,8 @@
 		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
 		74250000, 88, 44, 148, 4, 5, 36, 0, 0, 0, \
 		V4L2_DV_BT_STD_CEA861, \
-		V4L2_DV_FL_CAN_REDUCE_FPS | V4L2_DV_FL_IS_CE_VIDEO) \
+		V4L2_DV_FL_CAN_REDUCE_FPS | V4L2_DV_FL_IS_CE_VIDEO | \
+		V4L2_DV_FL_HAS_CEA861_VIC, { 0, 0 }, 34) \
 }
 
 #define V4L2_DV_BT_CEA_1920X1080I50 { \
@@ -151,7 +162,8 @@
 		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
 		74250000, 528, 44, 148, 2, 5, 15, 2, 5, 16, \
 		V4L2_DV_BT_STD_CEA861, \
-		V4L2_DV_FL_HALF_LINE | V4L2_DV_FL_IS_CE_VIDEO) \
+		V4L2_DV_FL_HALF_LINE | V4L2_DV_FL_IS_CE_VIDEO | \
+		V4L2_DV_FL_HAS_CEA861_VIC, { 0, 0 }, 20) \
 }
 
 #define V4L2_DV_BT_CEA_1920X1080P50 { \
@@ -159,7 +171,8 @@
 	V4L2_INIT_BT_TIMINGS(1920, 1080, 0, \
 		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
 		148500000, 528, 44, 148, 4, 5, 36, 0, 0, 0, \
-		V4L2_DV_BT_STD_CEA861, V4L2_DV_FL_IS_CE_VIDEO) \
+		V4L2_DV_BT_STD_CEA861, \
+		V4L2_DV_FL_IS_CE_VIDEO | V4L2_DV_FL_HAS_CEA861_VIC, { 0, 0 }, 31) \
 }
 
 #define V4L2_DV_BT_CEA_1920X1080I60 { \
@@ -169,7 +182,8 @@
 		74250000, 88, 44, 148, 2, 5, 15, 2, 5, 16, \
 		V4L2_DV_BT_STD_CEA861, \
 		V4L2_DV_FL_CAN_REDUCE_FPS | \
-		V4L2_DV_FL_HALF_LINE | V4L2_DV_FL_IS_CE_VIDEO) \
+		V4L2_DV_FL_HALF_LINE | V4L2_DV_FL_IS_CE_VIDEO | \
+		V4L2_DV_FL_HAS_CEA861_VIC, { 0, 0 }, 5) \
 }
 
 #define V4L2_DV_BT_CEA_1920X1080P60 { \
@@ -178,7 +192,8 @@
 		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
 		148500000, 88, 44, 148, 4, 5, 36, 0, 0, 0, \
 		V4L2_DV_BT_STD_DMT | V4L2_DV_BT_STD_CEA861, \
-		V4L2_DV_FL_CAN_REDUCE_FPS | V4L2_DV_FL_IS_CE_VIDEO) \
+		V4L2_DV_FL_CAN_REDUCE_FPS | V4L2_DV_FL_IS_CE_VIDEO | \
+		V4L2_DV_FL_HAS_CEA861_VIC, { 0, 0 }, 16) \
 }
 
 #define V4L2_DV_BT_CEA_3840X2160P24 { \
@@ -187,7 +202,9 @@
 		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
 		297000000, 1276, 88, 296, 8, 10, 72, 0, 0, 0, \
 		V4L2_DV_BT_STD_CEA861, \
-		V4L2_DV_FL_CAN_REDUCE_FPS | V4L2_DV_FL_IS_CE_VIDEO) \
+		V4L2_DV_FL_CAN_REDUCE_FPS | V4L2_DV_FL_IS_CE_VIDEO | \
+		V4L2_DV_FL_HAS_CEA861_VIC | V4L2_DV_FL_HAS_HDMI_VIC, \
+		{ 0, 0 }, 93, 3) \
 }
 
 #define V4L2_DV_BT_CEA_3840X2160P25 { \
@@ -195,7 +212,9 @@
 	V4L2_INIT_BT_TIMINGS(3840, 2160, 0, \
 		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
 		297000000, 1056, 88, 296, 8, 10, 72, 0, 0, 0, \
-		V4L2_DV_BT_STD_CEA861, V4L2_DV_FL_IS_CE_VIDEO) \
+		V4L2_DV_BT_STD_CEA861, \
+		V4L2_DV_FL_IS_CE_VIDEO | V4L2_DV_FL_HAS_CEA861_VIC | \
+		V4L2_DV_FL_HAS_HDMI_VIC, { 0, 0 }, 94, 2) \
 }
 
 #define V4L2_DV_BT_CEA_3840X2160P30 { \
@@ -204,7 +223,9 @@
 		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
 		297000000, 176, 88, 296, 8, 10, 72, 0, 0, 0, \
 		V4L2_DV_BT_STD_CEA861, \
-		V4L2_DV_FL_CAN_REDUCE_FPS | V4L2_DV_FL_IS_CE_VIDEO) \
+		V4L2_DV_FL_CAN_REDUCE_FPS | V4L2_DV_FL_IS_CE_VIDEO | \
+		V4L2_DV_FL_HAS_CEA861_VIC | V4L2_DV_FL_HAS_HDMI_VIC, \
+		{ 0, 0 }, 95, 1) \
 }
 
 #define V4L2_DV_BT_CEA_3840X2160P50 { \
@@ -212,7 +233,8 @@
 	V4L2_INIT_BT_TIMINGS(3840, 2160, 0, \
 		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
 		594000000, 1056, 88, 296, 8, 10, 72, 0, 0, 0, \
-		V4L2_DV_BT_STD_CEA861, V4L2_DV_FL_IS_CE_VIDEO) \
+		V4L2_DV_BT_STD_CEA861, \
+		V4L2_DV_FL_IS_CE_VIDEO | V4L2_DV_FL_HAS_CEA861_VIC, { 0, 0 }, 96) \
 }
 
 #define V4L2_DV_BT_CEA_3840X2160P60 { \
@@ -221,7 +243,8 @@
 		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
 		594000000, 176, 88, 296, 8, 10, 72, 0, 0, 0, \
 		V4L2_DV_BT_STD_CEA861, \
-		V4L2_DV_FL_CAN_REDUCE_FPS | V4L2_DV_FL_IS_CE_VIDEO) \
+		V4L2_DV_FL_CAN_REDUCE_FPS | V4L2_DV_FL_IS_CE_VIDEO | \
+		V4L2_DV_FL_HAS_CEA861_VIC, { 0, 0 }, 97) \
 }
 
 #define V4L2_DV_BT_CEA_4096X2160P24 { \
@@ -230,7 +253,9 @@
 		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
 		297000000, 1020, 88, 296, 8, 10, 72, 0, 0, 0, \
 		V4L2_DV_BT_STD_CEA861, \
-		V4L2_DV_FL_CAN_REDUCE_FPS | V4L2_DV_FL_IS_CE_VIDEO) \
+		V4L2_DV_FL_CAN_REDUCE_FPS | V4L2_DV_FL_IS_CE_VIDEO | \
+		V4L2_DV_FL_HAS_CEA861_VIC | V4L2_DV_FL_HAS_HDMI_VIC, \
+		{ 0, 0 }, 98, 4) \
 }
 
 #define V4L2_DV_BT_CEA_4096X2160P25 { \
@@ -238,7 +263,8 @@
 	V4L2_INIT_BT_TIMINGS(4096, 2160, 0, \
 		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
 		297000000, 968, 88, 128, 8, 10, 72, 0, 0, 0, \
-		V4L2_DV_BT_STD_CEA861, V4L2_DV_FL_IS_CE_VIDEO) \
+		V4L2_DV_BT_STD_CEA861, \
+		V4L2_DV_FL_IS_CE_VIDEO | V4L2_DV_FL_HAS_CEA861_VIC, { 0, 0 }, 99) \
 }
 
 #define V4L2_DV_BT_CEA_4096X2160P30 { \
@@ -247,7 +273,8 @@
 		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
 		297000000, 88, 88, 128, 8, 10, 72, 0, 0, 0, \
 		V4L2_DV_BT_STD_CEA861, \
-		V4L2_DV_FL_CAN_REDUCE_FPS | V4L2_DV_FL_IS_CE_VIDEO) \
+		V4L2_DV_FL_CAN_REDUCE_FPS | V4L2_DV_FL_IS_CE_VIDEO | \
+		V4L2_DV_FL_HAS_CEA861_VIC, { 0, 0 }, 100) \
 }
 
 #define V4L2_DV_BT_CEA_4096X2160P50 { \
@@ -255,7 +282,8 @@
 	V4L2_INIT_BT_TIMINGS(4096, 2160, 0, \
 		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
 		594000000, 968, 88, 128, 8, 10, 72, 0, 0, 0, \
-		V4L2_DV_BT_STD_CEA861, V4L2_DV_FL_IS_CE_VIDEO) \
+		V4L2_DV_BT_STD_CEA861, \
+		V4L2_DV_FL_IS_CE_VIDEO | V4L2_DV_FL_HAS_CEA861_VIC, { 0, 0 }, 101) \
 }
 
 #define V4L2_DV_BT_CEA_4096X2160P60 { \
@@ -264,7 +292,8 @@
 		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
 		594000000, 88, 88, 128, 8, 10, 72, 0, 0, 0, \
 		V4L2_DV_BT_STD_CEA861, \
-		V4L2_DV_FL_CAN_REDUCE_FPS | V4L2_DV_FL_IS_CE_VIDEO) \
+		V4L2_DV_FL_CAN_REDUCE_FPS | V4L2_DV_FL_IS_CE_VIDEO | \
+		V4L2_DV_FL_HAS_CEA861_VIC, { 0, 0 }, 102) \
 }
 
 
-- 
2.8.1

