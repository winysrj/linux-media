Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:35410 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752671AbaLAJFf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Dec 2014 04:05:35 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv3 9/9] adv7511: improve colorspace handling
Date: Mon,  1 Dec 2014 10:03:53 +0100
Message-Id: <1417424633-15781-10-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1417424633-15781-1-git-send-email-hverkuil@xs4all.nl>
References: <1417424633-15781-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add support for YCbCr output and support setting colorspace,
YCbCr encoding and quantization for the AVI InfoFrame.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7511.c | 208 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 208 insertions(+)

diff --git a/drivers/media/i2c/adv7511.c b/drivers/media/i2c/adv7511.c
index 8acc8c5..81736aa 100644
--- a/drivers/media/i2c/adv7511.c
+++ b/drivers/media/i2c/adv7511.c
@@ -26,6 +26,7 @@
 #include <linux/videodev2.h>
 #include <linux/gpio.h>
 #include <linux/workqueue.h>
+#include <linux/hdmi.h>
 #include <linux/v4l2-dv-timings.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-common.h>
@@ -96,6 +97,10 @@ struct adv7511_state {
 	bool have_monitor;
 	/* timings from s_dv_timings */
 	struct v4l2_dv_timings dv_timings;
+	u32 fmt_code;
+	u32 colorspace;
+	u32 ycbcr_enc;
+	u32 quantization;
 	/* controls */
 	struct v4l2_ctrl *hdmi_mode_ctrl;
 	struct v4l2_ctrl *hotplug_ctrl;
@@ -804,8 +809,209 @@ static int adv7511_get_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
 	return 0;
 }
 
