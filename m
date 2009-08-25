Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:38145 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752672AbZHYLFv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2009 07:05:51 -0400
Received: from lyakh (helo=localhost)
	by axis700.grange with local-esmtp (Exim 4.63)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1Mftqh-0001mx-Nm
	for linux-media@vger.kernel.org; Tue, 25 Aug 2009 13:05:59 +0200
Date: Tue, 25 Aug 2009 13:05:59 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/3] soc-camera: remove .gain and .exposure struct
 soc_camera_device members
In-Reply-To: <Pine.LNX.4.64.0908251258410.4810@axis700.grange>
Message-ID: <Pine.LNX.4.64.0908251302520.4810@axis700.grange>
References: <Pine.LNX.4.64.0908251258410.4810@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This makes the soc-camera interface for V4L2 subdevices thinner yet. Handle
gain and exposure internally in each driver just like all other controls.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/mt9m001.c    |   43 ++++++++++++++++++++++++-------------
 drivers/media/video/mt9m111.c    |   20 ++++++++++++++---
 drivers/media/video/mt9t031.c    |   37 +++++++++++++++++++++-----------
 drivers/media/video/mt9v022.c    |   43 ++++++++++++++++++++++++++++---------
 drivers/media/video/soc_camera.c |   19 ----------------
 include/media/soc_camera.h       |    2 -
 6 files changed, 100 insertions(+), 64 deletions(-)

diff --git a/drivers/media/video/mt9m001.c b/drivers/media/video/mt9m001.c
index 4b39479..45388d2 100644
--- a/drivers/media/video/mt9m001.c
+++ b/drivers/media/video/mt9m001.c
@@ -80,6 +80,8 @@ struct mt9m001 {
 	struct v4l2_rect rect;	/* Sensor window */
 	__u32 fourcc;
 	int model;	/* V4L2_IDENT_MT9M001* codes from v4l2-chip-ident.h */
+	unsigned int gain;
+	unsigned int exposure;
 	unsigned char autoexposure;
 };
 
@@ -129,8 +131,8 @@ static int mt9m001_init(struct i2c_client *client)
 	dev_dbg(&client->dev, "%s\n", __func__);
 
 	/*
-	 * We don't know, whether platform provides reset,
-	 * issue a soft reset too
+	 * We don't know, whether platform provides reset, issue a soft reset
+	 * too. This returns all registers to their default values.
 	 */
 	ret = reg_write(client, MT9M001_RESET, 1);
 	if (!ret)
@@ -200,6 +202,7 @@ static int mt9m001_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 	struct soc_camera_device *icd = client->dev.platform_data;
 	int ret;
 	const u16 hblank = 9, vblank = 25;
+	unsigned int total_h;
 
 	if (mt9m001->fourcc == V4L2_PIX_FMT_SBGGR8 ||
 	    mt9m001->fourcc == V4L2_PIX_FMT_SBGGR16)
@@ -219,6 +222,8 @@ static int mt9m001_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 	soc_camera_limit_side(&rect.top, &rect.height,
 		     MT9M001_ROW_SKIP, MT9M001_MIN_HEIGHT, MT9M001_MAX_HEIGHT);
 
+	total_h = rect.height + icd->y_skip_top + vblank;
+
 	/* Blanking and start values - default... */
 	ret = reg_write(client, MT9M001_HORIZONTAL_BLANKING, hblank);
 	if (!ret)
@@ -236,15 +241,13 @@ static int mt9m001_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 		ret = reg_write(client, MT9M001_WINDOW_HEIGHT,
 				rect.height + icd->y_skip_top - 1);
 	if (!ret && mt9m001->autoexposure) {
-		ret = reg_write(client, MT9M001_SHUTTER_WIDTH,
-				rect.height + icd->y_skip_top + vblank);
+		ret = reg_write(client, MT9M001_SHUTTER_WIDTH, total_h);
 		if (!ret) {
 			const struct v4l2_queryctrl *qctrl =
 				soc_camera_find_qctrl(icd->ops,
 						      V4L2_CID_EXPOSURE);
-			icd->exposure = (524 + (rect.height + icd->y_skip_top +
-						vblank - 1) *
-					 (qctrl->maximum - qctrl->minimum)) /
+			mt9m001->exposure = (524 + (total_h - 1) *
+				 (qctrl->maximum - qctrl->minimum)) /
 				1048 + qctrl->minimum;
 		}
 	}
