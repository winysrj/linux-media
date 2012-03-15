Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:30616 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031961Ab2COQyu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Mar 2012 12:54:50 -0400
Received: from euspt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M0X000L7QYZW4@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 15 Mar 2012 16:54:35 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M0X00177QZ4YS@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 15 Mar 2012 16:54:41 +0000 (GMT)
Date: Thu, 15 Mar 2012 17:54:28 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC 14/23] m5mols: Add ISO controls
In-reply-to: <1331830477-12146-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com
Message-id: <1331830477-12146-15-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1331830477-12146-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/m5mols/m5mols.h          |    5 +++
 drivers/media/video/m5mols/m5mols_controls.c |   51 ++++++++++++++++++++++++++
 2 files changed, 56 insertions(+)

diff --git a/drivers/media/video/m5mols/m5mols.h b/drivers/media/video/m5mols/m5mols.h
index cf5405b..475a7be 100644
--- a/drivers/media/video/m5mols/m5mols.h
+++ b/drivers/media/video/m5mols/m5mols.h
@@ -193,6 +193,11 @@ struct m5mols_info {
 		struct v4l2_ctrl *auto_exposure;
 		struct v4l2_ctrl *exposure;
 	};
+	struct {
+		/* iso/auto iso cluster */
+		struct v4l2_ctrl *auto_iso;
+		struct v4l2_ctrl *iso;
+	};
 
 	struct v4l2_ctrl *autowb;
 	struct v4l2_ctrl *colorfx;
diff --git a/drivers/media/video/m5mols/m5mols_controls.c b/drivers/media/video/m5mols/m5mols_controls.c
index cb94ec9..f335f9c 100644
--- a/drivers/media/video/m5mols/m5mols_controls.c
+++ b/drivers/media/video/m5mols/m5mols_controls.c
@@ -319,6 +319,35 @@ static int m5mols_set_color_effect(struct m5mols_info *info, int val)
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
+
+	if (!info->isp_ready)
+		return -EBUSY;
+
+	switch (ctrl->id) {
+	case V4L2_CID_ISO_SENSITIVITY_AUTO:
+		ret = m5mols_read_u8(sd, AE_ISO, &status);
+		if (ret == 0)
+			ctrl->val = !status;
+		break;
+	}
+
+	return ret;
+}
+
 static int m5mols_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	unsigned int ctrl_mode = m5mols_get_ctrl_mode(ctrl);
@@ -354,6 +383,10 @@ static int m5mols_s_ctrl(struct v4l2_ctrl *ctrl)
 		ret = m5mols_set_exposure(info, ctrl->val);
 		break;
 
+	case V4L2_CID_ISO_SENSITIVITY:
+		ret = m5mols_set_iso(info, ctrl->val);
+		break;
+
 	case V4L2_CID_AUTO_WHITE_BALANCE:
 		ret = m5mols_set_white_balance(info, ctrl->val);
 		break;
@@ -374,9 +407,16 @@ static int m5mols_s_ctrl(struct v4l2_ctrl *ctrl)
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
@@ -406,6 +446,14 @@ int m5mols_init_controls(struct v4l2_subdev *sd)
 			&m5mols_ctrl_ops, V4L2_CID_EXPOSURE,
 			0, exposure_max, 1, exposure_max / 2);
 
+	/* ISO control cluster */
+	info->auto_iso = v4l2_ctrl_new_std(&info->handle, &m5mols_ctrl_ops,
+			V4L2_CID_ISO_SENSITIVITY_AUTO, 0, 1, 1, 1);
+
+	info->iso = v4l2_ctrl_new_std_int_menu(&info->handle, &m5mols_ctrl_ops,
+			V4L2_CID_ISO_SENSITIVITY, ARRAY_SIZE(iso_qmenu) - 1,
+			ARRAY_SIZE(iso_qmenu)/2 - 1, iso_qmenu);
+
 	info->saturation = v4l2_ctrl_new_std(&info->handle, &m5mols_ctrl_ops,
 			V4L2_CID_SATURATION, 1, 5, 1, 3);
 
@@ -424,6 +472,9 @@ int m5mols_init_controls(struct v4l2_subdev *sd)
 	}
 
 	v4l2_ctrl_auto_cluster(2, &info->auto_exposure, 1, false);
+	info->auto_iso->flags |= V4L2_CTRL_FLAG_VOLATILE |
+				V4L2_CTRL_FLAG_UPDATE;
+	v4l2_ctrl_auto_cluster(2, &info->auto_iso, 0, false);
 	sd->ctrl_handler = &info->handle;
 
 	return 0;
-- 
1.7.9.2

