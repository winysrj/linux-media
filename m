Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:54543 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803Ab1IPQAF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Sep 2011 12:00:05 -0400
Received: from euspt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LRM006A0HS0C7@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 16 Sep 2011 17:00:00 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LRM00KRPHRZAI@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 16 Sep 2011 17:00:00 +0100 (BST)
Date: Fri, 16 Sep 2011 17:59:54 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v3 1/3] noon010pc30: Conversion to the media controller API
In-reply-to: <1316188796-8374-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, s.nawrocki@samsung.com,
	sw0312.kim@samsung.com, riverful.kim@samsung.com
Message-id: <1316188796-8374-2-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1316188796-8374-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace g/s_mbus_fmt ops with the pad level get/set_fmt operations.
Add media entity initialization and set subdev flags so the host driver
creates a subdev device node for the driver.
A mutex was added for serializing the subdev operations. When setting
format is attempted during streaming an (EBUSY) error will be returned.

After the device is powered up it will now remain in "power sleep"
mode until s_stream(1) is called. The "power sleep" mode is used
to suspend/resume frame generation at the sensor's output through
s_stream op.

While at here simplify the colorspace parameter handling.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/Kconfig       |    2 +-
 drivers/media/video/noon010pc30.c |  253 ++++++++++++++++++++++++-------------
 2 files changed, 164 insertions(+), 91 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 6279663..75bb46f 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -755,7 +755,7 @@ config VIDEO_VIA_CAMERA
 
 config VIDEO_NOON010PC30
 	tristate "NOON010PC30 CIF camera sensor support"
-	depends on I2C && VIDEO_V4L2
+	depends on I2C && VIDEO_V4L2 && EXPERIMENTAL && VIDEO_V4L2_SUBDEV_API
 	---help---
 	  This driver supports NOON010PC30 CIF camera from Siliconfile
 
diff --git a/drivers/media/video/noon010pc30.c b/drivers/media/video/noon010pc30.c
index 35f722a..115d976 100644
--- a/drivers/media/video/noon010pc30.c
+++ b/drivers/media/video/noon010pc30.c
@@ -1,7 +1,7 @@
 /*
  * Driver for SiliconFile NOON010PC30 CIF (1/11") Image Sensor with ISP
  *
- * Copyright (C) 2010 Samsung Electronics
+ * Copyright (C) 2010 - 2011 Samsung Electronics Co., Ltd.
  * Contact: Sylwester Nawrocki, <s.nawrocki@samsung.com>
  *
  * Initial register configuration based on a driver authored by
@@ -10,7 +10,7 @@
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later vergsion.
+ * (at your option) any later version.
  */
 
 #include <linux/delay.h>
@@ -113,7 +113,6 @@ MODULE_PARM_DESC(debug, "Enable module debug trace. Set to 1 to enable.");
 
 struct noon010_format {
 	enum v4l2_mbus_pixelcode code;
-	enum v4l2_colorspace colorspace;
 	u16 ispctl1_reg;
 };
 
