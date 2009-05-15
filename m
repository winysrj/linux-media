Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:39819 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755045AbZEORUX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 May 2009 13:20:23 -0400
Date: Fri, 15 May 2009 19:20:27 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Magnus Damm <magnus.damm@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Darius Augulis <augulis.darius@gmail.com>,
	Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH/RFC 10/10 v2] soc-camera: (partially) convert to v4l2-(sub)dev
 API
In-Reply-To: <Pine.LNX.4.64.0905151817070.4658@axis700.grange>
Message-ID: <Pine.LNX.4.64.0905151912390.4658@axis700.grange>
References: <Pine.LNX.4.64.0905151817070.4658@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert the soc-camera framework to use the v4l2-(sub)dev API. Start using
v4l2-subdev operations. Only a part of the interface between the
soc_camera core, soc_camera host drivers on one side and soc_camera device
drivers on the other side is replaced so far. The rest of the interface
will be replaced in incremental steps, and will require extensions and,
possibly, modifications to the v4l2-subdev code.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Ok, this one depends on the previous, so, it currently cannot go in. We 
have to come up with a solution to the init/s_standby question from the 
previoud patch.

 drivers/media/video/mt9m001.c              |  171 +++++++--------
 drivers/media/video/mt9m111.c              |  324 ++++++++++++----------------
 drivers/media/video/mt9t031.c              |  178 +++++++--------
 drivers/media/video/mt9v022.c              |  173 ++++++---------
 drivers/media/video/mx1_camera.c           |   31 ++--
 drivers/media/video/mx3_camera.c           |   54 ++---
 drivers/media/video/ov772x.c               |  169 ++++++---------
 drivers/media/video/pxa_camera.c           |  107 +++++-----
 drivers/media/video/sh_mobile_ceu_camera.c |   45 ++---
 drivers/media/video/soc_camera.c           |  255 +++++++++++++---------
 drivers/media/video/soc_camera_platform.c  |  116 +++++------
 drivers/media/video/tw9910.c               |  151 ++++++--------
 include/media/soc_camera.h                 |   25 +--
 13 files changed, 806 insertions(+), 993 deletions(-)

diff --git a/drivers/media/video/mt9m001.c b/drivers/media/video/mt9m001.c
index b0f4ad5..fc42061 100644
--- a/drivers/media/video/mt9m001.c
+++ b/drivers/media/video/mt9m001.c
@@ -13,13 +13,13 @@
 #include <linux/i2c.h>
 #include <linux/log2.h>
 
-#include <media/v4l2-common.h>
+#include <media/v4l2-subdev.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/soc_camera.h>
 
 /* mt9m001 i2c address 0x5d
- * The platform has to define i2c_board_info
- * and call i2c_register_board_info() */
+ * The platform has to define ctruct i2c_board_info objects and link to them
+ * from struct soc_camera_link */
 
 /* mt9m001 selected register addresses */
 #define MT9M001_CHIP_VERSION		0x00
@@ -69,10 +69,16 @@ static const struct soc_camera_data_format mt9m001_monochrome_formats[] = {
 };
 
 struct mt9m001 {
+	struct v4l2_subdev subdev;
 	int model;	/* V4L2_IDENT_MT9M001* codes from v4l2-chip-ident.h */
 	unsigned char autoexposure;
 };
 
+static struct mt9m001 *to_mt9m001(const struct i2c_client *client)
+{
+	return container_of(i2c_get_clientdata(client), struct mt9m001, subdev);
+}
+
 static int reg_read(struct i2c_client *client, const u8 reg)
 {
 	s32 data = i2c_smbus_read_word_data(client, reg);
@@ -107,35 +113,21 @@ static int reg_clear(struct i2c_client *client, const u8 reg,
 	return reg_write(client, reg, ret & ~data);
 }
 
-static int mt9m001_init(struct soc_camera_device *icd)
+static int mt9m001_init(struct v4l2_subdev *sd, u32 val)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
+	struct i2c_client *client = sd->priv;
 	int ret;
 
-	dev_dbg(&icd->dev, "%s\n", __func__);
-
-	if (icl->power) {
-		ret = icl->power(&client->dev, 1);
-		if (ret < 0) {
-			dev_err(icd->vdev->parent,
-				"Platform failed to power-on the camera.\n");
-			return ret;
-		}
-	}
+	dev_dbg(&client->dev, "%s\n", __func__);
 
-	/* The camera could have been already on, we reset it additionally */
-	if (icl->reset)
-		ret = icl->reset(&client->dev);
-	else
-		ret = -ENODEV;
+	/*
+	 * We don't know, whether platform provides reset,
+	 * issue a soft reset too
+	 */
+	ret = reg_write(client, MT9M001_RESET, 1);
+	if (!ret)
+		ret = reg_write(client, MT9M001_RESET, 0);
 
-	if (ret < 0) {
-		/* Either no platform reset, or platform reset failed */
-		ret = reg_write(client, MT9M001_RESET, 1);
-		if (!ret)
-			ret = reg_write(client, MT9M001_RESET, 0);
-	}
 	/* Disable chip, synchronous option update */
 	if (!ret)
 		ret = reg_write(client, MT9M001_OUTPUT_CONTROL, 0);
@@ -143,36 +135,22 @@ static int mt9m001_init(struct soc_camera_device *icd)
 	return ret;
 }
 
-static int mt9m001_release(struct soc_camera_device *icd)
+static int mt9m001_s_standby(struct v4l2_subdev *sd, u32 standby)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
+	struct i2c_client *client = sd->priv;
 
 	/* Disable the chip */
 	reg_write(client, MT9M001_OUTPUT_CONTROL, 0);
 
-	if (icl->power)
-		icl->power(&client->dev, 0);
-
-	return 0;
-}
-
-static int mt9m001_start_capture(struct soc_camera_device *icd)
-{
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-
-	/* Switch to master "normal" mode */
-	if (reg_write(client, MT9M001_OUTPUT_CONTROL, 2) < 0)
-		return -EIO;
 	return 0;
 }
 
-static int mt9m001_stop_capture(struct soc_camera_device *icd)
+static int mt9m001_s_stream(struct v4l2_subdev *sd, int enable)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct i2c_client *client = sd->priv;
 
-	/* Stop sensor readout */
-	if (reg_write(client, MT9M001_OUTPUT_CONTROL, 0) < 0)
+	/* Switch to master "normal" mode or stop sensor readout */
+	if (reg_write(client, MT9M001_OUTPUT_CONTROL, enable ? 2 : 0) < 0)
 		return -EIO;
 	return 0;
 }
