Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:54972 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758827Ab2EJKbN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 May 2012 06:31:13 -0400
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M3S005EIYJLKG@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 May 2012 11:30:57 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M3S00DF6YJQCT@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 May 2012 11:31:03 +0100 (BST)
Date: Thu, 10 May 2012 12:30:51 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 16/23] m5mols: Add ISO sensitivity controls
In-reply-to: <1336645858-30366-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1336645858-30366-17-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1336645858-30366-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add controls for manual/auto ISO sensitivity.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/m5mols/m5mols.h          |    7 ++++
 drivers/media/video/m5mols/m5mols_controls.c |   56 ++++++++++++++++++++++++++
 2 files changed, 63 insertions(+)

diff --git a/drivers/media/video/m5mols/m5mols.h b/drivers/media/video/m5mols/m5mols.h
index 87684c4..598bb0f 100644
--- a/drivers/media/video/m5mols/m5mols.h
+++ b/drivers/media/video/m5mols/m5mols.h
@@ -162,6 +162,8 @@ struct m5mols_version {
  * @handle: control handler
  * @auto_exposure: auto/manual exposure control
  * @exposure: manual exposure control
+ * @auto_iso: auto/manual ISO sensitivity control
+ * @iso: manual ISO sensitivity control
  * @autowb: Auto White Balance control
  * @colorfx: color effect control
  * @saturation: saturation control
@@ -193,6 +195,11 @@ struct m5mols_info {
 		struct v4l2_ctrl *auto_exposure;
 		struct v4l2_ctrl *exposure;
 	};
+	struct {
+		/* iso/auto iso cluster */
+		struct v4l2_ctrl *auto_iso;
+		struct v4l2_ctrl *iso;
+	};
 
 	struct v4l2_ctrl *auto_wb;
 	struct v4l2_ctrl *colorfx;
diff --git a/drivers/media/video/m5mols/m5mols_controls.c b/drivers/media/video/m5mols/m5mols_controls.c
index 4776601..f1c8850 100644
--- a/drivers/media/video/m5mols/m5mols_controls.c
+++ b/drivers/media/video/m5mols/m5mols_controls.c
@@ -319,6 +319,39 @@ static int m5mols_set_color_effect(struct m5mols_info *info, int val)
 	return ret;
 }
 
+static int m5mols_set_iso(struct m5mols_info *info, int auto_iso)
+{
+	u32 iso = auto_iso ? 0 : info->iso->val + 1;
+
+	return m5mols_write(&info->sd, AE_ISO, iso);
+}
+
+static int m5mols_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct v4l2_subdev *sd = to_sd(ctrl);
+	struct m5mols_info *info = to_m5mols(sd);
+	int ret = 0;
+	u8 status;
+
+	v4l2_dbg(1, m5mols_debug, sd, "%s: ctrl: %s (%d)\n",
+		 __func__, ctrl->name, info->isp_ready);
+
+	if (!info->isp_ready)
+		return -EBUSY;
+
+	switch (ctrl->id) {
+	case V4L2_CID_ISO_SENSITIVITY_AUTO:
+		ret = m5mols_read_u8(sd, AE_ISO, &status);
+		if (ret == 0)
+			ctrl->val = !status;
+		if (status != REG_ISO_AUTO)
+			info->iso->val = status - 1;
+		break;
+	}
+
+	return ret;
+}
+
 static int m5mols_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	unsigned int ctrl_mode = m5mols_get_ctrl_mode(ctrl);
@@ -354,6 +387,10 @@ static int m5mols_s_ctrl(struct v4l2_ctrl *ctrl)
 		ret = m5mols_set_exposure(info, ctrl->val);
 		break;
 
+	case V4L2_CID_ISO_SENSITIVITY:
+		ret = m5mols_set_iso(info, ctrl->val);
+		break;
+
 	case V4L2_CID_AUTO_WHITE_BALANCE:
 		ret = m5mols_set_white_balance(info, ctrl->val);
 		break;
@@ -374,9 +411,16 @@ static int m5mols_s_ctrl(struct v4l2_ctrl *ctrl)
 }
 
 static const struct v4l2_ctrl_ops m5mols_ctrl_ops = {
+	.g_volatile_ctrl	= m5mols_g_volatile_ctrl,
 	.s_ctrl			= m5mols_s_ctrl,
 };
 
+/* Supported manual ISO values */
+static const s64 iso_qmenu[] = {
+	/* AE_ISO: 0x01...0x07 */
+	50, 100, 200, 400, 800, 1600, 3200
+};
+
 int m5mols_init_controls(struct v4l2_subdev *sd)
 {
 	struct m5mols_info *info = to_m5mols(sd);
@@ -404,6 +448,14 @@ int m5mols_init_controls(struct v4l2_subdev *sd)
 			&m5mols_ctrl_ops, V4L2_CID_EXPOSURE,
 			0, exposure_max, 1, exposure_max / 2);
 
+	/* ISO control cluster */
+	info->auto_iso = v4l2_ctrl_new_std_menu(&info->handle, &m5mols_ctrl_ops,
+			V4L2_CID_ISO_SENSITIVITY_AUTO, 1, ~0x03, 1);
+
+	info->iso = v4l2_ctrl_new_int_menu(&info->handle, &m5mols_ctrl_ops,
+			V4L2_CID_ISO_SENSITIVITY, ARRAY_SIZE(iso_qmenu) - 1,
+			ARRAY_SIZE(iso_qmenu)/2 - 1, iso_qmenu);
+
 	info->saturation = v4l2_ctrl_new_std(&info->handle, &m5mols_ctrl_ops,
 			V4L2_CID_SATURATION, 1, 5, 1, 3);
 
@@ -422,6 +474,10 @@ int m5mols_init_controls(struct v4l2_subdev *sd)
 
 	v4l2_ctrl_auto_cluster(2, &info->auto_exposure, 1, false);
 
+	info->auto_iso->flags |= V4L2_CTRL_FLAG_VOLATILE |
+				V4L2_CTRL_FLAG_UPDATE;
+	v4l2_ctrl_auto_cluster(2, &info->auto_iso, 0, false);
+
 	m5mols_set_ctrl_mode(info->auto_exposure, REG_PARAMETER);
 	m5mols_set_ctrl_mode(info->auto_wb, REG_PARAMETER);
 	m5mols_set_ctrl_mode(info->colorfx, REG_MONITOR);
-- 
1.7.10

