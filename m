Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:30616 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030346Ab2COQyq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Mar 2012 12:54:46 -0400
Received: from euspt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M0X001FYQYY8A@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 15 Mar 2012 16:54:34 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M0X008JAQZ3T2@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 15 Mar 2012 16:54:40 +0000 (GMT)
Date: Thu, 15 Mar 2012 17:54:26 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC 12/23] m5mols: Refactored controls handling
In-reply-to: <1331830477-12146-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com
Message-id: <1331830477-12146-13-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1331830477-12146-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch is a prerequisite for the new controls addition. It consolidates
the control handling code, which is moved to m5mols_controls.c and
staticized. The controls initialization is reordered to better reflect
the control clusters and make the diffs smaller when new controls are added.
To make the code easier to follow when more controls is added use separate
set function for each control.

Rewrite the image effect registers handling.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/m5mols/m5mols.h          |   10 +-
 drivers/media/video/m5mols/m5mols_controls.c |  224 ++++++++++++++++++++------
 drivers/media/video/m5mols/m5mols_core.c     |   77 +--------
 3 files changed, 180 insertions(+), 131 deletions(-)

diff --git a/drivers/media/video/m5mols/m5mols.h b/drivers/media/video/m5mols/m5mols.h
index da4381f..631a0c9 100644
--- a/drivers/media/video/m5mols/m5mols.h
+++ b/drivers/media/video/m5mols/m5mols.h
@@ -188,10 +188,11 @@ struct m5mols_info {
 	atomic_t irq_done;
 
 	struct v4l2_ctrl_handler handle;
-
-	/* Autoexposure/exposure control cluster */
-	struct v4l2_ctrl *autoexposure;
-	struct v4l2_ctrl *exposure;
+	struct {
+		/* exposure/auto-exposure cluster */
+		struct v4l2_ctrl *auto_exposure;
+		struct v4l2_ctrl *exposure;
+	};
 
 	struct v4l2_ctrl *autowb;
 	struct v4l2_ctrl *colorfx;
@@ -286,6 +287,7 @@ int m5mols_start_capture(struct m5mols_info *info);
 int m5mols_do_scenemode(struct m5mols_info *info, u8 mode);
 int m5mols_lock_3a(struct m5mols_info *info, bool lock);
 int m5mols_set_ctrl(struct v4l2_ctrl *ctrl);
+int m5mols_init_controls(struct v4l2_subdev *sd);
 
 /* The firmware function */
 int m5mols_update_fw(struct v4l2_subdev *sd,
diff --git a/drivers/media/video/m5mols/m5mols_controls.c b/drivers/media/video/m5mols/m5mols_controls.c
index 0730e50..f4308a4 100644
--- a/drivers/media/video/m5mols/m5mols_controls.c
+++ b/drivers/media/video/m5mols/m5mols_controls.c
@@ -227,73 +227,195 @@ int m5mols_lock_3a(struct m5mols_info *info, bool lock)
 	return ret;
 }
 
-/* m5mols_set_ctrl() - The main s_ctrl function called by m5mols_set_ctrl() */
-int m5mols_set_ctrl(struct v4l2_ctrl *ctrl)
+/* Set exposure/auto exposure cluster */
+static int m5mols_set_exposure(struct m5mols_info *info, int exposure)
+{
+	struct v4l2_subdev *sd = &info->sd;
+	int ret;
+
+	ret = m5mols_lock_ae(info, exposure != V4L2_EXPOSURE_AUTO);
+	if (ret < 0)
+		return ret;
+
+	if (exposure == V4L2_EXPOSURE_AUTO) {
+		ret = m5mols_write(sd, AE_MODE, REG_AE_ALL);
+		if (ret < 0)
+			return ret;
+	}
+
+	if (exposure == V4L2_EXPOSURE_MANUAL) {
+		ret = m5mols_write(sd, AE_MODE, REG_AE_OFF);
+		if (ret == 0)
+			ret = m5mols_write(sd, AE_MAN_GAIN_MON,
+					   info->exposure->val);
+		if (ret == 0)
+			ret = m5mols_write(sd, AE_MAN_GAIN_CAP,
+					   info->exposure->val);
+	}
+
+	return ret;
+}
+
+static int m5mols_set_white_balance(struct m5mols_info *info, int awb)
+{
+	int ret;
+
+	ret = m5mols_lock_awb(info, !awb);
+	if (ret < 0)
+		return ret;
+
+	return m5mols_write(&info->sd, AWB_MODE, awb ? REG_AWB_AUTO :
+			    REG_AWB_PRESET);
+}
+
+static int m5mols_set_saturation(struct m5mols_info *info, int val)
+{
+	int ret = m5mols_write(&info->sd, MON_CHROMA_LVL, val);
+	if (ret < 0)
+		return ret;
+
+	return m5mols_write(&info->sd, MON_CHROMA_EN, REG_CHROMA_ON);
+}
+
+static int m5mols_set_color_effect(struct m5mols_info *info, int val)
+{
+	unsigned int m_effect = REG_COLOR_EFFECT_OFF;
+	unsigned int p_effect = REG_EFFECT_OFF;
+	unsigned int cfix_r = 0, cfix_b = 0;
+	struct v4l2_subdev *sd = &info->sd;
+	int ret = 0;
+
+	switch (val) {
+	case V4L2_COLORFX_BW:
+		m_effect = REG_COLOR_EFFECT_ON;
+		break;
+	case V4L2_COLORFX_NEGATIVE:
+		p_effect = REG_EFFECT_NEGA;
+		break;
+	case V4L2_COLORFX_EMBOSS:
+		p_effect = REG_EFFECT_EMBOSS;
+		break;
+	case V4L2_COLORFX_SEPIA:
+		m_effect = REG_COLOR_EFFECT_ON;
+		cfix_r = REG_CFIXR_SEPIA;
+		cfix_b = REG_CFIXB_SEPIA;
+		break;
+	}
+
+	ret = m5mols_write(sd, PARM_EFFECT, p_effect);
+	if (!ret)
+		ret = m5mols_write(sd, MON_EFFECT, m_effect);
+
+	if (ret == 0 && m_effect == REG_COLOR_EFFECT_ON) {
+		ret = m5mols_write(sd, MON_CFIXR, cfix_r);
+		if (!ret)
+			ret = m5mols_write(sd, MON_CFIXB, cfix_b);
+	}
+
+	v4l2_dbg(1, m5mols_debug, sd,
+		 "p_effect: %#x, m_effect: %#x, r: %#x, b: %#x (%d)\n",
+		 p_effect, m_effect, cfix_r, cfix_b, ret);
+
+	return ret;
+}
+
+static int m5mols_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct v4l2_subdev *sd = to_sd(ctrl);
 	struct m5mols_info *info = to_m5mols(sd);
+	int ispstate = info->mode;
 	int ret;
 
+	/*
+	 * If needed, defer restoring the controls until
+	 * the device is fully initialized.
+	 */
+	if (!info->isp_ready) {
+		info->ctrl_sync = 0;
+		return 0;
+	}
+
+	ret = m5mols_mode(info, REG_PARAMETER);
+	if (ret < 0)
+		return ret;
+
 	switch (ctrl->id) {
 	case V4L2_CID_ZOOM_ABSOLUTE:
-		return m5mols_write(sd, MON_ZOOM, ctrl->val);
+		ret = m5mols_write(sd, MON_ZOOM, ctrl->val);
+		break;
 
 	case V4L2_CID_EXPOSURE_AUTO:
-		ret = m5mols_lock_ae(info,
-			ctrl->val == V4L2_EXPOSURE_AUTO ? false : true);
-		if (!ret && ctrl->val == V4L2_EXPOSURE_AUTO)
-			ret = m5mols_write(sd, AE_MODE, REG_AE_ALL);
-		if (!ret && ctrl->val == V4L2_EXPOSURE_MANUAL) {
-			int val = info->exposure->val;
-			ret = m5mols_write(sd, AE_MODE, REG_AE_OFF);
-			if (!ret)
-				ret = m5mols_write(sd, AE_MAN_GAIN_MON, val);
-			if (!ret)
-				ret = m5mols_write(sd, AE_MAN_GAIN_CAP, val);
-		}
-		return ret;
+		ret = m5mols_set_exposure(info, ctrl->val);
+		break;
 
 	case V4L2_CID_AUTO_WHITE_BALANCE:
-		ret = m5mols_lock_awb(info, ctrl->val ? false : true);
-		if (!ret)
-			ret = m5mols_write(sd, AWB_MODE, ctrl->val ?
-				REG_AWB_AUTO : REG_AWB_PRESET);
-		return ret;
+		ret = m5mols_set_white_balance(info, ctrl->val);
+		break;
 
 	case V4L2_CID_SATURATION:
-		ret = m5mols_write(sd, MON_CHROMA_LVL, ctrl->val);
-		if (!ret)
-			ret = m5mols_write(sd, MON_CHROMA_EN, REG_CHROMA_ON);
-		return ret;
+		ret = m5mols_set_saturation(info, ctrl->val);
+		break;
 
 	case V4L2_CID_COLORFX:
-		/*
-		 * This control uses two kinds of registers: normal & color.
-		 * The normal effect belongs to category 1, while the color
-		 * one belongs to category 2.
-		 *
-		 * The normal effect uses one register: CAT1_EFFECT.
-		 * The color effect uses three registers:
-		 * CAT2_COLOR_EFFECT, CAT2_CFIXR, CAT2_CFIXB.
-		 */
-		ret = m5mols_write(sd, PARM_EFFECT,
-			ctrl->val == V4L2_COLORFX_NEGATIVE ? REG_EFFECT_NEGA :
-			ctrl->val == V4L2_COLORFX_EMBOSS ? REG_EFFECT_EMBOSS :
-			REG_EFFECT_OFF);
-		if (!ret)
-			ret = m5mols_write(sd, MON_EFFECT,
-				ctrl->val == V4L2_COLORFX_SEPIA ?
-				REG_COLOR_EFFECT_ON : REG_COLOR_EFFECT_OFF);
-		if (!ret)
-			ret = m5mols_write(sd, MON_CFIXR,
-				ctrl->val == V4L2_COLORFX_SEPIA ?
-				REG_CFIXR_SEPIA : 0);
-		if (!ret)
-			ret = m5mols_write(sd, MON_CFIXB,
-				ctrl->val == V4L2_COLORFX_SEPIA ?
-				REG_CFIXB_SEPIA : 0);
+		ret = m5mols_set_color_effect(info, ctrl->val);
+		break;
+	}
+	if (ret < 0)
+		return ret;
+
+	return m5mols_mode(info, ispstate);
+}
+
+static const struct v4l2_ctrl_ops m5mols_ctrl_ops = {
+	.s_ctrl			= m5mols_s_ctrl,
+};
+
+int m5mols_init_controls(struct v4l2_subdev *sd)
+{
+	struct m5mols_info *info = to_m5mols(sd);
+	u16 exposure_max;
+	u16 zoom_step;
+	int ret;
+
+	/* Determine the firmware dependant control range and step values */
+	ret = m5mols_read_u16(sd, AE_MAX_GAIN_MON, &exposure_max);
+	if (ret < 0)
+		return ret;
+
+	zoom_step = is_manufacturer(info, REG_SAMSUNG_OPTICS) ? 31 : 1;
+
+	v4l2_ctrl_handler_init(&info->handle, 6);
+
+	info->auto_wb = v4l2_ctrl_new_std(&info->handle, &m5mols_ctrl_ops,
+			V4L2_CID_AUTO_WHITE_BALANCE, 0, 1, 1, 1);
+
+	info->auto_exposure = v4l2_ctrl_new_std_menu(&info->handle,
+			&m5mols_ctrl_ops, V4L2_CID_EXPOSURE_AUTO,
+			1, ~0x03, V4L2_EXPOSURE_AUTO);
+
+	info->exposure = v4l2_ctrl_new_std(&info->handle,
+			&m5mols_ctrl_ops, V4L2_CID_EXPOSURE,
+			0, exposure_max, 1, exposure_max / 2);
+
+	info->saturation = v4l2_ctrl_new_std(&info->handle, &m5mols_ctrl_ops,
+			V4L2_CID_SATURATION, 1, 5, 1, 3);
+
+	info->zoom = v4l2_ctrl_new_std(&info->handle, &m5mols_ctrl_ops,
+			V4L2_CID_ZOOM_ABSOLUTE, 1, 70, zoom_step, 1);
+
+	info->colorfx = v4l2_ctrl_new_std_menu(&info->handle, &m5mols_ctrl_ops,
+			V4L2_CID_COLORFX, 4, 0, V4L2_COLORFX_NONE);
+	m5mols_set_ctrl_mode(info->colorfx, REG_PARAMETER);
+
+	if (info->handle.error) {
+		int ret = info->handle.error;
+		v4l2_err(sd, "Failed to initialize controls: %d\n", ret);
+		v4l2_ctrl_handler_free(&info->handle);
 		return ret;
 	}
 
-	return -EINVAL;
+	v4l2_ctrl_auto_cluster(2, &info->auto_exposure, 1, false);
+	sd->ctrl_handler = &info->handle;
+
+	return 0;
 }
