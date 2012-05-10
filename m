Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:35963 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758424Ab2EJKbM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 May 2012 06:31:12 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M3S008ZYYK5CW40@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 May 2012 11:31:17 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M3S00DOCYJS9S@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 May 2012 11:31:05 +0100 (BST)
Date: Thu, 10 May 2012 12:30:50 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 15/23] m5mols: Use proper sensor mode for the controls
In-reply-to: <1336645858-30366-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1336645858-30366-16-git-send-email-s.nawrocki@samsung.com>
References: <1336645858-30366-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The parameters corresponding to the V4L controls can be reconfigured
only in associated M-5MOLS operation mode. Use struct v4l2_ctrl
priv field to assign the working mode to the controls which can be
modified only in certain conditions.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/m5mols/m5mols.h          |   11 ++++++++++
 drivers/media/video/m5mols/m5mols_controls.c |   28 ++++++++++++++++++--------
 2 files changed, 31 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/m5mols/m5mols.h b/drivers/media/video/m5mols/m5mols.h
index ed75bbe..87684c4 100644
--- a/drivers/media/video/m5mols/m5mols.h
+++ b/drivers/media/video/m5mols/m5mols.h
@@ -305,4 +305,15 @@ static inline struct v4l2_subdev *to_sd(struct v4l2_ctrl *ctrl)
 	return &info->sd;
 }
 
+static inline void m5mols_set_ctrl_mode(struct v4l2_ctrl *ctrl,
+					unsigned int mode)
+{
+	ctrl->priv = (void *)mode;
+}
+
+static inline unsigned int m5mols_get_ctrl_mode(struct v4l2_ctrl *ctrl)
+{
+	return (unsigned int)ctrl->priv;
+}
+
 #endif	/* M5MOLS_H */
diff --git a/drivers/media/video/m5mols/m5mols_controls.c b/drivers/media/video/m5mols/m5mols_controls.c
index 464ec0c..4776601 100644
--- a/drivers/media/video/m5mols/m5mols_controls.c
+++ b/drivers/media/video/m5mols/m5mols_controls.c
@@ -321,10 +321,11 @@ static int m5mols_set_color_effect(struct m5mols_info *info, int val)
 
 static int m5mols_s_ctrl(struct v4l2_ctrl *ctrl)
 {
+	unsigned int ctrl_mode = m5mols_get_ctrl_mode(ctrl);
 	struct v4l2_subdev *sd = to_sd(ctrl);
 	struct m5mols_info *info = to_m5mols(sd);
-	int ispstate = info->mode;
-	int ret;
+	int last_mode = info->mode;
+	int ret = 0;
 
 	/*
 	 * If needed, defer restoring the controls until
@@ -335,9 +336,14 @@ static int m5mols_s_ctrl(struct v4l2_ctrl *ctrl)
 		return 0;
 	}
 
-	ret = m5mols_mode(info, REG_PARAMETER);
-	if (ret < 0)
-		return ret;
+	v4l2_dbg(1, m5mols_debug, sd, "%s: %s, val: %d, priv: %#x\n",
+		 __func__, ctrl->name, ctrl->val, (int)ctrl->priv);
+
+	if (ctrl_mode && ctrl_mode != info->mode) {
+		ret = m5mols_set_mode(info, ctrl_mode);
+		if (ret < 0)
+			return ret;
+	}
 
 	switch (ctrl->id) {
 	case V4L2_CID_ZOOM_ABSOLUTE:
@@ -360,10 +366,11 @@ static int m5mols_s_ctrl(struct v4l2_ctrl *ctrl)
 		ret = m5mols_set_color_effect(info, ctrl->val);
 		break;
 	}
-	if (ret < 0)
-		return ret;
 
-	return m5mols_mode(info, ispstate);
+	if (ret == 0 && info->mode != last_mode)
+		ret = m5mols_set_mode(info, last_mode);
+
+	return ret;
 }
 
 static const struct v4l2_ctrl_ops m5mols_ctrl_ops = {
@@ -414,6 +421,11 @@ int m5mols_init_controls(struct v4l2_subdev *sd)
 	}
 
 	v4l2_ctrl_auto_cluster(2, &info->auto_exposure, 1, false);
+
+	m5mols_set_ctrl_mode(info->auto_exposure, REG_PARAMETER);
+	m5mols_set_ctrl_mode(info->auto_wb, REG_PARAMETER);
+	m5mols_set_ctrl_mode(info->colorfx, REG_MONITOR);
+
 	sd->ctrl_handler = &info->handle;
 
 	return 0;
-- 
1.7.10

