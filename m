Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-190.synserver.de ([212.40.185.190]:1136 "EHLO
	smtp-out-190.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755701AbbAWPwp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2015 10:52:45 -0500
From: Lars-Peter Clausen <lars@metafoo.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Vladimir Barinov <vladimir.barinov@cogentembedded.com>,
	=?UTF-8?q?Richard=20R=C3=B6jfors?=
	<richard.rojfors@mocean-labs.com>,
	Federico Vaga <federico.vaga@gmail.com>,
	linux-media@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v2 09/15] [media] adv7180: Prepare for multi-chip support
Date: Fri, 23 Jan 2015 16:52:28 +0100
Message-Id: <1422028354-31891-10-git-send-email-lars@metafoo.de>
In-Reply-To: <1422028354-31891-1-git-send-email-lars@metafoo.de>
References: <1422028354-31891-1-git-send-email-lars@metafoo.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The adv7180 is part of a larger family of device, which have all a very
similar register map layout. This patch prepares the adv7180 driver for
support for multiple different devices. For now the only difference we care
about is the number of input channel configurations. Also the way the input
format is configured slightly differs between some devices.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7180.c | 187 ++++++++++++++++++++++++++++++--------------
 1 file changed, 130 insertions(+), 57 deletions(-)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index 4d9bcc8..e3f91d5 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -32,23 +32,24 @@
 #include <linux/mutex.h>
 #include <linux/delay.h>
 
+#define ADV7180_STD_AD_PAL_BG_NTSC_J_SECAM		0x0
+#define ADV7180_STD_AD_PAL_BG_NTSC_J_SECAM_PED		0x1
+#define ADV7180_STD_AD_PAL_N_NTSC_J_SECAM		0x2
+#define ADV7180_STD_AD_PAL_N_NTSC_M_SECAM		0x3
+#define ADV7180_STD_NTSC_J				0x4
+#define ADV7180_STD_NTSC_M				0x5
+#define ADV7180_STD_PAL60				0x6
+#define ADV7180_STD_NTSC_443				0x7
+#define ADV7180_STD_PAL_BG				0x8
+#define ADV7180_STD_PAL_N				0x9
+#define ADV7180_STD_PAL_M				0xa
+#define ADV7180_STD_PAL_M_PED				0xb
+#define ADV7180_STD_PAL_COMB_N				0xc
+#define ADV7180_STD_PAL_COMB_N_PED			0xd
+#define ADV7180_STD_PAL_SECAM				0xe
+#define ADV7180_STD_PAL_SECAM_PED			0xf
+
 #define ADV7180_REG_INPUT_CONTROL			0x0000
-#define ADV7180_INPUT_CONTROL_AD_PAL_BG_NTSC_J_SECAM	0x00
-#define ADV7180_INPUT_CONTROL_AD_PAL_BG_NTSC_J_SECAM_PED 0x10
-#define ADV7180_INPUT_CONTROL_AD_PAL_N_NTSC_J_SECAM	0x20
-#define ADV7180_INPUT_CONTROL_AD_PAL_N_NTSC_M_SECAM	0x30
-#define ADV7180_INPUT_CONTROL_NTSC_J			0x40
-#define ADV7180_INPUT_CONTROL_NTSC_M			0x50
-#define ADV7180_INPUT_CONTROL_PAL60			0x60
-#define ADV7180_INPUT_CONTROL_NTSC_443			0x70
-#define ADV7180_INPUT_CONTROL_PAL_BG			0x80
-#define ADV7180_INPUT_CONTROL_PAL_N			0x90
-#define ADV7180_INPUT_CONTROL_PAL_M			0xa0
-#define ADV7180_INPUT_CONTROL_PAL_M_PED			0xb0
-#define ADV7180_INPUT_CONTROL_PAL_COMB_N		0xc0
-#define ADV7180_INPUT_CONTROL_PAL_COMB_N_PED		0xd0
-#define ADV7180_INPUT_CONTROL_PAL_SECAM			0xe0
-#define ADV7180_INPUT_CONTROL_PAL_SECAM_PED		0xf0
 #define ADV7180_INPUT_CONTROL_INSEL_MASK		0x0f
 
 #define ADV7180_REG_EXTENDED_OUTPUT_CONTROL		0x0004