@@ -457,6 +460,12 @@ static int mt9m001_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 	case V4L2_CID_EXPOSURE_AUTO:
 		ctrl->value = mt9m001->autoexposure;
 		break;
+	case V4L2_CID_GAIN:
+		ctrl->value = mt9m001->gain;
+		break;
+	case V4L2_CID_EXPOSURE:
+		ctrl->value = mt9m001->exposure;
+		break;
 	}
 	return 0;
 }
@@ -518,7 +527,7 @@ static int mt9m001_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 		}
 
 		/* Success */
-		icd->gain = ctrl->value;
+		mt9m001->gain = ctrl->value;
 		break;
 	case V4L2_CID_EXPOSURE:
 		/* mt9m001 has maximum == default */
@@ -535,21 +544,21 @@ static int mt9m001_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 				shutter);
 			if (reg_write(client, MT9M001_SHUTTER_WIDTH, shutter) < 0)
 				return -EIO;
-			icd->exposure = ctrl->value;
+			mt9m001->exposure = ctrl->value;
 			mt9m001->autoexposure = 0;
 		}
 		break;
 	case V4L2_CID_EXPOSURE_AUTO:
 		if (ctrl->value) {
 			const u16 vblank = 25;
+			unsigned int total_h = mt9m001->rect.height +
+				icd->y_skip_top + vblank;
 			if (reg_write(client, MT9M001_SHUTTER_WIDTH,
-				      mt9m001->rect.height +
-				      icd->y_skip_top + vblank) < 0)
+				      total_h) < 0)
 				return -EIO;
 			qctrl = soc_camera_find_qctrl(icd->ops, V4L2_CID_EXPOSURE);
-			icd->exposure = (524 + (mt9m001->rect.height +
-						icd->y_skip_top + vblank - 1) *
-					 (qctrl->maximum - qctrl->minimum)) /
+			mt9m001->exposure = (524 + (total_h - 1) *
+				 (qctrl->maximum - qctrl->minimum)) /
 				1048 + qctrl->minimum;
 			mt9m001->autoexposure = 1;
 		} else
@@ -629,6 +638,10 @@ static int mt9m001_video_probe(struct soc_camera_device *icd,
 	if (ret < 0)
 		dev_err(&client->dev, "Failed to initialise the camera\n");
 
+	/* mt9m001_init() has reset the chip, returning registers to defaults */
+	mt9m001->gain = 64;
+	mt9m001->exposure = 255;
+
 	return ret;
 }
 
