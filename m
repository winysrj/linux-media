Return-path: <mchehab@gaivota>
Received: from mail-in-09.arcor-online.net ([151.189.21.49]:42787 "EHLO
	mail-in-09.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754507Ab1EITyO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 May 2011 15:54:14 -0400
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, d.belimov@gmail.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 05/16] tm6000: change input control
Date: Mon,  9 May 2011 21:53:53 +0200
Message-Id: <1304970844-20955-5-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1304970844-20955-1-git-send-email-stefan.ringel@arcor.de>
References: <1304970844-20955-1-git-send-email-stefan.ringel@arcor.de>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

From: Stefan Ringel <stefan.ringel@arcor.de>

change input control


Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/tm6000-core.c  |   12 +-
 drivers/staging/tm6000/tm6000-stds.c  |  774 ++++++---------------------------
 drivers/staging/tm6000/tm6000-video.c |    9 +-
 drivers/staging/tm6000/tm6000.h       |    4 +-
 4 files changed, 130 insertions(+), 669 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
index f4b9fcd..259cf80 100644
--- a/drivers/staging/tm6000/tm6000-core.c
+++ b/drivers/staging/tm6000/tm6000-core.c
@@ -327,7 +327,7 @@ int tm6000_init_analog_mode(struct tm6000_core *dev)
 	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_frequency, &f);
 
 	msleep(100);
-	tm6000_set_standard(dev, &dev->norm);
+	tm6000_set_standard(dev);
 	tm6000_set_vbi(dev);
 	tm6000_set_audio_bitrate(dev, 48000);
 
@@ -489,14 +489,6 @@ struct reg_init tm6010_init_tab[] = {
 	{ TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xf0 },
 	{ TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2 },
 	{ TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x60 },
-	{ TM6010_REQ08_R03_A_AUTO_GAIN_CTRL, 0x00},
-	{ TM6010_REQ08_R04_A_SIF_AMP_CTRL, 0x80},
-	{ TM6010_REQ08_R0C_A_ASD_THRES2, 0x0a},
-	{ TM6010_REQ08_R0D_A_AMD_THRES, 0x40},
-	{ TM6010_REQ08_R1A_A_NICAM_SER_MAX, 0x64},
-	{ TM6010_REQ08_R1B_A_NICAM_SER_MIN, 0x20},
-	{ TM6010_REQ08_R16_A_AGC_GAIN_MAX, 0xfe},
-	{ TM6010_REQ08_R17_A_AGC_GAIN_MIN, 0x01},
 	{ TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc },
 
 	{ TM6010_REQ07_R3F_RESET, 0x01 },
@@ -657,7 +649,7 @@ int tm6000_set_audio_bitrate(struct tm6000_core *dev, int bitrate)
 }
 EXPORT_SYMBOL_GPL(tm6000_set_audio_bitrate);
 
