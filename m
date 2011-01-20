Return-path: <mchehab@pedra>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:46071 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527Ab1ATBoX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jan 2011 20:44:23 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from eu_spt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LFA00A9GSTW5S50@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 20 Jan 2011 01:44:21 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LFA00NJKSTW0Z@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 20 Jan 2011 01:44:20 +0000 (GMT)
Date: Thu, 20 Jan 2011 02:44:01 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 2/3] sr030pc30: Use the control framework
In-reply-to: <1295487842-23410-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, m.szyprowski@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <1295487842-23410-3-git-send-email-s.nawrocki@samsung.com>
References: <1295487842-23410-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Implement controls using the control framework.
Add horizontal/vertical flip controls, minor cleanup.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/sr030pc30.c |  311 +++++++++++++++++----------------------
 1 files changed, 132 insertions(+), 179 deletions(-)

diff --git a/drivers/media/video/sr030pc30.c b/drivers/media/video/sr030pc30.c
index e1eced1..1a195f0 100644
--- a/drivers/media/video/sr030pc30.c
+++ b/drivers/media/video/sr030pc30.c
@@ -19,6 +19,8 @@
 #include <linux/i2c.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
+#include <media/v4l2-chip-ident.h>
+#include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-mediabus.h>
@@ -141,17 +143,24 @@ module_param(debug, int, 0644);
 
 struct sr030pc30_info {
 	struct v4l2_subdev sd;
+	struct v4l2_ctrl_handler hdl;
+	struct {
+		/* exposure/auto-exposure cluster */
+		struct v4l2_ctrl *autoexposure;
+		struct v4l2_ctrl *exposure;
+	};
+	struct {
+		/* blue/red/autowhitebalance cluster */
+		struct v4l2_ctrl *autowb;
+		struct v4l2_ctrl *blue;
+		struct v4l2_ctrl *red;
+	};
+	struct v4l2_ctrl *hflip;
+	struct v4l2_ctrl *vflip;
 	const struct sr030pc30_platform_data *pdata;
 	const struct sr030pc30_format *curr_fmt;
 	const struct sr030pc30_frmsize *curr_win;
-	unsigned int auto_wb:1;
-	unsigned int auto_exp:1;
-	unsigned int hflip:1;
-	unsigned int vflip:1;
 	unsigned int sleep:1;
-	unsigned int exposure;
-	u8 blue_balance;
-	u8 red_balance;
 	u8 i2c_reg_page;
 };
 
@@ -172,52 +181,6 @@ struct i2c_regval {
 	u16 val;
 };
 