diff --git a/drivers/media/video/m5mols/m5mols_core.c b/drivers/media/video/m5mols/m5mols_core.c
index d718aee..2afe12b 100644
--- a/drivers/media/video/m5mols/m5mols_core.c
+++ b/drivers/media/video/m5mols/m5mols_core.c
@@ -681,35 +681,6 @@ static const struct v4l2_subdev_video_ops m5mols_video_ops = {
 	.s_stream	= m5mols_s_stream,
 };
 
-static int m5mols_s_ctrl(struct v4l2_ctrl *ctrl)
-{
-	struct v4l2_subdev *sd = to_sd(ctrl);
-	struct m5mols_info *info = to_m5mols(sd);
-	int ispstate = info->mode;
-	int ret;
-
-	/*
-	 * If needed, defer restoring the controls until
-	 * the device is fully initialized.
-	 */
-	if (!info->isp_ready) {
-		info->ctrl_sync = 0;
-		return 0;
-	}
-
-	ret = m5mols_mode(info, REG_PARAMETER);
-	if (ret < 0)
-		return ret;
-	ret = m5mols_set_ctrl(ctrl);
-	if (ret < 0)
-		return ret;
-	return m5mols_mode(info, ispstate);
-}
-
-static const struct v4l2_ctrl_ops m5mols_ctrl_ops = {
-	.s_ctrl	= m5mols_s_ctrl,
-};
-
 static int m5mols_sensor_power(struct m5mols_info *info, bool enable)
 {
 	struct v4l2_subdev *sd = &info->sd;
@@ -802,52 +773,6 @@ static int m5mols_fw_start(struct v4l2_subdev *sd)
 	return ret;
 }
 
