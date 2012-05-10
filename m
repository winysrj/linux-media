Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:35963 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340Ab2EJKbG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 May 2012 06:31:06 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M3S008ZYYK5CW40@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 May 2012 11:31:17 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M3S00251YJSNB@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 May 2012 11:31:05 +0100 (BST)
Date: Thu, 10 May 2012 12:30:48 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 13/23] m5mols: Convert macros to inline functions
In-reply-to: <1336645858-30366-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1336645858-30366-14-git-send-email-s.nawrocki@samsung.com>
References: <1336645858-30366-1-git-send-email-s.nawrocki@samsung.com>
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
index 4b021e1..0acc3d6 100644
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
1.7.10