@@ -701,7 +714,7 @@ static int mt9m001_probe(struct i2c_client *client,
 
 	/* Second stage probe - when a capture adapter is there */
 	icd->ops		= &mt9m001_ops;
-	icd->y_skip_top		= 1;
+	icd->y_skip_top		= 0;
 
 	mt9m001->rect.left	= MT9M001_COLUMN_SKIP;
 	mt9m001->rect.top	= MT9M001_ROW_SKIP;
diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index 186902f..3ec6e4a 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -153,6 +153,7 @@ struct mt9m111 {
 	enum mt9m111_context context;
 	struct v4l2_rect rect;
 	u32 pixfmt;
+	unsigned int gain;
 	unsigned char autoexposure;
 	unsigned char datawidth;
 	unsigned int powered:1;
@@ -672,8 +673,10 @@ static const struct v4l2_queryctrl mt9m111_controls[] = {
 };
 
 static int mt9m111_resume(struct soc_camera_device *icd);
+static int mt9m111_suspend(struct soc_camera_device *icd, pm_message_t state);
 
 static struct soc_camera_ops mt9m111_ops = {
+	.suspend		= mt9m111_suspend,
 	.resume			= mt9m111_resume,
 	.query_bus_param	= mt9m111_query_bus_param,
 	.set_bus_param		= mt9m111_set_bus_param,
@@ -714,13 +717,13 @@ static int mt9m111_get_global_gain(struct i2c_client *client)
 
 static int mt9m111_set_global_gain(struct i2c_client *client, int gain)
 {
-	struct soc_camera_device *icd = client->dev.platform_data;
+	struct mt9m111 *mt9m111 = to_mt9m111(client);
 	u16 val;
 
 	if (gain > 63 * 2 * 2)
 		return -EINVAL;
 
-	icd->gain = gain;
+	mt9m111->gain = gain;
 	if ((gain >= 64 * 2) && (gain < 63 * 2 * 2))
 		val = (1 << 10) | (1 << 9) | (gain / 4);
 	else if ((gain >= 64) && (gain < 64 * 2))
@@ -844,17 +847,26 @@ static int mt9m111_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 	return ret;
 }
 
+static int mt9m111_suspend(struct soc_camera_device *icd, pm_message_t state)
+{
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct mt9m111 *mt9m111 = to_mt9m111(client);
+
+	mt9m111->gain = mt9m111_get_global_gain(client);
+
+	return 0;
+}
+
 static int mt9m111_restore_state(struct i2c_client *client)
 {
 	struct mt9m111 *mt9m111 = to_mt9m111(client);
-	struct soc_camera_device *icd = client->dev.platform_data;
 
 	mt9m111_set_context(client, mt9m111->context);
 	mt9m111_set_pixfmt(client, mt9m111->pixfmt);
 	mt9m111_setup_rect(client, &mt9m111->rect);
 	mt9m111_set_flip(client, mt9m111->hflip, MT9M111_RMB_MIRROR_COLS);
 	mt9m111_set_flip(client, mt9m111->vflip, MT9M111_RMB_MIRROR_ROWS);
-	mt9m111_set_global_gain(client, icd->gain);
+	mt9m111_set_global_gain(client, mt9m111->gain);
 	mt9m111_set_autoexposure(client, mt9m111->autoexposure);
 	mt9m111_set_autowhitebalance(client, mt9m111->autowhitebalance);
 	return 0;
diff --git a/drivers/media/video/mt9t031.c b/drivers/media/video/mt9t031.c
index 9a64896..6966f64 100644
--- a/drivers/media/video/mt9t031.c
+++ b/drivers/media/video/mt9t031.c
@@ -73,6 +73,8 @@ struct mt9t031 {
 	int model;	/* V4L2_IDENT_MT9T031* codes from v4l2-chip-ident.h */
 	u16 xskip;
 	u16 yskip;
+	unsigned int gain;
+	unsigned int exposure;
 	unsigned char autoexposure;
 };
 
@@ -301,16 +303,15 @@ static int mt9t031_set_params(struct soc_camera_device *icd,
 		ret = reg_write(client, MT9T031_WINDOW_HEIGHT,
 				rect->height + icd->y_skip_top - 1);
 	if (ret >= 0 && mt9t031->autoexposure) {
-		ret = set_shutter(client,
-				  rect->height + icd->y_skip_top + vblank);
+		unsigned int total_h = rect->height + icd->y_skip_top + vblank;
+		ret = set_shutter(client, total_h);
 		if (ret >= 0) {
 			const u32 shutter_max = MT9T031_MAX_HEIGHT + vblank;
 			const struct v4l2_queryctrl *qctrl =
 				soc_camera_find_qctrl(icd->ops,
 						      V4L2_CID_EXPOSURE);
-			icd->exposure = (shutter_max / 2 + (rect->height +
-					 icd->y_skip_top + vblank - 1) *
-					 (qctrl->maximum - qctrl->minimum)) /
+			mt9t031->exposure = (shutter_max / 2 + (total_h - 1) *
+				 (qctrl->maximum - qctrl->minimum)) /
 				shutter_max + qctrl->minimum;
 		}
 	}
@@ -553,6 +554,12 @@ static int mt9t031_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 	case V4L2_CID_EXPOSURE_AUTO:
 		ctrl->value = mt9t031->autoexposure;
 		break;
+	case V4L2_CID_GAIN:
+		ctrl->value = mt9t031->gain;
+		break;
+	case V4L2_CID_EXPOSURE:
+		ctrl->value = mt9t031->exposure;
+		break;
 	}
 	return 0;
 }
@@ -624,7 +631,7 @@ static int mt9t031_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 		}
 
 		/* Success */
-		icd->gain = ctrl->value;
+		mt9t031->gain = ctrl->value;
 		break;
 	case V4L2_CID_EXPOSURE:
 		/* mt9t031 has maximum == default */
@@ -641,7 +648,7 @@ static int mt9t031_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 				old, shutter);
 			if (set_shutter(client, shutter) < 0)
 				return -EIO;
-			icd->exposure = ctrl->value;
+			mt9t031->exposure = ctrl->value;
 			mt9t031->autoexposure = 0;
 		}
 		break;
