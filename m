Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:36298 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032379Ab2COVBp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Mar 2012 17:01:45 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [PATCH 1/1] mt9v032: Provide pixel rate control
Date: Thu, 15 Mar 2012 23:01:39 +0200
Message-Id: <1331845299-6147-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Provide pixel rate control calculated from external clock and horizontal
binning factor.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/video/mt9v032.c |   35 ++++++++++++++++++++++++++++++++++-
 1 files changed, 34 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/mt9v032.c b/drivers/media/video/mt9v032.c
index 75e253a..e530e8d 100644
--- a/drivers/media/video/mt9v032.c
+++ b/drivers/media/video/mt9v032.c
@@ -122,6 +122,7 @@ struct mt9v032 {
 	struct v4l2_mbus_framefmt format;
 	struct v4l2_rect crop;
 
+	struct v4l2_ctrl *pixel_rate;
 	struct v4l2_ctrl_handler ctrls;
 
 	struct mutex power_lock;
@@ -187,13 +188,15 @@ mt9v032_update_aec_agc(struct mt9v032 *mt9v032, u16 which, int enable)
 	return 0;
 }
 
+#define EXT_CLK		25000000
+
 static int mt9v032_power_on(struct mt9v032 *mt9v032)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&mt9v032->subdev);
 	int ret;
 
 	if (mt9v032->pdata->set_clock) {
-		mt9v032->pdata->set_clock(&mt9v032->subdev, 25000000);
+		mt9v032->pdata->set_clock(&mt9v032->subdev, EXT_CLK);
 		udelay(1);
 	}
 
@@ -365,6 +368,27 @@ static int mt9v032_get_format(struct v4l2_subdev *subdev,
 	return 0;
 }
 
+static void mt9v032_configure_pixel_rate(struct v4l2_subdev *subdev,
+					 unsigned int hratio)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(subdev);
+	struct mt9v032 *mt9v032 = to_mt9v032(subdev);
+	struct v4l2_ext_controls ctrls;
+	struct v4l2_ext_control ctrl;
+
+	memset(&ctrls, 0, sizeof(ctrls));
+	memset(&ctrl, 0, sizeof(ctrl));
+
+	ctrls.count = 1;
+	ctrls.controls = &ctrl;
+
+	ctrl.id = V4L2_CID_PIXEL_RATE;
+	ctrl.value64 = EXT_CLK / hratio;
+
+	if (v4l2_s_ext_ctrls(mt9v032->pixel_rate->ctrl_handler, &ctrls) < 0)
+		dev_warn(&client->dev, "bug: failed to set pixel rate\n");
+}
+
 static int mt9v032_set_format(struct v4l2_subdev *subdev,
 			      struct v4l2_subdev_fh *fh,
 			      struct v4l2_subdev_format *format)
@@ -395,6 +419,8 @@ static int mt9v032_set_format(struct v4l2_subdev *subdev,
 					    format->which);
 	__format->width = __crop->width / hratio;
 	__format->height = __crop->height / vratio;
+	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
+		mt9v032_configure_pixel_rate(subdev, hratio);
 
 	format->format = *__format;
 
@@ -450,6 +476,8 @@ static int mt9v032_set_crop(struct v4l2_subdev *subdev,
 						    crop->which);
 		__format->width = rect.width;
 		__format->height = rect.height;
+		if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
+			mt9v032_configure_pixel_rate(subdev, 1);
 	}
 
 	*__crop = rect;
@@ -695,6 +723,9 @@ static int mt9v032_probe(struct i2c_client *client,
 			  V4L2_CID_EXPOSURE, MT9V032_TOTAL_SHUTTER_WIDTH_MIN,
 			  MT9V032_TOTAL_SHUTTER_WIDTH_MAX, 1,
 			  MT9V032_TOTAL_SHUTTER_WIDTH_DEF);
+	mt9v032->pixel_rate =
+		v4l2_ctrl_new_std(&mt9v032->ctrls, &mt9v032_ctrl_ops,
+				  V4L2_CID_PIXEL_RATE, 0, 0, 1, 0);
 
 	for (i = 0; i < ARRAY_SIZE(mt9v032_ctrls); ++i)
 		v4l2_ctrl_new_custom(&mt9v032->ctrls, &mt9v032_ctrls[i], NULL);
@@ -716,6 +747,8 @@ static int mt9v032_probe(struct i2c_client *client,
 	mt9v032->format.field = V4L2_FIELD_NONE;
 	mt9v032->format.colorspace = V4L2_COLORSPACE_SRGB;
 
+	mt9v032_configure_pixel_rate(subdev, 1);
+
 	mt9v032->aec_agc = MT9V032_AEC_ENABLE | MT9V032_AGC_ENABLE;
 
 	v4l2_i2c_subdev_init(&mt9v032->subdev, client, &mt9v032_subdev_ops);
-- 
1.7.2.5