-int tm6000_set_audio_input(struct tm6000_core *dev, enum tm6000_inaudio ainp)
+int tm6000_set_audio_rinput(struct tm6000_core *dev)
 {
 	if (dev->dev_type == TM6010) {
 		/* Audio crossbar setting, default SIF1 */
diff --git a/drivers/staging/tm6000/tm6000-stds.c b/drivers/staging/tm6000/tm6000-stds.c
index 588b1fc..8b29d73 100644
--- a/drivers/staging/tm6000/tm6000-stds.c
+++ b/drivers/staging/tm6000/tm6000-stds.c
@@ -25,422 +25,23 @@
 static unsigned int tm6010_a_mode = 0;
 module_param(tm6010_a_mode, int, 0644);
 MODULE_PARM_DESC(tm6010_a_mode, "set tm6010 sif audio mode");
+
 struct tm6000_reg_settings {
 	unsigned char req;
 	unsigned char reg;
 	unsigned char value;
 };
 
-enum tm6000_audio_std {
-	BG_NICAM,
-	BTSC,
-	BG_A2,
-	DK_NICAM,
-	EIAJ,
-	FM_RADIO,
-	I_NICAM,
-	KOREA_A2,
-	L_NICAM,
-};
-
-struct tm6000_std_tv_settings {
-	v4l2_std_id id;
-	enum tm6000_audio_std audio_default_std;
-
-	struct tm6000_reg_settings sif[12];
-	struct tm6000_reg_settings nosif[12];
-	struct tm6000_reg_settings common[26];
-};
 
 struct tm6000_std_settings {
 	v4l2_std_id id;
-	enum tm6000_audio_std audio_default_std;
-	struct tm6000_reg_settings common[37];
-};
-
-static struct tm6000_std_tv_settings tv_stds[] = {
-	{
-		.id = V4L2_STD_PAL_M,
-		.audio_default_std = BTSC,
-		.sif = {
-			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf2},
-			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf8},
-			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3},
-			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x08},
-			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf1},
-			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xe0},
-			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
-			{TM6010_REQ08_RED_GAIN_SEL, 0xe8},
-			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x62},
-			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfe},
-			{TM6010_REQ07_RFE_POWER_DOWN, 0xcb},
-			{0, 0, 0},
-		},
-		.nosif = {
-			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
-			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf8},
-			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3},
-			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x0f},
-			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf1},
-			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xe0},
-			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
-			{TM6010_REQ08_RED_GAIN_SEL, 0xe8},
-			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x60},
-			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc},
-			{TM6010_REQ07_RFE_POWER_DOWN, 0x8b},
-			{0, 0, 0},
-		},
-		.common = {
-			{TM6010_REQ07_R3F_RESET, 0x01},
-			{TM6010_REQ07_R00_VIDEO_CONTROL0, 0x04},
-			{TM6010_REQ07_R01_VIDEO_CONTROL1, 0x0e},
-			{TM6010_REQ07_R02_VIDEO_CONTROL2, 0x5f},
-			{TM6010_REQ07_R03_YC_SEP_CONTROL, 0x00},
-			{TM6010_REQ07_R07_OUTPUT_CONTROL, 0x31},
-			{TM6010_REQ07_R18_CHROMA_DTO_INCREMENT3, 0x1e},
-			{TM6010_REQ07_R19_CHROMA_DTO_INCREMENT2, 0x83},
-			{TM6010_REQ07_R1A_CHROMA_DTO_INCREMENT1, 0x0a},
-			{TM6010_REQ07_R1B_CHROMA_DTO_INCREMENT0, 0xe0},
-			{TM6010_REQ07_R1C_HSYNC_DTO_INCREMENT3, 0x1c},
-			{TM6010_REQ07_R1D_HSYNC_DTO_INCREMENT2, 0xcc},
-			{TM6010_REQ07_R1E_HSYNC_DTO_INCREMENT1, 0xcc},
-			{TM6010_REQ07_R1F_HSYNC_DTO_INCREMENT0, 0xcd},
-			{TM6010_REQ07_R2E_ACTIVE_VIDEO_HSTART, 0x88},
-			{TM6010_REQ07_R30_ACTIVE_VIDEO_VSTART, 0x20},
-			{TM6010_REQ07_R31_ACTIVE_VIDEO_VHIGHT, 0x61},
-			{TM6010_REQ07_R33_VSYNC_HLOCK_MAX, 0x0c},
-			{TM6010_REQ07_R35_VSYNC_AGC_MAX, 0x1c},
-			{TM6010_REQ07_R82_COMB_FILTER_CONFIG, 0x52},
-			{TM6010_REQ07_R83_CHROMA_LOCK_CONFIG, 0x6F},
-
-			{TM6010_REQ07_R04_LUMA_HAGC_CONTROL, 0xdc},
-			{TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x07},
-
-			{TM6010_REQ07_R3F_RESET, 0x00},
-
-			{0, 0, 0},
-		},
-	}, {
-		.id = V4L2_STD_PAL_Nc,
-		.audio_default_std = BTSC,
-		.sif = {
-			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf2},
-			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf8},
-			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3},
-			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x08},
-			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf1},
-			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xe0},
-			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
-			{TM6010_REQ08_RED_GAIN_SEL, 0xe8},
-			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x62},
-			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfe},
-			{TM6010_REQ07_RFE_POWER_DOWN, 0xcb},
-			{0, 0, 0},
-		},
-		.nosif = {
-			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
-			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf8},
-			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3},
-			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x0f},
-			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf1},
-			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xe0},
-			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
-			{TM6010_REQ08_RED_GAIN_SEL, 0xe8},
-			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x60},
-			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc},
-			{TM6010_REQ07_RFE_POWER_DOWN, 0x8b},
-			{0, 0, 0},
-		},
-		.common = {
-			{TM6010_REQ07_R3F_RESET, 0x01},
-			{TM6010_REQ07_R00_VIDEO_CONTROL0, 0x36},
-			{TM6010_REQ07_R01_VIDEO_CONTROL1, 0x0e},
-			{TM6010_REQ07_R02_VIDEO_CONTROL2, 0x5f},
-			{TM6010_REQ07_R03_YC_SEP_CONTROL, 0x02},
-			{TM6010_REQ07_R07_OUTPUT_CONTROL, 0x31},
-			{TM6010_REQ07_R18_CHROMA_DTO_INCREMENT3, 0x1e},
-			{TM6010_REQ07_R19_CHROMA_DTO_INCREMENT2, 0x91},
-			{TM6010_REQ07_R1A_CHROMA_DTO_INCREMENT1, 0x1f},
-			{TM6010_REQ07_R1B_CHROMA_DTO_INCREMENT0, 0x0c},
-			{TM6010_REQ07_R1C_HSYNC_DTO_INCREMENT3, 0x1c},
-			{TM6010_REQ07_R1D_HSYNC_DTO_INCREMENT2, 0xcc},
-			{TM6010_REQ07_R1E_HSYNC_DTO_INCREMENT1, 0xcc},
-			{TM6010_REQ07_R1F_HSYNC_DTO_INCREMENT0, 0xcd},
-			{TM6010_REQ07_R2E_ACTIVE_VIDEO_HSTART, 0x8c},
-			{TM6010_REQ07_R30_ACTIVE_VIDEO_VSTART, 0x2c},
-			{TM6010_REQ07_R31_ACTIVE_VIDEO_VHIGHT, 0xc1},
-			{TM6010_REQ07_R33_VSYNC_HLOCK_MAX, 0x0c},
-			{TM6010_REQ07_R35_VSYNC_AGC_MAX, 0x1c},
-			{TM6010_REQ07_R82_COMB_FILTER_CONFIG, 0x52},
-			{TM6010_REQ07_R83_CHROMA_LOCK_CONFIG, 0x6F},
-
-			{TM6010_REQ07_R04_LUMA_HAGC_CONTROL, 0xdc},
-			{TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x07},
-
-			{TM6010_REQ07_R3F_RESET, 0x00},
-
-			{0, 0, 0},
-		},
-	}, {
-		.id = V4L2_STD_PAL,
-		.audio_default_std = BG_A2,
-		.sif = {
-			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf2},
-			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf8},
-			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3},
-			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x08},
-			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf1},
-			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xe0},
-			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
-			{TM6010_REQ08_RED_GAIN_SEL, 0xe8},
-			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x62},
-			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfe},
-			{TM6010_REQ07_RFE_POWER_DOWN, 0xcb},
-			{0, 0, 0}
-		},
-		.nosif = {
-			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
-			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf8},
-			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3},
-			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x0f},
-			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf1},
-			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xe0},
-			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
-			{TM6010_REQ08_RED_GAIN_SEL, 0xe8},
-			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x60},
-			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc},
-			{TM6010_REQ07_RFE_POWER_DOWN, 0x8b},
-			{0, 0, 0},
-		},
-		.common = {
-			{TM6010_REQ07_R3F_RESET, 0x01},
-			{TM6010_REQ07_R00_VIDEO_CONTROL0, 0x32},
-			{TM6010_REQ07_R01_VIDEO_CONTROL1, 0x0e},
-			{TM6010_REQ07_R02_VIDEO_CONTROL2, 0x5f},
-			{TM6010_REQ07_R03_YC_SEP_CONTROL, 0x02},
-			{TM6010_REQ07_R07_OUTPUT_CONTROL, 0x31},
-			{TM6010_REQ07_R18_CHROMA_DTO_INCREMENT3, 0x25},
-			{TM6010_REQ07_R19_CHROMA_DTO_INCREMENT2, 0xd5},
-			{TM6010_REQ07_R1A_CHROMA_DTO_INCREMENT1, 0x63},
-			{TM6010_REQ07_R1B_CHROMA_DTO_INCREMENT0, 0x50},
-			{TM6010_REQ07_R1C_HSYNC_DTO_INCREMENT3, 0x1c},
-			{TM6010_REQ07_R1D_HSYNC_DTO_INCREMENT2, 0xcc},
-			{TM6010_REQ07_R1E_HSYNC_DTO_INCREMENT1, 0xcc},
-			{TM6010_REQ07_R1F_HSYNC_DTO_INCREMENT0, 0xcd},
-			{TM6010_REQ07_R2E_ACTIVE_VIDEO_HSTART, 0x8c},
-			{TM6010_REQ07_R30_ACTIVE_VIDEO_VSTART, 0x2c},
-			{TM6010_REQ07_R31_ACTIVE_VIDEO_VHIGHT, 0xc1},
-			{TM6010_REQ07_R33_VSYNC_HLOCK_MAX, 0x0c},
-			{TM6010_REQ07_R35_VSYNC_AGC_MAX, 0x1c},
-			{TM6010_REQ07_R82_COMB_FILTER_CONFIG, 0x52},
-			{TM6010_REQ07_R83_CHROMA_LOCK_CONFIG, 0x6F},
-
-			{TM6010_REQ07_R04_LUMA_HAGC_CONTROL, 0xdc},
-			{TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x07},
-
-			{TM6010_REQ07_R3F_RESET, 0x00},
-
-			{0, 0, 0},
-		},
-	}, {
-		.id = V4L2_STD_SECAM_B | V4L2_STD_SECAM_G,
-		.audio_default_std = BG_NICAM,
-		.sif = {
-			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf2},
-			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf8},
-			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3},
-			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x08},
-			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf1},
-			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xe0},
-			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
-			{TM6010_REQ08_RED_GAIN_SEL, 0xe8},
-			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x62},
-			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfe},
-			{TM6010_REQ07_RFE_POWER_DOWN, 0xcb},
-			{0, 0, 0},
-		},
-		.nosif = {
-			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
-			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf8},
-			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3},
-			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x0f},
-			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf1},
-			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xe0},
-			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
-			{TM6010_REQ08_RED_GAIN_SEL, 0xe8},
-			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x60},
-			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc},
-			{TM6010_REQ07_RFE_POWER_DOWN, 0x8b},
-			{0, 0, 0},
-		},
-		.common = {
-			{TM6010_REQ07_R3F_RESET, 0x01},
-			{TM6010_REQ07_R00_VIDEO_CONTROL0, 0x38},
-			{TM6010_REQ07_R01_VIDEO_CONTROL1, 0x0e},
-			{TM6010_REQ07_R02_VIDEO_CONTROL2, 0x5f},
-			{TM6010_REQ07_R03_YC_SEP_CONTROL, 0x02},
-			{TM6010_REQ07_R07_OUTPUT_CONTROL, 0x31},
-			{TM6010_REQ07_R18_CHROMA_DTO_INCREMENT3, 0x24},
-			{TM6010_REQ07_R19_CHROMA_DTO_INCREMENT2, 0x92},
-			{TM6010_REQ07_R1A_CHROMA_DTO_INCREMENT1, 0xe8},
-			{TM6010_REQ07_R1B_CHROMA_DTO_INCREMENT0, 0xed},
-			{TM6010_REQ07_R1C_HSYNC_DTO_INCREMENT3, 0x1c},
-			{TM6010_REQ07_R1D_HSYNC_DTO_INCREMENT2, 0xcc},
-			{TM6010_REQ07_R1E_HSYNC_DTO_INCREMENT1, 0xcc},
-			{TM6010_REQ07_R1F_HSYNC_DTO_INCREMENT0, 0xcd},
-			{TM6010_REQ07_R2E_ACTIVE_VIDEO_HSTART, 0x8c},
-			{TM6010_REQ07_R30_ACTIVE_VIDEO_VSTART, 0x2c},
-			{TM6010_REQ07_R31_ACTIVE_VIDEO_VHIGHT, 0xc1},
-			{TM6010_REQ07_R33_VSYNC_HLOCK_MAX, 0x2c},
-			{TM6010_REQ07_R35_VSYNC_AGC_MAX, 0x18},
-			{TM6010_REQ07_R82_COMB_FILTER_CONFIG, 0x42},
-			{TM6010_REQ07_R83_CHROMA_LOCK_CONFIG, 0xFF},
-
-			{TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x07},
-
-			{TM6010_REQ07_R3F_RESET, 0x00},
-			{0, 0, 0},
-		},
-	}, {
-		.id = V4L2_STD_SECAM_DK,
-		.audio_default_std = DK_NICAM,
-		.sif = {
-			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf2},
-			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf8},
-			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3},
-			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x08},
-			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf1},
-			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xe0},
-			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
-			{TM6010_REQ08_RED_GAIN_SEL, 0xe8},
-			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x62},
-			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfe},
-			{TM6010_REQ07_RFE_POWER_DOWN, 0xcb},
-			{0, 0, 0},
-		},
-		.nosif = {
-			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
-			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf8},
-			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3},
-			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x0f},
-			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf1},
-			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xe0},
-			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
-			{TM6010_REQ08_RED_GAIN_SEL, 0xe8},
-			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x60},
-			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc},
-			{TM6010_REQ07_RFE_POWER_DOWN, 0x8b},
-			{0, 0, 0},
-		},
-		.common = {
-			{TM6010_REQ07_R3F_RESET, 0x01},
-			{TM6010_REQ07_R00_VIDEO_CONTROL0, 0x38},
-			{TM6010_REQ07_R01_VIDEO_CONTROL1, 0x0e},
-			{TM6010_REQ07_R02_VIDEO_CONTROL2, 0x5f},
-			{TM6010_REQ07_R03_YC_SEP_CONTROL, 0x02},
-			{TM6010_REQ07_R07_OUTPUT_CONTROL, 0x31},
-			{TM6010_REQ07_R18_CHROMA_DTO_INCREMENT3, 0x24},
-			{TM6010_REQ07_R19_CHROMA_DTO_INCREMENT2, 0x92},
-			{TM6010_REQ07_R1A_CHROMA_DTO_INCREMENT1, 0xe8},
-			{TM6010_REQ07_R1B_CHROMA_DTO_INCREMENT0, 0xed},
-			{TM6010_REQ07_R1C_HSYNC_DTO_INCREMENT3, 0x1c},
-			{TM6010_REQ07_R1D_HSYNC_DTO_INCREMENT2, 0xcc},
-			{TM6010_REQ07_R1E_HSYNC_DTO_INCREMENT1, 0xcc},
-			{TM6010_REQ07_R1F_HSYNC_DTO_INCREMENT0, 0xcd},
-			{TM6010_REQ07_R2E_ACTIVE_VIDEO_HSTART, 0x8c},
-			{TM6010_REQ07_R30_ACTIVE_VIDEO_VSTART, 0x2c},
-			{TM6010_REQ07_R31_ACTIVE_VIDEO_VHIGHT, 0xc1},
-			{TM6010_REQ07_R33_VSYNC_HLOCK_MAX, 0x2c},
-			{TM6010_REQ07_R35_VSYNC_AGC_MAX, 0x18},
-			{TM6010_REQ07_R82_COMB_FILTER_CONFIG, 0x42},
-			{TM6010_REQ07_R83_CHROMA_LOCK_CONFIG, 0xFF},
-
-			{TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x07},
-
-			{TM6010_REQ07_R3F_RESET, 0x00},
-			{0, 0, 0},
-		},
-	}, {
-		.id = V4L2_STD_NTSC,
-		.audio_default_std = BTSC,
-		.sif = {
-			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf2},
-			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf8},
-			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3},
-			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x08},
-			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf1},
-			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xe0},
-			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
-			{TM6010_REQ08_RED_GAIN_SEL, 0xe8},
-			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x62},
-			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfe},
-			{TM6010_REQ07_RFE_POWER_DOWN, 0xcb},
-			{0, 0, 0},
-		},
-		.nosif = {
-			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
-			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf8},
-			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3},
-			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x0f},
-			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf1},
-			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xe0},
-			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
-			{TM6010_REQ08_RED_GAIN_SEL, 0xe8},
-			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x60},
-			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc},
-			{TM6010_REQ07_RFE_POWER_DOWN, 0x8b},
-			{0, 0, 0},
-		},
-		.common = {
-			{TM6010_REQ07_R3F_RESET, 0x01},
-			{TM6010_REQ07_R00_VIDEO_CONTROL0, 0x00},
-			{TM6010_REQ07_R01_VIDEO_CONTROL1, 0x0f},
-			{TM6010_REQ07_R02_VIDEO_CONTROL2, 0x5f},
-			{TM6010_REQ07_R03_YC_SEP_CONTROL, 0x00},
-			{TM6010_REQ07_R07_OUTPUT_CONTROL, 0x31},
-			{TM6010_REQ07_R18_CHROMA_DTO_INCREMENT3, 0x1e},
-			{TM6010_REQ07_R19_CHROMA_DTO_INCREMENT2, 0x8b},
-			{TM6010_REQ07_R1A_CHROMA_DTO_INCREMENT1, 0xa2},
-			{TM6010_REQ07_R1B_CHROMA_DTO_INCREMENT0, 0xe9},
-			{TM6010_REQ07_R1C_HSYNC_DTO_INCREMENT3, 0x1c},
-			{TM6010_REQ07_R1D_HSYNC_DTO_INCREMENT2, 0xcc},
-			{TM6010_REQ07_R1E_HSYNC_DTO_INCREMENT1, 0xcc},
-			{TM6010_REQ07_R1F_HSYNC_DTO_INCREMENT0, 0xcd},
-			{TM6010_REQ07_R2E_ACTIVE_VIDEO_HSTART, 0x88},
-			{TM6010_REQ07_R30_ACTIVE_VIDEO_VSTART, 0x22},
-			{TM6010_REQ07_R31_ACTIVE_VIDEO_VHIGHT, 0x61},
-			{TM6010_REQ07_R33_VSYNC_HLOCK_MAX, 0x1c},
-			{TM6010_REQ07_R35_VSYNC_AGC_MAX, 0x1c},
-			{TM6010_REQ07_R82_COMB_FILTER_CONFIG, 0x42},
-			{TM6010_REQ07_R83_CHROMA_LOCK_CONFIG, 0x6F},
-
-			{TM6010_REQ07_R04_LUMA_HAGC_CONTROL, 0xdd},
-			{TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x07},
-
-			{TM6010_REQ07_R3F_RESET, 0x00},
-
-			{0, 0, 0},
-		},
-	},
+	struct tm6000_reg_settings common[27];
 };
 
 static struct tm6000_std_settings composite_stds[] = {
 	{
 		.id = V4L2_STD_PAL_M,
-		.audio_default_std = BTSC,
 		.common = {
-			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
-			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf4},
-			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3},
-			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x0f},
-			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf1},
-			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xe0},
-			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
-			{TM6010_REQ08_RED_GAIN_SEL, 0xe8},
-			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x68},
-			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc},
-			{TM6010_REQ07_RFE_POWER_DOWN, 0x8b},
-
 			{TM6010_REQ07_R3F_RESET, 0x01},
 			{TM6010_REQ07_R00_VIDEO_CONTROL0, 0x04},
 			{TM6010_REQ07_R01_VIDEO_CONTROL1, 0x0e},
