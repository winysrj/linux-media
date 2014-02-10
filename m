Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42214 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903AbaBJVxt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 16:53:49 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
Subject: [PATCH 2/5] mt9t001: Add regulator support
Date: Mon, 10 Feb 2014 22:54:41 +0100
Message-Id: <1392069284-18024-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1392069284-18024-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1392069284-18024-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The sensor needs two power supplies, VAA and VDD. Require a regulator
for each of them.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/mt9t001.c | 206 +++++++++++++++++++++++++++++++++-----------
 1 file changed, 156 insertions(+), 50 deletions(-)

diff --git a/drivers/media/i2c/mt9t001.c b/drivers/media/i2c/mt9t001.c
index d41c70e..9a0bb06 100644
--- a/drivers/media/i2c/mt9t001.c
+++ b/drivers/media/i2c/mt9t001.c
@@ -13,8 +13,9 @@
  */
 
 #include <linux/i2c.h>
-#include <linux/module.h>
 #include <linux/log2.h>
+#include <linux/module.h>
+#include <linux/regulator/consumer.h>
 #include <linux/slab.h>
 #include <linux/videodev2.h>
 #include <linux/v4l2-mediabus.h>
@@ -55,6 +56,7 @@
 #define		MT9T001_OUTPUT_CONTROL_SYNC		(1 << 0)
 #define		MT9T001_OUTPUT_CONTROL_CHIP_ENABLE	(1 << 1)
 #define		MT9T001_OUTPUT_CONTROL_TEST_DATA	(1 << 6)
+#define		MT9T001_OUTPUT_CONTROL_DEF		0x0002
 #define MT9T001_SHUTTER_WIDTH_HIGH			0x08
 #define MT9T001_SHUTTER_WIDTH_LOW			0x09
 #define		MT9T001_SHUTTER_WIDTH_MIN		1
@@ -116,6 +118,11 @@ struct mt9t001 {
 	struct v4l2_subdev subdev;
 	struct media_pad pad;
 
+	struct regulator_bulk_data regulators[2];
+
+	struct mutex power_lock; /* lock to protect power_count */
+	int power_count;
+
 	struct v4l2_mbus_framefmt format;
 	struct v4l2_rect crop;
 
@@ -159,6 +166,62 @@ static int mt9t001_set_output_control(struct mt9t001 *mt9t001, u16 clear,
 	return 0;
 }
 
+static int mt9t001_reset(struct mt9t001 *mt9t001)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&mt9t001->subdev);
+	int ret;
+
+	/* Reset the chip and stop data read out */
+	ret = mt9t001_write(client, MT9T001_RESET, 1);
+	if (ret < 0)
+		return ret;
+
+	ret = mt9t001_write(client, MT9T001_RESET, 0);
+	if (ret < 0)
+		return ret;
+
+	mt9t001->output_control = MT9T001_OUTPUT_CONTROL_DEF;
+
+	return mt9t001_set_output_control(mt9t001,
+					  MT9T001_OUTPUT_CONTROL_CHIP_ENABLE,
+					  0);
+}
+
+static int mt9t001_power_on(struct mt9t001 *mt9t001)
+{
+	/* Bring up the supplies */
+	return regulator_bulk_enable(ARRAY_SIZE(mt9t001->regulators),
+				     mt9t001->regulators);
+}
+
+static void mt9t001_power_off(struct mt9t001 *mt9t001)
+{
+	regulator_bulk_disable(ARRAY_SIZE(mt9t001->regulators),
+			       mt9t001->regulators);
+
+static int __mt9t001_set_power(struct mt9t001 *mt9t001, bool on)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&mt9t001->subdev);
+	int ret;
+
+	if (!on) {
+		mt9t001_power_off(mt9t001);
+		return 0;
+	}
+
+	ret = mt9t001_power_on(mt9t001);
+	if (ret < 0)
+		return ret;
+
+	ret = mt9t001_reset(mt9t001);
+	if (ret < 0) {
+		dev_err(&client->dev, "Failed to reset the camera\n");
+		return ret;
+	}
+
+	return v4l2_ctrl_handler_setup(&mt9t001->ctrls);
+}
+
 /* -----------------------------------------------------------------------------
  * V4L2 subdev video operations
  */
