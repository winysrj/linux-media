Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49947 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933089Ab3LDTPv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Dec 2013 14:15:51 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Enric Balletbo i Serra <eballetbo@gmail.com>
Subject: [PATCH 3/6] mt9v032: Fix binning configuration
Date: Wed,  4 Dec 2013 20:15:50 +0100
Message-Id: <1386184553-12770-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1386184553-12770-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1386184553-12770-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The sensor can scale the image down using binning by 1, 2 or 4 in both
directions. Update size enumeration and ratio and binning factor
computation accordingly.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/mt9v032.c | 68 ++++++++++++++++++++++++++++++---------------
 1 file changed, 45 insertions(+), 23 deletions(-)

diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
index 12360e4..38bf664 100644
--- a/drivers/media/i2c/mt9v032.c
+++ b/drivers/media/i2c/mt9v032.c
@@ -127,6 +127,8 @@ struct mt9v032 {
 
 	struct v4l2_mbus_framefmt format;
 	struct v4l2_rect crop;
+	unsigned int hratio;
+	unsigned int vratio;
 
 	struct v4l2_ctrl_handler ctrls;
 	struct {
@@ -311,22 +313,20 @@ static int mt9v032_s_stream(struct v4l2_subdev *subdev, int enable)
 		       | MT9V032_CHIP_CONTROL_SEQUENTIAL;
 	struct i2c_client *client = v4l2_get_subdevdata(subdev);
 	struct mt9v032 *mt9v032 = to_mt9v032(subdev);
-	struct v4l2_mbus_framefmt *format = &mt9v032->format;
 	struct v4l2_rect *crop = &mt9v032->crop;
-	unsigned int hratio;
-	unsigned int vratio;
+	unsigned int hbin;
+	unsigned int vbin;
 	int ret;
 
 	if (!enable)
 		return mt9v032_set_chip_control(mt9v032, mode, 0);
 
 	/* Configure the window size and row/column bin */
-	hratio = DIV_ROUND_CLOSEST(crop->width, format->width);
-	vratio = DIV_ROUND_CLOSEST(crop->height, format->height);
-
+	hbin = fls(mt9v032->hratio) - 1;
+	vbin = fls(mt9v032->vratio) - 1;
 	ret = mt9v032_write(client, MT9V032_READ_MODE,
-		    (hratio - 1) << MT9V032_READ_MODE_ROW_BIN_SHIFT |
-		    (vratio - 1) << MT9V032_READ_MODE_COLUMN_BIN_SHIFT);
+			    hbin << MT9V032_READ_MODE_COLUMN_BIN_SHIFT |
+			    vbin << MT9V032_READ_MODE_ROW_BIN_SHIFT);
 	if (ret < 0)
 		return ret;
 
@@ -369,12 +369,12 @@ static int mt9v032_enum_frame_size(struct v4l2_subdev *subdev,
 				   struct v4l2_subdev_fh *fh,
 				   struct v4l2_subdev_frame_size_enum *fse)
 {
-	if (fse->index >= 8 || fse->code != V4L2_MBUS_FMT_SGRBG10_1X10)
+	if (fse->index >= 3 || fse->code != V4L2_MBUS_FMT_SGRBG10_1X10)
 		return -EINVAL;
 
-	fse->min_width = MT9V032_WINDOW_WIDTH_DEF / fse->index;
+	fse->min_width = MT9V032_WINDOW_WIDTH_DEF / (1 << fse->index);
 	fse->max_width = fse->min_width;
-	fse->min_height = MT9V032_WINDOW_HEIGHT_DEF / fse->index;
+	fse->min_height = MT9V032_WINDOW_HEIGHT_DEF / (1 << fse->index);
 	fse->max_height = fse->min_height;
 
 	return 0;
@@ -391,18 +391,30 @@ static int mt9v032_get_format(struct v4l2_subdev *subdev,
 	return 0;
 }
 
-static void mt9v032_configure_pixel_rate(struct mt9v032 *mt9v032,
-					 unsigned int hratio)
+static void mt9v032_configure_pixel_rate(struct mt9v032 *mt9v032)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&mt9v032->subdev);
 	int ret;
 
 	ret = v4l2_ctrl_s_ctrl_int64(mt9v032->pixel_rate,
-				     mt9v032->sysclk / hratio);
+				     mt9v032->sysclk / mt9v032->hratio);
 	if (ret < 0)
 		dev_warn(&client->dev, "failed to set pixel rate (%d)\n", ret);
 }
 
