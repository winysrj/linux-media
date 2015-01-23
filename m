Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-190.synserver.de ([212.40.185.190]:1311 "EHLO
	smtp-out-190.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755785AbbAWPwu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2015 10:52:50 -0500
From: Lars-Peter Clausen <lars@metafoo.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Vladimir Barinov <vladimir.barinov@cogentembedded.com>,
	=?UTF-8?q?Richard=20R=C3=B6jfors?=
	<richard.rojfors@mocean-labs.com>,
	Federico Vaga <federico.vaga@gmail.com>,
	linux-media@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v2 13/15] [media] adv7180: Add I2P support
Date: Fri, 23 Jan 2015 16:52:32 +0100
Message-Id: <1422028354-31891-14-git-send-email-lars@metafoo.de>
In-Reply-To: <1422028354-31891-1-git-send-email-lars@metafoo.de>
References: <1422028354-31891-1-git-send-email-lars@metafoo.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some of the devices supported by this driver have a interlaced-to-
progressive converter which can optionally be enabled. This patch adds
support for enabling and disabling the I2P converter on such devices.

I2P mode can be enabled by selecting V4L2_FIELD_NONE instead of
V4L2_FIELD_INTERLACED for the format.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7180.c | 156 +++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 148 insertions(+), 8 deletions(-)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index 868a677..4d789c7 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -124,6 +124,7 @@
 #define ADV7180_REG_NTSC_V_BIT_END	0x00E6
 #define ADV7180_NTSC_V_BIT_END_MANUAL_NVEND	0x4F
 
+#define ADV7180_REG_VPP_SLAVE_ADDR	0xFD
 #define ADV7180_REG_CSI_SLAVE_ADDR	0xFE
 
 #define ADV7180_CSI_REG_PWRDN	0x00
@@ -161,12 +162,14 @@
 #define ADV7182_INPUT_DIFF_CVBS_AIN7_AIN8 0x11
 
 #define ADV7180_DEFAULT_CSI_I2C_ADDR 0x44
+#define ADV7180_DEFAULT_VPP_I2C_ADDR 0x42
 
 struct adv7180_state;
 
 #define ADV7180_FLAG_RESET_POWERED	BIT(0)
 #define ADV7180_FLAG_V2			BIT(1)
 #define ADV7180_FLAG_MIPI_CSI2		BIT(2)
