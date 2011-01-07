Return-path: <mchehab@pedra>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1788 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561Ab1AGMrx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Jan 2011 07:47:53 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [RFC PATCH 4/5] ov7670: use the control framework
Date: Fri,  7 Jan 2011 13:47:34 +0100
Message-Id: <f40635cbf1af567b4f0337e13df31d67360718e1.1294402580.git.hverkuil@xs4all.nl>
In-Reply-To: <1294404455-22050-1-git-send-email-hverkuil@xs4all.nl>
References: <1294404455-22050-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <cc5591b13e048b8fbc1482db6dffeb7d48f9134b.1294402580.git.hverkuil@xs4all.nl>
References: <cc5591b13e048b8fbc1482db6dffeb7d48f9134b.1294402580.git.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/ov7670.c |  296 ++++++++++++++++-------------------------
 1 files changed, 116 insertions(+), 180 deletions(-)

diff --git a/drivers/media/video/ov7670.c b/drivers/media/video/ov7670.c
index d4e7c11..4da8b62 100644
--- a/drivers/media/video/ov7670.c
+++ b/drivers/media/video/ov7670.c
@@ -19,6 +19,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/v4l2-mediabus.h>
+#include <media/v4l2-ctrls.h>
 
 #include "ov7670.h"
 
@@ -191,9 +192,23 @@ MODULE_PARM_DESC(debug, "Debug level (0-1)");
 struct ov7670_format_struct;  /* coming later */
 struct ov7670_info {
 	struct v4l2_subdev sd;
+	struct v4l2_ctrl_handler hdl;
+	struct {
+		/* gain cluster */
+		struct v4l2_ctrl *auto_gain;
+		struct v4l2_ctrl *gain;
+	};
+	struct {
+		/* exposure cluster */
+		struct v4l2_ctrl *auto_exposure;
+		struct v4l2_ctrl *exposure;
+	};
+	struct {
+		/* saturation/hue cluster */
+		struct v4l2_ctrl *saturation;
+		struct v4l2_ctrl *hue;
+	};
 	struct ov7670_format_struct *fmt;  /* Current format */
-	unsigned char sat;		/* Saturation value */
-	int hue;			/* Hue value */
 	int min_width;			/* Filter out smaller sizes */
 	int min_height;			/* Filter out smaller sizes */
 	int clock_speed;		/* External clock speed (MHz) */
@@ -206,6 +221,11 @@ static inline struct ov7670_info *to_state(struct v4l2_subdev *sd)
 	return container_of(sd, struct ov7670_info, sd);
 }
 
+static inline struct v4l2_subdev *to_sd(struct v4l2_ctrl *ctrl)
+{
+	return &container_of(ctrl->handler, struct ov7670_info, hdl)->sd;
+}
+
 
 
 /*
@@ -1043,23 +1063,23 @@ static int ov7670_cosine(int theta)
 
 
 static void ov7670_calc_cmatrix(struct ov7670_info *info,
-		int matrix[CMATRIX_LEN])
+		int matrix[CMATRIX_LEN], int sat, int hue)
 {
 	int i;
 	/*
 	 * Apply the current saturation setting first.
 	 */
 	for (i = 0; i < CMATRIX_LEN; i++)
-		matrix[i] = (info->fmt->cmatrix[i]*info->sat) >> 7;
+		matrix[i] = (info->fmt->cmatrix[i] * sat) >> 7;
 	/*
 	 * Then, if need be, rotate the hue value.
 	 */
