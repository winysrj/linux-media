Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:30756 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031941Ab2COQyx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Mar 2012 12:54:53 -0400
Received: from euspt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M0X009O6QZ6NE@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 15 Mar 2012 16:54:42 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M0X00HGVQZ35S@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 15 Mar 2012 16:54:40 +0000 (GMT)
Date: Thu, 15 Mar 2012 17:54:25 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC 11/23] m5mols: Convert macros to inline functions
In-reply-to: <1331830477-12146-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com
Message-id: <1331830477-12146-12-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1331830477-12146-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make to_sd and to_m5mols macros static inline functions
for better type safety.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/m5mols/m5mols.h |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/m5mols/m5mols.h b/drivers/media/video/m5mols/m5mols.h
index 35a3949..da4381f 100644
--- a/drivers/media/video/m5mols/m5mols.h
+++ b/drivers/media/video/m5mols/m5mols.h
@@ -21,11 +21,6 @@
 
 extern int m5mols_debug;
 
-#define to_m5mols(__sd)	container_of(__sd, struct m5mols_info, sd)
-
-#define to_sd(__ctrl) \
-	(&container_of(__ctrl->handler, struct m5mols_info, handle)->sd)
-
 enum m5mols_restype {
 	M5MOLS_RESTYPE_MONITOR,
 	M5MOLS_RESTYPE_CAPTURE,
@@ -296,4 +291,16 @@ int m5mols_set_ctrl(struct v4l2_ctrl *ctrl);
 int m5mols_update_fw(struct v4l2_subdev *sd,
 		     int (*set_power)(struct m5mols_info *, bool));
 
+static inline struct m5mols_info *to_m5mols(struct v4l2_subdev *subdev)
+{
+	return container_of(subdev, struct m5mols_info, sd);
+}
+
+static inline struct v4l2_subdev *to_sd(struct v4l2_ctrl *ctrl)
+{
+	struct m5mols_info *info = container_of(ctrl->handler,
+						struct m5mols_info, handle);
+	return &info->sd;
+}
+
 #endif	/* M5MOLS_H */
-- 
1.7.9.2