-static const struct v4l2_queryctrl sr030pc30_ctrl[] = {
-	{
-		.id		= V4L2_CID_AUTO_WHITE_BALANCE,
-		.type		= V4L2_CTRL_TYPE_BOOLEAN,
-		.name		= "Auto White Balance",
-		.minimum	= 0,
-		.maximum	= 1,
-		.step		= 1,
-		.default_value	= 1,
-	}, {
-		.id		= V4L2_CID_RED_BALANCE,
-		.type		= V4L2_CTRL_TYPE_INTEGER,
-		.name		= "Red Balance",
-		.minimum	= 0,
-		.maximum	= 127,
-		.step		= 1,
-		.default_value	= 64,
-		.flags		= 0,
-	}, {
-		.id		= V4L2_CID_BLUE_BALANCE,
-		.type		= V4L2_CTRL_TYPE_INTEGER,
-		.name		= "Blue Balance",
-		.minimum	= 0,
-		.maximum	= 127,
-		.step		= 1,
-		.default_value	= 64,
-	}, {
-		.id		= V4L2_CID_EXPOSURE_AUTO,
-		.type		= V4L2_CTRL_TYPE_INTEGER,
-		.name		= "Auto Exposure",
-		.minimum	= 0,
-		.maximum	= 1,
-		.step		= 1,
-		.default_value	= 1,
-	}, {
-		.id		= V4L2_CID_EXPOSURE,
-		.type		= V4L2_CTRL_TYPE_INTEGER,
-		.name		= "Exposure",
-		.minimum	= EXPOS_MIN_MS,
-		.maximum	= EXPOS_MAX_MS,
-		.step		= 1,
-		.default_value	= 1,
-	}, {
-	}
-};
-
 /* supported resolutions */
 static const struct sr030pc30_frmsize sr030pc30_sizes[] = {
 	{
@@ -323,6 +286,11 @@ static inline struct sr030pc30_info *to_sr030pc30(struct v4l2_subdev *sd)
 	return container_of(sd, struct sr030pc30_info, sd);
 }
 
+static inline struct v4l2_subdev *to_sd(struct v4l2_ctrl *ctrl)
+{
+	return &container_of(ctrl->handler, struct sr030pc30_info, hdl)->sd;
+}
+
 static inline int set_i2c_page(struct sr030pc30_info *info,
 			       struct i2c_client *client, unsigned int reg)
 {
@@ -395,59 +363,56 @@ static int sr030pc30_pwr_ctrl(struct v4l2_subdev *sd,
 
 static inline int sr030pc30_enable_autoexposure(struct v4l2_subdev *sd, int on)
 {
-	struct sr030pc30_info *info = to_sr030pc30(sd);
 	/* auto anti-flicker is also enabled here */
-	int ret = cam_i2c_write(sd, AE_CTL1_REG, on ? 0xDC : 0x0C);
-	if (!ret)
-		info->auto_exp = on;
-	return ret;
+	return cam_i2c_write(sd, AE_CTL1_REG, on ? 0xDC : 0x0C);
 }
 
 static int sr030pc30_set_exposure(struct v4l2_subdev *sd, int value)
 {
 	struct sr030pc30_info *info = to_sr030pc30(sd);
-
 	unsigned long expos = value * info->pdata->clk_rate / (8 * 1000);
+	int ret;
 
-	int ret = cam_i2c_write(sd, EXP_TIMEH_REG, expos >> 16 & 0xFF);
+	ret = cam_i2c_write(sd, EXP_TIMEH_REG, expos >> 16 & 0xFF);
 	if (!ret)
 		ret = cam_i2c_write(sd, EXP_TIMEM_REG, expos >> 8 & 0xFF);
 	if (!ret)
 		ret = cam_i2c_write(sd, EXP_TIMEL_REG, expos & 0xFF);
-	if (!ret) { /* Turn off AE */
-		info->exposure = value;
+	if (!ret) /* Turn off AE */
 		ret = sr030pc30_enable_autoexposure(sd, 0);
-	}
+
 	return ret;
 }
 
 /* Automatic white balance control */
 static int sr030pc30_enable_autowhitebalance(struct v4l2_subdev *sd, int on)
 {
-	struct sr030pc30_info *info = to_sr030pc30(sd);
+	int ret;
 
-	int ret = cam_i2c_write(sd, AWB_CTL2_REG, on ? 0x2E : 0x2F);
+	ret = cam_i2c_write(sd, AWB_CTL2_REG, on ? 0x2E : 0x2F);
 	if (!ret)
 		ret = cam_i2c_write(sd, AWB_CTL1_REG, on ? 0xFB : 0x7B);
-	if (!ret)
-		info->auto_wb = on;
 
 	return ret;
 }
 
-static int sr030pc30_set_flip(struct v4l2_subdev *sd)
+/**
+ * sr030pc30_set_flip - set image flipping
+ * @sd: a pointer to the subdev to apply the seetings to
+ * @hflip: 1 to enable or 0 to disable horizontal flip
+ * @vflip: as above but for vertical flip
+ */
+static int sr030pc30_set_flip(struct v4l2_subdev *sd, u32 hflip, u32 vflip)
 {
-	struct sr030pc30_info *info = to_sr030pc30(sd);
-
 	s32 reg = cam_i2c_read(sd, VDO_CTL2_REG);
+
 	if (reg < 0)
 		return reg;
 
 	reg &= 0x7C;
-	if (info->hflip)
-		reg |= 0x01;
-	if (info->vflip)
-		reg |= 0x02;
+	reg |= ((hflip & 0x1) << 0);
+	reg |= ((vflip & 0x1) << 1);
+
 	return cam_i2c_write(sd, VDO_CTL2_REG, reg | 0x80);
 }
 
@@ -468,8 +433,8 @@ static int sr030pc30_set_params(struct v4l2_subdev *sd)
 		ret = cam_i2c_write(sd, ISP_CTL_REG(0),
 				info->curr_fmt->ispctl1_reg);
 	if (!ret)
-		ret = sr030pc30_set_flip(sd);
-
+		ret = sr030pc30_set_flip(sd, info->hflip->val,
+					 info->vflip->val);
 	return ret;
 }
 
@@ -497,108 +462,48 @@ static int sr030pc30_try_frame_size(struct v4l2_mbus_framefmt *mf)
 	return -EINVAL;
 }
 
-static int sr030pc30_queryctrl(struct v4l2_subdev *sd,
-			       struct v4l2_queryctrl *qc)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(sr030pc30_ctrl); i++)
-		if (qc->id == sr030pc30_ctrl[i].id) {
-			*qc = sr030pc30_ctrl[i];
-			v4l2_dbg(1, debug, sd, "%s id: %d\n",
-				 __func__, qc->id);
-			return 0;
-		}
-
-	return -EINVAL;
-}
-
-static inline int sr030pc30_set_bluebalance(struct v4l2_subdev *sd, int value)
-{
-	int ret = cam_i2c_write(sd, MWB_BGAIN_REG, value);
-	if (!ret)
-		to_sr030pc30(sd)->blue_balance = value;
-	return ret;
-}
-
-static inline int sr030pc30_set_redbalance(struct v4l2_subdev *sd, int value)
-{
-	int ret = cam_i2c_write(sd, MWB_RGAIN_REG, value);
-	if (!ret)
-		to_sr030pc30(sd)->red_balance = value;
-	return ret;
-}
-
-static int sr030pc30_s_ctrl(struct v4l2_subdev *sd,
-			    struct v4l2_control *ctrl)
+static int sr030pc30_s_ctrl(struct v4l2_ctrl *ctrl)
 {
-	int i, ret = 0;
-
-	for (i = 0; i < ARRAY_SIZE(sr030pc30_ctrl); i++)
-		if (ctrl->id == sr030pc30_ctrl[i].id)
-			break;
-
-	if (i == ARRAY_SIZE(sr030pc30_ctrl))
-		return -EINVAL;
-
-	if (ctrl->value < sr030pc30_ctrl[i].minimum ||
-		ctrl->value > sr030pc30_ctrl[i].maximum)
-			return -ERANGE;
+	struct v4l2_subdev *sd = to_sd(ctrl);
+	struct sr030pc30_info *info = to_sr030pc30(sd);
+	int ret = 0;
 
-	v4l2_dbg(1, debug, sd, "%s: ctrl_id: %d, value: %d\n",
-			 __func__, ctrl->id, ctrl->value);
+	v4l2_dbg(1, debug, sd, "%s: ctrl id: %d, value: %d\n",
+			 __func__, ctrl->id, ctrl->val);
 
 	switch (ctrl->id) {
 	case V4L2_CID_AUTO_WHITE_BALANCE:
-		sr030pc30_enable_autowhitebalance(sd, ctrl->value);
-		break;
-	case V4L2_CID_BLUE_BALANCE:
-		ret = sr030pc30_set_bluebalance(sd, ctrl->value);
-		break;
-	case V4L2_CID_RED_BALANCE:
-		ret = sr030pc30_set_redbalance(sd, ctrl->value);
-		break;
-	case V4L2_CID_EXPOSURE_AUTO:
-		sr030pc30_enable_autoexposure(sd,
-			ctrl->value == V4L2_EXPOSURE_AUTO);
-		break;
-	case V4L2_CID_EXPOSURE:
-		ret = sr030pc30_set_exposure(sd, ctrl->value);
-		break;
-	default:
-		return -EINVAL;
-	}
+		if (!ctrl->has_new)
+			ctrl->val = 0;
 
-	return ret;
-}
-
-static int sr030pc30_g_ctrl(struct v4l2_subdev *sd,
-			    struct v4l2_control *ctrl)
-{
-	struct sr030pc30_info *info = to_sr030pc30(sd);
+		ret = sr030pc30_enable_autowhitebalance(sd, ctrl->val);
 
-	v4l2_dbg(1, debug, sd, "%s: id: %d\n", __func__, ctrl->id);
+		if (!ret && !ctrl->val) {
+			ret = cam_i2c_write(sd, MWB_BGAIN_REG, info->blue->val);
+			if (!ret)
+				ret = cam_i2c_write(sd, MWB_RGAIN_REG,
+						    info->red->val);
+		}
+		return ret;
 
-	switch (ctrl->id) {
-	case V4L2_CID_AUTO_WHITE_BALANCE:
-		ctrl->value = info->auto_wb;
-		break;
-	case V4L2_CID_BLUE_BALANCE:
-		ctrl->value = info->blue_balance;
-		break;
-	case V4L2_CID_RED_BALANCE:
-		ctrl->value = info->red_balance;
-		break;
 	case V4L2_CID_EXPOSURE_AUTO:
-		ctrl->value = info->auto_exp;
-		break;
-	case V4L2_CID_EXPOSURE:
-		ctrl->value = info->exposure;
-		break;
+		if (!ctrl->has_new)
+			ctrl->val = V4L2_EXPOSURE_MANUAL;
+
+		if (ctrl->val == V4L2_EXPOSURE_MANUAL)
+			return sr030pc30_set_exposure(sd, info->exposure->val);
+		else
+			return sr030pc30_enable_autoexposure(sd, 1);
+
+	case V4L2_CID_HFLIP:
+		return sr030pc30_set_flip(sd, ctrl->val,
+					  info->vflip->val);
+	case V4L2_CID_VFLIP:
+		return sr030pc30_set_flip(sd, info->hflip->val,
+					  ctrl->val);
 	default:
 		return -EINVAL;
 	}
-	return 0;
 }
 
 static int sr030pc30_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
