Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50310 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597Ab2GWSe7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jul 2012 14:34:59 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH 3/4] mt9v032: Export horizontal and vertical blanking as V4L2 controls
Date: Mon, 23 Jul 2012 20:35:01 +0200
Message-Id: <1343068502-7431-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1343068502-7431-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1343068502-7431-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/mt9v032.c |   34 +++++++++++++++++++++++++++++++---
 1 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/mt9v032.c b/drivers/media/video/mt9v032.c
index 2203a6f..df55044 100644
--- a/drivers/media/video/mt9v032.c
+++ b/drivers/media/video/mt9v032.c
@@ -50,10 +50,19 @@
 #define		MT9V032_WINDOW_WIDTH_MAX		752
 #define MT9V032_HORIZONTAL_BLANKING			0x05
 #define		MT9V032_HORIZONTAL_BLANKING_MIN		43
+#define		MT9V032_HORIZONTAL_BLANKING_DEF		94
 #define		MT9V032_HORIZONTAL_BLANKING_MAX		1023
 #define MT9V032_VERTICAL_BLANKING			0x06
 #define		MT9V032_VERTICAL_BLANKING_MIN		4
-#define		MT9V032_VERTICAL_BLANKING_MAX		3000
+#define		MT9V032_VERTICAL_BLANKING_DEF		45
+/* The vertical blanking maximum value is 3000 rows according to the datasheet,
+ * and the sensor is supposed to automatically extend vertical blanking
+ * internally when the exposure time exceeds the total number of lines. However,
+ * experience showed that the vertical blanking is not automatically extended,
+ * and that the vertical blanking registers supports values up to at least 32767
+ * lines.
+ */
+#define		MT9V032_VERTICAL_BLANKING_MAX		32767
 #define MT9V032_CHIP_CONTROL				0x07
 #define		MT9V032_CHIP_CONTROL_MASTER_MODE	(1 << 3)
 #define		MT9V032_CHIP_CONTROL_DOUT_ENABLE	(1 << 7)
@@ -131,6 +140,7 @@ struct mt9v032 {
 	struct mt9v032_platform_data *pdata;
 	u16 chip_control;
 	u16 aec_agc;
+	u16 hblank;
 };
 
 static struct mt9v032 *to_mt9v032(struct v4l2_subdev *sd)
@@ -323,7 +333,7 @@ static int mt9v032_s_stream(struct v4l2_subdev *subdev, int enable)
 		return ret;
 
 	ret = mt9v032_write(client, MT9V032_HORIZONTAL_BLANKING,
-			    max(43, 660 - crop->width));
+			    max_t(s32, mt9v032->hblank, 660 - crop->width));
 	if (ret < 0)
 		return ret;
 
@@ -505,6 +515,15 @@ static int mt9v032_s_ctrl(struct v4l2_ctrl *ctrl)
 		return mt9v032_write(client, MT9V032_TOTAL_SHUTTER_WIDTH,
 				     ctrl->val);
 
+	case V4L2_CID_HBLANK:
+		mt9v032->hblank = ctrl->val;
+		return mt9v032_write(client, MT9V032_HORIZONTAL_BLANKING,
+				     ctrl->val);
+
+	case V4L2_CID_VBLANK:
+		return mt9v032_write(client, MT9V032_VERTICAL_BLANKING,
+				     ctrl->val);
+
 	case V4L2_CID_TEST_PATTERN:
 		switch (ctrl->val) {
 		case 0:
@@ -701,7 +720,7 @@ static int mt9v032_probe(struct i2c_client *client,
 	mutex_init(&mt9v032->power_lock);
 	mt9v032->pdata = client->dev.platform_data;
 
-	v4l2_ctrl_handler_init(&mt9v032->ctrls, ARRAY_SIZE(mt9v032_ctrls) + 5);
+	v4l2_ctrl_handler_init(&mt9v032->ctrls, ARRAY_SIZE(mt9v032_ctrls) + 7);
 
 	v4l2_ctrl_new_std(&mt9v032->ctrls, &mt9v032_ctrl_ops,
 			  V4L2_CID_AUTOGAIN, 0, 1, 1, 1);
@@ -715,6 +734,14 @@ static int mt9v032_probe(struct i2c_client *client,
 			  V4L2_CID_EXPOSURE, MT9V032_TOTAL_SHUTTER_WIDTH_MIN,
 			  MT9V032_TOTAL_SHUTTER_WIDTH_MAX, 1,
 			  MT9V032_TOTAL_SHUTTER_WIDTH_DEF);
+	v4l2_ctrl_new_std(&mt9v032->ctrls, &mt9v032_ctrl_ops,
+			  V4L2_CID_HBLANK, MT9V032_HORIZONTAL_BLANKING_MIN,
+			  MT9V032_HORIZONTAL_BLANKING_MAX, 1,
+			  MT9V032_HORIZONTAL_BLANKING_DEF);
+	v4l2_ctrl_new_std(&mt9v032->ctrls, &mt9v032_ctrl_ops,
+			  V4L2_CID_VBLANK, MT9V032_VERTICAL_BLANKING_MIN,
+			  MT9V032_VERTICAL_BLANKING_MAX, 1,
+			  MT9V032_VERTICAL_BLANKING_DEF);
 	mt9v032->pixel_rate =
 		v4l2_ctrl_new_std(&mt9v032->ctrls, &mt9v032_ctrl_ops,
 				  V4L2_CID_PIXEL_RATE, 0, 0, 1, 0);
@@ -740,6 +767,7 @@ static int mt9v032_probe(struct i2c_client *client,
 	mt9v032->format.colorspace = V4L2_COLORSPACE_SRGB;
 
 	mt9v032->aec_agc = MT9V032_AEC_ENABLE | MT9V032_AGC_ENABLE;
+	mt9v032->hblank = MT9V032_HORIZONTAL_BLANKING_DEF;
 
 	v4l2_i2c_subdev_init(&mt9v032->subdev, client, &mt9v032_subdev_ops);
 	mt9v032->subdev.internal_ops = &mt9v032_subdev_internal_ops;
-- 
1.7.8.6