@@ -470,20 +71,7 @@ static struct tm6000_std_settings composite_stds[] = {
 		},
 	 }, {
 		.id = V4L2_STD_PAL_Nc,
-		.audio_default_std = BTSC,
 		.common = {
-			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
-			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf4},
-			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3},
-			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x0f},
-			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf1},
-			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xe0},
-			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
-			{TM6010_REQ08_RED_GAIN_SEL, 0xe8},
-			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x68},
-			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc},
-			{TM6010_REQ07_RFE_POWER_DOWN, 0x8b},
-
 			{TM6010_REQ07_R3F_RESET, 0x01},
 			{TM6010_REQ07_R00_VIDEO_CONTROL0, 0x36},
 			{TM6010_REQ07_R01_VIDEO_CONTROL1, 0x0e},
@@ -513,20 +101,7 @@ static struct tm6000_std_settings composite_stds[] = {
 		},
 	}, {
 		.id = V4L2_STD_PAL,
-		.audio_default_std = BG_A2,
 		.common = {
-			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
-			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf4},
-			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3},
-			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x0f},
-			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf1},
-			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xe0},
-			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
-			{TM6010_REQ08_RED_GAIN_SEL, 0xe8},
-			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x68},
-			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc},
-			{TM6010_REQ07_RFE_POWER_DOWN, 0x8b},
-
 			{TM6010_REQ07_R3F_RESET, 0x01},
 			{TM6010_REQ07_R00_VIDEO_CONTROL0, 0x32},
 			{TM6010_REQ07_R01_VIDEO_CONTROL1, 0x0e},
