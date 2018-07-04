Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:58623 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752826AbeGDM7I (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Jul 2018 08:59:08 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>
CC: <linux-media@vger.kernel.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH 2/5] media: ov5640: fix auto gain & exposure when changing mode
Date: Wed, 4 Jul 2018 14:58:40 +0200
Message-ID: <1530709123-12445-3-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1530709123-12445-1-git-send-email-hugues.fruchet@st.com>
References: <1530709123-12445-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ensure that auto gain and auto exposure are well restored
when changing mode.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 drivers/media/i2c/ov5640.c | 96 ++++++++++++++++++++++++++--------------------
 1 file changed, 54 insertions(+), 42 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 4b9da8b..7c569de 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -1000,6 +1000,18 @@ static int ov5640_get_gain(struct ov5640_dev *sensor)
 	return gain & 0x3ff;
 }
 
+static int ov5640_set_gain(struct ov5640_dev *sensor, int gain)
+{
+	return ov5640_write_reg16(sensor, OV5640_REG_AEC_PK_REAL_GAIN,
+				  (u16)gain & 0x3ff);
+}
+
+static int ov5640_set_autogain(struct ov5640_dev *sensor, bool on)
+{
+	return ov5640_mod_reg(sensor, OV5640_REG_AEC_PK_MANUAL,
+			      BIT(1), on ? 0 : BIT(1));
+}
+
 static int ov5640_set_stream_dvp(struct ov5640_dev *sensor, bool on)
 {
 	int ret;
@@ -1577,7 +1589,7 @@ static int ov5640_set_mode_exposure_calc(struct ov5640_dev *sensor,
 	}
 
 	/* set capture gain */
-	ret = __v4l2_ctrl_s_ctrl(sensor->ctrls.gain, cap_gain16);
+	ret = ov5640_set_gain(sensor, cap_gain16);
 	if (ret)
 		return ret;
 
@@ -1590,7 +1602,7 @@ static int ov5640_set_mode_exposure_calc(struct ov5640_dev *sensor,
 	}
 
 	/* set exposure */
-	return __v4l2_ctrl_s_ctrl(sensor->ctrls.exposure, cap_shutter);
+	return ov5640_set_exposure(sensor, cap_shutter);
 }
 
 /*
@@ -1598,26 +1610,13 @@ static int ov5640_set_mode_exposure_calc(struct ov5640_dev *sensor,
  * change mode directly
  */
 static int ov5640_set_mode_direct(struct ov5640_dev *sensor,
-				  const struct ov5640_mode_info *mode,
-				  bool auto_exp)
+				  const struct ov5640_mode_info *mode)
 {
-	int ret;
-
 	if (!mode->reg_data)
 		return -EINVAL;
 
 	/* Write capture setting */
-	ret = ov5640_load_regs(sensor, mode);
-	if (ret < 0)
-		return ret;
-
-	/* turn auto gain/exposure back on for direct mode */
-	ret = __v4l2_ctrl_s_ctrl(sensor->ctrls.auto_gain, 1);
-	if (ret)
-		return ret;
-
-	return __v4l2_ctrl_s_ctrl(sensor->ctrls.auto_exp, auto_exp ?
-				  V4L2_EXPOSURE_AUTO : V4L2_EXPOSURE_MANUAL);
+	return ov5640_load_regs(sensor, mode);
 }
 
 static int ov5640_set_mode(struct ov5640_dev *sensor,
@@ -1625,6 +1624,7 @@ static int ov5640_set_mode(struct ov5640_dev *sensor,
 {
 	const struct ov5640_mode_info *mode = sensor->current_mode;
 	enum ov5640_downsize_mode dn_mode, orig_dn_mode;
+	bool auto_gain = sensor->ctrls.auto_gain->val == 1;
 	bool auto_exp =  sensor->ctrls.auto_exp->val == V4L2_EXPOSURE_AUTO;
 	int ret;
 
@@ -1632,19 +1632,23 @@ static int ov5640_set_mode(struct ov5640_dev *sensor,
 	orig_dn_mode = orig_mode->dn_mode;
 
 	/* auto gain and exposure must be turned off when changing modes */
-	ret = __v4l2_ctrl_s_ctrl(sensor->ctrls.auto_gain, 0);
-	if (ret)
-		return ret;
+	if (auto_gain) {
+		ret = ov5640_set_autogain(sensor, false);
+		if (ret)
+			return ret;
+	}
 
-	ret = ov5640_set_autoexposure(sensor, false);
-	if (ret)
-		return ret;
+	if (auto_exp) {
+		ret = ov5640_set_autoexposure(sensor, false);
+		if (ret)
+			goto restore_auto_gain;
+	}
 
 	if ((dn_mode == SUBSAMPLING && orig_dn_mode == SCALING) ||
 	    (dn_mode == SCALING && orig_dn_mode == SUBSAMPLING)) {
 		/*
 		 * change between subsampling and scaling
-		 * go through exposure calucation
+		 * go through exposure calculation
 		 */
 		ret = ov5640_set_mode_exposure_calc(sensor, mode);
 	} else {
@@ -1652,11 +1656,16 @@ static int ov5640_set_mode(struct ov5640_dev *sensor,
 		 * change inside subsampling or scaling
 		 * download firmware directly
 		 */
-		ret = ov5640_set_mode_direct(sensor, mode, auto_exp);
+		ret = ov5640_set_mode_direct(sensor, mode);
 	}
-
 	if (ret < 0)
-		return ret;
+		goto restore_auto_exp_gain;
+
+	/* restore auto gain and exposure */
+	if (auto_gain)
+		ov5640_set_autogain(sensor, true);
+	if (auto_exp)
+		ov5640_set_autoexposure(sensor, true);
 
 	ret = ov5640_set_timings(sensor, mode);
 	if (ret < 0)
@@ -1681,6 +1690,15 @@ static int ov5640_set_mode(struct ov5640_dev *sensor,
 	sensor->pending_mode_change = false;
 
 	return 0;
+
+restore_auto_exp_gain:
+	if (auto_exp)
+		ov5640_set_autoexposure(sensor, true);
+restore_auto_gain:
+	if (auto_gain)
+		ov5640_set_autogain(sensor, true);
+
+	return ret;
 }
 
 static int ov5640_set_framefmt(struct ov5640_dev *sensor,
@@ -2141,20 +2159,20 @@ static int ov5640_set_ctrl_white_balance(struct ov5640_dev *sensor, int awb)
 	return ret;
 }
 
-static int ov5640_set_ctrl_exposure(struct ov5640_dev *sensor, int exp)
+static int ov5640_set_ctrl_exposure(struct ov5640_dev *sensor,
+				    enum v4l2_exposure_auto_type auto_exposure)
 {
 	struct ov5640_ctrls *ctrls = &sensor->ctrls;
-	bool auto_exposure = (exp == V4L2_EXPOSURE_AUTO);
+	bool auto_exp = (auto_exposure == V4L2_EXPOSURE_AUTO);
 	int ret = 0;
 
 	if (ctrls->auto_exp->is_new) {
-		ret = ov5640_mod_reg(sensor, OV5640_REG_AEC_PK_MANUAL,
-				     BIT(0), auto_exposure ? 0 : BIT(0));
+		ret = ov5640_set_autoexposure(sensor, auto_exp);
 		if (ret)
 			return ret;
 	}
 
-	if (!auto_exposure && ctrls->exposure->is_new) {
+	if (!auto_exp && ctrls->exposure->is_new) {
 		u16 max_exp;
 
 		ret = ov5640_read_reg16(sensor, OV5640_REG_AEC_PK_VTS,
@@ -2174,25 +2192,19 @@ static int ov5640_set_ctrl_exposure(struct ov5640_dev *sensor, int exp)
 	return ret;
 }
 
-static int ov5640_set_ctrl_gain(struct ov5640_dev *sensor, int auto_gain)
+static int ov5640_set_ctrl_gain(struct ov5640_dev *sensor, bool auto_gain)
 {
 	struct ov5640_ctrls *ctrls = &sensor->ctrls;
 	int ret = 0;
 
 	if (ctrls->auto_gain->is_new) {
-		ret = ov5640_mod_reg(sensor, OV5640_REG_AEC_PK_MANUAL,
-				     BIT(1),
-				     ctrls->auto_gain->val ? 0 : BIT(1));
+		ret = ov5640_set_autogain(sensor, auto_gain);
 		if (ret)
 			return ret;
 	}
 
-	if (!auto_gain && ctrls->gain->is_new) {
-		u16 gain = (u16)ctrls->gain->val;
-
-		ret = ov5640_write_reg16(sensor, OV5640_REG_AEC_PK_REAL_GAIN,
-					 gain & 0x3ff);
-	}
+	if (!auto_gain && ctrls->gain->is_new)
+		ret = ov5640_set_gain(sensor, ctrls->gain->val);
 
 	return ret;
 }
-- 
1.9.1