@@ -700,7 +605,7 @@ static int sr030pc30_base_config(struct v4l2_subdev *sd)
 	v4l2_dbg(1, debug, sd, "%s: expmin= %lx, expmax= %lx", __func__,
 		 expmin, expmax);
 
-	/* Setting up manual exposure time range */
+	/* Setting up manual exposure time range. */
 	ret = cam_i2c_write(sd, EXP_MMINH_REG, expmin >> 8 & 0xFF);
 	if (!ret)
 		ret = cam_i2c_write(sd, EXP_MMINL_REG, expmin & 0xFF);
@@ -710,8 +615,11 @@ static int sr030pc30_base_config(struct v4l2_subdev *sd)
 		ret = cam_i2c_write(sd, EXP_MMAXM_REG, expmax >> 8 & 0xFF);
 	if (!ret)
 		ret = cam_i2c_write(sd, EXP_MMAXL_REG, expmax & 0xFF);
+	if (ret)
+		return ret;
 
-	return ret;
+	/* Sync the handler and the registers state. */
+	return v4l2_ctrl_handler_setup(&info->hdl);
 }
 
 static int sr030pc30_s_power(struct v4l2_subdev *sd, int on)
@@ -748,11 +656,28 @@ static int sr030pc30_s_power(struct v4l2_subdev *sd, int on)
 	return ret;
 }
 
