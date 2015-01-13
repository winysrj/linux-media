Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-231.synserver.de ([212.40.185.231]:1063 "EHLO
	smtp-out-227.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751531AbbAMMB3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Jan 2015 07:01:29 -0500
From: Lars-Peter Clausen <lars@metafoo.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 05/16] [media] adv7180: Do implicit register paging
Date: Tue, 13 Jan 2015 13:01:10 +0100
Message-Id: <1421150481-30230-6-git-send-email-lars@metafoo.de>
In-Reply-To: <1421150481-30230-1-git-send-email-lars@metafoo.de>
References: <1421150481-30230-1-git-send-email-lars@metafoo.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ad7180 has multiple register pages which can be switched between by
writing to a register. Currently the driver manually switches between pages
whenever a register outside of the default register map is accessed and
switches back after it has been accessed. This is a bit tedious and also
potential source for bugs.

This patch adds two helper functions that take care of switching between
pages and reading/writing the register. The register numbers for registers
are updated to encode both the page (in the upper 8-bits) and the register
(in the lower 8-bits) numbers.

Having multiple pages means that a register access is not a single atomic
i2c_smbus_write_byte_data() or i2c_smbus_read_byte_data() call and we need
to make sure that concurrent register access does not race against each
other.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/media/i2c/adv7180.c | 206 ++++++++++++++++++++++----------------------
 1 file changed, 105 insertions(+), 101 deletions(-)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index 00ba845..cc05db9 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -31,7 +31,7 @@
 #include <media/v4l2-ctrls.h>
 #include <linux/mutex.h>
 
-#define ADV7180_REG_INPUT_CONTROL			0x00
+#define ADV7180_REG_INPUT_CONTROL			0x0000
 #define ADV7180_INPUT_CONTROL_AD_PAL_BG_NTSC_J_SECAM	0x00
 #define ADV7180_INPUT_CONTROL_AD_PAL_BG_NTSC_J_SECAM_PED 0x10
 #define ADV7180_INPUT_CONTROL_AD_PAL_N_NTSC_J_SECAM	0x20
@@ -50,28 +50,28 @@
 #define ADV7180_INPUT_CONTROL_PAL_SECAM_PED		0xf0
 #define ADV7180_INPUT_CONTROL_INSEL_MASK		0x0f
 
-#define ADV7180_REG_EXTENDED_OUTPUT_CONTROL		0x04
+#define ADV7180_REG_EXTENDED_OUTPUT_CONTROL		0x0004
 #define ADV7180_EXTENDED_OUTPUT_CONTROL_NTSCDIS		0xC5
 
 #define ADV7180_REG_AUTODETECT_ENABLE			0x07
 #define ADV7180_AUTODETECT_DEFAULT			0x7f
 /* Contrast */
-#define ADV7180_REG_CON		0x08	/*Unsigned */
+#define ADV7180_REG_CON		0x0008	/*Unsigned */
 #define ADV7180_CON_MIN		0
 #define ADV7180_CON_DEF		128
 #define ADV7180_CON_MAX		255
 /* Brightness*/
-#define ADV7180_REG_BRI		0x0a	/*Signed */
+#define ADV7180_REG_BRI		0x000a	/*Signed */
 #define ADV7180_BRI_MIN		-128
 #define ADV7180_BRI_DEF		0
 #define ADV7180_BRI_MAX		127
 /* Hue */
-#define ADV7180_REG_HUE		0x0b	/*Signed, inverted */
+#define ADV7180_REG_HUE		0x000b	/*Signed, inverted */
 #define ADV7180_HUE_MIN		-127
 #define ADV7180_HUE_DEF		0
 #define ADV7180_HUE_MAX		128
 
-#define ADV7180_REG_CTRL		0x0e
+#define ADV7180_REG_CTRL		0x000e
 #define ADV7180_CTRL_IRQ_SPACE		0x20
 
 #define ADV7180_REG_PWR_MAN		0x0f
@@ -79,7 +79,7 @@
 #define ADV7180_PWR_MAN_OFF		0x24
 #define ADV7180_PWR_MAN_RES		0x80
 
-#define ADV7180_REG_STATUS1		0x10
+#define ADV7180_REG_STATUS1		0x0010
 #define ADV7180_STATUS1_IN_LOCK		0x01
 #define ADV7180_STATUS1_AUTOD_MASK	0x70
 #define ADV7180_STATUS1_AUTOD_NTSM_M_J	0x00
@@ -91,33 +91,33 @@
 #define ADV7180_STATUS1_AUTOD_PAL_COMB	0x60
 #define ADV7180_STATUS1_AUTOD_SECAM_525	0x70
 