@@ -195,6 +258,7 @@ static int mt9t001_s_stream(struct v4l2_subdev *subdev, int enable)
 {
 	const u16 mode = MT9T001_OUTPUT_CONTROL_CHIP_ENABLE;
 	struct i2c_client *client = v4l2_get_subdevdata(subdev);
+	struct mt9t001_platform_data *pdata = client->dev.platform_data;
 	struct mt9t001 *mt9t001 = to_mt9t001(subdev);
 	struct v4l2_mbus_framefmt *format = &mt9t001->format;
 	struct v4l2_rect *crop = &mt9t001->crop;
@@ -205,6 +269,14 @@ static int mt9t001_s_stream(struct v4l2_subdev *subdev, int enable)
 	if (!enable)
 		return mt9t001_set_output_control(mt9t001, mode, 0);
 
+	/* Configure the pixel clock polarity */
+	if (pdata->clk_pol) {
+		ret  = mt9t001_write(client, MT9T001_PIXEL_CLOCK,
+				     MT9T001_PIXEL_CLOCK_INVERT);
+		if (ret < 0)
+			return ret;
+	}
+
 	/* Configure the window size and row/column bin */
 	hratio = DIV_ROUND_CLOSEST(crop->width, format->width);
 	vratio = DIV_ROUND_CLOSEST(crop->height, format->height);
@@ -630,9 +702,67 @@ static const struct v4l2_ctrl_config mt9t001_gains[] = {
 };
 
 /* -----------------------------------------------------------------------------
+ * V4L2 subdev core operations
+ */
+
+static int mt9t001_set_power(struct v4l2_subdev *subdev, int on)
+{
+	struct mt9t001 *mt9t001 = to_mt9t001(subdev);
+	int ret = 0;
+
+	mutex_lock(&mt9t001->power_lock);
+
+	/* If the power count is modified from 0 to != 0 or from != 0 to 0,
+	 * update the power state.
+	 */
+	if (mt9t001->power_count == !on) {
+		ret = __mt9t001_set_power(mt9t001, !!on);
+		if (ret < 0)
+			goto out;
+	}
+
+	/* Update the power count. */
+	mt9t001->power_count += on ? 1 : -1;
+	WARN_ON(mt9t001->power_count < 0);
+
+out:
+	mutex_unlock(&mt9t001->power_lock);
+	return ret;
+}
+
+/* -----------------------------------------------------------------------------
  * V4L2 subdev internal operations
  */
 
+static int mt9t001_registered(struct v4l2_subdev *subdev)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(subdev);
+	struct mt9t001 *mt9t001 = to_mt9t001(subdev);
+	s32 data;
+	int ret;
+
+	ret = mt9t001_power_on(mt9t001);
+	if (ret < 0) {
+		dev_err(&client->dev, "MT9T001 power up failed\n");
+		return ret;
+	}
+
+	/* Read out the chip version register */
+	data = mt9t001_read(client, MT9T001_CHIP_VERSION);
+	mt9t001_power_off(mt9t001);
+
+	if (data != MT9T001_CHIP_ID) {
+		dev_err(&client->dev,
+			"MT9T001 not detected, wrong version 0x%04x\n", data);
+		return -ENODEV;
+	}
+
+	dev_info(&client->dev, "MT9T001 detected at address 0x%02x\n",
+		 client->addr);
+
+	return 0;
+}
+
 static int mt9t001_open(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh)
 {
 	struct v4l2_mbus_framefmt *format;
@@ -651,9 +781,18 @@ static int mt9t001_open(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh)
 	format->field = V4L2_FIELD_NONE;
 	format->colorspace = V4L2_COLORSPACE_SRGB;
 
-	return 0;
+	return mt9t001_set_power(subdev, 1);
 }
 
