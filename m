Return-path: <mchehab@pedra>
Received: from mail-in-18.arcor-online.net ([151.189.21.58]:59206 "EHLO
	mail-in-18.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751301Ab1AYQl1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Jan 2011 11:41:27 -0500
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, d.belimov@gmail.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH] tm6000: relabeling any registers
Date: Tue, 25 Jan 2011 17:40:55 +0100
Message-Id: <1295973655-19072-1-git-send-email-stefan.ringel@arcor.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Stefan Ringel <stefan.ringel@arcor.de>

relabeling any registers


Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/tm6000-core.c |   64 ++++++++++++++++++++-------------
 1 files changed, 39 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
index 96aed4a..5162cd4 100644
--- a/drivers/staging/tm6000/tm6000-core.c
+++ b/drivers/staging/tm6000/tm6000-core.c
@@ -268,11 +268,11 @@ int tm6000_init_analog_mode(struct tm6000_core *dev)
 			tm6000_set_reg(dev, TM6010_REQ07_RC0_ACTIVE_VIDEO_SOURCE, 0x80);
 
 		tm6000_set_reg(dev, TM6010_REQ07_RC3_HSTART1, 0x88);
-		tm6000_set_reg(dev, TM6010_REQ07_RD8_IR_WAKEUP_SEL, 0x23);
+		tm6000_set_reg(dev, TM6000_REQ07_RDA_CLK_SEL, 0x23);
 		tm6000_set_reg(dev, TM6010_REQ07_RD1_ADDR_FOR_REQ1, 0xc0);
 		tm6000_set_reg(dev, TM6010_REQ07_RD2_ADDR_FOR_REQ2, 0xd8);
 		tm6000_set_reg(dev, TM6010_REQ07_RD6_ENDP_REQ1_REQ2, 0x06);
-		tm6000_set_reg(dev, TM6010_REQ07_RD8_IR_PULSE_CNT0, 0x1f);
+		tm6000_set_reg(dev, TM6000_REQ07_RDF_PWDOWN_ACLK, 0x1f);
 
 		/* AP Software reset */
 		tm6000_set_reg(dev, TM6010_REQ07_RFF_SOFT_RESET, 0x08);
@@ -284,8 +284,8 @@ int tm6000_init_analog_mode(struct tm6000_core *dev)
 		tm6000_set_reg(dev, TM6010_REQ07_R3F_RESET, 0x00);
 
 		/* E3: Select input 0 - TV tuner */
-		tm6000_set_reg(dev, TM6010_REQ07_RE3_OUT_SEL1, 0x00);
-		tm6000_set_reg(dev, REQ_07_SET_GET_AVREG, 0xeb, 0x60);
+		tm6000_set_reg(dev, TM6000_REQ07_RE3_VADC_INP_LPF_SEL1, 0x00);
+		tm6000_set_reg(dev, TM6000_REQ07_REB_VADC_AADC_MODE, 0x60);
 
 		/* This controls input */
 		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN, TM6000_GPIO_2, 0x0);
@@ -344,21 +344,21 @@ int tm6000_init_digital_mode(struct tm6000_core *dev)
 		tm6000_set_reg(dev, TM6010_REQ07_RFF_SOFT_RESET, 0x08);
 		tm6000_set_reg(dev, TM6010_REQ07_RFF_SOFT_RESET, 0x00);
 		tm6000_set_reg(dev, TM6010_REQ07_R3F_RESET, 0x01);
-		tm6000_set_reg(dev, TM6010_REQ07_RD8_IR_PULSE_CNT0, 0x08);
-		tm6000_set_reg(dev, TM6010_REQ07_RE2_OUT_SEL2, 0x0c);
-		tm6000_set_reg(dev, TM6010_REQ07_RE8_TYPESEL_MOS_I2S, 0xff);
-		tm6000_set_reg(dev, REQ_07_SET_GET_AVREG, 0x00eb, 0xd8);
+		tm6000_set_reg(dev, TM6000_REQ07_RDF_PWDOWN_ACLK, 0x08);
+		tm6000_set_reg(dev, TM6000_REQ07_RE2_VADC_STATUS_CTL, 0x0c);
+		tm6000_set_reg(dev, TM6000_REQ07_RE8_VADC_PWDOWN_CTL, 0xff);
+		tm6000_set_reg(dev, TM6000_REQ07_REB_VADC_AADC_MODE, 0xd8);
 		tm6000_set_reg(dev, TM6010_REQ07_RC0_ACTIVE_VIDEO_SOURCE, 0x40);
 		tm6000_set_reg(dev, TM6010_REQ07_RC1_TRESHOLD, 0xd0);
 		tm6000_set_reg(dev, TM6010_REQ07_RC3_HSTART1, 0x09);
-		tm6000_set_reg(dev, TM6010_REQ07_RD8_IR_WAKEUP_SEL, 0x37);
+		tm6000_set_reg(dev, TM6000_REQ07_RDA_CLK_SEL, 0x37);
 		tm6000_set_reg(dev, TM6010_REQ07_RD1_ADDR_FOR_REQ1, 0xd8);
 		tm6000_set_reg(dev, TM6010_REQ07_RD2_ADDR_FOR_REQ2, 0xc0);
 		tm6000_set_reg(dev, TM6010_REQ07_RD6_ENDP_REQ1_REQ2, 0x60);
 
