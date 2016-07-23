Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:34455 "EHLO
	mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbcGWRBA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Jul 2016 13:01:00 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: lars@metafoo.de
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v3 2/9] media: adv7180: define more registers
Date: Sat, 23 Jul 2016 10:00:42 -0700
Message-Id: <1469293249-6774-3-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1469293249-6774-1-git-send-email-steve_longerbeam@mentor.com>
References: <1469293249-6774-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace hard-coded addresses with new register macro defines. No
functional changes.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
Acked-by: Lars-Peter Clausen <lars@metafoo.de>

v3: no changes
---
 drivers/media/i2c/adv7180.c | 73 ++++++++++++++++++++++++++++++---------------
 1 file changed, 49 insertions(+), 24 deletions(-)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index 95cbc85..cb83ebb 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -56,10 +56,11 @@
 
 #define ADV7182_REG_INPUT_VIDSEL			0x0002
 
+#define ADV7180_REG_OUTPUT_CONTROL			0x0003
 #define ADV7180_REG_EXTENDED_OUTPUT_CONTROL		0x0004
 #define ADV7180_EXTENDED_OUTPUT_CONTROL_NTSCDIS		0xC5
 
-#define ADV7180_REG_AUTODETECT_ENABLE			0x07
+#define ADV7180_REG_AUTODETECT_ENABLE			0x0007
 #define ADV7180_AUTODETECT_DEFAULT			0x7f
 /* Contrast */
 #define ADV7180_REG_CON		0x0008	/*Unsigned */
@@ -100,6 +101,20 @@
 #define ADV7180_REG_IDENT 0x0011
 #define ADV7180_ID_7180 0x18
 
+#define ADV7180_REG_STATUS3		0x0013
+#define ADV7180_REG_ANALOG_CLAMP_CTL	0x0014
+#define ADV7180_REG_SHAP_FILTER_CTL_1	0x0017
+#define ADV7180_REG_CTRL_2		0x001d
+#define ADV7180_REG_VSYNC_FIELD_CTL_1	0x0031
+#define ADV7180_REG_MANUAL_WIN_CTL_1	0x003d
+#define ADV7180_REG_MANUAL_WIN_CTL_2	0x003e
+#define ADV7180_REG_MANUAL_WIN_CTL_3	0x003f
+#define ADV7180_REG_LOCK_CNT		0x0051
+#define ADV7180_REG_CVBS_TRIM		0x0052
+#define ADV7180_REG_CLAMP_ADJ		0x005a
+#define ADV7180_REG_RES_CIR		0x005f
+#define ADV7180_REG_DIFF_MODE		0x0060
+
 #define ADV7180_REG_ICONF1		0x2040
 #define ADV7180_ICONF1_ACTIVE_LOW	0x01
 #define ADV7180_ICONF1_PSYNC_ONLY	0x10
@@ -129,9 +144,15 @@
 #define ADV7180_REG_VPP_SLAVE_ADDR	0xFD
 #define ADV7180_REG_CSI_SLAVE_ADDR	0xFE
 
-#define ADV7180_REG_FLCONTROL 0x40e0
+#define ADV7180_REG_ACE_CTRL1		0x4080
+#define ADV7180_REG_ACE_CTRL5		0x4084
+#define ADV7180_REG_FLCONTROL		0x40e0
 #define ADV7180_FLCONTROL_FL_ENABLE 0x1
 
+#define ADV7180_REG_RST_CLAMP	0x809c
+#define ADV7180_REG_AGC_ADJ1	0x80b6
+#define ADV7180_REG_AGC_ADJ2	0x80c0
+
 #define ADV7180_CSI_REG_PWRDN	0x00
 #define ADV7180_CSI_PWRDN	0x80
 
