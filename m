Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2338 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963AbaAaNc3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jan 2014 08:32:29 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 1/2] v4l2-dv-timings.h: add new 4K DMT resolutions.
Date: Fri, 31 Jan 2014 14:32:15 +0100
Message-Id: <1391175136-27875-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1391175136-27875-1-git-send-email-hverkuil@xs4all.nl>
References: <1391175136-27875-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/uapi/linux/v4l2-dv-timings.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/include/uapi/linux/v4l2-dv-timings.h b/include/uapi/linux/v4l2-dv-timings.h
index be709fe..b6a5fe0 100644
--- a/include/uapi/linux/v4l2-dv-timings.h
+++ b/include/uapi/linux/v4l2-dv-timings.h
@@ -823,4 +823,21 @@
 		V4L2_DV_FL_REDUCED_BLANKING) \
 }
 
+/* 4K resolutions */
+#define V4L2_DV_BT_DMT_4096X2160P60_RB { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(4096, 2160, 0, V4L2_DV_HSYNC_POS_POL, \
+		556744000, 8, 32, 40, 48, 8, 6, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT | V4L2_DV_BT_STD_CVT, \
+		V4L2_DV_FL_REDUCED_BLANKING) \
+}
+
+#define V4L2_DV_BT_DMT_4096X2160P59_94_RB { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(4096, 2160, 0, V4L2_DV_HSYNC_POS_POL, \
+		556188000, 8, 32, 40, 48, 8, 6, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT | V4L2_DV_BT_STD_CVT, \
+		V4L2_DV_FL_REDUCED_BLANKING) \
+}
+
 #endif
-- 
1.8.5.2

