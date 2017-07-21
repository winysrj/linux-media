Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:30491 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753564AbdGUPwL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Jul 2017 11:52:11 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Hans Verkuil" <hverkuil@xs4all.nl>
CC: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        "Hugues Fruchet" <hugues.fruchet@st.com>
Subject: [PATCH v1 1/2] [media] ov9650: fix coding style
Date: Fri, 21 Jul 2017 17:49:40 +0200
Message-ID: <1500652181-971-2-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1500652181-971-1-git-send-email-hugues.fruchet@st.com>
References: <1500652181-971-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix a bunch of coding style issues detected
by checkpatch --strict.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 drivers/media/i2c/ov9650.c | 59 ++++++++++++++++++++++++++--------------------
 1 file changed, 33 insertions(+), 26 deletions(-)

diff --git a/drivers/media/i2c/ov9650.c b/drivers/media/i2c/ov9650.c
index 2de2fbb..e8dea28 100644
--- a/drivers/media/i2c/ov9650.c
+++ b/drivers/media/i2c/ov9650.c
@@ -484,6 +484,7 @@ static int ov965x_set_default_gamma_curve(struct ov965x *ov965x)
 
 	for (i = 0; i < ARRAY_SIZE(gamma_curve); i++) {
 		int ret = ov965x_write(ov965x->client, addr, gamma_curve[i]);
+
 		if (ret < 0)
 			return ret;
 		addr++;
@@ -503,6 +504,7 @@ static int ov965x_set_color_matrix(struct ov965x *ov965x)
 
 	for (i = 0; i < ARRAY_SIZE(mtx); i++) {
 		int ret = ov965x_write(ov965x->client, addr, mtx[i]);
+
 		if (ret < 0)
 			return ret;
 		addr++;
@@ -611,7 +613,7 @@ static int ov965x_set_banding_filter(struct ov965x *ov965x, int value)
 	}
 	if (value == V4L2_CID_POWER_LINE_FREQUENCY_DISABLED)
 		return 0;
-	if (WARN_ON(ov965x->fiv == NULL))
+	if (WARN_ON(!ov965x->fiv))
 		return -EINVAL;
 	/* Set minimal exposure time for 50/60 HZ lighting */
 	if (value == V4L2_CID_POWER_LINE_FREQUENCY_50HZ)
@@ -999,44 +1001,47 @@ static int ov965x_initialize_controls(struct ov965x *ov965x)
 
 	/* Auto/manual white balance */
 	ctrls->auto_wb = v4l2_ctrl_new_std(hdl, ops,
-				V4L2_CID_AUTO_WHITE_BALANCE,
-				0, 1, 1, 1);
+					   V4L2_CID_AUTO_WHITE_BALANCE,
+					   0, 1, 1, 1);
 	ctrls->blue_balance = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_BLUE_BALANCE,
 						0, 0xff, 1, 0x80);
 	ctrls->red_balance = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_RED_BALANCE,
-						0, 0xff, 1, 0x80);
+					       0, 0xff, 1, 0x80);
 	/* Auto/manual exposure */
-	ctrls->auto_exp = v4l2_ctrl_new_std_menu(hdl, ops,
-				V4L2_CID_EXPOSURE_AUTO,
-				V4L2_EXPOSURE_MANUAL, 0, V4L2_EXPOSURE_AUTO);
+	ctrls->auto_exp =
+		v4l2_ctrl_new_std_menu(hdl, ops,
+				       V4L2_CID_EXPOSURE_AUTO,
+				       V4L2_EXPOSURE_MANUAL, 0,
+				       V4L2_EXPOSURE_AUTO);
 	/* Exposure time, in 100 us units. min/max is updated dynamically. */
 	ctrls->exposure = v4l2_ctrl_new_std(hdl, ops,
-				V4L2_CID_EXPOSURE_ABSOLUTE,
-				2, 1500, 1, 500);
+					    V4L2_CID_EXPOSURE_ABSOLUTE,
+					    2, 1500, 1, 500);
 	/* Auto/manual gain */
 	ctrls->auto_gain = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_AUTOGAIN,
-						0, 1, 1, 1);
+					     0, 1, 1, 1);
 	ctrls->gain = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_GAIN,