@@ -649,14 +656,14 @@ static int mt9t031_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 		if (ctrl->value) {
 			const u16 vblank = MT9T031_VERTICAL_BLANK;
 			const u32 shutter_max = MT9T031_MAX_HEIGHT + vblank;
-			if (set_shutter(client, mt9t031->rect.height +
-					icd->y_skip_top + vblank) < 0)
+			unsigned int total_h = mt9t031->rect.height +
+				icd->y_skip_top + vblank;
+
+			if (set_shutter(client, total_h) < 0)
 				return -EIO;
 			qctrl = soc_camera_find_qctrl(icd->ops, V4L2_CID_EXPOSURE);
-			icd->exposure = (shutter_max / 2 +
-					 (mt9t031->rect.height +
-					  icd->y_skip_top + vblank - 1) *
-					 (qctrl->maximum - qctrl->minimum)) /
+			mt9t031->exposure = (shutter_max / 2 + (total_h - 1) *
+				 (qctrl->maximum - qctrl->minimum)) /
 				shutter_max + qctrl->minimum;
 			mt9t031->autoexposure = 1;
 		} else
@@ -700,6 +707,10 @@ static int mt9t031_video_probe(struct i2c_client *client)
 	if (ret < 0)
 		dev_err(&client->dev, "Failed to initialise the camera\n");
 
+	/* mt9t031_idle() has reset the chip to default. */
+	mt9t031->exposure = 255;
+	mt9t031->gain = 64;
+
 	return ret;
 }
 
diff --git a/drivers/media/video/mt9v022.c b/drivers/media/video/mt9v022.c
index 5c47b55..2bfb26b 100644
--- a/drivers/media/video/mt9v022.c
+++ b/drivers/media/video/mt9v022.c
@@ -45,7 +45,7 @@ MODULE_PARM_DESC(sensor_type, "Sensor type: \"colour\" or \"monochrome\"");
 #define MT9V022_PIXEL_OPERATION_MODE	0x0f
 #define MT9V022_LED_OUT_CONTROL		0x1b
 #define MT9V022_ADC_MODE_CONTROL	0x1c
-#define MT9V022_ANALOG_GAIN		0x34
+#define MT9V022_ANALOG_GAIN		0x35
 #define MT9V022_BLACK_LEVEL_CALIB_CTRL	0x47
 #define MT9V022_PIXCLK_FV_LV		0x74
 #define MT9V022_DIGITAL_TEST_PATTERN	0x7f
@@ -156,6 +156,10 @@ static int mt9v022_init(struct i2c_client *client)
 		/* AEC, AGC on */
 		ret = reg_set(client, MT9V022_AEC_AGC_ENABLE, 0x3);
 	if (!ret)
+		ret = reg_write(client, MT9V022_ANALOG_GAIN, 16);
+	if (!ret)
+		ret = reg_write(client, MT9V022_TOTAL_SHUTTER_WIDTH, 480);
+	if (!ret)
 		ret = reg_write(client, MT9V022_MAX_TOTAL_SHUTTER_WIDTH, 480);
 	if (!ret)
 		/* default - auto */
