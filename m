Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:57351 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751666AbdBMJYm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 04:24:42 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mats Randgaard <matrandg@cisco.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 2/2] [media] tc358743: extend colorimetry support
Date: Mon, 13 Feb 2017 10:24:37 +0100
Message-Id: <1486977877-26206-2-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1486977877-26206-1-git-send-email-p.zabel@pengutronix.de>
References: <1486977877-26206-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The video output format can freely be chosen to be 24-bit SRGB or 16-bit
YUV 4:2:2 in either SMPTE170M or REC709 color space. In all three modes
the output can be full or limited range.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v1:
 - Determine colorspace and xfer_func from the S_V_COLOR (HDMI input
   colorspace) bitfield. This defaults to SRGB full range if no input
   is connected, or if the input does not send AVI infoframes (DVI).
 - Control ycbcr_enc and quantization via VOUT_COLOR_SEL. This can be
   set via set_fmt, with some limitations:
 - Disallow YUV to RGB conversion, which is apparently not supported by the
   hardware.
 - Limit V4L2_YCBCR_ENC_601/709 encodings to limited quantization range and
   limit V4L2_YCBCR_ENC_XV601/XV709 encodings to full quantization range
 - Default to limited range for SRGB and Adobe RGB if quantization is not
   set explicitly.
---
 drivers/media/i2c/tc358743.c      | 148 ++++++++++++++++++++++++++++++++------
 drivers/media/i2c/tc358743_regs.h |   8 +++
 2 files changed, 135 insertions(+), 21 deletions(-)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index 64a97bbbd00a8..9f191735be805 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -96,6 +96,7 @@ struct tc358743_state {
 
 	struct v4l2_dv_timings timings;
 	u32 mbus_fmt_code;
+	u8 vout_color_sel;
 	u8 csi_lanes_in_use;
 
 	struct gpio_desc *reset_gpio;
@@ -628,7 +629,7 @@ static void tc358743_set_csi_color_space(struct v4l2_subdev *sd)
 				~(MASK_SEL422 | MASK_VOUT_422FIL_100) & 0xff,
 				MASK_SEL422 | MASK_VOUT_422FIL_100);
 		i2c_wr8_and_or(sd, VI_REP, ~MASK_VOUT_COLOR_SEL & 0xff,
-				MASK_VOUT_COLOR_601_YCBCR_LIMITED);
+				state->vout_color_sel);
 		mutex_lock(&state->confctl_mutex);
 		i2c_wr16_and_or(sd, CONFCTL, ~MASK_YCBCRFMT,
 				MASK_YCBCRFMT_422_8_BIT);
@@ -640,7 +641,7 @@ static void tc358743_set_csi_color_space(struct v4l2_subdev *sd)
 				~(MASK_SEL422 | MASK_VOUT_422FIL_100) & 0xff,
 				0x00);
 		i2c_wr8_and_or(sd, VI_REP, ~MASK_VOUT_COLOR_SEL & 0xff,
-				MASK_VOUT_COLOR_RGB_FULL);
+				state->vout_color_sel);
 		mutex_lock(&state->confctl_mutex);
 		i2c_wr16_and_or(sd, CONFCTL, ~MASK_YCBCRFMT, 0);
 		mutex_unlock(&state->confctl_mutex);
@@ -1096,11 +1097,17 @@ static int tc358743_log_status(struct v4l2_subdev *sd)
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
@@ -1159,11 +1166,12 @@ static int tc358743_log_status(struct v4l2_subdev *sd)
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
@@ -1469,38 +1477,88 @@ static int tc358743_s_stream(struct v4l2_subdev *sd, int enable)
 
 /* --------------- PAD OPS --------------- */
 