@@ -131,17 +130,24 @@ static const char * const noon010_supply_name[] = {
 
 struct noon010_info {
 	struct v4l2_subdev sd;
+	struct media_pad pad;
 	struct v4l2_ctrl_handler hdl;
 	const struct noon010pc30_platform_data *pdata;
+	struct regulator_bulk_data supply[NOON010_NUM_SUPPLIES];
+	u32 gpio_nreset;
+	u32 gpio_nstby;
+
+	/* Protects the struct members below */
+	struct mutex lock;
+
 	const struct noon010_format *curr_fmt;
 	const struct noon010_frmsize *curr_win;
+	unsigned int apply_new_cfg:1;
+	unsigned int streaming:1;
 	unsigned int hflip:1;
 	unsigned int vflip:1;
 	unsigned int power:1;
 	u8 i2c_reg_page;
-	struct regulator_bulk_data supply[NOON010_NUM_SUPPLIES];
-	u32 gpio_nreset;
-	u32 gpio_nstby;
 };
 
 struct i2c_regval {
@@ -168,27 +174,11 @@ static const struct noon010_frmsize noon010_sizes[] = {
 
 /* Supported pixel formats. */
 static const struct noon010_format noon010_formats[] = {
-	{
-		.code		= V4L2_MBUS_FMT_YUYV8_2X8,
-		.colorspace	= V4L2_COLORSPACE_JPEG,
-		.ispctl1_reg	= 0x03,
-	}, {
-		.code		= V4L2_MBUS_FMT_YVYU8_2X8,
-		.colorspace	= V4L2_COLORSPACE_JPEG,
-		.ispctl1_reg	= 0x02,
-	}, {
-		.code		= V4L2_MBUS_FMT_VYUY8_2X8,
-		.colorspace	= V4L2_COLORSPACE_JPEG,
-		.ispctl1_reg	= 0,
-	}, {
-		.code		= V4L2_MBUS_FMT_UYVY8_2X8,
-		.colorspace	= V4L2_COLORSPACE_JPEG,
-		.ispctl1_reg	= 0x01,
-	}, {
-		.code		= V4L2_MBUS_FMT_RGB565_2X8_BE,
-		.colorspace	= V4L2_COLORSPACE_JPEG,
-		.ispctl1_reg	= 0x40,
-	},
+	{ V4L2_MBUS_FMT_YUYV8_2X8, 0x03 },
+	{ V4L2_MBUS_FMT_YVYU8_2X8, 0x02 },
+	{ V4L2_MBUS_FMT_VYUY8_2X8, 0 },
+	{ V4L2_MBUS_FMT_UYVY8_2X8, 0x01 },
+	{ V4L2_MBUS_FMT_RGB565_2X8_BE, 0x40},
 };
 
 static const struct i2c_regval noon010_base_regs[] = {
@@ -313,6 +303,7 @@ static int noon010_enable_autowhitebalance(struct v4l2_subdev *sd, int on)
 	return ret;
 }
 
+/* Called with struct noon010_info.lock mutex held */
 static int noon010_set_flip(struct v4l2_subdev *sd, int hflip, int vflip)
 {
 	struct noon010_info *info = to_noon010(sd);
@@ -340,21 +331,18 @@ static int noon010_set_flip(struct v4l2_subdev *sd, int hflip, int vflip)
 static int noon010_set_params(struct v4l2_subdev *sd)
 {
 	struct noon010_info *info = to_noon010(sd);
-	int ret;
-
-	if (!info->curr_win)
-		return -EINVAL;
-
-	ret = cam_i2c_write(sd, VDO_CTL_REG(0), info->curr_win->vid_ctl1);
 
-	if (!ret && info->curr_fmt)
-		ret = cam_i2c_write(sd, ISP_CTL_REG(0),
-				info->curr_fmt->ispctl1_reg);
-	return ret;
+	int ret = cam_i2c_write(sd, VDO_CTL_REG(0),
+				info->curr_win->vid_ctl1);
+	if (ret)
+		return ret;
+	return cam_i2c_write(sd, ISP_CTL_REG(0),
+			     info->curr_fmt->ispctl1_reg);
 }
 
 /* Find nearest matching image pixel size. */
-static int noon010_try_frame_size(struct v4l2_mbus_framefmt *mf)
+static int noon010_try_frame_size(struct v4l2_mbus_framefmt *mf,
+				  const struct noon010_frmsize **size)
 {
 	unsigned int min_err = ~0;
 	int i = ARRAY_SIZE(noon010_sizes);
@@ -374,11 +362,14 @@ static int noon010_try_frame_size(struct v4l2_mbus_framefmt *mf)
 	if (match) {
 		mf->width  = match->width;
 		mf->height = match->height;
+		if (size)
+			*size = match;
 		return 0;
 	}
 	return -EINVAL;
 }
 
+/* Called with info.lock mutex held */
 static int power_enable(struct noon010_info *info)
 {
 	int ret;
@@ -419,6 +410,7 @@ static int power_enable(struct noon010_info *info)
 	return 0;
 }
 
+/* Called with info.lock mutex held */
 static int power_disable(struct noon010_info *info)
 {
 	int ret;
@@ -448,93 +440,125 @@ static int power_disable(struct noon010_info *info)
 static int noon010_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct v4l2_subdev *sd = to_sd(ctrl);
+	struct noon010_info *info = to_noon010(sd);
+	int ret = 0;
 
 	v4l2_dbg(1, debug, sd, "%s: ctrl_id: %d, value: %d\n",
 		 __func__, ctrl->id, ctrl->val);
 
+	mutex_lock(&info->lock);
+	/*
+	 * If the device is not powered up by the host driver do
+	 * not apply any controls to H/W at this time. Instead
+	 * the controls will be restored right after power-up.
+	 */
+	if (!info->power)
+		goto unlock;
+
 	switch (ctrl->id) {
 	case V4L2_CID_AUTO_WHITE_BALANCE:
-		return noon010_enable_autowhitebalance(sd, ctrl->val);
+		ret = noon010_enable_autowhitebalance(sd, ctrl->val);
+		break;
 	case V4L2_CID_BLUE_BALANCE:
-		return cam_i2c_write(sd, MWB_BGAIN_REG, ctrl->val);
+		ret = cam_i2c_write(sd, MWB_BGAIN_REG, ctrl->val);
+		break;
 	case V4L2_CID_RED_BALANCE:
-		return cam_i2c_write(sd, MWB_RGAIN_REG, ctrl->val);
+		ret =  cam_i2c_write(sd, MWB_RGAIN_REG, ctrl->val);
+		break;
 	default:
-		return -EINVAL;
+		ret = -EINVAL;
 	}
+unlock:
+	mutex_unlock(&info->lock);
+	return ret;
 }
 
-static int noon010_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
-			    enum v4l2_mbus_pixelcode *code)
+static int noon010_enum_mbus_code(struct v4l2_subdev *sd,
+				  struct v4l2_subdev_fh *fh,
+				  struct v4l2_subdev_mbus_code_enum *code)
 {
-	if (!code || index >= ARRAY_SIZE(noon010_formats))
+	if (code->index >= ARRAY_SIZE(noon010_formats))
 		return -EINVAL;
 
-	*code = noon010_formats[index].code;
+	code->code = noon010_formats[code->index].code;
 	return 0;
 }
 
-static int noon010_g_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *mf)
+static void noon010_get_current_fmt(struct noon010_info *info,
+				    struct v4l2_mbus_framefmt *mf)
 {
-	struct noon010_info *info = to_noon010(sd);
-	int ret;
-
-	if (!mf)
-		return -EINVAL;
-
-	if (!info->curr_win || !info->curr_fmt) {
-		ret = noon010_set_params(sd);
-		if (ret)
-			return ret;
-	}
-
 	mf->width	= info->curr_win->width;
 	mf->height	= info->curr_win->height;
 	mf->code	= info->curr_fmt->code;
-	mf->colorspace	= info->curr_fmt->colorspace;
 	mf->field	= V4L2_FIELD_NONE;
+	mf->colorspace	= V4L2_COLORSPACE_JPEG;
+}
+
+static int noon010_get_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+			   struct v4l2_subdev_format *fmt)
+{
+	struct noon010_info *info = to_noon010(sd);
+	struct v4l2_mbus_framefmt *mf;
+
+	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
+		if (fh) {
+			mf = v4l2_subdev_get_try_format(fh, 0);
+			fmt->format = *mf;
+		}
+		return 0;
+	}
+
+	mutex_lock(&info->lock);
+	noon010_get_current_fmt(info, &fmt->format);
+	mutex_unlock(&info->lock);
 
 	return 0;
 }
 
 /* Return nearest media bus frame format. */
