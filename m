Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:56321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752382Ab0JGF2k (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Oct 2010 01:28:40 -0400
Message-ID: <4CAD5A78.3070803@redhat.com>
Date: Thu, 07 Oct 2010 02:28:24 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Dmitri Belimov <d.belimov@gmail.com>
CC: Felipe Sanches <juca@members.fsf.org>,
	Stefan Ringel <stefan.ringel@arcor.de>,
	Bee Hock Goh <beehock@gmail.com>,
	Luis Henrique Fagundes <lhfagundes@hacklab.com.br>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [RFC PATCH] Audio standards on tm6000
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Dmitri,

IMO, the better is to remove the audio init from tm6000-core and add a separate
per-standard set of tables.

I'm enclosing the patch for it. Please check if this won't break for your device.

On all tests I did here with a tm6010 device (HVR 900H), I was only able to listen to
white noise.

I'm suspecting that this device uses XC3028 MTS mode (e. g. uses xc3028 to decode audio,
and just inputs the audio stream from some line IN. As the driver is not able yet to
handle an audio mux, this may explain why I'm not able to receive any audio at all.

Maybe tm5600 devices may also require (or use) line input entries, instead of I2S.

Could you please check those issues?

PS.: the PAL/M hunk will probably fail, as I likely applied some patches before
this one, in order to try to fix it. It should be trivial to solve the conflicts.

---

tm6000: Implement audio standard tables

Implement separate tables for audio standards, associating them with the
video standards.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
index 57cb69e..9cb2901 100644
--- a/drivers/staging/tm6000/tm6000-core.c
+++ b/drivers/staging/tm6000/tm6000-core.c
@@ -200,6 +200,10 @@ int tm6000_init_analog_mode(struct tm6000_core *dev)
 		val &= ~0x40;
 		tm6000_set_reg(dev, TM6010_REQ07_RC0_ACTIVE_VIDEO_SOURCE, val);
 
+		tm6000_set_reg(dev, TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc);
+
+#if 0		/* FIXME: VBI is standard-dependent */
+
 		/* Init teletext */
 		tm6000_set_reg(dev, TM6010_REQ07_R3F_RESET, 0x01);
 		tm6000_set_reg(dev, TM6010_REQ07_R41_TELETEXT_VBI_CODE1, 0x27);
@@ -249,44 +253,7 @@ int tm6000_init_analog_mode(struct tm6000_core *dev)
 		tm6000_set_reg(dev, TM6010_REQ07_R5B_VBI_TELETEXT_DTO0, 0x4c);
 		tm6000_set_reg(dev, TM6010_REQ07_R40_TELETEXT_VBI_CODE0, 0x01);
 		tm6000_set_reg(dev, TM6010_REQ07_R3F_RESET, 0x00);
-
-
-		/* Init audio */
-		tm6000_set_reg(dev, TM6010_REQ08_R01_A_INIT, 0x00);
-		tm6000_set_reg(dev, TM6010_REQ08_R02_A_FIX_GAIN_CTRL, 0x04);
-		tm6000_set_reg(dev, TM6010_REQ08_R03_A_AUTO_GAIN_CTRL, 0x00);
-		tm6000_set_reg(dev, TM6010_REQ08_R04_A_SIF_AMP_CTRL, 0xa0);
-		tm6000_set_reg(dev, TM6010_REQ08_R06_A_SOUND_MOD, 0x06);
-		tm6000_set_reg(dev, TM6010_REQ08_R07_A_LEFT_VOL, 0x00);
-		tm6000_set_reg(dev, TM6010_REQ08_R08_A_RIGHT_VOL, 0x00);
-		tm6000_set_reg(dev, TM6010_REQ08_R09_A_MAIN_VOL, 0x08);
-		tm6000_set_reg(dev, TM6010_REQ08_R0A_A_I2S_MOD, 0x91);
-		tm6000_set_reg(dev, TM6010_REQ08_R0B_A_ASD_THRES1, 0x20);
-		tm6000_set_reg(dev, TM6010_REQ08_R0C_A_ASD_THRES2, 0x12);
-		tm6000_set_reg(dev, TM6010_REQ08_R0D_A_AMD_THRES, 0x20);
-		tm6000_set_reg(dev, TM6010_REQ08_R0E_A_MONO_THRES1, 0xf0);
-		tm6000_set_reg(dev, TM6010_REQ08_R0F_A_MONO_THRES2, 0x80);
-		tm6000_set_reg(dev, TM6010_REQ08_R10_A_MUTE_THRES1, 0xc0);
-		tm6000_set_reg(dev, TM6010_REQ08_R11_A_MUTE_THRES2, 0x80);
-		tm6000_set_reg(dev, TM6010_REQ08_R12_A_AGC_U, 0x12);
-		tm6000_set_reg(dev, TM6010_REQ08_R13_A_AGC_ERR_T, 0xfe);
-		tm6000_set_reg(dev, TM6010_REQ08_R14_A_AGC_GAIN_INIT, 0x20);
-		tm6000_set_reg(dev, TM6010_REQ08_R15_A_AGC_STEP_THR, 0x14);
-		tm6000_set_reg(dev, TM6010_REQ08_R16_A_AGC_GAIN_MAX, 0xfe);
-		tm6000_set_reg(dev, TM6010_REQ08_R17_A_AGC_GAIN_MIN, 0x01);
-		tm6000_set_reg(dev, TM6010_REQ08_R18_A_TR_CTRL, 0xa0);
-		tm6000_set_reg(dev, TM6010_REQ08_R19_A_FH_2FH_GAIN, 0x32);
-		tm6000_set_reg(dev, TM6010_REQ08_R1A_A_NICAM_SER_MAX, 0x64);
-		tm6000_set_reg(dev, TM6010_REQ08_R1B_A_NICAM_SER_MIN, 0x20);
-		tm6000_set_reg(dev, REQ_08_SET_GET_AVREG_BIT, 0x1c, 0x00);
-		tm6000_set_reg(dev, REQ_08_SET_GET_AVREG_BIT, 0x1d, 0x00);
-		tm6000_set_reg(dev, TM6010_REQ08_R1E_A_GAIN_DEEMPH_OUT, 0x13);
-		tm6000_set_reg(dev, TM6010_REQ08_R1F_A_TEST_INTF_SEL, 0x00);
-		tm6000_set_reg(dev, TM6010_REQ08_R20_A_TEST_PIN_SEL, 0x00);
-		tm6000_set_reg(dev, TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3);
-		tm6000_set_reg(dev, TM6010_REQ08_R06_A_SOUND_MOD, 0x00);
-		tm6000_set_reg(dev, TM6010_REQ08_R01_A_INIT, 0x80);
-
+#endif
 	} else {
 		/* Enables soft reset */
 		tm6000_set_reg(dev, TM6010_REQ07_R3F_RESET, 0x01);
@@ -360,7 +327,6 @@ int tm6000_init_digital_mode(struct tm6000_core *dev)
 		tm6000_set_reg(dev, TM6010_REQ07_RFE_POWER_DOWN, 0x28);
 		tm6000_set_reg(dev, TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xfc);
 		tm6000_set_reg(dev, TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0xff);
-		tm6000_set_reg(dev, TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfe);
 		tm6000_read_write_usb(dev, 0xc0, 0x0e, 0x00c2, 0x0008, buf, 2);
 		printk(KERN_INFO"buf %#x %#x\n", buf[0], buf[1]);
 	} else  {
diff --git a/drivers/staging/tm6000/tm6000-stds.c b/drivers/staging/tm6000/tm6000-stds.c
index 33adf6c..e79a72e 100644
--- a/drivers/staging/tm6000/tm6000-stds.c
+++ b/drivers/staging/tm6000/tm6000-stds.c
@@ -28,8 +28,22 @@ struct tm6000_reg_settings {
 	unsigned char value;
 };
 
+enum tm6000_audio_std {
+	BG_NICAM,
+	BTSC,
+	BG_A2,
+	DK_NICAM,
+	EIAJ,
+	FM_RADIO,
+	I_NICAM,
+	KOREA_A2,
+	L_NICAM,
+};
+
 struct tm6000_std_tv_settings {
 	v4l2_std_id id;
+	enum tm6000_audio_std audio_default_std;
+
 	struct tm6000_reg_settings sif[12];
 	struct tm6000_reg_settings nosif[12];
 	struct tm6000_reg_settings common[26];
@@ -37,12 +51,14 @@ struct tm6000_std_tv_settings {
 
 struct tm6000_std_settings {
 	v4l2_std_id id;
+	enum tm6000_audio_std audio_default_std;
 	struct tm6000_reg_settings common[37];
 };
 
 static struct tm6000_std_tv_settings tv_stds[] = {
 	{
 		.id = V4L2_STD_PAL_M,
+		.audio_default_std = BTSC,
 		.sif = {
 			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf2},
 			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf8},
@@ -96,12 +112,14 @@ static struct tm6000_std_tv_settings tv_stds[] = {
 
 			{TM6010_REQ07_R04_LUMA_HAGC_CONTROL, 0xdc},
 			{TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x07},
-			{TM6010_REQ08_R05_A_STANDARD_MOD, 0x22},
+
 			{TM6010_REQ07_R3F_RESET, 0x00},
+
 			{0, 0, 0},
 		},
 	}, {
 		.id = V4L2_STD_PAL_Nc,
+		.audio_default_std = BTSC,
 		.sif = {
 			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf2},
 			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf8},
@@ -161,6 +179,7 @@ static struct tm6000_std_tv_settings tv_stds[] = {
 		},
 	}, {
 		.id = V4L2_STD_PAL,
+		.audio_default_std = BG_A2,
 		.sif = {
 			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf2},
 			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf8},
@@ -220,6 +239,7 @@ static struct tm6000_std_tv_settings tv_stds[] = {
 		},
 	}, {
 		.id = V4L2_STD_SECAM,
+		.audio_default_std = BG_NICAM,
 		.sif = {
 			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf2},
 			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf8},
@@ -278,6 +298,7 @@ static struct tm6000_std_tv_settings tv_stds[] = {
 		},
 	}, {
 		.id = V4L2_STD_NTSC,
+		.audio_default_std = BTSC,
 		.sif = {
 			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf2},
 			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf8},
