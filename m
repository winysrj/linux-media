Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3468 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933145AbaGQPb3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 11:31:29 -0400
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209])
	(authenticated bits=0)
	by smtp-vbr14.xs4all.nl (8.13.8/8.13.8) with ESMTP id s6HFVPqh092327
	for <linux-media@vger.kernel.org>; Thu, 17 Jul 2014 17:31:27 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id AD6492A1FD1
	for <linux-media@vger.kernel.org>; Thu, 17 Jul 2014 17:31:23 +0200 (CEST)
Message-ID: <53C7EC4B.6050901@xs4all.nl>
Date: Thu, 17 Jul 2014 17:31:23 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH for v3.17] Fix 64-bit division fall-out from 64-bit control
 ranges
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit 0ba2aeb6dab80920edd9cf5b93b1ea4d6913b8f3 increased the internal control ranges
to 64 bit, but that caused problems in drivers that use the minimum/maximum/step/default_value
control values in a division or modulus operations since not all architectures support
those natively.

Luckily, in almost all cases it is possible to just cast to 32 bits (the control value
is known to be 32 bits, so it is safe to cast). Only in v4l2-ctrls.c was it necessary to
use do_div in one function.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/i2c/soc_camera/mt9m001.c b/drivers/media/i2c/soc_camera/mt9m001.c
index df97033..dbd8c14 100644
--- a/drivers/media/i2c/soc_camera/mt9m001.c
+++ b/drivers/media/i2c/soc_camera/mt9m001.c
@@ -403,7 +403,7 @@ static int mt9m001_s_ctrl(struct v4l2_ctrl *ctrl)
 		if (ctrl->val <= ctrl->default_value) {
 			/* Pack it into 0..1 step 0.125, register values 0..8 */
 			unsigned long range = ctrl->default_value - ctrl->minimum;
-			data = ((ctrl->val - ctrl->minimum) * 8 + range / 2) / range;
+			data = ((ctrl->val - (s32)ctrl->minimum) * 8 + range / 2) / range;
 
 			dev_dbg(&client->dev, "Setting gain %d\n", data);
 			data = reg_write(client, MT9M001_GLOBAL_GAIN, data);
@@ -413,7 +413,7 @@ static int mt9m001_s_ctrl(struct v4l2_ctrl *ctrl)
 			/* Pack it into 1.125..15 variable step, register values 9..67 */
 			/* We assume qctrl->maximum - qctrl->default_value - 1 > 0 */
 			unsigned long range = ctrl->maximum - ctrl->default_value - 1;
-			unsigned long gain = ((ctrl->val - ctrl->default_value - 1) *
+			unsigned long gain = ((ctrl->val - (s32)ctrl->default_value - 1) *
 					       111 + range / 2) / range + 9;
 
 			if (gain <= 32)
@@ -434,7 +434,7 @@ static int mt9m001_s_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_EXPOSURE_AUTO:
 		if (ctrl->val == V4L2_EXPOSURE_MANUAL) {
 			unsigned long range = exp->maximum - exp->minimum;
-			unsigned long shutter = ((exp->val - exp->minimum) * 1048 +
+			unsigned long shutter = ((exp->val - (s32)exp->minimum) * 1048 +
 						 range / 2) / range + 1;
 
 			dev_dbg(&client->dev,
diff --git a/drivers/media/i2c/soc_camera/mt9t031.c b/drivers/media/i2c/soc_camera/mt9t031.c
index ee7bb0f..f8358c4 100644
--- a/drivers/media/i2c/soc_camera/mt9t031.c
+++ b/drivers/media/i2c/soc_camera/mt9t031.c
@@ -474,7 +474,7 @@ static int mt9t031_s_ctrl(struct v4l2_ctrl *ctrl)
 		if (ctrl->val <= ctrl->default_value) {
 			/* Pack it into 0..1 step 0.125, register values 0..8 */
 			unsigned long range = ctrl->default_value - ctrl->minimum;
-			data = ((ctrl->val - ctrl->minimum) * 8 + range / 2) / range;
+			data = ((ctrl->val - (s32)ctrl->minimum) * 8 + range / 2) / range;
 
 			dev_dbg(&client->dev, "Setting gain %d\n", data);
 			data = reg_write(client, MT9T031_GLOBAL_GAIN, data);
@@ -485,7 +485,7 @@ static int mt9t031_s_ctrl(struct v4l2_ctrl *ctrl)
 			/* We assume qctrl->maximum - qctrl->default_value - 1 > 0 */
 			unsigned long range = ctrl->maximum - ctrl->default_value - 1;
 			/* calculated gain: map 65..127 to 9..1024 step 0.125 */
-			unsigned long gain = ((ctrl->val - ctrl->default_value - 1) *
+			unsigned long gain = ((ctrl->val - (s32)ctrl->default_value - 1) *
 					       1015 + range / 2) / range + 9;
 
 			if (gain <= 32)		/* calculated gain 9..32 -> 9..32 */
@@ -507,7 +507,7 @@ static int mt9t031_s_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_EXPOSURE_AUTO:
 		if (ctrl->val == V4L2_EXPOSURE_MANUAL) {
 			unsigned int range = exp->maximum - exp->minimum;
-			unsigned int shutter = ((exp->val - exp->minimum) * 1048 +
+			unsigned int shutter = ((exp->val - (s32)exp->minimum) * 1048 +
 						 range / 2) / range + 1;
 			u32 old;
 
diff --git a/drivers/media/i2c/soc_camera/mt9v022.c b/drivers/media/i2c/soc_camera/mt9v022.c
index f9f95f8..99022c8 100644
--- a/drivers/media/i2c/soc_camera/mt9v022.c
+++ b/drivers/media/i2c/soc_camera/mt9v022.c
@@ -583,7 +583,7 @@ static int mt9v022_s_ctrl(struct v4l2_ctrl *ctrl)
 			/* mt9v022 has minimum == default */
 			unsigned long range = gain->maximum - gain->minimum;
 			/* Valid values 16 to 64, 32 to 64 must be even. */
-			unsigned long gain_val = ((gain->val - gain->minimum) *
+			unsigned long gain_val = ((gain->val - (s32)gain->minimum) *
 					      48 + range / 2) / range + 16;
 
 			if (gain_val >= 32)
@@ -608,7 +608,7 @@ static int mt9v022_s_ctrl(struct v4l2_ctrl *ctrl)
 		} else {
 			struct v4l2_ctrl *exp = mt9v022->exposure;
 			unsigned long range = exp->maximum - exp->minimum;
-			unsigned long shutter = ((exp->val - exp->minimum) *
+			unsigned long shutter = ((exp->val - (s32)exp->minimum) *
 					479 + range / 2) / range + 1;
 
 			/*
diff --git a/drivers/media/radio/radio-keene.c b/drivers/media/radio/radio-keene.c
index 67ac72e..0c5d2db 100644
--- a/drivers/media/radio/radio-keene.c
+++ b/drivers/media/radio/radio-keene.c
@@ -265,7 +265,7 @@ static int keene_s_ctrl(struct v4l2_ctrl *ctrl)
 		return keene_cmd_set(radio);
 
 	case V4L2_CID_AUDIO_COMPRESSION_GAIN:
-		radio->tx = db2tx[(ctrl->val - ctrl->minimum) / ctrl->step];
+		radio->tx = db2tx[(ctrl->val - (s32)ctrl->minimum) / (s32)ctrl->step];
 		return keene_cmd_set(radio);
 	}
 	return -EINVAL;
diff --git a/drivers/media/usb/gspca/autogain_functions.c b/drivers/media/usb/gspca/autogain_functions.c
index 67db674..0e9ee8b 100644
--- a/drivers/media/usb/gspca/autogain_functions.c
+++ b/drivers/media/usb/gspca/autogain_functions.c
@@ -121,9 +121,9 @@ int gspca_coarse_grained_expo_autogain(
 	orig_gain = gain = v4l2_ctrl_g_ctrl(gspca_dev->gain);
 	orig_exposure = exposure = v4l2_ctrl_g_ctrl(gspca_dev->exposure);
 
-	gain_low  = (gspca_dev->gain->maximum - gspca_dev->gain->minimum) /
+	gain_low  = (s32)(gspca_dev->gain->maximum - gspca_dev->gain->minimum) /
 		    5 * 2 + gspca_dev->gain->minimum;
-	gain_high = (gspca_dev->gain->maximum - gspca_dev->gain->minimum) /
+	gain_high = (s32)(gspca_dev->gain->maximum - gspca_dev->gain->minimum) /
 		    5 * 4 + gspca_dev->gain->minimum;
 
 	/* If we are of a multiple of deadzone, do multiple steps to reach the
diff --git a/drivers/media/usb/gspca/pac7302.c b/drivers/media/usb/gspca/pac7302.c
index 2fd1c5e..a7b7a99 100644
--- a/drivers/media/usb/gspca/pac7302.c
+++ b/drivers/media/usb/gspca/pac7302.c
@@ -394,9 +394,9 @@ static void setbrightcont(struct gspca_dev *gspca_dev)
 	reg_w(gspca_dev, 0xff, 0x00);		/* page 0 */
 	for (i = 0; i < 10; i++) {
 		v = max[i];
-		v += (sd->brightness->val - sd->brightness->maximum)
-			* 150 / sd->brightness->maximum; /* 200 ? */
-		v -= delta[i] * sd->contrast->val / sd->contrast->maximum;
+		v += (sd->brightness->val - (s32)sd->brightness->maximum)
+			* 150 / (s32)sd->brightness->maximum; /* 200 ? */
+		v -= delta[i] * sd->contrast->val / (s32)sd->contrast->maximum;
 		if (v < 0)
 			v = 0;
 		else if (v > 0xff)
@@ -419,7 +419,7 @@ static void setcolors(struct gspca_dev *gspca_dev)
 	reg_w(gspca_dev, 0x11, 0x01);
 	reg_w(gspca_dev, 0xff, 0x00);			/* page 0 */
 	for (i = 0; i < 9; i++) {
-		v = a[i] * sd->saturation->val / sd->saturation->maximum;
+		v = a[i] * sd->saturation->val / (s32)sd->saturation->maximum;
 		v += b[i];
 		reg_w(gspca_dev, 0x0f + 2 * i, (v >> 8) & 0x07);
 		reg_w(gspca_dev, 0x0f + 2 * i + 1, v);
diff --git a/drivers/media/usb/gspca/sonixb.c b/drivers/media/usb/gspca/sonixb.c
index ecbcb39..6696b2e 100644
--- a/drivers/media/usb/gspca/sonixb.c
+++ b/drivers/media/usb/gspca/sonixb.c
@@ -913,7 +913,7 @@ static void do_autogain(struct gspca_dev *gspca_dev)
 				desired_avg_lum, deadzone))
 			sd->autogain_ignore_frames = AUTOGAIN_IGNORE_FRAMES;
 	} else {
-		int gain_knee = gspca_dev->gain->maximum * 9 / 10;
+		int gain_knee = (s32)gspca_dev->gain->maximum * 9 / 10;
 		if (gspca_expo_autogain(gspca_dev, avg_lum, desired_avg_lum,
 				deadzone, gain_knee, sd->exposure_knee))
 			sd->autogain_ignore_frames = AUTOGAIN_IGNORE_FRAMES;
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 5c3b8de..8552c83 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1303,7 +1303,7 @@ static void std_log(const struct v4l2_ctrl *ctrl)
 	val = clamp_t(typeof(val), val,				\
 		      (ctrl)->minimum, (ctrl)->maximum);	\
 	offset = (val) - (ctrl)->minimum;			\
-	offset = (ctrl)->step * (offset / (ctrl)->step);	\
+	offset = (ctrl)->step * (offset / (s32)(ctrl)->step);	\
 	val = (ctrl)->minimum + offset;				\
 	0;							\
 })
@@ -1313,12 +1313,24 @@ static int std_validate(const struct v4l2_ctrl *ctrl, u32 idx,
 			union v4l2_ctrl_ptr ptr)
 {
 	size_t len;
+	u64 offset;
+	s64 val;
 
 	switch (ctrl->type) {
 	case V4L2_CTRL_TYPE_INTEGER:
 		return ROUND_TO_RANGE(ptr.p_s32[idx], u32, ctrl);
 	case V4L2_CTRL_TYPE_INTEGER64:
-		return ROUND_TO_RANGE(ptr.p_s64[idx], u64, ctrl);
+		/*
+		 * We can't use the ROUND_TO_RANGE define here due to
+		 * the u64 divide that needs special care.
+		 */
+		val = ptr.p_s64[idx];
+		val += ctrl->step / 2;
+		val = clamp_t(s64, val, ctrl->minimum, ctrl->maximum);
+		offset = val - ctrl->minimum;
+		do_div(offset, ctrl->step);
+		ptr.p_s64[idx] = ctrl->minimum + offset * ctrl->step;
+		return 0;
 	case V4L2_CTRL_TYPE_U8:
 		return ROUND_TO_RANGE(ptr.p_u8[idx], u8, ctrl);
 	case V4L2_CTRL_TYPE_U16:
@@ -1353,7 +1365,7 @@ static int std_validate(const struct v4l2_ctrl *ctrl, u32 idx,
 		len = strlen(ptr.p_char + idx);
 		if (len < ctrl->minimum)
 			return -ERANGE;
-		if ((len - ctrl->minimum) % ctrl->step)
+		if ((len - (u32)ctrl->minimum) % (u32)ctrl->step)
 			return -ERANGE;
 		return 0;
 