@@ -121,6 +122,30 @@
 #define ADV7180_REG_NTSC_V_BIT_END	0x00E6
 #define ADV7180_NTSC_V_BIT_END_MANUAL_NVEND	0x4F
 
+#define ADV7180_INPUT_CVBS_AIN1 0x00
+#define ADV7180_INPUT_CVBS_AIN2 0x01
+#define ADV7180_INPUT_CVBS_AIN3 0x02
+#define ADV7180_INPUT_CVBS_AIN4 0x03
+#define ADV7180_INPUT_CVBS_AIN5 0x04
+#define ADV7180_INPUT_CVBS_AIN6 0x05
+#define ADV7180_INPUT_SVIDEO_AIN1_AIN2 0x06
+#define ADV7180_INPUT_SVIDEO_AIN3_AIN4 0x07
+#define ADV7180_INPUT_SVIDEO_AIN5_AIN6 0x08
+#define ADV7180_INPUT_YPRPB_AIN1_AIN2_AIN3 0x09
+#define ADV7180_INPUT_YPRPB_AIN4_AIN5_AIN6 0x0a
+
+struct adv7180_state;
+
+#define ADV7180_FLAG_RESET_POWERED	BIT(0)
+
+struct adv7180_chip_info {
+	unsigned int flags;
+	unsigned int valid_input_mask;
+	int (*set_std)(struct adv7180_state *st, unsigned int std);
+	int (*select_input)(struct adv7180_state *st, unsigned int input);
+	int (*init)(struct adv7180_state *state);
+};
+
 struct adv7180_state {
 	struct v4l2_ctrl_handler ctrl_hdl;
 	struct v4l2_subdev	sd;
@@ -134,6 +159,7 @@ struct adv7180_state {
 
 	struct i2c_client	*client;
 	unsigned int		register_page;
+	const struct adv7180_chip_info *chip_info;
 };
 
 static struct adv7180_state *ctrl_to_adv7180(struct v4l2_ctrl *ctrl)
@@ -167,6 +193,11 @@ static int adv7180_read(struct adv7180_state *state, unsigned int reg)
 	return i2c_smbus_read_byte_data(state->client, reg & 0xff);
 }
 
