Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:49300 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758672Ab1IIRnh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Sep 2011 13:43:37 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id A8E1418B03B
	for <linux-media@vger.kernel.org>; Fri,  9 Sep 2011 19:43:35 +0200 (CEST)
Date: Fri, 9 Sep 2011 19:43:35 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 3/4] V4L: soc-camera: make (almost) all client drivers
 re-usable outside of the framework
In-Reply-To: <Pine.LNX.4.64.1109091917260.915@axis700.grange>
Message-ID: <Pine.LNX.4.64.1109091921590.915@axis700.grange>
References: <Pine.LNX.4.64.1109091917260.915@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The most important change in this patch is direct linking to struct
soc_camera_link via the client->dev.platform_data pointer. This makes most
of the soc-camera client drivers also usable outside of the soc-camera
framework. After this change all what is needed for these drivers to
function are inclusions of soc-camera headers for some convenience macros,
suitably configured platform data, which is anyway always required, and
loaded soc-camera core module for library functions. If desired, these
library functions can be made generic in the future and moved to a more
neutral location.

The only two client drivers, that still depend on soc-camera are:

mt9t031: it uses struct video_device for its PM. Since no hardware is
available, alternative methods cannot be tested.

ov6650: it uses struct soc_camera_device to pass its sense data back to
the bridge driver. A generic v4l2-subdevice approach should be developed
to perform this.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/mt9t031.c    |   29 ++++++++++++++++++----
 drivers/media/video/ov6650.c     |    2 +-
 drivers/media/video/soc_camera.c |   11 +++++++-
 drivers/media/video/tw9910.c     |   50 ++++++++++++++++++++++---------------
 include/media/soc_camera.h       |    6 ++--
 5 files changed, 68 insertions(+), 30 deletions(-)

