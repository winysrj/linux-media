Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:18635 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727833AbeIKSsM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Sep 2018 14:48:12 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Jacopo Mondi <jacopo@jmondi.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
CC: <linux-media@vger.kernel.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v3 5/5] media: ov5640: fix restore of last mode set
Date: Tue, 11 Sep 2018 15:48:21 +0200
Message-ID: <1536673701-32165-6-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1536673701-32165-1-git-send-email-hugues.fruchet@st.com>
References: <1536673701-32165-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mode setting depends on last mode set, in particular
because of exposure calculation when downscale mode
change between subsampling and scaling.
At stream on the last mode was wrongly set to current mode,
so no change was detected and exposure calculation
was not made, fix this.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 drivers/media/i2c/ov5640.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index c110a6a..427c2e7 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -225,6 +225,7 @@ struct ov5640_dev {
 	struct v4l2_mbus_framefmt fmt;
 
 	const struct ov5640_mode_info *current_mode;
+	const struct ov5640_mode_info *last_mode;
 	enum ov5640_frame_rate current_fr;
 	struct v4l2_fract frame_interval;
 
@@ -1619,10 +1620,10 @@ static int ov5640_set_mode_direct(struct ov5640_dev *sensor,
 	return ov5640_load_regs(sensor, mode);
 }
 
-static int ov5640_set_mode(struct ov5640_dev *sensor,
-			   const struct ov5640_mode_info *orig_mode)
+static int ov5640_set_mode(struct ov5640_dev *sensor)
 {
 	const struct ov5640_mode_info *mode = sensor->current_mode;
+	const struct ov5640_mode_info *orig_mode = sensor->last_mode;
 	enum ov5640_downsize_mode dn_mode, orig_dn_mode;
 	bool auto_gain = sensor->ctrls.auto_gain->val == 1;
 	bool auto_exp =  sensor->ctrls.auto_exp->val == V4L2_EXPOSURE_AUTO;
@@ -1688,6 +1689,7 @@ static int ov5640_set_mode(struct ov5640_dev *sensor,
 		return ret;
 
 	sensor->pending_mode_change = false;
+	sensor->last_mode = mode;
 
 	return 0;
 
@@ -1713,6 +1715,7 @@ static int ov5640_restore_mode(struct ov5640_dev *sensor)
 	ret = ov5640_load_regs(sensor, &ov5640_mode_init_data);
 	if (ret < 0)
 		return ret;
+	sensor->last_mode = &ov5640_mode_init_data;
 
 	ret = ov5640_mod_reg(sensor, OV5640_REG_SYS_ROOT_DIVIDER, 0x3f,
 			     (ilog2(OV5640_SCLK2X_ROOT_DIVIDER_DEFAULT) << 2) |
@@ -1721,7 +1724,7 @@ static int ov5640_restore_mode(struct ov5640_dev *sensor)
 		return ret;
 
 	/* now restore the last capture mode */
-	ret = ov5640_set_mode(sensor, &ov5640_mode_init_data);
+	ret = ov5640_set_mode(sensor);
 	if (ret < 0)
 		return ret;
 
@@ -2551,7 +2554,7 @@ static int ov5640_s_stream(struct v4l2_subdev *sd, int enable)
 
 	if (sensor->streaming == !enable) {
 		if (enable && sensor->pending_mode_change) {
-			ret = ov5640_set_mode(sensor, sensor->current_mode);
+			ret = ov5640_set_mode(sensor);
 			if (ret)
 				goto out;
 
@@ -2667,6 +2670,7 @@ static int ov5640_probe(struct i2c_client *client,
 	sensor->current_mode =
 		&ov5640_mode_data[OV5640_30_FPS][OV5640_MODE_VGA_640_480];
 	sensor->pending_mode_change = true;
+	sensor->last_mode = sensor->current_mode;
 
 	sensor->ae_target = 52;
 
-- 
2.7.4