-#define ADV7180_REG_IDENT 0x11
+#define ADV7180_REG_IDENT 0x0011
 #define ADV7180_ID_7180 0x18
 
-#define ADV7180_REG_ICONF1		0x40
+#define ADV7180_REG_ICONF1		0x0040
 #define ADV7180_ICONF1_ACTIVE_LOW	0x01
 #define ADV7180_ICONF1_PSYNC_ONLY	0x10
 #define ADV7180_ICONF1_ACTIVE_TO_CLR	0xC0
 /* Saturation */
-#define ADV7180_REG_SD_SAT_CB	0xe3	/*Unsigned */
-#define ADV7180_REG_SD_SAT_CR	0xe4	/*Unsigned */
+#define ADV7180_REG_SD_SAT_CB	0x00e3	/*Unsigned */
+#define ADV7180_REG_SD_SAT_CR	0x00e4	/*Unsigned */
 #define ADV7180_SAT_MIN		0
 #define ADV7180_SAT_DEF		128
 #define ADV7180_SAT_MAX		255
 
 #define ADV7180_IRQ1_LOCK	0x01
 #define ADV7180_IRQ1_UNLOCK	0x02
-#define ADV7180_REG_ISR1	0x42
-#define ADV7180_REG_ICR1	0x43
-#define ADV7180_REG_IMR1	0x44
-#define ADV7180_REG_IMR2	0x48
+#define ADV7180_REG_ISR1	0x0042
+#define ADV7180_REG_ICR1	0x0043
+#define ADV7180_REG_IMR1	0x0044
+#define ADV7180_REG_IMR2	0x0048
 #define ADV7180_IRQ3_AD_CHANGE	0x08
-#define ADV7180_REG_ISR3	0x4A
-#define ADV7180_REG_ICR3	0x4B
-#define ADV7180_REG_IMR3	0x4C
+#define ADV7180_REG_ISR3	0x004A
+#define ADV7180_REG_ICR3	0x004B
+#define ADV7180_REG_IMR3	0x004C
 #define ADV7180_REG_IMR4	0x50
 
-#define ADV7180_REG_NTSC_V_BIT_END	0xE6
+#define ADV7180_REG_NTSC_V_BIT_END	0x00E6
 #define ADV7180_NTSC_V_BIT_END_MANUAL_NVEND	0x4F
 
 struct adv7180_state {
@@ -129,6 +129,9 @@ struct adv7180_state {
 	bool			autodetect;
 	bool			powered;
 	u8			input;
+
+	struct i2c_client	*client;
+	unsigned int		register_page;
 };
 
 static struct adv7180_state *ctrl_to_adv7180(struct v4l2_ctrl *ctrl)
@@ -136,6 +139,33 @@ static struct adv7180_state *ctrl_to_adv7180(struct v4l2_ctrl *ctrl)
 	return container_of(ctrl->handler, struct adv7180_state, ctrl_hdl);
 }
 
+static int adv7180_select_page(struct adv7180_state *state, unsigned int page)
+{
+	if (state->register_page != page) {
+		i2c_smbus_write_byte_data(state->client, ADV7180_REG_CTRL,
+			page);
+		state->register_page = page;
+	}
+
+	return 0;
+}
+
+static int adv7180_write(struct adv7180_state *state, unsigned int reg,
+	unsigned int value)
+{
+	lockdep_assert_held(&state->mutex);
+	adv7180_select_page(state, reg >> 8);
+	return i2c_smbus_write_byte_data(state->client, reg & 0xff, value);
+}
+
+static int adv7180_read(struct adv7180_state *state, unsigned int reg)
+{
+	lockdep_assert_held(&state->mutex);
+	adv7180_select_page(state, reg >> 8);
+	return i2c_smbus_read_byte_data(state->client, reg & 0xff);
+}
+
+
 static v4l2_std_id adv7180_std_to_v4l2(u8 status1)
 {
 	/* in case V4L2_IN_ST_NO_SIGNAL */
@@ -195,10 +225,10 @@ static u32 adv7180_status_to_v4l2(u8 status1)
 	return 0;
 }
 
