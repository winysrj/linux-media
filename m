Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:31655 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728226AbeHMMEC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Aug 2018 08:04:02 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>
CC: <linux-media@vger.kernel.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Jacopo Mondi <jacopo@jmondi.org>
Subject: [PATCH v2] media: ov5640: do not change mode if format or frame interval is unchanged
Date: Mon, 13 Aug 2018 11:21:51 +0200
Message-ID: <1534152111-16837-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Save load of mode registers array when V4L2 client sets a format or a
frame interval which selects the same mode than the current one.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
Version 2:
  - Fix fuzzy image because of JPEG default format not being
    changed according to new format selected, fix this.
  - Init sequence initialises format to YUV422 UYVY but
    sensor->fmt initial value was set to JPEG, fix this.


 drivers/media/i2c/ov5640.c | 33 ++++++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 1ecbb7a..2ddd86d 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -223,6 +223,7 @@ struct ov5640_dev {
 	int power_count;
 
 	struct v4l2_mbus_framefmt fmt;
+	bool pending_fmt_change;
 
 	const struct ov5640_mode_info *current_mode;
 	enum ov5640_frame_rate current_fr;
@@ -255,7 +256,7 @@ static inline struct v4l2_subdev *ctrl_to_sd(struct v4l2_ctrl *ctrl)
  * should be identified and removed to speed register load time
  * over i2c.
  */
-
+/* YUV422 UYVY VGA@30fps */
 static const struct reg_value ov5640_init_setting_30fps_VGA[] = {
 	{0x3103, 0x11, 0, 0}, {0x3008, 0x82, 0, 5}, {0x3008, 0x42, 0, 0},
 	{0x3103, 0x03, 0, 0}, {0x3017, 0x00, 0, 0}, {0x3018, 0x00, 0, 0},
@@ -1966,9 +1967,14 @@ static int ov5640_set_fmt(struct v4l2_subdev *sd,
 		goto out;
 	}
 
-	sensor->current_mode = new_mode;
-	sensor->fmt = *mbus_fmt;
-	sensor->pending_mode_change = true;
+	if (new_mode != sensor->current_mode) {
+		sensor->current_mode = new_mode;
+		sensor->pending_mode_change = true;
+	}
+	if (mbus_fmt->code != sensor->fmt.code) {
+		sensor->fmt = *mbus_fmt;
+		sensor->pending_fmt_change = true;
+	}
 out:
 	mutex_unlock(&sensor->lock);
 	return ret;
@@ -2508,8 +2514,10 @@ static int ov5640_s_frame_interval(struct v4l2_subdev *sd,
 		goto out;
 	}
 
-	sensor->current_mode = mode;
-	sensor->pending_mode_change = true;
+	if (mode != sensor->current_mode) {
+		sensor->current_mode = mode;
+		sensor->pending_mode_change = true;
+	}
 out:
 	mutex_unlock(&sensor->lock);
 	return ret;
@@ -2540,10 +2548,13 @@ static int ov5640_s_stream(struct v4l2_subdev *sd, int enable)
 			ret = ov5640_set_mode(sensor, sensor->current_mode);
 			if (ret)
 				goto out;
+		}
 
+		if (enable && sensor->pending_fmt_change) {
 			ret = ov5640_set_framefmt(sensor, &sensor->fmt);
 			if (ret)
 				goto out;
+			sensor->pending_fmt_change = false;
 		}
 
 		if (sensor->ep.bus_type == V4L2_MBUS_CSI2)
@@ -2638,9 +2649,14 @@ static int ov5640_probe(struct i2c_client *client,
 		return -ENOMEM;
 
 	sensor->i2c_client = client;
+
+	/*
+	 * default init sequence initialize sensor to
+	 * YUV422 UYVY VGA@30fps
+	 */
 	fmt = &sensor->fmt;
-	fmt->code = ov5640_formats[0].code;
-	fmt->colorspace = ov5640_formats[0].colorspace;
+	fmt->code = MEDIA_BUS_FMT_UYVY8_2X8;
+	fmt->colorspace = V4L2_COLORSPACE_SRGB;
 	fmt->ycbcr_enc = V4L2_MAP_YCBCR_ENC_DEFAULT(fmt->colorspace);
 	fmt->quantization = V4L2_QUANTIZATION_FULL_RANGE;
 	fmt->xfer_func = V4L2_MAP_XFER_FUNC_DEFAULT(fmt->colorspace);
@@ -2652,7 +2668,6 @@ static int ov5640_probe(struct i2c_client *client,
 	sensor->current_fr = OV5640_30_FPS;
 	sensor->current_mode =
 		&ov5640_mode_data[OV5640_30_FPS][OV5640_MODE_VGA_640_480];
-	sensor->pending_mode_change = true;
 
 	sensor->ae_target = 52;
 
-- 
2.7.4
