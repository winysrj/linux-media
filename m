Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:61564 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab1HDHOX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Aug 2011 03:14:23 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 04/21] [staging] tm6000: Use correct input in radio mode.
Date: Thu,  4 Aug 2011 09:14:02 +0200
Message-Id: <1312442059-23935-5-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1312442059-23935-1-git-send-email-thierry.reding@avionic-design.de>
References: <1312442059-23935-1-git-send-email-thierry.reding@avionic-design.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In radio mode, the correct input is rinput. The pseudo index 5 is used
but cannot be used to index the vinput array because that only has 3
elements.
---
 drivers/staging/tm6000/tm6000-stds.c |   28 +++++++++++++++-------------
 1 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-stds.c b/drivers/staging/tm6000/tm6000-stds.c
index bebf1f3..cd69626 100644
--- a/drivers/staging/tm6000/tm6000-stds.c
+++ b/drivers/staging/tm6000/tm6000-stds.c
@@ -525,6 +525,7 @@ static int tm6000_load_std(struct tm6000_core *dev,
 
 int tm6000_set_standard(struct tm6000_core *dev)
 {
+	struct tm6000_input *input;
 	int i, rc = 0;
 	u8 reg_07_fe = 0x8a;
 	u8 reg_08_f1 = 0xfc;
@@ -533,12 +534,13 @@ int tm6000_set_standard(struct tm6000_core *dev)
 
 	tm6000_get_std_res(dev);
 
-	if (dev->radio) {
-		/* todo */
-	}
+	if (!dev->radio)
+		input = &dev->vinput[dev->input];
+	else
+		input = &dev->rinput;
 
 	if (dev->dev_type == TM6010) {
-		switch (dev->vinput[dev->input].vmux) {
+		switch (input->vmux) {
 		case TM6000_VMUX_VIDEO_A:
 			tm6000_set_reg(dev, TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf4);
 			tm6000_set_reg(dev, TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf1);
@@ -567,7 +569,7 @@ int tm6000_set_standard(struct tm6000_core *dev)
 		default:
 			break;
 		}
-		switch (dev->vinput[dev->input].amux) {
+		switch (input->amux) {
 		case TM6000_AMUX_ADC1:
 			tm6000_set_reg_mask(dev, TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG,
 				0x00, 0x0f);
@@ -602,32 +604,32 @@ int tm6000_set_standard(struct tm6000_core *dev)
 		tm6000_set_reg(dev, TM6010_REQ08_RF1_AADC_POWER_DOWN, reg_08_f1);
 		tm6000_set_reg(dev, TM6010_REQ07_RFE_POWER_DOWN, reg_07_fe);
 	} else {
-		switch (dev->vinput[dev->input].vmux) {
+		switch (input->vmux) {
 		case TM6000_VMUX_VIDEO_A:
 			tm6000_set_reg(dev, TM6000_REQ07_RE3_VADC_INP_LPF_SEL1, 0x10);
 			tm6000_set_reg(dev, TM6000_REQ07_RE5_VADC_INP_LPF_SEL2, 0x00);
 			tm6000_set_reg(dev, TM6000_REQ07_RE8_VADC_PWDOWN_CTL, 0x0f);
 			tm6000_set_reg(dev,
-			    REQ_03_SET_GET_MCU_PIN, dev->vinput[dev->input].v_gpio, 0);
+			    REQ_03_SET_GET_MCU_PIN, input->v_gpio, 0);
 			break;
 		case TM6000_VMUX_VIDEO_B:
 			tm6000_set_reg(dev, TM6000_REQ07_RE3_VADC_INP_LPF_SEL1, 0x00);
 			tm6000_set_reg(dev, TM6000_REQ07_RE5_VADC_INP_LPF_SEL2, 0x00);
 			tm6000_set_reg(dev, TM6000_REQ07_RE8_VADC_PWDOWN_CTL, 0x0f);
 			tm6000_set_reg(dev,
-			    REQ_03_SET_GET_MCU_PIN, dev->vinput[dev->input].v_gpio, 0);
+			    REQ_03_SET_GET_MCU_PIN, input->v_gpio, 0);
 			break;
 		case TM6000_VMUX_VIDEO_AB:
 			tm6000_set_reg(dev, TM6000_REQ07_RE3_VADC_INP_LPF_SEL1, 0x10);
 			tm6000_set_reg(dev, TM6000_REQ07_RE5_VADC_INP_LPF_SEL2, 0x10);
 			tm6000_set_reg(dev, TM6000_REQ07_RE8_VADC_PWDOWN_CTL, 0x00);
 			tm6000_set_reg(dev,
-			    REQ_03_SET_GET_MCU_PIN, dev->vinput[dev->input].v_gpio, 1);
+			    REQ_03_SET_GET_MCU_PIN, input->v_gpio, 1);
 			break;
 		default:
 			break;
 		}
-		switch (dev->vinput[dev->input].amux) {
+		switch (input->amux) {
 		case TM6000_AMUX_ADC1:
 			tm6000_set_reg_mask(dev,
 				TM6000_REQ07_REB_VADC_AADC_MODE, 0x00, 0x0f);
@@ -640,7 +642,7 @@ int tm6000_set_standard(struct tm6000_core *dev)
 			break;
 		}
 	}
-	if (dev->vinput[dev->input].type == TM6000_INPUT_SVIDEO) {
+	if (input->type == TM6000_INPUT_SVIDEO) {
 		for (i = 0; i < ARRAY_SIZE(svideo_stds); i++) {
 			if (dev->norm & svideo_stds[i].id) {
 				rc = tm6000_load_std(dev, svideo_stds[i].common,
@@ -668,8 +670,8 @@ ret:
 		return rc;
 
 	if ((dev->dev_type == TM6010) &&
-	    ((dev->vinput[dev->input].amux == TM6000_AMUX_SIF1) ||
-	    (dev->vinput[dev->input].amux == TM6000_AMUX_SIF2)))
+	    ((input->amux == TM6000_AMUX_SIF1) ||
+	    (input->amux == TM6000_AMUX_SIF2)))
 		tm6000_set_audio_std(dev);
 
 	msleep(40);
-- 
1.7.6