@@ -886,16 +907,20 @@ static int adv7182_init(struct adv7180_state *state)
 
 	/* ADI required writes */
 	if (state->chip_info->flags & ADV7180_FLAG_MIPI_CSI2) {
-		adv7180_write(state, 0x0003, 0x4e);
-		adv7180_write(state, 0x0004, 0x57);
-		adv7180_write(state, 0x001d, 0xc0);
+		adv7180_write(state, ADV7180_REG_OUTPUT_CONTROL, 0x4e);
+		adv7180_write(state, ADV7180_REG_EXTENDED_OUTPUT_CONTROL, 0x57);
+		adv7180_write(state, ADV7180_REG_CTRL_2, 0xc0);
 	} else {
 		if (state->chip_info->flags & ADV7180_FLAG_V2)
-			adv7180_write(state, 0x0004, 0x17);
+			adv7180_write(state,
+				      ADV7180_REG_EXTENDED_OUTPUT_CONTROL,
+				      0x17);
 		else
-			adv7180_write(state, 0x0004, 0x07);
-		adv7180_write(state, 0x0003, 0x0c);
-		adv7180_write(state, 0x001d, 0x40);
+			adv7180_write(state,
+				      ADV7180_REG_EXTENDED_OUTPUT_CONTROL,
+				      0x07);
+		adv7180_write(state, ADV7180_REG_OUTPUT_CONTROL, 0x0c);
+		adv7180_write(state, ADV7180_REG_CTRL_2, 0x40);
 	}
 
 	adv7180_write(state, 0x0013, 0x00);
@@ -972,8 +997,8 @@ static int adv7182_select_input(struct adv7180_state *state, unsigned int input)
 		return ret;
 
 	/* Reset clamp circuitry - ADI recommended writes */
-	adv7180_write(state, 0x809c, 0x00);
-	adv7180_write(state, 0x809c, 0xff);
+	adv7180_write(state, ADV7180_REG_RST_CLAMP, 0x00);
+	adv7180_write(state, ADV7180_REG_RST_CLAMP, 0xff);
 
 	input_type = adv7182_get_input_type(input);
 
@@ -981,10 +1006,10 @@ static int adv7182_select_input(struct adv7180_state *state, unsigned int input)
 	case ADV7182_INPUT_TYPE_CVBS:
 	case ADV7182_INPUT_TYPE_DIFF_CVBS:
 		/* ADI recommends to use the SH1 filter */
-		adv7180_write(state, 0x0017, 0x41);
+		adv7180_write(state, ADV7180_REG_SHAP_FILTER_CTL_1, 0x41);
 		break;
 	default:
-		adv7180_write(state, 0x0017, 0x01);
+		adv7180_write(state, ADV7180_REG_SHAP_FILTER_CTL_1, 0x01);
 		break;
 	}
 
@@ -994,21 +1019,21 @@ static int adv7182_select_input(struct adv7180_state *state, unsigned int input)
 		lbias = adv7182_lbias_settings[input_type];
 
 	for (i = 0; i < ARRAY_SIZE(adv7182_lbias_settings[0]); i++)
-		adv7180_write(state, 0x0052 + i, lbias[i]);
+		adv7180_write(state, ADV7180_REG_CVBS_TRIM + i, lbias[i]);
 
 	if (input_type == ADV7182_INPUT_TYPE_DIFF_CVBS) {
 		/* ADI required writes to make differential CVBS work */
-		adv7180_write(state, 0x005f, 0xa8);
-		adv7180_write(state, 0x005a, 0x90);
-		adv7180_write(state, 0x0060, 0xb0);
-		adv7180_write(state, 0x80b6, 0x08);
-		adv7180_write(state, 0x80c0, 0xa0);
+		adv7180_write(state, ADV7180_REG_RES_CIR, 0xa8);
+		adv7180_write(state, ADV7180_REG_CLAMP_ADJ, 0x90);
+		adv7180_write(state, ADV7180_REG_DIFF_MODE, 0xb0);
+		adv7180_write(state, ADV7180_REG_AGC_ADJ1, 0x08);
+		adv7180_write(state, ADV7180_REG_AGC_ADJ2, 0xa0);
 	} else {
-		adv7180_write(state, 0x005f, 0xf0);
-		adv7180_write(state, 0x005a, 0xd0);
-		adv7180_write(state, 0x0060, 0x10);
-		adv7180_write(state, 0x80b6, 0x9c);
-		adv7180_write(state, 0x80c0, 0x00);
+		adv7180_write(state, ADV7180_REG_RES_CIR, 0xf0);
+		adv7180_write(state, ADV7180_REG_CLAMP_ADJ, 0xd0);
+		adv7180_write(state, ADV7180_REG_DIFF_MODE, 0x10);
+		adv7180_write(state, ADV7180_REG_AGC_ADJ1, 0x9c);
+		adv7180_write(state, ADV7180_REG_AGC_ADJ2, 0x00);
 	}
 
 	return 0;
-- 
1.9.1

