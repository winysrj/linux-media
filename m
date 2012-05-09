Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55163 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759236Ab2EIM4C (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 May 2012 08:56:02 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH 3/3] mt9m032: Implement V4L2_CID_PIXEL_RATE control
Date: Wed,  9 May 2012 14:55:59 +0200
Message-Id: <1336568159-23378-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1336568159-23378-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1336568159-23378-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The pixel rate control is required by the OMAP3 ISP driver and should be
implemented by all media controller-compatible sensor drivers.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/mt9m032.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/mt9m032.c b/drivers/media/video/mt9m032.c
index 3c1e626..445359c 100644
--- a/drivers/media/video/mt9m032.c
+++ b/drivers/media/video/mt9m032.c
@@ -688,11 +688,17 @@ static const struct v4l2_subdev_ops mt9m032_ops = {
 static int mt9m032_probe(struct i2c_client *client,
 			 const struct i2c_device_id *devid)
 {
+	struct mt9m032_platform_data *pdata = client->dev.platform_data;
 	struct i2c_adapter *adapter = client->adapter;
 	struct mt9m032 *sensor;
 	int chip_version;
 	int ret;
 
+	if (pdata == NULL) {
+		dev_err(&client->dev, "No platform data\n");
+		return -EINVAL;
+	}
+
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_WORD_DATA)) {
 		dev_warn(&client->dev,
 			 "I2C-Adapter doesn't support I2C_FUNC_SMBUS_WORD\n");
@@ -708,7 +714,7 @@ static int mt9m032_probe(struct i2c_client *client,
 
 	mutex_init(&sensor->lock);
 
-	sensor->pdata = client->dev.platform_data;
+	sensor->pdata = pdata;
 
 	v4l2_i2c_subdev_init(&sensor->subdev, client, &mt9m032_ops);
 	sensor->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
@@ -738,7 +744,7 @@ static int mt9m032_probe(struct i2c_client *client,
 	sensor->format.field = V4L2_FIELD_NONE;
 	sensor->format.colorspace = V4L2_COLORSPACE_SRGB;
 
-	v4l2_ctrl_handler_init(&sensor->ctrls, 4);
+	v4l2_ctrl_handler_init(&sensor->ctrls, 5);
 
 	v4l2_ctrl_new_std(&sensor->ctrls, &mt9m032_ctrl_ops,
 			  V4L2_CID_GAIN, 0, 127, 1, 64);
@@ -754,6 +760,9 @@ static int mt9m032_probe(struct i2c_client *client,
 			  V4L2_CID_EXPOSURE, MT9M032_SHUTTER_WIDTH_MIN,
 			  MT9M032_SHUTTER_WIDTH_MAX, 1,
 			  MT9M032_SHUTTER_WIDTH_DEF);
+	v4l2_ctrl_new_std(&sensor->ctrls, &mt9m032_ctrl_ops,
+			  V4L2_CID_PIXEL_RATE, pdata->pix_clock,
+			  pdata->pix_clock, 1, pdata->pix_clock);
 
 	if (sensor->ctrls.error) {
 		ret = sensor->ctrls.error;
-- 
1.7.3.4