-static const struct noon010_format *try_fmt(struct v4l2_subdev *sd,
+static const struct noon010_format *noon010_try_fmt(struct v4l2_subdev *sd,
 					    struct v4l2_mbus_framefmt *mf)
 {
 	int i = ARRAY_SIZE(noon010_formats);
 
-	noon010_try_frame_size(mf);
-
-	while (i--)
+	while (--i)
 		if (mf->code == noon010_formats[i].code)
 			break;
-
 	mf->code = noon010_formats[i].code;
 
 	return &noon010_formats[i];
 }
 
-static int noon010_try_fmt(struct v4l2_subdev *sd,
-			   struct v4l2_mbus_framefmt *mf)
-{
-	if (!sd || !mf)
-		return -EINVAL;
-
-	try_fmt(sd, mf);
-	return 0;
-}
-
-static int noon010_s_fmt(struct v4l2_subdev *sd,
-			 struct v4l2_mbus_framefmt *mf)
+static int noon010_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+			   struct v4l2_subdev_format *fmt)
 {
 	struct noon010_info *info = to_noon010(sd);
+	const struct noon010_frmsize *size = NULL;
+	const struct noon010_format *nf;
+	struct v4l2_mbus_framefmt *mf;
+	int ret = 0;
 
-	if (!sd || !mf)
-		return -EINVAL;
-
-	info->curr_fmt = try_fmt(sd, mf);
+	nf = noon010_try_fmt(sd, &fmt->format);
+	noon010_try_frame_size(&fmt->format, &size);
+	fmt->format.colorspace = V4L2_COLORSPACE_JPEG;
 
-	return noon010_set_params(sd);
+	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
+		if (fh) {
+			mf = v4l2_subdev_get_try_format(fh, 0);
+			*mf = fmt->format;
+		}
+		return 0;
+	}
+	mutex_lock(&info->lock);
+	if (!info->streaming) {
+		info->apply_new_cfg = 1;
+		info->curr_fmt = nf;
+		info->curr_win = size;
+	} else {
+		ret = -EBUSY;
+	}
+	mutex_unlock(&info->lock);
+	return ret;
 }
 
 static int noon010_base_config(struct v4l2_subdev *sd)
@@ -550,8 +574,6 @@ static int noon010_base_config(struct v4l2_subdev *sd)
 	}
 	if (!ret)
 		ret = noon010_set_flip(sd, 1, 0);
