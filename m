Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:33561 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753651AbdBHLMu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 8 Feb 2017 06:12:50 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mats Randgaard <matrandg@cisco.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 2/2] [media] tc358743: extend colorimetry support
Date: Wed,  8 Feb 2017 11:53:38 +0100
Message-Id: <20170208105338.4100-2-p.zabel@pengutronix.de>
In-Reply-To: <20170208105338.4100-1-p.zabel@pengutronix.de>
References: <20170208105338.4100-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The video output format can freely be chosen to be 24-bit SRGB or 16-bit
YUV 4:2:2 in either SMPTE170M or REC709 color space. In all three modes
the output can be full or limited range.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/i2c/tc358743.c | 118 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 114 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index 64a97bbbd00a8..817741e20cc16 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -96,6 +96,7 @@ struct tc358743_state {
 
 	struct v4l2_dv_timings timings;
 	u32 mbus_fmt_code;
+	u8 vout_color_sel;
 	u8 csi_lanes_in_use;
 
 	struct gpio_desc *reset_gpio;
@@ -620,6 +621,7 @@ static void tc358743_set_ref_clk(struct v4l2_subdev *sd)
 static void tc358743_set_csi_color_space(struct v4l2_subdev *sd)
 {
 	struct tc358743_state *state = to_state(sd);
+	u8 vout_color_sel = state->vout_color_sel;
 
 	switch (state->mbus_fmt_code) {
 	case MEDIA_BUS_FMT_UYVY8_1X16:
@@ -627,8 +629,17 @@ static void tc358743_set_csi_color_space(struct v4l2_subdev *sd)
 		i2c_wr8_and_or(sd, VOUT_SET2,
 				~(MASK_SEL422 | MASK_VOUT_422FIL_100) & 0xff,
 				MASK_SEL422 | MASK_VOUT_422FIL_100);
+		switch (vout_color_sel) {
+		case MASK_VOUT_COLOR_601_YCBCR_FULL:
+		case MASK_VOUT_COLOR_709_YCBCR_FULL:
+		case MASK_VOUT_COLOR_709_YCBCR_LIMITED:
+			break;
+		default:
+			vout_color_sel = MASK_VOUT_COLOR_601_YCBCR_LIMITED;
+			break;
+		}
 		i2c_wr8_and_or(sd, VI_REP, ~MASK_VOUT_COLOR_SEL & 0xff,
-				MASK_VOUT_COLOR_601_YCBCR_LIMITED);
+				vout_color_sel);
 		mutex_lock(&state->confctl_mutex);
 		i2c_wr16_and_or(sd, CONFCTL, ~MASK_YCBCRFMT,
 				MASK_YCBCRFMT_422_8_BIT);
@@ -639,8 +650,10 @@ static void tc358743_set_csi_color_space(struct v4l2_subdev *sd)
 		i2c_wr8_and_or(sd, VOUT_SET2,
 				~(MASK_SEL422 | MASK_VOUT_422FIL_100) & 0xff,
 				0x00);
+		if (vout_color_sel != MASK_VOUT_COLOR_RGB_LIMITED)
+			vout_color_sel = MASK_VOUT_COLOR_RGB_FULL;
 		i2c_wr8_and_or(sd, VI_REP, ~MASK_VOUT_COLOR_SEL & 0xff,
-				MASK_VOUT_COLOR_RGB_FULL);
+				vout_color_sel);
 		mutex_lock(&state->confctl_mutex);
 		i2c_wr16_and_or(sd, CONFCTL, ~MASK_YCBCRFMT, 0);
 		mutex_unlock(&state->confctl_mutex);
@@ -1096,11 +1109,17 @@ static int tc358743_log_status(struct v4l2_subdev *sd)
 	uint8_t hdmi_sys_status =  i2c_rd8(sd, SYS_STATUS);
 	uint16_t sysctl = i2c_rd16(sd, SYSCTL);
 	u8 vi_status3 =  i2c_rd8(sd, VI_STATUS3);
+	u8 vi_rep = i2c_rd8(sd, VI_REP);
 	const int deep_color_mode[4] = { 8, 10, 12, 16 };
 	static const char * const input_color_space[] = {
 		"RGB", "YCbCr 601", "Adobe RGB", "YCbCr 709", "NA (4)",
 		"xvYCC 601", "NA(6)", "xvYCC 709", "NA(8)", "sYCC601",
 		"NA(10)", "NA(11)", "NA(12)", "Adobe YCC 601"};
+	static const char * const output_color_space[8] = {
+		"full range (0-255)", "limited range (16-235)",
+		"Bt.601 (0-255)", "Bt.601 (16-235)",
+		"Bt.709 (0-255)", "Bt.709 (16-235)",
+		"full to limited range", "limited to full range"};
 
 	v4l2_info(sd, "-----Chip status-----\n");
 	v4l2_info(sd, "Chip ID: 0x%02x\n",
@@ -1159,11 +1178,12 @@ static int tc358743_log_status(struct v4l2_subdev *sd)
 	v4l2_info(sd, "Stopped: %s\n",
 			(i2c_rd16(sd, CSI_STATUS) & MASK_S_HLT) ?
 			"yes" : "no");
-	v4l2_info(sd, "Color space: %s\n",
+	v4l2_info(sd, "Color space: %s %s\n",
 			state->mbus_fmt_code == MEDIA_BUS_FMT_UYVY8_1X16 ?
 			"YCbCr 422 16-bit" :
 			state->mbus_fmt_code == MEDIA_BUS_FMT_RGB888_1X24 ?
-			"RGB 888 24-bit" : "Unsupported");
+			"RGB 888 24-bit" : "Unsupported",
+			output_color_space[(vi_rep & MASK_VOUT_COLOR_SEL) >> 5]);
 
 	v4l2_info(sd, "-----%s status-----\n", is_hdmi(sd) ? "HDMI" : "DVI-D");
 	v4l2_info(sd, "HDCP encrypted content: %s\n",
@@ -1486,16 +1506,40 @@ static int tc358743_get_fmt(struct v4l2_subdev *sd,
 
 	switch (vi_rep & MASK_VOUT_COLOR_SEL) {
 	case MASK_VOUT_COLOR_RGB_FULL:
+		format->format.colorspace = V4L2_COLORSPACE_SRGB;
+		format->format.xfer_func = V4L2_XFER_FUNC_SRGB;
+		format->format.ycbcr_enc = V4L2_YCBCR_ENC_601;
+		format->format.quantization = V4L2_QUANTIZATION_FULL_RANGE;
+		break;
 	case MASK_VOUT_COLOR_RGB_LIMITED:
 		format->format.colorspace = V4L2_COLORSPACE_SRGB;
+		format->format.xfer_func = V4L2_XFER_FUNC_SRGB;
+		format->format.ycbcr_enc = V4L2_YCBCR_ENC_601;
+		format->format.quantization = V4L2_QUANTIZATION_LIM_RANGE;
 		break;
 	case MASK_VOUT_COLOR_601_YCBCR_LIMITED:
+		format->format.colorspace = V4L2_COLORSPACE_SMPTE170M;
+		format->format.xfer_func = V4L2_XFER_FUNC_709;
+		format->format.ycbcr_enc = V4L2_YCBCR_ENC_601;
+		format->format.quantization = V4L2_QUANTIZATION_LIM_RANGE;
+		break;
 	case MASK_VOUT_COLOR_601_YCBCR_FULL:
 		format->format.colorspace = V4L2_COLORSPACE_SMPTE170M;
+		format->format.xfer_func = V4L2_XFER_FUNC_709;
+		format->format.ycbcr_enc = V4L2_YCBCR_ENC_XV601;
+		format->format.quantization = V4L2_QUANTIZATION_FULL_RANGE;
 		break;
 	case MASK_VOUT_COLOR_709_YCBCR_FULL:
+		format->format.colorspace = V4L2_COLORSPACE_REC709;
+		format->format.xfer_func = V4L2_XFER_FUNC_709;
+		format->format.ycbcr_enc = V4L2_YCBCR_ENC_XV709;
+		format->format.quantization = V4L2_QUANTIZATION_FULL_RANGE;
+		break;
 	case MASK_VOUT_COLOR_709_YCBCR_LIMITED:
 		format->format.colorspace = V4L2_COLORSPACE_REC709;
+		format->format.xfer_func = V4L2_XFER_FUNC_709;
+		format->format.ycbcr_enc = V4L2_YCBCR_ENC_709;
+		format->format.quantization = V4L2_QUANTIZATION_LIM_RANGE;
 		break;
 	default:
 		format->format.colorspace = 0;
@@ -1512,7 +1556,11 @@ static int tc358743_set_fmt(struct v4l2_subdev *sd,
 	struct tc358743_state *state = to_state(sd);
 
 	u32 code = format->format.code; /* is overwritten by get_fmt */
+	enum v4l2_colorspace colorspace = format->format.colorspace;
+	enum v4l2_ycbcr_encoding ycbcr_enc = format->format.ycbcr_enc;
+	enum v4l2_quantization quantization = format->format.quantization;
 	int ret = tc358743_get_fmt(sd, cfg, format);
+	u8 vout_color_sel;
 
 	format->format.code = code;
 
@@ -1521,16 +1569,78 @@ static int tc358743_set_fmt(struct v4l2_subdev *sd,
 
 	switch (code) {
 	case MEDIA_BUS_FMT_RGB888_1X24:
+		colorspace = V4L2_COLORSPACE_SRGB;
+		break;
 	case MEDIA_BUS_FMT_UYVY8_1X16:
+		switch (colorspace) {
+		case V4L2_COLORSPACE_SMPTE170M:
+		case V4L2_COLORSPACE_REC709:
+			break;
+		default:
+			if (format->format.colorspace != V4L2_COLORSPACE_SRGB)
+				colorspace = format->format.colorspace;
+			else
+				colorspace = V4L2_COLORSPACE_SMPTE170M;
+			break;
+		}
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	format->format.colorspace = colorspace;
+
+	if (ycbcr_enc == V4L2_YCBCR_ENC_DEFAULT)
+		ycbcr_enc = V4L2_MAP_YCBCR_ENC_DEFAULT(colorspace);
+	if (quantization == V4L2_QUANTIZATION_DEFAULT)
+		quantization = V4L2_MAP_QUANTIZATION_DEFAULT(false, colorspace,
+							     ycbcr_enc);
+
+	switch (colorspace) {
+	case V4L2_COLORSPACE_SRGB:
+		format->format.xfer_func = V4L2_XFER_FUNC_SRGB;
+		ycbcr_enc = V4L2_YCBCR_ENC_601;
+		if (quantization == V4L2_QUANTIZATION_LIM_RANGE) {
+			vout_color_sel = MASK_VOUT_COLOR_RGB_LIMITED;
+		} else {
+			quantization = V4L2_QUANTIZATION_FULL_RANGE;
+			vout_color_sel = MASK_VOUT_COLOR_RGB_FULL;
+		}
+		break;
+	case V4L2_COLORSPACE_SMPTE170M:
+		format->format.xfer_func = V4L2_XFER_FUNC_709;
+		if (quantization == V4L2_QUANTIZATION_FULL_RANGE) {
+			ycbcr_enc = V4L2_YCBCR_ENC_XV601;
+			vout_color_sel = MASK_VOUT_COLOR_601_YCBCR_FULL;
+		} else {
+			ycbcr_enc = V4L2_YCBCR_ENC_601;
+			quantization = V4L2_QUANTIZATION_LIM_RANGE;
+			vout_color_sel = MASK_VOUT_COLOR_601_YCBCR_LIMITED;
+		}
+		break;
+	case V4L2_COLORSPACE_REC709:
+		format->format.xfer_func = V4L2_XFER_FUNC_709;
+		if (quantization == V4L2_QUANTIZATION_FULL_RANGE) {
+			ycbcr_enc = V4L2_YCBCR_ENC_XV709;
+			vout_color_sel = MASK_VOUT_COLOR_709_YCBCR_FULL;
+		} else {
+			ycbcr_enc = V4L2_YCBCR_ENC_709;
+			quantization = V4L2_QUANTIZATION_LIM_RANGE;
+			vout_color_sel = MASK_VOUT_COLOR_709_YCBCR_LIMITED;
+		}
 		break;
 	default:
 		return -EINVAL;
 	}
 
+	format->format.ycbcr_enc = ycbcr_enc;
+	format->format.quantization = quantization;
+
 	if (format->which == V4L2_SUBDEV_FORMAT_TRY)
 		return 0;
 
 	state->mbus_fmt_code = format->format.code;
+	state->vout_color_sel = vout_color_sel;
 
 	enable_stream(sd, false);
 	tc358743_set_pll(sd);
-- 
2.11.0