-static int tc358743_get_fmt(struct v4l2_subdev *sd,
-		struct v4l2_subdev_pad_config *cfg,
-		struct v4l2_subdev_format *format)
+static void tc358743_get_csi_color_space(struct v4l2_subdev *sd,
+					 struct v4l2_mbus_framefmt *format)
 {
-	struct tc358743_state *state = to_state(sd);
+	u8 vi_status3 = i2c_rd8(sd, VI_STATUS3);
 	u8 vi_rep = i2c_rd8(sd, VI_REP);
 
-	if (format->pad != 0)
-		return -EINVAL;
+	switch (vi_status3 & MASK_S_V_COLOR) {
+	default:
+	case MASK_S_V_COLOR_RGB:
+	case MASK_S_V_COLOR_SYCC601:
+		format->colorspace = V4L2_COLORSPACE_SRGB;
+		format->xfer_func = V4L2_XFER_FUNC_SRGB;
+		break;
+	case MASK_S_V_COLOR_YCBCR601:
+	case MASK_S_V_COLOR_XVYCC601:
+		format->colorspace = V4L2_COLORSPACE_SMPTE170M;
+		format->xfer_func = V4L2_XFER_FUNC_709;
+		break;
+	case MASK_S_V_COLOR_YCBCR709:
+	case MASK_S_V_COLOR_XVYCC709:
+		format->colorspace = V4L2_COLORSPACE_REC709;
+		format->xfer_func = V4L2_XFER_FUNC_709;
+		break;
+	case MASK_S_V_COLOR_ADOBERGB:
+	case MASK_S_V_COLOR_ADOBEYCC601:
+		format->colorspace = V4L2_COLORSPACE_ADOBERGB;
+		format->xfer_func = V4L2_XFER_FUNC_ADOBERGB;
+		break;
+	}
 
-	format->format.code = state->mbus_fmt_code;
-	format->format.width = state->timings.bt.width;
-	format->format.height = state->timings.bt.height;
-	format->format.field = V4L2_FIELD_NONE;
+	format->ycbcr_enc = V4L2_MAP_YCBCR_ENC_DEFAULT(format->colorspace);
 
 	switch (vi_rep & MASK_VOUT_COLOR_SEL) {
+	default:
 	case MASK_VOUT_COLOR_RGB_FULL:
+		format->ycbcr_enc = V4L2_YCBCR_ENC_601;
+		format->quantization = V4L2_QUANTIZATION_FULL_RANGE;
+		break;
 	case MASK_VOUT_COLOR_RGB_LIMITED:
-		format->format.colorspace = V4L2_COLORSPACE_SRGB;
+		format->ycbcr_enc = V4L2_YCBCR_ENC_601;
+		format->quantization = V4L2_QUANTIZATION_LIM_RANGE;
 		break;
 	case MASK_VOUT_COLOR_601_YCBCR_LIMITED:
+		format->ycbcr_enc = V4L2_YCBCR_ENC_601;
+		format->quantization = V4L2_QUANTIZATION_LIM_RANGE;
+		break;
 	case MASK_VOUT_COLOR_601_YCBCR_FULL:
-		format->format.colorspace = V4L2_COLORSPACE_SMPTE170M;
+		format->ycbcr_enc = V4L2_YCBCR_ENC_XV601;
+		format->quantization = V4L2_QUANTIZATION_FULL_RANGE;
 		break;
 	case MASK_VOUT_COLOR_709_YCBCR_FULL:
+		format->ycbcr_enc = V4L2_YCBCR_ENC_XV709;
+		format->quantization = V4L2_QUANTIZATION_FULL_RANGE;
+		break;
 	case MASK_VOUT_COLOR_709_YCBCR_LIMITED:
-		format->format.colorspace = V4L2_COLORSPACE_REC709;
+		format->ycbcr_enc = V4L2_YCBCR_ENC_709;
+		format->quantization = V4L2_QUANTIZATION_LIM_RANGE;
 		break;
-	default:
-		format->format.colorspace = 0;
+	case MASK_VOUT_COLOR_FULL_TO_LIMITED:
+		format->quantization = V4L2_QUANTIZATION_LIM_RANGE;
+		break;
+	case MASK_VOUT_COLOR_LIMITED_TO_FULL:
+		format->quantization = V4L2_QUANTIZATION_FULL_RANGE;
 		break;
 	}
+}
+
+static int tc358743_get_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
+{
+	struct tc358743_state *state = to_state(sd);
+
+	if (format->pad != 0)
+		return -EINVAL;
+
+	format->format.code = state->mbus_fmt_code;
+	format->format.width = state->timings.bt.width;
+	format->format.height = state->timings.bt.height;
+	format->format.field = V4L2_FIELD_NONE;
+
+	tc358743_get_csi_color_space(sd, &format->format);
 
 	return 0;
 }
