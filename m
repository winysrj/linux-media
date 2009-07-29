Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:59015 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751535AbZG2PSQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jul 2009 11:18:16 -0400
Date: Wed, 29 Jul 2009 17:18:26 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Magnus Damm <magnus.damm@gmail.com>, m-karicheri2@ti.com,
	Valentin Longchamp <valentin.longchamp@epfl.ch>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
	Darius Augulis <augulis.darius@gmail.com>
Subject: [PATCH 1/4] soc-camera: Use I2C device for dev_{dbg,info,...} output
 in all clients
In-Reply-To: <Pine.LNX.4.64.0907291640010.4983@axis700.grange>
Message-ID: <Pine.LNX.4.64.0907291657490.4983@axis700.grange>
References: <Pine.LNX.4.64.0907291640010.4983@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/mt9m001.c |   20 +++++++++++---------
 drivers/media/video/mt9m111.c |   11 +++++------
 drivers/media/video/mt9t031.c |   16 ++++++++--------
 drivers/media/video/mt9v022.c |   16 ++++++++--------
 drivers/media/video/ov772x.c  |    6 +++---
 drivers/media/video/tw9910.c  |    6 +++---
 6 files changed, 38 insertions(+), 37 deletions(-)

diff --git a/drivers/media/video/mt9m001.c b/drivers/media/video/mt9m001.c
index fb1b580..1e7c469 100644
--- a/drivers/media/video/mt9m001.c
+++ b/drivers/media/video/mt9m001.c
@@ -118,7 +118,7 @@ static int mt9m001_init(struct soc_camera_device *icd)
 	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
 	int ret;
 
-	dev_dbg(&icd->dev, "%s\n", __func__);
+	dev_dbg(&client->dev, "%s\n", __func__);
 
 	/*
 	 * We don't know, whether platform provides reset,
@@ -427,7 +427,7 @@ static int mt9m001_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 			unsigned long range = qctrl->default_value - qctrl->minimum;
 			data = ((ctrl->value - qctrl->minimum) * 8 + range / 2) / range;
 
-			dev_dbg(&icd->dev, "Setting gain %d\n", data);
+			dev_dbg(&client->dev, "Setting gain %d\n", data);
 			data = reg_write(client, MT9M001_GLOBAL_GAIN, data);
 			if (data < 0)
 				return -EIO;
@@ -445,7 +445,7 @@ static int mt9m001_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 			else
 				data = ((gain - 64) * 7 + 28) / 56 + 96;
 
-			dev_dbg(&icd->dev, "Setting gain from %d to %d\n",
+			dev_dbg(&client->dev, "Setting gain from %d to %d\n",
 				 reg_read(client, MT9M001_GLOBAL_GAIN), data);
 			data = reg_write(client, MT9M001_GLOBAL_GAIN, data);
 			if (data < 0)
@@ -464,8 +464,10 @@ static int mt9m001_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 			unsigned long shutter = ((ctrl->value - qctrl->minimum) * 1048 +
 						 range / 2) / range + 1;
 
-			dev_dbg(&icd->dev, "Setting shutter width from %d to %lu\n",
-				 reg_read(client, MT9M001_SHUTTER_WIDTH), shutter);
+			dev_dbg(&client->dev,
+				"Setting shutter width from %d to %lu\n",
+				reg_read(client, MT9M001_SHUTTER_WIDTH),
+				shutter);
 			if (reg_write(client, MT9M001_SHUTTER_WIDTH, shutter) < 0)
 				return -EIO;
 			icd->exposure = ctrl->value;
@@ -510,7 +512,7 @@ static int mt9m001_video_probe(struct soc_camera_device *icd,
 
 	/* Enable the chip */
 	data = reg_write(client, MT9M001_CHIP_ENABLE, 1);
-	dev_dbg(&icd->dev, "write: %d\n", data);
+	dev_dbg(&client->dev, "write: %d\n", data);
 
 	/* Read out the chip version register */
 	data = reg_read(client, MT9M001_CHIP_VERSION);
