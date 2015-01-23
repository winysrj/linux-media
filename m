Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-190.synserver.de ([212.40.185.190]:1072 "EHLO
	smtp-out-190.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755777AbbAWPwr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2015 10:52:47 -0500
From: Lars-Peter Clausen <lars@metafoo.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Vladimir Barinov <vladimir.barinov@cogentembedded.com>,
	=?UTF-8?q?Richard=20R=C3=B6jfors?=
	<richard.rojfors@mocean-labs.com>,
	Federico Vaga <federico.vaga@gmail.com>,
	linux-media@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v2 10/15] [media] adv7180: Add support for the adv7182
Date: Fri, 23 Jan 2015 16:52:29 +0100
Message-Id: <1422028354-31891-11-git-send-email-lars@metafoo.de>
In-Reply-To: <1422028354-31891-1-git-send-email-lars@metafoo.de>
References: <1422028354-31891-1-git-send-email-lars@metafoo.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for the adv7182 to the adv7180 driver. The adv7182
is similar to the adv7180, the main difference from the driver's point of
view is how the video input and how the input format are selected.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7180.c | 149 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 149 insertions(+)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index e3f91d5..4e518d5 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -52,6 +52,8 @@
 #define ADV7180_REG_INPUT_CONTROL			0x0000
 #define ADV7180_INPUT_CONTROL_INSEL_MASK		0x0f
 
+#define ADV7182_REG_INPUT_VIDSEL			0x0002
+
 #define ADV7180_REG_EXTENDED_OUTPUT_CONTROL		0x0004
 #define ADV7180_EXTENDED_OUTPUT_CONTROL_NTSCDIS		0xC5
 
@@ -134,6 +136,25 @@
 #define ADV7180_INPUT_YPRPB_AIN1_AIN2_AIN3 0x09
 #define ADV7180_INPUT_YPRPB_AIN4_AIN5_AIN6 0x0a
 
+#define ADV7182_INPUT_CVBS_AIN1 0x00
+#define ADV7182_INPUT_CVBS_AIN2 0x01
+#define ADV7182_INPUT_CVBS_AIN3 0x02
+#define ADV7182_INPUT_CVBS_AIN4 0x03
+#define ADV7182_INPUT_CVBS_AIN5 0x04
+#define ADV7182_INPUT_CVBS_AIN6 0x05
+#define ADV7182_INPUT_CVBS_AIN7 0x06
+#define ADV7182_INPUT_CVBS_AIN8 0x07
+#define ADV7182_INPUT_SVIDEO_AIN1_AIN2 0x08
+#define ADV7182_INPUT_SVIDEO_AIN3_AIN4 0x09
+#define ADV7182_INPUT_SVIDEO_AIN5_AIN6 0x0a
+#define ADV7182_INPUT_SVIDEO_AIN7_AIN8 0x0b
+#define ADV7182_INPUT_YPRPB_AIN1_AIN2_AIN3 0x0c
+#define ADV7182_INPUT_YPRPB_AIN4_AIN5_AIN6 0x0d
+#define ADV7182_INPUT_DIFF_CVBS_AIN1_AIN2 0x0e
+#define ADV7182_INPUT_DIFF_CVBS_AIN3_AIN4 0x0f
+#define ADV7182_INPUT_DIFF_CVBS_AIN5_AIN6 0x10
+#define ADV7182_INPUT_DIFF_CVBS_AIN7_AIN8 0x11
+
 struct adv7180_state;
 
 #define ADV7180_FLAG_RESET_POWERED	BIT(0)
@@ -615,6 +636,118 @@ static int adv7180_select_input(struct adv7180_state *state, unsigned int input)
 	return adv7180_write(state, ADV7180_REG_INPUT_CONTROL, ret);
 }
 