+#define ADV7180_FLAG_I2P		BIT(3)
 
 struct adv7180_chip_info {
 	unsigned int flags;
@@ -190,7 +193,9 @@ struct adv7180_state {
 	struct i2c_client	*client;
 	unsigned int		register_page;
 	struct i2c_client	*csi_client;
+	struct i2c_client	*vpp_client;
 	const struct adv7180_chip_info *chip_info;
+	enum v4l2_field		field;
 };
 
 static struct adv7180_state *ctrl_to_adv7180(struct v4l2_ctrl *ctrl)
@@ -236,6 +241,12 @@ static int adv7180_set_video_standard(struct adv7180_state *state,
 	return state->chip_info->set_std(state, std);
 }
 
+static int adv7180_vpp_write(struct adv7180_state *state, unsigned int reg,
+	unsigned int value)
+{
+	return i2c_smbus_write_byte_data(state->vpp_client, reg, value);
+}
+
 static v4l2_std_id adv7180_std_to_v4l2(u8 status1)
 {
 	/* in case V4L2_IN_ST_NO_SIGNAL */
@@ -440,6 +451,8 @@ static int adv7180_set_power(struct adv7180_state *state, bool on)
 			adv7180_csi_write(state, 0xD8, 0x65);
 			adv7180_csi_write(state, 0xE0, 0x09);
 			adv7180_csi_write(state, 0x2C, 0x00);
+			if (state->field == V4L2_FIELD_NONE)
+				adv7180_csi_write(state, 0x1D, 0x80);
 			adv7180_csi_write(state, 0x00, 0x00);
 		} else {
 			adv7180_csi_write(state, 0x00, 0x80);
@@ -559,25 +572,97 @@ static int adv7180_mbus_fmt(struct v4l2_subdev *sd,
 
 	fmt->code = MEDIA_BUS_FMT_YUYV8_2X8;
 	fmt->colorspace = V4L2_COLORSPACE_SMPTE170M;
-	fmt->field = V4L2_FIELD_INTERLACED;
 	fmt->width = 720;
 	fmt->height = state->curr_norm & V4L2_STD_525_60 ? 480 : 576;
 
 	return 0;
 }
 
+static int adv7180_set_field_mode(struct adv7180_state *state)
+{
+	if (!(state->chip_info->flags & ADV7180_FLAG_I2P))
+		return 0;
+
+	if (state->field == V4L2_FIELD_NONE) {
+		if (state->chip_info->flags & ADV7180_FLAG_MIPI_CSI2) {
+			adv7180_csi_write(state, 0x01, 0x20);
+			adv7180_csi_write(state, 0x02, 0x28);
+			adv7180_csi_write(state, 0x03, 0x38);
+			adv7180_csi_write(state, 0x04, 0x30);
+			adv7180_csi_write(state, 0x05, 0x30);
+			adv7180_csi_write(state, 0x06, 0x80);
+			adv7180_csi_write(state, 0x07, 0x70);
+			adv7180_csi_write(state, 0x08, 0x50);
+		}
+		adv7180_vpp_write(state, 0xa3, 0x00);
+		adv7180_vpp_write(state, 0x5b, 0x00);
+		adv7180_vpp_write(state, 0x55, 0x80);
+	} else {
+		if (state->chip_info->flags & ADV7180_FLAG_MIPI_CSI2) {
+			adv7180_csi_write(state, 0x01, 0x18);
+			adv7180_csi_write(state, 0x02, 0x18);
+			adv7180_csi_write(state, 0x03, 0x30);
+			adv7180_csi_write(state, 0x04, 0x20);
+			adv7180_csi_write(state, 0x05, 0x28);
+			adv7180_csi_write(state, 0x06, 0x40);
+			adv7180_csi_write(state, 0x07, 0x58);
+			adv7180_csi_write(state, 0x08, 0x30);
+		}
+		adv7180_vpp_write(state, 0xa3, 0x70);
+		adv7180_vpp_write(state, 0x5b, 0x80);
+		adv7180_vpp_write(state, 0x55, 0x00);
+	}
+
+	return 0;
+}
+
 static int adv7180_get_pad_format(struct v4l2_subdev *sd,
 				  struct v4l2_subdev_fh *fh,
 				  struct v4l2_subdev_format *format)
 {
-	return adv7180_mbus_fmt(sd, &format->format);
+	struct adv7180_state *state = to_state(sd);
+
+	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
+		format->format = *v4l2_subdev_get_try_format(fh, 0);
+	} else {
+		adv7180_mbus_fmt(sd, &format->format);
+		format->format.field = state->field;
+	}
+
+	return 0;
 }
 
 static int adv7180_set_pad_format(struct v4l2_subdev *sd,
 				  struct v4l2_subdev_fh *fh,
 				  struct v4l2_subdev_format *format)
 {
-	return adv7180_mbus_fmt(sd, &format->format);
+	struct adv7180_state *state = to_state(sd);
+	struct v4l2_mbus_framefmt *framefmt;
+
+	switch (format->format.field) {
+	case V4L2_FIELD_NONE:
+		if (!(state->chip_info->flags & ADV7180_FLAG_I2P))
+			format->format.field = V4L2_FIELD_INTERLACED;
+		break;
+	default:
+		format->format.field = V4L2_FIELD_INTERLACED;
+		break;
+	}
+
+	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
+		framefmt = &format->format;
+		if (state->field != format->format.field) {
+			state->field = format->format.field;
+			adv7180_set_power(state, false);
+			adv7180_set_field_mode(state);
+			adv7180_set_power(state, true);
+		}
+	} else {
+		framefmt = v4l2_subdev_get_try_format(fh, 0);
+		*framefmt = format->format;
+	}
+
+	return adv7180_mbus_fmt(sd, framefmt);
 }
 
 static int adv7180_g_mbus_config(struct v4l2_subdev *sd,
@@ -685,6 +770,10 @@ static int adv7182_init(struct adv7180_state *state)
 		adv7180_write(state, ADV7180_REG_CSI_SLAVE_ADDR,
 			ADV7180_DEFAULT_CSI_I2C_ADDR << 1);
 
+	if (state->chip_info->flags & ADV7180_FLAG_I2P)
+		adv7180_write(state, ADV7180_REG_VPP_SLAVE_ADDR,
+			ADV7180_DEFAULT_VPP_I2C_ADDR << 1);
+
 	if (state->chip_info->flags & ADV7180_FLAG_V2) {
 		/* ADI recommended writes for improved video quality */
 		adv7180_write(state, 0x0080, 0x51);
@@ -859,7 +948,7 @@ static const struct adv7180_chip_info adv7182_info = {
 };
 
 static const struct adv7180_chip_info adv7280_info = {
-	.flags = ADV7180_FLAG_V2,
+	.flags = ADV7180_FLAG_V2 | ADV7180_FLAG_I2P,
 	.valid_input_mask = BIT(ADV7182_INPUT_CVBS_AIN1) |
 		BIT(ADV7182_INPUT_CVBS_AIN2) |
 		BIT(ADV7182_INPUT_CVBS_AIN3) |
@@ -873,7 +962,7 @@ static const struct adv7180_chip_info adv7280_info = {
 };
 
 static const struct adv7180_chip_info adv7280_m_info = {
-	.flags = ADV7180_FLAG_V2 | ADV7180_FLAG_MIPI_CSI2,
+	.flags = ADV7180_FLAG_V2 | ADV7180_FLAG_MIPI_CSI2 | ADV7180_FLAG_I2P,
 	.valid_input_mask = BIT(ADV7182_INPUT_CVBS_AIN1) |
 		BIT(ADV7182_INPUT_CVBS_AIN2) |
 		BIT(ADV7182_INPUT_CVBS_AIN3) |
@@ -953,6 +1042,40 @@ static const struct adv7180_chip_info adv7281_ma_info = {
 	.select_input = adv7182_select_input,
 };
 
+static const struct adv7180_chip_info adv7282_info = {
+	.flags = ADV7180_FLAG_V2 | ADV7180_FLAG_I2P,
+	.valid_input_mask = BIT(ADV7182_INPUT_CVBS_AIN1) |
+		BIT(ADV7182_INPUT_CVBS_AIN2) |
+		BIT(ADV7182_INPUT_CVBS_AIN7) |
+		BIT(ADV7182_INPUT_CVBS_AIN8) |
+		BIT(ADV7182_INPUT_SVIDEO_AIN1_AIN2) |
+		BIT(ADV7182_INPUT_SVIDEO_AIN7_AIN8) |
+		BIT(ADV7182_INPUT_DIFF_CVBS_AIN1_AIN2) |
+		BIT(ADV7182_INPUT_DIFF_CVBS_AIN7_AIN8),
+	.init = adv7182_init,
+	.set_std = adv7182_set_std,
+	.select_input = adv7182_select_input,
+};
+
+static const struct adv7180_chip_info adv7282_m_info = {
+	.flags = ADV7180_FLAG_V2 | ADV7180_FLAG_MIPI_CSI2 | ADV7180_FLAG_I2P,
+	.valid_input_mask = BIT(ADV7182_INPUT_CVBS_AIN1) |
+		BIT(ADV7182_INPUT_CVBS_AIN2) |
+		BIT(ADV7182_INPUT_CVBS_AIN3) |
+		BIT(ADV7182_INPUT_CVBS_AIN4) |
+		BIT(ADV7182_INPUT_CVBS_AIN7) |
+		BIT(ADV7182_INPUT_CVBS_AIN8) |
+		BIT(ADV7182_INPUT_SVIDEO_AIN1_AIN2) |
+		BIT(ADV7182_INPUT_SVIDEO_AIN3_AIN4) |
+		BIT(ADV7182_INPUT_SVIDEO_AIN7_AIN8) |
+		BIT(ADV7182_INPUT_DIFF_CVBS_AIN1_AIN2) |
+		BIT(ADV7182_INPUT_DIFF_CVBS_AIN3_AIN4) |
+		BIT(ADV7182_INPUT_DIFF_CVBS_AIN7_AIN8),
+	.init = adv7182_init,
+	.set_std = adv7182_set_std,
+	.select_input = adv7182_select_input,
+};
+
 static int init_device(struct adv7180_state *state)
 {
 	int ret;
@@ -970,6 +1093,8 @@ static int init_device(struct adv7180_state *state)
 	if (ret)
 		goto out_unlock;
 
+	adv7180_set_field_mode(state);
+
 	/* register for interrupts */
 	if (state->irq > 0) {
 		/* config the Interrupt pin to be active low */
@@ -1025,6 +1150,7 @@ static int adv7180_probe(struct i2c_client *client,
 	}
 
 	state->client = client;
+	state->field = V4L2_FIELD_INTERLACED;
 	state->chip_info = (struct adv7180_chip_info *)id->driver_data;
 
 	if (state->chip_info->flags & ADV7180_FLAG_MIPI_CSI2) {
@@ -1034,6 +1160,15 @@ static int adv7180_probe(struct i2c_client *client,
 			return -ENOMEM;
 	}
 
+	if (state->chip_info->flags & ADV7180_FLAG_I2P) {
+		state->vpp_client = i2c_new_dummy(client->adapter,
+				ADV7180_DEFAULT_VPP_I2C_ADDR);
+		if (!state->vpp_client) {
+			ret = -ENOMEM;
+			goto err_unregister_csi_client;
+		}
+	}
+
 	state->irq = client->irq;
 	mutex_init(&state->mutex);
 	state->autodetect = true;
@@ -1048,7 +1183,7 @@ static int adv7180_probe(struct i2c_client *client,
 
 	ret = adv7180_init_controls(state);
 	if (ret)
-		goto err_unregister_csi_client;
+		goto err_unregister_vpp_client;
 
 	state->pad.flags = MEDIA_PAD_FL_SOURCE;
 	sd->entity.flags |= MEDIA_ENT_T_V4L2_SUBDEV_DECODER;
@@ -1081,6 +1216,9 @@ err_media_entity_cleanup:
 	media_entity_cleanup(&sd->entity);
 err_free_ctrl:
 	adv7180_exit_controls(state);
+err_unregister_vpp_client:
+	if (state->chip_info->flags & ADV7180_FLAG_I2P)
+		i2c_unregister_device(state->vpp_client);
 err_unregister_csi_client:
 	if (state->chip_info->flags & ADV7180_FLAG_MIPI_CSI2)
 		i2c_unregister_device(state->csi_client);
@@ -1102,6 +1240,8 @@ static int adv7180_remove(struct i2c_client *client)
 	media_entity_cleanup(&sd->entity);
 	adv7180_exit_controls(state);
 
+	if (state->chip_info->flags & ADV7180_FLAG_I2P)
+		i2c_unregister_device(state->vpp_client);
 	if (state->chip_info->flags & ADV7180_FLAG_MIPI_CSI2)
 		i2c_unregister_device(state->csi_client);
 
@@ -1118,8 +1258,8 @@ static const struct i2c_device_id adv7180_id[] = {
 	{ "adv7281", (kernel_ulong_t)&adv7281_info },
 	{ "adv7281-m", (kernel_ulong_t)&adv7281_m_info },
 	{ "adv7281-ma", (kernel_ulong_t)&adv7281_ma_info },
-	{ "adv7282", (kernel_ulong_t)&adv7281_info },
-	{ "adv7282-m", (kernel_ulong_t)&adv7281_m_info },
+	{ "adv7282", (kernel_ulong_t)&adv7282_info },
+	{ "adv7282-m", (kernel_ulong_t)&adv7282_m_info },
 	{},
 };
 MODULE_DEVICE_TABLE(i2c, adv7180_id);
-- 
1.8.0