@@ -341,6 +362,7 @@ static struct tm6000_std_tv_settings tv_stds[] = {
 static struct tm6000_std_settings composite_stds[] = {
 	{
 		.id = V4L2_STD_PAL_M,
+		.audio_default_std = BTSC,
 		.common = {
 			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
 			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf4},
@@ -383,6 +405,7 @@ static struct tm6000_std_settings composite_stds[] = {
 		},
 	 }, {
 		.id = V4L2_STD_PAL_Nc,
+		.audio_default_std = BTSC,
 		.common = {
 			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
 			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf4},
@@ -425,6 +448,7 @@ static struct tm6000_std_settings composite_stds[] = {
 		},
 	}, {
 		.id = V4L2_STD_PAL,
+		.audio_default_std = BG_A2,
 		.common = {
 			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
 			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf4},
@@ -467,6 +491,7 @@ static struct tm6000_std_settings composite_stds[] = {
 		},
 	 }, {
 		.id = V4L2_STD_SECAM,
+		.audio_default_std = BG_NICAM,
 		.common = {
 			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
 			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf4},
@@ -508,6 +533,7 @@ static struct tm6000_std_settings composite_stds[] = {
 		},
 	}, {
 		.id = V4L2_STD_NTSC,
+		.audio_default_std = BTSC,
 		.common = {
 			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
 			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf4},
@@ -554,6 +580,7 @@ static struct tm6000_std_settings composite_stds[] = {
 static struct tm6000_std_settings svideo_stds[] = {
 	{
 		.id = V4L2_STD_PAL_M,
+		.audio_default_std = BTSC,
 		.common = {
 			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
 			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xfc},
@@ -596,6 +623,7 @@ static struct tm6000_std_settings svideo_stds[] = {
 		},
 	}, {
 		.id = V4L2_STD_PAL_Nc,
+		.audio_default_std = BTSC,
 		.common = {
 			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
 			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xfc},
@@ -638,6 +666,7 @@ static struct tm6000_std_settings svideo_stds[] = {
 		},
 	}, {
 		.id = V4L2_STD_PAL,
+		.audio_default_std = BG_A2,
 		.common = {
 			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
 			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xfc},
@@ -680,6 +709,7 @@ static struct tm6000_std_settings svideo_stds[] = {
 		},
 	 }, {
 		.id = V4L2_STD_SECAM,
+		.audio_default_std = BG_NICAM,
 		.common = {
 			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
 			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xfc},
@@ -721,6 +751,7 @@ static struct tm6000_std_settings svideo_stds[] = {
 		},
 	}, {
 		.id = V4L2_STD_NTSC,
+		.audio_default_std = BTSC,
 		.common = {
 			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
 			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xfc},
@@ -765,6 +796,136 @@ static struct tm6000_std_settings svideo_stds[] = {
 	},
 };
 
+
+static int tm6000_set_audio_std(struct tm6000_core *dev,
+				enum tm6000_audio_std std)
+{
+	switch (std) {
+	case BG_NICAM:
+		tm6000_set_reg(dev, TM6010_REQ08_R01_A_INIT, 0x00);
+		tm6000_set_reg(dev, TM6010_REQ08_R02_A_FIX_GAIN_CTRL, 0x11);
+		tm6000_set_reg(dev, TM6010_REQ08_R03_A_AUTO_GAIN_CTRL, 0x00);
+		tm6000_set_reg(dev, TM6010_REQ08_R05_A_STANDARD_MOD, 0x01);
+		tm6000_set_reg(dev, TM6010_REQ08_R06_A_SOUND_MOD, 0x06);
+		tm6000_set_reg(dev, TM6010_REQ08_R0A_A_I2S_MOD, 0x91);
+		tm6000_set_reg(dev, TM6010_REQ08_R16_A_AGC_GAIN_MAX, 0xfe);
+		tm6000_set_reg(dev, TM6010_REQ08_R17_A_AGC_GAIN_MIN, 0x01);
+		tm6000_set_reg(dev, TM6010_REQ08_R01_A_INIT, 0x80);
+		break;
+	case BTSC:
+		tm6000_set_reg(dev, TM6010_REQ08_R01_A_INIT, 0x00);
+		tm6000_set_reg(dev, TM6010_REQ08_R02_A_FIX_GAIN_CTRL, 0x04);
+		tm6000_set_reg(dev, TM6010_REQ08_R03_A_AUTO_GAIN_CTRL, 0x00);
+		tm6000_set_reg(dev, TM6010_REQ08_R05_A_STANDARD_MOD, 0x02);
+		tm6000_set_reg(dev, TM6010_REQ08_R06_A_SOUND_MOD, 0x06);
+		tm6000_set_reg(dev, TM6010_REQ08_R09_A_MAIN_VOL, 0x08);
+		tm6000_set_reg(dev, TM6010_REQ08_R0A_A_I2S_MOD, 0x91);
+		tm6000_set_reg(dev, TM6010_REQ08_R0E_A_MONO_THRES1, 0xf0);
+		tm6000_set_reg(dev, TM6010_REQ08_R0F_A_MONO_THRES2, 0x80);
+		tm6000_set_reg(dev, TM6010_REQ08_R10_A_MUTE_THRES1, 0xc0);
+		tm6000_set_reg(dev, TM6010_REQ08_R11_A_MUTE_THRES2, 0x80);
+		tm6000_set_reg(dev, TM6010_REQ08_R16_A_AGC_GAIN_MAX, 0xfe);
+		tm6000_set_reg(dev, TM6010_REQ08_R17_A_AGC_GAIN_MIN, 0x01);
+		tm6000_set_reg(dev, TM6010_REQ08_R01_A_INIT, 0x80);
+		break;
+	case BG_A2:
+		tm6000_set_reg(dev, TM6010_REQ08_R01_A_INIT, 0x00);
+		tm6000_set_reg(dev, TM6010_REQ08_R02_A_FIX_GAIN_CTRL, 0x04);
+		tm6000_set_reg(dev, TM6010_REQ08_R03_A_AUTO_GAIN_CTRL, 0x00);
+		tm6000_set_reg(dev, TM6010_REQ08_R05_A_STANDARD_MOD, 0x05);
+		tm6000_set_reg(dev, TM6010_REQ08_R06_A_SOUND_MOD, 0x06);
+		tm6000_set_reg(dev, TM6010_REQ08_R09_A_MAIN_VOL, 0x08);
+		tm6000_set_reg(dev, TM6010_REQ08_R0A_A_I2S_MOD, 0x91);
+		tm6000_set_reg(dev, TM6010_REQ08_R0E_A_MONO_THRES1, 0xf0);
+		tm6000_set_reg(dev, TM6010_REQ08_R0F_A_MONO_THRES2, 0x80);
+		tm6000_set_reg(dev, TM6010_REQ08_R10_A_MUTE_THRES1, 0xc0);
+		tm6000_set_reg(dev, TM6010_REQ08_R11_A_MUTE_THRES2, 0x80);
+		tm6000_set_reg(dev, TM6010_REQ08_R16_A_AGC_GAIN_MAX, 0xfe);
+		tm6000_set_reg(dev, TM6010_REQ08_R17_A_AGC_GAIN_MIN, 0x01);
+		tm6000_set_reg(dev, TM6010_REQ08_R01_A_INIT, 0x80);
+		break;
+	case DK_NICAM:
+		tm6000_set_reg(dev, TM6010_REQ08_R01_A_INIT, 0x00);
+		tm6000_set_reg(dev, TM6010_REQ08_R02_A_FIX_GAIN_CTRL, 0x04);
+		tm6000_set_reg(dev, TM6010_REQ08_R03_A_AUTO_GAIN_CTRL, 0x00);
+		tm6000_set_reg(dev, TM6010_REQ08_R05_A_STANDARD_MOD, 0x06);
+		tm6000_set_reg(dev, TM6010_REQ08_R06_A_SOUND_MOD, 0x06);
+		tm6000_set_reg(dev, TM6010_REQ08_R09_A_MAIN_VOL, 0x08);
+		tm6000_set_reg(dev, TM6010_REQ08_R0A_A_I2S_MOD, 0x91);
+		tm6000_set_reg(dev, TM6010_REQ08_R0C_A_ASD_THRES2, 0x0a);
+		tm6000_set_reg(dev, TM6010_REQ08_R16_A_AGC_GAIN_MAX, 0xfe);
+		tm6000_set_reg(dev, TM6010_REQ08_R17_A_AGC_GAIN_MIN, 0x01);
+		tm6000_set_reg(dev, TM6010_REQ08_R01_A_INIT, 0x80);
+		break;
+	case EIAJ:
+		tm6000_set_reg(dev, TM6010_REQ08_R01_A_INIT, 0x00);
+		tm6000_set_reg(dev, TM6010_REQ08_R02_A_FIX_GAIN_CTRL, 0x04);
+		tm6000_set_reg(dev, TM6010_REQ08_R03_A_AUTO_GAIN_CTRL, 0x00);
+		tm6000_set_reg(dev, TM6010_REQ08_R05_A_STANDARD_MOD, 0x03);
+		tm6000_set_reg(dev, TM6010_REQ08_R06_A_SOUND_MOD, 0x06);
+		tm6000_set_reg(dev, TM6010_REQ08_R09_A_MAIN_VOL, 0x08);
+		tm6000_set_reg(dev, TM6010_REQ08_R0A_A_I2S_MOD, 0x91);
+		tm6000_set_reg(dev, TM6010_REQ08_R16_A_AGC_GAIN_MAX, 0xfe);
+		tm6000_set_reg(dev, TM6010_REQ08_R17_A_AGC_GAIN_MIN, 0x01);
+		tm6000_set_reg(dev, TM6010_REQ08_R01_A_INIT, 0x80);
+		break;
+	case FM_RADIO:
+		tm6000_set_reg(dev, TM6010_REQ08_R01_A_INIT, 0x00);
+		tm6000_set_reg(dev, TM6010_REQ08_R02_A_FIX_GAIN_CTRL, 0x01);
+		tm6000_set_reg(dev, TM6010_REQ08_R03_A_AUTO_GAIN_CTRL, 0x00);
+		tm6000_set_reg(dev, TM6010_REQ08_R05_A_STANDARD_MOD, 0x0c);
+		tm6000_set_reg(dev, TM6010_REQ08_R06_A_SOUND_MOD, 0x00);
+		tm6000_set_reg(dev, TM6010_REQ08_R09_A_MAIN_VOL, 0x10);
+		tm6000_set_reg(dev, TM6010_REQ08_R0A_A_I2S_MOD, 0x91);
+		tm6000_set_reg(dev, TM6010_REQ08_R16_A_AGC_GAIN_MAX, 0xfe);
+		tm6000_set_reg(dev, TM6010_REQ08_R17_A_AGC_GAIN_MIN, 0x01);
+		tm6000_set_reg(dev, TM6010_REQ08_R01_A_INIT, 0x80);
+		break;
+	case I_NICAM:
+		tm6000_set_reg(dev, TM6010_REQ08_R01_A_INIT, 0x00);
+		tm6000_set_reg(dev, TM6010_REQ08_R02_A_FIX_GAIN_CTRL, 0x04);
+		tm6000_set_reg(dev, TM6010_REQ08_R03_A_AUTO_GAIN_CTRL, 0x00);
+		tm6000_set_reg(dev, TM6010_REQ08_R05_A_STANDARD_MOD, 0x01);
+		tm6000_set_reg(dev, TM6010_REQ08_R06_A_SOUND_MOD, 0x06);
+		tm6000_set_reg(dev, TM6010_REQ08_R09_A_MAIN_VOL, 0x08);
+		tm6000_set_reg(dev, TM6010_REQ08_R0A_A_I2S_MOD, 0x91);
+		tm6000_set_reg(dev, TM6010_REQ08_R0C_A_ASD_THRES2, 0x0a);
+		tm6000_set_reg(dev, TM6010_REQ08_R16_A_AGC_GAIN_MAX, 0xfe);
+		tm6000_set_reg(dev, TM6010_REQ08_R17_A_AGC_GAIN_MIN, 0x01);
+		tm6000_set_reg(dev, TM6010_REQ08_R01_A_INIT, 0x80);
+		break;
+	case KOREA_A2:
+		tm6000_set_reg(dev, TM6010_REQ08_R01_A_INIT, 0x00);
+		tm6000_set_reg(dev, TM6010_REQ08_R02_A_FIX_GAIN_CTRL, 0x04);
+		tm6000_set_reg(dev, TM6010_REQ08_R03_A_AUTO_GAIN_CTRL, 0x00);
+		tm6000_set_reg(dev, TM6010_REQ08_R05_A_STANDARD_MOD, 0x04);
+		tm6000_set_reg(dev, TM6010_REQ08_R06_A_SOUND_MOD, 0x06);
+		tm6000_set_reg(dev, TM6010_REQ08_R09_A_MAIN_VOL, 0x08);
+		tm6000_set_reg(dev, TM6010_REQ08_R0A_A_I2S_MOD, 0x91);
+		tm6000_set_reg(dev, TM6010_REQ08_R0E_A_MONO_THRES1, 0xf0);
+		tm6000_set_reg(dev, TM6010_REQ08_R0F_A_MONO_THRES2, 0x80);
+		tm6000_set_reg(dev, TM6010_REQ08_R10_A_MUTE_THRES1, 0xc0);
+		tm6000_set_reg(dev, TM6010_REQ08_R11_A_MUTE_THRES2, 0xf0);
+		tm6000_set_reg(dev, TM6010_REQ08_R16_A_AGC_GAIN_MAX, 0xfe);
+		tm6000_set_reg(dev, TM6010_REQ08_R17_A_AGC_GAIN_MIN, 0x01);
+		tm6000_set_reg(dev, TM6010_REQ08_R01_A_INIT, 0x80);
+		break;
+	case L_NICAM:
+		tm6000_set_reg(dev, TM6010_REQ08_R01_A_INIT, 0x00);
+		tm6000_set_reg(dev, TM6010_REQ08_R02_A_FIX_GAIN_CTRL, 0x02);
+		tm6000_set_reg(dev, TM6010_REQ08_R03_A_AUTO_GAIN_CTRL, 0x00);
+		tm6000_set_reg(dev, TM6010_REQ08_R05_A_STANDARD_MOD, 0x0a);
+		tm6000_set_reg(dev, TM6010_REQ08_R06_A_SOUND_MOD, 0x06);
+		tm6000_set_reg(dev, TM6010_REQ08_R09_A_MAIN_VOL, 0x08);
+		tm6000_set_reg(dev, TM6010_REQ08_R0A_A_I2S_MOD, 0x91);
+		tm6000_set_reg(dev, TM6010_REQ08_R16_A_AGC_GAIN_MAX, 0xfe);
+		tm6000_set_reg(dev, TM6010_REQ08_R17_A_AGC_GAIN_MIN, 0x01);
+		tm6000_set_reg(dev, TM6010_REQ08_R01_A_INIT, 0x80);
+		break;
+	}
+	return 0;
+}
+
 void tm6000_get_std_res(struct tm6000_core *dev)
 {
 	/* Currently, those are the only supported resoltions */
@@ -825,6 +986,8 @@ static int tm6000_set_tv(struct tm6000_core *dev, int pos)
 	rc = tm6000_load_std(dev, tv_stds[pos].common,
 			     sizeof(tv_stds[pos].common));
 
+	tm6000_set_audio_std(dev, tv_stds[pos].audio_default_std);
+
 	return rc;
 }
 
@@ -850,6 +1013,8 @@ int tm6000_set_standard(struct tm6000_core *dev, v4l2_std_id * norm)
 				rc = tm6000_load_std(dev, svideo_stds[i].common,
 						     sizeof(svideo_stds[i].
 							    common));
+				tm6000_set_audio_std(dev, svideo_stds[i].audio_default_std);
+
 				goto ret;
 			}
 		}
@@ -861,6 +1026,7 @@ int tm6000_set_standard(struct tm6000_core *dev, v4l2_std_id * norm)
 						     composite_stds[i].common,
 						     sizeof(composite_stds[i].
 							    common));
+				tm6000_set_audio_std(dev, composite_stds[i].audio_default_std);
 				goto ret;
 			}
 		}
diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
index a45b012..9304158 100644
--- a/drivers/staging/tm6000/tm6000-video.c
+++ b/drivers/staging/tm6000/tm6000-video.c
@@ -1015,7 +1015,8 @@ static int vidioc_s_std (struct file *file, void *priv, v4l2_std_id *norm)
 	struct tm6000_fh   *fh=priv;
 	struct tm6000_core *dev = fh->dev;
 
-	rc=tm6000_set_standard (dev, norm);
+	rc = tm6000_set_standard(dev, norm);
+	rc = tm6000_init_analog_mode(dev);
 
 	fh->width  = dev->width;
 	fh->height = dev->height;
@@ -1292,9 +1293,10 @@ static int tm6000_open(struct file *file)
 				"active=%d\n",list_empty(&dev->vidq.active));
 
 	/* initialize hardware on analog mode */
-	if (dev->mode!=TM6000_MODE_ANALOG) {
-		rc=tm6000_init_analog_mode (dev);
-		if (rc<0)
+//	if (dev->mode!=TM6000_MODE_ANALOG) {
+//		rc = tm6000_set_standard(dev, dev->norm);
+		rc += tm6000_init_analog_mode(dev);
+		if (rc < 0)
 			return rc;
 
 		/* Put all controls at a sane state */
@@ -1302,7 +1304,7 @@ static int tm6000_open(struct file *file)
 			qctl_regs[i] =tm6000_qctrl[i].default_value;
 
 		dev->mode=TM6000_MODE_ANALOG;
-	}
+//	}
 
 	videobuf_queue_vmalloc_init(&fh->vb_vidq, &tm6000_video_qops,
 			NULL, &dev->slock,
