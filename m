Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:48999 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab2EJKbK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 May 2012 06:31:10 -0400
Received: from euspt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M3S00BC6YGKMD@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 May 2012 11:29:08 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M3S00DAWYJQ3L@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 May 2012 11:31:03 +0100 (BST)
Date: Thu, 10 May 2012 12:30:49 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 14/23] m5mols: Refactored controls handling
In-reply-to: <1336645858-30366-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1336645858-30366-15-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1336645858-30366-1-git-send-email-s.nawrocki@samsung.com>
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
 drivers/media/video/m5mols/m5mols.h          |   24 +--
 drivers/media/video/m5mols/m5mols_capture.c  |    4 +-
 drivers/media/video/m5mols/m5mols_controls.c |  227 ++++++++++++++++++++------
 drivers/media/video/m5mols/m5mols_core.c     |   93 +----------
 4 files changed, 198 insertions(+), 150 deletions(-)

diff --git a/drivers/media/video/m5mols/m5mols.h b/drivers/media/video/m5mols/m5mols.h
index 0acc3d6..ed75bbe 100644
--- a/drivers/media/video/m5mols/m5mols.h
+++ b/drivers/media/video/m5mols/m5mols.h
@@ -160,12 +160,12 @@ struct m5mols_version {
  * @irq_waitq: waitqueue for the capture
  * @flags: state variable for the interrupt handler
  * @handle: control handler
- * @autoexposure: Auto Exposure control
- * @exposure: Exposure control
+ * @auto_exposure: auto/manual exposure control
+ * @exposure: manual exposure control
  * @autowb: Auto White Balance control
- * @colorfx: Color effect control
- * @saturation:	Saturation control
- * @zoom: Zoom control
+ * @colorfx: color effect control
+ * @saturation: saturation control
+ * @zoom: zoom control
  * @ver: information of the version
  * @cap: the capture mode attributes
  * @power: current sensor's power status
@@ -188,12 +188,13 @@ struct m5mols_info {
 	atomic_t irq_done;
 
 	struct v4l2_ctrl_handler handle;
+	struct {
+		/* exposure/auto-exposure cluster */
+		struct v4l2_ctrl *auto_exposure;
+		struct v4l2_ctrl *exposure;
+	};
 
-	/* Autoexposure/exposure control cluster */
-	struct v4l2_ctrl *autoexposure;
-	struct v4l2_ctrl *exposure;
-
-	struct v4l2_ctrl *autowb;
+	struct v4l2_ctrl *auto_wb;
 	struct v4l2_ctrl *colorfx;
 	struct v4l2_ctrl *saturation;
 	struct v4l2_ctrl *zoom;
@@ -277,7 +278,7 @@ int m5mols_busy_wait(struct v4l2_subdev *sd, u32 reg, u32 value, u32 mask,
  * The available executing order between each modes are as follows:
  *   PARAMETER <---> MONITOR <---> CAPTURE
  */
-int m5mols_mode(struct m5mols_info *info, u8 mode);
+int m5mols_set_mode(struct m5mols_info *info, u8 mode);
 
 int m5mols_enable_interrupt(struct v4l2_subdev *sd, u8 reg);
 int m5mols_wait_interrupt(struct v4l2_subdev *sd, u8 condition, u32 timeout);
@@ -286,6 +287,7 @@ int m5mols_start_capture(struct m5mols_info *info);
 int m5mols_do_scenemode(struct m5mols_info *info, u8 mode);
 int m5mols_lock_3a(struct m5mols_info *info, bool lock);
 int m5mols_set_ctrl(struct v4l2_ctrl *ctrl);
+int m5mols_init_controls(struct v4l2_subdev *sd);
 
 /* The firmware function */
 int m5mols_update_fw(struct v4l2_subdev *sd,
diff --git a/drivers/media/video/m5mols/m5mols_capture.c b/drivers/media/video/m5mols/m5mols_capture.c
index ba25e8e..4f27aed 100644
--- a/drivers/media/video/m5mols/m5mols_capture.c
+++ b/drivers/media/video/m5mols/m5mols_capture.c
@@ -114,7 +114,7 @@ int m5mols_start_capture(struct m5mols_info *info)
 	 * format. The frame capture is initiated during switching from Monitor
 	 * to Capture mode.
 	 */
-	ret = m5mols_mode(info, REG_MONITOR);
+	ret = m5mols_set_mode(info, REG_MONITOR);
 	if (!ret)
 		ret = m5mols_restore_controls(info);
 	if (!ret)
@@ -124,7 +124,7 @@ int m5mols_start_capture(struct m5mols_info *info)
 	if (!ret)
 		ret = m5mols_lock_3a(info, true);
 	if (!ret)
-		ret = m5mols_mode(info, REG_CAPTURE);
+		ret = m5mols_set_mode(info, REG_CAPTURE);
 	if (!ret)
 		/* Wait until a frame is captured to ISP internal memory */
 		ret = m5mols_wait_interrupt(sd, REG_INT_CAPTURE, 2000);
diff --git a/drivers/media/video/m5mols/m5mols_controls.c b/drivers/media/video/m5mols/m5mols_controls.c
index d135d20..464ec0c 100644
--- a/drivers/media/video/m5mols/m5mols_controls.c
+++ b/drivers/media/video/m5mols/m5mols_controls.c
@@ -169,7 +169,7 @@ int m5mols_do_scenemode(struct m5mols_info *info, u8 mode)
 	if (!ret)
 		ret = m5mols_write(sd, AE_ISO, scenemode.iso);
 	if (!ret)
-		ret = m5mols_mode(info, REG_CAPTURE);
+		ret = m5mols_set_mode(info, REG_CAPTURE);
 	if (!ret)
 		ret = m5mols_write(sd, CAPP_WDR_EN, scenemode.wdr);
 	if (!ret)
@@ -181,7 +181,7 @@ int m5mols_do_scenemode(struct m5mols_info *info, u8 mode)
 	if (!ret)
 		ret = m5mols_write(sd, CAPC_MODE, scenemode.capt_mode);
 	if (!ret)
-		ret = m5mols_mode(info, REG_MONITOR);
+		ret = m5mols_set_mode(info, REG_MONITOR);
 
 	return ret;
 }
@@ -227,73 +227,194 @@ int m5mols_lock_3a(struct m5mols_info *info, bool lock)
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
index d718aee..ac7d28b 100644
--- a/drivers/media/video/m5mols/m5mols_core.c
+++ b/drivers/media/video/m5mols/m5mols_core.c
@@ -362,14 +362,14 @@ static int m5mols_reg_mode(struct v4l2_subdev *sd, u8 mode)
 }
 
 /**
- * m5mols_mode - manage the M-5MOLS's mode
+ * m5mols_set_mode - set the M-5MOLS controller mode
  * @mode: the required operation mode
  *
  * The commands of M-5MOLS are grouped into specific modes. Each functionality
- * can be guaranteed only when the sensor is operating in mode which which
- * a command belongs to.
+ * can be guaranteed only when the sensor is operating in mode which a command
+ * belongs to.
  */
-int m5mols_mode(struct m5mols_info *info, u8 mode)
+int m5mols_set_mode(struct m5mols_info *info, u8 mode)
 {
 	struct v4l2_subdev *sd = &info->sd;
 	int ret = -EINVAL;
@@ -645,13 +645,13 @@ static int m5mols_start_monitor(struct m5mols_info *info)
 	struct v4l2_subdev *sd = &info->sd;
 	int ret;
 
-	ret = m5mols_mode(info, REG_PARAMETER);
+	ret = m5mols_set_mode(info, REG_PARAMETER);
 	if (!ret)
 		ret = m5mols_write(sd, PARM_MON_SIZE, info->resolution);
 	if (!ret)
 		ret = m5mols_write(sd, PARM_MON_FPS, REG_FPS_30);
 	if (!ret)
-		ret = m5mols_mode(info, REG_MONITOR);
+		ret = m5mols_set_mode(info, REG_MONITOR);
 	if (!ret)
 		ret = m5mols_restore_controls(info);
 
@@ -674,42 +674,13 @@ static int m5mols_s_stream(struct v4l2_subdev *sd, int enable)
 		return ret;
 	}
 
-	return m5mols_mode(info, REG_PARAMETER);
+	return m5mols_set_mode(info, REG_PARAMETER);
 }
 
 static const struct v4l2_subdev_video_ops m5mols_video_ops = {
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
@@ -868,7 +793,7 @@ static int m5mols_s_power(struct v4l2_subdev *sd, int on)
 	}
 
 	if (is_manufacturer(info, REG_SAMSUNG_TECHWIN)) {
-		ret = m5mols_mode(info, REG_MONITOR);
+		ret = m5mols_set_mode(info, REG_MONITOR);
 		if (!ret)
 			ret = m5mols_write(sd, AF_EXECUTE, REG_AF_STOP);
 		if (!ret)
@@ -1010,7 +935,7 @@ static int __devinit m5mols_probe(struct i2c_client *client,
 
 	ret = m5mols_fw_start(sd);
 	if (!ret)
-		ret = m5mols_init_controls(info);
+		ret = m5mols_init_controls(sd);
 
 	m5mols_sensor_power(info, false);
 	if (!ret)
-- 
1.7.10