-static int __adv7180_status(struct i2c_client *client, u32 *status,
+static int __adv7180_status(struct adv7180_state *state, u32 *status,
 			    v4l2_std_id *std)
 {
-	int status1 = i2c_smbus_read_byte_data(client, ADV7180_REG_STATUS1);
+	int status1 = adv7180_read(state, ADV7180_REG_STATUS1);
 
 	if (status1 < 0)
 		return status1;
@@ -227,7 +257,7 @@ static int adv7180_querystd(struct v4l2_subdev *sd, v4l2_std_id *std)
 	if (!state->autodetect || state->irq > 0)
 		*std = state->curr_norm;
 	else
-		err = __adv7180_status(v4l2_get_subdevdata(sd), NULL, std);
+		err = __adv7180_status(state, NULL, std);
 
 	mutex_unlock(&state->mutex);
 	return err;
@@ -238,7 +268,6 @@ static int adv7180_s_routing(struct v4l2_subdev *sd, u32 input,
 {
 	struct adv7180_state *state = to_state(sd);
 	int ret = mutex_lock_interruptible(&state->mutex);
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
 	if (ret)
 		return ret;
@@ -249,13 +278,12 @@ static int adv7180_s_routing(struct v4l2_subdev *sd, u32 input,
 	if ((input & ADV7180_INPUT_CONTROL_INSEL_MASK) != input)
 		goto out;
 
-	ret = i2c_smbus_read_byte_data(client, ADV7180_REG_INPUT_CONTROL);
+	ret = adv7180_read(state, ADV7180_REG_INPUT_CONTROL);
 	if (ret < 0)
 		goto out;
 
 	ret &= ~ADV7180_INPUT_CONTROL_INSEL_MASK;
-	ret = i2c_smbus_write_byte_data(client,
-					ADV7180_REG_INPUT_CONTROL, ret | input);
+	ret = adv7180_write(state, ADV7180_REG_INPUT_CONTROL, ret | input);
 	state->input = input;
 out:
 	mutex_unlock(&state->mutex);
@@ -269,7 +297,7 @@ static int adv7180_g_input_status(struct v4l2_subdev *sd, u32 *status)
 	if (ret)
 		return ret;
 
-	ret = __adv7180_status(v4l2_get_subdevdata(sd), status, NULL);
+	ret = __adv7180_status(state, status, NULL);
 	mutex_unlock(&state->mutex);
 	return ret;
 }
@@ -277,30 +305,27 @@ static int adv7180_g_input_status(struct v4l2_subdev *sd, u32 *status)
 static int adv7180_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
 {
 	struct adv7180_state *state = to_state(sd);
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	int ret = mutex_lock_interruptible(&state->mutex);
 	if (ret)
 		return ret;
 
 	/* all standards -> autodetect */
 	if (std == V4L2_STD_ALL) {
-		ret =
-		    i2c_smbus_write_byte_data(client, ADV7180_REG_INPUT_CONTROL,
-				ADV7180_INPUT_CONTROL_AD_PAL_BG_NTSC_J_SECAM
-					      | state->input);
+		ret = adv7180_write(state, ADV7180_REG_INPUT_CONTROL,
+				    ADV7180_INPUT_CONTROL_AD_PAL_BG_NTSC_J_SECAM
+				    | state->input);
 		if (ret < 0)
 			goto out;
 
-		__adv7180_status(client, NULL, &state->curr_norm);
+		__adv7180_status(state, NULL, &state->curr_norm);
 		state->autodetect = true;
 	} else {
 		ret = v4l2_std_to_adv7180(std);
 		if (ret < 0)
 			goto out;
 
-		ret = i2c_smbus_write_byte_data(client,
-						ADV7180_REG_INPUT_CONTROL,
-						ret | state->input);
+		ret = adv7180_write(state, ADV7180_REG_INPUT_CONTROL,
+				    ret | state->input);
 		if (ret < 0)
 			goto out;
 
@@ -313,8 +338,7 @@ out:
 	return ret;
 }
 
-static int adv7180_set_power(struct adv7180_state *state,
-	struct i2c_client *client, bool on)
+static int adv7180_set_power(struct adv7180_state *state, bool on)
 {
 	u8 val;
 
@@ -323,20 +347,19 @@ static int adv7180_set_power(struct adv7180_state *state,
 	else
 		val = ADV7180_PWR_MAN_OFF;
 
-	return i2c_smbus_write_byte_data(client, ADV7180_REG_PWR_MAN, val);
+	return adv7180_write(state, ADV7180_REG_PWR_MAN, val);
 }
 
 static int adv7180_s_power(struct v4l2_subdev *sd, int on)
 {
 	struct adv7180_state *state = to_state(sd);
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	int ret;
 
 	ret = mutex_lock_interruptible(&state->mutex);
 	if (ret)
 		return ret;
 
-	ret = adv7180_set_power(state, client, on);
+	ret = adv7180_set_power(state, on);
 	if (ret == 0)
 		state->powered = on;
 
@@ -347,7 +370,6 @@ static int adv7180_s_power(struct v4l2_subdev *sd, int on)
 static int adv7180_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct adv7180_state *state = ctrl_to_adv7180(ctrl);
-	struct i2c_client *client = v4l2_get_subdevdata(&state->sd);
 	int ret = mutex_lock_interruptible(&state->mutex);
 	int val;
 
@@ -356,26 +378,24 @@ static int adv7180_s_ctrl(struct v4l2_ctrl *ctrl)
 	val = ctrl->val;
 	switch (ctrl->id) {
 	case V4L2_CID_BRIGHTNESS:
-		ret = i2c_smbus_write_byte_data(client, ADV7180_REG_BRI, val);
+		ret = adv7180_write(state, ADV7180_REG_BRI, val);
 		break;
 	case V4L2_CID_HUE:
 		/*Hue is inverted according to HSL chart */
-		ret = i2c_smbus_write_byte_data(client, ADV7180_REG_HUE, -val);
+		ret = adv7180_write(state, ADV7180_REG_HUE, -val);
 		break;
 	case V4L2_CID_CONTRAST:
-		ret = i2c_smbus_write_byte_data(client, ADV7180_REG_CON, val);
+		ret = adv7180_write(state, ADV7180_REG_CON, val);
 		break;
 	case V4L2_CID_SATURATION:
 		/*
 		 *This could be V4L2_CID_BLUE_BALANCE/V4L2_CID_RED_BALANCE
 		 *Let's not confuse the user, everybody understands saturation
 		 */
-		ret = i2c_smbus_write_byte_data(client, ADV7180_REG_SD_SAT_CB,
-						val);
+		ret = adv7180_write(state, ADV7180_REG_SD_SAT_CB, val);
 		if (ret < 0)
 			break;
-		ret = i2c_smbus_write_byte_data(client, ADV7180_REG_SD_SAT_CR,
-						val);
+		ret = adv7180_write(state, ADV7180_REG_SD_SAT_CR, val);
 		break;
 	default:
 		ret = -EINVAL;
@@ -484,114 +504,96 @@ static const struct v4l2_subdev_ops adv7180_ops = {
 static irqreturn_t adv7180_irq(int irq, void *devid)
 {
 	struct adv7180_state *state = devid;
-	struct i2c_client *client = v4l2_get_subdevdata(&state->sd);
 	u8 isr3;
 
 	mutex_lock(&state->mutex);
-	i2c_smbus_write_byte_data(client, ADV7180_REG_CTRL,
-				  ADV7180_CTRL_IRQ_SPACE);
-	isr3 = i2c_smbus_read_byte_data(client, ADV7180_REG_ISR3);
+	isr3 = adv7180_read(state, ADV7180_REG_ISR3);
 	/* clear */
-	i2c_smbus_write_byte_data(client, ADV7180_REG_ICR3, isr3);
-	i2c_smbus_write_byte_data(client, ADV7180_REG_CTRL, 0);
+	adv7180_write(state, ADV7180_REG_ICR3, isr3);
 
 	if (isr3 & ADV7180_IRQ3_AD_CHANGE && state->autodetect)
-		__adv7180_status(client, NULL, &state->curr_norm);
+		__adv7180_status(state, NULL, &state->curr_norm);
 	mutex_unlock(&state->mutex);
 
 	return IRQ_HANDLED;
 }
 
-static int init_device(struct i2c_client *client, struct adv7180_state *state)
+static int init_device(struct adv7180_state *state)
 {
 	int ret;
 
+	mutex_lock(&state->mutex);
+
 	/* Initialize adv7180 */
 	/* Enable autodetection */
 	if (state->autodetect) {
-		ret =
-		    i2c_smbus_write_byte_data(client, ADV7180_REG_INPUT_CONTROL,
+		ret = adv7180_write(state, ADV7180_REG_INPUT_CONTROL,
 				ADV7180_INPUT_CONTROL_AD_PAL_BG_NTSC_J_SECAM
 					      | state->input);
 		if (ret < 0)
-			return ret;
+			goto out_unlock;
 
-		ret =
-		    i2c_smbus_write_byte_data(client,
-					      ADV7180_REG_AUTODETECT_ENABLE,
+		ret = adv7180_write(state, ADV7180_REG_AUTODETECT_ENABLE,
 					      ADV7180_AUTODETECT_DEFAULT);
 		if (ret < 0)
-			return ret;
+			goto out_unlock;
 	} else {
 		ret = v4l2_std_to_adv7180(state->curr_norm);
 		if (ret < 0)
-			return ret;
+			goto out_unlock;
 
-		ret =
-		    i2c_smbus_write_byte_data(client, ADV7180_REG_INPUT_CONTROL,
+		ret = adv7180_write(state, ADV7180_REG_INPUT_CONTROL,
 					      ret | state->input);
 		if (ret < 0)
-			return ret;
+			goto out_unlock;
 
 	}
 	/* ITU-R BT.656-4 compatible */
-	ret = i2c_smbus_write_byte_data(client,
-			ADV7180_REG_EXTENDED_OUTPUT_CONTROL,
+	ret = adv7180_write(state, ADV7180_REG_EXTENDED_OUTPUT_CONTROL,
 			ADV7180_EXTENDED_OUTPUT_CONTROL_NTSCDIS);
 	if (ret < 0)
-		return ret;
+		goto out_unlock;
 
 	/* Manually set V bit end position in NTSC mode */
-	ret = i2c_smbus_write_byte_data(client,
-					ADV7180_REG_NTSC_V_BIT_END,
+	ret = adv7180_write(state, ADV7180_REG_NTSC_V_BIT_END,
 					ADV7180_NTSC_V_BIT_END_MANUAL_NVEND);
 	if (ret < 0)
-		return ret;
+		goto out_unlock;
 
 	/* read current norm */
-	__adv7180_status(client, NULL, &state->curr_norm);
+	__adv7180_status(state, NULL, &state->curr_norm);
 
 	/* register for interrupts */
 	if (state->irq > 0) {
-		ret = i2c_smbus_write_byte_data(client, ADV7180_REG_CTRL,
-						ADV7180_CTRL_IRQ_SPACE);
-		if (ret < 0)
-			goto err;
-
 		/* config the Interrupt pin to be active low */
-		ret = i2c_smbus_write_byte_data(client, ADV7180_REG_ICONF1,
+		ret = adv7180_write(state, ADV7180_REG_ICONF1,
 						ADV7180_ICONF1_ACTIVE_LOW |
 						ADV7180_ICONF1_PSYNC_ONLY);
 		if (ret < 0)
-			goto err;
+			goto out_unlock;
 
-		ret = i2c_smbus_write_byte_data(client, ADV7180_REG_IMR1, 0);
+		ret = adv7180_write(state, ADV7180_REG_IMR1, 0);
 		if (ret < 0)
-			goto err;
+			goto out_unlock;
 
-		ret = i2c_smbus_write_byte_data(client, ADV7180_REG_IMR2, 0);
+		ret = adv7180_write(state, ADV7180_REG_IMR2, 0);
 		if (ret < 0)
-			goto err;
+			goto out_unlock;
 
 		/* enable AD change interrupts interrupts */
-		ret = i2c_smbus_write_byte_data(client, ADV7180_REG_IMR3,
+		ret = adv7180_write(state, ADV7180_REG_IMR3,
 						ADV7180_IRQ3_AD_CHANGE);
 		if (ret < 0)
-			goto err;
-
-		ret = i2c_smbus_write_byte_data(client, ADV7180_REG_IMR4, 0);
-		if (ret < 0)
-			goto err;
+			goto out_unlock;
 
-		ret = i2c_smbus_write_byte_data(client, ADV7180_REG_CTRL,
-						0);
+		ret = adv7180_write(state, ADV7180_REG_IMR4, 0);
 		if (ret < 0)
-			goto err;
+			goto out_unlock;
 	}
 
-	return 0;
+out_unlock:
+	mutex_unlock(&state->mutex);
 
-err:
 	return ret;
 }
 
@@ -615,6 +617,8 @@ static int adv7180_probe(struct i2c_client *client,
 		goto err;
 	}
 
+	state->client = client;
+
 	state->irq = client->irq;
 	mutex_init(&state->mutex);
 	state->autodetect = true;
@@ -626,7 +630,7 @@ static int adv7180_probe(struct i2c_client *client,
 	ret = adv7180_init_controls(state);
 	if (ret)
 		goto err_unreg_subdev;
-	ret = init_device(client, state);
+	ret = init_device(state);
 	if (ret)
 		goto err_free_ctrl;
 
@@ -682,7 +686,7 @@ static int adv7180_suspend(struct device *dev)
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 	struct adv7180_state *state = to_state(sd);
 
-	return adv7180_set_power(state, client, false);
+	return adv7180_set_power(state, false);
 }
 
 static int adv7180_resume(struct device *dev)
@@ -693,11 +697,11 @@ static int adv7180_resume(struct device *dev)
 	int ret;
 
 	if (state->powered) {
-		ret = adv7180_set_power(state, client, true);
+		ret = adv7180_set_power(state, true);
 		if (ret)
 			return ret;
 	}
-	ret = init_device(client, state);
+	ret = init_device(state);
 	if (ret < 0)
 		return ret;
 	return 0;
-- 
1.8.0