@@ -540,8 +544,12 @@ static struct soc_camera_ops mt9v022_ops = {
 static int mt9v022_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 {
 	struct i2c_client *client = sd->priv;
+	const struct v4l2_queryctrl *qctrl;
+	unsigned long range;
 	int data;
 
+	qctrl = soc_camera_find_qctrl(&mt9v022_ops, ctrl->id);
+
 	switch (ctrl->id) {
 	case V4L2_CID_VFLIP:
 		data = reg_read(client, MT9V022_READ_MODE);
@@ -567,6 +575,24 @@ static int mt9v022_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 			return -EIO;
 		ctrl->value = !!(data & 0x2);
 		break;
+	case V4L2_CID_GAIN:
+		data = reg_read(client, MT9V022_ANALOG_GAIN);
+		if (data < 0)
+			return -EIO;
+
+		range = qctrl->maximum - qctrl->minimum;
+		ctrl->value = ((data - 16) * range + 24) / 48 + qctrl->minimum;
+
+		break;
+	case V4L2_CID_EXPOSURE:
+		data = reg_read(client, MT9V022_TOTAL_SHUTTER_WIDTH);
+		if (data < 0)
+			return -EIO;
+
+		range = qctrl->maximum - qctrl->minimum;
+		ctrl->value = ((data - 1) * range + 239) / 479 + qctrl->minimum;
+
+		break;
 	}
 	return 0;
 }
@@ -575,7 +601,6 @@ static int mt9v022_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 {
 	int data;
 	struct i2c_client *client = sd->priv;
-	struct soc_camera_device *icd = client->dev.platform_data;
 	const struct v4l2_queryctrl *qctrl;
 
 	qctrl = soc_camera_find_qctrl(&mt9v022_ops, ctrl->id);
@@ -605,12 +630,9 @@ static int mt9v022_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 			return -EINVAL;
 		else {
 			unsigned long range = qctrl->maximum - qctrl->minimum;
-			/* Datasheet says 16 to 64. autogain only works properly
-			 * after setting gain to maximum 14. Larger values
-			 * produce "white fly" noise effect. On the whole,
-			 * manually setting analog gain does no good. */
+			/* Valid values 16 to 64, 32 to 64 must be even. */
 			unsigned long gain = ((ctrl->value - qctrl->minimum) *
-					      10 + range / 2) / range + 4;
+					      48 + range / 2) / range + 16;
 			if (gain >= 32)
 				gain &= ~1;
 			/* The user wants to set gain manually, hope, she
@@ -619,11 +641,10 @@ static int mt9v022_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 			if (reg_clear(client, MT9V022_AEC_AGC_ENABLE, 0x2) < 0)
 				return -EIO;
 
-			dev_info(&client->dev, "Setting gain from %d to %lu\n",
-				 reg_read(client, MT9V022_ANALOG_GAIN), gain);
+			dev_dbg(&client->dev, "Setting gain from %d to %lu\n",
+				reg_read(client, MT9V022_ANALOG_GAIN), gain);
 			if (reg_write(client, MT9V022_ANALOG_GAIN, gain) < 0)
 				return -EIO;
-			icd->gain = ctrl->value;
 		}
 		break;
 	case V4L2_CID_EXPOSURE:
@@ -646,7 +667,6 @@ static int mt9v022_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 			if (reg_write(client, MT9V022_TOTAL_SHUTTER_WIDTH,
 				      shutter) < 0)
 				return -EIO;
-			icd->exposure = ctrl->value;
 		}
 		break;
 	case V4L2_CID_AUTOGAIN:
@@ -827,6 +847,7 @@ static int mt9v022_probe(struct i2c_client *client,
 	mt9v022->chip_control = MT9V022_CHIP_CONTROL_DEFAULT;
 
 	icd->ops		= &mt9v022_ops;
+	/* MT9V022 _really_ corrupts the first read out line. TODO: verify on i.MX31 */
 	icd->y_skip_top		= 1;
 
 	mt9v022->rect.left	= MT9V022_COLUMN_SKIP;
diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 2792116..95dfa43 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -670,19 +670,6 @@ static int soc_camera_g_ctrl(struct file *file, void *priv,
 
 	WARN_ON(priv != file->private_data);
 
-	switch (ctrl->id) {
-	case V4L2_CID_GAIN:
-		if (icd->gain == (unsigned short)~0)
-			return -EINVAL;
-		ctrl->value = icd->gain;
-		return 0;
-	case V4L2_CID_EXPOSURE:
-		if (icd->exposure == (unsigned short)~0)
-			return -EINVAL;
-		ctrl->value = icd->exposure;
-		return 0;
-	}
-
 	if (ici->ops->get_ctrl) {
 		ret = ici->ops->get_ctrl(icd, ctrl);
 		if (ret != -ENOIOCTLCMD)
@@ -1279,7 +1266,6 @@ static int video_dev_create(struct soc_camera_device *icd)
  */
 static int soc_camera_video_start(struct soc_camera_device *icd)
 {
-	const struct v4l2_queryctrl *qctrl;
 	int ret;
 
 	if (!icd->dev.parent)
@@ -1297,11 +1283,6 @@ static int soc_camera_video_start(struct soc_camera_device *icd)
 		return ret;
 	}
 
-	qctrl = soc_camera_find_qctrl(icd->ops, V4L2_CID_GAIN);
-	icd->gain = qctrl ? qctrl->default_value : (unsigned short)~0;
-	qctrl = soc_camera_find_qctrl(icd->ops, V4L2_CID_EXPOSURE);
-	icd->exposure = qctrl ? qctrl->default_value : (unsigned short)~0;
-
 	return 0;
 }
 
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index f95cc4a..fe20e33 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -27,8 +27,6 @@ struct soc_camera_device {
 	unsigned short width_min;
 	unsigned short height_min;
 	unsigned short y_skip_top;	/* Lines to skip at the top */
-	unsigned short gain;
-	unsigned short exposure;
 	unsigned char iface;		/* Host number */
 	unsigned char devnum;		/* Device number per host */
 	unsigned char buswidth;		/* See comment in .c */
-- 
1.6.2.4