@@ -556,62 +131,7 @@ static struct tm6000_std_settings composite_stds[] = {
 		},
 	 }, {
 		.id = V4L2_STD_SECAM,
-		.audio_default_std = BG_NICAM,
-		.common = {
-			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
-			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf4},
-			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3},
-			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x0f},
-			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf1},
-			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xe0},
-			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
-			{TM6010_REQ08_RED_GAIN_SEL, 0xe8},
-			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x68},
-			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc},
-			{TM6010_REQ07_RFE_POWER_DOWN, 0x8b},
-
-			{TM6010_REQ07_R3F_RESET, 0x01},
-			{TM6010_REQ07_R00_VIDEO_CONTROL0, 0x38},
-			{TM6010_REQ07_R01_VIDEO_CONTROL1, 0x0e},
-			{TM6010_REQ07_R02_VIDEO_CONTROL2, 0x5f},
-			{TM6010_REQ07_R03_YC_SEP_CONTROL, 0x02},
-			{TM6010_REQ07_R07_OUTPUT_CONTROL, 0x31},
-			{TM6010_REQ07_R18_CHROMA_DTO_INCREMENT3, 0x24},
-			{TM6010_REQ07_R19_CHROMA_DTO_INCREMENT2, 0x92},
-			{TM6010_REQ07_R1A_CHROMA_DTO_INCREMENT1, 0xe8},
-			{TM6010_REQ07_R1B_CHROMA_DTO_INCREMENT0, 0xed},
-			{TM6010_REQ07_R1C_HSYNC_DTO_INCREMENT3, 0x1c},
-			{TM6010_REQ07_R1D_HSYNC_DTO_INCREMENT2, 0xcc},
-			{TM6010_REQ07_R1E_HSYNC_DTO_INCREMENT1, 0xcc},
-			{TM6010_REQ07_R1F_HSYNC_DTO_INCREMENT0, 0xcd},
-			{TM6010_REQ07_R2E_ACTIVE_VIDEO_HSTART, 0x8c},
-			{TM6010_REQ07_R30_ACTIVE_VIDEO_VSTART, 0x2c},
-			{TM6010_REQ07_R31_ACTIVE_VIDEO_VHIGHT, 0xc1},
-			{TM6010_REQ07_R33_VSYNC_HLOCK_MAX, 0x2c},
-			{TM6010_REQ07_R35_VSYNC_AGC_MAX, 0x18},
-			{TM6010_REQ07_R82_COMB_FILTER_CONFIG, 0x42},
-			{TM6010_REQ07_R83_CHROMA_LOCK_CONFIG, 0xFF},
-
-			{TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x07},
-			{TM6010_REQ07_R3F_RESET, 0x00},
-			{0, 0, 0},
-		},
-	}, {
-		.id = V4L2_STD_SECAM_DK,
-		.audio_default_std = DK_NICAM,
 		.common = {
-			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
-			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf4},
-			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3},
-			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x0f},
-			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf1},
-			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xe0},
-			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
-			{TM6010_REQ08_RED_GAIN_SEL, 0xe8},
-			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x68},
-			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc},
-			{TM6010_REQ07_RFE_POWER_DOWN, 0x8b},
-
 			{TM6010_REQ07_R3F_RESET, 0x01},
 			{TM6010_REQ07_R00_VIDEO_CONTROL0, 0x38},
 			{TM6010_REQ07_R01_VIDEO_CONTROL1, 0x0e},