-						16, 64 * (16 + 15), 1, 64 * 16);
+					16, 64 * (16 + 15), 1, 64 * 16);
 
 	ctrls->saturation = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_SATURATION,
-						-2, 2, 1, 0);
+					      -2, 2, 1, 0);
 	ctrls->brightness = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_BRIGHTNESS,
-						-3, 3, 1, 0);
+					      -3, 3, 1, 0);
 	ctrls->sharpness = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_SHARPNESS,
-						0, 32, 1, 6);
+					     0, 32, 1, 6);
 
 	ctrls->hflip = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_HFLIP, 0, 1, 1, 0);
 	ctrls->vflip = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_VFLIP, 0, 1, 1, 0);
 
-	ctrls->light_freq = v4l2_ctrl_new_std_menu(hdl, ops,
-				V4L2_CID_POWER_LINE_FREQUENCY,
-				V4L2_CID_POWER_LINE_FREQUENCY_60HZ, ~0x7,
-				V4L2_CID_POWER_LINE_FREQUENCY_50HZ);
+	ctrls->light_freq =
+		v4l2_ctrl_new_std_menu(hdl, ops,
+				       V4L2_CID_POWER_LINE_FREQUENCY,
+				       V4L2_CID_POWER_LINE_FREQUENCY_60HZ, ~0x7,
+				       V4L2_CID_POWER_LINE_FREQUENCY_50HZ);
 
 	v4l2_ctrl_new_std_menu_items(hdl, ops, V4L2_CID_TEST_PATTERN,
-				ARRAY_SIZE(test_pattern_menu) - 1, 0, 0,
-				test_pattern_menu);
+				     ARRAY_SIZE(test_pattern_menu) - 1, 0, 0,
+				     test_pattern_menu);
 	if (hdl->error) {
 		ret = hdl->error;
 		v4l2_ctrl_handler_free(hdl);
@@ -1121,7 +1126,6 @@ static int __ov965x_set_frame_interval(struct ov965x *ov965x,
 	u64 req_int, err, min_err = ~0ULL;
 	unsigned int i;
 
-
 	if (fi->interval.denominator == 0)
 		return -EINVAL;
 
@@ -1165,7 +1169,8 @@ static int ov965x_s_frame_interval(struct v4l2_subdev *sd,
 	return ret;
 }
 
-static int ov965x_get_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
+static int ov965x_get_fmt(struct v4l2_subdev *sd,
+			  struct v4l2_subdev_pad_config *cfg,
 			  struct v4l2_subdev_format *fmt)
 {
 	struct ov965x *ov965x = to_ov965x(sd);
@@ -1209,7 +1214,8 @@ static void __ov965x_try_frame_size(struct v4l2_mbus_framefmt *mf,
 		*size = match;
 }
 
-static int ov965x_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
+static int ov965x_set_fmt(struct v4l2_subdev *sd,
+			  struct v4l2_subdev_pad_config *cfg,
 			  struct v4l2_subdev_format *fmt)
 {
 	unsigned int index = ARRAY_SIZE(ov965x_formats);
@@ -1231,7 +1237,7 @@ static int ov965x_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config
 	mutex_lock(&ov965x->lock);
 
 	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
-		if (cfg != NULL) {
+		if (cfg) {
 			mf = v4l2_subdev_get_try_format(sd, cfg, fmt->pad);
 			*mf = fmt->format;
 		}
@@ -1362,7 +1368,8 @@ static int ov965x_s_stream(struct v4l2_subdev *sd, int on)
  */
 static int ov965x_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 {
-	struct v4l2_mbus_framefmt *mf = v4l2_subdev_get_try_format(sd, fh->pad, 0);
+	struct v4l2_mbus_framefmt *mf =
+		v4l2_subdev_get_try_format(sd, fh->pad, 0);
 
 	ov965x_get_default_format(mf);
 	return 0;
@@ -1470,7 +1477,7 @@ static int ov965x_probe(struct i2c_client *client,
 	struct ov965x *ov965x;
 	int ret;
 
-	if (pdata == NULL) {
+	if (!pdata) {
 		dev_err(&client->dev, "platform data not specified\n");
 		return -EINVAL;
 	}
-- 
1.9.1