-		tm6000_set_reg(dev, TM6010_REQ07_RE2_OUT_SEL2, 0x0c);
-		tm6000_set_reg(dev, TM6010_REQ07_RE8_TYPESEL_MOS_I2S, 0xff);
-		tm6000_set_reg(dev, REQ_07_SET_GET_AVREG, 0x00eb, 0x08);
+		tm6000_set_reg(dev, TM6000_REQ07_RE2_VADC_STATUS_CTL, 0x0c);
+		tm6000_set_reg(dev, TM6000_REQ07_RE8_VADC_PWDOWN_CTL, 0xff);
+		tm6000_set_reg(dev, TM6000_REQ07_REB_VADC_AADC_MODE, 0x08);
 		msleep(50);
 
 		tm6000_set_reg(dev, REQ_04_EN_DISABLE_MCU_INT, 0x0020, 0x00);
@@ -388,18 +388,19 @@ struct reg_init {
 /* The meaning of those initializations are unknown */
 struct reg_init tm6000_init_tab[] = {
 	/* REG  VALUE */
-	{ TM6010_REQ07_RD8_IR_PULSE_CNT0, 0x1f },
+	{ TM6000_REQ07_RDF_PWDOWN_ACLK, 0x1f },
 	{ TM6010_REQ07_RFF_SOFT_RESET, 0x08 },
 	{ TM6010_REQ07_RFF_SOFT_RESET, 0x00 },
 	{ TM6010_REQ07_RD5_POWERSAVE, 0x4f },
-	{ TM6010_REQ07_RD8_IR_WAKEUP_SEL, 0x23 },
-	{ TM6010_REQ07_RD8_IR_WAKEUP_ADD, 0x08 },
-	{ TM6010_REQ07_RE2_OUT_SEL2, 0x00 },
-	{ TM6010_REQ07_RE3_OUT_SEL1, 0x10 },
-	{ TM6010_REQ07_RE5_REMOTE_WAKEUP, 0x00 },
-	{ TM6010_REQ07_RE8_TYPESEL_MOS_I2S, 0x00 },
-	{ REQ_07_SET_GET_AVREG,  0xeb, 0x64 },		/* 48000 bits/sample, external input */
-	{ REQ_07_SET_GET_AVREG,  0xee, 0xc2 },
+	{ TM6000_REQ07_RDA_CLK_SEL, 0x23 },
+	{ TM6000_REQ07_RDB_OUT_SEL, 0x08 },
+	{ TM6000_REQ07_RE2_VADC_STATUS_CTL, 0x00 },
+	{ TM6000_REQ07_RE3_VADC_INP_LPF_SEL1, 0x10 },
+	{ TM6000_REQ07_RE5_VADC_INP_LPF_SEL2, 0x00 },
+	{ TM6000_REQ07_RE8_VADC_PWDOWN_CTL, 0x00 },
+	{ TM6000_REQ07_REB_VADC_AADC_MODE, 0x64 },	/* 48000 bits/sample, external input */
+	{ TM6000_REQ07_REE_VADC_CTRL_SEL_CONTROL, 0xc2 },
+
 	{ TM6010_REQ07_R3F_RESET, 0x01 },		/* Start of soft reset */
 	{ TM6010_REQ07_R00_VIDEO_CONTROL0, 0x00 },
 	{ TM6010_REQ07_R01_VIDEO_CONTROL1, 0x07 },
@@ -592,6 +593,7 @@ int tm6000_set_audio_bitrate(struct tm6000_core *dev, int bitrate)
 {
 	int val;
 
+	/* enable I2S, if we use sif or external I2S device */
 	if (dev->dev_type == TM6010) {
 		val = tm6000_get_reg(dev, TM6010_REQ08_R0A_A_I2S_MOD, 0);
 		if (val < 0)
@@ -602,9 +604,17 @@ int tm6000_set_audio_bitrate(struct tm6000_core *dev, int bitrate)
 			return val;
 	}
 
-	val = tm6000_get_reg(dev, REQ_07_SET_GET_AVREG, 0xeb, 0x0);
-	if (val < 0)
-		return val;
+	/* different reg's to set audio bitrate */
+	if (dev->dev_type == TM6010) {
+		val = tm6000_get_reg(dev, TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG,
+			0x0);
+		if (val < 0)
+			return val;
+	} else {
+		val = tm6000_get_reg(dev, TM6000_REQ07_REB_VADC_AADC_MODE, 0x0);
+		if (val < 0)
+			return val;
+	}
 
 	val &= 0x0f;		/* Preserve the audio input control bits */
 	switch (bitrate) {
@@ -617,7 +627,11 @@ int tm6000_set_audio_bitrate(struct tm6000_core *dev, int bitrate)
 		dev->audio_bitrate = bitrate;
 		break;
 	}
-	val = tm6000_set_reg(dev, REQ_07_SET_GET_AVREG, 0xeb, val);
+	if (dev->dev_type == TM6010)
+		val = tm6000_set_reg(dev, TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG,
+			val);
+	else
+		val = tm6000_set_reg(dev, TM6000_REQ07_REB_VADC_AADC_MODE, val);
 
 	return val;
 }
-- 
1.7.3.4