@@ -640,20 +160,7 @@ static struct tm6000_std_settings composite_stds[] = {
 		},
 	}, {
 		.id = V4L2_STD_NTSC,
-		.audio_default_std = BTSC,
 		.common = {
-			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
-			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf4},
-			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3},
-			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x0f},
-			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf1},
-			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xe0},
-			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
-			{TM6010_REQ08_RED_GAIN_SEL, 0xe8},
-			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x68},
-			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc},
-			{TM6010_REQ07_RFE_POWER_DOWN, 0x8b},
-
 			{TM6010_REQ07_R3F_RESET, 0x01},
 			{TM6010_REQ07_R00_VIDEO_CONTROL0, 0x00},
 			{TM6010_REQ07_R01_VIDEO_CONTROL1, 0x0f},
@@ -687,20 +194,7 @@ static struct tm6000_std_settings composite_stds[] = {
 static struct tm6000_std_settings svideo_stds[] = {
 	{
 		.id = V4L2_STD_PAL_M,
-		.audio_default_std = BTSC,
 		.common = {
-			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
-			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xfc},
-			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf8},
-			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x00},
-			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf2},
-			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xf0},
-			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
-			{TM6010_REQ08_RED_GAIN_SEL, 0xe0},
-			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x68},
-			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc},
-			{TM6010_REQ07_RFE_POWER_DOWN, 0x8a},
-
 			{TM6010_REQ07_R3F_RESET, 0x01},
 			{TM6010_REQ07_R00_VIDEO_CONTROL0, 0x05},
 			{TM6010_REQ07_R01_VIDEO_CONTROL1, 0x0e},