-	if (!ret)
-		ret = noon010_power_ctrl(sd, false, false);
 
 	/* sync the handler and the registers state */
 	v4l2_ctrl_handler_setup(&to_noon010(sd)->hdl);
@@ -582,6 +604,26 @@ static int noon010_s_power(struct v4l2_subdev *sd, int on)
 	return ret;
 }
 
+static int noon010_s_stream(struct v4l2_subdev *sd, int on)
+{
+	struct noon010_info *info = to_noon010(sd);
+	int ret = 0;
+
+	mutex_lock(&info->lock);
+	if (!info->streaming != !on) {
+		ret = noon010_power_ctrl(sd, false, !on);
+		if (!ret)
+			info->streaming = on;
+	}
+	if (!ret && on && info->apply_new_cfg) {
+		ret = noon010_set_params(sd);
+		if (!ret)
+			info->apply_new_cfg = 0;
+	}
+	mutex_unlock(&info->lock);
+	return ret;
+}
+
 static int noon010_g_chip_ident(struct v4l2_subdev *sd,
 				struct v4l2_dbg_chip_ident *chip)
 {
@@ -599,6 +641,22 @@ static int noon010_log_status(struct v4l2_subdev *sd)
 	return 0;
 }
 
+static int noon010_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
+{
+	struct v4l2_mbus_framefmt *mf = v4l2_subdev_get_try_format(fh, 0);
+	struct noon010_info *info = to_noon010(sd);
+
+	mutex_lock(&info->lock);
+	noon010_get_current_fmt(to_noon010(sd), mf);
+
+	mutex_unlock(&info->lock);
+	return 0;
+}
+
+static const struct v4l2_subdev_internal_ops noon010_subdev_internal_ops = {
+	.open = noon010_open,
+};
+
 static const struct v4l2_ctrl_ops noon010_ctrl_ops = {
 	.s_ctrl = noon010_s_ctrl,
 };
@@ -616,15 +674,19 @@ static const struct v4l2_subdev_core_ops noon010_core_ops = {
 	.log_status	= noon010_log_status,
 };
 
-static const struct v4l2_subdev_video_ops noon010_video_ops = {
-	.g_mbus_fmt	= noon010_g_fmt,
-	.s_mbus_fmt	= noon010_s_fmt,
-	.try_mbus_fmt	= noon010_try_fmt,
-	.enum_mbus_fmt	= noon010_enum_fmt,
+static struct v4l2_subdev_pad_ops noon010_pad_ops = {
+	.enum_mbus_code	= noon010_enum_mbus_code,
+	.get_fmt	= noon010_get_fmt,
+	.set_fmt	= noon010_set_fmt,
+};
+
+static struct v4l2_subdev_video_ops noon010_video_ops = {
+	.s_stream	= noon010_s_stream,
 };
 
 static const struct v4l2_subdev_ops noon010_ops = {
 	.core	= &noon010_core_ops,
+	.pad	= &noon010_pad_ops,
 	.video	= &noon010_video_ops,
 };
 
@@ -665,10 +727,14 @@ static int noon010_probe(struct i2c_client *client,
 	if (!info)
 		return -ENOMEM;
 
+	mutex_init(&info->lock);
 	sd = &info->sd;
 	strlcpy(sd->name, MODULE_NAME, sizeof(sd->name));
 	v4l2_i2c_subdev_init(sd, client, &noon010_ops);
 
+	sd->internal_ops = &noon010_subdev_internal_ops;
+	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+
 	v4l2_ctrl_handler_init(&info->hdl, 3);
 
 	v4l2_ctrl_new_std(&info->hdl, &noon010_ctrl_ops,
@@ -719,11 +785,17 @@ static int noon010_probe(struct i2c_client *client,
 	if (ret)
 		goto np_reg_err;
 
+	info->pad.flags = MEDIA_PAD_FL_SOURCE;
+	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
+	ret = media_entity_init(&sd->entity, 1, &info->pad, 0);
+	if (ret < 0)
+		goto np_me_err;
+
 	ret = noon010_detect(client, info);
 	if (!ret)
 		return 0;
 
-	/* the sensor detection failed */
+np_me_err:
 	regulator_bulk_free(NOON010_NUM_SUPPLIES, info->supply);
 np_reg_err:
 	if (gpio_is_valid(info->gpio_nstby))
@@ -754,6 +826,7 @@ static int noon010_remove(struct i2c_client *client)
 	if (gpio_is_valid(info->gpio_nstby))
 		gpio_free(info->gpio_nstby);
 
+	media_entity_cleanup(&sd->entity);
 	kfree(info);
 	return 0;
 }
-- 
1.7.6