@@ -527,7 +529,7 @@ static int mt9m001_video_probe(struct soc_camera_device *icd,
 		icd->formats = mt9m001_monochrome_formats;
 		break;
 	default:
-		dev_err(&icd->dev,
+		dev_err(&client->dev,
 			"No MT9M001 chip detected, register read %x\n", data);
 		return -ENODEV;
 	}
@@ -552,7 +554,7 @@ static int mt9m001_video_probe(struct soc_camera_device *icd,
 	if (flags & SOCAM_DATAWIDTH_8)
 		icd->num_formats++;
 
-	dev_info(&icd->dev, "Detected a MT9M001 chip ID %x (%s)\n", data,
+	dev_info(&client->dev, "Detected a MT9M001 chip ID %x (%s)\n", data,
 		 data == 0x8431 ? "C12STM" : "C12ST");
 
 	return 0;
@@ -563,7 +565,7 @@ static void mt9m001_video_remove(struct soc_camera_device *icd)
 	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
 	struct soc_camera_link *icl = to_soc_camera_link(icd);
 
-	dev_dbg(&icd->dev, "Video %x removed: %p, %p\n", client->addr,
+	dev_dbg(&client->dev, "Video %x removed: %p, %p\n", client->addr,
 		icd->dev.parent, icd->vdev);
 	if (icl->free_bus)
 		icl->free_bus(icl);
diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index bef4151..3637376 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -400,10 +400,9 @@ static int mt9m111_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 	struct v4l2_rect *rect = &a->c;
 	struct i2c_client *client = sd->priv;
 	struct mt9m111 *mt9m111 = to_mt9m111(client);
-	struct soc_camera_device *icd = client->dev.platform_data;
 	int ret;
 
-	dev_dbg(&icd->dev, "%s left=%d, top=%d, width=%d, height=%d\n",
+	dev_dbg(&client->dev, "%s left=%d, top=%d, width=%d, height=%d\n",
 		__func__, rect->left, rect->top, rect->width,
 		rect->height);
 
@@ -818,7 +817,7 @@ static int mt9m111_init(struct soc_camera_device *icd)
 	if (!ret)
 		ret = mt9m111_set_autoexposure(client, mt9m111->autoexposure);
 	if (ret)
-		dev_err(&icd->dev, "mt9m11x init failed: %d\n", ret);
+		dev_err(&client->dev, "mt9m11x init failed: %d\n", ret);
 	return ret;
 }
 
@@ -833,7 +832,7 @@ static int mt9m111_release(struct soc_camera_device *icd)
 		mt9m111->powered = 0;
 
 	if (ret < 0)
-		dev_err(&icd->dev, "mt9m11x release failed: %d\n", ret);
+		dev_err(&client->dev, "mt9m11x release failed: %d\n", ret);
 
 	return ret;
 }
@@ -875,7 +874,7 @@ static int mt9m111_video_probe(struct soc_camera_device *icd,
 		break;
 	default:
 		ret = -ENODEV;
-		dev_err(&icd->dev,
+		dev_err(&client->dev,
 			"No MT9M11x chip detected, register read %x\n", data);
 		goto ei2c;
 	}
@@ -883,7 +882,7 @@ static int mt9m111_video_probe(struct soc_camera_device *icd,
 	icd->formats = mt9m111_colour_formats;
 	icd->num_formats = ARRAY_SIZE(mt9m111_colour_formats);
 
-	dev_info(&icd->dev, "Detected a MT9M11x chip ID %x\n", data);
+	dev_info(&client->dev, "Detected a MT9M11x chip ID %x\n", data);
 
 	mt9m111->autoexposure = 1;
 	mt9m111->autowhitebalance = 1;
diff --git a/drivers/media/video/mt9t031.c b/drivers/media/video/mt9t031.c
index 3bfc008..d6c677f 100644
--- a/drivers/media/video/mt9t031.c
+++ b/drivers/media/video/mt9t031.c
@@ -248,7 +248,7 @@ static int mt9t031_set_params(struct soc_camera_device *icd,
 	xbin = min(xskip, (u16)3);
 	ybin = min(yskip, (u16)3);
 
-	dev_dbg(&icd->dev, "xskip %u, width %u/%u, yskip %u, height %u/%u\n",
+	dev_dbg(&client->dev, "xskip %u, width %u/%u, yskip %u, height %u/%u\n",
 		xskip, width, rect->width, yskip, height, rect->height);
 
 	/* Could just do roundup(rect->left, [xy]bin * 2); but this is cheaper */
@@ -287,7 +287,7 @@ static int mt9t031_set_params(struct soc_camera_device *icd,
 			ret = reg_write(client, MT9T031_ROW_ADDRESS_MODE,
 					((ybin - 1) << 4) | (yskip - 1));
 	}
-	dev_dbg(&icd->dev, "new physical left %u, top %u\n", left, top);
+	dev_dbg(&client->dev, "new physical left %u, top %u\n", left, top);
 
 	/* The caller provides a supported format, as guaranteed by
 	 * icd->try_fmt_cap(), soc_camera_s_crop() and soc_camera_cropcap() */
@@ -575,7 +575,7 @@ static int mt9t031_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 			unsigned long range = qctrl->default_value - qctrl->minimum;
 			data = ((ctrl->value - qctrl->minimum) * 8 + range / 2) / range;
 
-			dev_dbg(&icd->dev, "Setting gain %d\n", data);
+			dev_dbg(&client->dev, "Setting gain %d\n", data);
 			data = reg_write(client, MT9T031_GLOBAL_GAIN, data);
 			if (data < 0)
 				return -EIO;
@@ -595,7 +595,7 @@ static int mt9t031_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 				/* calculated gain 65..1024 -> (1..120) << 8 + 0x60 */
 				data = (((gain - 64 + 7) * 32) & 0xff00) | 0x60;
 
-			dev_dbg(&icd->dev, "Setting gain from 0x%x to 0x%x\n",
+			dev_dbg(&client->dev, "Set gain from 0x%x to 0x%x\n",
 				reg_read(client, MT9T031_GLOBAL_GAIN), data);
 			data = reg_write(client, MT9T031_GLOBAL_GAIN, data);
 			if (data < 0)
@@ -616,7 +616,7 @@ static int mt9t031_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 			u32 old;
 
 			get_shutter(client, &old);
-			dev_dbg(&icd->dev, "Setting shutter width from %u to %u\n",
+			dev_dbg(&client->dev, "Set shutter from %u to %u\n",
 				old, shutter);
 			if (set_shutter(client, shutter) < 0)
 				return -EIO;
@@ -661,7 +661,7 @@ static int mt9t031_video_probe(struct i2c_client *client)
 
 	/* Enable the chip */
 	data = reg_write(client, MT9T031_CHIP_ENABLE, 1);
-	dev_dbg(&icd->dev, "write: %d\n", data);
+	dev_dbg(&client->dev, "write: %d\n", data);
 
 	/* Read out the chip version register */
 	data = reg_read(client, MT9T031_CHIP_VERSION);
@@ -673,12 +673,12 @@ static int mt9t031_video_probe(struct i2c_client *client)
 		icd->num_formats = ARRAY_SIZE(mt9t031_colour_formats);
 		break;
 	default:
-		dev_err(&icd->dev,
+		dev_err(&client->dev,
 			"No MT9T031 chip detected, register read %x\n", data);
 		return -ENODEV;
 	}
 
-	dev_info(&icd->dev, "Detected a MT9T031 chip ID %x\n", data);
+	dev_info(&client->dev, "Detected a MT9T031 chip ID %x\n", data);
 
 	return 0;
 }
diff --git a/drivers/media/video/mt9v022.c b/drivers/media/video/mt9v022.c
index b51ca0d..70ad9a1 100644
--- a/drivers/media/video/mt9v022.c
+++ b/drivers/media/video/mt9v022.c
@@ -224,7 +224,7 @@ static int mt9v022_set_bus_param(struct soc_camera_device *icd,
 	if (ret < 0)
 		return ret;
 
-	dev_dbg(&icd->dev, "Calculated pixclk 0x%x, chip control 0x%x\n",
+	dev_dbg(&client->dev, "Calculated pixclk 0x%x, chip control 0x%x\n",
 		pixclk, mt9v022->chip_control);
 
 	return 0;
@@ -287,7 +287,7 @@ static int mt9v022_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 	if (ret < 0)
 		return ret;
 
-	dev_dbg(&icd->dev, "Frame %ux%u pixel\n", rect->width, rect->height);
+	dev_dbg(&client->dev, "Frame %ux%u pixel\n", rect->width, rect->height);
 
 	return 0;
 }
@@ -551,7 +551,7 @@ static int mt9v022_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 			if (reg_clear(client, MT9V022_AEC_AGC_ENABLE, 0x2) < 0)
 				return -EIO;
 
-			dev_info(&icd->dev, "Setting gain from %d to %lu\n",
+			dev_info(&client->dev, "Setting gain from %d to %lu\n",
 				 reg_read(client, MT9V022_ANALOG_GAIN), gain);
 			if (reg_write(client, MT9V022_ANALOG_GAIN, gain) < 0)
 				return -EIO;
@@ -572,7 +572,7 @@ static int mt9v022_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 			if (reg_clear(client, MT9V022_AEC_AGC_ENABLE, 0x1) < 0)
 				return -EIO;
 
-			dev_dbg(&icd->dev, "Shutter width from %d to %lu\n",
+			dev_dbg(&client->dev, "Shutter width from %d to %lu\n",
 				reg_read(client, MT9V022_TOTAL_SHUTTER_WIDTH),
 				shutter);
 			if (reg_write(client, MT9V022_TOTAL_SHUTTER_WIDTH,
@@ -622,7 +622,7 @@ static int mt9v022_video_probe(struct soc_camera_device *icd,
 	/* must be 0x1311 or 0x1313 */
 	if (data != 0x1311 && data != 0x1313) {
 		ret = -ENODEV;
-		dev_info(&icd->dev, "No MT9V022 detected, ID register 0x%x\n",
+		dev_info(&client->dev, "No MT9V022 found, ID register 0x%x\n",
 			 data);
 		goto ei2c;
 	}
@@ -634,7 +634,7 @@ static int mt9v022_video_probe(struct soc_camera_device *icd,
 	/* 15 clock cycles */
 	udelay(200);
 	if (reg_read(client, MT9V022_RESET)) {
-		dev_err(&icd->dev, "Resetting MT9V022 failed!\n");
+		dev_err(&client->dev, "Resetting MT9V022 failed!\n");
 		if (ret > 0)
 			ret = -EIO;
 		goto ei2c;
@@ -675,7 +675,7 @@ static int mt9v022_video_probe(struct soc_camera_device *icd,
 	if (flags & SOCAM_DATAWIDTH_8)
 		icd->num_formats++;
 
-	dev_info(&icd->dev, "Detected a MT9V022 chip ID %x, %s sensor\n",
+	dev_info(&client->dev, "Detected a MT9V022 chip ID %x, %s sensor\n",
 		 data, mt9v022->model == V4L2_IDENT_MT9V022IX7ATM ?
 		 "monochrome" : "colour");
 
@@ -688,7 +688,7 @@ static void mt9v022_video_remove(struct soc_camera_device *icd)
 	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
 	struct soc_camera_link *icl = to_soc_camera_link(icd);
 
-	dev_dbg(&icd->dev, "Video %x removed: %p, %p\n", client->addr,
+	dev_dbg(&client->dev, "Video %x removed: %p, %p\n", client->addr,
 		icd->dev.parent, icd->vdev);
 	if (icl->free_bus)
 		icl->free_bus(icl);
diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
index bbe6f2d..bbf5331 100644
--- a/drivers/media/video/ov772x.c
+++ b/drivers/media/video/ov772x.c
@@ -1002,7 +1002,7 @@ static int ov772x_video_probe(struct soc_camera_device *icd,
 	 */
 	if (SOCAM_DATAWIDTH_10 != priv->info->buswidth &&
 	    SOCAM_DATAWIDTH_8  != priv->info->buswidth) {
-		dev_err(&icd->dev, "bus width error\n");
+		dev_err(&client->dev, "bus width error\n");
 		return -ENODEV;
 	}
 
@@ -1025,12 +1025,12 @@ static int ov772x_video_probe(struct soc_camera_device *icd,
 		priv->model = V4L2_IDENT_OV7725;
 		break;
 	default:
-		dev_err(&icd->dev,
+		dev_err(&client->dev,
 			"Product ID error %x:%x\n", pid, ver);
 		return -ENODEV;
 	}
 
-	dev_info(&icd->dev,
+	dev_info(&client->dev,
 		 "%s Product ID %0x:%0x Manufacturer ID %x:%x\n",
 		 devname,
 		 pid,
diff --git a/drivers/media/video/tw9910.c b/drivers/media/video/tw9910.c
index b6b1546..94bd5b0 100644
--- a/drivers/media/video/tw9910.c
+++ b/drivers/media/video/tw9910.c
@@ -793,7 +793,7 @@ static int tw9910_video_probe(struct soc_camera_device *icd,
 	 */
 	if (SOCAM_DATAWIDTH_16 != priv->info->buswidth &&
 	    SOCAM_DATAWIDTH_8  != priv->info->buswidth) {
-		dev_err(&icd->dev, "bus width error\n");
+		dev_err(&client->dev, "bus width error\n");
 		return -ENODEV;
 	}
 
@@ -807,12 +807,12 @@ static int tw9910_video_probe(struct soc_camera_device *icd,
 
 	if (0x0B != GET_ID(val) ||
 	    0x00 != GET_ReV(val)) {
-		dev_err(&icd->dev,
+		dev_err(&client->dev,
 			"Product ID error %x:%x\n", GET_ID(val), GET_ReV(val));
 		return -ENODEV;
 	}
 
-	dev_info(&icd->dev,
+	dev_info(&client->dev,
 		 "tw9910 Product ID %0x:%0x\n", GET_ID(val), GET_ReV(val));
 
 	icd->vdev->tvnorms      = V4L2_STD_NTSC | V4L2_STD_PAL;
-- 
1.6.2.4