@@ -730,20 +224,7 @@ static struct tm6000_std_settings svideo_stds[] = {
 		},
 	}, {
 		.id = V4L2_STD_PAL_Nc,
-		.audio_default_std = BTSC,
 		.common = {
-			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
-			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xfc},
-			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf8},
-			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x00},
-			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf2},
-			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xf0},
-			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
-			{TM6010_REQ08_RED_GAIN_SEL, 0xe0},
-			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x68},
-			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc},
-			{TM6010_REQ07_RFE_POWER_DOWN, 0x8a},
-
 			{TM6010_REQ07_R3F_RESET, 0x01},
 			{TM6010_REQ07_R00_VIDEO_CONTROL0, 0x37},
 			{TM6010_REQ07_R01_VIDEO_CONTROL1, 0x0e},
@@ -773,20 +254,7 @@ static struct tm6000_std_settings svideo_stds[] = {
 		},
 	}, {
 		.id = V4L2_STD_PAL,
-		.audio_default_std = BG_A2,
 		.common = {
-			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
-			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xfc},
-			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf8},
-			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x00},
-			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf2},
-			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xf0},
-			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
-			{TM6010_REQ08_RED_GAIN_SEL, 0xe0},
-			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x68},
-			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc},
-			{TM6010_REQ07_RFE_POWER_DOWN, 0x8a},
-
 			{TM6010_REQ07_R3F_RESET, 0x01},
 			{TM6010_REQ07_R00_VIDEO_CONTROL0, 0x33},
 			{TM6010_REQ07_R01_VIDEO_CONTROL1, 0x0e},
@@ -816,62 +284,7 @@ static struct tm6000_std_settings svideo_stds[] = {
 		},
 	 }, {
 		.id = V4L2_STD_SECAM,
-		.audio_default_std = BG_NICAM,
-		.common = {
-			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
-			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xfc},
-			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf8},
-			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x00},
-			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf2},
-			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xf0},
-			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
-			{TM6010_REQ08_RED_GAIN_SEL, 0xe0},
-			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x68},
-			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc},
-			{TM6010_REQ07_RFE_POWER_DOWN, 0x8a},
-
-			{TM6010_REQ07_R3F_RESET, 0x01},
-			{TM6010_REQ07_R00_VIDEO_CONTROL0, 0x39},
-			{TM6010_REQ07_R01_VIDEO_CONTROL1, 0x0e},
-			{TM6010_REQ07_R02_VIDEO_CONTROL2, 0x5f},
-			{TM6010_REQ07_R03_YC_SEP_CONTROL, 0x03},
-			{TM6010_REQ07_R07_OUTPUT_CONTROL, 0x31},
-			{TM6010_REQ07_R18_CHROMA_DTO_INCREMENT3, 0x24},
-			{TM6010_REQ07_R19_CHROMA_DTO_INCREMENT2, 0x92},
-			{TM6010_REQ07_R1A_CHROMA_DTO_INCREMENT1, 0xe8},
-			{TM6010_REQ07_R1B_CHROMA_DTO_INCREMENT0, 0xed},
-			{TM6010_REQ07_R1C_HSYNC_DTO_INCREMENT3, 0x1c},
-			{TM6010_REQ07_R1D_HSYNC_DTO_INCREMENT2, 0xcc},
-			{TM6010_REQ07_R1E_HSYNC_DTO_INCREMENT1, 0xcc},
-			{TM6010_REQ07_R1F_HSYNC_DTO_INCREMENT0, 0xcd},
-			{TM6010_REQ07_R2E_ACTIVE_VIDEO_HSTART, 0x8c},
-			{TM6010_REQ07_R30_ACTIVE_VIDEO_VSTART, 0x2a},
-			{TM6010_REQ07_R31_ACTIVE_VIDEO_VHIGHT, 0xc1},
-			{TM6010_REQ07_R33_VSYNC_HLOCK_MAX, 0x2c},
-			{TM6010_REQ07_R35_VSYNC_AGC_MAX, 0x18},
-			{TM6010_REQ07_R82_COMB_FILTER_CONFIG, 0x42},
-			{TM6010_REQ07_R83_CHROMA_LOCK_CONFIG, 0xFF},
-
-			{TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x07},
-			{TM6010_REQ07_R3F_RESET, 0x00},
-			{0, 0, 0},
-		},
-	}, {
-		.id = V4L2_STD_SECAM_DK,
-		.audio_default_std = DK_NICAM,
 		.common = {
-			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
-			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xfc},
-			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf8},
-			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x00},
-			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf2},
-			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xf0},
-			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
-			{TM6010_REQ08_RED_GAIN_SEL, 0xe0},
-			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x68},
-			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc},
-			{TM6010_REQ07_RFE_POWER_DOWN, 0x8a},
-
 			{TM6010_REQ07_R3F_RESET, 0x01},
 			{TM6010_REQ07_R00_VIDEO_CONTROL0, 0x39},
 			{TM6010_REQ07_R01_VIDEO_CONTROL1, 0x0e},
@@ -900,20 +313,7 @@ static struct tm6000_std_settings svideo_stds[] = {
 		},
 	}, {
 		.id = V4L2_STD_NTSC,
-		.audio_default_std = BTSC,
 		.common = {
-			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
-			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xfc},
-			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf8},
-			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x00},
-			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf2},
-			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xf0},
-			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
-			{TM6010_REQ08_RED_GAIN_SEL, 0xe0},
-			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x68},
-			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc},
-			{TM6010_REQ07_RFE_POWER_DOWN, 0x8a},
-
 			{TM6010_REQ07_R3F_RESET, 0x01},
 			{TM6010_REQ07_R00_VIDEO_CONTROL0, 0x01},
 			{TM6010_REQ07_R01_VIDEO_CONTROL1, 0x0f},
@@ -946,8 +346,7 @@ static struct tm6000_std_settings svideo_stds[] = {
 };
 
 