+static unsigned int mt9v032_calc_ratio(unsigned int input, unsigned int output)
+{
+	/* Compute the power-of-two binning factor closest to the input size to
+	 * output size ratio. Given that the output size is bounded by input/4
+	 * and input, a generic implementation would be an ineffective luxury.
+	 */
+	if (output * 3 > input * 2)
+		return 1;
+	if (output * 3 > input)
+		return 2;
+	return 4;
+}
+
 static int mt9v032_set_format(struct v4l2_subdev *subdev,
 			      struct v4l2_subdev_fh *fh,
 			      struct v4l2_subdev_format *format)
@@ -420,21 +432,25 @@ static int mt9v032_set_format(struct v4l2_subdev *subdev,
 
 	/* Clamp the width and height to avoid dividing by zero. */
 	width = clamp_t(unsigned int, ALIGN(format->format.width, 2),
-			max(__crop->width / 8, MT9V032_WINDOW_WIDTH_MIN),
+			max(__crop->width / 4, MT9V032_WINDOW_WIDTH_MIN),
 			__crop->width);
 	height = clamp_t(unsigned int, ALIGN(format->format.height, 2),
-			 max(__crop->height / 8, MT9V032_WINDOW_HEIGHT_MIN),
+			 max(__crop->height / 4, MT9V032_WINDOW_HEIGHT_MIN),
 			 __crop->height);
 
-	hratio = DIV_ROUND_CLOSEST(__crop->width, width);
-	vratio = DIV_ROUND_CLOSEST(__crop->height, height);
+	hratio = mt9v032_calc_ratio(__crop->width, width);
+	vratio = mt9v032_calc_ratio(__crop->height, height);
 
 	__format = __mt9v032_get_pad_format(mt9v032, fh, format->pad,
 					    format->which);
 	__format->width = __crop->width / hratio;
 	__format->height = __crop->height / vratio;
-	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
-		mt9v032_configure_pixel_rate(mt9v032, hratio);
+
+	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
+		mt9v032->hratio = hratio;
+		mt9v032->vratio = vratio;
+		mt9v032_configure_pixel_rate(mt9v032);
+	}
 
 	format->format = *__format;
 
@@ -490,8 +506,11 @@ static int mt9v032_set_crop(struct v4l2_subdev *subdev,
 						    crop->which);
 		__format->width = rect.width;
 		__format->height = rect.height;
-		if (crop->which == V4L2_SUBDEV_FORMAT_ACTIVE)
-			mt9v032_configure_pixel_rate(mt9v032, 1);
+		if (crop->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
+			mt9v032->hratio = 1;
+			mt9v032->vratio = 1;
+			mt9v032_configure_pixel_rate(mt9v032);
+		}
 	}
 
 	*__crop = rect;
@@ -665,7 +684,7 @@ static int mt9v032_registered(struct v4l2_subdev *subdev)
 	dev_info(&client->dev, "MT9V032 detected at address 0x%02x\n",
 			client->addr);
 
-	mt9v032_configure_pixel_rate(mt9v032, 1);
+	mt9v032_configure_pixel_rate(mt9v032);
 
 	return ret;
 }
@@ -824,6 +843,9 @@ static int mt9v032_probe(struct i2c_client *client,
 	mt9v032->format.field = V4L2_FIELD_NONE;
 	mt9v032->format.colorspace = V4L2_COLORSPACE_SRGB;
 
+	mt9v032->hratio = 1;
+	mt9v032->vratio = 1;
+
 	mt9v032->aec_agc = MT9V032_AEC_ENABLE | MT9V032_AGC_ENABLE;
 	mt9v032->hblank = MT9V032_HORIZONTAL_BLANKING_DEF;
 	mt9v032->sysclk = MT9V032_SYSCLK_FREQ_DEF;
-- 
1.8.3.2

