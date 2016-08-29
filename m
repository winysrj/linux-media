Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:26461 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755303AbcH2R4I (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Aug 2016 13:56:08 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Jiri Kosina <trivial@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH v5 01/13] media: mt9m111: make a standalone v4l2 subdevice
Date: Mon, 29 Aug 2016 19:55:46 +0200
Message-Id: <1472493358-24618-2-git-send-email-robert.jarzmik@free.fr>
In-Reply-To: <1472493358-24618-1-git-send-email-robert.jarzmik@free.fr>
References: <1472493358-24618-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove the soc_camera adherence. Mostly the change removes the power
manipulation provided by soc_camera, and instead :
 - powers on the sensor when the s_power control is activated
 - powers on the sensor in initial probe
 - enables and disables the MCLK provided to it in power on/off

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/media/i2c/soc_camera/mt9m111.c | 51 ++++++++++------------------------
 1 file changed, 15 insertions(+), 36 deletions(-)

diff --git a/drivers/media/i2c/soc_camera/mt9m111.c b/drivers/media/i2c/soc_camera/mt9m111.c
index 6dfaead6aaa8..a7efaa5964d1 100644
--- a/drivers/media/i2c/soc_camera/mt9m111.c
+++ b/drivers/media/i2c/soc_camera/mt9m111.c
@@ -16,10 +16,11 @@
 #include <linux/v4l2-mediabus.h>
 #include <linux/module.h>
 
-#include <media/soc_camera.h>
+#include <media/v4l2-async.h>
 #include <media/v4l2-clk.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
 
 /*
  * MT9M111, MT9M112 and MT9M131:
@@ -388,7 +389,7 @@ static int mt9m111_s_crop(struct v4l2_subdev *sd, const struct v4l2_crop *a)
 	struct v4l2_rect rect = a->c;
 	struct mt9m111 *mt9m111 = container_of(sd, struct mt9m111, subdev);
 	int width, height;
-	int ret;
+	int ret, align = 0;
 
 	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
@@ -396,17 +397,19 @@ static int mt9m111_s_crop(struct v4l2_subdev *sd, const struct v4l2_crop *a)
 	if (mt9m111->fmt->code == MEDIA_BUS_FMT_SBGGR8_1X8 ||
 	    mt9m111->fmt->code == MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_LE) {
 		/* Bayer format - even size lengths */
-		rect.width	= ALIGN(rect.width, 2);
-		rect.height	= ALIGN(rect.height, 2);
+		align = 1;
 		/* Let the user play with the starting pixel */
 	}
 
 	/* FIXME: the datasheet doesn't specify minimum sizes */
-	soc_camera_limit_side(&rect.left, &rect.width,
-		     MT9M111_MIN_DARK_COLS, 2, MT9M111_MAX_WIDTH);
-
-	soc_camera_limit_side(&rect.top, &rect.height,
-		     MT9M111_MIN_DARK_ROWS, 2, MT9M111_MAX_HEIGHT);
+	v4l_bound_align_image(&rect.width, 2, MT9M111_MAX_WIDTH, align,
+			      &rect.height, 2, MT9M111_MAX_HEIGHT, align, 0);
+	rect.left = clamp(rect.left, MT9M111_MIN_DARK_COLS,
+			  MT9M111_MIN_DARK_COLS + MT9M111_MAX_WIDTH -
+			  (__s32)rect.width);
+	rect.top = clamp(rect.top, MT9M111_MIN_DARK_ROWS,
+			 MT9M111_MIN_DARK_ROWS + MT9M111_MAX_HEIGHT -
+			 (__s32)rect.height);
 
 	width = min(mt9m111->width, rect.width);
 	height = min(mt9m111->height, rect.height);
@@ -775,17 +778,16 @@ static int mt9m111_init(struct mt9m111 *mt9m111)
 static int mt9m111_power_on(struct mt9m111 *mt9m111)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&mt9m111->subdev);
-	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 	int ret;
 
-	ret = soc_camera_power_on(&client->dev, ssdd, mt9m111->clk);
+	ret = v4l2_clk_enable(mt9m111->clk);
 	if (ret < 0)
 		return ret;
 
 	ret = mt9m111_resume(mt9m111);
 	if (ret < 0) {
 		dev_err(&client->dev, "Failed to resume the sensor: %d\n", ret);
-		soc_camera_power_off(&client->dev, ssdd, mt9m111->clk);
+		v4l2_clk_disable(mt9m111->clk);
 	}
 
 	return ret;
@@ -793,11 +795,8 @@ static int mt9m111_power_on(struct mt9m111 *mt9m111)
 
 static void mt9m111_power_off(struct mt9m111 *mt9m111)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(&mt9m111->subdev);
-	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
-
 	mt9m111_suspend(mt9m111);
-	soc_camera_power_off(&client->dev, ssdd, mt9m111->clk);
+	v4l2_clk_disable(mt9m111->clk);
 }
 
 static int mt9m111_s_power(struct v4l2_subdev *sd, int on)
@@ -854,14 +853,10 @@ static int mt9m111_enum_mbus_code(struct v4l2_subdev *sd,
 static int mt9m111_g_mbus_config(struct v4l2_subdev *sd,
 				struct v4l2_mbus_config *cfg)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
-
 	cfg->flags = V4L2_MBUS_MASTER | V4L2_MBUS_PCLK_SAMPLE_RISING |
 		V4L2_MBUS_HSYNC_ACTIVE_HIGH | V4L2_MBUS_VSYNC_ACTIVE_HIGH |
 		V4L2_MBUS_DATA_ACTIVE_HIGH;
 	cfg->type = V4L2_MBUS_PARALLEL;
-	cfg->flags = soc_camera_apply_board_flags(ssdd, cfg);
 
 	return 0;
 }
@@ -933,20 +928,8 @@ static int mt9m111_probe(struct i2c_client *client,
 {
 	struct mt9m111 *mt9m111;
 	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
-	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 	int ret;
 
-	if (client->dev.of_node) {
-		ssdd = devm_kzalloc(&client->dev, sizeof(*ssdd), GFP_KERNEL);
-		if (!ssdd)
-			return -ENOMEM;
-		client->dev.platform_data = ssdd;
-	}
-	if (!ssdd) {
-		dev_err(&client->dev, "mt9m111: driver needs platform data\n");
-		return -EINVAL;
-	}
-
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_WORD_DATA)) {
 		dev_warn(&adapter->dev,
 			 "I2C-Adapter doesn't support I2C_FUNC_SMBUS_WORD\n");
@@ -992,10 +975,6 @@ static int mt9m111_probe(struct i2c_client *client,
 	mt9m111->lastpage	= -1;
 	mutex_init(&mt9m111->power_lock);
 
-	ret = soc_camera_power_init(&client->dev, ssdd);
-	if (ret < 0)
-		goto out_hdlfree;
-
 	ret = mt9m111_video_probe(client);
 	if (ret < 0)
 		goto out_hdlfree;
-- 
2.1.4

