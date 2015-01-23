Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-190.synserver.de ([212.40.185.190]:1105 "EHLO
	smtp-out-190.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755694AbbAWPwl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2015 10:52:41 -0500
From: Lars-Peter Clausen <lars@metafoo.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Vladimir Barinov <vladimir.barinov@cogentembedded.com>,
	=?UTF-8?q?Richard=20R=C3=B6jfors?=
	<richard.rojfors@mocean-labs.com>,
	Federico Vaga <federico.vaga@gmail.com>,
	linux-media@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v2 04/15] [media] adv7180: Cleanup register define naming
Date: Fri, 23 Jan 2015 16:52:23 +0100
Message-Id: <1422028354-31891-5-git-send-email-lars@metafoo.de>
In-Reply-To: <1422028354-31891-1-git-send-email-lars@metafoo.de>
References: <1422028354-31891-1-git-send-email-lars@metafoo.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Consistently prefix register defines with ADV7180_REG. Also remove the "ADI"
from register names, the ADV7180 prefix should provide enough of a namespace
separation.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7180.c | 105 ++++++++++++++++++++++----------------------
 1 file changed, 52 insertions(+), 53 deletions(-)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index f2508abe..00ba845 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -31,7 +31,7 @@
 #include <media/v4l2-ctrls.h>
 #include <linux/mutex.h>
 
-#define ADV7180_INPUT_CONTROL_REG			0x00
+#define ADV7180_REG_INPUT_CONTROL			0x00
 #define ADV7180_INPUT_CONTROL_AD_PAL_BG_NTSC_J_SECAM	0x00
 #define ADV7180_INPUT_CONTROL_AD_PAL_BG_NTSC_J_SECAM_PED 0x10
 #define ADV7180_INPUT_CONTROL_AD_PAL_N_NTSC_J_SECAM	0x20
@@ -50,36 +50,36 @@
 #define ADV7180_INPUT_CONTROL_PAL_SECAM_PED		0xf0
 #define ADV7180_INPUT_CONTROL_INSEL_MASK		0x0f
 
-#define ADV7180_EXTENDED_OUTPUT_CONTROL_REG		0x04
+#define ADV7180_REG_EXTENDED_OUTPUT_CONTROL		0x04
 #define ADV7180_EXTENDED_OUTPUT_CONTROL_NTSCDIS		0xC5
 
-#define ADV7180_AUTODETECT_ENABLE_REG			0x07
+#define ADV7180_REG_AUTODETECT_ENABLE			0x07
 #define ADV7180_AUTODETECT_DEFAULT			0x7f
 /* Contrast */
-#define ADV7180_CON_REG		0x08	/*Unsigned */
+#define ADV7180_REG_CON		0x08	/*Unsigned */
 #define ADV7180_CON_MIN		0
 #define ADV7180_CON_DEF		128
 #define ADV7180_CON_MAX		255
 /* Brightness*/
-#define ADV7180_BRI_REG		0x0a	/*Signed */
+#define ADV7180_REG_BRI		0x0a	/*Signed */
 #define ADV7180_BRI_MIN		-128
 #define ADV7180_BRI_DEF		0
 #define ADV7180_BRI_MAX		127
 /* Hue */
-#define ADV7180_HUE_REG		0x0b	/*Signed, inverted */
+#define ADV7180_REG_HUE		0x0b	/*Signed, inverted */
 #define ADV7180_HUE_MIN		-127
 #define ADV7180_HUE_DEF		0
 #define ADV7180_HUE_MAX		128
 
-#define ADV7180_ADI_CTRL_REG				0x0e
-#define ADV7180_ADI_CTRL_IRQ_SPACE			0x20
+#define ADV7180_REG_CTRL		0x0e
+#define ADV7180_CTRL_IRQ_SPACE		0x20
 
-#define ADV7180_PWR_MAN_REG		0x0f
+#define ADV7180_REG_PWR_MAN		0x0f
 #define ADV7180_PWR_MAN_ON		0x04
 #define ADV7180_PWR_MAN_OFF		0x24
 #define ADV7180_PWR_MAN_RES		0x80
 
-#define ADV7180_STATUS1_REG				0x10
+#define ADV7180_REG_STATUS1		0x10
 #define ADV7180_STATUS1_IN_LOCK		0x01
 #define ADV7180_STATUS1_AUTOD_MASK	0x70
 #define ADV7180_STATUS1_AUTOD_NTSM_M_J	0x00
