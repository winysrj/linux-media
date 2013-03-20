Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3323 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756125Ab3CTSjO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Mar 2013 14:39:14 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Janne Grunau <j@jannau.net>, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 02/11] v4l2-dv-timings.h: add 480i59.94 and 576i50 CEA-861-E timings.
Date: Wed, 20 Mar 2013 19:38:53 +0100
Message-Id: <1363804742-5355-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1363804742-5355-1-git-send-email-hverkuil@xs4all.nl>
References: <1363804742-5355-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

These formats are supported by the HDPVR, but they were missing in the list.
Note that these formats are different from the common PAL/NTSC/SECAM formats
since all color channels are transmitted separately and so there is no PAL
or NTSC or SECAM color encoding involved.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/uapi/linux/v4l2-dv-timings.h |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/include/uapi/linux/v4l2-dv-timings.h b/include/uapi/linux/v4l2-dv-timings.h
index 9ef8172..4e0c58d 100644
--- a/include/uapi/linux/v4l2-dv-timings.h
+++ b/include/uapi/linux/v4l2-dv-timings.h
@@ -42,6 +42,15 @@
 		V4L2_DV_BT_STD_DMT | V4L2_DV_BT_STD_CEA861, 0) \
 }
 
+/* Note: these are the nominal timings, for HDMI links this format is typically
+ * double-clocked to meet the minimum pixelclock requirements.  */
+#define V4L2_DV_BT_CEA_720X480I59_94 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(720, 480, 1, 0, \
+		13500000, 19, 62, 57, 4, 3, 15, 4, 3, 16, \
+		V4L2_DV_BT_STD_CEA861, V4L2_DV_FL_HALF_LINE) \
+}
+
 #define V4L2_DV_BT_CEA_720X480P59_94 { \
 	.type = V4L2_DV_BT_656_1120, \
 	V4L2_INIT_BT_TIMINGS(720, 480, 0, 0, \
@@ -49,6 +58,15 @@
 		V4L2_DV_BT_STD_CEA861, 0) \
 }
 
+/* Note: these are the nominal timings, for HDMI links this format is typically
+ * double-clocked to meet the minimum pixelclock requirements.  */
+#define V4L2_DV_BT_CEA_720X576I50 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(720, 576, 1, 0, \
+		13500000, 12, 63, 69, 2, 3, 19, 2, 3, 20, \
+		V4L2_DV_BT_STD_CEA861, V4L2_DV_FL_HALF_LINE) \
+}
+
 #define V4L2_DV_BT_CEA_720X576P50 { \
 	.type = V4L2_DV_BT_656_1120, \
 	V4L2_INIT_BT_TIMINGS(720, 576, 0, 0, \
-- 
1.7.10.4

