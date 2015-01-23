Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-190.synserver.de ([212.40.185.190]:1079 "EHLO
	smtp-out-190.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755769AbbAWPwt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2015 10:52:49 -0500
From: Lars-Peter Clausen <lars@metafoo.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Vladimir Barinov <vladimir.barinov@cogentembedded.com>,
	=?UTF-8?q?Richard=20R=C3=B6jfors?=
	<richard.rojfors@mocean-labs.com>,
	Federico Vaga <federico.vaga@gmail.com>,
	linux-media@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v2 12/15] [media] adv7180: Add support for the adv7280-m/adv7281-m/adv7281-ma/adv7282-m
Date: Fri, 23 Jan 2015 16:52:31 +0100
Message-Id: <1422028354-31891-13-git-send-email-lars@metafoo.de>
In-Reply-To: <1422028354-31891-1-git-send-email-lars@metafoo.de>
References: <1422028354-31891-1-git-send-email-lars@metafoo.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for the adv7280-m/adv2781-m/adv7281-ma/adv7282-m
devices to the adv7180 driver. They are very similar to the
adv7280/adv7281/adv7282 but instead of parallel video out they feature a
MIPI CSI2 transmitter.

The CSI2 transmitter is configured via a separate I2C address, so we need to
register a dummy device for it.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7180.c | 170 +++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 154 insertions(+), 16 deletions(-)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index ea6695c..868a677 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -124,6 +124,11 @@
 #define ADV7180_REG_NTSC_V_BIT_END	0x00E6
 #define ADV7180_NTSC_V_BIT_END_MANUAL_NVEND	0x4F
 
+#define ADV7180_REG_CSI_SLAVE_ADDR	0xFE
+
+#define ADV7180_CSI_REG_PWRDN	0x00
+#define ADV7180_CSI_PWRDN	0x80
+
 #define ADV7180_INPUT_CVBS_AIN1 0x00
 #define ADV7180_INPUT_CVBS_AIN2 0x01
 #define ADV7180_INPUT_CVBS_AIN3 0x02
@@ -155,10 +160,13 @@
 #define ADV7182_INPUT_DIFF_CVBS_AIN5_AIN6 0x10
 #define ADV7182_INPUT_DIFF_CVBS_AIN7_AIN8 0x11
 
+#define ADV7180_DEFAULT_CSI_I2C_ADDR 0x44
+
 struct adv7180_state;
 
 #define ADV7180_FLAG_RESET_POWERED	BIT(0)
 #define ADV7180_FLAG_V2			BIT(1)
+#define ADV7180_FLAG_MIPI_CSI2		BIT(2)
 
 struct adv7180_chip_info {
 	unsigned int flags;
@@ -181,6 +189,7 @@ struct adv7180_state {
 
 	struct i2c_client	*client;
 	unsigned int		register_page;
+	struct i2c_client	*csi_client;
 	const struct adv7180_chip_info *chip_info;
 };
 
@@ -215,6 +224,12 @@ static int adv7180_read(struct adv7180_state *state, unsigned int reg)
 	return i2c_smbus_read_byte_data(state->client, reg & 0xff);
 }
 