-	if (info->hue != 0) {
+	if (hue != 0) {
 		int sinth, costh, tmpmatrix[CMATRIX_LEN];
 
 		memcpy(tmpmatrix, matrix, CMATRIX_LEN*sizeof(int));
-		sinth = ov7670_sine(info->hue);
-		costh = ov7670_cosine(info->hue);
+		sinth = ov7670_sine(hue);
+		costh = ov7670_cosine(hue);
 
 		matrix[0] = (matrix[3]*sinth + matrix[0]*costh)/1000;
 		matrix[1] = (matrix[4]*sinth + matrix[1]*costh)/1000;
@@ -1072,60 +1092,21 @@ static void ov7670_calc_cmatrix(struct ov7670_info *info,
 
 
 
-static int ov7670_s_sat(struct v4l2_subdev *sd, int value)
-{
-	struct ov7670_info *info = to_state(sd);
-	int matrix[CMATRIX_LEN];
-	int ret;
-
-	info->sat = value;
-	ov7670_calc_cmatrix(info, matrix);
-	ret = ov7670_store_cmatrix(sd, matrix);
-	return ret;
-}
-
-static int ov7670_g_sat(struct v4l2_subdev *sd, __s32 *value)
-{
-	struct ov7670_info *info = to_state(sd);
-
-	*value = info->sat;
-	return 0;
-}
-
-static int ov7670_s_hue(struct v4l2_subdev *sd, int value)
+static int ov7670_s_sat_hue(struct v4l2_subdev *sd, int sat, int hue)
 {
 	struct ov7670_info *info = to_state(sd);
 	int matrix[CMATRIX_LEN];
 	int ret;
 
-	if (value < -180 || value > 180)
-		return -EINVAL;
-	info->hue = value;
-	ov7670_calc_cmatrix(info, matrix);
+	ov7670_calc_cmatrix(info, matrix, sat, hue);
 	ret = ov7670_store_cmatrix(sd, matrix);
 	return ret;
 }
 
 
-static int ov7670_g_hue(struct v4l2_subdev *sd, __s32 *value)
-{
-	struct ov7670_info *info = to_state(sd);
-
-	*value = info->hue;
-	return 0;
-}
-
-
 /*
  * Some weird registers seem to store values in a sign/magnitude format!
  */
-static unsigned char ov7670_sm_to_abs(unsigned char v)
-{
-	if ((v & 0x80) == 0)
-		return v + 128;
-	return 128 - (v & 0x7f);
-}
-
 
 static unsigned char ov7670_abs_to_sm(unsigned char v)
 {
@@ -1147,40 +1128,11 @@ static int ov7670_s_brightness(struct v4l2_subdev *sd, int value)
 	return ret;
 }
 
-static int ov7670_g_brightness(struct v4l2_subdev *sd, __s32 *value)
-{
-	unsigned char v = 0;
-	int ret = ov7670_read(sd, REG_BRIGHT, &v);
-
-	*value = ov7670_sm_to_abs(v);
-	return ret;
-}
-
 static int ov7670_s_contrast(struct v4l2_subdev *sd, int value)
 {
 	return ov7670_write(sd, REG_CONTRAS, (unsigned char) value);
 }
 
-static int ov7670_g_contrast(struct v4l2_subdev *sd, __s32 *value)
-{
-	unsigned char v = 0;
-	int ret = ov7670_read(sd, REG_CONTRAS, &v);
-
-	*value = v;
-	return ret;
-}
-
-static int ov7670_g_hflip(struct v4l2_subdev *sd, __s32 *value)
-{
-	int ret;
-	unsigned char v = 0;
-
-	ret = ov7670_read(sd, REG_MVFP, &v);
-	*value = (v & MVFP_MIRROR) == MVFP_MIRROR;
-	return ret;
-}
-
-
 static int ov7670_s_hflip(struct v4l2_subdev *sd, int value)
 {
 	unsigned char v = 0;
@@ -1196,19 +1148,6 @@ static int ov7670_s_hflip(struct v4l2_subdev *sd, int value)
 	return ret;
 }
 
-
-
-static int ov7670_g_vflip(struct v4l2_subdev *sd, __s32 *value)
-{
-	int ret;
-	unsigned char v = 0;
-
-	ret = ov7670_read(sd, REG_MVFP, &v);
-	*value = (v & MVFP_FLIP) == MVFP_FLIP;
-	return ret;
-}
-
-
 static int ov7670_s_vflip(struct v4l2_subdev *sd, int value)
 {
 	unsigned char v = 0;
@@ -1257,16 +1196,6 @@ static int ov7670_s_gain(struct v4l2_subdev *sd, int value)
 /*
  * Tweak autogain.
  */
-static int ov7670_g_autogain(struct v4l2_subdev *sd, __s32 *value)
-{
-	int ret;
-	unsigned char com8;
-
-	ret = ov7670_read(sd, REG_COM8, &com8);
-	*value = (com8 & COM8_AGC) != 0;
-	return ret;
-}
-
 static int ov7670_s_autogain(struct v4l2_subdev *sd, int value)
 {
 	int ret;
@@ -1325,20 +1254,6 @@ static int ov7670_s_exp(struct v4l2_subdev *sd, int value)
 /*
  * Tweak autoexposure.
  */
-static int ov7670_g_autoexp(struct v4l2_subdev *sd, __s32 *value)
-{
-	int ret;
-	unsigned char com8;
-	enum v4l2_exposure_auto_type *atype = (enum v4l2_exposure_auto_type *) value;
-
-	ret = ov7670_read(sd, REG_COM8, &com8);
-	if (com8 & COM8_AEC)
-		*atype = V4L2_EXPOSURE_AUTO;
-	else
-		*atype = V4L2_EXPOSURE_MANUAL;
-	return ret;
-}
-
 static int ov7670_s_autoexp(struct v4l2_subdev *sd,
 		enum v4l2_exposure_auto_type value)
 {
@@ -1357,90 +1272,69 @@ static int ov7670_s_autoexp(struct v4l2_subdev *sd,
 }
 
 
-
-static int ov7670_queryctrl(struct v4l2_subdev *sd,
-		struct v4l2_queryctrl *qc)
+static int ov7670_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
 {
-	/* Fill in min, max, step and default value for these controls. */
-	switch (qc->id) {
-	case V4L2_CID_BRIGHTNESS:
-		return v4l2_ctrl_query_fill(qc, 0, 255, 1, 128);
-	case V4L2_CID_CONTRAST:
-		return v4l2_ctrl_query_fill(qc, 0, 127, 1, 64);
-	case V4L2_CID_VFLIP:
-	case V4L2_CID_HFLIP:
-		return v4l2_ctrl_query_fill(qc, 0, 1, 1, 0);
-	case V4L2_CID_SATURATION:
-		return v4l2_ctrl_query_fill(qc, 0, 256, 1, 128);
-	case V4L2_CID_HUE:
-		return v4l2_ctrl_query_fill(qc, -180, 180, 5, 0);
-	case V4L2_CID_GAIN:
-		return v4l2_ctrl_query_fill(qc, 0, 255, 1, 128);
-	case V4L2_CID_AUTOGAIN:
-		return v4l2_ctrl_query_fill(qc, 0, 1, 1, 1);
-	case V4L2_CID_EXPOSURE:
-		return v4l2_ctrl_query_fill(qc, 0, 65535, 1, 500);
-	case V4L2_CID_EXPOSURE_AUTO:
-		return v4l2_ctrl_query_fill(qc, 0, 1, 1, 0);
-	}
-	return -EINVAL;
-}
+	struct v4l2_subdev *sd = to_sd(ctrl);
+	struct ov7670_info *info = to_state(sd);
 
-static int ov7670_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
-{
 	switch (ctrl->id) {
-	case V4L2_CID_BRIGHTNESS:
-		return ov7670_g_brightness(sd, &ctrl->value);
-	case V4L2_CID_CONTRAST:
-		return ov7670_g_contrast(sd, &ctrl->value);
-	case V4L2_CID_SATURATION:
-		return ov7670_g_sat(sd, &ctrl->value);
-	case V4L2_CID_HUE:
-		return ov7670_g_hue(sd, &ctrl->value);
-	case V4L2_CID_VFLIP:
-		return ov7670_g_vflip(sd, &ctrl->value);
-	case V4L2_CID_HFLIP:
-		return ov7670_g_hflip(sd, &ctrl->value);
-	case V4L2_CID_GAIN:
-		return ov7670_g_gain(sd, &ctrl->value);
 	case V4L2_CID_AUTOGAIN:
-		return ov7670_g_autogain(sd, &ctrl->value);
-	case V4L2_CID_EXPOSURE:
-		return ov7670_g_exp(sd, &ctrl->value);
+		if (!ctrl->cur.val)
+			return 0;
+		return ov7670_g_gain(sd, &info->gain->cur.val);
 	case V4L2_CID_EXPOSURE_AUTO:
-		return ov7670_g_autoexp(sd, &ctrl->value);
+		if (ctrl->cur.val == V4L2_EXPOSURE_MANUAL)
+			return 0;
+		return ov7670_g_exp(sd, &info->exposure->cur.val);
 	}
 	return -EINVAL;
 }
 
-static int ov7670_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+static int ov7670_s_ctrl(struct v4l2_ctrl *ctrl)
 {
+	struct v4l2_subdev *sd = to_sd(ctrl);
+	struct ov7670_info *info = to_state(sd);
+
 	switch (ctrl->id) {
 	case V4L2_CID_BRIGHTNESS:
-		return ov7670_s_brightness(sd, ctrl->value);
+		return ov7670_s_brightness(sd, ctrl->val);
 	case V4L2_CID_CONTRAST:
-		return ov7670_s_contrast(sd, ctrl->value);
+		return ov7670_s_contrast(sd, ctrl->val);
 	case V4L2_CID_SATURATION:
-		return ov7670_s_sat(sd, ctrl->value);
-	case V4L2_CID_HUE:
-		return ov7670_s_hue(sd, ctrl->value);
+		return ov7670_s_sat_hue(sd,
+				info->saturation->val, info->hue->val);
 	case V4L2_CID_VFLIP:
-		return ov7670_s_vflip(sd, ctrl->value);
+		return ov7670_s_vflip(sd, ctrl->val);
 	case V4L2_CID_HFLIP:
-		return ov7670_s_hflip(sd, ctrl->value);
-	case V4L2_CID_GAIN:
-		return ov7670_s_gain(sd, ctrl->value);
+		return ov7670_s_hflip(sd, ctrl->val);
 	case V4L2_CID_AUTOGAIN:
-		return ov7670_s_autogain(sd, ctrl->value);
-	case V4L2_CID_EXPOSURE:
-		return ov7670_s_exp(sd, ctrl->value);
+		/* Only set manual gain if auto gain is not explicitly
+		   turned on. */
+		if (!ctrl->has_new || !ctrl->val) {
+			ctrl->val = 0;
+			/* ov7670_s_gain turns off auto gain */
+			return ov7670_s_gain(sd, info->gain->val);
+		}
+		return ov7670_s_autogain(sd, ctrl->val);
 	case V4L2_CID_EXPOSURE_AUTO:
+		/* Only set manual exposure if auto exposure is not explicitly
+		   turned on. */
+		if (!ctrl->has_new || ctrl->val == V4L2_EXPOSURE_MANUAL) {
+			ctrl->val = V4L2_EXPOSURE_MANUAL;
+			/* ov7670_s_exp turns off auto exposure */
+			return ov7670_s_exp(sd, info->exposure->val);
+		}
 		return ov7670_s_autoexp(sd,
-				(enum v4l2_exposure_auto_type) ctrl->value);
+			(enum v4l2_exposure_auto_type)ctrl->val);
 	}
 	return -EINVAL;
 }
 
+static const struct v4l2_ctrl_ops ov7670_ctrl_ops = {
+	.s_ctrl = ov7670_s_ctrl,
+	.g_volatile_ctrl = ov7670_g_volatile_ctrl,
+};
+
 static int ov7670_g_chip_ident(struct v4l2_subdev *sd,
 		struct v4l2_dbg_chip_ident *chip)
 {
@@ -1483,9 +1377,13 @@ static int ov7670_s_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *r
 
 static const struct v4l2_subdev_core_ops ov7670_core_ops = {
 	.g_chip_ident = ov7670_g_chip_ident,
-	.g_ctrl = ov7670_g_ctrl,
-	.s_ctrl = ov7670_s_ctrl,
-	.queryctrl = ov7670_queryctrl,
+	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
+	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
+	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
+	.g_ctrl = v4l2_subdev_g_ctrl,
+	.s_ctrl = v4l2_subdev_s_ctrl,
+	.queryctrl = v4l2_subdev_queryctrl,
+	.querymenu = v4l2_subdev_querymenu,
 	.reset = ov7670_reset,
 	.init = ov7670_init,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
@@ -1553,8 +1451,44 @@ static int ov7670_probe(struct i2c_client *client,
 			client->addr << 1, client->adapter->name);
 
 	info->fmt = &ov7670_formats[0];
-	info->sat = 128;	/* Review this */
 	info->clkrc = info->clock_speed / 30;
+
+	v4l2_ctrl_handler_init(&info->hdl, 10);
+	v4l2_ctrl_new_std(&info->hdl, &ov7670_ctrl_ops,
+			V4L2_CID_BRIGHTNESS, 0, 255, 1, 128);
+	v4l2_ctrl_new_std(&info->hdl, &ov7670_ctrl_ops,
+			V4L2_CID_CONTRAST, 0, 127, 1, 64);
+	v4l2_ctrl_new_std(&info->hdl, &ov7670_ctrl_ops,
+			V4L2_CID_VFLIP, 0, 1, 1, 0);
+	v4l2_ctrl_new_std(&info->hdl, &ov7670_ctrl_ops,
+			V4L2_CID_HFLIP, 0, 1, 1, 0);
+	info->saturation = v4l2_ctrl_new_std(&info->hdl, &ov7670_ctrl_ops,
+			V4L2_CID_SATURATION, 0, 256, 1, 128);
+	info->hue = v4l2_ctrl_new_std(&info->hdl, &ov7670_ctrl_ops,
+			V4L2_CID_HUE, -180, 180, 5, 0);
+	info->gain = v4l2_ctrl_new_std(&info->hdl, &ov7670_ctrl_ops,
+			V4L2_CID_GAIN, 0, 255, 1, 128);
+	info->auto_gain = v4l2_ctrl_new_std(&info->hdl, &ov7670_ctrl_ops,
+			V4L2_CID_AUTOGAIN, 0, 1, 1, 1);
+	info->exposure = v4l2_ctrl_new_std(&info->hdl, &ov7670_ctrl_ops,
+			V4L2_CID_EXPOSURE, 0, 65535, 1, 500);
+	info->auto_exposure = v4l2_ctrl_new_std_menu(&info->hdl, &ov7670_ctrl_ops,
+			V4L2_CID_EXPOSURE_AUTO, 1, 0, 0);
+	sd->ctrl_handler = &info->hdl;
+	if (info->hdl.error) {
+		int err = info->hdl.error;
+
+		v4l2_ctrl_handler_free(&info->hdl);
+		kfree(info);
+		return err;
+	}
+	info->gain->is_volatile = true;
+	info->exposure->is_volatile = true;
+	v4l2_ctrl_cluster(2, &info->auto_gain);
+	v4l2_ctrl_cluster(2, &info->auto_exposure);
+	v4l2_ctrl_cluster(2, &info->saturation);
+	v4l2_ctrl_handler_setup(&info->hdl);
+
 	return 0;
 }
 
@@ -1562,9 +1496,11 @@ static int ov7670_probe(struct i2c_client *client,
 static int ov7670_remove(struct i2c_client *client)
 {
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct ov7670_info *info = to_state(sd);
 
 	v4l2_device_unregister_subdev(sd);
-	kfree(to_state(sd));
+	v4l2_ctrl_handler_free(&info->hdl);
+	kfree(info);
 	return 0;
 }
 
-- 
1.7.0.4

