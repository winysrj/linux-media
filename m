Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39793 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854Ab2GWXKi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jul 2012 19:10:38 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH v2] mt9v032: Export horizontal and vertical blanking as V4L2 controls
Date: Tue, 24 Jul 2012 01:10:42 +0200
Message-Id: <1343085042-19695-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1343068502-7431-4-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1343068502-7431-4-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/mt9v032.c |   36 +++++++++++++++++++++++++++++++++---
 1 files changed, 33 insertions(+), 3 deletions(-)

Changes since v1:

- Make sure the total horizontal time will not go below 660 when setting the
  horizontal blanking control
- Restrict the vertical blanking value to 3000 as documented in the datasheet.
  Increasing the exposure time actually extends vertical blanking, as long as
  the user doesn't forget to turn auto-exposure off...

diff --git a/drivers/media/video/mt9v032.c b/drivers/media/video/mt9v032.c
index 2203a6f..e713ad9 100644
--- a/drivers/media/video/mt9v032.c
+++ b/drivers/media/video/mt9v032.c
@@ -50,9 +50,11 @@
 #define		MT9V032_WINDOW_WIDTH_MAX		752
 #define MT9V032_HORIZONTAL_BLANKING			0x05
 #define		MT9V032_HORIZONTAL_BLANKING_MIN		43
+#define		MT9V032_HORIZONTAL_BLANKING_DEF		94
 #define		MT9V032_HORIZONTAL_BLANKING_MAX		1023
 #define MT9V032_VERTICAL_BLANKING			0x06
 #define		MT9V032_VERTICAL_BLANKING_MIN		4
+#define		MT9V032_VERTICAL_BLANKING_DEF		45
 #define		MT9V032_VERTICAL_BLANKING_MAX		3000
 #define MT9V032_CHIP_CONTROL				0x07
 #define		MT9V032_CHIP_CONTROL_MASTER_MODE	(1 << 3)
@@ -129,8 +131,10 @@ struct mt9v032 {
 	int power_count;
 
 	struct mt9v032_platform_data *pdata;
+
 	u16 chip_control;
 	u16 aec_agc;
+	u16 hblank;
 };
 
 static struct mt9v032 *to_mt9v032(struct v4l2_subdev *sd)
@@ -188,6 +192,16 @@ mt9v032_update_aec_agc(struct mt9v032 *mt9v032, u16 which, int enable)
 	return 0;
 }
 
+static int
+mt9v032_update_hblank(struct mt9v032 *mt9v032)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&mt9v032->subdev);
+	struct v4l2_rect *crop = &mt9v032->crop;
+
+	return mt9v032_write(client, MT9V032_HORIZONTAL_BLANKING,
+			     max_t(s32, mt9v032->hblank, 660 - crop->width));
+}
+
 #define EXT_CLK		25000000
 
 static int mt9v032_power_on(struct mt9v032 *mt9v032)
@@ -322,8 +336,7 @@ static int mt9v032_s_stream(struct v4l2_subdev *subdev, int enable)
 	if (ret < 0)
 		return ret;
 
-	ret = mt9v032_write(client, MT9V032_HORIZONTAL_BLANKING,
-			    max(43, 660 - crop->width));
+	ret = mt9v032_update_hblank(mt9v032);
 	if (ret < 0)
 		return ret;
 
@@ -505,6 +518,14 @@ static int mt9v032_s_ctrl(struct v4l2_ctrl *ctrl)
 		return mt9v032_write(client, MT9V032_TOTAL_SHUTTER_WIDTH,
 				     ctrl->val);
 
+	case V4L2_CID_HBLANK:
+		mt9v032->hblank = ctrl->val;
+		return mt9v032_update_hblank(mt9v032);
+
+	case V4L2_CID_VBLANK:
+		return mt9v032_write(client, MT9V032_VERTICAL_BLANKING,
+				     ctrl->val);
+
 	case V4L2_CID_TEST_PATTERN:
 		switch (ctrl->val) {
 		case 0:
@@ -701,7 +722,7 @@ static int mt9v032_probe(struct i2c_client *client,
 	mutex_init(&mt9v032->power_lock);
 	mt9v032->pdata = client->dev.platform_data;
 
-	v4l2_ctrl_handler_init(&mt9v032->ctrls, ARRAY_SIZE(mt9v032_ctrls) + 5);
+	v4l2_ctrl_handler_init(&mt9v032->ctrls, ARRAY_SIZE(mt9v032_ctrls) + 7);
 
 	v4l2_ctrl_new_std(&mt9v032->ctrls, &mt9v032_ctrl_ops,
 			  V4L2_CID_AUTOGAIN, 0, 1, 1, 1);
@@ -715,6 +736,14 @@ static int mt9v032_probe(struct i2c_client *client,
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
@@ -740,6 +769,7 @@ static int mt9v032_probe(struct i2c_client *client,
 	mt9v032->format.colorspace = V4L2_COLORSPACE_SRGB;
 
 	mt9v032->aec_agc = MT9V032_AEC_ENABLE | MT9V032_AGC_ENABLE;
+	mt9v032->hblank = MT9V032_HORIZONTAL_BLANKING_DEF;
 
 	v4l2_i2c_subdev_init(&mt9v032->subdev, client, &mt9v032_subdev_ops);
 	mt9v032->subdev.internal_ops = &mt9v032_subdev_internal_ops;
-- 
Regards,

Laurent Pinchart