+static int sr030pc30_log_status(struct v4l2_subdev *sd)
+{
+	struct sr030pc30_info *info = to_sr030pc30(sd);
+
+	v4l2_ctrl_handler_log_status(&info->hdl, sd->name);
+	return 0;
+}
+
+static const struct v4l2_ctrl_ops sr030pc30_ctrl_ops = {
+	.s_ctrl = sr030pc30_s_ctrl,
+};
+
 static const struct v4l2_subdev_core_ops sr030pc30_core_ops = {
 	.s_power	= sr030pc30_s_power,
-	.queryctrl	= sr030pc30_queryctrl,
-	.s_ctrl		= sr030pc30_s_ctrl,
-	.g_ctrl		= sr030pc30_g_ctrl,
+	.g_ctrl		= v4l2_subdev_g_ctrl,
+	.s_ctrl		= v4l2_subdev_s_ctrl,
+	.queryctrl	= v4l2_subdev_queryctrl,
+	.querymenu	= v4l2_subdev_querymenu,
+	.g_ext_ctrls	= v4l2_subdev_g_ext_ctrls,
+	.try_ext_ctrls	= v4l2_subdev_try_ext_ctrls,
+	.s_ext_ctrls	= v4l2_subdev_s_ext_ctrls,
+	.log_status	= sr030pc30_log_status,
 };
 
 static const struct v4l2_subdev_video_ops sr030pc30_video_ops = {
@@ -797,7 +722,6 @@ static int sr030pc30_detect(struct i2c_client *client)
 	return ret == SR030PC30_ID ? 0 : -ENODEV;
 }
 