+static int adv7180_set_video_standard(struct adv7180_state *state,
+	unsigned int std)
+{
+	return state->chip_info->set_std(state, std);
+}
 
 static v4l2_std_id adv7180_std_to_v4l2(u8 status1)
 {
@@ -199,22 +230,22 @@ static v4l2_std_id adv7180_std_to_v4l2(u8 status1)
 static int v4l2_std_to_adv7180(v4l2_std_id std)
 {
 	if (std == V4L2_STD_PAL_60)
-		return ADV7180_INPUT_CONTROL_PAL60;
+		return ADV7180_STD_PAL60;
 	if (std == V4L2_STD_NTSC_443)
-		return ADV7180_INPUT_CONTROL_NTSC_443;
+		return ADV7180_STD_NTSC_443;
 	if (std == V4L2_STD_PAL_N)
-		return ADV7180_INPUT_CONTROL_PAL_N;
+		return ADV7180_STD_PAL_N;
 	if (std == V4L2_STD_PAL_M)
-		return ADV7180_INPUT_CONTROL_PAL_M;
+		return ADV7180_STD_PAL_M;
 	if (std == V4L2_STD_PAL_Nc)
-		return ADV7180_INPUT_CONTROL_PAL_COMB_N;
+		return ADV7180_STD_PAL_COMB_N;
 
 	if (std & V4L2_STD_PAL)
-		return ADV7180_INPUT_CONTROL_PAL_BG;
+		return ADV7180_STD_PAL_BG;
 	if (std & V4L2_STD_NTSC)
-		return ADV7180_INPUT_CONTROL_NTSC_M;
+		return ADV7180_STD_NTSC_M;
 	if (std & V4L2_STD_SECAM)
-		return ADV7180_INPUT_CONTROL_PAL_SECAM;
+		return ADV7180_STD_PAL_SECAM;
 
 	return -EINVAL;
 }
@@ -274,19 +305,15 @@ static int adv7180_s_routing(struct v4l2_subdev *sd, u32 input,
 	if (ret)
 		return ret;
 
-	/* We cannot discriminate between LQFP and 40-pin LFCSP, so accept
-	 * all inputs and let the card driver take care of validation
-	 */
-	if ((input & ADV7180_INPUT_CONTROL_INSEL_MASK) != input)
+	if (input > 31 || !(BIT(input) & state->chip_info->valid_input_mask)) {
+		ret = -EINVAL;
 		goto out;
+	}
 
-	ret = adv7180_read(state, ADV7180_REG_INPUT_CONTROL);
-	if (ret < 0)
-		goto out;
+	ret = state->chip_info->select_input(state, input);
 
-	ret &= ~ADV7180_INPUT_CONTROL_INSEL_MASK;
-	ret = adv7180_write(state, ADV7180_REG_INPUT_CONTROL, ret | input);
-	state->input = input;
+	if (ret == 0)
+		state->input = input;
 out:
 	mutex_unlock(&state->mutex);
 	return ret;
@@ -309,9 +336,8 @@ static int adv7180_program_std(struct adv7180_state *state)
 	int ret;
 
 	if (state->autodetect) {
-		ret = adv7180_write(state, ADV7180_REG_INPUT_CONTROL,
-				    ADV7180_INPUT_CONTROL_AD_PAL_BG_NTSC_J_SECAM
-				    | state->input);
+		ret = adv7180_set_video_standard(state,
+			ADV7180_STD_AD_PAL_BG_NTSC_J_SECAM);
 		if (ret < 0)
 			return ret;
 
@@ -321,8 +347,7 @@ static int adv7180_program_std(struct adv7180_state *state)
 		if (ret < 0)
 			return ret;
 
-		ret = adv7180_write(state, ADV7180_REG_INPUT_CONTROL,
-				    ret | state->input);
+		ret = adv7180_set_video_standard(state, ret);
 		if (ret < 0)
 			return ret;
 	}
@@ -522,6 +547,7 @@ static const struct v4l2_subdev_video_ops adv7180_video_ops = {
 	.g_mbus_config = adv7180_g_mbus_config,
 };
 
+
 static const struct v4l2_subdev_core_ops adv7180_core_ops = {
 	.s_power = adv7180_s_power,
 };
@@ -555,33 +581,77 @@ static irqreturn_t adv7180_irq(int irq, void *devid)
 	return IRQ_HANDLED;
 }
 
-static int init_device(struct adv7180_state *state)
+static int adv7180_init(struct adv7180_state *state)
 {
 	int ret;
 
-	mutex_lock(&state->mutex);
-
-	adv7180_write(state, ADV7180_REG_PWR_MAN, ADV7180_PWR_MAN_RES);
-	usleep_range(2000, 10000);
-
-	ret = adv7180_program_std(state);
-	if (ret)
-		goto out_unlock;
-
 	/* ITU-R BT.656-4 compatible */
 	ret = adv7180_write(state, ADV7180_REG_EXTENDED_OUTPUT_CONTROL,
 			ADV7180_EXTENDED_OUTPUT_CONTROL_NTSCDIS);
 	if (ret < 0)
-		goto out_unlock;
+		return ret;
 
 	/* Manually set V bit end position in NTSC mode */
-	ret = adv7180_write(state, ADV7180_REG_NTSC_V_BIT_END,
+	return adv7180_write(state, ADV7180_REG_NTSC_V_BIT_END,
 					ADV7180_NTSC_V_BIT_END_MANUAL_NVEND);
+}
+
+static int adv7180_set_std(struct adv7180_state *state, unsigned int std)
+{
+	return adv7180_write(state, ADV7180_REG_INPUT_CONTROL,
+		(std << 4) | state->input);
+}
+
+static int adv7180_select_input(struct adv7180_state *state, unsigned int input)
+{
+	int ret;
+
+	ret = adv7180_read(state, ADV7180_REG_INPUT_CONTROL);
 	if (ret < 0)
+		return ret;
+
+	ret &= ~ADV7180_INPUT_CONTROL_INSEL_MASK;
+	ret |= input;
+	return adv7180_write(state, ADV7180_REG_INPUT_CONTROL, ret);
+}
+
+static const struct adv7180_chip_info adv7180_info = {
+	.flags = ADV7180_FLAG_RESET_POWERED,
+	/* We cannot discriminate between LQFP and 40-pin LFCSP, so accept
+	 * all inputs and let the card driver take care of validation
+	 */
+	.valid_input_mask = BIT(ADV7180_INPUT_CVBS_AIN1) |
+		BIT(ADV7180_INPUT_CVBS_AIN2) |
+		BIT(ADV7180_INPUT_CVBS_AIN3) |
+		BIT(ADV7180_INPUT_CVBS_AIN4) |
+		BIT(ADV7180_INPUT_CVBS_AIN5) |
+		BIT(ADV7180_INPUT_CVBS_AIN6) |
+		BIT(ADV7180_INPUT_SVIDEO_AIN1_AIN2) |
+		BIT(ADV7180_INPUT_SVIDEO_AIN3_AIN4) |
+		BIT(ADV7180_INPUT_SVIDEO_AIN5_AIN6) |
+		BIT(ADV7180_INPUT_YPRPB_AIN1_AIN2_AIN3) |
+		BIT(ADV7180_INPUT_YPRPB_AIN4_AIN5_AIN6),
+	.init = adv7180_init,
+	.set_std = adv7180_set_std,
+	.select_input = adv7180_select_input,
+};
+
+static int init_device(struct adv7180_state *state)
+{
+	int ret;
+
+	mutex_lock(&state->mutex);
+
+	adv7180_write(state, ADV7180_REG_PWR_MAN, ADV7180_PWR_MAN_RES);
+	usleep_range(2000, 10000);
+
+	ret = state->chip_info->init(state);
+	if (ret)
 		goto out_unlock;
 
-	/* read current norm */
-	__adv7180_status(state, NULL, &state->curr_norm);
+	ret = adv7180_program_std(state);
+	if (ret)
+		goto out_unlock;
 
 	/* register for interrupts */
 	if (state->irq > 0) {
@@ -638,11 +708,15 @@ static int adv7180_probe(struct i2c_client *client,
 	}
 
 	state->client = client;
+	state->chip_info = (struct adv7180_chip_info *)id->driver_data;
 
 	state->irq = client->irq;
 	mutex_init(&state->mutex);
 	state->autodetect = true;
-	state->powered = true;
+	if (state->chip_info->flags & ADV7180_FLAG_RESET_POWERED)
+		state->powered = true;
+	else
+		state->powered = false;
 	state->input = 0;
 	sd = &state->sd;
 	v4l2_i2c_subdev_init(sd, client, &adv7180_ops);
@@ -706,9 +780,10 @@ static int adv7180_remove(struct i2c_client *client)
 }
 
 static const struct i2c_device_id adv7180_id[] = {
-	{KBUILD_MODNAME, 0},
+	{ "adv7180", (kernel_ulong_t)&adv7180_info },
 	{},
 };
+MODULE_DEVICE_TABLE(i2c, adv7180_id);
 
 #ifdef CONFIG_PM_SLEEP
 static int adv7180_suspend(struct device *dev)
@@ -745,8 +820,6 @@ static SIMPLE_DEV_PM_OPS(adv7180_pm_ops, adv7180_suspend, adv7180_resume);
 #define ADV7180_PM_OPS NULL
 #endif
 
-MODULE_DEVICE_TABLE(i2c, adv7180_id);
-
 static struct i2c_driver adv7180_driver = {
 	.driver = {
 		   .owner = THIS_MODULE,
-- 
1.8.0

