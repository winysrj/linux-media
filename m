Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1793 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756450Ab2IGN3i (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Sep 2012 09:29:38 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 API PATCH 23/28] v4l2: make vidioc_s_crop const.
Date: Fri,  7 Sep 2012 15:29:23 +0200
Message-Id: <113cb426c62cab9795c9788fb1285e97e0811801.1347023744.git.hans.verkuil@cisco.com>
In-Reply-To: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl>
References: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <ea8cc4841a79893a29bafb9af7df2cb0f72af169.1347023744.git.hans.verkuil@cisco.com>
References: <ea8cc4841a79893a29bafb9af7df2cb0f72af169.1347023744.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Write-only ioctls should have a const argument in the ioctl op.

Do this conversion for vidioc_s_crop.

Adding const for write-only ioctls was decided during the 2012 Media Workshop.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/soc_camera/mt9m001.c             |    2 +-
 drivers/media/i2c/soc_camera/mt9m111.c             |    2 +-
 drivers/media/i2c/soc_camera/mt9t031.c             |    2 +-
 drivers/media/i2c/soc_camera/mt9t112.c             |    4 +--
 drivers/media/i2c/soc_camera/mt9v022.c             |    2 +-
 drivers/media/i2c/soc_camera/ov5642.c              |   20 ++++++------
 drivers/media/i2c/soc_camera/ov6650.c              |   32 ++++++++++----------
 drivers/media/i2c/soc_camera/rj54n1cb0c.c          |    4 +--
 drivers/media/i2c/tvp5150.c                        |    2 +-
 drivers/media/pci/bt8xx/bttv-driver.c              |   10 +++---
 drivers/media/pci/cx18/cx18-ioctl.c                |    2 +-
 drivers/media/pci/cx25821/cx25821-video.c          |    2 +-
 drivers/media/pci/cx25821/cx25821-video.h          |    2 +-
 drivers/media/pci/ivtv/ivtv-ioctl.c                |    2 +-
 drivers/media/pci/saa7134/saa7134-video.c          |   32 ++++++++++----------
 drivers/media/pci/zoran/zoran_driver.c             |    2 +-
 drivers/media/platform/davinci/vpbe_display.c      |    2 +-
 drivers/media/platform/davinci/vpfe_capture.c      |    2 +-
 drivers/media/platform/omap/omap_vout.c            |    2 +-
 drivers/media/platform/s5p-fimc/fimc-m2m.c         |    2 +-
 drivers/media/platform/s5p-g2d/g2d.c               |    2 +-
 drivers/media/platform/sh_vou.c                    |    2 +-
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |    4 +--
 drivers/media/platform/soc_camera/soc_camera.c     |    6 ++--
 drivers/media/platform/vino.c                      |    2 +-
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c           |    2 +-
 drivers/staging/media/go7007/go7007-v4l2.c         |    2 +-
 include/media/soc_camera.h                         |    4 +--
 include/media/v4l2-ioctl.h                         |    2 +-
 include/media/v4l2-subdev.h                        |    2 +-
 30 files changed, 79 insertions(+), 79 deletions(-)

diff --git a/drivers/media/i2c/soc_camera/mt9m001.c b/drivers/media/i2c/soc_camera/mt9m001.c
index d85be41..19f8a07 100644
--- a/drivers/media/i2c/soc_camera/mt9m001.c
+++ b/drivers/media/i2c/soc_camera/mt9m001.c
@@ -171,7 +171,7 @@ static int mt9m001_s_stream(struct v4l2_subdev *sd, int enable)
 	return 0;
 }
 
-static int mt9m001_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
+static int mt9m001_s_crop(struct v4l2_subdev *sd, const struct v4l2_crop *a)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct mt9m001 *mt9m001 = to_mt9m001(client);
diff --git a/drivers/media/i2c/soc_camera/mt9m111.c b/drivers/media/i2c/soc_camera/mt9m111.c
index 938c5c3..62fd94a 100644
--- a/drivers/media/i2c/soc_camera/mt9m111.c
+++ b/drivers/media/i2c/soc_camera/mt9m111.c
@@ -383,7 +383,7 @@ static int mt9m111_reset(struct mt9m111 *mt9m111)
 	return ret;
 }
 
