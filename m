Return-path: <mchehab@pedra>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:21550 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab1GAPEj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Jul 2011 11:04:39 -0400
Received: from eu_spt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LNN008PDTVOAX@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 01 Jul 2011 16:04:36 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LNN00JL9TVMGH@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 01 Jul 2011 16:04:35 +0100 (BST)
Date: Fri, 01 Jul 2011 17:04:30 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2 2/4] noon010pc30: Convert to the pad level ops
In-reply-to: <1309532672-17920-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, s.nawrocki@samsung.com,
	sw0312.kim@samsung.com, riverful.kim@samsung.com
Message-id: <1309532672-17920-3-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1309532672-17920-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Replace g/s_mbus_fmt ops with the pad level get/set_fmt operations.
Add media entity initialization and set subdev flags so the host driver
creates a v4l-subdev device node for the driver. A mutex is added for
serializing operations on subdevice node. When setting format
is attempted during streaming EBUSY error code will be returned.
After the device is powered up it will now remain in "power sleep"
mode until s_stream(1) is called. The "power sleep" mode is used
to suspend/resume frame generation at the sensor's output through
s_stream op. Also the data format is now retained over s_power
cycles.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/Kconfig       |    2 +-
 drivers/media/video/noon010pc30.c |  142 +++++++++++++++++++++++++------------
 2 files changed, 98 insertions(+), 46 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index ae9790e..f92b9bb 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -746,7 +746,7 @@ config VIDEO_VIA_CAMERA
 
 config VIDEO_NOON010PC30
 	tristate "NOON010PC30 CIF camera sensor support"
-	depends on I2C && VIDEO_V4L2
+	depends on I2C && VIDEO_V4L2 && EXPERIMENTAL && VIDEO_V4L2_SUBDEV_API
 	---help---
 	  This driver supports NOON010PC30 CIF camera from Siliconfile
 
diff --git a/drivers/media/video/noon010pc30.c b/drivers/media/video/noon010pc30.c
index 37eca91..3e24783 100644
--- a/drivers/media/video/noon010pc30.c
+++ b/drivers/media/video/noon010pc30.c
@@ -1,7 +1,7 @@
 /*
  * Driver for SiliconFile NOON010PC30 CIF (1/11") Image Sensor with ISP
  *
- * Copyright (C) 2010 Samsung Electronics
+ * Copyright (C) 2010 - 2011 Samsung Electronics
  * Contact: Sylwester Nawrocki, <s.nawrocki@samsung.com>
  *
  * Initial register configuration based on a driver authored by
@@ -130,14 +130,19 @@ static const char * const noon010_supply_name[] = {
 #define NOON010_NUM_SUPPLIES ARRAY_SIZE(noon010_supply_name)
 
 struct noon010_info {
+	/* A mutex protecting curr_fmt, curr_win fields and the bit flags */
+	struct mutex lock;
 	struct v4l2_subdev sd;
+	struct media_pad pad;
 	struct v4l2_ctrl_handler hdl;
 	const struct noon010pc30_platform_data *pdata;
 	const struct noon010_format *curr_fmt;
 	const struct noon010_frmsize *curr_win;
+	struct v4l2_mbus_framefmt format;
 	unsigned int hflip:1;
 	unsigned int vflip:1;
 	unsigned int power:1;
+	unsigned int streaming:1;
 	u8 i2c_reg_page;
 	struct regulator_bulk_data supply[NOON010_NUM_SUPPLIES];
 	u32 gpio_nreset;
@@ -313,6 +318,7 @@ static int noon010_enable_autowhitebalance(struct v4l2_subdev *sd, int on)
 	return ret;
 }
 
+/* Called with struct noon010_info.lock mutex held */
 static int noon010_set_flip(struct v4l2_subdev *sd, int hflip, int vflip)
 {
 	struct noon010_info *info = to_noon010(sd);
@@ -342,7 +348,7 @@ static int noon010_set_params(struct v4l2_subdev *sd)
 	struct noon010_info *info = to_noon010(sd);
 	int ret;
 
-	if (!info->curr_win)
+	if (!info->curr_win || !info->power)
 		return -EINVAL;
 
 	ret = cam_i2c_write(sd, VDO_CTL_REG(0), info->curr_win->vid_ctl1);
@@ -354,7 +360,8 @@ static int noon010_set_params(struct v4l2_subdev *sd)
 }
 
 /* Find nearest matching image pixel size. */
