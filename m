Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:51591 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754878Ab0D1U7A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Apr 2010 16:59:00 -0400
Message-ID: <4BD8A139.1080905@arcor.de>
Date: Wed, 28 Apr 2010 22:57:29 +0200
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Dmitri Belimov <d.belimov@gmail.com>
Subject: [PATCH] tm6000: bugfix analog init for tm6010
Content-Type: multipart/mixed;
 boundary="------------050007030807010103010705"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050007030807010103010705
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit


-- 
Stefan Ringel <stefan.ringel@arcor.de>


--------------050007030807010103010705
Content-Type: text/x-patch;
 name="1.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="1.diff"

commit 32b6f5e24c4de1143c784fd82201ac32c191c3b0
Author: Stefan Ringel <stefan.ringel@arcor.de>
Date:   Wed Apr 28 22:31:19 2010 +0200

    tm6000: bugfix analog init for tm6010
    
    - change value in function tm6000_set_fourcc_format
    - disable digital source
    - add vbi and audio init
    
    
    Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>

diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
index 0b4dc64..ff5d0b6 100644
--- a/drivers/staging/tm6000/tm6000-core.c
+++ b/drivers/staging/tm6000/tm6000-core.c
@@ -157,9 +157,9 @@ void tm6000_set_fourcc_format(struct tm6000_core *dev)
 {
 	if (dev->dev_type == TM6010) {
 		if (dev->fourcc == V4L2_PIX_FMT_UYVY)
-			tm6000_set_reg(dev, TM6010_REQ07_RC1_TRESHOLD, 0xfc);
+			tm6000_set_reg(dev, TM6010_REQ07_RC1_TRESHOLD, 0xd0);
 		else
-			tm6000_set_reg(dev, TM6010_REQ07_RC1_TRESHOLD, 0xfd);
+			tm6000_set_reg(dev, TM6010_REQ07_RC1_TRESHOLD, 0x90);
 	} else {
 		if (dev->fourcc == V4L2_PIX_FMT_UYVY)
 			tm6000_set_reg(dev, TM6010_REQ07_RC1_TRESHOLD, 0xd0);
@@ -177,7 +177,79 @@ int tm6000_init_analog_mode (struct tm6000_core *dev)
 		val = tm6000_get_reg(dev, TM6010_REQ07_RCC_ACTIVE_VIDEO_IF, 0);
 		val |= 0x60;
 		tm6000_set_reg(dev, TM6010_REQ07_RCC_ACTIVE_VIDEO_IF, val);
-		tm6000_set_reg(dev, TM6010_REQ07_RFE_POWER_DOWN, 0xcf);
+		val = tm6000_get_reg(dev, TM6010_REQ07_RC0_ACTIVE_VIDEO_SOURCE, 0);
+		val &= ~0x40;
+		tm6000_set_reg(dev, TM6010_REQ07_RC0_ACTIVE_VIDEO_SOURCE, val);
+
+		/* Init teletext */
+		tm6000_set_reg(dev, TM6010_REQ07_R3F_RESET, 0x01);
+		tm6000_set_reg(dev, TM6010_REQ07_R41_TELETEXT_VBI_CODE1, 0x27);
+		tm6000_set_reg(dev, TM6010_REQ07_R42_VBI_DATA_HIGH_LEVEL, 0x55);
+		tm6000_set_reg(dev, TM6010_REQ07_R43_VBI_DATA_TYPE_LINE7, 0x66);
+		tm6000_set_reg(dev, TM6010_REQ07_R44_VBI_DATA_TYPE_LINE8, 0x66);
+		tm6000_set_reg(dev, TM6010_REQ07_R45_VBI_DATA_TYPE_LINE9, 0x66);
+		tm6000_set_reg(dev, TM6010_REQ07_R46_VBI_DATA_TYPE_LINE10, 0x66);
+		tm6000_set_reg(dev, TM6010_REQ07_R47_VBI_DATA_TYPE_LINE11, 0x66);
+		tm6000_set_reg(dev, TM6010_REQ07_R48_VBI_DATA_TYPE_LINE12, 0x66);
+		tm6000_set_reg(dev, TM6010_REQ07_R49_VBI_DATA_TYPE_LINE13, 0x66);
+		tm6000_set_reg(dev, TM6010_REQ07_R4A_VBI_DATA_TYPE_LINE14, 0x66);
+		tm6000_set_reg(dev, TM6010_REQ07_R4B_VBI_DATA_TYPE_LINE15, 0x66);
+		tm6000_set_reg(dev, TM6010_REQ07_R4C_VBI_DATA_TYPE_LINE16, 0x66);
+		tm6000_set_reg(dev, TM6010_REQ07_R4D_VBI_DATA_TYPE_LINE17, 0x66);
+		tm6000_set_reg(dev, TM6010_REQ07_R4E_VBI_DATA_TYPE_LINE18, 0x66);
+		tm6000_set_reg(dev, TM6010_REQ07_R4F_VBI_DATA_TYPE_LINE19, 0x66);
+		tm6000_set_reg(dev, TM6010_REQ07_R50_VBI_DATA_TYPE_LINE20, 0x66);
+		tm6000_set_reg(dev, TM6010_REQ07_R51_VBI_DATA_TYPE_LINE21, 0x66);
+		tm6000_set_reg(dev, TM6010_REQ07_R52_VBI_DATA_TYPE_LINE22, 0x66);
+		tm6000_set_reg(dev, TM6010_REQ07_R53_VBI_DATA_TYPE_LINE23, 0x00);
+		tm6000_set_reg(dev, TM6010_REQ07_R54_VBI_DATA_TYPE_RLINES, 0x00);
+		tm6000_set_reg(dev, TM6010_REQ07_R55_VBI_LOOP_FILTER_GAIN, 0x01);
+		tm6000_set_reg(dev, TM6010_REQ07_R56_VBI_LOOP_FILTER_I_GAIN, 0x00);
+		tm6000_set_reg(dev, TM6010_REQ07_R57_VBI_LOOP_FILTER_P_GAIN, 0x02);
+		tm6000_set_reg(dev, TM6010_REQ07_R58_VBI_CAPTION_DTO1, 0x35);
+		tm6000_set_reg(dev, TM6010_REQ07_R59_VBI_CAPTION_DTO0, 0xa0);
+		tm6000_set_reg(dev, TM6010_REQ07_R5A_VBI_TELETEXT_DTO1, 0x11);
+		tm6000_set_reg(dev, TM6010_REQ07_R5B_VBI_TELETEXT_DTO0, 0x4c);
+		tm6000_set_reg(dev, TM6010_REQ07_R40_TELETEXT_VBI_CODE0, 0x01);
+		tm6000_set_reg(dev, TM6010_REQ07_R3F_RESET, 0x00);
+
+
+		/* Init audio */
+		tm6000_set_reg(dev, TM6010_REQ08_R01_A_INIT, 0x00);
+		tm6000_set_reg(dev, TM6010_REQ08_R02_A_FIX_GAIN_CTRL, 0x04);
+		tm6000_set_reg(dev, TM6010_REQ08_R03_A_AUTO_GAIN_CTRL, 0x00);
+		tm6000_set_reg(dev, TM6010_REQ08_R04_A_SIF_AMP_CTRL, 0xa0);
+		tm6000_set_reg(dev, TM6010_REQ08_R05_A_STANDARD_MOD, 0x05);
+		tm6000_set_reg(dev, TM6010_REQ08_R06_A_SOUND_MOD, 0x06);
+		tm6000_set_reg(dev, TM6010_REQ08_R07_A_LEFT_VOL, 0x00);
+		tm6000_set_reg(dev, TM6010_REQ08_R08_A_RIGHT_VOL, 0x00);
+		tm6000_set_reg(dev, TM6010_REQ08_R09_A_MAIN_VOL, 0x08);
+		tm6000_set_reg(dev, TM6010_REQ08_R0A_A_I2S_MOD, 0x91);
+		tm6000_set_reg(dev, TM6010_REQ08_R0B_A_ASD_THRES1, 0x20);
+		tm6000_set_reg(dev, TM6010_REQ08_R0C_A_ASD_THRES2, 0x12);
+		tm6000_set_reg(dev, TM6010_REQ08_R0D_A_AMD_THRES, 0x20);
+		tm6000_set_reg(dev, TM6010_REQ08_R0E_A_MONO_THRES1, 0xf0);
+		tm6000_set_reg(dev, TM6010_REQ08_R0F_A_MONO_THRES2, 0x80);
+		tm6000_set_reg(dev, TM6010_REQ08_R10_A_MUTE_THRES1, 0xc0);
+		tm6000_set_reg(dev, TM6010_REQ08_R11_A_MUTE_THRES2, 0x80);
+		tm6000_set_reg(dev, TM6010_REQ08_R12_A_AGC_U, 0x12);
+		tm6000_set_reg(dev, TM6010_REQ08_R13_A_AGC_ERR_T, 0xfe);
+		tm6000_set_reg(dev, TM6010_REQ08_R14_A_AGC_GAIN_INIT, 0x20);
+		tm6000_set_reg(dev, TM6010_REQ08_R15_A_AGC_STEP_THR, 0x14);
+		tm6000_set_reg(dev, TM6010_REQ08_R16_A_AGC_GAIN_MAX, 0xfe);
+		tm6000_set_reg(dev, TM6010_REQ08_R17_A_AGC_GAIN_MIN, 0x01);
+		tm6000_set_reg(dev, TM6010_REQ08_R18_A_TR_CTRL, 0xa0);
+		tm6000_set_reg(dev, TM6010_REQ08_R19_A_FH_2FH_GAIN, 0x32);
+		tm6000_set_reg(dev, TM6010_REQ08_R1A_A_NICAM_SER_MAX, 0x64);
+		tm6000_set_reg(dev, TM6010_REQ08_R1B_A_NICAM_SER_MIN, 0x20);
+		tm6000_set_reg(dev, REQ_08_SET_GET_AVREG_BIT, 0x1c, 0x00);
+		tm6000_set_reg(dev, REQ_08_SET_GET_AVREG_BIT, 0x1d, 0x00);
+		tm6000_set_reg(dev, TM6010_REQ08_R1E_A_GAIN_DEEMPH_OUT, 0x13);
+		tm6000_set_reg(dev, TM6010_REQ08_R1F_A_TEST_INTF_SEL, 0x00);
+		tm6000_set_reg(dev, TM6010_REQ08_R20_A_TEST_PIN_SEL, 0x00);
+		tm6000_set_reg(dev, TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3);
+		tm6000_set_reg(dev, TM6010_REQ08_R06_A_SOUND_MOD, 0x00);
+		tm6000_set_reg(dev, TM6010_REQ08_R01_A_INIT, 0x80);
 
 	} else {
 		/* Enables soft reset */

--------------050007030807010103010705--