-static int mt9m111_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
+static int mt9m111_s_crop(struct v4l2_subdev *sd, const struct v4l2_crop *a)
 {
 	struct v4l2_rect rect = a->c;
 	struct mt9m111 *mt9m111 = container_of(sd, struct mt9m111, subdev);
diff --git a/drivers/media/i2c/soc_camera/mt9t031.c b/drivers/media/i2c/soc_camera/mt9t031.c
index d74607a..40800b1 100644
--- a/drivers/media/i2c/soc_camera/mt9t031.c
+++ b/drivers/media/i2c/soc_camera/mt9t031.c
@@ -294,7 +294,7 @@ static int mt9t031_set_params(struct i2c_client *client,
 	return ret < 0 ? ret : 0;
 }
 
-static int mt9t031_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
+static int mt9t031_s_crop(struct v4l2_subdev *sd, const struct v4l2_crop *a)
 {
 	struct v4l2_rect rect = a->c;
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
diff --git a/drivers/media/i2c/soc_camera/mt9t112.c b/drivers/media/i2c/soc_camera/mt9t112.c
index 9ba428e..de7cd83 100644
--- a/drivers/media/i2c/soc_camera/mt9t112.c
+++ b/drivers/media/i2c/soc_camera/mt9t112.c
@@ -907,11 +907,11 @@ static int mt9t112_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 	return 0;
 }
 
-static int mt9t112_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
+static int mt9t112_s_crop(struct v4l2_subdev *sd, const struct v4l2_crop *a)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct mt9t112_priv *priv = to_mt9t112(client);
-	struct v4l2_rect *rect = &a->c;
+	const struct v4l2_rect *rect = &a->c;
 
 	return mt9t112_set_params(priv, rect, priv->format->code);
 }
diff --git a/drivers/media/i2c/soc_camera/mt9v022.c b/drivers/media/i2c/soc_camera/mt9v022.c
index 350d0d8..13057b9 100644
--- a/drivers/media/i2c/soc_camera/mt9v022.c
+++ b/drivers/media/i2c/soc_camera/mt9v022.c
@@ -237,7 +237,7 @@ static int mt9v022_s_stream(struct v4l2_subdev *sd, int enable)
 	return 0;
 }
 
