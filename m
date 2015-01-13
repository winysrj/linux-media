Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-231.synserver.de ([212.40.185.231]:1047 "EHLO
	smtp-out-227.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751709AbbAMMBc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Jan 2015 07:01:32 -0500
From: Lars-Peter Clausen <lars@metafoo.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 11/16] [media] adv7180: Add support for the adv7280/adv7281/adv7282
Date: Tue, 13 Jan 2015 13:01:16 +0100
Message-Id: <1421150481-30230-12-git-send-email-lars@metafoo.de>
In-Reply-To: <1421150481-30230-1-git-send-email-lars@metafoo.de>
References: <1421150481-30230-1-git-send-email-lars@metafoo.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for the adv7280/adv7281/adv7282 devices to the
adv7180 driver. They are very similar to the adv7182, the main difference
from the drivers point of view are some different tuning constants for
improved video performance.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/media/i2c/adv7180.c | 56 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 54 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index 4e518d5..ea6695c 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -158,6 +158,7 @@
 struct adv7180_state;
 
 #define ADV7180_FLAG_RESET_POWERED	BIT(0)
+#define ADV7180_FLAG_V2			BIT(1)
 
 struct adv7180_chip_info {
 	unsigned int flags;
@@ -638,9 +639,18 @@ static int adv7180_select_input(struct adv7180_state *state, unsigned int input)
 
 static int adv7182_init(struct adv7180_state *state)
 {
+	if (state->chip_info->flags & ADV7180_FLAG_V2) {
+		/* ADI recommended writes for improved video quality */
+		adv7180_write(state, 0x0080, 0x51);
+		adv7180_write(state, 0x0081, 0x51);
+		adv7180_write(state, 0x0082, 0x68);
+		adv7180_write(state, 0x0004, 0x17);
+	} else {
+		adv7180_write(state, 0x0004, 0x07);
+	}
+
 	/* ADI required writes */
 	adv7180_write(state, 0x0003, 0x0c);
-	adv7180_write(state, 0x0004, 0x07);
 	adv7180_write(state, 0x0013, 0x00);
 	adv7180_write(state, 0x001d, 0x40);
 
@@ -697,6 +707,13 @@ static unsigned int adv7182_lbias_settings[][3] = {
 	[ADV7182_INPUT_TYPE_YPBPR] = { 0x0B, 0x4E, 0xC0 },
 };
 
+static unsigned int adv7280_lbias_settings[][3] = {
+	[ADV7182_INPUT_TYPE_CVBS] = { 0xCD, 0x4E, 0x80 },
+	[ADV7182_INPUT_TYPE_DIFF_CVBS] = { 0xC0, 0x4E, 0x80 },
+	[ADV7182_INPUT_TYPE_SVIDEO] = { 0x0B, 0xCE, 0x80 },
+	[ADV7182_INPUT_TYPE_YPBPR] = { 0x0B, 0x4E, 0xC0 },
+};
+
 static int adv7182_select_input(struct adv7180_state *state, unsigned int input)
 {
 	enum adv7182_input_type input_type;
@@ -725,7 +742,10 @@ static int adv7182_select_input(struct adv7180_state *state, unsigned int input)
 		break;
 	}
 
-	lbias = adv7182_lbias_settings[input_type];
+	if (state->chip_info->flags & ADV7180_FLAG_V2)
+		lbias = adv7280_lbias_settings[input_type];
+	else
+		lbias = adv7182_lbias_settings[input_type];
 
 	for (i = 0; i < ARRAY_SIZE(adv7182_lbias_settings[0]); i++)
 		adv7180_write(state, 0x0052 + i, lbias[i]);
@@ -784,6 +804,35 @@ static const struct adv7180_chip_info adv7182_info = {
 	.select_input = adv7182_select_input,
 };
 
+static const struct adv7180_chip_info adv7280_info = {
+	.flags = ADV7180_FLAG_V2,
+	.valid_input_mask = BIT(ADV7182_INPUT_CVBS_AIN1) |
+		BIT(ADV7182_INPUT_CVBS_AIN2) |
+		BIT(ADV7182_INPUT_CVBS_AIN3) |
+		BIT(ADV7182_INPUT_CVBS_AIN4) |
+		BIT(ADV7182_INPUT_SVIDEO_AIN1_AIN2) |
+		BIT(ADV7182_INPUT_SVIDEO_AIN3_AIN4) |
+		BIT(ADV7182_INPUT_YPRPB_AIN1_AIN2_AIN3),
+	.init = adv7182_init,
+	.set_std = adv7182_set_std,
+	.select_input = adv7182_select_input,
+};
+
+static const struct adv7180_chip_info adv7281_info = {
+	.flags = ADV7180_FLAG_V2,
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
 static int init_device(struct adv7180_state *state)
 {
 	int ret;
@@ -930,6 +979,9 @@ static int adv7180_remove(struct i2c_client *client)
 static const struct i2c_device_id adv7180_id[] = {
 	{ "adv7180", (kernel_ulong_t)&adv7180_info },
 	{ "adv7182", (kernel_ulong_t)&adv7182_info },
+	{ "adv7280", (kernel_ulong_t)&adv7280_info },
+	{ "adv7281", (kernel_ulong_t)&adv7281_info },
+	{ "adv7282", (kernel_ulong_t)&adv7281_info },
 	{},
 };
 MODULE_DEVICE_TABLE(i2c, adv7180_id);
-- 
1.8.0