@@ -1512,25 +1570,72 @@ static int tc358743_set_fmt(struct v4l2_subdev *sd,
 	struct tc358743_state *state = to_state(sd);
 
 	u32 code = format->format.code; /* is overwritten by get_fmt */
+	enum v4l2_ycbcr_encoding ycbcr_enc = format->format.ycbcr_enc;
+	enum v4l2_quantization quantization = format->format.quantization;
 	int ret = tc358743_get_fmt(sd, cfg, format);
-
-	format->format.code = code;
+	enum v4l2_colorspace colorspace;
+	u8 vout_color_sel;
 
 	if (ret)
 		return ret;
 
+	colorspace = format->format.colorspace;
+
 	switch (code) {
 	case MEDIA_BUS_FMT_RGB888_1X24:
+		if (colorspace == V4L2_COLORSPACE_SRGB ||
+		    colorspace == V4L2_COLORSPACE_ADOBERGB) {
+			ycbcr_enc = V4L2_YCBCR_ENC_601;
+			if (quantization == V4L2_QUANTIZATION_FULL_RANGE) {
+				vout_color_sel = MASK_VOUT_COLOR_RGB_FULL;
+			} else {
+				quantization = V4L2_QUANTIZATION_LIM_RANGE;
+				vout_color_sel = MASK_VOUT_COLOR_RGB_LIMITED;
+			}
+			break;
+		}
+		/*
+		 * Since color space conversion to RGB is not supported,
+		 * fall through for YUV input.
+		 */
+		code = MEDIA_BUS_FMT_UYVY8_1X16;
 	case MEDIA_BUS_FMT_UYVY8_1X16:
+		if (ycbcr_enc == V4L2_YCBCR_ENC_DEFAULT)
+			ycbcr_enc = V4L2_MAP_YCBCR_ENC_DEFAULT(colorspace);
+		switch (ycbcr_enc) {
+		case V4L2_YCBCR_ENC_601:
+			quantization = V4L2_QUANTIZATION_LIM_RANGE;
+			vout_color_sel = MASK_VOUT_COLOR_601_YCBCR_LIMITED;
+			break;
+		case V4L2_YCBCR_ENC_709:
+			quantization = V4L2_QUANTIZATION_LIM_RANGE;
+			vout_color_sel = MASK_VOUT_COLOR_709_YCBCR_LIMITED;
+			break;
+		case V4L2_YCBCR_ENC_XV601:
+			quantization = V4L2_QUANTIZATION_FULL_RANGE;
+			vout_color_sel = MASK_VOUT_COLOR_601_YCBCR_FULL;
+			break;
+		case V4L2_YCBCR_ENC_XV709:
+			quantization = V4L2_QUANTIZATION_FULL_RANGE;
+			vout_color_sel = MASK_VOUT_COLOR_709_YCBCR_FULL;
+			break;
+		default:
+			return -EINVAL;
+		}
 		break;
 	default:
 		return -EINVAL;
 	}
 
+	format->format.code = code;
+	format->format.ycbcr_enc = ycbcr_enc;
+	format->format.quantization = quantization;
+
 	if (format->which == V4L2_SUBDEV_FORMAT_TRY)
 		return 0;
 
 	state->mbus_fmt_code = format->format.code;
+	state->vout_color_sel = vout_color_sel;
 
 	enable_stream(sd, false);
 	tc358743_set_pll(sd);
@@ -1898,6 +2003,7 @@ static int tc358743_probe(struct i2c_client *client,
 	tc358743_s_dv_timings(sd, &default_timing);
 
 	state->mbus_fmt_code = MEDIA_BUS_FMT_RGB888_1X24;
+	state->vout_color_sel = MASK_VOUT_COLOR_RGB_FULL;
 	tc358743_set_csi_color_space(sd);
 
 	tc358743_init_interrupts(sd);
diff --git a/drivers/media/i2c/tc358743_regs.h b/drivers/media/i2c/tc358743_regs.h
index 657ef50f215f5..8dae3d34c6270 100644
--- a/drivers/media/i2c/tc358743_regs.h
+++ b/drivers/media/i2c/tc358743_regs.h
@@ -337,6 +337,14 @@
 
 #define VI_STATUS3                            0x8528
 #define MASK_S_V_COLOR                        0x1e
+#define MASK_S_V_COLOR_RGB                    0x00
+#define MASK_S_V_COLOR_YCBCR601               0x02
+#define MASK_S_V_COLOR_YCBCR709               0x06
+#define MASK_S_V_COLOR_ADOBERGB               0x04
+#define MASK_S_V_COLOR_XVYCC601               0x0a
+#define MASK_S_V_COLOR_XVYCC709               0x0e
+#define MASK_S_V_COLOR_SYCC601                0x12
+#define MASK_S_V_COLOR_ADOBEYCC601            0x1a
 #define MASK_LIMITED                          0x01
 
 #define PHY_CTL0                              0x8531
-- 
2.11.0