+static int mt9t001_close(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh)
+{
+	return mt9t001_set_power(subdev, 0);
+}
+
+static struct v4l2_subdev_core_ops mt9t001_subdev_core_ops = {
+	.s_power = mt9t001_set_power,
+};
+
 static struct v4l2_subdev_video_ops mt9t001_subdev_video_ops = {
 	.s_stream = mt9t001_s_stream,
 };
@@ -668,58 +807,17 @@ static struct v4l2_subdev_pad_ops mt9t001_subdev_pad_ops = {
 };
 
 static struct v4l2_subdev_ops mt9t001_subdev_ops = {
+	.core = &mt9t001_subdev_core_ops,
 	.video = &mt9t001_subdev_video_ops,
 	.pad = &mt9t001_subdev_pad_ops,
 };
 
 static struct v4l2_subdev_internal_ops mt9t001_subdev_internal_ops = {
+	.registered = mt9t001_registered,
 	.open = mt9t001_open,
+	.close = mt9t001_close,
 };
 
-static int mt9t001_video_probe(struct i2c_client *client)
-{
-	struct mt9t001_platform_data *pdata = client->dev.platform_data;
-	s32 data;
-	int ret;
-
-	dev_info(&client->dev, "Probing MT9T001 at address 0x%02x\n",
-		 client->addr);
-
-	/* Reset the chip and stop data read out */
-	ret = mt9t001_write(client, MT9T001_RESET, 1);
-	if (ret < 0)
-		return ret;
-
-	ret = mt9t001_write(client, MT9T001_RESET, 0);
-	if (ret < 0)
-		return ret;
-
-	ret  = mt9t001_write(client, MT9T001_OUTPUT_CONTROL, 0);
-	if (ret < 0)
-		return ret;
-
-	/* Configure the pixel clock polarity */
-	if (pdata->clk_pol) {
-		ret  = mt9t001_write(client, MT9T001_PIXEL_CLOCK,
-				     MT9T001_PIXEL_CLOCK_INVERT);
-		if (ret < 0)
-			return ret;
-	}
-
-	/* Read and check the sensor version */
-	data = mt9t001_read(client, MT9T001_CHIP_VERSION);
-	if (data != MT9T001_CHIP_ID) {
-		dev_err(&client->dev, "MT9T001 not detected, wrong version "
-			"0x%04x\n", data);
-		return -ENODEV;
-	}
-
-	dev_info(&client->dev, "MT9T001 detected at address 0x%02x\n",
-		 client->addr);
-
-	return ret;
-}
-
 static int mt9t001_probe(struct i2c_client *client,
 			 const struct i2c_device_id *did)
 {
@@ -740,14 +838,22 @@ static int mt9t001_probe(struct i2c_client *client,
 		return -EIO;
 	}
 
-	ret = mt9t001_video_probe(client);
-	if (ret < 0)
-		return ret;
-
 	mt9t001 = devm_kzalloc(&client->dev, sizeof(*mt9t001), GFP_KERNEL);
 	if (!mt9t001)
 		return -ENOMEM;
 
+	mutex_init(&mt9t001->power_lock);
+	mt9t001->output_control = MT9T001_OUTPUT_CONTROL_DEF;
+
+	mt9t001->regulators[0].supply = "vdd";
+	mt9t001->regulators[1].supply = "vaa";
+
+	ret = devm_regulator_bulk_get(&client->dev, 2, mt9t001->regulators);
+	if (ret < 0) {
+		dev_err(&client->dev, "Unable to get regulators\n");
+		return ret;
+	}
+
 	v4l2_ctrl_handler_init(&mt9t001->ctrls, ARRAY_SIZE(mt9t001_ctrls) +
 						ARRAY_SIZE(mt9t001_gains) + 4);
 
-- 
1.8.3.2

