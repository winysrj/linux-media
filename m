Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:54972 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758861Ab2EJKbP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 May 2012 06:31:15 -0400
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M3S005EIYJLKG@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 May 2012 11:30:57 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M3S00DB5YJQ3L@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 May 2012 11:31:03 +0100 (BST)
Date: Thu, 10 May 2012 12:30:53 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 18/23] m5mols: Add exposure bias control
In-reply-to: <1336645858-30366-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1336645858-30366-19-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1336645858-30366-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add integer menu control for exposure bias. The control value range is
-2.0 EV to +2.0 EV, in 0.5 EV steps.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/m5mols/m5mols.h          |    4 +++-
 drivers/media/video/m5mols/m5mols_controls.c |   24 ++++++++++++++++++++++--
 2 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/m5mols/m5mols.h b/drivers/media/video/m5mols/m5mols.h
index fa1f2c1..03421fc 100644
--- a/drivers/media/video/m5mols/m5mols.h
+++ b/drivers/media/video/m5mols/m5mols.h
@@ -161,6 +161,7 @@ struct m5mols_version {
  * @flags: state variable for the interrupt handler
  * @handle: control handler
  * @auto_exposure: auto/manual exposure control
+ * @exposure_bias: exposure compensation control
  * @exposure: manual exposure control
  * @auto_iso: auto/manual ISO sensitivity control
  * @iso: manual ISO sensitivity control
@@ -191,8 +192,9 @@ struct m5mols_info {
 
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
index 1ab21f0..7978363 100644
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
@@ -447,6 +455,12 @@ static const s64 iso_qmenu[] = {
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
@@ -467,6 +481,7 @@ int m5mols_init_controls(struct v4l2_subdev *sd)
 			&m5mols_ctrl_ops, V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE,
 			9, ~0x3fe, V4L2_WHITE_BALANCE_AUTO);
 
+	/* Exposure control cluster */
 	info->auto_exposure = v4l2_ctrl_new_std_menu(&info->handle,
 			&m5mols_ctrl_ops, V4L2_CID_EXPOSURE_AUTO,
 			1, ~0x03, V4L2_EXPOSURE_AUTO);
@@ -475,6 +490,12 @@ int m5mols_init_controls(struct v4l2_subdev *sd)
 			&m5mols_ctrl_ops, V4L2_CID_EXPOSURE,
 			0, exposure_max, 1, exposure_max / 2);
 
+	info->exposure_bias = v4l2_ctrl_new_int_menu(&info->handle,
+			&m5mols_ctrl_ops, V4L2_CID_AUTO_EXPOSURE_BIAS,
+			ARRAY_SIZE(ev_bias_qmenu) - 1,
+			ARRAY_SIZE(ev_bias_qmenu)/2 - 1,
+			ev_bias_qmenu);
+
 	/* ISO control cluster */
 	info->auto_iso = v4l2_ctrl_new_std_menu(&info->handle, &m5mols_ctrl_ops,
 			V4L2_CID_ISO_SENSITIVITY_AUTO, 1, ~0x03, 1);
@@ -499,8 +520,7 @@ int m5mols_init_controls(struct v4l2_subdev *sd)
 		return ret;
 	}
 
-	v4l2_ctrl_auto_cluster(2, &info->auto_exposure, 1, false);
-
+	v4l2_ctrl_auto_cluster(3, &info->auto_exposure, 1, false);
 	info->auto_iso->flags |= V4L2_CTRL_FLAG_VOLATILE |
 				V4L2_CTRL_FLAG_UPDATE;
 	v4l2_ctrl_auto_cluster(2, &info->auto_iso, 0, false);
-- 
1.7.10