-
 static int sr030pc30_probe(struct i2c_client *client,
 			   const struct i2c_device_id *id)
 {
@@ -808,7 +732,7 @@ static int sr030pc30_probe(struct i2c_client *client,
 	int ret;
 
 	if (!pdata) {
-		dev_err(&client->dev, "No platform data!");
+		dev_err(&client->dev, "No platform data!\n");
 		return -EIO;
 	}
 
@@ -820,17 +744,45 @@ static int sr030pc30_probe(struct i2c_client *client,
 	if (!info)
 		return -ENOMEM;
 
+	info->i2c_reg_page = -1;
+
 	sd = &info->sd;
-	strcpy(sd->name, MODULE_NAME);
+	strlcpy(sd->name, MODULE_NAME, sizeof(sd->name));
 	info->pdata = client->dev.platform_data;
 
 	v4l2_i2c_subdev_init(sd, client, &sr030pc30_ops);
+	v4l2_ctrl_handler_init(&info->hdl, 6);
+
+	info->autowb = v4l2_ctrl_new_std(&info->hdl, &sr030pc30_ctrl_ops,
+				V4L2_CID_AUTO_WHITE_BALANCE, 0, 1, 1, 1);
+	info->red = v4l2_ctrl_new_std(&info->hdl, &sr030pc30_ctrl_ops,
+				V4L2_CID_RED_BALANCE, 0, 127, 1, 64);
+	info->blue = v4l2_ctrl_new_std(&info->hdl, &sr030pc30_ctrl_ops,
+				V4L2_CID_BLUE_BALANCE, 0, 127, 1, 64);
+
+	info->hflip = v4l2_ctrl_new_std(&info->hdl, &sr030pc30_ctrl_ops,
+				V4L2_CID_HFLIP, 0, 1, 1, 0);
+	info->vflip = v4l2_ctrl_new_std(&info->hdl, &sr030pc30_ctrl_ops,
+				V4L2_CID_VFLIP, 0, 1, 1, 0);
+
+	info->exposure = v4l2_ctrl_new_std(&info->hdl, &sr030pc30_ctrl_ops,
+				V4L2_CID_EXPOSURE, EXPOS_MIN_MS,
+				EXPOS_MAX_MS, 1, 30);
+
+	info->autoexposure = v4l2_ctrl_new_std_menu(&info->hdl,
+				&sr030pc30_ctrl_ops, V4L2_CID_EXPOSURE_AUTO,
+				1, 0, V4L2_EXPOSURE_AUTO);
+
+	sd->ctrl_handler = &info->hdl;
+
+	if (info->hdl.error) {
+		v4l2_ctrl_handler_free(&info->hdl);
+		kfree(info);
+		return info->hdl.error;
+	}
 
-	info->i2c_reg_page	= -1;
-	info->hflip		= 1;
-	info->auto_exp		= 1;
-	info->exposure		= 30;
-
+	v4l2_ctrl_cluster(2, &info->autoexposure);
+	v4l2_ctrl_cluster(3, &info->autowb);
 	return 0;
 }
 
@@ -840,6 +792,7 @@ static int sr030pc30_remove(struct i2c_client *client)
 	struct sr030pc30_info *info = to_sr030pc30(sd);
 
 	v4l2_device_unregister_subdev(sd);
+	v4l2_ctrl_handler_free(&info->hdl);
 	kfree(info);
 	return 0;
 }
-- 
1.7.0.4

