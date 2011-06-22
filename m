Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:11449 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932246Ab1FVPoh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2011 11:44:37 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from spt2.w1.samsung.com ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LN700F3E7QCCY20@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 22 Jun 2011 16:44:36 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LN700H7Z7QBNB@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 22 Jun 2011 16:44:35 +0100 (BST)
Date: Wed, 22 Jun 2011 17:44:29 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 2/3] noon010pc30: Convert to the pad level ops
In-reply-to: <1308757470-24421-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, s.nawrocki@samsung.com,
	sw0312.kim@samsung.com, riverful.kim@samsung.com
Message-id: <1308757470-24421-3-git-send-email-s.nawrocki@samsung.com>
References: <1308757470-24421-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Replace g/s_mbus_fmt ops with the pad level get/set_fmt operations.
Add media entity initalization and set subdev flags so the host driver
creates a v4l-subdev device node for the driver. A mutex is added for
serializing operations on subdevice node. When setting format
is attempted during streaming EBUSY error code will be returned.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/Kconfig       |    2 +-
 drivers/media/video/noon010pc30.c |  130 +++++++++++++++++++++++++------------
 2 files changed, 90 insertions(+), 42 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 8de3476..b505120 100644
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
index 50ca097..6920cc4 100644
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
+	/* Mutex protecting this data structure and subdev operations */
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
@@ -342,7 +347,7 @@ static int noon010_set_params(struct v4l2_subdev *sd)
 	struct noon010_info *info = to_noon010(sd);
 	int ret;
 
-	if (!info->curr_win)
+	if (!info->curr_win || !info->power)
 		return -EINVAL;
 
 	ret = cam_i2c_write(sd, VDO_CTL_REG(0), info->curr_win->vid_ctl1);
@@ -354,7 +359,8 @@ static int noon010_set_params(struct v4l2_subdev *sd)
 }
 
 /* Find nearest matching image pixel size. */
-static int noon010_try_frame_size(struct v4l2_mbus_framefmt *mf)
+static int noon010_try_frame_size(struct v4l2_mbus_framefmt *mf,
+				  const struct noon010_frmsize **size)
 {
 	unsigned int min_err = ~0;
 	int i = ARRAY_SIZE(noon010_sizes);
@@ -374,6 +380,8 @@ static int noon010_try_frame_size(struct v4l2_mbus_framefmt *mf)
 	if (match) {
 		mf->width  = match->width;
 		mf->height = match->height;
+		if (size)
+			*size = match;
 		return 0;
 	}
 	return -EINVAL;
@@ -464,36 +472,45 @@ static int noon010_s_ctrl(struct v4l2_ctrl *ctrl)
 	}
 }
 
-static int noon010_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
-			    enum v4l2_mbus_pixelcode *code)
+static int noon010_enum_mbus_code(struct v4l2_subdev *sd,
+				  struct v4l2_subdev_fh *fh,
+				  struct v4l2_subdev_mbus_code_enum *code)
 {
-	if (!code || index >= ARRAY_SIZE(noon010_formats))
+	if (!code || code->index >= ARRAY_SIZE(noon010_formats))
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
+	struct v4l2_mbus_framefmt *mf;
 
-	if (!mf)
+	if (fmt->pad != 0)
 		return -EINVAL;
 
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
 
@@ -503,38 +520,47 @@ static const struct noon010_format *try_fmt(struct v4l2_subdev *sd,
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
 
 static int noon010_base_config(struct v4l2_subdev *sd)
@@ -583,6 +609,17 @@ static int noon010_s_power(struct v4l2_subdev *sd, int on)
 	return ret;
 }
 
+static int noon010_s_stream(struct v4l2_subdev *sd, int on)
+{
+	struct noon010_info *info = to_noon010(sd);
+
+	mutex_lock(&info->lock);
+	info->streaming = on;
+	mutex_unlock(&info->lock);
+
+	return 0;
+}
+
 static int noon010_g_chip_ident(struct v4l2_subdev *sd,
 				struct v4l2_dbg_chip_ident *chip)
 {
@@ -617,15 +654,19 @@ static const struct v4l2_subdev_core_ops noon010_core_ops = {
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
 
@@ -666,9 +707,11 @@ static int noon010_probe(struct i2c_client *client,
 	if (!info)
 		return -ENOMEM;
 
+	mutex_init(&info->lock);
 	sd = &info->sd;
 	strlcpy(sd->name, MODULE_NAME, sizeof(sd->name));
 	v4l2_i2c_subdev_init(sd, client, &noon010_ops);
+	sd->flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
 
 	v4l2_ctrl_handler_init(&info->hdl, 3);
 
@@ -720,11 +763,16 @@ static int noon010_probe(struct i2c_client *client,
 	if (ret)
 		goto np_reg_err;
 
+	info->pad.flags = MEDIA_PAD_FL_SOURCE;
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
@@ -751,10 +799,10 @@ static int noon010_remove(struct i2c_client *client)
 
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

