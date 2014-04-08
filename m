Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1113 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756445AbaDHIJI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Apr 2014 04:09:08 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/2] v4l2-dv-timings.h: add CEA-861-F 4K timings
Date: Tue,  8 Apr 2014 10:07:35 +0200
Message-Id: <3f4a49ed4bac96ac5bd05eb733a7d28fa37aee59.1396944189.git.hans.verkuil@cisco.com>
In-Reply-To: <1396944456-20008-1-git-send-email-hverkuil@xs4all.nl>
References: <1396944456-20008-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add the CEA-861-F timings for 3840x2160p24/25/30/50/60 and
4096x2160p24/25/30/50/60.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/uapi/linux/v4l2-dv-timings.h | 70 ++++++++++++++++++++++++++++++++++++
 1 file changed, 70 insertions(+)

diff --git a/include/uapi/linux/v4l2-dv-timings.h b/include/uapi/linux/v4l2-dv-timings.h
index b6a5fe0..6c8f159 100644
--- a/include/uapi/linux/v4l2-dv-timings.h
+++ b/include/uapi/linux/v4l2-dv-timings.h
@@ -173,6 +173,76 @@
 		V4L2_DV_FL_CAN_REDUCE_FPS) \
 }
 
+#define V4L2_DV_BT_CEA_3840X2160P24 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(3840, 2160, 0, V4L2_DV_HSYNC_POS_POL, \
+		297000000, 1276, 88, 296, 8, 10, 72, 0, 0, 0, \
+		V4L2_DV_BT_STD_CEA861, V4L2_DV_FL_CAN_REDUCE_FPS) \
+}
+
+#define V4L2_DV_BT_CEA_3840X2160P25 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(3840, 2160, 0, V4L2_DV_HSYNC_POS_POL, \
+		297000000, 1056, 88, 296, 8, 10, 72, 0, 0, 0, \
+		V4L2_DV_BT_STD_CEA861, 0) \
+}
+
+#define V4L2_DV_BT_CEA_3840X2160P30 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(3840, 2160, 0, V4L2_DV_HSYNC_POS_POL, \
+		297000000, 176, 88, 296, 8, 10, 72, 0, 0, 0, \
+		V4L2_DV_BT_STD_CEA861, V4L2_DV_FL_CAN_REDUCE_FPS) \
+}
+
+#define V4L2_DV_BT_CEA_3840X2160P50 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(3840, 2160, 0, V4L2_DV_HSYNC_POS_POL, \
+		594000000, 1056, 88, 296, 8, 10, 72, 0, 0, 0, \
+		V4L2_DV_BT_STD_CEA861, 0) \
+}
+
+#define V4L2_DV_BT_CEA_3840X2160P60 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(3840, 2160, 0, V4L2_DV_HSYNC_POS_POL, \
+		594000000, 176, 88, 296, 8, 10, 72, 0, 0, 0, \
+		V4L2_DV_BT_STD_CEA861, V4L2_DV_FL_CAN_REDUCE_FPS) \
+}
+
+#define V4L2_DV_BT_CEA_4096X2160P24 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(4096, 2160, 0, V4L2_DV_HSYNC_POS_POL, \
+		297000000, 1020, 88, 296, 8, 10, 72, 0, 0, 0, \
+		V4L2_DV_BT_STD_CEA861, V4L2_DV_FL_CAN_REDUCE_FPS) \
+}
+
+#define V4L2_DV_BT_CEA_4096X2160P25 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(4096, 2160, 0, V4L2_DV_HSYNC_POS_POL, \
+		297000000, 968, 88, 128, 8, 10, 72, 0, 0, 0, \
+		V4L2_DV_BT_STD_CEA861, 0) \
+}
+
+#define V4L2_DV_BT_CEA_4096X2160P30 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(4096, 2160, 0, V4L2_DV_HSYNC_POS_POL, \
+		297000000, 88, 88, 128, 8, 10, 72, 0, 0, 0, \
+		V4L2_DV_BT_STD_CEA861, V4L2_DV_FL_CAN_REDUCE_FPS) \
+}
+
+#define V4L2_DV_BT_CEA_4096X2160P50 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(4096, 2160, 0, V4L2_DV_HSYNC_POS_POL, \
+		594000000, 968, 88, 128, 8, 10, 72, 0, 0, 0, \
+		V4L2_DV_BT_STD_CEA861, 0) \
+}
+
+#define V4L2_DV_BT_CEA_4096X2160P60 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(4096, 2160, 0, V4L2_DV_HSYNC_POS_POL, \
+		594000000, 88, 88, 128, 8, 10, 72, 0, 0, 0, \
+		V4L2_DV_BT_STD_CEA861, V4L2_DV_FL_CAN_REDUCE_FPS) \
+}
+
 
 /* VESA Discrete Monitor Timings as per version 1.0, revision 12 */
 
-- 
1.8.4.rc3