+static int adv7180_csi_write(struct adv7180_state *state, unsigned int reg,
+	unsigned int value)
+{
+	return i2c_smbus_write_byte_data(state->csi_client, reg, value);
+}
+
 static int adv7180_set_video_standard(struct adv7180_state *state,
 	unsigned int std)
 {
@@ -407,13 +422,31 @@ out:
 static int adv7180_set_power(struct adv7180_state *state, bool on)
 {
 	u8 val;
+	int ret;
 
 	if (on)
 		val = ADV7180_PWR_MAN_ON;
 	else
 		val = ADV7180_PWR_MAN_OFF;
 
-	return adv7180_write(state, ADV7180_REG_PWR_MAN, val);
+	ret = adv7180_write(state, ADV7180_REG_PWR_MAN, val);
+	if (ret)
+		return ret;
+
+	if (state->chip_info->flags & ADV7180_FLAG_MIPI_CSI2) {
+		if (on) {
+			adv7180_csi_write(state, 0xDE, 0x02);
+			adv7180_csi_write(state, 0xD2, 0xF7);
+			adv7180_csi_write(state, 0xD8, 0x65);
+			adv7180_csi_write(state, 0xE0, 0x09);
+			adv7180_csi_write(state, 0x2C, 0x00);
+			adv7180_csi_write(state, 0x00, 0x00);
+		} else {
+			adv7180_csi_write(state, 0x00, 0x80);
+		}
+	}
+
+	return 0;
 }
 
 static int adv7180_s_power(struct v4l2_subdev *sd, int on)
@@ -550,13 +583,22 @@ static int adv7180_set_pad_format(struct v4l2_subdev *sd,
 static int adv7180_g_mbus_config(struct v4l2_subdev *sd,
 				 struct v4l2_mbus_config *cfg)
 {
-	/*
-	 * The ADV7180 sensor supports BT.601/656 output modes.
-	 * The BT.656 is default and not yet configurable by s/w.
-	 */
-	cfg->flags = V4L2_MBUS_MASTER | V4L2_MBUS_PCLK_SAMPLE_RISING |
-		     V4L2_MBUS_DATA_ACTIVE_HIGH;
-	cfg->type = V4L2_MBUS_BT656;
+	struct adv7180_state *state = to_state(sd);
+
+	if (state->chip_info->flags & ADV7180_FLAG_MIPI_CSI2) {
+		cfg->type = V4L2_MBUS_CSI2;
+		cfg->flags = V4L2_MBUS_CSI2_1_LANE |
+				V4L2_MBUS_CSI2_CHANNEL_0 |
+				V4L2_MBUS_CSI2_CONTINUOUS_CLOCK;
+	} else {
+		/*
+		 * The ADV7180 sensor supports BT.601/656 output modes.
+		 * The BT.656 is default and not yet configurable by s/w.
+		 */
+		cfg->flags = V4L2_MBUS_MASTER | V4L2_MBUS_PCLK_SAMPLE_RISING |
+				 V4L2_MBUS_DATA_ACTIVE_HIGH;
+		cfg->type = V4L2_MBUS_BT656;
+	}
 
 	return 0;
 }
@@ -639,20 +681,32 @@ static int adv7180_select_input(struct adv7180_state *state, unsigned int input)
 
 static int adv7182_init(struct adv7180_state *state)
 {
+	if (state->chip_info->flags & ADV7180_FLAG_MIPI_CSI2)
+		adv7180_write(state, ADV7180_REG_CSI_SLAVE_ADDR,
+			ADV7180_DEFAULT_CSI_I2C_ADDR << 1);
+
 	if (state->chip_info->flags & ADV7180_FLAG_V2) {
 		/* ADI recommended writes for improved video quality */
 		adv7180_write(state, 0x0080, 0x51);
 		adv7180_write(state, 0x0081, 0x51);
 		adv7180_write(state, 0x0082, 0x68);
-		adv7180_write(state, 0x0004, 0x17);
-	} else {
-		adv7180_write(state, 0x0004, 0x07);
 	}
 
 	/* ADI required writes */
-	adv7180_write(state, 0x0003, 0x0c);
+	if (state->chip_info->flags & ADV7180_FLAG_MIPI_CSI2) {
+		adv7180_write(state, 0x0003, 0x4e);
+		adv7180_write(state, 0x0004, 0x57);
+		adv7180_write(state, 0x001d, 0xc0);
+	} else {
+		if (state->chip_info->flags & ADV7180_FLAG_V2)
+			adv7180_write(state, 0x0004, 0x17);
+		else
+			adv7180_write(state, 0x0004, 0x07);
+		adv7180_write(state, 0x0003, 0x0c);
+		adv7180_write(state, 0x001d, 0x40);
+	}
+
 	adv7180_write(state, 0x0013, 0x00);
-	adv7180_write(state, 0x001d, 0x40);
 
 	return 0;
 }
@@ -818,15 +872,81 @@ static const struct adv7180_chip_info adv7280_info = {
 	.select_input = adv7182_select_input,
 };
 
+static const struct adv7180_chip_info adv7280_m_info = {
+	.flags = ADV7180_FLAG_V2 | ADV7180_FLAG_MIPI_CSI2,
+	.valid_input_mask = BIT(ADV7182_INPUT_CVBS_AIN1) |
+		BIT(ADV7182_INPUT_CVBS_AIN2) |
+		BIT(ADV7182_INPUT_CVBS_AIN3) |
+		BIT(ADV7182_INPUT_CVBS_AIN4) |
+		BIT(ADV7182_INPUT_CVBS_AIN5) |
+		BIT(ADV7182_INPUT_CVBS_AIN6) |
+		BIT(ADV7182_INPUT_CVBS_AIN7) |
+		BIT(ADV7182_INPUT_CVBS_AIN8) |
+		BIT(ADV7182_INPUT_SVIDEO_AIN1_AIN2) |
+		BIT(ADV7182_INPUT_SVIDEO_AIN3_AIN4) |
+		BIT(ADV7182_INPUT_SVIDEO_AIN5_AIN6) |
+		BIT(ADV7182_INPUT_SVIDEO_AIN7_AIN8) |
+		BIT(ADV7182_INPUT_YPRPB_AIN1_AIN2_AIN3) |
+		BIT(ADV7182_INPUT_YPRPB_AIN4_AIN5_AIN6),
+	.init = adv7182_init,
+	.set_std = adv7182_set_std,
+	.select_input = adv7182_select_input,
+};
+
 static const struct adv7180_chip_info adv7281_info = {
-	.flags = ADV7180_FLAG_V2,
+	.flags = ADV7180_FLAG_V2 | ADV7180_FLAG_MIPI_CSI2,
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
+static const struct adv7180_chip_info adv7281_m_info = {
+	.flags = ADV7180_FLAG_V2 | ADV7180_FLAG_MIPI_CSI2,
+	.valid_input_mask = BIT(ADV7182_INPUT_CVBS_AIN1) |
+		BIT(ADV7182_INPUT_CVBS_AIN2) |
+		BIT(ADV7182_INPUT_CVBS_AIN3) |
+		BIT(ADV7182_INPUT_CVBS_AIN4) |
+		BIT(ADV7182_INPUT_CVBS_AIN7) |
+		BIT(ADV7182_INPUT_CVBS_AIN8) |
+		BIT(ADV7182_INPUT_SVIDEO_AIN1_AIN2) |
+		BIT(ADV7182_INPUT_SVIDEO_AIN3_AIN4) |
+		BIT(ADV7182_INPUT_SVIDEO_AIN7_AIN8) |
+		BIT(ADV7182_INPUT_YPRPB_AIN1_AIN2_AIN3) |
+		BIT(ADV7182_INPUT_DIFF_CVBS_AIN1_AIN2) |
+		BIT(ADV7182_INPUT_DIFF_CVBS_AIN3_AIN4) |
+		BIT(ADV7182_INPUT_DIFF_CVBS_AIN7_AIN8),
+	.init = adv7182_init,
+	.set_std = adv7182_set_std,
+	.select_input = adv7182_select_input,
+};
+
+static const struct adv7180_chip_info adv7281_ma_info = {
+	.flags = ADV7180_FLAG_V2 | ADV7180_FLAG_MIPI_CSI2,
 	.valid_input_mask = BIT(ADV7182_INPUT_CVBS_AIN1) |
 		BIT(ADV7182_INPUT_CVBS_AIN2) |
+		BIT(ADV7182_INPUT_CVBS_AIN3) |
+		BIT(ADV7182_INPUT_CVBS_AIN4) |
+		BIT(ADV7182_INPUT_CVBS_AIN5) |
+		BIT(ADV7182_INPUT_CVBS_AIN6) |
 		BIT(ADV7182_INPUT_CVBS_AIN7) |
 		BIT(ADV7182_INPUT_CVBS_AIN8) |
 		BIT(ADV7182_INPUT_SVIDEO_AIN1_AIN2) |
+		BIT(ADV7182_INPUT_SVIDEO_AIN3_AIN4) |
+		BIT(ADV7182_INPUT_SVIDEO_AIN5_AIN6) |
 		BIT(ADV7182_INPUT_SVIDEO_AIN7_AIN8) |
+		BIT(ADV7182_INPUT_YPRPB_AIN1_AIN2_AIN3) |
+		BIT(ADV7182_INPUT_YPRPB_AIN4_AIN5_AIN6) |
 		BIT(ADV7182_INPUT_DIFF_CVBS_AIN1_AIN2) |
+		BIT(ADV7182_INPUT_DIFF_CVBS_AIN3_AIN4) |
+		BIT(ADV7182_INPUT_DIFF_CVBS_AIN5_AIN6) |
 		BIT(ADV7182_INPUT_DIFF_CVBS_AIN7_AIN8),
 	.init = adv7182_init,
 	.set_std = adv7182_set_std,
@@ -907,6 +1027,13 @@ static int adv7180_probe(struct i2c_client *client,
 	state->client = client;
 	state->chip_info = (struct adv7180_chip_info *)id->driver_data;
 
+	if (state->chip_info->flags & ADV7180_FLAG_MIPI_CSI2) {
+		state->csi_client = i2c_new_dummy(client->adapter,
+				ADV7180_DEFAULT_CSI_I2C_ADDR);
+		if (!state->csi_client)
+			return -ENOMEM;
+	}
+
 	state->irq = client->irq;
 	mutex_init(&state->mutex);
 	state->autodetect = true;
@@ -921,7 +1048,7 @@ static int adv7180_probe(struct i2c_client *client,
 
 	ret = adv7180_init_controls(state);
 	if (ret)
-		goto err_unreg_subdev;
+		goto err_unregister_csi_client;
 
 	state->pad.flags = MEDIA_PAD_FL_SOURCE;
 	sd->entity.flags |= MEDIA_ENT_T_V4L2_SUBDEV_DECODER;
@@ -954,7 +1081,9 @@ err_media_entity_cleanup:
 	media_entity_cleanup(&sd->entity);
 err_free_ctrl:
 	adv7180_exit_controls(state);
-err_unreg_subdev:
+err_unregister_csi_client:
+	if (state->chip_info->flags & ADV7180_FLAG_MIPI_CSI2)
+		i2c_unregister_device(state->csi_client);
 	mutex_destroy(&state->mutex);
 err:
 	return ret;
@@ -972,7 +1101,12 @@ static int adv7180_remove(struct i2c_client *client)
 
 	media_entity_cleanup(&sd->entity);
 	adv7180_exit_controls(state);
+
+	if (state->chip_info->flags & ADV7180_FLAG_MIPI_CSI2)
+		i2c_unregister_device(state->csi_client);
+
 	mutex_destroy(&state->mutex);
+
 	return 0;
 }
 
@@ -980,8 +1114,12 @@ static const struct i2c_device_id adv7180_id[] = {
 	{ "adv7180", (kernel_ulong_t)&adv7180_info },
 	{ "adv7182", (kernel_ulong_t)&adv7182_info },
 	{ "adv7280", (kernel_ulong_t)&adv7280_info },
+	{ "adv7280-m", (kernel_ulong_t)&adv7280_m_info },
 	{ "adv7281", (kernel_ulong_t)&adv7281_info },
+	{ "adv7281-m", (kernel_ulong_t)&adv7281_m_info },
+	{ "adv7281-ma", (kernel_ulong_t)&adv7281_ma_info },
 	{ "adv7282", (kernel_ulong_t)&adv7281_info },
+	{ "adv7282-m", (kernel_ulong_t)&adv7281_m_info },
 	{},
 };
 MODULE_DEVICE_TABLE(i2c, adv7180_id);
-- 
1.8.0