diff --git a/drivers/media/video/mt9t031.c b/drivers/media/video/mt9t031.c
index 95cd602..0226486 100644
--- a/drivers/media/video/mt9t031.c
+++ b/drivers/media/video/mt9t031.c
@@ -22,6 +22,13 @@
 #include <media/v4l2-ctrls.h>
 
 /*
+ * ATTENTION: this driver still cannot be used outside of the soc-camera
+ * framework because of its PM implementation, using the video_device node.
+ * If hardware becomes available for testing, alternative PM approaches shall
+ * be considered and tested.
+ */
+
+/*
  * mt9t031 i2c address 0x5d
  * The platform has to define i2c_board_info and link to it from
  * struct soc_camera_link
@@ -606,6 +613,19 @@ static struct device_type mt9t031_dev_type = {
 	.pm	= &mt9t031_dev_pm_ops,
 };
 
+static int mt9t031_s_power(struct v4l2_subdev *sd, int on)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct video_device *vdev = soc_camera_i2c_to_vdev(client);
+
+	if (on)
+		vdev->dev.type = &mt9t031_dev_type;
+	else
+		vdev->dev.type = NULL;
+
+	return 0;
+}
+
 /*
  * Interface active, can use i2c. If it fails, it can indeed mean, that
  * this wasn't our capture interface, so, we wait for the right one
@@ -613,7 +633,6 @@ static struct device_type mt9t031_dev_type = {
 static int mt9t031_video_probe(struct i2c_client *client)
 {
 	struct mt9t031 *mt9t031 = to_mt9t031(client);
-	struct video_device *vdev = soc_camera_i2c_to_vdev(client);
 	s32 data;
 	int ret;
 
@@ -637,12 +656,11 @@ static int mt9t031_video_probe(struct i2c_client *client)
 	dev_info(&client->dev, "Detected a MT9T031 chip ID %x\n", data);
 
 	ret = mt9t031_idle(client);
-	if (ret < 0) {
+	if (ret < 0)
 		dev_err(&client->dev, "Failed to initialise the camera\n");
-	} else {
-		vdev->dev.type = &mt9t031_dev_type;
+	else
 		v4l2_ctrl_handler_setup(&mt9t031->hdl);
-	}
+
 	return ret;
 }
 
@@ -663,6 +681,7 @@ static const struct v4l2_ctrl_ops mt9t031_ctrl_ops = {
 
 static struct v4l2_subdev_core_ops mt9t031_subdev_core_ops = {
 	.g_chip_ident	= mt9t031_g_chip_ident,
+	.s_power	= mt9t031_s_power,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register	= mt9t031_g_register,
 	.s_register	= mt9t031_s_register,
diff --git a/drivers/media/video/ov6650.c b/drivers/media/video/ov6650.c
index 8323536..957949a 100644
--- a/drivers/media/video/ov6650.c
+++ b/drivers/media/video/ov6650.c
@@ -541,7 +541,7 @@ static u8 to_clkrc(struct v4l2_fract *timeperframe,
 static int ov6650_s_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *mf)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_device *icd = client->dev.platform_data;
+	struct soc_camera_device *icd = (struct soc_camera_device *)sd->grp_id;
 	struct soc_camera_sense *sense = icd->sense;
 	struct ov6650 *priv = to_ov6650(client);
 	bool half_scale = !is_unscaled_ok(mf->width, mf->height, &priv->rect);
diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 6bd6fd9..6818e00 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -249,6 +249,14 @@ static int soc_camera_s_std(struct file *file, void *priv, v4l2_std_id *a)
 	return v4l2_subdev_call(sd, core, s_std, *a);
 }
 
+static int soc_camera_g_std(struct file *file, void *priv, v4l2_std_id *a)
+{
+	struct soc_camera_device *icd = file->private_data;
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+
+	return v4l2_subdev_call(sd, core, g_std, a);
+}
+
 static int soc_camera_enum_fsizes(struct file *file, void *fh,
 					 struct v4l2_frmsizeenum *fsize)
 {
@@ -977,7 +985,7 @@ static int soc_camera_init_i2c(struct soc_camera_device *icd,
 		goto ei2cga;
 	}
 
-	icl->board_info->platform_data = icd;
+	icl->board_info->platform_data = icl;
 
 	subdev = v4l2_i2c_new_subdev_board(&ici->v4l2_dev, adap,
 				icl->board_info, NULL);
@@ -1376,6 +1384,7 @@ static const struct v4l2_ioctl_ops soc_camera_ioctl_ops = {
 	.vidioc_g_input		 = soc_camera_g_input,
 	.vidioc_s_input		 = soc_camera_s_input,
 	.vidioc_s_std		 = soc_camera_s_std,
+	.vidioc_g_std		 = soc_camera_g_std,
 	.vidioc_enum_framesizes  = soc_camera_enum_fsizes,
 	.vidioc_reqbufs		 = soc_camera_reqbufs,
 	.vidioc_querybuf	 = soc_camera_querybuf,
diff --git a/drivers/media/video/tw9910.c b/drivers/media/video/tw9910.c
index 5a3722b..efce537 100644
--- a/drivers/media/video/tw9910.c
+++ b/drivers/media/video/tw9910.c
@@ -230,6 +230,7 @@ struct tw9910_priv {
 	struct v4l2_subdev		subdev;
 	struct tw9910_video_info	*info;
 	const struct tw9910_scale_ctrl	*scale;
+	v4l2_std_id			norm;
 	u32				revision;
 };
 
@@ -421,12 +422,11 @@ static int tw9910_power(struct i2c_client *client, int enable)
 	return tw9910_mask_set(client, ACNTL2, ACNTL2_PDN_MASK, acntl2);
 }
 
-static const struct tw9910_scale_ctrl *tw9910_select_norm(struct soc_camera_device *icd,
+static const struct tw9910_scale_ctrl *tw9910_select_norm(v4l2_std_id norm,
 							  u32 width, u32 height)
 {
 	const struct tw9910_scale_ctrl *scale;
 	const struct tw9910_scale_ctrl *ret = NULL;
-	v4l2_std_id norm = icd->vdev->current_norm;
 	__u32 diff = 0xffffffff, tmp;
 	int size, i;
 
@@ -495,14 +495,27 @@ static int tw9910_s_stream(struct v4l2_subdev *sd, int enable)
 	return tw9910_power(client, enable);
 }
 
+static int tw9910_g_std(struct v4l2_subdev *sd, v4l2_std_id *norm)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct tw9910_priv *priv = to_tw9910(client);
+
+	*norm = priv->norm;
+
+	return 0;
+}
+
 static int tw9910_s_std(struct v4l2_subdev *sd, v4l2_std_id norm)
 {
-	int ret = -EINVAL;
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct tw9910_priv *priv = to_tw9910(client);
 
-	if (norm & (V4L2_STD_NTSC | V4L2_STD_PAL))
-		ret = 0;
+	if (!(norm & (V4L2_STD_NTSC | V4L2_STD_PAL)))
+		return -EINVAL;
 
-	return ret;
+	priv->norm = norm;
+
+	return 0;
 }
 
 static int tw9910_g_chip_ident(struct v4l2_subdev *sd,
@@ -557,14 +570,13 @@ static int tw9910_set_frame(struct v4l2_subdev *sd, u32 *width, u32 *height)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct tw9910_priv *priv = to_tw9910(client);
-	struct soc_camera_device *icd = client->dev.platform_data;
 	int ret = -EINVAL;
 	u8 val;
 
 	/*
 	 * select suitable norm
 	 */
-	priv->scale = tw9910_select_norm(icd, *width, *height);
+	priv->scale = tw9910_select_norm(priv->norm, *width, *height);
 	if (!priv->scale)
 		goto tw9910_set_fmt_error;
 