-static int m5mols_init_controls(struct m5mols_info *info)
-{
-	struct v4l2_subdev *sd = &info->sd;
-	u16 max_exposure;
-	u16 step_zoom;
-	int ret;
-
-	/* Determine value's range & step of controls for various FW version */
-	ret = m5mols_read_u16(sd, AE_MAX_GAIN_MON, &max_exposure);
-	if (!ret)
-		step_zoom = is_manufacturer(info, REG_SAMSUNG_OPTICS) ? 31 : 1;
-	if (ret)
-		return ret;
-
-	v4l2_ctrl_handler_init(&info->handle, 6);
-	info->autowb = v4l2_ctrl_new_std(&info->handle,
-			&m5mols_ctrl_ops, V4L2_CID_AUTO_WHITE_BALANCE,
-			0, 1, 1, 0);
-	info->saturation = v4l2_ctrl_new_std(&info->handle,
-			&m5mols_ctrl_ops, V4L2_CID_SATURATION,
-			1, 5, 1, 3);
-	info->zoom = v4l2_ctrl_new_std(&info->handle,
-			&m5mols_ctrl_ops, V4L2_CID_ZOOM_ABSOLUTE,
-			1, 70, step_zoom, 1);
-	info->exposure = v4l2_ctrl_new_std(&info->handle,
-			&m5mols_ctrl_ops, V4L2_CID_EXPOSURE,
-			0, max_exposure, 1, (int)max_exposure/2);
-	info->colorfx = v4l2_ctrl_new_std_menu(&info->handle,
-			&m5mols_ctrl_ops, V4L2_CID_COLORFX,
-			4, (1 << V4L2_COLORFX_BW), V4L2_COLORFX_NONE);
-	info->autoexposure = v4l2_ctrl_new_std_menu(&info->handle,
-			&m5mols_ctrl_ops, V4L2_CID_EXPOSURE_AUTO,
-			1, 0, V4L2_EXPOSURE_AUTO);
-
-	sd->ctrl_handler = &info->handle;
-	if (info->handle.error) {
-		v4l2_err(sd, "Failed to initialize controls: %d\n", ret);
-		v4l2_ctrl_handler_free(&info->handle);
-		return info->handle.error;
-	}
-
-	v4l2_ctrl_cluster(2, &info->autoexposure);
-
-	return 0;
-}
-
 /**
  * m5mols_s_power - Main sensor power control function
  *
@@ -1010,7 +935,7 @@ static int __devinit m5mols_probe(struct i2c_client *client,
 
 	ret = m5mols_fw_start(sd);
 	if (!ret)
-		ret = m5mols_init_controls(info);
+		ret = m5mols_init_controls(sd);
 
 	m5mols_sensor_power(info, false);
 	if (!ret)
-- 
1.7.9.2

