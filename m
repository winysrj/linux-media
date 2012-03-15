Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:64585 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031663Ab2COQyx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Mar 2012 12:54:53 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M0X007YTQZ8PJ00@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 15 Mar 2012 16:54:44 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M0X00178QZ4YS@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 15 Mar 2012 16:54:41 +0000 (GMT)
Date: Thu, 15 Mar 2012 17:54:30 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC 16/23] m5mols: Add exposure bias control
In-reply-to: <1331830477-12146-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com
Message-id: <1331830477-12146-17-git-send-email-s.nawrocki@samsung.com>
References: <1331830477-12146-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add integer menu control for exposure bias. The control value range is
-2.0 EV to +2.0 EV, in 0.5 EV steps.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/m5mols/m5mols.h          |    3 ++-
 drivers/media/video/m5mols/m5mols_controls.c |   23 ++++++++++++++++++++++-
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/m5mols/m5mols.h b/drivers/media/video/m5mols/m5mols.h
index d04443b..87bf690 100644
--- a/drivers/media/video/m5mols/m5mols.h
+++ b/drivers/media/video/m5mols/m5mols.h
@@ -189,8 +189,9 @@ struct m5mols_info {
 
 	struct v4l2_ctrl_handler handle;
 	struct {
-		/* exposure/auto-exposure cluster */
+		/* exposure/exposure bias/auto exposure cluster */
 		struct v4l2_ctrl *auto_exposure;
+		struct v4l2_ctrl *exposure_bias;
 		struct v4l2_ctrl *exposure;
 	};
 	struct {
diff --git a/drivers/media/video/m5mols/m5mols_controls.c b/drivers/media/video/m5mols/m5mols_controls.c
index 98eaeb0..cca31db 100644
--- a/drivers/media/video/m5mols/m5mols_controls.c
+++ b/drivers/media/video/m5mols/m5mols_controls.c
@@ -241,6 +241,11 @@ static int m5mols_set_exposure(struct m5mols_info *info, int exposure)
 		ret = m5mols_write(sd, AE_MODE, REG_AE_ALL);
 		if (ret < 0)
 			return ret;
+
+		v4l2_dbg(1, m5mols_debug, sd, "%s: exposure bias: %#x\n",
+			 __func__, info->exposure_bias->val);
+
+		return m5mols_write(sd, AE_INDEX, info->exposure_bias->val);
 	}
 
 	if (exposure == V4L2_EXPOSURE_MANUAL) {
@@ -251,6 +256,9 @@ static int m5mols_set_exposure(struct m5mols_info *info, int exposure)
 		if (ret == 0)
 			ret = m5mols_write(sd, AE_MAN_GAIN_CAP,
 					   info->exposure->val);
+
+		v4l2_dbg(1, m5mols_debug, sd, "%s: exposure: %#x\n",
+			 __func__, info->exposure->val);
 	}
 
 	return ret;
@@ -431,6 +439,12 @@ static const s64 iso_qmenu[] = {
 	50, 100, 200, 400, 800, 1600, 3200
 };
 
+/* Supported Exposure Bias values, -2.0EV...+2.0EV */
+static const s64 ev_bias_qmenu[] = {
+	/* AE_INDEX: 0x00...0x08 */
+	-2000, -1500, -1000, -500, 0, 500, 1000, 1500, 2000
+};
+
 int m5mols_init_controls(struct v4l2_subdev *sd)
 {
 	struct m5mols_info *info = to_m5mols(sd);
@@ -456,6 +470,7 @@ int m5mols_init_controls(struct v4l2_subdev *sd)
 			&m5mols_ctrl_ops, V4L2_CID_WHITE_BALANCE_PRESET,
 			5, ~0x3e, V4L2_WHITE_BALANCE_PRESET_DAYLIGHT);
 
+	/* Exposure control cluster */
 	info->auto_exposure = v4l2_ctrl_new_std_menu(&info->handle,
 			&m5mols_ctrl_ops, V4L2_CID_EXPOSURE_AUTO,
 			1, ~0x03, V4L2_EXPOSURE_AUTO);
@@ -465,6 +480,12 @@ int m5mols_init_controls(struct v4l2_subdev *sd)
 			&m5mols_ctrl_ops, V4L2_CID_EXPOSURE,
 			0, exposure_max, 1, exposure_max / 2);
 
+	info->exposure_bias = v4l2_ctrl_new_std_int_menu(&info->handle,
+			&m5mols_ctrl_ops, V4L2_CID_AUTO_EXPOSURE_BIAS,
+			ARRAY_SIZE(ev_bias_qmenu) - 1,
+			ARRAY_SIZE(ev_bias_qmenu)/2 - 1,
+			ev_bias_qmenu);
+
 	/* ISO control cluster */
 	info->auto_iso = v4l2_ctrl_new_std(&info->handle, &m5mols_ctrl_ops,
 			V4L2_CID_ISO_SENSITIVITY_AUTO, 0, 1, 1, 1);
@@ -490,7 +511,7 @@ int m5mols_init_controls(struct v4l2_subdev *sd)
 		return ret;
 	}
 
-	v4l2_ctrl_auto_cluster(2, &info->auto_exposure, 1, false);
+	v4l2_ctrl_auto_cluster(3, &info->auto_exposure, 1, false);
 	info->auto_iso->flags |= V4L2_CTRL_FLAG_VOLATILE |
 				V4L2_CTRL_FLAG_UPDATE;
 	v4l2_ctrl_auto_cluster(2, &info->auto_iso, 0, false);
-- 
1.7.9.2

