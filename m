Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55161 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759225Ab2EIM4B (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 May 2012 08:56:01 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH 1/3] mt9t001: Implement V4L2_CID_PIXEL_RATE control
Date: Wed,  9 May 2012 14:55:57 +0200
Message-Id: <1336568159-23378-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1336568159-23378-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1336568159-23378-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The pixel rate control is required by the OMAP3 ISP driver and should be
implemented by all media controller-compatible sensor drivers.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/mt9t001.c |   13 +++++++++++--
 include/media/mt9t001.h       |    1 +
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/mt9t001.c b/drivers/media/video/mt9t001.c
index 49ca3cb..6d343ad 100644
--- a/drivers/media/video/mt9t001.c
+++ b/drivers/media/video/mt9t001.c
@@ -691,7 +691,7 @@ static int mt9t001_video_probe(struct i2c_client *client)
 		return ret;
 
 	/* Configure the pixel clock polarity */
-	if (pdata && pdata->clk_pol) {
+	if (pdata->clk_pol) {
 		ret  = mt9t001_write(client, MT9T001_PIXEL_CLOCK,
 				     MT9T001_PIXEL_CLOCK_INVERT);
 		if (ret < 0)
@@ -715,10 +715,16 @@ static int mt9t001_video_probe(struct i2c_client *client)
 static int mt9t001_probe(struct i2c_client *client,
 			 const struct i2c_device_id *did)
 {
+	struct mt9t001_platform_data *pdata = client->dev.platform_data;
 	struct mt9t001 *mt9t001;
 	unsigned int i;
 	int ret;
 
+	if (pdata == NULL) {
+		dev_err(&client->dev, "No platform data\n");
+		return -EINVAL;
+	}
+
 	if (!i2c_check_functionality(client->adapter,
 				     I2C_FUNC_SMBUS_WORD_DATA)) {
 		dev_warn(&client->adapter->dev,
@@ -735,7 +741,7 @@ static int mt9t001_probe(struct i2c_client *client,
 		return -ENOMEM;
 
 	v4l2_ctrl_handler_init(&mt9t001->ctrls, ARRAY_SIZE(mt9t001_ctrls) +
-						ARRAY_SIZE(mt9t001_gains) + 2);
+						ARRAY_SIZE(mt9t001_gains) + 3);
 
 	v4l2_ctrl_new_std(&mt9t001->ctrls, &mt9t001_ctrl_ops,
 			  V4L2_CID_EXPOSURE, MT9T001_SHUTTER_WIDTH_MIN,
@@ -743,6 +749,9 @@ static int mt9t001_probe(struct i2c_client *client,
 			  MT9T001_SHUTTER_WIDTH_DEF);
 	v4l2_ctrl_new_std(&mt9t001->ctrls, &mt9t001_ctrl_ops,
 			  V4L2_CID_BLACK_LEVEL, 1, 1, 1, 1);
+	v4l2_ctrl_new_std(&mt9t001->ctrls, &mt9t001_ctrl_ops,
+			  V4L2_CID_PIXEL_RATE, pdata->ext_clk, pdata->ext_clk,
+			  1, pdata->ext_clk);
 
 	for (i = 0; i < ARRAY_SIZE(mt9t001_ctrls); ++i)
 		v4l2_ctrl_new_custom(&mt9t001->ctrls, &mt9t001_ctrls[i], NULL);
diff --git a/include/media/mt9t001.h b/include/media/mt9t001.h
index e839a78..03fd63e 100644
--- a/include/media/mt9t001.h
+++ b/include/media/mt9t001.h
@@ -3,6 +3,7 @@
 
 struct mt9t001_platform_data {
 	unsigned int clk_pol:1;
+	unsigned int ext_clk;
 };
 
 #endif
-- 
1.7.3.4