@@ -220,7 +198,7 @@ static int mt9m001_set_crop(struct soc_camera_device *icd,
 			    struct v4l2_rect *rect)
 {
 	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct mt9m001 *mt9m001 = i2c_get_clientdata(client);
+	struct mt9m001 *mt9m001 = to_mt9m001(client);
 	int ret;
 	const u16 hblank = 9, vblank = 25;
 
@@ -257,9 +235,10 @@ static int mt9m001_set_crop(struct soc_camera_device *icd,
 	return ret;
 }
 
-static int mt9m001_set_fmt(struct soc_camera_device *icd,
-			   struct v4l2_format *f)
+static int mt9m001_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
 {
+	struct i2c_client *client = sd->priv;
+	struct soc_camera_device *icd = client->dev.platform_data;
 	struct v4l2_rect rect = {
 		.left	= icd->x_current,
 		.top	= icd->y_current,
@@ -271,9 +250,10 @@ static int mt9m001_set_fmt(struct soc_camera_device *icd,
 	return mt9m001_set_crop(icd, &rect);
 }
 
-static int mt9m001_try_fmt(struct soc_camera_device *icd,
-			   struct v4l2_format *f)
+static int mt9m001_try_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
 {
+	struct i2c_client *client = sd->priv;
+	struct soc_camera_device *icd = client->dev.platform_data;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 
 	if (pix->height < 32 + icd->y_skip_top)
@@ -289,11 +269,11 @@ static int mt9m001_try_fmt(struct soc_camera_device *icd,
 	return 0;
 }
 
-static int mt9m001_get_chip_id(struct soc_camera_device *icd,
-			       struct v4l2_dbg_chip_ident *id)
+static int mt9m001_g_chip_ident(struct v4l2_subdev *sd,
+				struct v4l2_dbg_chip_ident *id)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct mt9m001 *mt9m001 = i2c_get_clientdata(client);
+	struct i2c_client *client = sd->priv;
+	struct mt9m001 *mt9m001 = to_mt9m001(client);
 
 	if (id->match.type != V4L2_CHIP_MATCH_I2C_ADDR)
 		return -EINVAL;
@@ -308,10 +288,10 @@ static int mt9m001_get_chip_id(struct soc_camera_device *icd,
 }
 
 #ifdef CONFIG_VIDEO_ADV_DEBUG
-static int mt9m001_get_register(struct soc_camera_device *icd,
-				struct v4l2_dbg_register *reg)
+static int mt9m001_g_register(struct v4l2_subdev *sd,
+			      struct v4l2_dbg_register *reg)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct i2c_client *client = sd->priv;
 
 	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR || reg->reg > 0xff)
 		return -EINVAL;
@@ -328,10 +308,10 @@ static int mt9m001_get_register(struct soc_camera_device *icd,
 	return 0;
 }
 
-static int mt9m001_set_register(struct soc_camera_device *icd,
-				struct v4l2_dbg_register *reg)
+static int mt9m001_s_register(struct v4l2_subdev *sd,
+			      struct v4l2_dbg_register *reg)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct i2c_client *client = sd->priv;
 
 	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR || reg->reg > 0xff)
 		return -EINVAL;
@@ -384,35 +364,18 @@ static const struct v4l2_queryctrl mt9m001_controls[] = {
 	}
 };
 
-static int mt9m001_get_control(struct soc_camera_device *, struct v4l2_control *);
-static int mt9m001_set_control(struct soc_camera_device *, struct v4l2_control *);
-
 static struct soc_camera_ops mt9m001_ops = {
-	.owner			= THIS_MODULE,
-	.init			= mt9m001_init,
-	.release		= mt9m001_release,
-	.start_capture		= mt9m001_start_capture,
-	.stop_capture		= mt9m001_stop_capture,
 	.set_crop		= mt9m001_set_crop,
-	.set_fmt		= mt9m001_set_fmt,
-	.try_fmt		= mt9m001_try_fmt,
 	.set_bus_param		= mt9m001_set_bus_param,
 	.query_bus_param	= mt9m001_query_bus_param,
 	.controls		= mt9m001_controls,
 	.num_controls		= ARRAY_SIZE(mt9m001_controls),
-	.get_control		= mt9m001_get_control,
-	.set_control		= mt9m001_set_control,
-	.get_chip_id		= mt9m001_get_chip_id,
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-	.get_register		= mt9m001_get_register,
-	.set_register		= mt9m001_set_register,
-#endif
 };
 
-static int mt9m001_get_control(struct soc_camera_device *icd, struct v4l2_control *ctrl)
+static int mt9m001_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct mt9m001 *mt9m001 = i2c_get_clientdata(client);
+	struct i2c_client *client = sd->priv;
+	struct mt9m001 *mt9m001 = to_mt9m001(client);
 	int data;
 
 	switch (ctrl->id) {
@@ -429,10 +392,11 @@ static int mt9m001_get_control(struct soc_camera_device *icd, struct v4l2_contro
 	return 0;
 }
 
-static int mt9m001_set_control(struct soc_camera_device *icd, struct v4l2_control *ctrl)
+static int mt9m001_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct mt9m001 *mt9m001 = i2c_get_clientdata(client);
+	struct i2c_client *client = sd->priv;
+	struct mt9m001 *mt9m001 = to_mt9m001(client);
+	struct soc_camera_device *icd = client->dev.platform_data;
 	const struct v4l2_queryctrl *qctrl;
 	int data;
 
@@ -527,10 +491,9 @@ static int mt9m001_set_control(struct soc_camera_device *icd, struct v4l2_contro
 static int mt9m001_video_probe(struct soc_camera_device *icd,
 			       struct i2c_client *client)
 {
-	struct mt9m001 *mt9m001 = i2c_get_clientdata(client);
+	struct mt9m001 *mt9m001 = to_mt9m001(client);
 	struct soc_camera_link *icl = to_soc_camera_link(icd);
 	s32 data;
-	int ret;
 	unsigned long flags;
 
 	/* We must have a parent by now. And it cannot be a wrong one.
@@ -539,11 +502,6 @@ static int mt9m001_video_probe(struct soc_camera_device *icd,
 	    to_soc_camera_host(icd->dev.parent)->nr != icd->iface)
 		return -ENODEV;
 
-	/* Switch master clock on */
-	ret = soc_camera_video_start(icd, &client->dev);
-	if (ret)
-		return ret;
-
 	/* Enable the chip */
 	data = reg_write(client, MT9M001_CHIP_ENABLE, 1);
 	dev_dbg(&icd->dev, "write: %d\n", data);
@@ -551,8 +509,6 @@ static int mt9m001_video_probe(struct soc_camera_device *icd,
 	/* Read out the chip version register */
 	data = reg_read(client, MT9M001_CHIP_VERSION);
 
-	soc_camera_video_stop(icd);
-
 	/* must be 0x8411 or 0x8421 for colour sensor and 8431 for bw */
 	switch (data) {
 	case 0x8411:
@@ -608,6 +564,29 @@ static void mt9m001_video_remove(struct soc_camera_device *icd)
 		icl->free_bus(icl);
 }
 
+static struct v4l2_subdev_core_ops mt9m001_subdev_core_ops = {
+	.init		= mt9m001_init,
+	.s_standby	= mt9m001_s_standby,
+	.g_ctrl		= mt9m001_g_ctrl,
+	.s_ctrl		= mt9m001_s_ctrl,
+	.g_chip_ident	= mt9m001_g_chip_ident,
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+	.g_register	= mt9m001_g_register,
+	.s_register	= mt9m001_s_register,
+#endif
+};
+
+static struct v4l2_subdev_video_ops mt9m001_subdev_video_ops = {
+	.s_stream	= mt9m001_s_stream,
+	.s_fmt		= mt9m001_s_fmt,
+	.try_fmt	= mt9m001_try_fmt,
+};
+
+static struct v4l2_subdev_ops mt9m001_subdev_ops = {
+	.core	= &mt9m001_subdev_core_ops,
+	.video	= &mt9m001_subdev_video_ops,
+};
+
 static int mt9m001_probe(struct i2c_client *client,
 			 const struct i2c_device_id *did)
 {
@@ -638,7 +617,7 @@ static int mt9m001_probe(struct i2c_client *client,
 	if (!mt9m001)
 		return -ENOMEM;
 
-	i2c_set_clientdata(client, mt9m001);
+	v4l2_i2c_subdev_init(&mt9m001->subdev, client, &mt9m001_subdev_ops);
 
 	/* Second stage probe - when a capture adapter is there */
 	icd->ops	= &mt9m001_ops;
@@ -666,7 +645,7 @@ static int mt9m001_probe(struct i2c_client *client,
 
 static int mt9m001_remove(struct i2c_client *client)
 {
-	struct mt9m001 *mt9m001 = i2c_get_clientdata(client);
+	struct mt9m001 *mt9m001 = to_mt9m001(client);
 	struct soc_camera_device *icd = client->dev.platform_data;
 
 	mt9m001_video_remove(icd);
diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index 06f5f97..d5d0478 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -148,6 +148,7 @@ enum mt9m111_context {
 };
 
 struct mt9m111 {
+	struct v4l2_subdev subdev;
 	int model;	/* V4L2_IDENT_MT9M11x* codes from v4l2-chip-ident.h */
 	enum mt9m111_context context;
 	struct v4l2_rect rect;
@@ -164,6 +165,11 @@ struct mt9m111 {
 	unsigned int autowhitebalance:1;
 };
 
+static struct mt9m111 *to_mt9m111(const struct i2c_client *client)
+{
+	return container_of(i2c_get_clientdata(client), struct mt9m111, subdev);
+}
+
 static int reg_page_map_set(struct i2c_client *client, const u16 reg)
 {
 	int ret;
@@ -227,10 +233,9 @@ static int mt9m111_reg_clear(struct i2c_client *client, const u16 reg,
 	return mt9m111_reg_write(client, reg, ret & ~data);
 }
 
-static int mt9m111_set_context(struct soc_camera_device *icd,
+static int mt9m111_set_context(struct i2c_client *client,
 			       enum mt9m111_context ctxt)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
 	int valB = MT9M111_CTXT_CTRL_RESTART | MT9M111_CTXT_CTRL_DEFECTCOR_B
 		| MT9M111_CTXT_CTRL_RESIZE_B | MT9M111_CTXT_CTRL_CTRL2_B
 		| MT9M111_CTXT_CTRL_GAMMA_B | MT9M111_CTXT_CTRL_READ_MODE_B
@@ -244,11 +249,10 @@ static int mt9m111_set_context(struct soc_camera_device *icd,
 		return reg_write(CONTEXT_CONTROL, valA);
 }
 
-static int mt9m111_setup_rect(struct soc_camera_device *icd,
+static int mt9m111_setup_rect(struct i2c_client *client,
 			      struct v4l2_rect *rect)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct mt9m111 *mt9m111 = i2c_get_clientdata(client);
+	struct mt9m111 *mt9m111 = to_mt9m111(client);
 	int ret, is_raw_format;
 	int width = rect->width;
 	int height = rect->height;
@@ -290,9 +294,8 @@ static int mt9m111_setup_rect(struct soc_camera_device *icd,
 	return ret;
 }
 
-static int mt9m111_setup_pixfmt(struct soc_camera_device *icd, u16 outfmt)
+static int mt9m111_setup_pixfmt(struct i2c_client *client, u16 outfmt)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
 	int ret;
 
 	ret = reg_write(OUTPUT_FORMAT_CTRL2_A, outfmt);
@@ -301,20 +304,19 @@ static int mt9m111_setup_pixfmt(struct soc_camera_device *icd, u16 outfmt)
 	return ret;
 }
 
-static int mt9m111_setfmt_bayer8(struct soc_camera_device *icd)
+static int mt9m111_setfmt_bayer8(struct i2c_client *client)
 {
-	return mt9m111_setup_pixfmt(icd, MT9M111_OUTFMT_PROCESSED_BAYER);
+	return mt9m111_setup_pixfmt(client, MT9M111_OUTFMT_PROCESSED_BAYER);
 }
 
-static int mt9m111_setfmt_bayer10(struct soc_camera_device *icd)
+static int mt9m111_setfmt_bayer10(struct i2c_client *client)
 {
-	return mt9m111_setup_pixfmt(icd, MT9M111_OUTFMT_BYPASS_IFP);
+	return mt9m111_setup_pixfmt(client, MT9M111_OUTFMT_BYPASS_IFP);
 }
 
-static int mt9m111_setfmt_rgb565(struct soc_camera_device *icd)
+static int mt9m111_setfmt_rgb565(struct i2c_client *client)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct mt9m111 *mt9m111 = i2c_get_clientdata(client);
+	struct mt9m111 *mt9m111 = to_mt9m111(client);
 	int val = 0;
 
 	if (mt9m111->swap_rgb_red_blue)
@@ -323,13 +325,12 @@ static int mt9m111_setfmt_rgb565(struct soc_camera_device *icd)
 		val |= MT9M111_OUTFMT_SWAP_RGB_EVEN;
 	val |= MT9M111_OUTFMT_RGB | MT9M111_OUTFMT_RGB565;
 
-	return mt9m111_setup_pixfmt(icd, val);
+	return mt9m111_setup_pixfmt(client, val);
 }
 
-static int mt9m111_setfmt_rgb555(struct soc_camera_device *icd)
+static int mt9m111_setfmt_rgb555(struct i2c_client *client)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct mt9m111 *mt9m111 = i2c_get_clientdata(client);
+	struct mt9m111 *mt9m111 = to_mt9m111(client);
 	int val = 0;
 
 	if (mt9m111->swap_rgb_red_blue)
@@ -338,13 +339,12 @@ static int mt9m111_setfmt_rgb555(struct soc_camera_device *icd)
 		val |= MT9M111_OUTFMT_SWAP_RGB_EVEN;
 	val |= MT9M111_OUTFMT_RGB | MT9M111_OUTFMT_RGB555;
 
-	return mt9m111_setup_pixfmt(icd, val);
+	return mt9m111_setup_pixfmt(client, val);
 }
 
-static int mt9m111_setfmt_yuv(struct soc_camera_device *icd)
+static int mt9m111_setfmt_yuv(struct i2c_client *client)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct mt9m111 *mt9m111 = i2c_get_clientdata(client);
+	struct mt9m111 *mt9m111 = to_mt9m111(client);
 	int val = 0;
 
 	if (mt9m111->swap_yuv_cb_cr)
@@ -352,52 +352,22 @@ static int mt9m111_setfmt_yuv(struct soc_camera_device *icd)
 	if (mt9m111->swap_yuv_y_chromas)
 		val |= MT9M111_OUTFMT_SWAP_YCbCr_C_Y;
 
-	return mt9m111_setup_pixfmt(icd, val);
+	return mt9m111_setup_pixfmt(client, val);
 }
 
-static int mt9m111_enable(struct soc_camera_device *icd)
+static int mt9m111_enable(struct i2c_client *client)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
-	struct mt9m111 *mt9m111 = i2c_get_clientdata(client);
+	struct mt9m111 *mt9m111 = to_mt9m111(client);
 	int ret;
 
-	if (icl->power) {
-		ret = icl->power(&client->dev, 1);
-		if (ret < 0) {
-			dev_err(icd->vdev->parent,
-				"Platform failed to power-on the camera.\n");
-			return ret;
-		}
-	}
-
 	ret = reg_set(RESET, MT9M111_RESET_CHIP_ENABLE);
 	if (!ret)
 		mt9m111->powered = 1;
 	return ret;
 }
 
-static int mt9m111_disable(struct soc_camera_device *icd)
-{
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
-	struct mt9m111 *mt9m111 = i2c_get_clientdata(client);
-	int ret;
-
-	ret = reg_clear(RESET, MT9M111_RESET_CHIP_ENABLE);
-	if (!ret)
-		mt9m111->powered = 0;
-
-	if (icl->power)
-		icl->power(&client->dev, 0);
-
-	return ret;
-}
-
-static int mt9m111_reset(struct soc_camera_device *icd)
+static int mt9m111_reset(struct i2c_client *client)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
 	int ret;
 
 	ret = reg_set(RESET, MT9M111_RESET_RESET_MODE);
@@ -407,22 +377,9 @@ static int mt9m111_reset(struct soc_camera_device *icd)
 		ret = reg_clear(RESET, MT9M111_RESET_RESET_MODE
 				| MT9M111_RESET_RESET_SOC);
 
-	if (icl->reset)
-		icl->reset(&client->dev);
-
 	return ret;
 }
 
-static int mt9m111_start_capture(struct soc_camera_device *icd)
-{
-	return 0;
-}
-
-static int mt9m111_stop_capture(struct soc_camera_device *icd)
-{
-	return 0;
-}
-
 static unsigned long mt9m111_query_bus_param(struct soc_camera_device *icd)
 {
 	struct soc_camera_link *icl = to_soc_camera_link(icd);
@@ -442,60 +399,59 @@ static int mt9m111_set_crop(struct soc_camera_device *icd,
 			    struct v4l2_rect *rect)
 {
 	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct mt9m111 *mt9m111 = i2c_get_clientdata(client);
+	struct mt9m111 *mt9m111 = to_mt9m111(client);
 	int ret;
 
 	dev_dbg(&icd->dev, "%s left=%d, top=%d, width=%d, height=%d\n",
 		__func__, rect->left, rect->top, rect->width,
 		rect->height);
 
-	ret = mt9m111_setup_rect(icd, rect);
+	ret = mt9m111_setup_rect(client, rect);
 	if (!ret)
 		mt9m111->rect = *rect;
 	return ret;
 }
 
-static int mt9m111_set_pixfmt(struct soc_camera_device *icd, u32 pixfmt)
+static int mt9m111_set_pixfmt(struct i2c_client *client, u32 pixfmt)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct mt9m111 *mt9m111 = i2c_get_clientdata(client);
+	struct mt9m111 *mt9m111 = to_mt9m111(client);
 	int ret;
 
 	switch (pixfmt) {
 	case V4L2_PIX_FMT_SBGGR8:
-		ret = mt9m111_setfmt_bayer8(icd);
+		ret = mt9m111_setfmt_bayer8(client);
 		break;
 	case V4L2_PIX_FMT_SBGGR16:
-		ret = mt9m111_setfmt_bayer10(icd);
+		ret = mt9m111_setfmt_bayer10(client);
 		break;
 	case V4L2_PIX_FMT_RGB555:
-		ret = mt9m111_setfmt_rgb555(icd);
+		ret = mt9m111_setfmt_rgb555(client);
 		break;
 	case V4L2_PIX_FMT_RGB565:
-		ret = mt9m111_setfmt_rgb565(icd);
+		ret = mt9m111_setfmt_rgb565(client);
 		break;
 	case V4L2_PIX_FMT_UYVY:
 		mt9m111->swap_yuv_y_chromas = 0;
 		mt9m111->swap_yuv_cb_cr = 0;
-		ret = mt9m111_setfmt_yuv(icd);
+		ret = mt9m111_setfmt_yuv(client);
 		break;
 	case V4L2_PIX_FMT_VYUY:
 		mt9m111->swap_yuv_y_chromas = 0;
 		mt9m111->swap_yuv_cb_cr = 1;
-		ret = mt9m111_setfmt_yuv(icd);
+		ret = mt9m111_setfmt_yuv(client);
 		break;
 	case V4L2_PIX_FMT_YUYV:
 		mt9m111->swap_yuv_y_chromas = 1;
 		mt9m111->swap_yuv_cb_cr = 0;
-		ret = mt9m111_setfmt_yuv(icd);
+		ret = mt9m111_setfmt_yuv(client);
 		break;
 	case V4L2_PIX_FMT_YVYU:
 		mt9m111->swap_yuv_y_chromas = 1;
 		mt9m111->swap_yuv_cb_cr = 1;
-		ret = mt9m111_setfmt_yuv(icd);
+		ret = mt9m111_setfmt_yuv(client);
 		break;
 	default:
-		dev_err(&icd->dev, "Pixel format not handled : %x\n", pixfmt);
+		dev_err(&client->dev, "Pixel format not handled : %x\n", pixfmt);
 		ret = -EINVAL;
 	}
 
@@ -505,11 +461,10 @@ static int mt9m111_set_pixfmt(struct soc_camera_device *icd, u32 pixfmt)
 	return ret;
 }
 
-static int mt9m111_set_fmt(struct soc_camera_device *icd,
-			   struct v4l2_format *f)
+static int mt9m111_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct mt9m111 *mt9m111 = i2c_get_clientdata(client);
+	struct i2c_client *client = sd->priv;
+	struct mt9m111 *mt9m111 = to_mt9m111(client);
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 	struct v4l2_rect rect = {
 		.left	= mt9m111->rect.left,
@@ -519,20 +474,19 @@ static int mt9m111_set_fmt(struct soc_camera_device *icd,
 	};
 	int ret;
 
-	dev_dbg(&icd->dev, "%s fmt=%x left=%d, top=%d, width=%d, height=%d\n",
+	dev_dbg(&client->dev, "%s fmt=%x left=%d, top=%d, width=%d, height=%d\n",
 		__func__, pix->pixelformat, rect.left, rect.top, rect.width,
 		rect.height);
 
-	ret = mt9m111_setup_rect(icd, &rect);
+	ret = mt9m111_setup_rect(client, &rect);
 	if (!ret)
-		ret = mt9m111_set_pixfmt(icd, pix->pixelformat);
+		ret = mt9m111_set_pixfmt(client, pix->pixelformat);
 	if (!ret)
 		mt9m111->rect = rect;
 	return ret;
 }
 
-static int mt9m111_try_fmt(struct soc_camera_device *icd,
-			   struct v4l2_format *f)
+static int mt9m111_try_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
 {
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 
@@ -544,11 +498,11 @@ static int mt9m111_try_fmt(struct soc_camera_device *icd,
 	return 0;
 }
 
-static int mt9m111_get_chip_id(struct soc_camera_device *icd,
-			       struct v4l2_dbg_chip_ident *id)
+static int mt9m111_g_chip_ident(struct v4l2_subdev *sd,
+				struct v4l2_dbg_chip_ident *id)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct mt9m111 *mt9m111 = i2c_get_clientdata(client);
+	struct i2c_client *client = sd->priv;
+	struct mt9m111 *mt9m111 = to_mt9m111(client);
 
 	if (id->match.type != V4L2_CHIP_MATCH_I2C_ADDR)
 		return -EINVAL;
@@ -563,10 +517,10 @@ static int mt9m111_get_chip_id(struct soc_camera_device *icd,
 }
 
 #ifdef CONFIG_VIDEO_ADV_DEBUG
-static int mt9m111_get_register(struct soc_camera_device *icd,
-				struct v4l2_dbg_register *reg)
+static int mt9m111_g_register(struct v4l2_subdev *sd,
+			      struct v4l2_dbg_register *reg)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct i2c_client *client = sd->priv;
 	int val;
 
 	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR || reg->reg > 0x2ff)
@@ -584,10 +538,10 @@ static int mt9m111_get_register(struct soc_camera_device *icd,
 	return 0;
 }
 
-static int mt9m111_set_register(struct soc_camera_device *icd,
-				struct v4l2_dbg_register *reg)
+static int mt9m111_s_register(struct v4l2_subdev *sd,
+			      struct v4l2_dbg_register *reg)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct i2c_client *client = sd->priv;
 
 	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR || reg->reg > 0x2ff)
 		return -EINVAL;
@@ -639,41 +593,20 @@ static const struct v4l2_queryctrl mt9m111_controls[] = {
 	}
 };
 
-static int mt9m111_get_control(struct soc_camera_device *,
-			       struct v4l2_control *);
-static int mt9m111_set_control(struct soc_camera_device *,
-			       struct v4l2_control *);
 static int mt9m111_resume(struct soc_camera_device *icd);
-static int mt9m111_init(struct soc_camera_device *icd);
-static int mt9m111_release(struct soc_camera_device *icd);
 
 static struct soc_camera_ops mt9m111_ops = {
-	.owner			= THIS_MODULE,
-	.init			= mt9m111_init,
 	.resume			= mt9m111_resume,
-	.release		= mt9m111_release,
-	.start_capture		= mt9m111_start_capture,
-	.stop_capture		= mt9m111_stop_capture,
 	.set_crop		= mt9m111_set_crop,
-	.set_fmt		= mt9m111_set_fmt,
-	.try_fmt		= mt9m111_try_fmt,
 	.query_bus_param	= mt9m111_query_bus_param,
 	.set_bus_param		= mt9m111_set_bus_param,
 	.controls		= mt9m111_controls,
 	.num_controls		= ARRAY_SIZE(mt9m111_controls),
-	.get_control		= mt9m111_get_control,
-	.set_control		= mt9m111_set_control,
-	.get_chip_id		= mt9m111_get_chip_id,
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-	.get_register		= mt9m111_get_register,
-	.set_register		= mt9m111_set_register,
-#endif
 };
 
-static int mt9m111_set_flip(struct soc_camera_device *icd, int flip, int mask)
+static int mt9m111_set_flip(struct i2c_client *client, int flip, int mask)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct mt9m111 *mt9m111 = i2c_get_clientdata(client);
+	struct mt9m111 *mt9m111 = to_mt9m111(client);
 	int ret;
 
 	if (mt9m111->context == HIGHPOWER) {
@@ -691,9 +624,8 @@ static int mt9m111_set_flip(struct soc_camera_device *icd, int flip, int mask)
 	return ret;
 }
 
-static int mt9m111_get_global_gain(struct soc_camera_device *icd)
+static int mt9m111_get_global_gain(struct i2c_client *client)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
 	int data;
 
 	data = reg_read(GLOBAL_GAIN);
@@ -703,9 +635,9 @@ static int mt9m111_get_global_gain(struct soc_camera_device *icd)
 	return data;
 }
 
-static int mt9m111_set_global_gain(struct soc_camera_device *icd, int gain)
+static int mt9m111_set_global_gain(struct i2c_client *client, int gain)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct soc_camera_device *icd = client->dev.platform_data;
 	u16 val;
 
 	if (gain > 63 * 2 * 2)
@@ -722,10 +654,9 @@ static int mt9m111_set_global_gain(struct soc_camera_device *icd, int gain)
 	return reg_write(GLOBAL_GAIN, val);
 }
 
-static int mt9m111_set_autoexposure(struct soc_camera_device *icd, int on)
+static int mt9m111_set_autoexposure(struct i2c_client *client, int on)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct mt9m111 *mt9m111 = i2c_get_clientdata(client);
+	struct mt9m111 *mt9m111 = to_mt9m111(client);
 	int ret;
 
 	if (on)
@@ -739,10 +670,9 @@ static int mt9m111_set_autoexposure(struct soc_camera_device *icd, int on)
 	return ret;
 }
 
-static int mt9m111_set_autowhitebalance(struct soc_camera_device *icd, int on)
+static int mt9m111_set_autowhitebalance(struct i2c_client *client, int on)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct mt9m111 *mt9m111 = i2c_get_clientdata(client);
+	struct mt9m111 *mt9m111 = to_mt9m111(client);
 	int ret;
 
 	if (on)
@@ -756,11 +686,10 @@ static int mt9m111_set_autowhitebalance(struct soc_camera_device *icd, int on)
 	return ret;
 }
 
-static int mt9m111_get_control(struct soc_camera_device *icd,
-			       struct v4l2_control *ctrl)
+static int mt9m111_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct mt9m111 *mt9m111 = i2c_get_clientdata(client);
+	struct i2c_client *client = sd->priv;
+	struct mt9m111 *mt9m111 = to_mt9m111(client);
 	int data;
 
 	switch (ctrl->id) {
@@ -785,7 +714,7 @@ static int mt9m111_get_control(struct soc_camera_device *icd,
 		ctrl->value = !!(data & MT9M111_RMB_MIRROR_COLS);
 		break;
 	case V4L2_CID_GAIN:
-		data = mt9m111_get_global_gain(icd);
+		data = mt9m111_get_global_gain(client);
 		if (data < 0)
 			return data;
 		ctrl->value = data;
@@ -800,38 +729,36 @@ static int mt9m111_get_control(struct soc_camera_device *icd,
 	return 0;
 }
 
-static int mt9m111_set_control(struct soc_camera_device *icd,
-			       struct v4l2_control *ctrl)
+static int mt9m111_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct mt9m111 *mt9m111 = i2c_get_clientdata(client);
+	struct i2c_client *client = sd->priv;
+	struct mt9m111 *mt9m111 = to_mt9m111(client);
 	const struct v4l2_queryctrl *qctrl;
 	int ret;
 
 	qctrl = soc_camera_find_qctrl(&mt9m111_ops, ctrl->id);
-
 	if (!qctrl)
 		return -EINVAL;
 
 	switch (ctrl->id) {
 	case V4L2_CID_VFLIP:
 		mt9m111->vflip = ctrl->value;
-		ret = mt9m111_set_flip(icd, ctrl->value,
+		ret = mt9m111_set_flip(client, ctrl->value,
 					MT9M111_RMB_MIRROR_ROWS);
 		break;
 	case V4L2_CID_HFLIP:
 		mt9m111->hflip = ctrl->value;
-		ret = mt9m111_set_flip(icd, ctrl->value,
+		ret = mt9m111_set_flip(client, ctrl->value,
 					MT9M111_RMB_MIRROR_COLS);
 		break;
 	case V4L2_CID_GAIN:
-		ret = mt9m111_set_global_gain(icd, ctrl->value);
+		ret = mt9m111_set_global_gain(client, ctrl->value);
 		break;
 	case V4L2_CID_EXPOSURE_AUTO:
-		ret =  mt9m111_set_autoexposure(icd, ctrl->value);
+		ret =  mt9m111_set_autoexposure(client, ctrl->value);
 		break;
 	case V4L2_CID_AUTO_WHITE_BALANCE:
-		ret =  mt9m111_set_autowhitebalance(icd, ctrl->value);
+		ret =  mt9m111_set_autowhitebalance(client, ctrl->value);
 		break;
 	default:
 		ret = -EINVAL;
@@ -840,64 +767,70 @@ static int mt9m111_set_control(struct soc_camera_device *icd,
 	return ret;
 }
 
-static int mt9m111_restore_state(struct soc_camera_device *icd)
+static int mt9m111_restore_state(struct i2c_client *client)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct mt9m111 *mt9m111 = i2c_get_clientdata(client);
-
-	mt9m111_set_context(icd, mt9m111->context);
-	mt9m111_set_pixfmt(icd, mt9m111->pixfmt);
-	mt9m111_setup_rect(icd, &mt9m111->rect);
-	mt9m111_set_flip(icd, mt9m111->hflip, MT9M111_RMB_MIRROR_COLS);
-	mt9m111_set_flip(icd, mt9m111->vflip, MT9M111_RMB_MIRROR_ROWS);
-	mt9m111_set_global_gain(icd, icd->gain);
-	mt9m111_set_autoexposure(icd, mt9m111->autoexposure);
-	mt9m111_set_autowhitebalance(icd, mt9m111->autowhitebalance);
+	struct mt9m111 *mt9m111 = to_mt9m111(client);
+	struct soc_camera_device *icd = client->dev.platform_data;
+
+	mt9m111_set_context(client, mt9m111->context);
+	mt9m111_set_pixfmt(client, mt9m111->pixfmt);
+	mt9m111_setup_rect(client, &mt9m111->rect);
+	mt9m111_set_flip(client, mt9m111->hflip, MT9M111_RMB_MIRROR_COLS);
+	mt9m111_set_flip(client, mt9m111->vflip, MT9M111_RMB_MIRROR_ROWS);
+	mt9m111_set_global_gain(client, icd->gain);
+	mt9m111_set_autoexposure(client, mt9m111->autoexposure);
+	mt9m111_set_autowhitebalance(client, mt9m111->autowhitebalance);
 	return 0;
 }
 
 static int mt9m111_resume(struct soc_camera_device *icd)
 {
 	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct mt9m111 *mt9m111 = i2c_get_clientdata(client);
+	struct mt9m111 *mt9m111 = to_mt9m111(client);
 	int ret = 0;
 
 	if (mt9m111->powered) {
-		ret = mt9m111_enable(icd);
+		ret = mt9m111_enable(client);
 		if (!ret)
-			ret = mt9m111_reset(icd);
+			ret = mt9m111_reset(client);
 		if (!ret)
-			ret = mt9m111_restore_state(icd);
+			ret = mt9m111_restore_state(client);
 	}
 	return ret;
 }
 
-static int mt9m111_init(struct soc_camera_device *icd)
+static int mt9m111_init(struct v4l2_subdev *sd, u32 val)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct mt9m111 *mt9m111 = i2c_get_clientdata(client);
+	struct i2c_client *client = sd->priv;
+	struct mt9m111 *mt9m111 = to_mt9m111(client);
+	struct soc_camera_device *icd = client->dev.platform_data;
 	int ret;
 
 	mt9m111->context = HIGHPOWER;
-	ret = mt9m111_enable(icd);
+	ret = mt9m111_enable(client);
 	if (!ret)
-		ret = mt9m111_reset(icd);
+		ret = mt9m111_reset(client);
 	if (!ret)
-		ret = mt9m111_set_context(icd, mt9m111->context);
+		ret = mt9m111_set_context(client, mt9m111->context);
 	if (!ret)
-		ret = mt9m111_set_autoexposure(icd, mt9m111->autoexposure);
+		ret = mt9m111_set_autoexposure(client, mt9m111->autoexposure);
 	if (ret)
 		dev_err(&icd->dev, "mt9m11x init failed: %d\n", ret);
 	return ret;
 }
 
-static int mt9m111_release(struct soc_camera_device *icd)
+static int mt9m111_s_standby(struct v4l2_subdev *sd, u32 standby)
 {
+	struct i2c_client *client = sd->priv;
+	struct mt9m111 *mt9m111 = to_mt9m111(client);
 	int ret;
 
-	ret = mt9m111_disable(icd);
+	ret = reg_clear(RESET, MT9M111_RESET_CHIP_ENABLE);
+	if (!ret)
+		mt9m111->powered = 0;
+
 	if (ret < 0)
-		dev_err(&icd->dev, "mt9m11x release failed: %d\n", ret);
+		dev_err(&client->dev, "mt9m11x release failed: %d\n", ret);
 
 	return ret;
 }
@@ -909,7 +842,7 @@ static int mt9m111_release(struct soc_camera_device *icd)
 static int mt9m111_video_probe(struct soc_camera_device *icd,
 			       struct i2c_client *client)
 {
-	struct mt9m111 *mt9m111 = i2c_get_clientdata(client);
+	struct mt9m111 *mt9m111 = to_mt9m111(client);
 	s32 data;
 	int ret;
 
@@ -921,15 +854,10 @@ static int mt9m111_video_probe(struct soc_camera_device *icd,
 	    to_soc_camera_host(icd->dev.parent)->nr != icd->iface)
 		return -ENODEV;
 
-	/* Switch master clock on */
-	ret = soc_camera_video_start(icd, &client->dev);
-	if (ret)
-		goto evstart;
-
-	ret = mt9m111_enable(icd);
+	ret = mt9m111_enable(client);
 	if (ret)
 		goto ei2c;
-	ret = mt9m111_reset(icd);
+	ret = mt9m111_reset(client);
 	if (ret)
 		goto ei2c;
 
@@ -961,8 +889,6 @@ static int mt9m111_video_probe(struct soc_camera_device *icd,
 	mt9m111->swap_rgb_red_blue = 1;
 
 ei2c:
-	soc_camera_video_stop(icd);
-evstart:
 	return ret;
 }
 
@@ -975,6 +901,28 @@ static void mt9m111_video_remove(struct soc_camera_device *icd)
 	icd->ops = NULL;
 }
 
+static struct v4l2_subdev_core_ops mt9m111_subdev_core_ops = {
+	.init		= mt9m111_init,
+	.s_standby	= mt9m111_s_standby,
+	.g_ctrl		= mt9m111_g_ctrl,
+	.s_ctrl		= mt9m111_s_ctrl,
+	.g_chip_ident	= mt9m111_g_chip_ident,
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+	.g_register	= mt9m111_g_register,
+	.s_register	= mt9m111_s_register,
+#endif
+};
+
+static struct v4l2_subdev_video_ops mt9m111_subdev_video_ops = {
+	.s_fmt		= mt9m111_s_fmt,
+	.try_fmt	= mt9m111_try_fmt,
+};
+
+static struct v4l2_subdev_ops mt9m111_subdev_ops = {
+	.core	= &mt9m111_subdev_core_ops,
+	.video	= &mt9m111_subdev_video_ops,
+};
+
 static int mt9m111_probe(struct i2c_client *client,
 			 const struct i2c_device_id *did)
 {
@@ -1005,7 +953,7 @@ static int mt9m111_probe(struct i2c_client *client,
 	if (!mt9m111)
 		return -ENOMEM;
 
-	i2c_set_clientdata(client, mt9m111);
+	v4l2_i2c_subdev_init(&mt9m111->subdev, client, &mt9m111_subdev_ops);
 
 	/* Second stage probe - when a capture adapter is there */
 	icd->ops	= &mt9m111_ops;
@@ -1030,7 +978,7 @@ static int mt9m111_probe(struct i2c_client *client,
 
 static int mt9m111_remove(struct i2c_client *client)
 {
-	struct mt9m111 *mt9m111 = i2c_get_clientdata(client);
+	struct mt9m111 *mt9m111 = to_mt9m111(client);
 	struct soc_camera_device *icd = client->dev.platform_data;
 
 	mt9m111_video_remove(icd);
diff --git a/drivers/media/video/mt9t031.c b/drivers/media/video/mt9t031.c
index da09906..6673169 100644
--- a/drivers/media/video/mt9t031.c
+++ b/drivers/media/video/mt9t031.c
@@ -13,13 +13,13 @@
 #include <linux/i2c.h>
 #include <linux/log2.h>
 
-#include <media/v4l2-common.h>
+#include <media/v4l2-subdev.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/soc_camera.h>
 
 /* mt9t031 i2c address 0x5d
- * The platform has to define i2c_board_info
- * and call i2c_register_board_info() */
+ * The platform has to define i2c_board_info and link to it from
+ * struct soc_camera_link */
 
 /* mt9t031 selected register addresses */
 #define MT9T031_CHIP_VERSION		0x00
@@ -68,12 +68,18 @@ static const struct soc_camera_data_format mt9t031_colour_formats[] = {
 };
 
 struct mt9t031 {
+	struct v4l2_subdev subdev;
 	int model;	/* V4L2_IDENT_MT9T031* codes from v4l2-chip-ident.h */
 	unsigned char autoexposure;
 	u16 xskip;
 	u16 yskip;
 };
 
+static struct mt9t031 *to_mt9t031(const struct i2c_client *client)
+{
+	return container_of(i2c_get_clientdata(client), struct mt9t031, subdev);
+}
+
 static int reg_read(struct i2c_client *client, const u8 reg)
 {
 	s32 data = i2c_smbus_read_word_data(client, reg);
@@ -134,21 +140,11 @@ static int get_shutter(struct i2c_client *client, u32 *data)
 	return ret < 0 ? ret : 0;
 }
 
-static int mt9t031_init(struct soc_camera_device *icd)
+static int mt9t031_init(struct v4l2_subdev *sd, u32 val)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
+	struct i2c_client *client = sd->priv;
 	int ret;
 
-	if (icl->power) {
-		ret = icl->power(&client->dev, 1);
-		if (ret < 0) {
-			dev_err(icd->vdev->parent,
-				"Platform failed to power-on the camera.\n");
-			return ret;
-		}
-	}
-
 	/* Disable chip output, synchronous option update */
 	ret = reg_write(client, MT9T031_RESET, 1);
 	if (ret >= 0)
@@ -156,43 +152,34 @@ static int mt9t031_init(struct soc_camera_device *icd)
 	if (ret >= 0)
 		ret = reg_clear(client, MT9T031_OUTPUT_CONTROL, 2);
 
-	if (ret < 0 && icl->power)
-		icl->power(&client->dev, 0);
-
 	return ret >= 0 ? 0 : -EIO;
 }
 
-static int mt9t031_release(struct soc_camera_device *icd)
+static int mt9t031_s_standby(struct v4l2_subdev *sd, u32 standby)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
+	struct i2c_client *client = sd->priv;
 
 	/* Disable the chip */
 	reg_clear(client, MT9T031_OUTPUT_CONTROL, 2);
 
-	if (icl->power)
-		icl->power(&client->dev, 0);
-
 	return 0;
 }
 
-static int mt9t031_start_capture(struct soc_camera_device *icd)
+static int mt9t031_s_stream(struct v4l2_subdev *sd, int enable)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-
-	/* Switch to master "normal" mode */
-	if (reg_set(client, MT9T031_OUTPUT_CONTROL, 2) < 0)
-		return -EIO;
-	return 0;
-}
+	struct i2c_client *client = sd->priv;
+	int ret;
 
-static int mt9t031_stop_capture(struct soc_camera_device *icd)
-{
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	if (enable)
+		/* Switch to master "normal" mode */
+		ret = reg_set(client, MT9T031_OUTPUT_CONTROL, 2);
+	else
+		/* Stop sensor readout */
+		ret = reg_clear(client, MT9T031_OUTPUT_CONTROL, 2);
 
-	/* Stop sensor readout */
-	if (reg_clear(client, MT9T031_OUTPUT_CONTROL, 2) < 0)
+	if (ret < 0)
 		return -EIO;
+
 	return 0;
 }
 
@@ -236,7 +223,7 @@ static int mt9t031_set_params(struct soc_camera_device *icd,
 			      struct v4l2_rect *rect, u16 xskip, u16 yskip)
 {
 	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct mt9t031 *mt9t031 = i2c_get_clientdata(client);
+	struct mt9t031 *mt9t031 = to_mt9t031(client);
 	int ret;
 	u16 xbin, ybin, width, height, left, top;
 	const u16 hblank = MT9T031_HORIZONTAL_BLANK,
@@ -334,17 +321,17 @@ static int mt9t031_set_crop(struct soc_camera_device *icd,
 			    struct v4l2_rect *rect)
 {
 	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct mt9t031 *mt9t031 = i2c_get_clientdata(client);
+	struct mt9t031 *mt9t031 = to_mt9t031(client);
 
 	/* CROP - no change in scaling, or in limits */
 	return mt9t031_set_params(icd, rect, mt9t031->xskip, mt9t031->yskip);
 }
 
-static int mt9t031_set_fmt(struct soc_camera_device *icd,
-			   struct v4l2_format *f)
+static int mt9t031_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct mt9t031 *mt9t031 = i2c_get_clientdata(client);
+	struct i2c_client *client = sd->priv;
+	struct mt9t031 *mt9t031 = to_mt9t031(client);
+	struct soc_camera_device *icd = client->dev.platform_data;
 	int ret;
 	u16 xskip, yskip;
 	struct v4l2_rect rect = {
@@ -379,8 +366,7 @@ static int mt9t031_set_fmt(struct soc_camera_device *icd,
 	return ret;
 }
 
-static int mt9t031_try_fmt(struct soc_camera_device *icd,
-			   struct v4l2_format *f)
+static int mt9t031_try_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
 {
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 
@@ -399,11 +385,11 @@ static int mt9t031_try_fmt(struct soc_camera_device *icd,
 	return 0;
 }
 
-static int mt9t031_get_chip_id(struct soc_camera_device *icd,
-			       struct v4l2_dbg_chip_ident *id)
+static int mt9t031_g_chip_ident(struct v4l2_subdev *sd,
+				struct v4l2_dbg_chip_ident *id)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct mt9t031 *mt9t031 = i2c_get_clientdata(client);
+	struct i2c_client *client = sd->priv;
+	struct mt9t031 *mt9t031 = to_mt9t031(client);
 
 	if (id->match.type != V4L2_CHIP_MATCH_I2C_ADDR)
 		return -EINVAL;
@@ -418,10 +404,10 @@ static int mt9t031_get_chip_id(struct soc_camera_device *icd,
 }
 
 #ifdef CONFIG_VIDEO_ADV_DEBUG
-static int mt9t031_get_register(struct soc_camera_device *icd,
-				struct v4l2_dbg_register *reg)
+static int mt9t031_g_register(struct v4l2_subdev *sd,
+			      struct v4l2_dbg_register *reg)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct i2c_client *client = sd->priv;
 
 	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR || reg->reg > 0xff)
 		return -EINVAL;
@@ -437,10 +423,10 @@ static int mt9t031_get_register(struct soc_camera_device *icd,
 	return 0;
 }
 
-static int mt9t031_set_register(struct soc_camera_device *icd,
-				struct v4l2_dbg_register *reg)
+static int mt9t031_s_register(struct v4l2_subdev *sd,
+			      struct v4l2_dbg_register *reg)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct i2c_client *client = sd->priv;
 
 	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR || reg->reg > 0xff)
 		return -EINVAL;
@@ -501,35 +487,18 @@ static const struct v4l2_queryctrl mt9t031_controls[] = {
 	}
 };
 
-static int mt9t031_get_control(struct soc_camera_device *, struct v4l2_control *);
-static int mt9t031_set_control(struct soc_camera_device *, struct v4l2_control *);
-
 static struct soc_camera_ops mt9t031_ops = {
-	.owner			= THIS_MODULE,
-	.init			= mt9t031_init,
-	.release		= mt9t031_release,
-	.start_capture		= mt9t031_start_capture,
-	.stop_capture		= mt9t031_stop_capture,
 	.set_crop		= mt9t031_set_crop,
-	.set_fmt		= mt9t031_set_fmt,
-	.try_fmt		= mt9t031_try_fmt,
 	.set_bus_param		= mt9t031_set_bus_param,
 	.query_bus_param	= mt9t031_query_bus_param,
 	.controls		= mt9t031_controls,
 	.num_controls		= ARRAY_SIZE(mt9t031_controls),
-	.get_control		= mt9t031_get_control,
-	.set_control		= mt9t031_set_control,
-	.get_chip_id		= mt9t031_get_chip_id,
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-	.get_register		= mt9t031_get_register,
-	.set_register		= mt9t031_set_register,
-#endif
 };
 
-static int mt9t031_get_control(struct soc_camera_device *icd, struct v4l2_control *ctrl)
+static int mt9t031_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct mt9t031 *mt9t031 = i2c_get_clientdata(client);
+	struct i2c_client *client = sd->priv;
+	struct mt9t031 *mt9t031 = to_mt9t031(client);
 	int data;
 
 	switch (ctrl->id) {
@@ -552,10 +521,11 @@ static int mt9t031_get_control(struct soc_camera_device *icd, struct v4l2_contro
 	return 0;
 }
 
-static int mt9t031_set_control(struct soc_camera_device *icd, struct v4l2_control *ctrl)
+static int mt9t031_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct mt9t031 *mt9t031 = i2c_get_clientdata(client);
+	struct i2c_client *client = sd->priv;
+	struct mt9t031 *mt9t031 = to_mt9t031(client);
+	struct soc_camera_device *icd = client->dev.platform_data;
 	const struct v4l2_queryctrl *qctrl;
 	int data;
 
@@ -661,12 +631,11 @@ static int mt9t031_set_control(struct soc_camera_device *icd, struct v4l2_contro
 
 /* Interface active, can use i2c. If it fails, it can indeed mean, that
  * this wasn't our capture interface, so, we wait for the right one */
-static int mt9t031_video_probe(struct soc_camera_device *icd,
-			       struct i2c_client *client)
+static int mt9t031_video_probe(struct i2c_client *client)
 {
-	struct mt9t031 *mt9t031 = i2c_get_clientdata(client);
+	struct soc_camera_device *icd = client->dev.platform_data;
+	struct mt9t031 *mt9t031 = to_mt9t031(client);
 	s32 data;
-	int ret;
 
 	/* We must have a parent by now. And it cannot be a wrong one.
 	 * So this entire test is completely redundant. */
@@ -674,11 +643,6 @@ static int mt9t031_video_probe(struct soc_camera_device *icd,
 	    to_soc_camera_host(icd->dev.parent)->nr != icd->iface)
 		return -ENODEV;
 
-	/* Switch master clock on */
-	ret = soc_camera_video_start(icd, &client->dev);
-	if (ret)
-		return ret;
-
 	/* Enable the chip */
 	data = reg_write(client, MT9T031_CHIP_ENABLE, 1);
 	dev_dbg(&icd->dev, "write: %d\n", data);
@@ -686,8 +650,6 @@ static int mt9t031_video_probe(struct soc_camera_device *icd,
 	/* Read out the chip version register */
 	data = reg_read(client, MT9T031_CHIP_VERSION);
 
-	soc_camera_video_stop(icd);
-
 	switch (data) {
 	case 0x1621:
 		mt9t031->model = V4L2_IDENT_MT9T031;
@@ -714,6 +676,29 @@ static void mt9t031_video_remove(struct soc_camera_device *icd)
 	icd->ops = NULL;
 }
 
+static struct v4l2_subdev_core_ops mt9t031_subdev_core_ops = {
+	.init		= mt9t031_init,
+	.s_standby	= mt9t031_s_standby,
+	.g_ctrl		= mt9t031_g_ctrl,
+	.s_ctrl		= mt9t031_s_ctrl,
+	.g_chip_ident	= mt9t031_g_chip_ident,
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+	.g_register	= mt9t031_g_register,
+	.s_register	= mt9t031_s_register,
+#endif
+};
+
+static struct v4l2_subdev_video_ops mt9t031_subdev_video_ops = {
+	.s_stream	= mt9t031_s_stream,
+	.s_fmt		= mt9t031_s_fmt,
+	.try_fmt	= mt9t031_try_fmt,
+};
+
+static struct v4l2_subdev_ops mt9t031_subdev_ops = {
+	.core	= &mt9t031_subdev_core_ops,
+	.video	= &mt9t031_subdev_video_ops,
+};
+
 static int mt9t031_probe(struct i2c_client *client,
 			 const struct i2c_device_id *did)
 {
@@ -744,7 +729,7 @@ static int mt9t031_probe(struct i2c_client *client,
 	if (!mt9t031)
 		return -ENOMEM;
 
-	i2c_set_clientdata(client, mt9t031);
+	v4l2_i2c_subdev_init(&mt9t031->subdev, client, &mt9t031_subdev_ops);
 
 	/* Second stage probe - when a capture adapter is there */
 	icd->ops	= &mt9t031_ops;
@@ -764,7 +749,12 @@ static int mt9t031_probe(struct i2c_client *client,
 	mt9t031->xskip = 1;
 	mt9t031->yskip = 1;
 
-	ret = mt9t031_video_probe(icd, client);
+	mt9t031_init(&mt9t031->subdev, 0);
+
+	ret = mt9t031_video_probe(client);
+
+	mt9t031_s_standby(&mt9t031->subdev, 0);
+
 	if (ret) {
 		icd->ops = NULL;
 		i2c_set_clientdata(client, NULL);
@@ -776,10 +766,10 @@ static int mt9t031_probe(struct i2c_client *client,
 
 static int mt9t031_remove(struct i2c_client *client)
 {
-	struct mt9t031 *mt9t031 = i2c_get_clientdata(client);
-	struct soc_camera_device *icd = client->dev.platform_data;
+	struct mt9t031 *mt9t031 = to_mt9t031(client);
 
-	mt9t031_video_remove(icd);
+	mt9t031_video_remove(client->dev.platform_data);
+	v4l2_device_unregister_subdev(&mt9t031->subdev);
 	i2c_set_clientdata(client, NULL);
 	client->driver = NULL;
 	kfree(mt9t031);
diff --git a/drivers/media/video/mt9v022.c b/drivers/media/video/mt9v022.c
index 1683af1..6aae960 100644
--- a/drivers/media/video/mt9v022.c
+++ b/drivers/media/video/mt9v022.c
@@ -14,13 +14,13 @@
 #include <linux/delay.h>
 #include <linux/log2.h>
 
-#include <media/v4l2-common.h>
+#include <media/v4l2-subdev.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/soc_camera.h>
 
 /* mt9v022 i2c address 0x48, 0x4c, 0x58, 0x5c
- * The platform has to define i2c_board_info
- * and call i2c_register_board_info() */
+ * The platform has to define ctruct i2c_board_info objects and link to them
+ * from struct soc_camera_link */
 
 static char *sensor_type;
 module_param(sensor_type, charp, S_IRUGO);
@@ -85,10 +85,16 @@ static const struct soc_camera_data_format mt9v022_monochrome_formats[] = {
 };
 
 struct mt9v022 {
+	struct v4l2_subdev subdev;
 	int model;	/* V4L2_IDENT_MT9V022* codes from v4l2-chip-ident.h */
 	u16 chip_control;
 };
 
+static struct mt9v022 *to_mt9v022(const struct i2c_client *client)
+{
+	return container_of(i2c_get_clientdata(client), struct mt9v022, subdev);
+}
+
 static int reg_read(struct i2c_client *client, const u8 reg)
 {
 	s32 data = i2c_smbus_read_word_data(client, reg);
@@ -123,29 +129,12 @@ static int reg_clear(struct i2c_client *client, const u8 reg,
 	return reg_write(client, reg, ret & ~data);
 }
 
-static int mt9v022_init(struct soc_camera_device *icd)
+static int mt9v022_init(struct v4l2_subdev *sd, u32 val)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
-	struct mt9v022 *mt9v022 = i2c_get_clientdata(client);
+	struct i2c_client *client = sd->priv;
+	struct mt9v022 *mt9v022 = to_mt9v022(client);
 	int ret;
 
-	if (icl->power) {
-		ret = icl->power(&client->dev, 1);
-		if (ret < 0) {
-			dev_err(icd->vdev->parent,
-				"Platform failed to power-on the camera.\n");
-			return ret;
-		}
-	}
-
-	/*
-	 * The camera could have been already on, we hard-reset it additionally,
-	 * if available. Soft reset is done in video_probe().
-	 */
-	if (icl->reset)
-		icl->reset(&client->dev);
-
 	/* Almost the default mode: master, parallel, simultaneous, and an
 	 * undocumented bit 0x200, which is present in table 7, but not in 8,
 	 * plus snapshot mode to disable scan for now */
@@ -169,37 +158,19 @@ static int mt9v022_init(struct soc_camera_device *icd)
 	return ret;
 }
 
-static int mt9v022_release(struct soc_camera_device *icd)
+static int mt9v022_s_stream(struct v4l2_subdev *sd, int enable)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
-
-	if (icl->power)
-		icl->power(&client->dev, 0);
+	struct i2c_client *client = sd->priv;
+	struct mt9v022 *mt9v022 = to_mt9v022(client);
 
-	return 0;
-}
-
-static int mt9v022_start_capture(struct soc_camera_device *icd)
-{
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct mt9v022 *mt9v022 = i2c_get_clientdata(client);
-	/* Switch to master "normal" mode */
-	mt9v022->chip_control &= ~0x10;
-	if (reg_write(client, MT9V022_CHIP_CONTROL,
-		      mt9v022->chip_control) < 0)
-		return -EIO;
-	return 0;
-}
+	if (enable)
+		/* Switch to master "normal" mode */
+		mt9v022->chip_control &= ~0x10;
+	else
+		/* Switch to snapshot mode */
+		mt9v022->chip_control |= 0x10;
 
-static int mt9v022_stop_capture(struct soc_camera_device *icd)
-{
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct mt9v022 *mt9v022 = i2c_get_clientdata(client);
-	/* Switch to snapshot mode */
-	mt9v022->chip_control |= 0x10;
-	if (reg_write(client, MT9V022_CHIP_CONTROL,
-		      mt9v022->chip_control) < 0)
+	if (reg_write(client, MT9V022_CHIP_CONTROL, mt9v022->chip_control) < 0)
 		return -EIO;
 	return 0;
 }
@@ -208,7 +179,7 @@ static int mt9v022_set_bus_param(struct soc_camera_device *icd,
 				 unsigned long flags)
 {
 	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct mt9v022 *mt9v022 = i2c_get_clientdata(client);
+	struct mt9v022 *mt9v022 = to_mt9v022(client);
 	struct soc_camera_link *icl = to_soc_camera_link(icd);
 	unsigned int width_flag = flags & SOCAM_DATAWIDTH_MASK;
 	int ret;
@@ -320,11 +291,11 @@ static int mt9v022_set_crop(struct soc_camera_device *icd,
 	return 0;
 }
 
-static int mt9v022_set_fmt(struct soc_camera_device *icd,
-			   struct v4l2_format *f)
+static int mt9v022_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct mt9v022 *mt9v022 = i2c_get_clientdata(client);
+	struct i2c_client *client = sd->priv;
+	struct mt9v022 *mt9v022 = to_mt9v022(client);
+	struct soc_camera_device *icd = client->dev.platform_data;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 	struct v4l2_rect rect = {
 		.left	= icd->x_current,
@@ -357,9 +328,10 @@ static int mt9v022_set_fmt(struct soc_camera_device *icd,
 	return mt9v022_set_crop(icd, &rect);
 }
 
-static int mt9v022_try_fmt(struct soc_camera_device *icd,
-			   struct v4l2_format *f)
+static int mt9v022_try_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
 {
+	struct i2c_client *client = sd->priv;
+	struct soc_camera_device *icd = client->dev.platform_data;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 
 	if (pix->height < 32 + icd->y_skip_top)
@@ -375,11 +347,11 @@ static int mt9v022_try_fmt(struct soc_camera_device *icd,
 	return 0;
 }
 
-static int mt9v022_get_chip_id(struct soc_camera_device *icd,
-			       struct v4l2_dbg_chip_ident *id)
+static int mt9v022_g_chip_ident(struct v4l2_subdev *sd,
+				struct v4l2_dbg_chip_ident *id)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct mt9v022 *mt9v022 = i2c_get_clientdata(client);
+	struct i2c_client *client = sd->priv;
+	struct mt9v022 *mt9v022 = to_mt9v022(client);
 
 	if (id->match.type != V4L2_CHIP_MATCH_I2C_ADDR)
 		return -EINVAL;
@@ -394,10 +366,10 @@ static int mt9v022_get_chip_id(struct soc_camera_device *icd,
 }
 
 #ifdef CONFIG_VIDEO_ADV_DEBUG
-static int mt9v022_get_register(struct soc_camera_device *icd,
-				struct v4l2_dbg_register *reg)
+static int mt9v022_g_register(struct v4l2_subdev *sd,
+			      struct v4l2_dbg_register *reg)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct i2c_client *client = sd->priv;
 
 	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR || reg->reg > 0xff)
 		return -EINVAL;
@@ -414,10 +386,10 @@ static int mt9v022_get_register(struct soc_camera_device *icd,
 	return 0;
 }
 
-static int mt9v022_set_register(struct soc_camera_device *icd,
-				struct v4l2_dbg_register *reg)
+static int mt9v022_s_register(struct v4l2_subdev *sd,
+			      struct v4l2_dbg_register *reg)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct i2c_client *client = sd->priv;
 
 	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR || reg->reg > 0xff)
 		return -EINVAL;
@@ -486,35 +458,17 @@ static const struct v4l2_queryctrl mt9v022_controls[] = {
 	}
 };
 
-static int mt9v022_get_control(struct soc_camera_device *, struct v4l2_control *);
-static int mt9v022_set_control(struct soc_camera_device *, struct v4l2_control *);
-
 static struct soc_camera_ops mt9v022_ops = {
-	.owner			= THIS_MODULE,
-	.init			= mt9v022_init,
-	.release		= mt9v022_release,
-	.start_capture		= mt9v022_start_capture,
-	.stop_capture		= mt9v022_stop_capture,
 	.set_crop		= mt9v022_set_crop,
-	.set_fmt		= mt9v022_set_fmt,
-	.try_fmt		= mt9v022_try_fmt,
 	.set_bus_param		= mt9v022_set_bus_param,
 	.query_bus_param	= mt9v022_query_bus_param,
 	.controls		= mt9v022_controls,
 	.num_controls		= ARRAY_SIZE(mt9v022_controls),
-	.get_control		= mt9v022_get_control,
-	.set_control		= mt9v022_set_control,
-	.get_chip_id		= mt9v022_get_chip_id,
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-	.get_register		= mt9v022_get_register,
-	.set_register		= mt9v022_set_register,
-#endif
 };
 
-static int mt9v022_get_control(struct soc_camera_device *icd,
-			       struct v4l2_control *ctrl)
+static int mt9v022_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct i2c_client *client = sd->priv;
 	int data;
 
 	switch (ctrl->id) {
@@ -546,15 +500,14 @@ static int mt9v022_get_control(struct soc_camera_device *icd,
 	return 0;
 }
 
-static int mt9v022_set_control(struct soc_camera_device *icd,
-			       struct v4l2_control *ctrl)
+static int mt9v022_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 {
 	int data;
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct i2c_client *client = sd->priv;
+	struct soc_camera_device *icd = client->dev.platform_data;
 	const struct v4l2_queryctrl *qctrl;
 
 	qctrl = soc_camera_find_qctrl(&mt9v022_ops, ctrl->id);
-
 	if (!qctrl)
 		return -EINVAL;
 
@@ -650,7 +603,7 @@ static int mt9v022_set_control(struct soc_camera_device *icd,
 static int mt9v022_video_probe(struct soc_camera_device *icd,
 			       struct i2c_client *client)
 {
-	struct mt9v022 *mt9v022 = i2c_get_clientdata(client);
+	struct mt9v022 *mt9v022 = to_mt9v022(client);
 	struct soc_camera_link *icl = to_soc_camera_link(icd);
 	s32 data;
 	int ret;
@@ -660,11 +613,6 @@ static int mt9v022_video_probe(struct soc_camera_device *icd,
 	    to_soc_camera_host(icd->dev.parent)->nr != icd->iface)
 		return -ENODEV;
 
-	/* Switch master clock on */
-	ret = soc_camera_video_start(icd, &client->dev);
-	if (ret)
-		return ret;
-
 	/* Read out the chip version register */
 	data = reg_read(client, MT9V022_CHIP_VERSION);
 
@@ -729,8 +677,6 @@ static int mt9v022_video_probe(struct soc_camera_device *icd,
 		 "monochrome" : "colour");
 
 ei2c:
-	soc_camera_video_stop(icd);
-
 	return ret;
 }
 
@@ -746,6 +692,28 @@ static void mt9v022_video_remove(struct soc_camera_device *icd)
 		icl->free_bus(icl);
 }
 
+static struct v4l2_subdev_core_ops mt9v022_subdev_core_ops = {
+	.init		= mt9v022_init,
+	.g_ctrl		= mt9v022_g_ctrl,
+	.s_ctrl		= mt9v022_s_ctrl,
+	.g_chip_ident	= mt9v022_g_chip_ident,
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+	.g_register	= mt9v022_g_register,
+	.s_register	= mt9v022_s_register,
+#endif
+};
+
+static struct v4l2_subdev_video_ops mt9v022_subdev_video_ops = {
+	.s_stream	= mt9v022_s_stream,
+	.s_fmt		= mt9v022_s_fmt,
+	.try_fmt	= mt9v022_try_fmt,
+};
+
+static struct v4l2_subdev_ops mt9v022_subdev_ops = {
+	.core	= &mt9v022_subdev_core_ops,
+	.video	= &mt9v022_subdev_video_ops,
+};
+
 static int mt9v022_probe(struct i2c_client *client,
 			 const struct i2c_device_id *did)
 {
@@ -776,8 +744,9 @@ static int mt9v022_probe(struct i2c_client *client,
 	if (!mt9v022)
 		return -ENOMEM;
 
+	v4l2_i2c_subdev_init(&mt9v022->subdev, client, &mt9v022_subdev_ops);
+
 	mt9v022->chip_control = MT9V022_CHIP_CONTROL_DEFAULT;
-	i2c_set_clientdata(client, mt9v022);
 
 	icd->ops	= &mt9v022_ops;
 	icd->x_min	= 1;
@@ -801,7 +770,7 @@ static int mt9v022_probe(struct i2c_client *client,
 
 static int mt9v022_remove(struct i2c_client *client)
 {
-	struct mt9v022 *mt9v022 = i2c_get_clientdata(client);
+	struct mt9v022 *mt9v022 = to_mt9v022(client);
 	struct soc_camera_device *icd = client->dev.platform_data;
 
 	mt9v022_video_remove(icd);
diff --git a/drivers/media/video/mx1_camera.c b/drivers/media/video/mx1_camera.c
index 2d07520..fc60266 100644
--- a/drivers/media/video/mx1_camera.c
+++ b/drivers/media/video/mx1_camera.c
@@ -219,7 +219,7 @@ static int mx1_camera_setup_dma(struct mx1_camera_dev *pcdev)
 	int ret;
 
 	if (unlikely(!pcdev->active)) {
-		dev_err(pcdev->soc_host.dev, "DMA End IRQ with no active buffer\n");
+		dev_err(pcdev->icd->dev.parent, "DMA End IRQ with no active buffer\n");
 		return -EFAULT;
 	}
 
@@ -229,7 +229,7 @@ static int mx1_camera_setup_dma(struct mx1_camera_dev *pcdev)
 		vbuf->size, pcdev->res->start +
 		CSIRXR, DMA_MODE_READ);
 	if (unlikely(ret))
-		dev_err(pcdev->soc_host.dev, "Failed to setup DMA sg list\n");
+		dev_err(pcdev->icd->dev.parent, "Failed to setup DMA sg list\n");
 
 	return ret;
 }
@@ -338,14 +338,14 @@ static void mx1_camera_dma_irq(int channel, void *data)
 	imx_dma_disable(channel);
 
 	if (unlikely(!pcdev->active)) {
-		dev_err(pcdev->soc_host.dev, "DMA End IRQ with no active buffer\n");
+		dev_err(pcdev->icd->dev.parent, "DMA End IRQ with no active buffer\n");
 		goto out;
 	}
 
 	vb = &pcdev->active->vb;
 	buf = container_of(vb, struct mx1_buffer, vb);
 	WARN_ON(buf->inwork || list_empty(&vb->queue));
-	dev_dbg(pcdev->soc_host.dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
+	dev_dbg(pcdev->icd->dev.parent, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
 		vb, vb->baddr, vb->bsize);
 
 	mx1_camera_wakeup(pcdev, vb, buf);
@@ -366,7 +366,7 @@ static void mx1_camera_init_videobuf(struct videobuf_queue *q,
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct mx1_camera_dev *pcdev = ici->priv;
 
-	videobuf_queue_dma_contig_init(q, &mx1_videobuf_ops, ici->dev,
+	videobuf_queue_dma_contig_init(q, &mx1_videobuf_ops, icd->dev.parent,
 					&pcdev->lock,
 					V4L2_BUF_TYPE_VIDEO_CAPTURE,
 					V4L2_FIELD_NONE,
@@ -385,7 +385,7 @@ static int mclk_get_divisor(struct mx1_camera_dev *pcdev)
 	 * they get a nice Oops */
 	div = (lcdclk + 2 * mclk - 1) / (2 * mclk) - 1;
 
-	dev_dbg(pcdev->soc_host.dev, "System clock %lukHz, target freq %dkHz, "
+	dev_dbg(pcdev->icd->dev.parent, "System clock %lukHz, target freq %dkHz, "
 		"divisor %lu\n", lcdclk / 1000, mclk / 1000, div);
 
 	return div;
@@ -395,7 +395,7 @@ static void mx1_camera_activate(struct mx1_camera_dev *pcdev)
 {
 	unsigned int csicr1 = CSICR1_EN;
 
-	dev_dbg(pcdev->soc_host.dev, "Activate device\n");
+	dev_dbg(pcdev->icd->dev.parent, "Activate device\n");
 
 	clk_enable(pcdev->clk);
 
@@ -411,7 +411,7 @@ static void mx1_camera_activate(struct mx1_camera_dev *pcdev)
 
 static void mx1_camera_deactivate(struct mx1_camera_dev *pcdev)
 {
-	dev_dbg(pcdev->soc_host.dev, "Deactivate device\n");
+	dev_dbg(pcdev->icd->dev.parent, "Deactivate device\n");
 
 	/* Disable all CSI interface */
 	__raw_writel(0x00, pcdev->base + CSICR1);
@@ -436,10 +436,8 @@ static int mx1_camera_add_device(struct soc_camera_device *icd)
 		 icd->devnum);
 
 	mx1_camera_activate(pcdev);
-	ret = icd->ops->init(icd);
 
-	if (!ret)
-		pcdev->icd = icd;
+	pcdev->icd = icd;
 
 ebusy:
 	return ret;
@@ -463,8 +461,6 @@ static void mx1_camera_remove_device(struct soc_camera_device *icd)
 	dev_info(&icd->dev, "MX1 Camera driver detached from camera %d\n",
 		 icd->devnum);
 
-	icd->ops->release(icd);
-
 	mx1_camera_deactivate(pcdev);
 
 	pcdev->icd = NULL;
@@ -550,11 +546,11 @@ static int mx1_camera_set_fmt(struct soc_camera_device *icd,
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
 	if (!xlate) {
-		dev_warn(ici->dev, "Format %x not found\n", pix->pixelformat);
+		dev_warn(icd->dev.parent, "Format %x not found\n", pix->pixelformat);
 		return -EINVAL;
 	}
 
-	ret = icd->ops->set_fmt(icd, f);
+	ret = v4l2_device_call_until_err(&ici->v4l2_dev, 0, video, s_fmt, f);
 	if (!ret) {
 		icd->buswidth = xlate->buswidth;
 		icd->current_fmt = xlate->host_fmt;
@@ -566,10 +562,11 @@ static int mx1_camera_set_fmt(struct soc_camera_device *icd,
 static int mx1_camera_try_fmt(struct soc_camera_device *icd,
 			      struct v4l2_format *f)
 {
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	/* TODO: limit to mx1 hardware capabilities */
 
 	/* limit to sensor capabilities */
-	return icd->ops->try_fmt(icd, f);
+	return v4l2_device_call_until_err(&ici->v4l2_dev, 0, video, try_fmt, f);
 }
 
 static int mx1_camera_reqbufs(struct soc_camera_file *icf,
@@ -741,7 +738,7 @@ static int __init mx1_camera_probe(struct platform_device *pdev)
 	pcdev->soc_host.drv_name	= DRIVER_NAME;
 	pcdev->soc_host.ops		= &mx1_soc_camera_host_ops;
 	pcdev->soc_host.priv		= pcdev;
-	pcdev->soc_host.dev		= &pdev->dev;
+	pcdev->soc_host.v4l2_dev.dev	= &pdev->dev;
 	pcdev->soc_host.nr		= pdev->id;
 	err = soc_camera_host_register(&pcdev->soc_host);
 	if (err)
diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
index 82873a7..d9bb68d 100644
--- a/drivers/media/video/mx3_camera.c
+++ b/drivers/media/video/mx3_camera.c
@@ -430,7 +430,7 @@ static void mx3_camera_init_videobuf(struct videobuf_queue *q,
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct mx3_camera_dev *mx3_cam = ici->priv;
 
-	videobuf_queue_dma_contig_init(q, &mx3_videobuf_ops, ici->dev,
+	videobuf_queue_dma_contig_init(q, &mx3_videobuf_ops, icd->dev.parent,
 				       &mx3_cam->lock,
 				       V4L2_BUF_TYPE_VIDEO_CAPTURE,
 				       V4L2_FIELD_NONE,
@@ -493,17 +493,11 @@ static int mx3_camera_add_device(struct soc_camera_device *icd)
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct mx3_camera_dev *mx3_cam = ici->priv;
-	int ret;
 
-	if (mx3_cam->icd) {
-		ret = -EBUSY;
-		goto ebusy;
-	}
+	if (mx3_cam->icd)
+		return -EBUSY;
 
 	mx3_camera_activate(mx3_cam, icd);
-	ret = icd->ops->init(icd);
-	if (ret < 0)
-		goto einit;
 
 	mx3_cam->icd = icd;
 
@@ -511,12 +505,6 @@ static int mx3_camera_add_device(struct soc_camera_device *icd)
 		 icd->devnum);
 
 	return 0;
-
-einit:
-	clk_disable(mx3_cam->clk);
-ebusy:
-
-	return ret;
 }
 
 /* Called with .video_lock held */
@@ -533,8 +521,6 @@ static void mx3_camera_remove_device(struct soc_camera_device *icd)
 		*ichan = NULL;
 	}
 
-	icd->ops->release(icd);
-
 	clk_disable(mx3_cam->clk);
 
 	mx3_cam->icd = NULL;
@@ -599,7 +585,7 @@ static int test_platform_param(struct mx3_camera_dev *mx3_cam,
 		*flags |= SOCAM_DATAWIDTH_4;
 		break;
 	default:
-		dev_info(mx3_cam->soc_host.dev, "Unsupported bus width %d\n",
+		dev_info(mx3_cam->soc_host.v4l2_dev.dev, "Unsupported bus width %d\n",
 			 buswidth);
 		return -EINVAL;
 	}
@@ -615,7 +601,7 @@ static int mx3_camera_try_bus_param(struct soc_camera_device *icd,
 	unsigned long bus_flags, camera_flags;
 	int ret = test_platform_param(mx3_cam, depth, &bus_flags);
 
-	dev_dbg(ici->dev, "requested bus width %d bit: %d\n", depth, ret);
+	dev_dbg(icd->dev.parent, "requested bus width %d bit: %d\n", depth, ret);
 
 	if (ret < 0)
 		return ret;
@@ -638,7 +624,7 @@ static bool chan_filter(struct dma_chan *chan, void *arg)
 	if (!rq)
 		return false;
 
-	pdata = rq->mx3_cam->soc_host.dev->platform_data;
+	pdata = rq->mx3_cam->soc_host.v4l2_dev.dev->platform_data;
 
 	return rq->id == chan->chan_id &&
 		pdata->dma_dev == chan->device->dev;
@@ -698,7 +684,7 @@ static int mx3_camera_get_formats(struct soc_camera_device *icd, int idx,
 			xlate->cam_fmt = icd->formats + idx;
 			xlate->buswidth = buswidth;
 			xlate++;
-			dev_dbg(ici->dev, "Providing format %s using %s\n",
+			dev_dbg(icd->dev.parent, "Providing format %s using %s\n",
 				mx3_camera_formats[0].name,
 				icd->formats[idx].name);
 		}
@@ -710,7 +696,7 @@ static int mx3_camera_get_formats(struct soc_camera_device *icd, int idx,
 			xlate->cam_fmt = icd->formats + idx;
 			xlate->buswidth = buswidth;
 			xlate++;
-			dev_dbg(ici->dev, "Providing format %s using %s\n",
+			dev_dbg(icd->dev.parent, "Providing format %s using %s\n",
 				mx3_camera_formats[0].name,
 				icd->formats[idx].name);
 		}
@@ -723,7 +709,7 @@ passthrough:
 			xlate->cam_fmt = icd->formats + idx;
 			xlate->buswidth = buswidth;
 			xlate++;
-			dev_dbg(ici->dev,
+			dev_dbg(icd->dev.parent,
 				"Providing format %s in pass-through mode\n",
 				icd->formats[idx].name);
 		}
@@ -830,7 +816,7 @@ static int mx3_camera_set_fmt(struct soc_camera_device *icd,
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
 	if (!xlate) {
-		dev_warn(ici->dev, "Format %x not found\n", pix->pixelformat);
+		dev_warn(icd->dev.parent, "Format %x not found\n", pix->pixelformat);
 		return -EINVAL;
 	}
 
@@ -846,7 +832,7 @@ static int mx3_camera_set_fmt(struct soc_camera_device *icd,
 
 	configure_geometry(mx3_cam, &rect);
 
-	ret = icd->ops->set_fmt(icd, f);
+	ret = v4l2_device_call_until_err(&ici->v4l2_dev, 0, video, s_fmt, f);
 	if (!ret) {
 		icd->buswidth = xlate->buswidth;
 		icd->current_fmt = xlate->host_fmt;
@@ -867,7 +853,7 @@ static int mx3_camera_try_fmt(struct soc_camera_device *icd,
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
 	if (pixfmt && !xlate) {
-		dev_warn(ici->dev, "Format %x not found\n", pixfmt);
+		dev_warn(icd->dev.parent, "Format %x not found\n", pixfmt);
 		return -EINVAL;
 	}
 
@@ -884,7 +870,7 @@ static int mx3_camera_try_fmt(struct soc_camera_device *icd,
 	/* camera has to see its format, but the user the original one */
 	pix->pixelformat = xlate->cam_fmt->fourcc;
 	/* limit to sensor capabilities */
-	ret = icd->ops->try_fmt(icd, f);
+	ret = v4l2_device_call_until_err(&ici->v4l2_dev, 0, video, try_fmt, f);
 	pix->pixelformat = xlate->host_fmt->fourcc;
 
 	field = pix->field;
@@ -934,11 +920,11 @@ static int mx3_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
 	if (!xlate) {
-		dev_warn(ici->dev, "Format %x not found\n", pixfmt);
+		dev_warn(icd->dev.parent, "Format %x not found\n", pixfmt);
 		return -EINVAL;
 	}
 
-	dev_dbg(ici->dev, "requested bus width %d bit: %d\n",
+	dev_dbg(icd->dev.parent, "requested bus width %d bit: %d\n",
 		icd->buswidth, ret);
 
 	if (ret < 0)
@@ -947,10 +933,10 @@ static int mx3_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 	camera_flags = icd->ops->query_bus_param(icd);
 
 	common_flags = soc_camera_bus_param_compatible(camera_flags, bus_flags);
-	dev_dbg(ici->dev, "Flags cam: 0x%lx host: 0x%lx common: 0x%lx\n",
+	dev_dbg(icd->dev.parent, "Flags cam: 0x%lx host: 0x%lx common: 0x%lx\n",
 		camera_flags, bus_flags, common_flags);
 	if (!common_flags) {
-		dev_dbg(ici->dev, "no common flags");
+		dev_dbg(icd->dev.parent, "no common flags");
 		return -EINVAL;
 	}
 
@@ -1004,7 +990,7 @@ static int mx3_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 
 	ret = icd->ops->set_bus_param(icd, common_flags);
 	if (ret < 0) {
-		dev_dbg(ici->dev, "camera set_bus_param(%lx) returned %d\n",
+		dev_dbg(icd->dev.parent, "camera set_bus_param(%lx) returned %d\n",
 			common_flags, ret);
 		return ret;
 	}
@@ -1059,7 +1045,7 @@ static int mx3_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 
 	csi_reg_write(mx3_cam, sens_conf | dw, CSI_SENS_CONF);
 
-	dev_dbg(ici->dev, "Set SENS_CONF to %x\n", sens_conf | dw);
+	dev_dbg(icd->dev.parent, "Set SENS_CONF to %x\n", sens_conf | dw);
 
 	return 0;
 }
@@ -1144,7 +1130,7 @@ static int mx3_camera_probe(struct platform_device *pdev)
 	soc_host->drv_name	= MX3_CAM_DRV_NAME;
 	soc_host->ops		= &mx3_soc_camera_host_ops;
 	soc_host->priv		= mx3_cam;
-	soc_host->dev		= &pdev->dev;
+	soc_host->v4l2_dev.dev	= &pdev->dev;
 	soc_host->nr		= pdev->id;
 
 	err = soc_camera_host_register(soc_host);
diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
index bc4dc6e..b723d60 100644
--- a/drivers/media/video/ov772x.c
+++ b/drivers/media/video/ov772x.c
@@ -22,7 +22,7 @@
 #include <linux/delay.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-chip-ident.h>
-#include <media/v4l2-common.h>
+#include <media/v4l2-subdev.h>
 #include <media/soc_camera.h>
 #include <media/ov772x.h>
 
@@ -398,6 +398,7 @@ struct ov772x_win_size {
 };
 
 struct ov772x_priv {
+	struct v4l2_subdev                subdev;
 	struct ov772x_camera_info        *info;
 	const struct ov772x_color_format *fmt;
 	const struct ov772x_win_size     *win;
@@ -575,6 +576,11 @@ static const struct v4l2_queryctrl ov772x_controls[] = {
  * general function
  */
 
+static struct ov772x_priv *to_ov772x(const struct i2c_client *client)
+{
+	return container_of(i2c_get_clientdata(client), struct ov772x_priv, subdev);
+}
+
 static int ov772x_write_array(struct i2c_client        *client,
 			      const struct regval_list *vals)
 {
@@ -615,61 +621,29 @@ static int ov772x_reset(struct i2c_client *client)
  * soc_camera_ops function
  */
 
-static int ov772x_init(struct soc_camera_device *icd)
+static int ov772x_s_stream(struct v4l2_subdev *sd, int enable)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
-	int ret = 0;
+	struct i2c_client *client = sd->priv;
+	struct ov772x_priv *priv = to_ov772x(client);
 
-	if (icl->power) {
-		ret = icl->power(&client->dev, 1);
-		if (ret < 0)
-			return ret;
+	if (!enable) {
+		ov772x_mask_set(client, COM2, SOFT_SLEEP_MODE, SOFT_SLEEP_MODE);
+		return 0;
 	}
 
-	if (icl->reset)
-		ret = icl->reset(&client->dev);
-
-	return ret;
-}
-
-static int ov772x_release(struct soc_camera_device *icd)
-{
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
-	int ret = 0;
-
-	if (icl->power)
-		ret = icl->power(&client->dev, 0);
-
-	return ret;
-}
-
-static int ov772x_start_capture(struct soc_camera_device *icd)
-{
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct ov772x_priv *priv = i2c_get_clientdata(client);
-
 	if (!priv->win || !priv->fmt) {
-		dev_err(&icd->dev, "norm or win select error\n");
+		dev_err(&client->dev, "norm or win select error\n");
 		return -EPERM;
 	}
 
 	ov772x_mask_set(client, COM2, SOFT_SLEEP_MODE, 0);
 
-	dev_dbg(&icd->dev,
+	dev_dbg(&client->dev,
 		"format %s, win %s\n", priv->fmt->name, priv->win->name);
 
 	return 0;
 }
 
-static int ov772x_stop_capture(struct soc_camera_device *icd)
-{
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	ov772x_mask_set(client, COM2, SOFT_SLEEP_MODE, SOFT_SLEEP_MODE);
-	return 0;
-}
-
 static int ov772x_set_bus_param(struct soc_camera_device *icd,
 				unsigned long		  flags)
 {
@@ -688,11 +662,10 @@ static unsigned long ov772x_query_bus_param(struct soc_camera_device *icd)
 	return soc_camera_apply_sensor_flags(icl, flags);
 }
 
-static int ov772x_get_control(struct soc_camera_device *icd,
-			      struct v4l2_control *ctrl)
+static int ov772x_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct ov772x_priv *priv = i2c_get_clientdata(client);
+	struct i2c_client *client = sd->priv;
+	struct ov772x_priv *priv = to_ov772x(client);
 
 	switch (ctrl->id) {
 	case V4L2_CID_VFLIP:
@@ -705,11 +678,10 @@ static int ov772x_get_control(struct soc_camera_device *icd,
 	return 0;
 }
 
-static int ov772x_set_control(struct soc_camera_device *icd,
-			      struct v4l2_control *ctrl)
+static int ov772x_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct ov772x_priv *priv = i2c_get_clientdata(client);
+	struct i2c_client *client = sd->priv;
+	struct ov772x_priv *priv = to_ov772x(client);
 	int ret = 0;
 	u8 val;
 
@@ -733,11 +705,11 @@ static int ov772x_set_control(struct soc_camera_device *icd,
 	return ret;
 }
 
-static int ov772x_get_chip_id(struct soc_camera_device *icd,
-			      struct v4l2_dbg_chip_ident *id)
+static int ov772x_g_chip_ident(struct v4l2_subdev *sd,
+			       struct v4l2_dbg_chip_ident *id)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct ov772x_priv *priv = i2c_get_clientdata(client);
+	struct i2c_client *client = sd->priv;
+	struct ov772x_priv *priv = to_ov772x(client);
 
 	id->ident    = priv->model;
 	id->revision = 0;
@@ -746,10 +718,10 @@ static int ov772x_get_chip_id(struct soc_camera_device *icd,
 }
 
 #ifdef CONFIG_VIDEO_ADV_DEBUG
-static int ov772x_get_register(struct soc_camera_device *icd,
-			       struct v4l2_dbg_register *reg)
+static int ov772x_g_register(struct v4l2_subdev *sd,
+			     struct v4l2_dbg_register *reg)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct i2c_client *client = sd->priv;
 	int ret;
 
 	reg->size = 1;
@@ -765,10 +737,10 @@ static int ov772x_get_register(struct soc_camera_device *icd,
 	return 0;
 }
 
-static int ov772x_set_register(struct soc_camera_device *icd,
-			       struct v4l2_dbg_register *reg)
+static int ov772x_s_register(struct v4l2_subdev *sd,
+			     struct v4l2_dbg_register *reg)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct i2c_client *client = sd->priv;
 
 	if (reg->reg > 0xff ||
 	    reg->val > 0xff)
@@ -778,8 +750,7 @@ static int ov772x_set_register(struct soc_camera_device *icd,
 }
 #endif
 
-static const struct ov772x_win_size*
-ov772x_select_win(u32 width, u32 height)
+static const struct ov772x_win_size *ov772x_select_win(u32 width, u32 height)
 {
 	__u32 diff;
 	const struct ov772x_win_size *win;
@@ -798,11 +769,10 @@ ov772x_select_win(u32 width, u32 height)
 	return win;
 }
 
-static int ov772x_set_params(struct soc_camera_device *icd,
+static int ov772x_set_params(struct i2c_client *client,
 			     u32 width, u32 height, u32 pixfmt)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct ov772x_priv *priv = i2c_get_clientdata(client);
+	struct ov772x_priv *priv = to_ov772x(client);
 	int ret = -EINVAL;
 	u8  val;
 	int i;
@@ -817,7 +787,6 @@ static int ov772x_set_params(struct soc_camera_device *icd,
 			break;
 		}
 	}
-	dev_dbg(&icd->dev, "Using fmt %x #%d\n", pixfmt, i);
 	if (!priv->fmt)
 		goto ov772x_set_fmt_error;
 
@@ -939,26 +908,26 @@ static int ov772x_set_crop(struct soc_camera_device *icd,
 			   struct v4l2_rect *rect)
 {
 	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct ov772x_priv *priv = i2c_get_clientdata(client);
+	struct ov772x_priv *priv = to_ov772x(client);
 
 	if (!priv->fmt)
 		return -EINVAL;
 
-	return ov772x_set_params(icd, rect->width, rect->height,
+	return ov772x_set_params(client, rect->width, rect->height,
 				 priv->fmt->fourcc);
 }
 
-static int ov772x_set_fmt(struct soc_camera_device *icd,
-			  struct v4l2_format *f)
+static int ov772x_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
 {
+	struct i2c_client *client = sd->priv;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 
-	return ov772x_set_params(icd, pix->width, pix->height,
+	return ov772x_set_params(client, pix->width, pix->height,
 				 pix->pixelformat);
 }
 
-static int ov772x_try_fmt(struct soc_camera_device *icd,
-			  struct v4l2_format       *f)
+static int ov772x_try_fmt(struct v4l2_subdev *sd,
+			  struct v4l2_format *f)
 {
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 	const struct ov772x_win_size *win;
@@ -978,10 +947,9 @@ static int ov772x_try_fmt(struct soc_camera_device *icd,
 static int ov772x_video_probe(struct soc_camera_device *icd,
 			      struct i2c_client *client)
 {
-	struct ov772x_priv *priv = i2c_get_clientdata(client);
+	struct ov772x_priv *priv = to_ov772x(client);
 	u8                  pid, ver;
 	const char         *devname;
-	int ret;
 
 	/*
 	 * We must have a parent by now. And it cannot be a wrong one.
@@ -1003,11 +971,6 @@ static int ov772x_video_probe(struct soc_camera_device *icd,
 	icd->formats     = ov772x_fmt_lists;
 	icd->num_formats = ARRAY_SIZE(ov772x_fmt_lists);
 
-	/* Switch master clock on */
-	ret = soc_camera_video_start(icd, &client->dev);
-	if (ret)
-		return ret;
-
 	/*
 	 * check and show product ID and manufacturer ID
 	 */
@@ -1026,8 +989,7 @@ static int ov772x_video_probe(struct soc_camera_device *icd,
 	default:
 		dev_err(&icd->dev,
 			"Product ID error %x:%x\n", pid, ver);
-		ret = -ENODEV;
-		goto ever;
+		return -ENODEV;
 	}
 
 	dev_info(&icd->dev,
@@ -1038,10 +1000,7 @@ static int ov772x_video_probe(struct soc_camera_device *icd,
 		 i2c_smbus_read_byte_data(client, MIDH),
 		 i2c_smbus_read_byte_data(client, MIDL));
 
-	soc_camera_video_stop(icd);
-
-ever:
-	return ret;
+	return 0;
 }
 
 static void ov772x_video_remove(struct soc_camera_device *icd)
@@ -1050,27 +1009,34 @@ static void ov772x_video_remove(struct soc_camera_device *icd)
 }
 
 static struct soc_camera_ops ov772x_ops = {
-	.owner			= THIS_MODULE,
-	.init			= ov772x_init,
-	.release		= ov772x_release,
-	.start_capture		= ov772x_start_capture,
-	.stop_capture		= ov772x_stop_capture,
 	.set_crop		= ov772x_set_crop,
-	.set_fmt		= ov772x_set_fmt,
-	.try_fmt		= ov772x_try_fmt,
 	.set_bus_param		= ov772x_set_bus_param,
 	.query_bus_param	= ov772x_query_bus_param,
 	.controls		= ov772x_controls,
 	.num_controls		= ARRAY_SIZE(ov772x_controls),
-	.get_control		= ov772x_get_control,
-	.set_control		= ov772x_set_control,
-	.get_chip_id		= ov772x_get_chip_id,
+};
+
+static struct v4l2_subdev_core_ops ov772x_subdev_core_ops = {
+	.g_ctrl		= ov772x_g_ctrl,
+	.s_ctrl		= ov772x_s_ctrl,
+	.g_chip_ident	= ov772x_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
-	.get_register		= ov772x_get_register,
-	.set_register		= ov772x_set_register,
+	.g_register	= ov772x_g_register,
+	.s_register	= ov772x_s_register,
 #endif
 };
 
+static struct v4l2_subdev_video_ops ov772x_subdev_video_ops = {
+	.s_stream	= ov772x_s_stream,
+	.s_fmt		= ov772x_s_fmt,
+	.try_fmt	= ov772x_try_fmt,
+};
+
+static struct v4l2_subdev_ops ov772x_subdev_ops = {
+	.core	= &ov772x_subdev_core_ops,
+	.video	= &ov772x_subdev_video_ops,
+};
+
 /*
  * i2c_driver function
  */
@@ -1086,7 +1052,7 @@ static int ov772x_probe(struct i2c_client *client,
 	int                        ret;
 
 	if (!icd) {
-		dev_err(&client->dev, "MT9M001: missing soc-camera data!\n");
+		dev_err(&client->dev, "OV772X: missing soc-camera data!\n");
 		return -EINVAL;
 	}
 
@@ -1107,8 +1073,9 @@ static int ov772x_probe(struct i2c_client *client,
 	if (!priv)
 		return -ENOMEM;
 
-	priv->info   = info;
-	i2c_set_clientdata(client, priv);
+	priv->info = info;
+
+	v4l2_i2c_subdev_init(&priv->subdev, client, &ov772x_subdev_ops);
 
 	icd->ops        = &ov772x_ops;
 	icd->width_max  = MAX_WIDTH;
@@ -1125,7 +1092,7 @@ static int ov772x_probe(struct i2c_client *client,
 
 static int ov772x_remove(struct i2c_client *client)
 {
-	struct ov772x_priv *priv = i2c_get_clientdata(client);
+	struct ov772x_priv *priv = to_ov772x(client);
 	struct soc_camera_device *icd = client->dev.platform_data;
 
 	ov772x_video_remove(icd);
diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index 63964d0..dcc79e6 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -277,7 +277,7 @@ static void free_buffer(struct videobuf_queue *vq, struct pxa_buffer *buf)
 
 	for (i = 0; i < ARRAY_SIZE(buf->dmas); i++) {
 		if (buf->dmas[i].sg_cpu)
-			dma_free_coherent(ici->dev, buf->dmas[i].sg_size,
+			dma_free_coherent(ici->v4l2_dev.dev, buf->dmas[i].sg_size,
 					  buf->dmas[i].sg_cpu,
 					  buf->dmas[i].sg_dma);
 		buf->dmas[i].sg_cpu = NULL;
@@ -332,19 +332,20 @@ static int pxa_init_dma_channel(struct pxa_camera_dev *pcdev,
 				struct scatterlist **sg_first, int *sg_first_ofs)
 {
 	struct pxa_cam_dma *pxa_dma = &buf->dmas[channel];
+	struct device *dev = pcdev->soc_host.v4l2_dev.dev;
 	struct scatterlist *sg;
 	int i, offset, sglen;
 	int dma_len = 0, xfer_len = 0;
 
 	if (pxa_dma->sg_cpu)
-		dma_free_coherent(pcdev->soc_host.dev, pxa_dma->sg_size,
+		dma_free_coherent(dev, pxa_dma->sg_size,
 				  pxa_dma->sg_cpu, pxa_dma->sg_dma);
 
 	sglen = calculate_dma_sglen(*sg_first, dma->sglen,
 				    *sg_first_ofs, size);
 
 	pxa_dma->sg_size = (sglen + 1) * sizeof(struct pxa_dma_desc);
-	pxa_dma->sg_cpu = dma_alloc_coherent(pcdev->soc_host.dev, pxa_dma->sg_size,
+	pxa_dma->sg_cpu = dma_alloc_coherent(dev, pxa_dma->sg_size,
 					     &pxa_dma->sg_dma, GFP_KERNEL);
 	if (!pxa_dma->sg_cpu)
 		return -ENOMEM;
@@ -352,7 +353,7 @@ static int pxa_init_dma_channel(struct pxa_camera_dev *pcdev,
 	pxa_dma->sglen = sglen;
 	offset = *sg_first_ofs;
 
-	dev_dbg(pcdev->soc_host.dev, "DMA: sg_first=%p, sglen=%d, ofs=%d, dma.desc=%x\n",
+	dev_dbg(dev, "DMA: sg_first=%p, sglen=%d, ofs=%d, dma.desc=%x\n",
 		*sg_first, sglen, *sg_first_ofs, pxa_dma->sg_dma);
 
 
@@ -375,7 +376,7 @@ static int pxa_init_dma_channel(struct pxa_camera_dev *pcdev,
 		pxa_dma->sg_cpu[i].ddadr =
 			pxa_dma->sg_dma + (i + 1) * sizeof(struct pxa_dma_desc);
 
-		dev_vdbg(pcdev->soc_host.dev, "DMA: desc.%08x->@phys=0x%08x, len=%d\n",
+		dev_vdbg(dev, "DMA: desc.%08x->@phys=0x%08x, len=%d\n",
 			 pxa_dma->sg_dma + i * sizeof(struct pxa_dma_desc),
 			 sg_dma_address(sg) + offset, xfer_len);
 		offset = 0;
@@ -425,11 +426,12 @@ static int pxa_videobuf_prepare(struct videobuf_queue *vq,
 	struct soc_camera_device *icd = vq->priv_data;
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct pxa_camera_dev *pcdev = ici->priv;
+	struct device *dev = pcdev->soc_host.v4l2_dev.dev;
 	struct pxa_buffer *buf = container_of(vb, struct pxa_buffer, vb);
 	int ret;
 	int size_y, size_u = 0, size_v = 0;
 
-	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
+	dev_dbg(dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
 		vb, vb->baddr, vb->bsize);
 
 	/* Added list head initialization on alloc */
@@ -487,8 +489,7 @@ static int pxa_videobuf_prepare(struct videobuf_queue *vq,
 		ret = pxa_init_dma_channel(pcdev, buf, dma, 0, CIBR0, size_y,
 					   &sg, &next_ofs);
 		if (ret) {
-			dev_err(pcdev->soc_host.dev,
-				"DMA initialization for Y/RGB failed\n");
+			dev_err(dev, "DMA initialization for Y/RGB failed\n");
 			goto fail;
 		}
 
@@ -497,8 +498,7 @@ static int pxa_videobuf_prepare(struct videobuf_queue *vq,
 			ret = pxa_init_dma_channel(pcdev, buf, dma, 1, CIBR1,
 						   size_u, &sg, &next_ofs);
 		if (ret) {
-			dev_err(pcdev->soc_host.dev,
-				"DMA initialization for U failed\n");
+			dev_err(dev, "DMA initialization for U failed\n");
 			goto fail_u;
 		}
 
@@ -507,8 +507,7 @@ static int pxa_videobuf_prepare(struct videobuf_queue *vq,
 			ret = pxa_init_dma_channel(pcdev, buf, dma, 2, CIBR2,
 						   size_v, &sg, &next_ofs);
 		if (ret) {
-			dev_err(pcdev->soc_host.dev,
-				"DMA initialization for V failed\n");
+			dev_err(dev, "DMA initialization for V failed\n");
 			goto fail_v;
 		}
 
@@ -521,10 +520,10 @@ static int pxa_videobuf_prepare(struct videobuf_queue *vq,
 	return 0;
 
 fail_v:
-	dma_free_coherent(pcdev->soc_host.dev, buf->dmas[1].sg_size,
+	dma_free_coherent(dev, buf->dmas[1].sg_size,
 			  buf->dmas[1].sg_cpu, buf->dmas[1].sg_dma);
 fail_u:
-	dma_free_coherent(pcdev->soc_host.dev, buf->dmas[0].sg_size,
+	dma_free_coherent(dev, buf->dmas[0].sg_size,
 			  buf->dmas[0].sg_cpu, buf->dmas[0].sg_dma);
 fail:
 	free_buffer(vq, buf);
@@ -548,7 +547,7 @@ static void pxa_dma_start_channels(struct pxa_camera_dev *pcdev)
 	active = pcdev->active;
 
 	for (i = 0; i < pcdev->channels; i++) {
-		dev_dbg(pcdev->soc_host.dev, "%s (channel=%d) ddadr=%08x\n", __func__,
+		dev_dbg(pcdev->soc_host.v4l2_dev.dev, "%s (channel=%d) ddadr=%08x\n", __func__,
 			i, active->dmas[i].sg_dma);
 		DDADR(pcdev->dma_chans[i]) = active->dmas[i].sg_dma;
 		DCSR(pcdev->dma_chans[i]) = DCSR_RUN;
@@ -560,7 +559,7 @@ static void pxa_dma_stop_channels(struct pxa_camera_dev *pcdev)
 	int i;
 
 	for (i = 0; i < pcdev->channels; i++) {
-		dev_dbg(pcdev->soc_host.dev, "%s (channel=%d)\n", __func__, i);
+		dev_dbg(pcdev->soc_host.v4l2_dev.dev, "%s (channel=%d)\n", __func__, i);
 		DCSR(pcdev->dma_chans[i]) = 0;
 	}
 }
@@ -596,7 +595,7 @@ static void pxa_camera_start_capture(struct pxa_camera_dev *pcdev)
 {
 	unsigned long cicr0, cifr;
 
-	dev_dbg(pcdev->soc_host.dev, "%s\n", __func__);
+	dev_dbg(pcdev->soc_host.v4l2_dev.dev, "%s\n", __func__);
 	/* Reset the FIFOs */
 	cifr = __raw_readl(pcdev->base + CIFR) | CIFR_RESET_F;
 	__raw_writel(cifr, pcdev->base + CIFR);
@@ -616,7 +615,7 @@ static void pxa_camera_stop_capture(struct pxa_camera_dev *pcdev)
 	__raw_writel(cicr0, pcdev->base + CICR0);
 
 	pcdev->active = NULL;
-	dev_dbg(pcdev->soc_host.dev, "%s\n", __func__);
+	dev_dbg(pcdev->soc_host.v4l2_dev.dev, "%s\n", __func__);
 }
 
 static void pxa_videobuf_queue(struct videobuf_queue *vq,
@@ -685,7 +684,8 @@ static void pxa_camera_wakeup(struct pxa_camera_dev *pcdev,
 	do_gettimeofday(&vb->ts);
 	vb->field_count++;
 	wake_up(&vb->done);
-	dev_dbg(pcdev->soc_host.dev, "%s dequeud buffer (vb=0x%p)\n", __func__, vb);
+	dev_dbg(pcdev->soc_host.v4l2_dev.dev, "%s dequeud buffer (vb=0x%p)\n",
+		__func__, vb);
 
 	if (list_empty(&pcdev->capture)) {
 		pxa_camera_stop_capture(pcdev);
@@ -721,7 +721,8 @@ static void pxa_camera_check_link_miss(struct pxa_camera_dev *pcdev)
 	for (i = 0; i < pcdev->channels; i++)
 		if (DDADR(pcdev->dma_chans[i]) != DDADR_STOP)
 			is_dma_stopped = 0;
-	dev_dbg(pcdev->soc_host.dev, "%s : top queued buffer=%p, dma_stopped=%d\n",
+	dev_dbg(pcdev->soc_host.v4l2_dev.dev,
+		"%s : top queued buffer=%p, dma_stopped=%d\n",
 		__func__, pcdev->active, is_dma_stopped);
 	if (pcdev->active && is_dma_stopped)
 		pxa_camera_start_capture(pcdev);
@@ -730,6 +731,7 @@ static void pxa_camera_check_link_miss(struct pxa_camera_dev *pcdev)
 static void pxa_camera_dma_irq(int channel, struct pxa_camera_dev *pcdev,
 			       enum pxa_camera_active_dma act_dma)
 {
+	struct device *dev = pcdev->soc_host.v4l2_dev.dev;
 	struct pxa_buffer *buf;
 	unsigned long flags;
 	u32 status, camera_status, overrun;
@@ -746,13 +748,13 @@ static void pxa_camera_dma_irq(int channel, struct pxa_camera_dev *pcdev,
 		overrun |= CISR_IFO_1 | CISR_IFO_2;
 
 	if (status & DCSR_BUSERR) {
-		dev_err(pcdev->soc_host.dev, "DMA Bus Error IRQ!\n");
+		dev_err(dev, "DMA Bus Error IRQ!\n");
 		goto out;
 	}
 
 	if (!(status & (DCSR_ENDINTR | DCSR_STARTINTR))) {
-		dev_err(pcdev->soc_host.dev, "Unknown DMA IRQ source, "
-			"status: 0x%08x\n", status);
+		dev_err(dev, "Unknown DMA IRQ source, status: 0x%08x\n",
+			status);
 		goto out;
 	}
 
@@ -775,7 +777,7 @@ static void pxa_camera_dma_irq(int channel, struct pxa_camera_dev *pcdev,
 	buf = container_of(vb, struct pxa_buffer, vb);
 	WARN_ON(buf->inwork || list_empty(&vb->queue));
 
-	dev_dbg(pcdev->soc_host.dev, "%s channel=%d %s%s(vb=0x%p) dma.desc=%x\n",
+	dev_dbg(dev, "%s channel=%d %s%s(vb=0x%p) dma.desc=%x\n",
 		__func__, channel, status & DCSR_STARTINTR ? "SOF " : "",
 		status & DCSR_ENDINTR ? "EOF " : "", vb, DDADR(channel));
 
@@ -786,7 +788,7 @@ static void pxa_camera_dma_irq(int channel, struct pxa_camera_dev *pcdev,
 		 */
 		if (camera_status & overrun &&
 		    !list_is_last(pcdev->capture.next, &pcdev->capture)) {
-			dev_dbg(pcdev->soc_host.dev, "FIFO overrun! CISR: %x\n",
+			dev_dbg(dev, "FIFO overrun! CISR: %x\n",
 				camera_status);
 			pxa_camera_stop_capture(pcdev);
 			pxa_camera_start_capture(pcdev);
@@ -845,6 +847,7 @@ static u32 mclk_get_divisor(struct platform_device *pdev,
 			    struct pxa_camera_dev *pcdev)
 {
 	unsigned long mclk = pcdev->mclk;
+	struct device *dev = pcdev->soc_host.v4l2_dev.dev;
 	u32 div;
 	unsigned long lcdclk;
 
@@ -854,7 +857,7 @@ static u32 mclk_get_divisor(struct platform_device *pdev,
 	/* mclk <= ciclk / 4 (27.4.2) */
 	if (mclk > lcdclk / 4) {
 		mclk = lcdclk / 4;
-		dev_warn(&pdev->dev, "Limiting master clock to %lu\n", mclk);
+		dev_warn(dev, "Limiting master clock to %lu\n", mclk);
 	}
 
 	/* We verify mclk != 0, so if anyone breaks it, here comes their Oops */
@@ -864,7 +867,7 @@ static u32 mclk_get_divisor(struct platform_device *pdev,
 	if (pcdev->platform_flags & PXA_CAMERA_MCLK_EN)
 		pcdev->mclk = lcdclk / (2 * (div + 1));
 
-	dev_dbg(&pdev->dev, "LCD clock %luHz, target freq %luHz, divisor %u\n",
+	dev_dbg(dev, "LCD clock %luHz, target freq %luHz, divisor %u\n",
 		lcdclk, mclk, div);
 
 	return div;
@@ -882,14 +885,15 @@ static void recalculate_fifo_timeout(struct pxa_camera_dev *pcdev,
 static void pxa_camera_activate(struct pxa_camera_dev *pcdev)
 {
 	struct pxacamera_platform_data *pdata = pcdev->pdata;
+	struct device *dev = pcdev->soc_host.v4l2_dev.dev;
 	u32 cicr4 = 0;
 
-	dev_dbg(pcdev->soc_host.dev, "Registered platform device at %p data %p\n",
+	dev_dbg(dev, "Registered platform device at %p data %p\n",
 		pcdev, pdata);
 
 	if (pdata && pdata->init) {
-		dev_dbg(pcdev->soc_host.dev, "%s: Init gpios\n", __func__);
-		pdata->init(pcdev->soc_host.dev);
+		dev_dbg(dev, "%s: Init gpios\n", __func__);
+		pdata->init(dev);
 	}
 
 	/* disable all interrupts */
@@ -931,7 +935,7 @@ static irqreturn_t pxa_camera_irq(int irq, void *data)
 	struct videobuf_buffer *vb;
 
 	status = __raw_readl(pcdev->base + CISR);
-	dev_dbg(pcdev->soc_host.dev, "Camera interrupt status 0x%lx\n", status);
+	dev_dbg(pcdev->soc_host.v4l2_dev.dev, "Camera interrupt status 0x%lx\n", status);
 
 	if (!status)
 		return IRQ_NONE;
@@ -963,17 +967,11 @@ static int pxa_camera_add_device(struct soc_camera_device *icd)
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct pxa_camera_dev *pcdev = ici->priv;
-	int ret;
 
-	if (pcdev->icd) {
-		ret = -EBUSY;
-		goto ebusy;
-	}
+	if (pcdev->icd)
+		return -EBUSY;
 
 	pxa_camera_activate(pcdev);
-	ret = icd->ops->init(icd);
-	if (ret < 0)
-		goto einit;
 
 	pcdev->icd = icd;
 
@@ -981,11 +979,6 @@ static int pxa_camera_add_device(struct soc_camera_device *icd)
 		 icd->devnum);
 
 	return 0;
-
-einit:
-	pxa_camera_deactivate(pcdev);
-ebusy:
-	return ret;
 }
 
 /* Called with .video_lock held */
@@ -1007,8 +1000,6 @@ static void pxa_camera_remove_device(struct soc_camera_device *icd)
 	DCSR(pcdev->dma_chans[1]) = 0;
 	DCSR(pcdev->dma_chans[2]) = 0;
 
-	icd->ops->release(icd);
-
 	pxa_camera_deactivate(pcdev);
 
 	pcdev->icd = NULL;
@@ -1264,7 +1255,7 @@ static int pxa_camera_get_formats(struct soc_camera_device *icd, int idx,
 			xlate->cam_fmt = icd->formats + idx;
 			xlate->buswidth = buswidth;
 			xlate++;
-			dev_dbg(ici->dev, "Providing format %s using %s\n",
+			dev_dbg(ici->v4l2_dev.dev, "Providing format %s using %s\n",
 				pxa_camera_formats[0].name,
 				icd->formats[idx].name);
 		}
@@ -1279,7 +1270,7 @@ static int pxa_camera_get_formats(struct soc_camera_device *icd, int idx,
 			xlate->cam_fmt = icd->formats + idx;
 			xlate->buswidth = buswidth;
 			xlate++;
-			dev_dbg(ici->dev, "Providing format %s packed\n",
+			dev_dbg(ici->v4l2_dev.dev, "Providing format %s packed\n",
 				icd->formats[idx].name);
 		}
 		break;
@@ -1291,7 +1282,7 @@ static int pxa_camera_get_formats(struct soc_camera_device *icd, int idx,
 			xlate->cam_fmt = icd->formats + idx;
 			xlate->buswidth = icd->formats[idx].depth;
 			xlate++;
-			dev_dbg(ici->dev,
+			dev_dbg(ici->v4l2_dev.dev,
 				"Providing format %s in pass-through mode\n",
 				icd->formats[idx].name);
 		}
@@ -1320,11 +1311,11 @@ static int pxa_camera_set_crop(struct soc_camera_device *icd,
 	icd->sense = NULL;
 
 	if (ret < 0) {
-		dev_warn(ici->dev, "Failed to crop to %ux%u@%u:%u\n",
+		dev_warn(ici->v4l2_dev.dev, "Failed to crop to %ux%u@%u:%u\n",
 			 rect->width, rect->height, rect->left, rect->top);
 	} else if (sense.flags & SOCAM_SENSE_PCLK_CHANGED) {
 		if (sense.pixel_clock > sense.pixel_clock_max) {
-			dev_err(ici->dev,
+			dev_err(ici->v4l2_dev.dev,
 				"pixel clock %lu set by the camera too high!",
 				sense.pixel_clock);
 			return -EIO;
@@ -1352,7 +1343,7 @@ static int pxa_camera_set_fmt(struct soc_camera_device *icd,
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
 	if (!xlate) {
-		dev_warn(ici->dev, "Format %x not found\n", pix->pixelformat);
+		dev_warn(ici->v4l2_dev.dev, "Format %x not found\n", pix->pixelformat);
 		return -EINVAL;
 	}
 
@@ -1363,16 +1354,16 @@ static int pxa_camera_set_fmt(struct soc_camera_device *icd,
 		icd->sense = &sense;
 
 	cam_f.fmt.pix.pixelformat = cam_fmt->fourcc;
-	ret = icd->ops->set_fmt(icd, &cam_f);
+	ret = v4l2_device_call_until_err(&ici->v4l2_dev, 0, video, s_fmt, f);
 
 	icd->sense = NULL;
 
 	if (ret < 0) {
-		dev_warn(ici->dev, "Failed to configure for format %x\n",
+		dev_warn(ici->v4l2_dev.dev, "Failed to configure for format %x\n",
 			 pix->pixelformat);
 	} else if (sense.flags & SOCAM_SENSE_PCLK_CHANGED) {
 		if (sense.pixel_clock > sense.pixel_clock_max) {
-			dev_err(ici->dev,
+			dev_err(ici->v4l2_dev.dev,
 				"pixel clock %lu set by the camera too high!",
 				sense.pixel_clock);
 			return -EIO;
@@ -1400,7 +1391,7 @@ static int pxa_camera_try_fmt(struct soc_camera_device *icd,
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
 	if (!xlate) {
-		dev_warn(ici->dev, "Format %x not found\n", pixfmt);
+		dev_warn(ici->v4l2_dev.dev, "Format %x not found\n", pixfmt);
 		return -EINVAL;
 	}
 
@@ -1434,7 +1425,7 @@ static int pxa_camera_try_fmt(struct soc_camera_device *icd,
 	/* camera has to see its format, but the user the original one */
 	pix->pixelformat = xlate->cam_fmt->fourcc;
 	/* limit to sensor capabilities */
-	ret = icd->ops->try_fmt(icd, f);
+	ret = v4l2_device_call_until_err(&ici->v4l2_dev, 0, video, try_fmt, f);
 	pix->pixelformat = xlate->host_fmt->fourcc;
 
 	field = pix->field;
@@ -1670,7 +1661,7 @@ static int pxa_camera_probe(struct platform_device *pdev)
 	pcdev->soc_host.drv_name	= PXA_CAM_DRV_NAME;
 	pcdev->soc_host.ops		= &pxa_soc_camera_host_ops;
 	pcdev->soc_host.priv		= pcdev;
-	pcdev->soc_host.dev		= &pdev->dev;
+	pcdev->soc_host.v4l2_dev.dev	= &pdev->dev;
 	pcdev->soc_host.nr		= pdev->id;
 
 	err = soc_camera_host_register(&pcdev->soc_host);
diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index ac9b467..7ac4d92 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -351,10 +351,9 @@ static int sh_mobile_ceu_add_device(struct soc_camera_device *icd)
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
-	int ret = -EBUSY;
 
 	if (pcdev->icd)
-		goto err;
+		return -EBUSY;
 
 	dev_info(&icd->dev,
 		 "SuperH Mobile CEU driver attached to camera %d\n",
@@ -362,19 +361,13 @@ static int sh_mobile_ceu_add_device(struct soc_camera_device *icd)
 
 	clk_enable(pcdev->clk);
 
-	ret = icd->ops->init(icd);
-	if (ret) {
-		clk_disable(pcdev->clk);
-		goto err;
-	}
-
 	ceu_write(pcdev, CAPSR, 1 << 16); /* reset */
 	while (ceu_read(pcdev, CSTSR) & 1)
 		msleep(1);
 
 	pcdev->icd = icd;
-err:
-	return ret;
+
+	return 0;
 }
 
 /* Called with .video_lock held */
@@ -400,8 +393,6 @@ static void sh_mobile_ceu_remove_device(struct soc_camera_device *icd)
 	}
 	spin_unlock_irqrestore(&pcdev->lock, flags);
 
-	icd->ops->release(icd);
-
 	clk_disable(pcdev->clk);
 
 	dev_info(&icd->dev,
@@ -618,7 +609,7 @@ static int sh_mobile_ceu_get_formats(struct soc_camera_device *icd, int idx,
 			xlate->cam_fmt = icd->formats + idx;
 			xlate->buswidth = icd->formats[idx].depth;
 			xlate++;
-			dev_dbg(ici->dev, "Providing format %s using %s\n",
+			dev_dbg(ici->v4l2_dev.dev, "Providing format %s using %s\n",
 				sh_mobile_ceu_formats[k].name,
 				icd->formats[idx].name);
 		}
@@ -631,7 +622,7 @@ add_single_format:
 			xlate->cam_fmt = icd->formats + idx;
 			xlate->buswidth = icd->formats[idx].depth;
 			xlate++;
-			dev_dbg(ici->dev,
+			dev_dbg(ici->v4l2_dev.dev,
 				"Providing format %s in pass-through mode\n",
 				icd->formats[idx].name);
 		}
@@ -653,18 +644,17 @@ static int sh_mobile_ceu_set_fmt(struct soc_camera_device *icd,
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
 	__u32 pixfmt = f->fmt.pix.pixelformat;
 	const struct soc_camera_format_xlate *xlate;
-	struct v4l2_format cam_f = *f;
 	int ret;
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
 	if (!xlate) {
-		dev_warn(ici->dev, "Format %x not found\n", pixfmt);
+		dev_warn(ici->v4l2_dev.dev, "Format %x not found\n", pixfmt);
 		return -EINVAL;
 	}
 
-	cam_f.fmt.pix.pixelformat = xlate->cam_fmt->fourcc;
-	ret = icd->ops->set_fmt(icd, &cam_f);
-
+	f->fmt.pix.pixelformat = xlate->cam_fmt->fourcc;
+	ret = v4l2_device_call_until_err(&ici->v4l2_dev, (__u32)icd, video, s_fmt, f);
+	f->fmt.pix.pixelformat = pixfmt;
 	if (!ret) {
 		icd->buswidth = xlate->buswidth;
 		icd->current_fmt = xlate->host_fmt;
@@ -685,7 +675,7 @@ static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
 	if (!xlate) {
-		dev_warn(ici->dev, "Format %x not found\n", pixfmt);
+		dev_warn(ici->v4l2_dev.dev, "Format %x not found\n", pixfmt);
 		return -EINVAL;
 	}
 
@@ -706,8 +696,11 @@ static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
 		DIV_ROUND_UP(xlate->host_fmt->depth, 8);
 	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
 
+	f->fmt.pix.pixelformat = xlate->cam_fmt->fourcc;
+
 	/* limit to sensor capabilities */
-	ret = icd->ops->try_fmt(icd, f);
+	ret = v4l2_device_call_until_err(&ici->v4l2_dev, (__u32)icd, video, try_fmt, f);
+	f->fmt.pix.pixelformat = pixfmt;
 	if (ret < 0)
 		return ret;
 
@@ -783,7 +776,7 @@ static void sh_mobile_ceu_init_videobuf(struct videobuf_queue *q,
 
 	videobuf_queue_dma_contig_init(q,
 				       &sh_mobile_ceu_videobuf_ops,
-				       ici->dev, &pcdev->lock,
+				       ici->v4l2_dev.dev, &pcdev->lock,
 				       V4L2_BUF_TYPE_VIDEO_CAPTURE,
 				       pcdev->is_interlaced ?
 				       V4L2_FIELD_INTERLACED : V4L2_FIELD_NONE,
@@ -806,7 +799,7 @@ static struct soc_camera_host_ops sh_mobile_ceu_host_ops = {
 	.init_videobuf	= sh_mobile_ceu_init_videobuf,
 };
 
-static int sh_mobile_ceu_probe(struct platform_device *pdev)
+static int __devinit sh_mobile_ceu_probe(struct platform_device *pdev)
 {
 	struct sh_mobile_ceu_dev *pcdev;
 	struct resource *res;
@@ -884,7 +877,7 @@ static int sh_mobile_ceu_probe(struct platform_device *pdev)
 	}
 
 	pcdev->ici.priv = pcdev;
-	pcdev->ici.dev = &pdev->dev;
+	pcdev->ici.v4l2_dev.dev = &pdev->dev;
 	pcdev->ici.nr = pdev->id;
 	pcdev->ici.drv_name = dev_name(&pdev->dev);
 	pcdev->ici.ops = &sh_mobile_ceu_host_ops;
@@ -910,7 +903,7 @@ exit:
 	return err;
 }
 
-static int sh_mobile_ceu_remove(struct platform_device *pdev)
+static int __devexit sh_mobile_ceu_remove(struct platform_device *pdev)
 {
 	struct soc_camera_host *soc_host = to_soc_camera_host(&pdev->dev);
 	struct sh_mobile_ceu_dev *pcdev = container_of(soc_host,
@@ -931,7 +924,7 @@ static struct platform_driver sh_mobile_ceu_driver = {
 		.name	= "sh_mobile_ceu",
 	},
 	.probe		= sh_mobile_ceu_probe,
-	.remove		= sh_mobile_ceu_remove,
+	.remove		= __exit_p(sh_mobile_ceu_remove),
 };
 
 static int __init sh_mobile_ceu_init(void)
diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 00fdbc6..15480d9 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -170,8 +170,6 @@ static int soc_camera_reqbufs(struct file *file, void *priv,
 
 	WARN_ON(priv != file->private_data);
 
-	dev_dbg(&icd->dev, "%s: %d\n", __func__, p->memory);
-
 	ret = videobuf_reqbufs(&icf->vb_vidq, p);
 	if (ret < 0)
 		return ret;
@@ -285,7 +283,7 @@ static int soc_camera_set_fmt(struct soc_camera_file *icf,
 		return ret;
 	} else if (!icd->current_fmt ||
 		   icd->current_fmt->fourcc != pix->pixelformat) {
-		dev_err(ici->dev,
+		dev_err(ici->v4l2_dev.dev,
 			"Host driver hasn't set up current format correctly!\n");
 		return -EINVAL;
 	}
@@ -308,20 +306,13 @@ static int soc_camera_set_fmt(struct soc_camera_file *icf,
 
 static int soc_camera_open(struct file *file)
 {
-	struct video_device *vdev;
-	struct soc_camera_device *icd;
+	struct video_device *vdev = video_devdata(file);
+	struct soc_camera_device *icd = container_of(vdev->parent, struct soc_camera_device, dev);
+	struct soc_camera_link *icl = to_soc_camera_link(icd);
 	struct soc_camera_host *ici;
 	struct soc_camera_file *icf;
 	int ret;
 
-	/*
-	 * It is safe to dereference these pointers now as long as a user has
-	 * the video device open - we are protected by the held cdev reference.
-	 */
-
-	vdev = video_devdata(file);
-	icd = container_of(vdev->parent, struct soc_camera_device, dev);
-
 	if (!icd->ops)
 		/* No device driver attached */
 		return -ENODEV;
@@ -332,12 +323,6 @@ static int soc_camera_open(struct file *file)
 	if (!icf)
 		return -ENOMEM;
 
-	if (!try_module_get(icd->ops->owner)) {
-		dev_err(&icd->dev, "Couldn't lock sensor driver.\n");
-		ret = -EINVAL;
-		goto emgd;
-	}
-
 	if (!try_module_get(ici->ops->owner)) {
 		dev_err(&icd->dev, "Couldn't lock capture bus driver.\n");
 		ret = -EINVAL;
@@ -366,47 +351,62 @@ static int soc_camera_open(struct file *file)
 		if (ret < 0)
 			goto eiufmt;
 
-		dev_dbg(&icd->dev, "Using fmt %x\n", icd->current_fmt->fourcc);
-
 		f.fmt.pix.pixelformat	= icd->current_fmt->fourcc;
 		f.fmt.pix.colorspace	= icd->current_fmt->colorspace;
 
+		if (icl->power) {
+			ret = icl->power(icd->pdev, 1);
+			if (ret < 0)
+				goto epower;
+		}
+
+		/* The camera could have been already on, try to reset */
+		if (icl->reset)
+			icl->reset(icd->pdev);
+
 		ret = ici->ops->add(icd);
 		if (ret < 0) {
 			dev_err(&icd->dev, "Couldn't activate the camera: %d\n", ret);
 			goto eiciadd;
 		}
 
+		ret = v4l2_device_call_until_err(&ici->v4l2_dev, (__u32)icd, core, init, 0);
+		if (ret < 0)
+			goto einit;
+
 		/* Try to configure with default parameters */
 		ret = soc_camera_set_fmt(icf, &f);
 		if (ret < 0)
 			goto esfmt;
 	}
 
-	mutex_unlock(&icd->video_lock);
-
 	file->private_data = icf;
 	dev_dbg(&icd->dev, "camera device open\n");
 
 	ici->ops->init_videobuf(&icf->vb_vidq, icd);
 
+	mutex_unlock(&icd->video_lock);
+
 	return 0;
 
 	/*
-	 * First three errors are entered with the .video_lock held
+	 * First five errors are entered with the .video_lock held
 	 * and use_count == 1
 	 */
 esfmt:
+	v4l2_device_call_until_err(&ici->v4l2_dev, (__u32)icd, core, s_standby, 0);
+einit:
 	ici->ops->remove(icd);
 eiciadd:
+	if (icl->power)
+		icl->power(icd->pdev, 0);
+epower:
 	soc_camera_free_user_formats(icd);
 eiufmt:
 	icd->use_count--;
 	mutex_unlock(&icd->video_lock);
 	module_put(ici->ops->owner);
 emgi:
-	module_put(icd->ops->owner);
-emgd:
 	vfree(icf);
 	return ret;
 }
@@ -421,13 +421,17 @@ static int soc_camera_close(struct file *file)
 	mutex_lock(&icd->video_lock);
 	icd->use_count--;
 	if (!icd->use_count) {
+		struct soc_camera_link *icl = to_soc_camera_link(icd);
+
+		v4l2_device_call_until_err(&ici->v4l2_dev, (__u32)icd, core, s_standby, 0);
 		ici->ops->remove(icd);
+		if (icl->power)
+			icl->power(icd->pdev, 0);
 		soc_camera_free_user_formats(icd);
 	}
 
 	mutex_unlock(&icd->video_lock);
 
-	module_put(icd->ops->owner);
 	module_put(ici->ops->owner);
 
 	vfree(icf);
@@ -575,18 +579,17 @@ static int soc_camera_streamon(struct file *file, void *priv,
 {
 	struct soc_camera_file *icf = file->private_data;
 	struct soc_camera_device *icd = icf->icd;
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	int ret;
 
 	WARN_ON(priv != file->private_data);
 
-	dev_dbg(&icd->dev, "%s\n", __func__);
-
 	if (i != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 
 	mutex_lock(&icd->video_lock);
 
-	icd->ops->start_capture(icd);
+	v4l2_device_call_until_err(&ici->v4l2_dev, (__u32)icd, video, s_stream, 1);
 
 	/* This calls buf_queue from host driver's videobuf_queue_ops */
 	ret = videobuf_streamon(&icf->vb_vidq);
@@ -601,11 +604,10 @@ static int soc_camera_streamoff(struct file *file, void *priv,
 {
 	struct soc_camera_file *icf = file->private_data;
 	struct soc_camera_device *icd = icf->icd;
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 
 	WARN_ON(priv != file->private_data);
 
-	dev_dbg(&icd->dev, "%s\n", __func__);
-
 	if (i != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 
@@ -615,7 +617,7 @@ static int soc_camera_streamoff(struct file *file, void *priv,
 	 * remaining buffers. When the last buffer is freed, stop capture */
 	videobuf_streamoff(&icf->vb_vidq);
 
-	icd->ops->stop_capture(icd);
+	v4l2_device_call_until_err(&ici->v4l2_dev, (__u32)icd, video, s_stream, 0);
 
 	mutex_unlock(&icd->video_lock);
 
@@ -649,6 +651,7 @@ static int soc_camera_g_ctrl(struct file *file, void *priv,
 {
 	struct soc_camera_file *icf = file->private_data;
 	struct soc_camera_device *icd = icf->icd;
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 
 	WARN_ON(priv != file->private_data);
 
@@ -665,9 +668,7 @@ static int soc_camera_g_ctrl(struct file *file, void *priv,
 		return 0;
 	}
 
-	if (icd->ops->get_control)
-		return icd->ops->get_control(icd, ctrl);
-	return -EINVAL;
+	return v4l2_device_call_until_err(&ici->v4l2_dev, (__u32)icd, core, g_ctrl, ctrl);
 }
 
 static int soc_camera_s_ctrl(struct file *file, void *priv,
@@ -675,12 +676,11 @@ static int soc_camera_s_ctrl(struct file *file, void *priv,
 {
 	struct soc_camera_file *icf = file->private_data;
 	struct soc_camera_device *icd = icf->icd;
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 
 	WARN_ON(priv != file->private_data);
 
-	if (icd->ops->set_control)
-		return icd->ops->set_control(icd, ctrl);
-	return -EINVAL;
+	return v4l2_device_call_until_err(&ici->v4l2_dev, (__u32)icd, core, s_ctrl, ctrl);
 }
 
 static int soc_camera_cropcap(struct file *file, void *fh,
@@ -751,11 +751,9 @@ static int soc_camera_g_chip_ident(struct file *file, void *fh,
 {
 	struct soc_camera_file *icf = file->private_data;
 	struct soc_camera_device *icd = icf->icd;
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 
-	if (!icd->ops->get_chip_id)
-		return -EINVAL;
-
-	return icd->ops->get_chip_id(icd, id);
+	return v4l2_device_call_until_err(&ici->v4l2_dev, (__u32)icd, core, g_chip_ident, id);
 }
 
 #ifdef CONFIG_VIDEO_ADV_DEBUG
@@ -764,11 +762,9 @@ static int soc_camera_g_register(struct file *file, void *fh,
 {
 	struct soc_camera_file *icf = file->private_data;
 	struct soc_camera_device *icd = icf->icd;
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 
-	if (!icd->ops->get_register)
-		return -EINVAL;
-
-	return icd->ops->get_register(icd, reg);
+	return v4l2_device_call_until_err(&ici->v4l2_dev, (__u32)icd, core, g_register, reg);
 }
 
 static int soc_camera_s_register(struct file *file, void *fh,
@@ -776,11 +772,9 @@ static int soc_camera_s_register(struct file *file, void *fh,
 {
 	struct soc_camera_file *icf = file->private_data;
 	struct soc_camera_device *icd = icf->icd;
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 
-	if (!icd->ops->set_register)
-		return -EINVAL;
-
-	return icd->ops->set_register(icd, reg);
+	return v4l2_device_call_until_err(&ici->v4l2_dev, (__u32)icd, core, s_register, reg);
 }
 #endif
 
@@ -794,7 +788,7 @@ static void scan_add_host(struct soc_camera_host *ici)
 	list_for_each_entry(icd, &devices, list) {
 		if (icd->iface == ici->nr) {
 			int ret;
-			icd->dev.parent = ici->dev;
+			icd->dev.parent = ici->v4l2_dev.dev;
 			dev_set_name(&icd->dev, "%u-%u", icd->iface,
 				     icd->devnum);
 			ret = device_register(&icd->dev);
@@ -814,7 +808,9 @@ static int soc_camera_init_i2c(struct soc_camera_device *icd,
 			       struct soc_camera_link *icl)
 {
 	struct i2c_client *client;
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct i2c_adapter *adap = i2c_get_adapter(icl->i2c_adapter_id);
+	struct v4l2_subdev *subdev;
 	int ret;
 
 	if (!adap) {
@@ -826,17 +822,16 @@ static int soc_camera_init_i2c(struct soc_camera_device *icd,
 
 	icl->board_info->platform_data = icd;
 
-	client = i2c_new_device(adap, icl->board_info);
-	if (!client) {
+	subdev = v4l2_i2c_subdev_board(&ici->v4l2_dev, adap,
+				       icl->module_name, icl->board_info);
+	if (!subdev) {
 		ret = -ENOMEM;
 		goto ei2cnd;
 	}
 
-	/*
-	 * We set icd drvdata at two locations - here and in
-	 * soc_camera_video_start(). Depending on the module loading /
-	 * initialisation order one of these locations will be entered first
-	 */
+	subdev->grp_id = (__u32)icd;
+	client = subdev->priv;
+
 	/* Use to_i2c_client(dev) to recover the i2c client */
 	dev_set_drvdata(&icd->dev, &client->dev);
 
@@ -852,6 +847,7 @@ static void soc_camera_free_i2c(struct soc_camera_device *icd)
 	struct i2c_client *client =
 		to_i2c_client(to_soc_camera_control(icd));
 	dev_set_drvdata(&icd->dev, NULL);
+	v4l2_device_unregister_subdev(i2c_get_clientdata(client));
 	i2c_unregister_device(client);
 	i2c_put_adapter(client->adapter);
 }
@@ -860,16 +856,41 @@ static void soc_camera_free_i2c(struct soc_camera_device *icd)
 #define soc_camera_free_i2c(icd)	do {} while (0)
 #endif
 
+static int soc_camera_video_start(struct soc_camera_device *icd);
 static int video_dev_create(struct soc_camera_device *icd);
 /* Called during host-driver probe */
 static int soc_camera_probe(struct device *dev)
 {
 	struct soc_camera_device *icd = to_soc_camera_dev(dev);
+	struct soc_camera_host *ici = to_soc_camera_host(dev->parent);
 	struct soc_camera_link *icl = to_soc_camera_link(icd);
+	struct device *control = NULL;
 	int ret;
 
 	dev_info(dev, "Probing %s\n", dev_name(dev));
 
+	if (icl->power) {
+		ret = icl->power(icd->pdev, 1);
+		if (ret < 0) {
+			dev_err(dev,
+				"Platform failed to power-on the camera.\n");
+			goto epower;
+		}
+	}
+
+	/* The camera could have been already on, try to reset */
+	if (icl->reset)
+		icl->reset(icd->pdev);
+
+	ret = ici->ops->add(icd);
+	if (ret < 0)
+		goto eadd;
+
+	/* Must have icd->vdev before registering the device */
+	ret = video_dev_create(icd);
+	if (ret < 0)
+		goto evdc;
+
 	/* Non-i2c cameras, e.g., soc_camera_platform, have no board_info */
 	if (icl->board_info) {
 		ret = soc_camera_init_i2c(icd, icl);
@@ -879,20 +900,28 @@ static int soc_camera_probe(struct device *dev)
 		ret = -EINVAL;
 		goto eadddev;
 	} else {
+		if (icl->module_name)
+			ret = request_module(icl->module_name);
+
 		ret = icl->add_device(icl, &icd->dev);
 		if (ret < 0)
 			goto eadddev;
+
+		/* FIXME: this is racy, have to use driver-binding notification */
+		control = to_soc_camera_control(icd);
+		if (!control || !control->driver ||
+		    !try_module_get(control->driver->owner)) {
+			icl->del_device(icl);
+			goto enodrv;
+		}
 	}
 
-	ret = video_dev_create(icd);
-	if (ret < 0)
-		goto evdc;
+	/* ..._video_start() will create a device node, so we have to protect */
+	mutex_lock(&icd->video_lock);
 
-	ret = video_register_device(icd->vdev, VFL_TYPE_GRABBER, icd->vdev->minor);
-	if (ret < 0) {
-		dev_err(&icd->dev, "video_register_device failed: %d\n", ret);
-		goto evidregd;
-	}
+	ret = soc_camera_video_start(icd);
+	if (ret < 0)
+		goto evidstart;
 
 	/* Do we have to sysfs_remove_link() before device_unregister()? */
 	if (to_soc_camera_control(icd) &&
@@ -900,17 +929,32 @@ static int soc_camera_probe(struct device *dev)
 			      "control"))
 		dev_warn(&icd->dev, "Failed creating the control symlink\n");
 
+	ici->ops->remove(icd);
+
+	if (icl->power)
+		icl->power(icd->pdev, 0);
+
+	mutex_unlock(&icd->video_lock);
 
 	return 0;
 
-evidregd:
-	video_device_release(icd->vdev);
-evdc:
-	if (icl->board_info)
+evidstart:
+	mutex_unlock(&icd->video_lock);
+	if (icl->board_info) {
 		soc_camera_free_i2c(icd);
-	else
+	} else {
 		icl->del_device(icl);
+		module_put(control->driver->owner);
+	}
+enodrv:
 eadddev:
+	video_device_release(icd->vdev);
+evdc:
+	ici->ops->remove(icd);
+eadd:
+	if (icl->power)
+		icl->power(icd->pdev, 0);
+epower:
 	return ret;
 }
 
@@ -931,10 +975,16 @@ static int soc_camera_remove(struct device *dev)
 		mutex_unlock(&icd->video_lock);
 	}
 
-	if (icl->board_info)
+	if (icl->board_info) {
 		soc_camera_free_i2c(icd);
-	else
-		icl->del_device(icl);
+	} else {
+		struct device_driver *drv = to_soc_camera_control(icd) ?
+			to_soc_camera_control(icd)->driver : NULL;
+		if (drv) {
+			icl->del_device(icl);
+			module_put(drv->owner);
+		}
+	}
 
 	return 0;
 }
@@ -984,6 +1034,7 @@ static void dummy_release(struct device *dev)
 int soc_camera_host_register(struct soc_camera_host *ici)
 {
 	struct soc_camera_host *ix;
+	int ret;
 
 	if (!ici || !ici->ops ||
 	    !ici->ops->try_fmt ||
@@ -996,18 +1047,20 @@ int soc_camera_host_register(struct soc_camera_host *ici)
 	    !ici->ops->add ||
 	    !ici->ops->remove ||
 	    !ici->ops->poll ||
-	    !ici->dev)
+	    !ici->v4l2_dev.dev)
 		return -EINVAL;
 
 	mutex_lock(&list_lock);
 	list_for_each_entry(ix, &hosts, list) {
 		if (ix->nr == ici->nr) {
-			mutex_unlock(&list_lock);
-			return -EBUSY;
+			ret = -EBUSY;
+			goto edevreg;
 		}
 	}
 
-	dev_set_drvdata(ici->dev, ici);
+	ret = v4l2_device_register(ici->v4l2_dev.dev, &ici->v4l2_dev);
+	if (ret < 0)
+		goto edevreg;
 
 	list_add_tail(&ici->list, &hosts);
 	mutex_unlock(&list_lock);
@@ -1015,6 +1068,10 @@ int soc_camera_host_register(struct soc_camera_host *ici)
 	scan_add_host(ici);
 
 	return 0;
+
+edevreg:
+	mutex_unlock(&list_lock);
+	return ret;
 }
 EXPORT_SYMBOL(soc_camera_host_register);
 
@@ -1028,7 +1085,7 @@ void soc_camera_host_unregister(struct soc_camera_host *ici)
 	list_del(&ici->list);
 
 	list_for_each_entry(icd, &devices, list) {
-		if (icd->dev.parent == ici->dev) {
+		if (icd->iface == ici->nr) {
 			/* The bus->remove will be called */
 			device_unregister(&icd->dev);
 			/* Not before device_unregister(), .remove
@@ -1043,7 +1100,7 @@ void soc_camera_host_unregister(struct soc_camera_host *ici)
 
 	mutex_unlock(&list_lock);
 
-	dev_set_drvdata(ici->dev, NULL);
+	v4l2_device_unregister(&ici->v4l2_dev);
 }
 EXPORT_SYMBOL(soc_camera_host_unregister);
 
@@ -1123,7 +1180,6 @@ static int video_dev_create(struct soc_camera_device *icd)
 
 	if (!vdev)
 		return -ENOMEM;
-	dev_dbg(ici->dev, "Allocated video_device %p\n", vdev);
 
 	strlcpy(vdev->name, ici->drv_name, sizeof(vdev->name));
 
@@ -1141,49 +1197,35 @@ static int video_dev_create(struct soc_camera_device *icd)
 }
 
 /*
- * Usually called from the struct soc_camera_ops .probe() method, i.e., from
- * soc_camera_probe() above with .video_lock held
+ * Called from soc_camera_probe() above (with .video_lock held???)
  */
-int soc_camera_video_start(struct soc_camera_device *icd, struct device *dev)
+static int soc_camera_video_start(struct soc_camera_device *icd)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	const struct v4l2_queryctrl *qctrl;
+	int ret;
 
 	if (!icd->dev.parent)
 		return -ENODEV;
 
 	if (!icd->ops ||
-	    !icd->ops->init ||
-	    !icd->ops->release ||
-	    !icd->ops->start_capture ||
-	    !icd->ops->stop_capture ||
-	    !icd->ops->set_fmt ||
-	    !icd->ops->try_fmt ||
 	    !icd->ops->query_bus_param ||
 	    !icd->ops->set_bus_param)
 		return -EINVAL;
 
-	/* See comment in soc_camera_probe() */
-	dev_set_drvdata(&icd->dev, dev);
+	ret = video_register_device(icd->vdev, VFL_TYPE_GRABBER,
+				    icd->vdev->minor);
+	if (ret < 0) {
+		dev_err(&icd->dev, "video_register_device failed: %d\n", ret);
+		return ret;
+	}
 
 	qctrl = soc_camera_find_qctrl(icd->ops, V4L2_CID_GAIN);
 	icd->gain = qctrl ? qctrl->default_value : (unsigned short)~0;
 	qctrl = soc_camera_find_qctrl(icd->ops, V4L2_CID_EXPOSURE);
 	icd->exposure = qctrl ? qctrl->default_value : (unsigned short)~0;
 
-	return ici->ops->add(icd);
-}
-EXPORT_SYMBOL(soc_camera_video_start);
-
-void soc_camera_video_stop(struct soc_camera_device *icd)
-{
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
-
-	dev_dbg(&icd->dev, "%s\n", __func__);
-
-	ici->ops->remove(icd);
+	return 0;
 }
-EXPORT_SYMBOL(soc_camera_video_stop);
 
 static int __devinit soc_camera_pdrv_probe(struct platform_device *pdev)
 {
@@ -1199,6 +1241,7 @@ static int __devinit soc_camera_pdrv_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	icd->iface = icl->bus_id;
+	icd->pdev = &pdev->dev;
 	platform_set_drvdata(pdev, icd);
 	icd->dev.platform_data = icl;
 
diff --git a/drivers/media/video/soc_camera_platform.c b/drivers/media/video/soc_camera_platform.c
index 14c5cf9..870e85e 100644
--- a/drivers/media/video/soc_camera_platform.c
+++ b/drivers/media/video/soc_camera_platform.c
@@ -16,11 +16,12 @@
 #include <linux/delay.h>
 #include <linux/platform_device.h>
 #include <linux/videodev2.h>
-#include <media/v4l2-common.h>
+#include <media/v4l2-subdev.h>
 #include <media/soc_camera.h>
 #include <media/soc_camera_platform.h>
 
 struct soc_camera_platform_priv {
+	struct v4l2_subdev subdev;
 	struct soc_camera_platform_info *info;
 	struct soc_camera_device icd;
 	struct soc_camera_data_format format;
@@ -33,36 +34,10 @@ soc_camera_platform_get_info(struct soc_camera_device *icd)
 	return pdev->dev.platform_data;
 }
 
-static int soc_camera_platform_init(struct soc_camera_device *icd)
+static int soc_camera_platform_s_stream(struct v4l2_subdev *sd, int enable)
 {
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
-
-	if (icl->power)
-		icl->power(dev_get_drvdata(&icd->dev), 1);
-
-	return 0;
-}
-
-static int soc_camera_platform_release(struct soc_camera_device *icd)
-{
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
-
-	if (icl->power)
-		icl->power(dev_get_drvdata(&icd->dev), 0);
-
-	return 0;
-}
-
-static int soc_camera_platform_start_capture(struct soc_camera_device *icd)
-{
-	struct soc_camera_platform_info *p = soc_camera_platform_get_info(icd);
-	return p->set_capture(p, 1);
-}
-
-static int soc_camera_platform_stop_capture(struct soc_camera_device *icd)
-{
-	struct soc_camera_platform_info *p = soc_camera_platform_get_info(icd);
-	return p->set_capture(p, 0);
+	struct soc_camera_platform_info *p = v4l2_get_subdevdata(sd);
+	return p->set_capture(p, enable);
 }
 
 static int soc_camera_platform_set_bus_param(struct soc_camera_device *icd,
@@ -84,16 +59,10 @@ static int soc_camera_platform_set_crop(struct soc_camera_device *icd,
 	return 0;
 }
 
-static int soc_camera_platform_set_fmt(struct soc_camera_device *icd,
+static int soc_camera_platform_try_fmt(struct v4l2_subdev *sd,
 				       struct v4l2_format *f)
 {
-	return 0;
-}
-
-static int soc_camera_platform_try_fmt(struct soc_camera_device *icd,
-				       struct v4l2_format *f)
-{
-	struct soc_camera_platform_info *p = soc_camera_platform_get_info(icd);
+	struct soc_camera_platform_info *p = v4l2_get_subdevdata(sd);
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 
 	pix->width = p->format.width;
@@ -101,8 +70,9 @@ static int soc_camera_platform_try_fmt(struct soc_camera_device *icd,
 	return 0;
 }
 
-static int soc_camera_platform_video_probe(struct soc_camera_device *icd,
-					   struct platform_device *pdev)
+#warning video_start / stop in platform patch
+static void soc_camera_platform_video_probe(struct soc_camera_device *icd,
+					    struct platform_device *pdev)
 {
 	struct soc_camera_platform_priv *priv = platform_get_drvdata(pdev);
 
@@ -113,31 +83,29 @@ static int soc_camera_platform_video_probe(struct soc_camera_device *icd,
 
 	icd->formats = &priv->format;
 	icd->num_formats = 1;
-
-	/* ..._video_start() does dev_set_drvdata(&icd->dev, &pdev->dev) */
-	return soc_camera_video_start(icd, &pdev->dev);
 }
 
-static void soc_camera_platform_video_remove(struct soc_camera_device *icd)
-{
-	soc_camera_video_stop(icd);
-}
+static struct v4l2_subdev_core_ops platform_subdev_core_ops;
+
+static struct v4l2_subdev_video_ops platform_subdev_video_ops = {
+	.s_stream	= soc_camera_platform_s_stream,
+	.try_fmt	= soc_camera_platform_try_fmt,
+};
+
+static struct v4l2_subdev_ops platform_subdev_ops = {
+	.core	= &platform_subdev_core_ops,
+	.video	= &platform_subdev_video_ops,
+};
 
 static struct soc_camera_ops soc_camera_platform_ops = {
-	.owner			= THIS_MODULE,
-	.init			= soc_camera_platform_init,
-	.release		= soc_camera_platform_release,
-	.start_capture		= soc_camera_platform_start_capture,
-	.stop_capture		= soc_camera_platform_stop_capture,
 	.set_crop		= soc_camera_platform_set_crop,
-	.set_fmt		= soc_camera_platform_set_fmt,
-	.try_fmt		= soc_camera_platform_try_fmt,
 	.set_bus_param		= soc_camera_platform_set_bus_param,
 	.query_bus_param	= soc_camera_platform_query_bus_param,
 };
 
 static int soc_camera_platform_probe(struct platform_device *pdev)
 {
+	struct soc_camera_host *ici;
 	struct soc_camera_platform_priv *priv;
 	struct soc_camera_platform_info *p;
 	struct soc_camera_device *icd;
@@ -147,41 +115,60 @@ static int soc_camera_platform_probe(struct platform_device *pdev)
 	if (!p)
 		return -EINVAL;
 
+	if (!p->dev) {
+		dev_err(&pdev->dev,
+			"Platform has not set soc_camera_device pointer!\n");
+		return -EINVAL;
+	}
+
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
 	priv->info = p;
-	platform_set_drvdata(pdev, priv);
 
-	icd = p->icd;
-	if (!icd)
-		goto enoicd;
+	icd = to_soc_camera_dev(p->dev);
 
-	icd->ops	= &soc_camera_platform_ops;
+	platform_set_drvdata(pdev, priv);
 	dev_set_drvdata(&icd->dev, &pdev->dev);
+
 	icd->width_min	= 0;
 	icd->width_max	= p->format.width;
 	icd->height_min	= 0;
 	icd->height_max	= p->format.height;
 	icd->y_skip_top	= 0;
+	icd->ops	= &soc_camera_platform_ops;
+
+	ici = to_soc_camera_host(icd->dev.parent);
+
+	soc_camera_platform_video_probe(icd, pdev);
 
-	ret = soc_camera_platform_video_probe(icd, pdev);
+	v4l2_subdev_init(&priv->subdev, &platform_subdev_ops);
+	v4l2_set_subdevdata(&priv->subdev, p);
+	priv->subdev.grp_id = (__u32)icd;
+	strncpy(priv->subdev.name, dev_name(&pdev->dev), V4L2_SUBDEV_NAME_SIZE);
+
+	ret = v4l2_device_register_subdev(&ici->v4l2_dev, &priv->subdev);
 	if (ret)
-		kfree(priv);
+		goto evdrs;
 
 	return ret;
 
-enoicd:
+evdrs:
+	icd->ops = NULL;
+	platform_set_drvdata(pdev, NULL);
 	kfree(priv);
-	return -EINVAL;
+	return ret;
 }
 
 static int soc_camera_platform_remove(struct platform_device *pdev)
 {
 	struct soc_camera_platform_priv *priv = platform_get_drvdata(pdev);
+	struct soc_camera_device *icd = to_soc_camera_dev(priv->info->dev);
 
-	soc_camera_platform_video_remove(&priv->icd);
+	v4l2_device_unregister_subdev(&priv->subdev);
+	icd->ops = NULL;
+	platform_set_drvdata(pdev, NULL);
 	kfree(priv);
 	return 0;
 }
@@ -189,6 +176,7 @@ static int soc_camera_platform_remove(struct platform_device *pdev)
 static struct platform_driver soc_camera_platform_driver = {
 	.driver 	= {
 		.name	= "soc_camera_platform",
+		.owner	= THIS_MODULE,
 	},
 	.probe		= soc_camera_platform_probe,
 	.remove		= soc_camera_platform_remove,
diff --git a/drivers/media/video/tw9910.c b/drivers/media/video/tw9910.c
index 419e596..961b2eb 100644
--- a/drivers/media/video/tw9910.c
+++ b/drivers/media/video/tw9910.c
@@ -24,7 +24,7 @@
 #include <linux/delay.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-chip-ident.h>
-#include <media/v4l2-common.h>
+#include <media/v4l2-subdev.h>
 #include <media/soc_camera.h>
 #include <media/tw9910.h>
 
@@ -223,6 +223,7 @@ struct tw9910_hsync_ctrl {
 };
 
 struct tw9910_priv {
+	struct v4l2_subdev                subdev;
 	struct tw9910_video_info       *info;
 	const struct tw9910_scale_ctrl *scale;
 };
@@ -354,6 +355,11 @@ static const struct tw9910_hsync_ctrl tw9910_hsync_ctrl = {
 /*
  * general function
  */
+static struct tw9910_priv *to_tw9910(const struct i2c_client *client)
+{
+	return container_of(i2c_get_clientdata(client), struct tw9910_priv, subdev);
+}
+
 static int tw9910_set_scale(struct i2c_client *client,
 			    const struct tw9910_scale_ctrl *scale)
 {
@@ -507,47 +513,20 @@ tw9910_select_norm(struct soc_camera_device *icd, u32 width, u32 height)
 /*
  * soc_camera_ops function
  */
-static int tw9910_init(struct soc_camera_device *icd)
+static int tw9910_s_stream(struct v4l2_subdev *sd, int enable)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
-	int ret = 0;
+	struct i2c_client *client = sd->priv;
+	struct tw9910_priv *priv = to_tw9910(client);
 
-	if (icl->power) {
-		ret = icl->power(&client->dev, 1);
-		if (ret < 0)
-			return ret;
-	}
-
-	if (icl->reset)
-		ret = icl->reset(&client->dev);
-
-	return ret;
-}
-
-static int tw9910_release(struct soc_camera_device *icd)
-{
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
-	int ret = 0;
-
-	if (icl->power)
-		ret = icl->power(&client->dev, 0);
-
-	return ret;
-}
-
-static int tw9910_start_capture(struct soc_camera_device *icd)
-{
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct tw9910_priv *priv = i2c_get_clientdata(client);
+	if (!enable)
+		return 0;
 
 	if (!priv->scale) {
-		dev_err(&icd->dev, "norm select error\n");
+		dev_err(&client->dev, "norm select error\n");
 		return -EPERM;
 	}
 
-	dev_dbg(&icd->dev, "%s %dx%d\n",
+	dev_dbg(&client->dev, "%s %dx%d\n",
 		 priv->scale->name,
 		 priv->scale->width,
 		 priv->scale->height);
@@ -555,11 +534,6 @@ static int tw9910_start_capture(struct soc_camera_device *icd)
 	return 0;
 }
 
-static int tw9910_stop_capture(struct soc_camera_device *icd)
-{
-	return 0;
-}
-
 static int tw9910_set_bus_param(struct soc_camera_device *icd,
 				unsigned long flags)
 {
@@ -569,7 +543,7 @@ static int tw9910_set_bus_param(struct soc_camera_device *icd,
 static unsigned long tw9910_query_bus_param(struct soc_camera_device *icd)
 {
 	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct tw9910_priv *priv = i2c_get_clientdata(client);
+	struct tw9910_priv *priv = to_tw9910(client);
 	struct soc_camera_link *icl = to_soc_camera_link(icd);
 	unsigned long flags = SOCAM_PCLK_SAMPLE_RISING | SOCAM_MASTER |
 		SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_HSYNC_ACTIVE_HIGH |
@@ -578,21 +552,11 @@ static unsigned long tw9910_query_bus_param(struct soc_camera_device *icd)
 	return soc_camera_apply_sensor_flags(icl, flags);
 }
 
-static int tw9910_get_chip_id(struct soc_camera_device *icd,
-			      struct v4l2_dbg_chip_ident *id)
-{
-	id->ident = V4L2_IDENT_TW9910;
-	id->revision = 0;
-
-	return 0;
-}
-
-static int tw9910_set_std(struct soc_camera_device *icd,
-			  v4l2_std_id *a)
+static int tw9910_s_std(struct v4l2_subdev *sd, v4l2_std_id norm)
 {
 	int ret = -EINVAL;
 
-	if (*a & (V4L2_STD_NTSC | V4L2_STD_PAL))
+	if (norm & (V4L2_STD_NTSC | V4L2_STD_PAL))
 		ret = 0;
 
 	return ret;
@@ -608,11 +572,20 @@ static int tw9910_enum_input(struct soc_camera_device *icd,
 	return 0;
 }
 
+static int tw9910_g_chip_ident(struct v4l2_subdev *sd,
+			       struct v4l2_dbg_chip_ident *id)
+{
+	id->ident = V4L2_IDENT_TW9910;
+	id->revision = 0;
+
+	return 0;
+}
+
 #ifdef CONFIG_VIDEO_ADV_DEBUG
-static int tw9910_get_register(struct soc_camera_device *icd,
-			       struct v4l2_dbg_register *reg)
+static int tw9910_g_register(struct v4l2_subdev *sd,
+			     struct v4l2_dbg_register *reg)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct i2c_client *client = sd->priv;
 	int ret;
 
 	if (reg->reg > 0xff)
@@ -630,10 +603,10 @@ static int tw9910_get_register(struct soc_camera_device *icd,
 	return 0;
 }
 
-static int tw9910_set_register(struct soc_camera_device *icd,
-			       struct v4l2_dbg_register *reg)
+static int tw9910_s_register(struct v4l2_subdev *sd,
+			     struct v4l2_dbg_register *reg)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct i2c_client *client = sd->priv;
 
 	if (reg->reg > 0xff ||
 	    reg->val > 0xff)
@@ -647,7 +620,7 @@ static int tw9910_set_crop(struct soc_camera_device *icd,
 			   struct v4l2_rect *rect)
 {
 	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct tw9910_priv *priv = i2c_get_clientdata(client);
+	struct tw9910_priv *priv = to_tw9910(client);
 	int                 ret  = -EINVAL;
 	u8                  val;
 
@@ -736,9 +709,10 @@ tw9910_set_fmt_error:
 	return ret;
 }
 
-static int tw9910_set_fmt(struct soc_camera_device *icd,
-			  struct v4l2_format *f)
+static int tw9910_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
 {
+	struct i2c_client *client = sd->priv;
+	struct soc_camera_device *icd = client->dev.platform_data;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 	struct v4l2_rect rect = {
 		.left	= icd->x_current,
@@ -761,16 +735,17 @@ static int tw9910_set_fmt(struct soc_camera_device *icd,
 	return tw9910_set_crop(icd, &rect);
 }
 
-static int tw9910_try_fmt(struct soc_camera_device *icd,
-			  struct v4l2_format *f)
+static int tw9910_try_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
 {
+	struct i2c_client *client = sd->priv;
+	struct soc_camera_device *icd = client->dev.platform_data;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 	const struct tw9910_scale_ctrl *scale;
 
 	if (V4L2_FIELD_ANY == pix->field) {
 		pix->field = V4L2_FIELD_INTERLACED;
 	} else if (V4L2_FIELD_INTERLACED != pix->field) {
-		dev_err(&icd->dev, "Field type invalid.\n");
+		dev_err(&client->dev, "Field type invalid.\n");
 		return -EINVAL;
 	}
 
@@ -790,9 +765,8 @@ static int tw9910_try_fmt(struct soc_camera_device *icd,
 static int tw9910_video_probe(struct soc_camera_device *icd,
 			      struct i2c_client *client)
 {
-	struct tw9910_priv *priv = i2c_get_clientdata(client);
+	struct tw9910_priv *priv = to_tw9910(client);
 	s32 val;
-	int ret;
 
 	/*
 	 * We must have a parent by now. And it cannot be a wrong one.
@@ -814,18 +788,11 @@ static int tw9910_video_probe(struct soc_camera_device *icd,
 	icd->formats     = tw9910_color_fmt;
 	icd->num_formats = ARRAY_SIZE(tw9910_color_fmt);
 
-	/* Switch master clock on */
-	ret = soc_camera_video_start(icd, &client->dev);
-	if (ret)
-		return ret;
-
 	/*
 	 * check and show Product ID
 	 */
 	val = i2c_smbus_read_byte_data(client, ID);
 
-	soc_camera_video_stop(icd);
-
 	if (0x0B != GET_ID(val) ||
 	    0x00 != GET_ReV(val)) {
 		dev_err(&icd->dev,
@@ -839,7 +806,7 @@ static int tw9910_video_probe(struct soc_camera_device *icd,
 	icd->vdev->tvnorms      = V4L2_STD_NTSC | V4L2_STD_PAL;
 	icd->vdev->current_norm = V4L2_STD_NTSC;
 
-	return ret;
+	return 0;
 }
 
 static void tw9910_video_remove(struct soc_camera_device *icd)
@@ -848,25 +815,32 @@ static void tw9910_video_remove(struct soc_camera_device *icd)
 }
 
 static struct soc_camera_ops tw9910_ops = {
-	.owner			= THIS_MODULE,
-	.init			= tw9910_init,
-	.release		= tw9910_release,
-	.start_capture		= tw9910_start_capture,
-	.stop_capture		= tw9910_stop_capture,
 	.set_crop		= tw9910_set_crop,
-	.set_fmt		= tw9910_set_fmt,
-	.try_fmt		= tw9910_try_fmt,
 	.set_bus_param		= tw9910_set_bus_param,
 	.query_bus_param	= tw9910_query_bus_param,
-	.get_chip_id		= tw9910_get_chip_id,
-	.set_std		= tw9910_set_std,
 	.enum_input		= tw9910_enum_input,
+};
+
+static struct v4l2_subdev_core_ops tw9910_subdev_core_ops = {
+	.g_chip_ident	= tw9910_g_chip_ident,
+	.s_std		= tw9910_s_std,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
-	.get_register		= tw9910_get_register,
-	.set_register		= tw9910_set_register,
+	.g_register	= tw9910_g_register,
+	.s_register	= tw9910_s_register,
 #endif
 };
 
+static struct v4l2_subdev_video_ops tw9910_subdev_video_ops = {
+	.s_stream	= tw9910_s_stream,
+	.s_fmt		= tw9910_s_fmt,
+	.try_fmt	= tw9910_try_fmt,
+};
+
+static struct v4l2_subdev_ops tw9910_subdev_ops = {
+	.core	= &tw9910_subdev_core_ops,
+	.video	= &tw9910_subdev_video_ops,
+};
+
 /*
  * i2c_driver function
  */
@@ -907,7 +881,8 @@ static int tw9910_probe(struct i2c_client *client,
 		return -ENOMEM;
 
 	priv->info   = info;
-	i2c_set_clientdata(client, priv);
+
+	v4l2_i2c_subdev_init(&priv->subdev, client, &tw9910_subdev_ops);
 
 	icd->ops     = &tw9910_ops;
 	icd->iface   = info->link.bus_id;
@@ -946,7 +921,7 @@ static int tw9910_probe(struct i2c_client *client,
 
 static int tw9910_remove(struct i2c_client *client)
 {
-	struct tw9910_priv *priv = i2c_get_clientdata(client);
+	struct tw9910_priv *priv = to_tw9910(client);
 	struct soc_camera_device *icd = client->dev.platform_data;
 
 	tw9910_video_remove(icd);
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index d8b4256..e104802 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -16,10 +16,12 @@
 #include <linux/pm.h>
 #include <linux/videodev2.h>
 #include <media/videobuf-core.h>
+#include <media/v4l2-device.h>
 
 struct soc_camera_device {
 	struct list_head list;
 	struct device dev;
+	struct device *pdev;		/* Platform device */
 	unsigned short width;		/* Current window */
 	unsigned short height;		/* sizes */
 	unsigned short x_min;		/* Camera capabilities */
@@ -45,7 +47,6 @@ struct soc_camera_device {
 	struct soc_camera_format_xlate *user_formats;
 	int num_user_formats;
 	enum v4l2_field field;		/* Preserve field over close() */
-	struct module *owner;
 	void *host_priv;		/* Per-device host private data */
 	/* soc_camera.c private count. Only accessed with .video_lock held */
 	int use_count;
@@ -58,8 +59,8 @@ struct soc_camera_file {
 };
 
 struct soc_camera_host {
+	struct v4l2_device v4l2_dev;
 	struct list_head list;
-	struct device *dev;
 	unsigned char nr;				/* Host number */
 	void *priv;
 	const char *drv_name;
@@ -127,7 +128,9 @@ static inline struct soc_camera_device *to_soc_camera_dev(struct device *dev)
 
 static inline struct soc_camera_host *to_soc_camera_host(struct device *dev)
 {
-	return dev_get_drvdata(dev);
+	struct v4l2_device *v4l2_dev = dev_get_drvdata(dev);
+
+	return container_of(v4l2_dev, struct soc_camera_host, v4l2_dev);
 }
 
 static inline struct soc_camera_link *to_soc_camera_link(struct soc_camera_device *icd)
@@ -143,9 +146,6 @@ static inline struct device *to_soc_camera_control(struct soc_camera_device *icd
 int soc_camera_host_register(struct soc_camera_host *ici);
 void soc_camera_host_unregister(struct soc_camera_host *ici);
 
-int soc_camera_video_start(struct soc_camera_device *icd, struct device *dev);
-void soc_camera_video_stop(struct soc_camera_device *icd);
-
 const struct soc_camera_data_format *soc_camera_format_by_fourcc(
 	struct soc_camera_device *icd, unsigned int fourcc);
 const struct soc_camera_format_xlate *soc_camera_xlate_by_fourcc(
@@ -176,28 +176,15 @@ struct soc_camera_format_xlate {
 };
 
 struct soc_camera_ops {
-	struct module *owner;
 	int (*suspend)(struct soc_camera_device *, pm_message_t state);
 	int (*resume)(struct soc_camera_device *);
-	int (*init)(struct soc_camera_device *);
-	int (*release)(struct soc_camera_device *);
-	int (*start_capture)(struct soc_camera_device *);
-	int (*stop_capture)(struct soc_camera_device *);
 	int (*set_crop)(struct soc_camera_device *, struct v4l2_rect *);
-	int (*set_fmt)(struct soc_camera_device *, struct v4l2_format *);
-	int (*try_fmt)(struct soc_camera_device *, struct v4l2_format *);
 	unsigned long (*query_bus_param)(struct soc_camera_device *);
 	int (*set_bus_param)(struct soc_camera_device *, unsigned long);
 	int (*get_chip_id)(struct soc_camera_device *,
 			   struct v4l2_dbg_chip_ident *);
 	int (*set_std)(struct soc_camera_device *, v4l2_std_id *);
 	int (*enum_input)(struct soc_camera_device *, struct v4l2_input *);
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-	int (*get_register)(struct soc_camera_device *, struct v4l2_dbg_register *);
-	int (*set_register)(struct soc_camera_device *, struct v4l2_dbg_register *);
-#endif
-	int (*get_control)(struct soc_camera_device *, struct v4l2_control *);
-	int (*set_control)(struct soc_camera_device *, struct v4l2_control *);
 	const struct v4l2_queryctrl *controls;
 	int num_controls;
 };
-- 
1.6.2.4