@@ -642,11 +654,11 @@ tw9910_set_fmt_error:
 static int tw9910_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_device *icd = client->dev.platform_data;
+	struct tw9910_priv *priv = to_tw9910(client);
 
 	a->c.left	= 0;
 	a->c.top	= 0;
-	if (icd->vdev->current_norm & V4L2_STD_NTSC) {
+	if (priv->norm & V4L2_STD_NTSC) {
 		a->c.width	= 640;
 		a->c.height	= 480;
 	} else {
@@ -661,11 +673,11 @@ static int tw9910_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 static int tw9910_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_device *icd = client->dev.platform_data;
+	struct tw9910_priv *priv = to_tw9910(client);
 
 	a->bounds.left			= 0;
 	a->bounds.top			= 0;
-	if (icd->vdev->current_norm & V4L2_STD_NTSC) {
+	if (priv->norm & V4L2_STD_NTSC) {
 		a->bounds.width		= 640;
 		a->bounds.height	= 480;
 	} else {
@@ -732,7 +744,7 @@ static int tw9910_try_fmt(struct v4l2_subdev *sd,
 			  struct v4l2_mbus_framefmt *mf)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_device *icd = client->dev.platform_data;
+	struct tw9910_priv *priv = to_tw9910(client);
 	const struct tw9910_scale_ctrl *scale;
 
 	if (V4L2_FIELD_ANY == mf->field) {
@@ -748,7 +760,7 @@ static int tw9910_try_fmt(struct v4l2_subdev *sd,
 	/*
 	 * select suitable norm
 	 */
-	scale = tw9910_select_norm(icd, mf->width, mf->height);
+	scale = tw9910_select_norm(priv->norm, mf->width, mf->height);
 	if (!scale)
 		return -EINVAL;
 
@@ -758,8 +770,7 @@ static int tw9910_try_fmt(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int tw9910_video_probe(struct soc_camera_device *icd,
-			      struct i2c_client *client)
+static int tw9910_video_probe(struct i2c_client *client)
 {
 	struct tw9910_priv *priv = to_tw9910(client);
 	s32 id;
@@ -792,8 +803,7 @@ static int tw9910_video_probe(struct soc_camera_device *icd,
 	dev_info(&client->dev,
 		 "tw9910 Product ID %0x:%0x\n", id, priv->revision);
 
-	icd->vdev->tvnorms      = V4L2_STD_NTSC | V4L2_STD_PAL;
-	icd->vdev->current_norm = V4L2_STD_NTSC;
+	priv->norm = V4L2_STD_NTSC;
 
 	return 0;
 }
@@ -801,6 +811,7 @@ static int tw9910_video_probe(struct soc_camera_device *icd,
 static struct v4l2_subdev_core_ops tw9910_subdev_core_ops = {
 	.g_chip_ident	= tw9910_g_chip_ident,
 	.s_std		= tw9910_s_std,
+	.g_std		= tw9910_g_std,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register	= tw9910_g_register,
 	.s_register	= tw9910_s_register,
@@ -883,7 +894,6 @@ static int tw9910_probe(struct i2c_client *client,
 {
 	struct tw9910_priv		*priv;
 	struct tw9910_video_info	*info;
-	struct soc_camera_device	*icd = client->dev.platform_data;
 	struct i2c_adapter		*adapter =
 		to_i2c_adapter(client->dev.parent);
 	struct soc_camera_link		*icl = soc_camera_i2c_to_link(client);
@@ -911,7 +921,7 @@ static int tw9910_probe(struct i2c_client *client,
 
 	v4l2_i2c_subdev_init(&priv->subdev, client, &tw9910_subdev_ops);
 
-	ret = tw9910_video_probe(icd, client);
+	ret = tw9910_video_probe(client);
 	if (ret)
 		kfree(priv);
 
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index dac5759..b1377b9 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -253,14 +253,14 @@ unsigned long soc_camera_apply_board_flags(struct soc_camera_link *icl,
 #include <linux/i2c.h>
 static inline struct video_device *soc_camera_i2c_to_vdev(const struct i2c_client *client)
 {
-	struct soc_camera_device *icd = client->dev.platform_data;
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct soc_camera_device *icd = (struct soc_camera_device *)sd->grp_id;
 	return icd ? icd->vdev : NULL;
 }
 
 static inline struct soc_camera_link *soc_camera_i2c_to_link(const struct i2c_client *client)
 {
-	struct soc_camera_device *icd = client->dev.platform_data;
-	return icd ? to_soc_camera_link(icd) : NULL;
+	return client->dev.platform_data;
 }
 
 static inline struct v4l2_subdev *soc_camera_vdev_to_subdev(const struct video_device *vdev)
-- 
1.7.2.5