@@ -91,33 +91,33 @@
 #define ADV7180_STATUS1_AUTOD_PAL_COMB	0x60
 #define ADV7180_STATUS1_AUTOD_SECAM_525	0x70
 
-#define ADV7180_IDENT_REG 0x11
+#define ADV7180_REG_IDENT 0x11
 #define ADV7180_ID_7180 0x18
 
-#define ADV7180_ICONF1_ADI		0x40
+#define ADV7180_REG_ICONF1		0x40
 #define ADV7180_ICONF1_ACTIVE_LOW	0x01
 #define ADV7180_ICONF1_PSYNC_ONLY	0x10
 #define ADV7180_ICONF1_ACTIVE_TO_CLR	0xC0
 /* Saturation */
-#define ADV7180_SD_SAT_CB_REG	0xe3	/*Unsigned */
-#define ADV7180_SD_SAT_CR_REG	0xe4	/*Unsigned */
+#define ADV7180_REG_SD_SAT_CB	0xe3	/*Unsigned */
+#define ADV7180_REG_SD_SAT_CR	0xe4	/*Unsigned */
 #define ADV7180_SAT_MIN		0
 #define ADV7180_SAT_DEF		128
 #define ADV7180_SAT_MAX		255
 
 #define ADV7180_IRQ1_LOCK	0x01
 #define ADV7180_IRQ1_UNLOCK	0x02
-#define ADV7180_ISR1_ADI	0x42
-#define ADV7180_ICR1_ADI	0x43
-#define ADV7180_IMR1_ADI	0x44
-#define ADV7180_IMR2_ADI	0x48
+#define ADV7180_REG_ISR1	0x42
+#define ADV7180_REG_ICR1	0x43
+#define ADV7180_REG_IMR1	0x44
+#define ADV7180_REG_IMR2	0x48
 #define ADV7180_IRQ3_AD_CHANGE	0x08
-#define ADV7180_ISR3_ADI	0x4A
-#define ADV7180_ICR3_ADI	0x4B
-#define ADV7180_IMR3_ADI	0x4C
-#define ADV7180_IMR4_ADI	0x50
+#define ADV7180_REG_ISR3	0x4A
+#define ADV7180_REG_ICR3	0x4B
+#define ADV7180_REG_IMR3	0x4C
+#define ADV7180_REG_IMR4	0x50
 
