Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:58757 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752317AbcEBIL5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 2 May 2016 04:11:57 -0400
To: stable@vger.kernel.org
Cc: linux-media <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] v4l2-dv-timings.h: fix polarity for 4k formats
Message-ID: <57270BC5.2010709@xs4all.nl>
Date: Mon, 2 May 2016 10:11:49 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Backport to 3.16-4.0 of mainline commit 3020ca711871fdaf0c15c8bab677a6bc302e28fe

The VSync polarity was negative instead of positive for the 4k CEA formats.
I probably copy-and-pasted these from the DMT 4k format, which does have a
negative VSync polarity.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Martin Bugge <marbugge@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 include/uapi/linux/v4l2-dv-timings.h | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

--- linux-4.0/include/uapi/linux/v4l2-dv-timings.h.orig	2015-04-13 00:12:50.000000000 +0200
+++ linux-4.0/include/uapi/linux/v4l2-dv-timings.h	2016-05-02 10:04:06.594531813 +0200
@@ -175,70 +175,80 @@

 #define V4L2_DV_BT_CEA_3840X2160P24 { \
 	.type = V4L2_DV_BT_656_1120, \
-	V4L2_INIT_BT_TIMINGS(3840, 2160, 0, V4L2_DV_HSYNC_POS_POL, \
+	V4L2_INIT_BT_TIMINGS(3840, 2160, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
 		297000000, 1276, 88, 296, 8, 10, 72, 0, 0, 0, \
 		V4L2_DV_BT_STD_CEA861, V4L2_DV_FL_CAN_REDUCE_FPS) \
 }

 #define V4L2_DV_BT_CEA_3840X2160P25 { \
 	.type = V4L2_DV_BT_656_1120, \
-	V4L2_INIT_BT_TIMINGS(3840, 2160, 0, V4L2_DV_HSYNC_POS_POL, \
+	V4L2_INIT_BT_TIMINGS(3840, 2160, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
 		297000000, 1056, 88, 296, 8, 10, 72, 0, 0, 0, \
 		V4L2_DV_BT_STD_CEA861, 0) \
 }

 #define V4L2_DV_BT_CEA_3840X2160P30 { \
 	.type = V4L2_DV_BT_656_1120, \
-	V4L2_INIT_BT_TIMINGS(3840, 2160, 0, V4L2_DV_HSYNC_POS_POL, \
+	V4L2_INIT_BT_TIMINGS(3840, 2160, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
 		297000000, 176, 88, 296, 8, 10, 72, 0, 0, 0, \
 		V4L2_DV_BT_STD_CEA861, V4L2_DV_FL_CAN_REDUCE_FPS) \
 }

 #define V4L2_DV_BT_CEA_3840X2160P50 { \
 	.type = V4L2_DV_BT_656_1120, \
-	V4L2_INIT_BT_TIMINGS(3840, 2160, 0, V4L2_DV_HSYNC_POS_POL, \
+	V4L2_INIT_BT_TIMINGS(3840, 2160, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
 		594000000, 1056, 88, 296, 8, 10, 72, 0, 0, 0, \
 		V4L2_DV_BT_STD_CEA861, 0) \
 }

 #define V4L2_DV_BT_CEA_3840X2160P60 { \
 	.type = V4L2_DV_BT_656_1120, \
-	V4L2_INIT_BT_TIMINGS(3840, 2160, 0, V4L2_DV_HSYNC_POS_POL, \
+	V4L2_INIT_BT_TIMINGS(3840, 2160, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
 		594000000, 176, 88, 296, 8, 10, 72, 0, 0, 0, \
 		V4L2_DV_BT_STD_CEA861, V4L2_DV_FL_CAN_REDUCE_FPS) \
 }

 #define V4L2_DV_BT_CEA_4096X2160P24 { \
 	.type = V4L2_DV_BT_656_1120, \
-	V4L2_INIT_BT_TIMINGS(4096, 2160, 0, V4L2_DV_HSYNC_POS_POL, \
+	V4L2_INIT_BT_TIMINGS(4096, 2160, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
 		297000000, 1020, 88, 296, 8, 10, 72, 0, 0, 0, \
 		V4L2_DV_BT_STD_CEA861, V4L2_DV_FL_CAN_REDUCE_FPS) \
 }

 #define V4L2_DV_BT_CEA_4096X2160P25 { \
 	.type = V4L2_DV_BT_656_1120, \
-	V4L2_INIT_BT_TIMINGS(4096, 2160, 0, V4L2_DV_HSYNC_POS_POL, \
+	V4L2_INIT_BT_TIMINGS(4096, 2160, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
 		297000000, 968, 88, 128, 8, 10, 72, 0, 0, 0, \
 		V4L2_DV_BT_STD_CEA861, 0) \
 }

 #define V4L2_DV_BT_CEA_4096X2160P30 { \
 	.type = V4L2_DV_BT_656_1120, \
-	V4L2_INIT_BT_TIMINGS(4096, 2160, 0, V4L2_DV_HSYNC_POS_POL, \
+	V4L2_INIT_BT_TIMINGS(4096, 2160, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
 		297000000, 88, 88, 128, 8, 10, 72, 0, 0, 0, \
 		V4L2_DV_BT_STD_CEA861, V4L2_DV_FL_CAN_REDUCE_FPS) \
 }

 #define V4L2_DV_BT_CEA_4096X2160P50 { \
 	.type = V4L2_DV_BT_656_1120, \
-	V4L2_INIT_BT_TIMINGS(4096, 2160, 0, V4L2_DV_HSYNC_POS_POL, \
+	V4L2_INIT_BT_TIMINGS(4096, 2160, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
 		594000000, 968, 88, 128, 8, 10, 72, 0, 0, 0, \
 		V4L2_DV_BT_STD_CEA861, 0) \
 }

 #define V4L2_DV_BT_CEA_4096X2160P60 { \
 	.type = V4L2_DV_BT_656_1120, \
-	V4L2_INIT_BT_TIMINGS(4096, 2160, 0, V4L2_DV_HSYNC_POS_POL, \
+	V4L2_INIT_BT_TIMINGS(4096, 2160, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
 		594000000, 88, 88, 128, 8, 10, 72, 0, 0, 0, \
 		V4L2_DV_BT_STD_CEA861, V4L2_DV_FL_CAN_REDUCE_FPS) \
 }
