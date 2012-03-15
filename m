Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:30756 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030966Ab2COQyz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Mar 2012 12:54:55 -0400
Received: from euspt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M0X009O6QZ6NE@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 15 Mar 2012 16:54:42 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M0X0016VQZ3YS@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 15 Mar 2012 16:54:40 +0000 (GMT)
Date: Thu, 15 Mar 2012 17:54:27 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC 13/23] m5mols: Use proper sensor mode for the controls
In-reply-to: <1331830477-12146-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com
Message-id: <1331830477-12146-14-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1331830477-12146-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The parameters corresponding to the V4L controls can be reconfigured
only in associated M-5MOLS operation mode. Use struct v4l2_ctrl
priv field to assign the working mode to the controls which can be
modified only in certain conditions.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/m5mols/m5mols.h          |   11 +++++++++++
 drivers/media/video/m5mols/m5mols_controls.c |   25 +++++++++++++++++--------
 2 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/m5mols/m5mols.h b/drivers/media/video/m5mols/m5mols.h
index 631a0c9..cf5405b 100644
--- a/drivers/media/video/m5mols/m5mols.h
+++ b/drivers/media/video/m5mols/m5mols.h
@@ -305,4 +305,15 @@ static inline struct v4l2_subdev *to_sd(struct v4l2_ctrl *ctrl)
 	return &info->sd;
 }
 
+static inline void m5mols_set_ctrl_mode(struct v4l2_ctrl *ctrl,
+					unsigned int mode)
+{
+	ctrl->priv = (void*)mode;
+}
+
+static inline unsigned int m5mols_get_ctrl_mode(struct v4l2_ctrl *ctrl)
+{
+	return (unsigned int)ctrl->priv;
+}
+
 #endif	/* M5MOLS_H */
diff --git a/drivers/media/video/m5mols/m5mols_controls.c b/drivers/media/video/m5mols/m5mols_controls.c
index f4308a4..cb94ec9 100644
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
+		ret = m5mols_mode(info, ctrl_mode);
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
+		ret = m5mols_mode(info, last_mode);
+
+	return ret;
 }
 
 static const struct v4l2_ctrl_ops m5mols_ctrl_ops = {
@@ -388,10 +395,12 @@ int m5mols_init_controls(struct v4l2_subdev *sd)
 
 	info->auto_wb = v4l2_ctrl_new_std(&info->handle, &m5mols_ctrl_ops,
 			V4L2_CID_AUTO_WHITE_BALANCE, 0, 1, 1, 1);
+	m5mols_set_ctrl_mode(info->auto_wb, REG_PARAMETER);
 
 	info->auto_exposure = v4l2_ctrl_new_std_menu(&info->handle,
 			&m5mols_ctrl_ops, V4L2_CID_EXPOSURE_AUTO,
 			1, ~0x03, V4L2_EXPOSURE_AUTO);
+	m5mols_set_ctrl_mode(info->auto_wb, REG_PARAMETER);
 
 	info->exposure = v4l2_ctrl_new_std(&info->handle,
 			&m5mols_ctrl_ops, V4L2_CID_EXPOSURE,
-- 
1.7.9.2

