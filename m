Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:46099 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751035AbaK0NZT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Nov 2014 08:25:19 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 9/9] adv7511: improve colorspace handling
Date: Thu, 27 Nov 2014 14:23:52 +0100
Message-Id: <1417094632-31980-10-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1417094632-31980-1-git-send-email-hverkuil@xs4all.nl>
References: <1417094632-31980-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add support for YCbCr output and support setting colorspace,
YCbCr encoding and quantization for the AVI InfoFrame.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7511.c | 199 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 199 insertions(+)

diff --git a/drivers/media/i2c/adv7511.c b/drivers/media/i2c/adv7511.c
index 8acc8c5..6eb50d2 100644
--- a/drivers/media/i2c/adv7511.c
+++ b/drivers/media/i2c/adv7511.c
@@ -96,6 +96,10 @@ struct adv7511_state {
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
@@ -804,8 +808,201 @@ static int adv7511_get_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
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
+	u8 c = 0, ec = 0, y = 0, q = 0, yq = 0;
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
+		y = 1;
+		break;
+	case MEDIA_BUS_FMT_YUYV8_1X16:
+		adv7511_wr_and_or(sd, 0x15, 0xf0, 0x01);
+		adv7511_wr_and_or(sd, 0x16, 0x03, 0xbc);
+		y = 1;
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
+		c = 3;
+		ec = y ? 3 : 4;
+		break;
+	case V4L2_COLORSPACE_SMPTE170M:
+		c = y ? 1 : 0;
+		if (y && format->format.ycbcr_enc == V4L2_YCBCR_ENC_XV601) {
+			c = 3;
+			ec = 0;
+		}
+		break;
+	case V4L2_COLORSPACE_REC709:
+		c = y ? 2 : 0;
+		if (y && format->format.ycbcr_enc == V4L2_YCBCR_ENC_XV709) {
+			c = 3;
+			ec = 1;
+		}
+		break;
+	case V4L2_COLORSPACE_SRGB:
+		c = y ? 3 : 0;
+		ec = y ? 2 : 0;
+		break;
+	case V4L2_COLORSPACE_BT2020:
+		c = 3;
+		if (y && format->format.ycbcr_enc == V4L2_YCBCR_ENC_BT2020C)
+			ec = 5;
+		else
+			ec = 6;
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
+		q = y ? 0 : 2;
+		yq = q ? q - 1 : 1;
+		break;
+	case V4L2_QUANTIZATION_LIM_RANGE:
+		q = y ? 0 : 1;
+		yq = q ? q - 1 : 0;
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
@@ -1123,6 +1320,8 @@ static int adv7511_probe(struct i2c_client *client, const struct i2c_device_id *
 		return -ENODEV;
 	}
 	memcpy(&state->pdata, pdata, sizeof(state->pdata));
+	state->fmt_code = MEDIA_BUS_FMT_RGB888_1X24;
+	state->colorspace = V4L2_COLORSPACE_SRGB;
 
 	sd = &state->sd;
 
-- 
2.1.3

