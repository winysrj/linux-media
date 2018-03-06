Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:53552 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753860AbeCFREv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Mar 2018 12:04:51 -0500
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>
CC: <linux-media@vger.kernel.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH] media: ov5640: fix get_/set_fmt colorspace related fields
Date: Tue, 6 Mar 2018 18:04:39 +0100
Message-ID: <1520355879-20291-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix set of missing colorspace related fields in get_/set_fmt.
Detected by v4l2-compliance tool.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 drivers/media/i2c/ov5640.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 03940f0..676f635 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -1874,7 +1874,13 @@ static int ov5640_try_fmt_internal(struct v4l2_subdev *sd,
 		if (ov5640_formats[i].code == fmt->code)
 			break;
 	if (i >= ARRAY_SIZE(ov5640_formats))
-		fmt->code = ov5640_formats[0].code;
+		i = 0;
+
+	fmt->code = ov5640_formats[i].code;
+	fmt->colorspace = ov5640_formats[i].colorspace;
+	fmt->ycbcr_enc = V4L2_MAP_YCBCR_ENC_DEFAULT(fmt->colorspace);
+	fmt->quantization = V4L2_QUANTIZATION_FULL_RANGE;
+	fmt->xfer_func = V4L2_MAP_XFER_FUNC_DEFAULT(fmt->colorspace);
 
 	return 0;
 }
@@ -1885,6 +1891,7 @@ static int ov5640_set_fmt(struct v4l2_subdev *sd,
 {
 	struct ov5640_dev *sensor = to_ov5640_dev(sd);
 	const struct ov5640_mode_info *new_mode;
+	struct v4l2_mbus_framefmt *mbus_fmt = &format->format;
 	int ret;
 
 	if (format->pad != 0)
@@ -1897,7 +1904,7 @@ static int ov5640_set_fmt(struct v4l2_subdev *sd,
 		goto out;
 	}
 
-	ret = ov5640_try_fmt_internal(sd, &format->format,
+	ret = ov5640_try_fmt_internal(sd, mbus_fmt,
 				      sensor->current_fr, &new_mode);
 	if (ret)
 		goto out;
@@ -1906,12 +1913,12 @@ static int ov5640_set_fmt(struct v4l2_subdev *sd,
 		struct v4l2_mbus_framefmt *fmt =
 			v4l2_subdev_get_try_format(sd, cfg, 0);
 
-		*fmt = format->format;
+		*fmt = *mbus_fmt;
 		goto out;
 	}
 
 	sensor->current_mode = new_mode;
-	sensor->fmt = format->format;
+	sensor->fmt = *mbus_fmt;
 	sensor->pending_mode_change = true;
 out:
 	mutex_unlock(&sensor->lock);
@@ -2497,16 +2504,22 @@ static int ov5640_probe(struct i2c_client *client,
 	struct fwnode_handle *endpoint;
 	struct ov5640_dev *sensor;
 	int ret;
+	struct v4l2_mbus_framefmt *fmt;
 
 	sensor = devm_kzalloc(dev, sizeof(*sensor), GFP_KERNEL);
 	if (!sensor)
 		return -ENOMEM;
 
 	sensor->i2c_client = client;
-	sensor->fmt.code = MEDIA_BUS_FMT_UYVY8_2X8;
-	sensor->fmt.width = 640;
-	sensor->fmt.height = 480;
-	sensor->fmt.field = V4L2_FIELD_NONE;
+	fmt = &sensor->fmt;
+	fmt->code = ov5640_formats[0].code;
+	fmt->colorspace = ov5640_formats[0].colorspace;
+	fmt->ycbcr_enc = V4L2_MAP_YCBCR_ENC_DEFAULT(fmt->colorspace);
+	fmt->quantization = V4L2_QUANTIZATION_FULL_RANGE;
+	fmt->xfer_func = V4L2_MAP_XFER_FUNC_DEFAULT(fmt->colorspace);
+	fmt->width = 640;
+	fmt->height = 480;
+	fmt->field = V4L2_FIELD_NONE;
 	sensor->frame_interval.numerator = 1;
 	sensor->frame_interval.denominator = ov5640_framerates[OV5640_30_FPS];
 	sensor->current_fr = OV5640_30_FPS;
-- 
1.9.1