-static int tm6000_set_audio_std(struct tm6000_core *dev,
-				enum tm6000_audio_std std)
+static int tm6000_set_audio_std(struct tm6000_core *dev)
 {
 	uint8_t areg_02 = 0x04; /* GC1 Fixed gain 0dB */
 	uint8_t areg_05 = 0x01; /* Auto 4.5 = M Japan, Auto 6.5 = DK */
@@ -1112,10 +511,6 @@ static int tm6000_load_std(struct tm6000_core *dev,
 		if (!set[i].req)
 			return 0;
 
-		if ((dev->dev_type != TM6010) &&
-		    (set[i].req == REQ_08_SET_GET_AVREG_BIT))
-				continue;
-
 		rc = tm6000_set_reg(dev, set[i].req, set[i].reg, set[i].value);
 		if (rc < 0) {
 			printk(KERN_ERR "Error %i while setting "
@@ -1128,53 +523,126 @@ static int tm6000_load_std(struct tm6000_core *dev,
 	return 0;
 }
 
-static int tm6000_set_tv(struct tm6000_core *dev, int pos)
-{
-	int rc;
-
-	/* FIXME: This code is for tm6010 - not tested yet - doesn't work with
-	   tm5600
-	 */
-
-	/* FIXME: This is tuner-dependent */
-	int nosif = 0;
-
-	if (nosif) {
-		rc = tm6000_load_std(dev, tv_stds[pos].nosif,
-				     sizeof(tv_stds[pos].nosif));
-	} else {
-		rc = tm6000_load_std(dev, tv_stds[pos].sif,
-				     sizeof(tv_stds[pos].sif));
-	}
-	if (rc < 0)
-		return rc;
-	rc = tm6000_load_std(dev, tv_stds[pos].common,
-			     sizeof(tv_stds[pos].common));
-
-	tm6000_set_audio_std(dev, tv_stds[pos].audio_default_std);
-
-	return rc;
-}
-
-int tm6000_set_standard(struct tm6000_core *dev, v4l2_std_id * norm)
+int tm6000_set_standard(struct tm6000_core *dev)
 {
 	int i, rc = 0;
+	u8 reg_07_fe = 0x8a;
+	u8 reg_08_f1 = 0xfc;
+	u8 reg_08_e2 = 0xf0;
+	u8 reg_08_e6 = 0x0f;
 
-	dev->norm = *norm;
 	tm6000_get_std_res(dev);
 
-	switch (dev->input) {
-	case TM6000_INPUT_TV:
-		for (i = 0; i < ARRAY_SIZE(tv_stds); i++) {
-			if (*norm & tv_stds[i].id) {
-				rc = tm6000_set_tv(dev, i);
-				goto ret;
-			}
+	if (dev->radio) {
+		/* todo */
+	}
+
+	if (dev->dev_type == TM6010) {
+		switch (dev->vinput[dev->input].vmux) {
+		case TM6000_VMUX_VIDEO_A:
+			tm6000_set_reg(dev, TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf4);
+			tm6000_set_reg(dev, TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf1);
+			tm6000_set_reg(dev, TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xe0);
+			tm6000_set_reg(dev, TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2);
+			tm6000_set_reg(dev, TM6010_REQ08_RED_GAIN_SEL, 0xe8);
+			reg_07_fe |= 0x01;
+			break;
+		case TM6000_VMUX_VIDEO_B:
+			tm6000_set_reg(dev, TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf8);
+			tm6000_set_reg(dev, TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf1);
+			tm6000_set_reg(dev, TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xe0);
+			tm6000_set_reg(dev, TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2);
+			tm6000_set_reg(dev, TM6010_REQ08_RED_GAIN_SEL, 0xe8);
+			reg_07_fe |= 0x01;
+			break;
+		case TM6000_VMUX_VIDEO_AB:
+			tm6000_set_reg(dev, TM6010_REQ08_RE3_ADC_IN1_SEL, 0xfc);
+			tm6000_set_reg(dev, TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf8);
+			reg_08_e6 = 0x00;
+			tm6000_set_reg(dev, TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf2);
+			tm6000_set_reg(dev, TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xf0);
+			tm6000_set_reg(dev, TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2);
+			tm6000_set_reg(dev, TM6010_REQ08_RED_GAIN_SEL, 0xe0);
+			break;
+		default:
+			break;
 		}
-		return -EINVAL;
-	case TM6000_INPUT_SVIDEO:
+		switch (dev->vinput[dev->input].amux) {
+		case TM6000_AMUX_ADC1:
+			tm6000_set_reg_mask(dev, TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG,
+				0x00, 0x0f);
+			break;
+		case TM6000_AMUX_ADC2:
+			tm6000_set_reg_mask(dev, TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG,
+				0x08, 0x0f);
+			break;
+		case TM6000_AMUX_SIF1:
+			reg_08_e2 |= 0x02;
+			reg_08_e6 = 0x08;
+			reg_07_fe |= 0x40;
+			reg_08_f1 |= 0x02;
+			tm6000_set_reg(dev, TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3);
+			tm6000_set_reg_mask(dev, TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG,
+				0x02, 0x0f);
+			break;
+		case TM6000_AMUX_SIF2:
+			reg_08_e2 |= 0x02;
+			reg_08_e6 = 0x08;
+			reg_07_fe |= 0x40;
+			reg_08_f1 |= 0x02;
+			tm6000_set_reg(dev, TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf7);
+			tm6000_set_reg_mask(dev, TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG,
+				0x02, 0x0f);
+			break;
+		default:
+			break;
+		}
+		tm6000_set_reg(dev, TM6010_REQ08_RE2_POWER_DOWN_CTRL1, reg_08_e2);
+		tm6000_set_reg(dev, TM6010_REQ08_RE6_POWER_DOWN_CTRL2, reg_08_e6);
+		tm6000_set_reg(dev, TM6010_REQ08_RF1_AADC_POWER_DOWN, reg_08_f1);
+		tm6000_set_reg(dev, TM6010_REQ07_RFE_POWER_DOWN, reg_07_fe);
+	} else {
+		switch (dev->vinput[dev->input].vmux) {
+		case TM6000_VMUX_VIDEO_A:
+			tm6000_set_reg(dev, TM6000_REQ07_RE3_VADC_INP_LPF_SEL1, 0x10);
+			tm6000_set_reg(dev, TM6000_REQ07_RE5_VADC_INP_LPF_SEL2, 0x00);
+			tm6000_set_reg(dev, TM6000_REQ07_RE8_VADC_PWDOWN_CTL, 0x0f);
+			tm6000_set_reg(dev,
+			    REQ_03_SET_GET_MCU_PIN, dev->vinput[dev->input].v_gpio, 0);
+			break;
+		case TM6000_VMUX_VIDEO_B:
+			tm6000_set_reg(dev, TM6000_REQ07_RE3_VADC_INP_LPF_SEL1, 0x00);
+			tm6000_set_reg(dev, TM6000_REQ07_RE5_VADC_INP_LPF_SEL2, 0x00);
+			tm6000_set_reg(dev, TM6000_REQ07_RE8_VADC_PWDOWN_CTL, 0x0f);
+			tm6000_set_reg(dev,
+			    REQ_03_SET_GET_MCU_PIN, dev->vinput[dev->input].v_gpio, 0);
+			break;
+		case TM6000_VMUX_VIDEO_AB:
+			tm6000_set_reg(dev, TM6000_REQ07_RE3_VADC_INP_LPF_SEL1, 0x10);
+			tm6000_set_reg(dev, TM6000_REQ07_RE5_VADC_INP_LPF_SEL2, 0x10);
+			tm6000_set_reg(dev, TM6000_REQ07_RE8_VADC_PWDOWN_CTL, 0x00);
+			tm6000_set_reg(dev,
+			    REQ_03_SET_GET_MCU_PIN, dev->vinput[dev->input].v_gpio, 1);
+			break;
+		default:
+			break;
+		}
+		switch (dev->vinput[dev->input].amux) {
+		case TM6000_AMUX_ADC1:
+			tm6000_set_reg_mask(dev,
+				TM6000_REQ07_REB_VADC_AADC_MODE, 0x00, 0x0f);
+			break;
+		case TM6000_AMUX_ADC2:
+			tm6000_set_reg_mask(dev,
+				TM6000_REQ07_REB_VADC_AADC_MODE, 0x04, 0x0f);
+			break;
+		default:
+			break;
+		}
+	}
+	if (dev->vinput[dev->input].type == TM6000_INPUT_SVIDEO) {
 		for (i = 0; i < ARRAY_SIZE(svideo_stds); i++) {
-			if (*norm & svideo_stds[i].id) {
+			if (dev->norm & svideo_stds[i].id) {
 				rc = tm6000_load_std(dev, svideo_stds[i].common,
 						     sizeof(svideo_stds[i].
 							    common));
@@ -1182,14 +650,13 @@ int tm6000_set_standard(struct tm6000_core *dev, v4l2_std_id * norm)
 			}
 		}
 		return -EINVAL;
-	case TM6000_INPUT_COMPOSITE:
+	} else {
 		for (i = 0; i < ARRAY_SIZE(composite_stds); i++) {
-			if (*norm & composite_stds[i].id) {
+			if (dev->norm & composite_stds[i].id) {
 				rc = tm6000_load_std(dev,
 						     composite_stds[i].common,
 						     sizeof(composite_stds[i].
 							    common));
-				tm6000_set_audio_std(dev, composite_stds[i].audio_default_std);
 				goto ret;
 			}
 		}
@@ -1200,6 +667,11 @@ ret:
 	if (rc < 0)
 		return rc;
 
+	if ((dev->dev_type == TM6010) &&
+	    ((dev->vinput[dev->input].amux == TM6000_AMUX_SIF1) ||
+	    (dev->vinput[dev->input].amux == TM6000_AMUX_SIF2)))
+		tm6000_set_audio_std(dev);
+
 	msleep(40);
 
 
diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
index 8b3bf7e..a9a5919 100644
--- a/drivers/staging/tm6000/tm6000-video.c
+++ b/drivers/staging/tm6000/tm6000-video.c
@@ -1271,6 +1271,7 @@ static int vidioc_s_tuner(struct file *file, void *priv,
 	dprintk(dev, 3, "audio mode: %x\n", t->audmode);
 
 	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_tuner, t);
+
 	return 0;
 }
 
@@ -1537,16 +1538,12 @@ static int tm6000_open(struct file *file)
 
 	if (fh->radio) {
 		dprintk(dev, V4L2_DEBUG_OPEN, "video_open: setting radio device\n");
-		tm6000_set_audio_input(dev, dev->aradio);
-		tm6000_set_volume(dev, dev->ctl_volume);
+		dev->input = 5;
+		tm6000_set_audio_rinput(dev);
 		v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_radio);
 		tm6000_prepare_isoc(dev);
 		tm6000_start_thread(dev);
 	}
-	else {
-		tm6000_set_audio_input(dev, dev->avideo);
-		tm6000_set_volume(dev, dev->ctl_volume);
-	}
 
 	return 0;
 }
diff --git a/drivers/staging/tm6000/tm6000.h b/drivers/staging/tm6000/tm6000.h
index 650decd..e4ca896 100644
--- a/drivers/staging/tm6000/tm6000.h
+++ b/drivers/staging/tm6000/tm6000.h
@@ -320,7 +320,7 @@ int tm6000_init(struct tm6000_core *dev);
 int tm6000_init_analog_mode(struct tm6000_core *dev);
 int tm6000_init_digital_mode(struct tm6000_core *dev);
 int tm6000_set_audio_bitrate(struct tm6000_core *dev, int bitrate);
-int tm6000_set_audio_input(struct tm6000_core *dev, enum tm6000_inaudio ainp);
+int tm6000_set_audio_rinput(struct tm6000_core *dev);
 int tm6000_tvaudio_set_mute(struct tm6000_core *dev, u8 mute);
 void tm6000_set_volume(struct tm6000_core *dev, int vol);
 
@@ -341,7 +341,7 @@ int tm6000_call_fillbuf(struct tm6000_core *dev, enum tm6000_ops_type type,
 
 /* In tm6000-stds.c */
 void tm6000_get_std_res(struct tm6000_core *dev);
-int tm6000_set_standard(struct tm6000_core *dev, v4l2_std_id *norm);
+int tm6000_set_standard(struct tm6000_core *dev);
 
 /* In tm6000-i2c.c */
 int tm6000_i2c_register(struct tm6000_core *dev);
-- 
1.7.4.2