-static int noon010_try_frame_size(struct v4l2_mbus_framefmt *mf)
+static int noon010_try_frame_size(struct v4l2_mbus_framefmt *mf,
+				  const struct noon010_frmsize **size)
 {
 	unsigned int min_err = ~0;
 	int i = ARRAY_SIZE(noon010_sizes);
@@ -374,11 +381,14 @@ static int noon010_try_frame_size(struct v4l2_mbus_framefmt *mf)
 	if (match) {
 		mf->width  = match->width;
 		mf->height = match->height;
+		if (size)
+			*size = match;
 		return 0;
 	}
 	return -EINVAL;
 }
 
+/* Called with struct info.lock mutex held */
 static int power_enable(struct noon010_info *info)
 {
 	int ret;
@@ -419,6 +429,7 @@ static int power_enable(struct noon010_info *info)
 	return 0;
 }
 
+/* Called with struct info.lock mutex held */
 static int power_disable(struct noon010_info *info)
 {
 	int ret;
@@ -464,36 +475,42 @@ static int noon010_s_ctrl(struct v4l2_ctrl *ctrl)
 	}
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
+static int noon010_get_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+			   struct v4l2_subdev_format *fmt)
 {
 	struct noon010_info *info = to_noon010(sd);
-	int ret;
-
-	if (!mf)
-		return -EINVAL;
+	struct v4l2_mbus_framefmt *mf;
 
-	if (!info->curr_win || !info->curr_fmt) {
-		ret = noon010_set_params(sd);
-		if (ret)
-			return ret;
+	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
+		if (fh) {
+			mf = v4l2_subdev_get_try_format(fh, 0);
+			fmt->format = *mf;
+		}
+		return 0;
 	}
+	/* Active format */
+	mf = &fmt->format;
 
+	mutex_lock(&info->lock);
 	mf->width	= info->curr_win->width;
 	mf->height	= info->curr_win->height;
 	mf->code	= info->curr_fmt->code;
 	mf->colorspace	= info->curr_fmt->colorspace;
-	mf->field	= V4L2_FIELD_NONE;
+	mutex_unlock(&info->lock);
 
+	mf->field	= V4L2_FIELD_NONE;
+	mf->colorspace	= V4L2_COLORSPACE_JPEG;
 	return 0;
 }
 
@@ -503,40 +520,50 @@ static const struct noon010_format *try_fmt(struct v4l2_subdev *sd,
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
+	int ret;
 
-	if (!sd || !mf)
+	if (fmt->pad != 0)
 		return -EINVAL;
 
-	info->curr_fmt = try_fmt(sd, mf);
+	nf = try_fmt(sd, &fmt->format);
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
+	if (info->streaming) {
+		ret = -EBUSY;
+	} else {
+		info->curr_fmt = nf;
+		info->curr_win = size;
+		ret = noon010_set_params(sd);
+	}
+	mutex_unlock(&info->lock);
+	return ret;
 }
 
+/* Called with struct noon010_info.lock mutex held */
 static int noon010_base_config(struct v4l2_subdev *sd)
 {
 	struct noon010_info *info = to_noon010(sd);
@@ -550,8 +577,6 @@ static int noon010_base_config(struct v4l2_subdev *sd)
 	}
 	if (!ret)
 		ret = noon010_set_flip(sd, 1, 0);
-	if (!ret)
-		ret = noon010_power_ctrl(sd, false, false);
 
 	/* Synchronize the control handler and the registers state */
 	if (!ret)
@@ -583,6 +608,21 @@ static int noon010_s_power(struct v4l2_subdev *sd, int on)
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
+	mutex_unlock(&info->lock);
+	return ret;
+}
+
 static int noon010_g_chip_ident(struct v4l2_subdev *sd,
 				struct v4l2_dbg_chip_ident *chip)
 {
@@ -617,15 +657,19 @@ static const struct v4l2_subdev_core_ops noon010_core_ops = {
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
 
@@ -666,9 +710,11 @@ static int noon010_probe(struct i2c_client *client,
 	if (!info)
 		return -ENOMEM;
 
+	mutex_init(&info->lock);
 	sd = &info->sd;
 	strlcpy(sd->name, MODULE_NAME, sizeof(sd->name));
 	v4l2_i2c_subdev_init(sd, client, &noon010_ops);
+	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 
 	v4l2_ctrl_handler_init(&info->hdl, 3);
 
@@ -720,11 +766,17 @@ static int noon010_probe(struct i2c_client *client,
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
@@ -751,10 +803,10 @@ static int noon010_remove(struct i2c_client *client)
 
 	if (gpio_is_valid(info->gpio_nreset))
 		gpio_free(info->gpio_nreset);
-
 	if (gpio_is_valid(info->gpio_nstby))
 		gpio_free(info->gpio_nstby);
 
+	media_entity_cleanup(&sd->entity);
 	kfree(info);
 	return 0;
 }
-- 
1.7.5.4

