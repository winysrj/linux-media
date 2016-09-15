Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39292 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1764599AbcIOLWl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Sep 2016 07:22:41 -0400
Received: from lanttu.localdomain (unknown [192.168.15.166])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 6FA5E600AC
        for <linux-media@vger.kernel.org>; Thu, 15 Sep 2016 14:22:36 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 14/17] smiapp: Remove useless newlines and other small cleanups
Date: Thu, 15 Sep 2016 14:22:28 +0300
Message-Id: <1473938551-14503-15-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1473938551-14503-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1473938551-14503-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The code probably has been unindented at some point but rewrapping has not
been done. Do it now.

Also remove a useless memory allocation failure message.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 33 +++++++++++++--------------------
 1 file changed, 13 insertions(+), 20 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 8b042e2..3548225 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -442,8 +442,7 @@ static int smiapp_set_ctrl(struct v4l2_ctrl *ctrl)
 			orient |= SMIAPP_IMAGE_ORIENTATION_VFLIP;
 
 		orient ^= sensor->hvflip_inv_mask;
-		rval = smiapp_write(sensor,
-				    SMIAPP_REG_U8_IMAGE_ORIENTATION,
+		rval = smiapp_write(sensor, SMIAPP_REG_U8_IMAGE_ORIENTATION,
 				    orient);
 		if (rval < 0)
 			return rval;
@@ -458,10 +457,8 @@ static int smiapp_set_ctrl(struct v4l2_ctrl *ctrl)
 		__smiapp_update_exposure_limits(sensor);
 
 		if (exposure > sensor->exposure->maximum) {
-			sensor->exposure->val =
-				sensor->exposure->maximum;
-			rval = smiapp_set_ctrl(
-				sensor->exposure);
+			sensor->exposure->val =	sensor->exposure->maximum;
+			rval = smiapp_set_ctrl(sensor->exposure);
 			if (rval < 0)
 				return rval;
 		}
@@ -1318,8 +1315,7 @@ static int smiapp_power_on(struct smiapp_sensor *sensor)
 	if (!sensor->pixel_array)
 		return 0;
 
-	rval = v4l2_ctrl_handler_setup(
-		&sensor->pixel_array->ctrl_handler);
+	rval = v4l2_ctrl_handler_setup(&sensor->pixel_array->ctrl_handler);
 	if (rval)
 		goto out_cci_addr_fail;
 
@@ -1625,7 +1621,8 @@ static int __smiapp_get_format(struct v4l2_subdev *subdev,
 	struct smiapp_subdev *ssd = to_smiapp_subdev(subdev);
 
 	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
-		fmt->format = *v4l2_subdev_get_try_format(subdev, cfg, fmt->pad);
+		fmt->format = *v4l2_subdev_get_try_format(subdev, cfg,
+							  fmt->pad);
 	} else {
 		struct v4l2_rect *r;
 
@@ -1725,7 +1722,6 @@ static void smiapp_propagate(struct v4l2_subdev *subdev,
 static const struct smiapp_csi_data_format
 *smiapp_validate_csi_data_format(struct smiapp_sensor *sensor, u32 code)
 {
-	const struct smiapp_csi_data_format *csi_format = sensor->csi_format;
 	unsigned int i;
 
 	for (i = 0; i < ARRAY_SIZE(smiapp_csi_data_formats); i++) {
@@ -1734,7 +1730,7 @@ static const struct smiapp_csi_data_format
 			return &smiapp_csi_data_formats[i];
 	}
 
-	return csi_format;
+	return sensor->csi_format;
 }
 
 static int smiapp_set_format_source(struct v4l2_subdev *subdev,
@@ -2068,8 +2064,7 @@ static int smiapp_set_compose(struct v4l2_subdev *subdev,
 		smiapp_set_compose_scaler(subdev, cfg, sel, crops, comp);
 
 	*comp = sel->r;
-	smiapp_propagate(subdev, cfg, sel->which,
-			 V4L2_SEL_TGT_COMPOSE);
+	smiapp_propagate(subdev, cfg, sel->which, V4L2_SEL_TGT_COMPOSE);
 
 	if (sel->which == V4L2_SUBDEV_FORMAT_ACTIVE)
 		return smiapp_update_mode(sensor);
@@ -2146,9 +2141,8 @@ static int smiapp_set_crop(struct v4l2_subdev *subdev,
 				->height;
 			src_size = &_r;
 		} else {
-			src_size =
-				v4l2_subdev_get_try_compose(
-					subdev, cfg, ssd->sink_pad);
+			src_size = v4l2_subdev_get_try_compose(
+				subdev, cfg, ssd->sink_pad);
 		}
 	}
 
@@ -2617,7 +2611,8 @@ static int smiapp_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 	for (i = 0; i < ssd->npads; i++) {
 		struct v4l2_mbus_framefmt *try_fmt =
 			v4l2_subdev_get_try_format(sd, fh->pad, i);
-		struct v4l2_rect *try_crop = v4l2_subdev_get_try_crop(sd, fh->pad, i);
+		struct v4l2_rect *try_crop =
+			v4l2_subdev_get_try_crop(sd, fh->pad, i);
 		struct v4l2_rect *try_comp;
 
 		smiapp_get_native_size(ssd, try_crop);
@@ -2856,8 +2851,7 @@ static int smiapp_probe(struct i2c_client *client,
 		return -EPROBE_DEFER;
 	}
 
-	rval = clk_set_rate(sensor->ext_clk,
-			    sensor->hwcfg->ext_clk);
+	rval = clk_set_rate(sensor->ext_clk, sensor->hwcfg->ext_clk);
 	if (rval < 0) {
 		dev_err(&client->dev,
 			"unable to set clock freq to %u\n",
@@ -2958,7 +2952,6 @@ static int smiapp_probe(struct i2c_client *client,
 		sensor->nvm = devm_kzalloc(&client->dev,
 				sensor->hwcfg->nvm_size, GFP_KERNEL);
 		if (sensor->nvm == NULL) {
-			dev_err(&client->dev, "nvm buf allocation failed\n");
 			rval = -ENOMEM;
 			goto out_cleanup;
 		}
-- 
2.1.4