-static int mt9v022_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
+static int mt9v022_s_crop(struct v4l2_subdev *sd, const struct v4l2_crop *a)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct mt9v022 *mt9v022 = to_mt9v022(client);
diff --git a/drivers/media/i2c/soc_camera/ov5642.c b/drivers/media/i2c/soc_camera/ov5642.c
index d886c0b..8577e0c 100644
--- a/drivers/media/i2c/soc_camera/ov5642.c
+++ b/drivers/media/i2c/soc_camera/ov5642.c
@@ -865,24 +865,24 @@ static int ov5642_g_chip_ident(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int ov5642_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
+static int ov5642_s_crop(struct v4l2_subdev *sd, const struct v4l2_crop *a)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct ov5642 *priv = to_ov5642(client);
-	struct v4l2_rect *rect = &a->c;
+	struct v4l2_rect rect = a->c;
 	int ret;
 
-	v4l_bound_align_image(&rect->width, 48, OV5642_MAX_WIDTH, 1,
-			      &rect->height, 32, OV5642_MAX_HEIGHT, 1, 0);
+	v4l_bound_align_image(&rect.width, 48, OV5642_MAX_WIDTH, 1,
+			      &rect.height, 32, OV5642_MAX_HEIGHT, 1, 0);
 
-	priv->crop_rect.width	= rect->width;
-	priv->crop_rect.height	= rect->height;
-	priv->total_width	= rect->width + BLANKING_EXTRA_WIDTH;
-	priv->total_height	= max_t(int, rect->height +
+	priv->crop_rect.width	= rect.width;
+	priv->crop_rect.height	= rect.height;
+	priv->total_width	= rect.width + BLANKING_EXTRA_WIDTH;
+	priv->total_height	= max_t(int, rect.height +
 							BLANKING_EXTRA_HEIGHT,
 							BLANKING_MIN_HEIGHT);
-	priv->crop_rect.width		= rect->width;
-	priv->crop_rect.height		= rect->height;
+	priv->crop_rect.width		= rect.width;
+	priv->crop_rect.height		= rect.height;
 
 	ret = ov5642_write_array(client, ov5642_default_regs_init);
 	if (!ret)
diff --git a/drivers/media/i2c/soc_camera/ov6650.c b/drivers/media/i2c/soc_camera/ov6650.c
index 65b031f..e87feb0 100644
--- a/drivers/media/i2c/soc_camera/ov6650.c
+++ b/drivers/media/i2c/soc_camera/ov6650.c
@@ -451,42 +451,42 @@ static int ov6650_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 	return 0;
 }
 
-static int ov6650_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
+static int ov6650_s_crop(struct v4l2_subdev *sd, const struct v4l2_crop *a)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct ov6650 *priv = to_ov6650(client);
-	struct v4l2_rect *rect = &a->c;
+	struct v4l2_rect rect = a->c;
 	int ret;
 
 	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 
-	rect->left   = ALIGN(rect->left,   2);
-	rect->width  = ALIGN(rect->width,  2);
-	rect->top    = ALIGN(rect->top,    2);
-	rect->height = ALIGN(rect->height, 2);
-	soc_camera_limit_side(&rect->left, &rect->width,
+	rect.left   = ALIGN(rect.left,   2);
+	rect.width  = ALIGN(rect.width,  2);
+	rect.top    = ALIGN(rect.top,    2);
+	rect.height = ALIGN(rect.height, 2);
+	soc_camera_limit_side(&rect.left, &rect.width,
 			DEF_HSTRT << 1, 2, W_CIF);
-	soc_camera_limit_side(&rect->top, &rect->height,
+	soc_camera_limit_side(&rect.top, &rect.height,
 			DEF_VSTRT << 1, 2, H_CIF);
 
-	ret = ov6650_reg_write(client, REG_HSTRT, rect->left >> 1);
+	ret = ov6650_reg_write(client, REG_HSTRT, rect.left >> 1);
 	if (!ret) {
-		priv->rect.left = rect->left;
+		priv->rect.left = rect.left;
 		ret = ov6650_reg_write(client, REG_HSTOP,
-				(rect->left + rect->width) >> 1);
+				(rect.left + rect.width) >> 1);
 	}
 	if (!ret) {
-		priv->rect.width = rect->width;
-		ret = ov6650_reg_write(client, REG_VSTRT, rect->top >> 1);
+		priv->rect.width = rect.width;
+		ret = ov6650_reg_write(client, REG_VSTRT, rect.top >> 1);
 	}
 	if (!ret) {
-		priv->rect.top = rect->top;
+		priv->rect.top = rect.top;
 		ret = ov6650_reg_write(client, REG_VSTOP,
-				(rect->top + rect->height) >> 1);
+				(rect.top + rect.height) >> 1);
 	}
 	if (!ret)
-		priv->rect.height = rect->height;
+		priv->rect.height = rect.height;
 
 	return ret;
 }
diff --git a/drivers/media/i2c/soc_camera/rj54n1cb0c.c b/drivers/media/i2c/soc_camera/rj54n1cb0c.c
index 32226c9..02f0400 100644
--- a/drivers/media/i2c/soc_camera/rj54n1cb0c.c
+++ b/drivers/media/i2c/soc_camera/rj54n1cb0c.c
@@ -536,11 +536,11 @@ static int rj54n1_commit(struct i2c_client *client)
 static int rj54n1_sensor_scale(struct v4l2_subdev *sd, s32 *in_w, s32 *in_h,
 			       s32 *out_w, s32 *out_h);
 
-static int rj54n1_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
+static int rj54n1_s_crop(struct v4l2_subdev *sd, const struct v4l2_crop *a)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct rj54n1 *rj54n1 = to_rj54n1(client);
-	struct v4l2_rect *rect = &a->c;
+	const struct v4l2_rect *rect = &a->c;
 	int dummy = 0, output_w, output_h,
 		input_w = rect->width, input_h = rect->height;
 	int ret;
diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index a751b6c..b5b1792 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -865,7 +865,7 @@ static int tvp5150_mbus_fmt(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int tvp5150_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
+static int tvp5150_s_crop(struct v4l2_subdev *sd, const struct v4l2_crop *a)
 {
 	struct v4l2_rect rect = a->c;
 	struct tvp5150 *decoder = to_tvp5150(sd);
diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 31b2826..16f5ca2 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -2986,7 +2986,7 @@ static int bttv_g_crop(struct file *file, void *f, struct v4l2_crop *crop)
 	return 0;
 }
 
-static int bttv_s_crop(struct file *file, void *f, struct v4l2_crop *crop)
+static int bttv_s_crop(struct file *file, void *f, const struct v4l2_crop *crop)
 {
 	struct bttv_fh *fh = f;
 	struct bttv *btv = fh->btv;
@@ -3028,17 +3028,17 @@ static int bttv_s_crop(struct file *file, void *f, struct v4l2_crop *crop)
 	}
 
 	/* Min. scaled size 48 x 32. */
-	c.rect.left = clamp(crop->c.left, b_left, b_right - 48);
+	c.rect.left = clamp_t(s32, crop->c.left, b_left, b_right - 48);
 	c.rect.left = min(c.rect.left, (__s32) MAX_HDELAY);
 
-	c.rect.width = clamp(crop->c.width,
+	c.rect.width = clamp_t(s32, crop->c.width,
 			     48, b_right - c.rect.left);
 
-	c.rect.top = clamp(crop->c.top, b_top, b_bottom - 32);
+	c.rect.top = clamp_t(s32, crop->c.top, b_top, b_bottom - 32);
 	/* Top and height must be a multiple of two. */
 	c.rect.top = (c.rect.top + 1) & ~1;
 
-	c.rect.height = clamp(crop->c.height,
+	c.rect.height = clamp_t(s32, crop->c.height,
 			      32, b_bottom - c.rect.top);
 	c.rect.height = (c.rect.height + 1) & ~1;
 
diff --git a/drivers/media/pci/cx18/cx18-ioctl.c b/drivers/media/pci/cx18/cx18-ioctl.c
index ffc00ef..c772e17 100644
--- a/drivers/media/pci/cx18/cx18-ioctl.c
+++ b/drivers/media/pci/cx18/cx18-ioctl.c
@@ -527,7 +527,7 @@ static int cx18_cropcap(struct file *file, void *fh,
 	return 0;
 }
 
-static int cx18_s_crop(struct file *file, void *fh, struct v4l2_crop *crop)
+static int cx18_s_crop(struct file *file, void *fh, const struct v4l2_crop *crop)
 {
 	struct cx18_open_id *id = fh2id(fh);
 	struct cx18 *cx = id->cx;
diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
index b38d437..0a80245 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -1610,7 +1610,7 @@ int cx25821_vidioc_cropcap(struct file *file, void *priv,
 	return 0;
 }
 
-int cx25821_vidioc_s_crop(struct file *file, void *priv, struct v4l2_crop *crop)
+int cx25821_vidioc_s_crop(struct file *file, void *priv, const struct v4l2_crop *crop)
 {
 	struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
 	struct cx25821_fh *fh = priv;
diff --git a/drivers/media/pci/cx25821/cx25821-video.h b/drivers/media/pci/cx25821/cx25821-video.h
index 9652a5e..c265e35 100644
--- a/drivers/media/pci/cx25821/cx25821-video.h
+++ b/drivers/media/pci/cx25821/cx25821-video.h
@@ -177,7 +177,7 @@ extern int cx25821_set_control(struct cx25821_dev *dev,
 extern int cx25821_vidioc_cropcap(struct file *file, void *fh,
 				  struct v4l2_cropcap *cropcap);
 extern int cx25821_vidioc_s_crop(struct file *file, void *priv,
-				 struct v4l2_crop *crop);
+				 const struct v4l2_crop *crop);
 extern int cx25821_vidioc_g_crop(struct file *file, void *priv,
 				 struct v4l2_crop *crop);
 
diff --git a/drivers/media/pci/ivtv/ivtv-ioctl.c b/drivers/media/pci/ivtv/ivtv-ioctl.c
index d5cbb61..ed6dcc7 100644
--- a/drivers/media/pci/ivtv/ivtv-ioctl.c
+++ b/drivers/media/pci/ivtv/ivtv-ioctl.c
@@ -874,7 +874,7 @@ static int ivtv_cropcap(struct file *file, void *fh, struct v4l2_cropcap *cropca
 	return 0;
 }
 
-static int ivtv_s_crop(struct file *file, void *fh, struct v4l2_crop *crop)
+static int ivtv_s_crop(struct file *file, void *fh, const struct v4l2_crop *crop)
 {
 	struct ivtv_open_id *id = fh2id(fh);
 	struct ivtv *itv = id->itv;
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 135bfd8..22f8758 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -1953,11 +1953,12 @@ static int saa7134_g_crop(struct file *file, void *f, struct v4l2_crop *crop)
 	return 0;
 }
 
-static int saa7134_s_crop(struct file *file, void *f, struct v4l2_crop *crop)
+static int saa7134_s_crop(struct file *file, void *f, const struct v4l2_crop *crop)
 {
 	struct saa7134_fh *fh = f;
 	struct saa7134_dev *dev = fh->dev;
 	struct v4l2_rect *b = &dev->crop_bounds;
+	struct v4l2_rect *c = &dev->crop_current;
 
 	if (crop->type != V4L2_BUF_TYPE_VIDEO_CAPTURE &&
 	    crop->type != V4L2_BUF_TYPE_VIDEO_OVERLAY)
@@ -1972,21 +1973,20 @@ static int saa7134_s_crop(struct file *file, void *f, struct v4l2_crop *crop)
 	if (res_locked(fh->dev, RESOURCE_VIDEO))
 		return -EBUSY;
 
-	if (crop->c.top < b->top)
-		crop->c.top = b->top;
-	if (crop->c.top > b->top + b->height)
-		crop->c.top = b->top + b->height;
-	if (crop->c.height > b->top - crop->c.top + b->height)
-		crop->c.height = b->top - crop->c.top + b->height;
-
-	if (crop->c.left < b->left)
-		crop->c.left = b->left;
-	if (crop->c.left > b->left + b->width)
-		crop->c.left = b->left + b->width;
-	if (crop->c.width > b->left - crop->c.left + b->width)
-		crop->c.width = b->left - crop->c.left + b->width;
-
-	dev->crop_current = crop->c;
+	*c = crop->c;
+	if (c->top < b->top)
+		c->top = b->top;
+	if (c->top > b->top + b->height)
+		c->top = b->top + b->height;
+	if (c->height > b->top - c->top + b->height)
+		c->height = b->top - c->top + b->height;
+
+	if (c->left < b->left)
+		c->left = b->left;
+	if (c->left > b->left + b->width)
+		c->left = b->left + b->width;
+	if (c->width > b->left - c->left + b->width)
+		c->width = b->left - c->left + b->width;
 	return 0;
 }
 
diff --git a/drivers/media/pci/zoran/zoran_driver.c b/drivers/media/pci/zoran/zoran_driver.c
index 9ecd7d7..53f12c7 100644
--- a/drivers/media/pci/zoran/zoran_driver.c
+++ b/drivers/media/pci/zoran/zoran_driver.c
@@ -2598,7 +2598,7 @@ gcrop_unlock_and_return:
 	return res;
 }
 
-static int zoran_s_crop(struct file *file, void *__fh, struct v4l2_crop *crop)
+static int zoran_s_crop(struct file *file, void *__fh, const struct v4l2_crop *crop)
 {
 	struct zoran_fh *fh = __fh;
 	struct zoran *zr = fh->zr;
diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index 3a50547..c7e5fd9 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -630,7 +630,7 @@ static int vpbe_display_querycap(struct file *file, void  *priv,
 }
 
 static int vpbe_display_s_crop(struct file *file, void *priv,
-			     struct v4l2_crop *crop)
+			     const struct v4l2_crop *crop)
 {
 	struct vpbe_fh *fh = file->private_data;
 	struct vpbe_layer *layer = fh->layer;
diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
index 843b138..4c2fa24 100644
--- a/drivers/media/platform/davinci/vpfe_capture.c
+++ b/drivers/media/platform/davinci/vpfe_capture.c
@@ -1666,7 +1666,7 @@ static int vpfe_g_crop(struct file *file, void *priv,
 }
 
 static int vpfe_s_crop(struct file *file, void *priv,
-			     struct v4l2_crop *crop)
+			     const struct v4l2_crop *crop)
 {
 	struct vpfe_device *vpfe_dev = video_drvdata(file);
 	int ret = 0;
diff --git a/drivers/media/platform/omap/omap_vout.c b/drivers/media/platform/omap/omap_vout.c
index 92845f8..36c3be8 100644
--- a/drivers/media/platform/omap/omap_vout.c
+++ b/drivers/media/platform/omap/omap_vout.c
@@ -1291,7 +1291,7 @@ static int vidioc_g_crop(struct file *file, void *fh, struct v4l2_crop *crop)
 	return 0;
 }
 
-static int vidioc_s_crop(struct file *file, void *fh, struct v4l2_crop *crop)
+static int vidioc_s_crop(struct file *file, void *fh, const struct v4l2_crop *crop)
 {
 	int ret = -EINVAL;
 	struct omap_vout_device *vout = fh;
diff --git a/drivers/media/platform/s5p-fimc/fimc-m2m.c b/drivers/media/platform/s5p-fimc/fimc-m2m.c
index c587011..b1681bd 100644
--- a/drivers/media/platform/s5p-fimc/fimc-m2m.c
+++ b/drivers/media/platform/s5p-fimc/fimc-m2m.c
@@ -551,7 +551,7 @@ static int fimc_m2m_try_crop(struct fimc_ctx *ctx, struct v4l2_crop *cr)
 	return 0;
 }
 
-static int fimc_m2m_s_crop(struct file *file, void *fh, struct v4l2_crop *cr)
+static int fimc_m2m_s_crop(struct file *file, void *fh, const struct v4l2_crop *cr)
 {
 	struct fimc_ctx *ctx = fh_to_ctx(fh);
 	struct fimc_dev *fimc = ctx->fimc_dev;
diff --git a/drivers/media/platform/s5p-g2d/g2d.c b/drivers/media/platform/s5p-g2d/g2d.c
index 0edc2df..c490f21 100644
--- a/drivers/media/platform/s5p-g2d/g2d.c
+++ b/drivers/media/platform/s5p-g2d/g2d.c
@@ -528,7 +528,7 @@ static int vidioc_try_crop(struct file *file, void *prv, struct v4l2_crop *cr)
 	return 0;
 }
 
-static int vidioc_s_crop(struct file *file, void *prv, struct v4l2_crop *cr)
+static int vidioc_s_crop(struct file *file, void *prv, const struct v4l2_crop *cr)
 {
 	struct g2d_ctx *ctx = prv;
 	struct g2d_frame *f;
diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index 9f62fd8..00cd52c 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -933,7 +933,7 @@ static int sh_vou_g_crop(struct file *file, void *fh, struct v4l2_crop *a)
 }
 
 /* Assume a dull encoder, do all the work ourselves. */
-static int sh_vou_s_crop(struct file *file, void *fh, struct v4l2_crop *a)
+static int sh_vou_s_crop(struct file *file, void *fh, const struct v4l2_crop *a)
 {
 	struct video_device *vdev = video_devdata(file);
 	struct sh_vou_device *vou_dev = video_get_drvdata(vdev);
diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
index 0baaf94..0a24253 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
@@ -1263,7 +1263,7 @@ static void update_subrect(struct sh_mobile_ceu_cam *cam)
  * 3. if (2) failed, try to request the maximum image
  */
 static int client_s_crop(struct soc_camera_device *icd, struct v4l2_crop *crop,
-			 struct v4l2_crop *cam_crop)
+			 const struct v4l2_crop *cam_crop)
 {
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct v4l2_rect *rect = &crop->c, *cam_rect = &cam_crop->c;
@@ -1517,7 +1517,7 @@ static int client_scale(struct soc_camera_device *icd,
  * scaling and cropping algorithms and for the meaning of referenced here steps.
  */
 static int sh_mobile_ceu_set_crop(struct soc_camera_device *icd,
-				  struct v4l2_crop *a)
+				  const struct v4l2_crop *a)
 {
 	struct v4l2_rect *rect = &a->c;
 	struct device *dev = icd->parent;
diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 10b57f8..f6b1c1f 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -888,11 +888,11 @@ static int soc_camera_g_crop(struct file *file, void *fh,
  * retrieve it.
  */
 static int soc_camera_s_crop(struct file *file, void *fh,
-			     struct v4l2_crop *a)
+			     const struct v4l2_crop *a)
 {
 	struct soc_camera_device *icd = file->private_data;
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
-	struct v4l2_rect *rect = &a->c;
+	const struct v4l2_rect *rect = &a->c;
 	struct v4l2_crop current_crop;
 	int ret;
 
@@ -1289,7 +1289,7 @@ static int default_g_crop(struct soc_camera_device *icd, struct v4l2_crop *a)
 	return v4l2_subdev_call(sd, video, g_crop, a);
 }
 
-static int default_s_crop(struct soc_camera_device *icd, struct v4l2_crop *a)
+static int default_s_crop(struct soc_camera_device *icd, const struct v4l2_crop *a)
 {
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	return v4l2_subdev_call(sd, video, s_crop, a);
diff --git a/drivers/media/platform/vino.c b/drivers/media/platform/vino.c
index aae1720..790d96c 100644
--- a/drivers/media/platform/vino.c
+++ b/drivers/media/platform/vino.c
@@ -3284,7 +3284,7 @@ static int vino_g_crop(struct file *file, void *__fh,
 }
 
 static int vino_s_crop(struct file *file, void *__fh,
-			    struct v4l2_crop *c)
+			    const struct v4l2_crop *c)
 {
 	struct vino_channel_settings *vcs = video_drvdata(file);
 	unsigned long flags;
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
index 7a445b0..db249ca 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
@@ -760,7 +760,7 @@ static int pvr2_g_crop(struct file *file, void *priv, struct v4l2_crop *crop)
 	return 0;
 }
 
-static int pvr2_s_crop(struct file *file, void *priv, struct v4l2_crop *crop)
+static int pvr2_s_crop(struct file *file, void *priv, const struct v4l2_crop *crop)
 {
 	struct pvr2_v4l2_fh *fh = file->private_data;
 	struct pvr2_hdw *hdw = fh->channel.mc_head->hdw;
diff --git a/drivers/staging/media/go7007/go7007-v4l2.c b/drivers/staging/media/go7007/go7007-v4l2.c
index f1dff3d..980371b 100644
--- a/drivers/staging/media/go7007/go7007-v4l2.c
+++ b/drivers/staging/media/go7007/go7007-v4l2.c
@@ -1372,7 +1372,7 @@ static int vidioc_g_crop(struct file *file, void *priv, struct v4l2_crop *crop)
 
 /* FIXME: vidioc_s_crop is not really implemented!!!
  */
-static int vidioc_s_crop(struct file *file, void *priv, struct v4l2_crop *crop)
+static int vidioc_s_crop(struct file *file, void *priv, const struct v4l2_crop *crop)
 {
 	if (crop->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 435e7b8..6442edc 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -85,14 +85,14 @@ struct soc_camera_host_ops {
 	void (*put_formats)(struct soc_camera_device *);
 	int (*cropcap)(struct soc_camera_device *, struct v4l2_cropcap *);
 	int (*get_crop)(struct soc_camera_device *, struct v4l2_crop *);
-	int (*set_crop)(struct soc_camera_device *, struct v4l2_crop *);
+	int (*set_crop)(struct soc_camera_device *, const struct v4l2_crop *);
 	int (*get_selection)(struct soc_camera_device *, struct v4l2_selection *);
 	int (*set_selection)(struct soc_camera_device *, struct v4l2_selection *);
 	/*
 	 * The difference to .set_crop() is, that .set_livecrop is not allowed
 	 * to change the output sizes
 	 */
-	int (*set_livecrop)(struct soc_camera_device *, struct v4l2_crop *);
+	int (*set_livecrop)(struct soc_camera_device *, const struct v4l2_crop *);
 	int (*set_fmt)(struct soc_camera_device *, struct v4l2_format *);
 	int (*try_fmt)(struct soc_camera_device *, struct v4l2_format *);
 	void (*init_videobuf)(struct videobuf_queue *,
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index fbeb00e..e48b571 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -186,7 +186,7 @@ struct v4l2_ioctl_ops {
 	int (*vidioc_g_crop)           (struct file *file, void *fh,
 					struct v4l2_crop *a);
 	int (*vidioc_s_crop)           (struct file *file, void *fh,
-					struct v4l2_crop *a);
+					const struct v4l2_crop *a);
 	int (*vidioc_g_selection)      (struct file *file, void *fh,
 					struct v4l2_selection *s);
 	int (*vidioc_s_selection)      (struct file *file, void *fh,
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 279bd8d..0563339 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -286,7 +286,7 @@ struct v4l2_subdev_video_ops {
 	int (*s_stream)(struct v4l2_subdev *sd, int enable);
 	int (*cropcap)(struct v4l2_subdev *sd, struct v4l2_cropcap *cc);
 	int (*g_crop)(struct v4l2_subdev *sd, struct v4l2_crop *crop);
-	int (*s_crop)(struct v4l2_subdev *sd, struct v4l2_crop *crop);
+	int (*s_crop)(struct v4l2_subdev *sd, const struct v4l2_crop *crop);
 	int (*g_parm)(struct v4l2_subdev *sd, struct v4l2_streamparm *param);
 	int (*s_parm)(struct v4l2_subdev *sd, struct v4l2_streamparm *param);
 	int (*g_frame_interval)(struct v4l2_subdev *sd,
-- 
1.7.10.4