-#define ADV7180_NTSC_V_BIT_END_REG	0xE6
+#define ADV7180_REG_NTSC_V_BIT_END	0xE6
 #define ADV7180_NTSC_V_BIT_END_MANUAL_NVEND	0x4F
 
 struct adv7180_state {
@@ -198,7 +198,7 @@ static u32 adv7180_status_to_v4l2(u8 status1)
 static int __adv7180_status(struct i2c_client *client, u32 *status,
 			    v4l2_std_id *std)
 {
-	int status1 = i2c_smbus_read_byte_data(client, ADV7180_STATUS1_REG);
+	int status1 = i2c_smbus_read_byte_data(client, ADV7180_REG_STATUS1);
 
 	if (status1 < 0)
 		return status1;
@@ -249,14 +249,13 @@ static int adv7180_s_routing(struct v4l2_subdev *sd, u32 input,
 	if ((input & ADV7180_INPUT_CONTROL_INSEL_MASK) != input)
 		goto out;
 
-	ret = i2c_smbus_read_byte_data(client, ADV7180_INPUT_CONTROL_REG);
-
+	ret = i2c_smbus_read_byte_data(client, ADV7180_REG_INPUT_CONTROL);
 	if (ret < 0)
 		goto out;
 
 	ret &= ~ADV7180_INPUT_CONTROL_INSEL_MASK;
 	ret = i2c_smbus_write_byte_data(client,
-					ADV7180_INPUT_CONTROL_REG, ret | input);
+					ADV7180_REG_INPUT_CONTROL, ret | input);
 	state->input = input;
 out:
 	mutex_unlock(&state->mutex);
@@ -286,7 +285,7 @@ static int adv7180_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
 	/* all standards -> autodetect */
 	if (std == V4L2_STD_ALL) {
 		ret =
-		    i2c_smbus_write_byte_data(client, ADV7180_INPUT_CONTROL_REG,
+		    i2c_smbus_write_byte_data(client, ADV7180_REG_INPUT_CONTROL,
 				ADV7180_INPUT_CONTROL_AD_PAL_BG_NTSC_J_SECAM
 					      | state->input);
 		if (ret < 0)
@@ -300,7 +299,7 @@ static int adv7180_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
 			goto out;
 
 		ret = i2c_smbus_write_byte_data(client,
-						ADV7180_INPUT_CONTROL_REG,
+						ADV7180_REG_INPUT_CONTROL,
 						ret | state->input);
 		if (ret < 0)
 			goto out;
@@ -324,7 +323,7 @@ static int adv7180_set_power(struct adv7180_state *state,
 	else
 		val = ADV7180_PWR_MAN_OFF;
 
-	return i2c_smbus_write_byte_data(client, ADV7180_PWR_MAN_REG, val);
+	return i2c_smbus_write_byte_data(client, ADV7180_REG_PWR_MAN, val);
 }
 
 static int adv7180_s_power(struct v4l2_subdev *sd, int on)
@@ -357,25 +356,25 @@ static int adv7180_s_ctrl(struct v4l2_ctrl *ctrl)
 	val = ctrl->val;
 	switch (ctrl->id) {
 	case V4L2_CID_BRIGHTNESS:
-		ret = i2c_smbus_write_byte_data(client, ADV7180_BRI_REG, val);
+		ret = i2c_smbus_write_byte_data(client, ADV7180_REG_BRI, val);
 		break;
 	case V4L2_CID_HUE:
 		/*Hue is inverted according to HSL chart */
-		ret = i2c_smbus_write_byte_data(client, ADV7180_HUE_REG, -val);
+		ret = i2c_smbus_write_byte_data(client, ADV7180_REG_HUE, -val);
 		break;
 	case V4L2_CID_CONTRAST:
-		ret = i2c_smbus_write_byte_data(client, ADV7180_CON_REG, val);
+		ret = i2c_smbus_write_byte_data(client, ADV7180_REG_CON, val);
 		break;
 	case V4L2_CID_SATURATION:
 		/*
 		 *This could be V4L2_CID_BLUE_BALANCE/V4L2_CID_RED_BALANCE
 		 *Let's not confuse the user, everybody understands saturation
 		 */
-		ret = i2c_smbus_write_byte_data(client, ADV7180_SD_SAT_CB_REG,
+		ret = i2c_smbus_write_byte_data(client, ADV7180_REG_SD_SAT_CB,
 						val);
 		if (ret < 0)
 			break;
-		ret = i2c_smbus_write_byte_data(client, ADV7180_SD_SAT_CR_REG,
+		ret = i2c_smbus_write_byte_data(client, ADV7180_REG_SD_SAT_CR,
 						val);
 		break;
 	default:
@@ -489,12 +488,12 @@ static irqreturn_t adv7180_irq(int irq, void *devid)
 	u8 isr3;
 
 	mutex_lock(&state->mutex);
-	i2c_smbus_write_byte_data(client, ADV7180_ADI_CTRL_REG,
-				  ADV7180_ADI_CTRL_IRQ_SPACE);
-	isr3 = i2c_smbus_read_byte_data(client, ADV7180_ISR3_ADI);
+	i2c_smbus_write_byte_data(client, ADV7180_REG_CTRL,
+				  ADV7180_CTRL_IRQ_SPACE);
+	isr3 = i2c_smbus_read_byte_data(client, ADV7180_REG_ISR3);
 	/* clear */
-	i2c_smbus_write_byte_data(client, ADV7180_ICR3_ADI, isr3);
-	i2c_smbus_write_byte_data(client, ADV7180_ADI_CTRL_REG, 0);
+	i2c_smbus_write_byte_data(client, ADV7180_REG_ICR3, isr3);
+	i2c_smbus_write_byte_data(client, ADV7180_REG_CTRL, 0);
 
 	if (isr3 & ADV7180_IRQ3_AD_CHANGE && state->autodetect)
 		__adv7180_status(client, NULL, &state->curr_norm);
@@ -511,7 +510,7 @@ static int init_device(struct i2c_client *client, struct adv7180_state *state)
 	/* Enable autodetection */
 	if (state->autodetect) {
 		ret =
-		    i2c_smbus_write_byte_data(client, ADV7180_INPUT_CONTROL_REG,
+		    i2c_smbus_write_byte_data(client, ADV7180_REG_INPUT_CONTROL,
 				ADV7180_INPUT_CONTROL_AD_PAL_BG_NTSC_J_SECAM
 					      | state->input);
 		if (ret < 0)
@@ -519,7 +518,7 @@ static int init_device(struct i2c_client *client, struct adv7180_state *state)
 
 		ret =
 		    i2c_smbus_write_byte_data(client,
-					      ADV7180_AUTODETECT_ENABLE_REG,
+					      ADV7180_REG_AUTODETECT_ENABLE,
 					      ADV7180_AUTODETECT_DEFAULT);
 		if (ret < 0)
 			return ret;
@@ -529,7 +528,7 @@ static int init_device(struct i2c_client *client, struct adv7180_state *state)
 			return ret;
 
 		ret =
-		    i2c_smbus_write_byte_data(client, ADV7180_INPUT_CONTROL_REG,
+		    i2c_smbus_write_byte_data(client, ADV7180_REG_INPUT_CONTROL,
 					      ret | state->input);
 		if (ret < 0)
 			return ret;
@@ -537,14 +536,14 @@ static int init_device(struct i2c_client *client, struct adv7180_state *state)
 	}
 	/* ITU-R BT.656-4 compatible */
 	ret = i2c_smbus_write_byte_data(client,
-			ADV7180_EXTENDED_OUTPUT_CONTROL_REG,
+			ADV7180_REG_EXTENDED_OUTPUT_CONTROL,
 			ADV7180_EXTENDED_OUTPUT_CONTROL_NTSCDIS);
 	if (ret < 0)
 		return ret;
 
 	/* Manually set V bit end position in NTSC mode */
 	ret = i2c_smbus_write_byte_data(client,
-					ADV7180_NTSC_V_BIT_END_REG,
+					ADV7180_REG_NTSC_V_BIT_END,
 					ADV7180_NTSC_V_BIT_END_MANUAL_NVEND);
 	if (ret < 0)
 		return ret;
@@ -554,37 +553,37 @@ static int init_device(struct i2c_client *client, struct adv7180_state *state)
 
 	/* register for interrupts */
 	if (state->irq > 0) {
-		ret = i2c_smbus_write_byte_data(client, ADV7180_ADI_CTRL_REG,
-						ADV7180_ADI_CTRL_IRQ_SPACE);
+		ret = i2c_smbus_write_byte_data(client, ADV7180_REG_CTRL,
+						ADV7180_CTRL_IRQ_SPACE);
 		if (ret < 0)
 			goto err;
 
 		/* config the Interrupt pin to be active low */
-		ret = i2c_smbus_write_byte_data(client, ADV7180_ICONF1_ADI,
+		ret = i2c_smbus_write_byte_data(client, ADV7180_REG_ICONF1,
 						ADV7180_ICONF1_ACTIVE_LOW |
 						ADV7180_ICONF1_PSYNC_ONLY);
 		if (ret < 0)
 			goto err;
 
-		ret = i2c_smbus_write_byte_data(client, ADV7180_IMR1_ADI, 0);
+		ret = i2c_smbus_write_byte_data(client, ADV7180_REG_IMR1, 0);
 		if (ret < 0)
 			goto err;
 
-		ret = i2c_smbus_write_byte_data(client, ADV7180_IMR2_ADI, 0);
+		ret = i2c_smbus_write_byte_data(client, ADV7180_REG_IMR2, 0);
 		if (ret < 0)
 			goto err;
 
 		/* enable AD change interrupts interrupts */
-		ret = i2c_smbus_write_byte_data(client, ADV7180_IMR3_ADI,
+		ret = i2c_smbus_write_byte_data(client, ADV7180_REG_IMR3,
 						ADV7180_IRQ3_AD_CHANGE);
 		if (ret < 0)
 			goto err;
 
-		ret = i2c_smbus_write_byte_data(client, ADV7180_IMR4_ADI, 0);
+		ret = i2c_smbus_write_byte_data(client, ADV7180_REG_IMR4, 0);
 		if (ret < 0)
 			goto err;
 
-		ret = i2c_smbus_write_byte_data(client, ADV7180_ADI_CTRL_REG,
+		ret = i2c_smbus_write_byte_data(client, ADV7180_REG_CTRL,
 						0);
 		if (ret < 0)
 			goto err;
-- 
1.8.0