+static int adv7511_enum_mbus_code(struct v4l2_subdev *sd,
+				  struct v4l2_subdev_fh *fh,
+				  struct v4l2_subdev_mbus_code_enum *code)
+{
+	if (code->pad != 0)
+		return -EINVAL;
+
+	switch (code->index) {
+	case 0:
+		code->code = MEDIA_BUS_FMT_RGB888_1X24;
+		break;
+	case 1:
+		code->code = MEDIA_BUS_FMT_YUYV8_1X16;
+		break;
+	case 2:
+		code->code = MEDIA_BUS_FMT_UYVY8_1X16;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static void adv7511_fill_format(struct adv7511_state *state,
+				struct v4l2_mbus_framefmt *format)
+{
+	memset(format, 0, sizeof(*format));
+
+	format->width = state->dv_timings.bt.width;
+	format->height = state->dv_timings.bt.height;
+	format->field = V4L2_FIELD_NONE;
+}
+
+static int adv7511_get_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+			      struct v4l2_subdev_format *format)
+{
+	struct adv7511_state *state = get_adv7511_state(sd);
+
+	if (format->pad != 0)
+		return -EINVAL;
+
+	adv7511_fill_format(state, &format->format);
+
+	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
+		struct v4l2_mbus_framefmt *fmt;
+
+		fmt = v4l2_subdev_get_try_format(fh, format->pad);
+		format->format.code = fmt->code;
+		format->format.colorspace = fmt->colorspace;
+		format->format.ycbcr_enc = fmt->ycbcr_enc;
+		format->format.quantization = fmt->quantization;
+	} else {
+		format->format.code = state->fmt_code;
+		format->format.colorspace = state->colorspace;
+		format->format.ycbcr_enc = state->ycbcr_enc;
+		format->format.quantization = state->quantization;
+	}
+
+	return 0;
+}
+
+static int adv7511_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+		       struct v4l2_subdev_format *format)
+{
+	struct adv7511_state *state = get_adv7511_state(sd);
+	/*
+	 * Bitfield namings come the CEA-861-F standard, table 8 "Auxiliary
+	 * Video Information (AVI) InfoFrame Format"
+	 *
+	 * c = Colorimetry
+	 * ec = Extended Colorimetry
+	 * y = RGB or YCbCr
+	 * q = RGB Quantization Range
+	 * yq = YCC Quantization Range
+	 */
+	u8 c = HDMI_COLORIMETRY_NONE;
+	u8 ec = HDMI_EXTENDED_COLORIMETRY_XV_YCC_601;
+	u8 y = HDMI_COLORSPACE_RGB;
+	u8 q = HDMI_QUANTIZATION_RANGE_DEFAULT;
+	u8 yq = HDMI_YCC_QUANTIZATION_RANGE_LIMITED;
+
+	if (format->pad != 0)
+		return -EINVAL;
+	switch (format->format.code) {
+	case MEDIA_BUS_FMT_UYVY8_1X16:
+	case MEDIA_BUS_FMT_YUYV8_1X16:
+	case MEDIA_BUS_FMT_RGB888_1X24:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	adv7511_fill_format(state, &format->format);
+	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
+		struct v4l2_mbus_framefmt *fmt;
+
+		fmt = v4l2_subdev_get_try_format(fh, format->pad);
+		fmt->code = format->format.code;
+		fmt->colorspace = format->format.colorspace;
+		fmt->ycbcr_enc = format->format.ycbcr_enc;
+		fmt->quantization = format->format.quantization;
+		return 0;
+	}
+
+	switch (format->format.code) {
+	case MEDIA_BUS_FMT_UYVY8_1X16:
+		adv7511_wr_and_or(sd, 0x15, 0xf0, 0x01);
+		adv7511_wr_and_or(sd, 0x16, 0x03, 0xb8);
+		y = HDMI_COLORSPACE_YUV422;
+		break;
+	case MEDIA_BUS_FMT_YUYV8_1X16:
+		adv7511_wr_and_or(sd, 0x15, 0xf0, 0x01);
+		adv7511_wr_and_or(sd, 0x16, 0x03, 0xbc);
+		y = HDMI_COLORSPACE_YUV422;
+		break;
+	case MEDIA_BUS_FMT_RGB888_1X24:
+	default:
+		adv7511_wr_and_or(sd, 0x15, 0xf0, 0x00);
+		adv7511_wr_and_or(sd, 0x16, 0x03, 0x00);
+		break;
+	}
+	state->fmt_code = format->format.code;
+	state->colorspace = format->format.colorspace;
+	state->ycbcr_enc = format->format.ycbcr_enc;
+	state->quantization = format->format.quantization;
+
+	switch (format->format.colorspace) {
+	case V4L2_COLORSPACE_ADOBERGB:
+		c = HDMI_COLORIMETRY_EXTENDED;
+		ec = y ? HDMI_EXTENDED_COLORIMETRY_ADOBE_YCC_601 :
+			 HDMI_EXTENDED_COLORIMETRY_ADOBE_RGB;
+		break;
+	case V4L2_COLORSPACE_SMPTE170M:
+		c = y ? HDMI_COLORIMETRY_ITU_601 : HDMI_COLORIMETRY_NONE;
+		if (y && format->format.ycbcr_enc == V4L2_YCBCR_ENC_XV601) {
+			c = HDMI_COLORIMETRY_EXTENDED;
+			ec = HDMI_EXTENDED_COLORIMETRY_XV_YCC_601;
+		}
+		break;
+	case V4L2_COLORSPACE_REC709:
+		c = y ? HDMI_COLORIMETRY_ITU_709 : HDMI_COLORIMETRY_NONE;
+		if (y && format->format.ycbcr_enc == V4L2_YCBCR_ENC_XV709) {
+			c = HDMI_COLORIMETRY_EXTENDED;
+			ec = HDMI_EXTENDED_COLORIMETRY_XV_YCC_709;
+		}
+		break;
+	case V4L2_COLORSPACE_SRGB:
+		c = y ? HDMI_COLORIMETRY_EXTENDED : HDMI_COLORIMETRY_NONE;
+		ec = y ? HDMI_EXTENDED_COLORIMETRY_S_YCC_601 :
+			 HDMI_EXTENDED_COLORIMETRY_XV_YCC_601;
+		break;
+	case V4L2_COLORSPACE_BT2020:
+		c = HDMI_COLORIMETRY_EXTENDED;
+		if (y && format->format.ycbcr_enc == V4L2_YCBCR_ENC_BT2020_CONST_LUM)
+			ec = 5; /* Not yet available in hdmi.h */
+		else
+			ec = 6; /* Not yet available in hdmi.h */
+		break;
+	default:
+		break;
+	}
+
+	/*
+	 * CEA-861-F says that for RGB formats the YCC range must match the
+	 * RGB range, although sources should ignore the YCC range.
+	 *
+	 * The RGB quantization range shouldn't be non-zero if the EDID doesn't
+	 * have the Q bit set in the Video Capabilities Data Block, however this
+	 * isn't checked at the moment. The assumption is that the application
+	 * knows the EDID and can detect this.
+	 *
+	 * The same is true for the YCC quantization range: non-standard YCC
+	 * quantization ranges should only be sent if the EDID has the YQ bit
+	 * set in the Video Capabilities Data Block.
+	 */
+	switch (format->format.quantization) {
+	case V4L2_QUANTIZATION_FULL_RANGE:
+		q = y ? HDMI_QUANTIZATION_RANGE_DEFAULT :
+			HDMI_QUANTIZATION_RANGE_FULL;
+		yq = q ? q - 1 : HDMI_YCC_QUANTIZATION_RANGE_FULL;
+		break;
+	case V4L2_QUANTIZATION_LIM_RANGE:
+		q = y ? HDMI_QUANTIZATION_RANGE_DEFAULT :
+			HDMI_QUANTIZATION_RANGE_LIMITED;
+		yq = q ? q - 1 : HDMI_YCC_QUANTIZATION_RANGE_LIMITED;
+		break;
+	}
+
+	adv7511_wr_and_or(sd, 0x4a, 0xbf, 0);
+	adv7511_wr_and_or(sd, 0x55, 0x9f, y << 5);
+	adv7511_wr_and_or(sd, 0x56, 0x3f, c << 6);
+	adv7511_wr_and_or(sd, 0x57, 0x83, (ec << 4) | (q << 2));
+	adv7511_wr_and_or(sd, 0x59, 0x0f, yq << 4);
+	adv7511_wr_and_or(sd, 0x4a, 0xff, 1);
+
+	return 0;
+}
+
 static const struct v4l2_subdev_pad_ops adv7511_pad_ops = {
 	.get_edid = adv7511_get_edid,
+	.enum_mbus_code = adv7511_enum_mbus_code,
+	.get_fmt = adv7511_get_fmt,
+	.set_fmt = adv7511_set_fmt,
 	.enum_dv_timings = adv7511_enum_dv_timings,
 	.dv_timings_cap = adv7511_dv_timings_cap,
 };
@@ -1123,6 +1329,8 @@ static int adv7511_probe(struct i2c_client *client, const struct i2c_device_id *
 		return -ENODEV;
 	}
 	memcpy(&state->pdata, pdata, sizeof(state->pdata));
+	state->fmt_code = MEDIA_BUS_FMT_RGB888_1X24;
+	state->colorspace = V4L2_COLORSPACE_SRGB;
 
 	sd = &state->sd;
 
-- 
2.1.3