+static int adv7182_init(struct adv7180_state *state)
+{
+	/* ADI required writes */
+	adv7180_write(state, 0x0003, 0x0c);
+	adv7180_write(state, 0x0004, 0x07);
+	adv7180_write(state, 0x0013, 0x00);
+	adv7180_write(state, 0x001d, 0x40);
+
+	return 0;
+}
+
+static int adv7182_set_std(struct adv7180_state *state, unsigned int std)
+{
+	return adv7180_write(state, ADV7182_REG_INPUT_VIDSEL, std << 4);
+}
+
+enum adv7182_input_type {
+	ADV7182_INPUT_TYPE_CVBS,
+	ADV7182_INPUT_TYPE_DIFF_CVBS,
+	ADV7182_INPUT_TYPE_SVIDEO,
+	ADV7182_INPUT_TYPE_YPBPR,
+};
+
+static enum adv7182_input_type adv7182_get_input_type(unsigned int input)
+{
+	switch (input) {
+	case ADV7182_INPUT_CVBS_AIN1:
+	case ADV7182_INPUT_CVBS_AIN2:
+	case ADV7182_INPUT_CVBS_AIN3:
+	case ADV7182_INPUT_CVBS_AIN4:
+	case ADV7182_INPUT_CVBS_AIN5:
+	case ADV7182_INPUT_CVBS_AIN6:
+	case ADV7182_INPUT_CVBS_AIN7:
+	case ADV7182_INPUT_CVBS_AIN8:
+		return ADV7182_INPUT_TYPE_CVBS;
+	case ADV7182_INPUT_SVIDEO_AIN1_AIN2:
+	case ADV7182_INPUT_SVIDEO_AIN3_AIN4:
+	case ADV7182_INPUT_SVIDEO_AIN5_AIN6:
+	case ADV7182_INPUT_SVIDEO_AIN7_AIN8:
+		return ADV7182_INPUT_TYPE_SVIDEO;
+	case ADV7182_INPUT_YPRPB_AIN1_AIN2_AIN3:
+	case ADV7182_INPUT_YPRPB_AIN4_AIN5_AIN6:
+		return ADV7182_INPUT_TYPE_YPBPR;
+	case ADV7182_INPUT_DIFF_CVBS_AIN1_AIN2:
+	case ADV7182_INPUT_DIFF_CVBS_AIN3_AIN4:
+	case ADV7182_INPUT_DIFF_CVBS_AIN5_AIN6:
+	case ADV7182_INPUT_DIFF_CVBS_AIN7_AIN8:
+		return ADV7182_INPUT_TYPE_DIFF_CVBS;
+	default: /* Will never happen */
+		return 0;
+	}
+}
+
+/* ADI recommended writes to registers 0x52, 0x53, 0x54 */
+static unsigned int adv7182_lbias_settings[][3] = {
+	[ADV7182_INPUT_TYPE_CVBS] = { 0xCB, 0x4E, 0x80 },
+	[ADV7182_INPUT_TYPE_DIFF_CVBS] = { 0xC0, 0x4E, 0x80 },
+	[ADV7182_INPUT_TYPE_SVIDEO] = { 0x0B, 0xCE, 0x80 },
+	[ADV7182_INPUT_TYPE_YPBPR] = { 0x0B, 0x4E, 0xC0 },
+};
+
+static int adv7182_select_input(struct adv7180_state *state, unsigned int input)
+{
+	enum adv7182_input_type input_type;
+	unsigned int *lbias;
+	unsigned int i;
+	int ret;
+
+	ret = adv7180_write(state, ADV7180_REG_INPUT_CONTROL, input);
+	if (ret)
+		return ret;
+
+	/* Reset clamp circuitry - ADI recommended writes */
+	adv7180_write(state, 0x809c, 0x00);
+	adv7180_write(state, 0x809c, 0xff);
+
+	input_type = adv7182_get_input_type(input);
+
+	switch (input_type) {
+	case ADV7182_INPUT_TYPE_CVBS:
+	case ADV7182_INPUT_TYPE_DIFF_CVBS:
+		/* ADI recommends to use the SH1 filter */
+		adv7180_write(state, 0x0017, 0x41);
+		break;
+	default:
+		adv7180_write(state, 0x0017, 0x01);
+		break;
+	}
+
+	lbias = adv7182_lbias_settings[input_type];
+
+	for (i = 0; i < ARRAY_SIZE(adv7182_lbias_settings[0]); i++)
+		adv7180_write(state, 0x0052 + i, lbias[i]);
+
+	if (input_type == ADV7182_INPUT_TYPE_DIFF_CVBS) {
+		/* ADI required writes to make differential CVBS work */
+		adv7180_write(state, 0x005f, 0xa8);
+		adv7180_write(state, 0x005a, 0x90);
+		adv7180_write(state, 0x0060, 0xb0);
+		adv7180_write(state, 0x80b6, 0x08);
+		adv7180_write(state, 0x80c0, 0xa0);
+	} else {
+		adv7180_write(state, 0x005f, 0xf0);
+		adv7180_write(state, 0x005a, 0xd0);
+		adv7180_write(state, 0x0060, 0x10);
+		adv7180_write(state, 0x80b6, 0x9c);
+		adv7180_write(state, 0x80c0, 0x00);
+	}
+
+	return 0;
+}
+
 static const struct adv7180_chip_info adv7180_info = {
 	.flags = ADV7180_FLAG_RESET_POWERED,
 	/* We cannot discriminate between LQFP and 40-pin LFCSP, so accept
@@ -636,6 +769,21 @@ static const struct adv7180_chip_info adv7180_info = {
 	.select_input = adv7180_select_input,
 };
 
+static const struct adv7180_chip_info adv7182_info = {
+	.valid_input_mask = BIT(ADV7182_INPUT_CVBS_AIN1) |
+		BIT(ADV7182_INPUT_CVBS_AIN2) |
+		BIT(ADV7182_INPUT_CVBS_AIN3) |
+		BIT(ADV7182_INPUT_CVBS_AIN4) |
+		BIT(ADV7182_INPUT_SVIDEO_AIN1_AIN2) |
+		BIT(ADV7182_INPUT_SVIDEO_AIN3_AIN4) |
+		BIT(ADV7182_INPUT_YPRPB_AIN1_AIN2_AIN3) |
+		BIT(ADV7182_INPUT_DIFF_CVBS_AIN1_AIN2) |
+		BIT(ADV7182_INPUT_DIFF_CVBS_AIN3_AIN4),
+	.init = adv7182_init,
+	.set_std = adv7182_set_std,
+	.select_input = adv7182_select_input,
+};
+
 static int init_device(struct adv7180_state *state)
 {
 	int ret;
@@ -781,6 +929,7 @@ static int adv7180_remove(struct i2c_client *client)
 
 static const struct i2c_device_id adv7180_id[] = {
 	{ "adv7180", (kernel_ulong_t)&adv7180_info },
+	{ "adv7182", (kernel_ulong_t)&adv7182_info },
 	{},
 };
 MODULE_DEVICE_TABLE(i2c, adv7180_id);
-- 
1.8.0

