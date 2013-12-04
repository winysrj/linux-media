Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49946 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756043Ab3LDTPw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Dec 2013 14:15:52 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Enric Balletbo i Serra <eballetbo@gmail.com>
Subject: [PATCH 4/6] mt9v032: Add support for monochrome models
Date: Wed,  4 Dec 2013 20:15:51 +0100
Message-Id: <1386184553-12770-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1386184553-12770-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1386184553-12770-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Identify the model based on the I2C device name and configure formats
accordingly.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/mt9v032.c | 37 ++++++++++++++++++++++++++++++++++---
 1 file changed, 34 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
index 38bf664..a31d6d1 100644
--- a/drivers/media/i2c/mt9v032.c
+++ b/drivers/media/i2c/mt9v032.c
@@ -121,6 +121,24 @@
 #define		MT9V032_AGC_ENABLE			(1 << 1)
 #define MT9V032_THERMAL_INFO				0xc1
 
+enum mt9v032_model {
+	MT9V032_MODEL_COLOR,
+	MT9V032_MODEL_MONO,
+};
+
+struct mt9v032_model_info {
+	bool color;
+};
+
+static const struct mt9v032_model_info mt9v032_models[] = {
+	[MT9V032_MODEL_COLOR] = {
+		.color = true,
+	},
+	[MT9V032_MODEL_MONO] = {
+		.color = false,
+	},
+};
+
 struct mt9v032 {
 	struct v4l2_subdev subdev;
 	struct media_pad pad;
@@ -142,6 +160,7 @@ struct mt9v032 {
 	struct clk *clk;
 
 	struct mt9v032_platform_data *pdata;
+	const struct mt9v032_model_info *model;
 
 	u32 sysclk;
 	u16 chip_control;
@@ -691,6 +710,7 @@ static int mt9v032_registered(struct v4l2_subdev *subdev)
 
 static int mt9v032_open(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh)
 {
+	struct mt9v032 *mt9v032 = to_mt9v032(subdev);
 	struct v4l2_mbus_framefmt *format;
 	struct v4l2_rect *crop;
 
@@ -701,7 +721,12 @@ static int mt9v032_open(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh)
 	crop->height = MT9V032_WINDOW_HEIGHT_DEF;
 
 	format = v4l2_subdev_get_try_format(fh, 0);
-	format->code = V4L2_MBUS_FMT_SGRBG10_1X10;
+
+	if (mt9v032->model->color)
+		format->code = V4L2_MBUS_FMT_SGRBG10_1X10;
+	else
+		format->code = V4L2_MBUS_FMT_Y10_1X10;
+
 	format->width = MT9V032_WINDOW_WIDTH_DEF;
 	format->height = MT9V032_WINDOW_HEIGHT_DEF;
 	format->field = V4L2_FIELD_NONE;
@@ -773,6 +798,7 @@ static int mt9v032_probe(struct i2c_client *client,
 
 	mutex_init(&mt9v032->power_lock);
 	mt9v032->pdata = pdata;
+	mt9v032->model = (const void *)did->driver_data;
 
 	v4l2_ctrl_handler_init(&mt9v032->ctrls, 10);
 
@@ -837,7 +863,11 @@ static int mt9v032_probe(struct i2c_client *client,
 	mt9v032->crop.width = MT9V032_WINDOW_WIDTH_DEF;
 	mt9v032->crop.height = MT9V032_WINDOW_HEIGHT_DEF;
 
-	mt9v032->format.code = V4L2_MBUS_FMT_SGRBG10_1X10;
+	if (mt9v032->model->color)
+		mt9v032->format.code = V4L2_MBUS_FMT_SGRBG10_1X10;
+	else
+		mt9v032->format.code = V4L2_MBUS_FMT_Y10_1X10;
+
 	mt9v032->format.width = MT9V032_WINDOW_WIDTH_DEF;
 	mt9v032->format.height = MT9V032_WINDOW_HEIGHT_DEF;
 	mt9v032->format.field = V4L2_FIELD_NONE;
@@ -876,7 +906,8 @@ static int mt9v032_remove(struct i2c_client *client)
 }
 
 static const struct i2c_device_id mt9v032_id[] = {
-	{ "mt9v032", 0 },
+	{ "mt9v032", (kernel_ulong_t)&mt9v032_models[MT9V032_MODEL_COLOR] },
+	{ "mt9v032m", (kernel_ulong_t)&mt9v032_models[MT9V032_MODEL_MONO] },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, mt9v032_id);
-- 
1.8.3.2

