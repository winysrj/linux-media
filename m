Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60252 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758070Ab1BRBKP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Feb 2011 20:10:15 -0500
Received: by bwz15 with SMTP id 15so273409bwz.19
        for <linux-media@vger.kernel.org>; Thu, 17 Feb 2011 17:10:13 -0800 (PST)
Date: Fri, 18 Feb 2011 10:11:05 +0900
From: Dmitri Belimov <d.belimov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Stefan Ringel <stefan.ringel@arcor.de>,
	Felipe Sanches <juca@members.fsf.org>,
	Bee Hock Goh <beehock@gmail.com>,
	Luis Henrique Fagundes <lhfagundes@hacklab.com.br>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jarod Wilson <jarod@redhat.com>
Subject: [PATCH] tm6000: add radio
Message-ID: <20110218101105.3b6a5a47@glory.local>
In-Reply-To: <4D5D8BFB.4070802@redhat.com>
References: <4CAD5A78.3070803@redhat.com>
	<4CB492D4.1000609@arcor.de>
	<20101129174412.08f2001c@glory.local>
	<4CF51C9E.6040600@arcor.de>
	<20101201144704.43b58f2c@glory.local>
	<4CF67AB9.6020006@arcor.de>
	<20101202134128.615bbfa0@glory.local>
	<4CF71CF6.7080603@redhat.com>
	<20101206010934.55d07569@glory.local>
	<4CFBF62D.7010301@arcor.de>
	<20101206190230.2259d7ab@glory.local>
	<4CFEA3D2.4050309@arcor.de>
	<20101208125539.739e2ed2@glory.local>
	<4CFFAD1E.7040004@arcor.de>
	<20101214122325.5cdea67e@glory.local>
	<4D079ADF.2000705@arcor.de>
	<20101215164634.44846128@glory.local>
	<4D08E43C.8080002@arcor.de>
	<20101216183844.6258734e@glory.local>
	<4D0A4883.20804@arcor.de>
	<20101217104633.7c9d10d7@glory.local>
	<4D0AF2A7.6080100@arcor.de>
	<20101217160854.16a1f754@glory.local>
	<4D0BFF4B.3060001@redhat.com>
	<20110120150508.53c9b55e@glory.local>
	<4D388C44.7040500@arcor.de>
	<20110217141257.6d1b578b@glory.local>
	<4D5D8BFB.4070802@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/3xvKmQEYt4H2KpU/xp6D0ka"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--MP_/3xvKmQEYt4H2KpU/xp6D0ka
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi

Changes:
  Add function tm6000_set_reg_mask for change some bits in regs. Very usefull, simplify some code with this function.
  Add control mute
  Add control volume
  Add control audio input MUX
  Add support radio

Radio works well. TV works too

Known bugs:
  The programm gnomeradio can't set freq for radio, it use old v4l API. Audio over USB works via arecord.
  The programm mplayer can set freq but no any audio
           mplayer -v -rawaudio rate=48000 radio://105.2/capture driver=v4l2:alsa:adevice=hw.1,0:amode=1:audiorate=48000:forceaudio:immediatemode=0
  When start watch TV very shortly after radio the kernel crashed hardly. Didn't stop all USB URBs, need some time for stop.

diff --git a/drivers/staging/tm6000/tm6000-alsa.c b/drivers/staging/tm6000/tm6000-alsa.c
index 184cc50..acb0317 100644
--- a/drivers/staging/tm6000/tm6000-alsa.c
+++ b/drivers/staging/tm6000/tm6000-alsa.c
@@ -76,14 +76,11 @@ MODULE_PARM_DESC(debug, "enable debug messages");
 static int _tm6000_start_audio_dma(struct snd_tm6000_card *chip)
 {
 	struct tm6000_core *core = chip->core;
-	int val;
 
 	dprintk(1, "Starting audio DMA\n");
 
 	/* Enables audio */
-	val = tm6000_get_reg(core, TM6010_REQ07_RCC_ACTIVE_VIDEO_IF, 0x0);
-	val |= 0x20;
-	tm6000_set_reg(core, TM6010_REQ07_RCC_ACTIVE_VIDEO_IF, val);
+	tm6000_set_reg_mask(core, TM6010_REQ07_RCC_ACTIVE_VIDEO_IF, 0x40, 0x40);
 
 	tm6000_set_audio_bitrate(core, 48000);
 
@@ -98,13 +95,11 @@ static int _tm6000_start_audio_dma(struct snd_tm6000_card *chip)
 static int _tm6000_stop_audio_dma(struct snd_tm6000_card *chip)
 {
 	struct tm6000_core *core = chip->core;
-	int val;
+
 	dprintk(1, "Stopping audio DMA\n");
 
-	/* Enables audio */
-	val = tm6000_get_reg(core, TM6010_REQ07_RCC_ACTIVE_VIDEO_IF, 0x0);
-	val &= ~0x20;
-	tm6000_set_reg(core, TM6010_REQ07_RCC_ACTIVE_VIDEO_IF, val);
+	/* Disables audio */
+	tm6000_set_reg_mask(core, TM6010_REQ07_RCC_ACTIVE_VIDEO_IF, 0x00, 0x40);
 
 	tm6000_set_reg(core, TM6010_REQ08_R01_A_INIT, 0);
 
diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index 455038b..c2aa889 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -63,6 +63,8 @@ struct tm6000_board {
 	char            *name;
 
 	struct tm6000_capabilities caps;
+	enum            tm6000_inaudio aradio;
+	enum            tm6000_inaudio avideo;
 
 	enum		tm6000_devtype type;	/* variant of the chipset */
 	int             tuner_type;     /* type of the tuner */
@@ -227,6 +229,8 @@ struct tm6000_board tm6000_boards[] = {
 		.tuner_addr   = 0xc2 >> 1,
 		.demod_addr   = 0x1e >> 1,
 		.type         = TM6010,
+		.avideo       = TM6000_AIP_SIF1,
+		.aradio       = TM6000_AIP_LINE1,
 		.caps = {
 			.has_tuner    = 1,
 			.has_dvb      = 1,
@@ -245,6 +249,8 @@ struct tm6000_board tm6000_boards[] = {
 		.tuner_type   = TUNER_XC5000,
 		.tuner_addr   = 0xc2 >> 1,
 		.type         = TM6010,
+		.avideo       = TM6000_AIP_SIF1,
+		.aradio       = TM6000_AIP_LINE1,
 		.caps = {
 			.has_tuner    = 1,
 			.has_dvb      = 0,
@@ -644,13 +650,12 @@ static void tm6000_config_tuner(struct tm6000_core *dev)
 		struct xc5000_config ctl = {
 			.i2c_address = dev->tuner_addr,
 			.if_khz      = 4570,
-			.radio_input = XC5000_RADIO_FM1,
+			.radio_input = XC5000_RADIO_FM1_MONO,
 			};
 
 		xc5000_cfg.tuner = TUNER_XC5000;
 		xc5000_cfg.priv  = &ctl;
 
-
 		v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_config,
 				     &xc5000_cfg);
 		}
@@ -683,6 +688,8 @@ static int tm6000_init_dev(struct tm6000_core *dev)
 
 	dev->caps = tm6000_boards[dev->model].caps;
 
+	dev->avideo = tm6000_boards[dev->model].avideo;
+	dev->aradio = tm6000_boards[dev->model].aradio;
 	/* initialize hardware */
 	rc = tm6000_init(dev);
 	if (rc < 0)
diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
index 96aed4a..b9d9624 100644
--- a/drivers/staging/tm6000/tm6000-core.c
+++ b/drivers/staging/tm6000/tm6000-core.c
@@ -116,6 +116,29 @@ int tm6000_get_reg(struct tm6000_core *dev, u8 req, u16 value, u16 index)
 }
 EXPORT_SYMBOL_GPL(tm6000_get_reg);
 
+int tm6000_set_reg_mask(struct tm6000_core *dev, u8 req, u16 value,
+						u16 index, u16 mask)
+{
+	int rc;
+	u8 buf[1];
+	u8 new_index;
+
+	rc = tm6000_read_write_usb(dev, USB_DIR_IN | USB_TYPE_VENDOR, req,
+					value, index, buf, 1);
+
+	if (rc < 0)
+		return rc;
+
+	new_index = (buf[0] & ~mask) | (index & mask);
+
+	if (new_index == index)
+		return 0;
+
+	return tm6000_read_write_usb(dev, USB_DIR_OUT | USB_TYPE_VENDOR,
+				      req, value, new_index, NULL, 0);
+}
+EXPORT_SYMBOL_GPL(tm6000_set_reg_mask);
+
 int tm6000_get_reg16(struct tm6000_core *dev, u8 req, u16 value, u16 index)
 {
 	int rc;
@@ -245,17 +268,12 @@ int tm6000_init_analog_mode(struct tm6000_core *dev)
 	struct v4l2_frequency f;
 
 	if (dev->dev_type == TM6010) {
-		int val;
-
 		/* Enable video */
-		val = tm6000_get_reg(dev, TM6010_REQ07_RCC_ACTIVE_VIDEO_IF, 0);
-		val |= 0x60;
-		tm6000_set_reg(dev, TM6010_REQ07_RCC_ACTIVE_VIDEO_IF, val);
-		val = tm6000_get_reg(dev,
-			TM6010_REQ07_RC0_ACTIVE_VIDEO_SOURCE, 0);
-		val &= ~0x40;
-		tm6000_set_reg(dev, TM6010_REQ07_RC0_ACTIVE_VIDEO_SOURCE, val);
 
+		tm6000_set_reg_mask(dev, TM6010_REQ07_RCC_ACTIVE_VIDEO_IF,
+							0x60, 0x60);
+		tm6000_set_reg_mask(dev, TM6010_REQ07_RC0_ACTIVE_VIDEO_SOURCE,
+							0x00, 0x40);
 		tm6000_set_reg(dev, TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc);
 
 	} else {
@@ -470,6 +488,14 @@ struct reg_init tm6010_init_tab[] = {
 	{ TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xf0 },
 	{ TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2 },
 	{ TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x60 },
+	{ TM6010_REQ08_R03_A_AUTO_GAIN_CTRL, 0x00},
+	{ TM6010_REQ08_R04_A_SIF_AMP_CTRL, 0x80},
+	{ TM6010_REQ08_R0C_A_ASD_THRES2, 0x0a},
+	{ TM6010_REQ08_R0D_A_AMD_THRES, 0x40},
+	{ TM6010_REQ08_R1A_A_NICAM_SER_MAX, 0x64},
+	{ TM6010_REQ08_R1B_A_NICAM_SER_MIN, 0x20},
+	{ TM6010_REQ08_R16_A_AGC_GAIN_MAX, 0xfe},
+	{ TM6010_REQ08_R17_A_AGC_GAIN_MIN, 0x01},
 	{ TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc },
 
 	{ TM6010_REQ07_R3F_RESET, 0x01 },
@@ -590,38 +616,213 @@ int tm6000_init(struct tm6000_core *dev)
 
 int tm6000_set_audio_bitrate(struct tm6000_core *dev, int bitrate)
 {
-	int val;
+	int val = 0;
+	u8 areg_f0 = 0x60; /* ADC MCLK = 250 Fs */
+	u8 areg_0a = 0x91; /* SIF 48KHz */
+
+	switch (bitrate) {
+	case 48000:
+		areg_f0 = 0x60; /* ADC MCLK = 250 Fs */
+		areg_0a = 0x91; /* SIF 48KHz */
+		dev->audio_bitrate = bitrate;
+		break;
+	case 32000:
+		areg_f0 = 0x00; /* ADC MCLK = 375 Fs */
+		areg_0a = 0x90; /* SIF 32KHz */
+		dev->audio_bitrate = bitrate;
+		break;
+	default:
+		return -EINVAL;
+	}
+
 
 	if (dev->dev_type == TM6010) {
-		val = tm6000_get_reg(dev, TM6010_REQ08_R0A_A_I2S_MOD, 0);
+		val = tm6000_set_reg(dev, TM6010_REQ08_R0A_A_I2S_MOD, areg_0a);
 		if (val < 0)
 			return val;
-		val = (val & 0xf0) | 0x1; /* 48 kHz, not muted */
-		val = tm6000_set_reg(dev, TM6010_REQ08_R0A_A_I2S_MOD, val);
+
+		val = tm6000_set_reg_mask(dev, TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG,
+							areg_f0, 0xf0);
+		if (val < 0)
+			return val;
+	} else {
+		val = tm6000_set_reg_mask(dev, TM6000_REQ07_REB_VADC_AADC_MODE,
+							areg_f0, 0xf0);
 		if (val < 0)
 			return val;
 	}
 
-	val = tm6000_get_reg(dev, REQ_07_SET_GET_AVREG, 0xeb, 0x0);
-	if (val < 0)
-		return val;
+	return val;
+}
+EXPORT_SYMBOL_GPL(tm6000_set_audio_bitrate);
 
-	val &= 0x0f;		/* Preserve the audio input control bits */
-	switch (bitrate) {
-	case 44100:
-		val |= 0xd0;
-		dev->audio_bitrate = bitrate;
+int tm6000_set_audio_input(struct tm6000_core *dev, enum tm6000_inaudio ainp)
+{
+	if (dev->dev_type == TM6010) {
+		/* Audio crossbar setting, default SIF1 */
+		u8 areg_f0 = 0x03;
+
+		switch (ainp) {
+		case TM6000_AIP_SIF1:
+		case TM6000_AIP_SIF2:
+			areg_f0 = 0x03;
+			break;
+		case TM6000_AIP_LINE1:
+			areg_f0 = 0x00;
+			break;
+		case TM6000_AIP_LINE2:
+			areg_f0 = 0x08;
+			break;
+		default:
+			return 0;
+			break;
+		}
+		/* Set audio input crossbar */
+		tm6000_set_reg_mask(dev, TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG,
+							areg_f0, 0x0f);
+	} else {
+		/* Audio setting, default LINE1 */
+		u8 areg_eb = 0x00;
+
+		switch (ainp) {
+		case TM6000_AIP_LINE1:
+			areg_eb = 0x00;
+			break;
+		case TM6000_AIP_LINE2:
+			areg_eb = 0x04;
+			break;
+		default:
+			return 0;
+			break;
+		}
+		/* Set audio input */
+		tm6000_set_reg_mask(dev, TM6000_REQ07_REB_VADC_AADC_MODE,
+							areg_eb, 0x0f);
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(tm6000_set_audio_input);
+
+void tm6010_set_mute_sif(struct tm6000_core *dev, u8 mute)
+{
+	u8 mute_reg = 0;
+
+	if (mute)
+		mute_reg = 0x08;
+
+	tm6000_set_reg_mask(dev, TM6010_REQ08_R0A_A_I2S_MOD, mute_reg, 0x08);
+}
+
+void tm6010_set_mute_adc(struct tm6000_core *dev, u8 mute)
+{
+	u8 mute_reg = 0;
+
+	if (mute)
+		mute_reg = 0x20;
+
+	if (dev->dev_type == TM6010) {
+		tm6000_set_reg_mask(dev, TM6010_REQ08_RF2_LEFT_CHANNEL_VOL,
+							mute_reg, 0x20);
+		tm6000_set_reg_mask(dev, TM6010_REQ08_RF3_RIGHT_CHANNEL_VOL,
+							mute_reg, 0x20);
+	} else {
+		tm6000_set_reg_mask(dev, TM6000_REQ07_REC_VADC_AADC_LVOL,
+							mute_reg, 0x20);
+		tm6000_set_reg_mask(dev, TM6000_REQ07_RED_VADC_AADC_RVOL,
+							mute_reg, 0x20);
+	}
+}
+
+int tm6000_tvaudio_set_mute(struct tm6000_core *dev, u8 mute)
+{
+	enum tm6000_inaudio ainp;
+
+	if (dev->radio)
+		ainp = dev->aradio;
+	else
+		ainp = dev->avideo;
+
+	switch (ainp) {
+	case TM6000_AIP_SIF1:
+	case TM6000_AIP_SIF2:
+		if (dev->dev_type == TM6010)
+			tm6010_set_mute_sif(dev, mute);
+		else {
+			printk(KERN_INFO "ERROR: TM5600 and TM6000 don't has"
+					" SIF audio inputs. Please check the %s"
+					" configuration.\n", dev->name);
+			return -EINVAL;
+		}
 		break;
-	case 48000:
-		val |= 0x60;
-		dev->audio_bitrate = bitrate;
+	case TM6000_AIP_LINE1:
+	case TM6000_AIP_LINE2:
+		tm6010_set_mute_adc(dev, mute);
+		break;
+	default:
+		return -EINVAL;
 		break;
 	}
-	val = tm6000_set_reg(dev, REQ_07_SET_GET_AVREG, 0xeb, val);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(tm6000_tvaudio_set_mute);
 
-	return val;
+void tm6010_set_volume_sif(struct tm6000_core *dev, int vol)
+{
+	u8 vol_reg;
+
+	vol_reg = vol & 0x0F;
+
+	if (vol < 0)
+		vol_reg |= 0x40;
+
+	tm6000_set_reg(dev, TM6010_REQ08_R07_A_LEFT_VOL, vol_reg);
+	tm6000_set_reg(dev, TM6010_REQ08_R08_A_RIGHT_VOL, vol_reg);
 }
-EXPORT_SYMBOL_GPL(tm6000_set_audio_bitrate);
+
+void tm6010_set_volume_adc(struct tm6000_core *dev, int vol)
+{
+	u8 vol_reg;
+
+	vol_reg = (vol + 0x10) & 0x1f;
+
+	if (dev->dev_type == TM6010) {
+		tm6000_set_reg(dev, TM6010_REQ08_RF2_LEFT_CHANNEL_VOL, vol_reg);
+		tm6000_set_reg(dev, TM6010_REQ08_RF3_RIGHT_CHANNEL_VOL, vol_reg);
+	} else {
+		tm6000_set_reg(dev, TM6000_REQ07_REC_VADC_AADC_LVOL, vol_reg);
+		tm6000_set_reg(dev, TM6000_REQ07_RED_VADC_AADC_RVOL, vol_reg);
+	}
+}
+
+void tm6000_set_volume(struct tm6000_core *dev, int vol)
+{
+	enum tm6000_inaudio ainp;
+
+	if (dev->radio) {
+		ainp = dev->aradio;
+		vol += 8; /* Offset to 0 dB */
+	} else
+		ainp = dev->avideo;
+
+	switch (ainp) {
+	case TM6000_AIP_SIF1:
+	case TM6000_AIP_SIF2:
+		if (dev->dev_type == TM6010)
+			tm6010_set_volume_sif(dev, vol);
+		else
+			printk(KERN_INFO "ERROR: TM5600 and TM6000 don't has"
+					" SIF audio inputs. Please check the %s"
+					" configuration.\n", dev->name);
+		break;
+	case TM6000_AIP_LINE1:
+	case TM6000_AIP_LINE2:
+		tm6010_set_volume_adc(dev, vol);
+		break;
+	default:
+		break;
+	}
+}
+EXPORT_SYMBOL_GPL(tm6000_set_volume);
 
 static LIST_HEAD(tm6000_devlist);
 static DEFINE_MUTEX(tm6000_devlist_mutex);
diff --git a/drivers/staging/tm6000/tm6000-stds.c b/drivers/staging/tm6000/tm6000-stds.c
index cc7b866..a4c07e5 100644
--- a/drivers/staging/tm6000/tm6000-stds.c
+++ b/drivers/staging/tm6000/tm6000-stds.c
@@ -952,6 +952,22 @@ static int tm6000_set_audio_std(struct tm6000_core *dev,
 	uint8_t mono_flag = 0;  /* No mono */
 	uint8_t nicam_flag = 0; /* No NICAM */
 
+	if (dev->radio) {
+		tm6000_set_reg(dev, TM6010_REQ08_R01_A_INIT, 0x00);
+		tm6000_set_reg(dev, TM6010_REQ08_R02_A_FIX_GAIN_CTRL, 0x04);
+		tm6000_set_reg(dev, TM6010_REQ08_R03_A_AUTO_GAIN_CTRL, 0x00);
+		tm6000_set_reg(dev, TM6010_REQ08_R04_A_SIF_AMP_CTRL, 0x80);
+		tm6000_set_reg(dev, TM6010_REQ08_R05_A_STANDARD_MOD, 0x0c);
+		tm6000_set_reg(dev, TM6010_REQ08_R06_A_SOUND_MOD, 0x00);
+		tm6000_set_reg(dev, TM6010_REQ08_R09_A_MAIN_VOL, 0x18);
+		tm6000_set_reg(dev, TM6010_REQ08_R0C_A_ASD_THRES2, 0x0a);
+		tm6000_set_reg(dev, TM6010_REQ08_R0D_A_AMD_THRES, 0x40);
+		tm6000_set_reg(dev, TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc);
+		tm6000_set_reg(dev, TM6010_REQ08_R1E_A_GAIN_DEEMPH_OUT, 0x13);
+		tm6000_set_reg(dev, TM6010_REQ08_R01_A_INIT, 0x80);
+		return 0;
+	}
+
 	switch (std) {
 #if 0
 	case DK_MONO:
@@ -984,20 +1000,6 @@ static int tm6000_set_audio_std(struct tm6000_core *dev,
 	case EIAJ:
 		areg_05 = 0x02;
 		break;
-	case FM_RADIO:
-		tm6000_set_reg(dev, TM6010_REQ08_R01_A_INIT, 0x00);
-		tm6000_set_reg(dev, TM6010_REQ08_R02_A_FIX_GAIN_CTRL, 0x04);
-		tm6000_set_reg(dev, TM6010_REQ08_R03_A_AUTO_GAIN_CTRL, 0x00);
-		tm6000_set_reg(dev, TM6010_REQ08_R05_A_STANDARD_MOD, 0x0c);
-		tm6000_set_reg(dev, TM6010_REQ08_R06_A_SOUND_MOD, 0x00);
-		tm6000_set_reg(dev, TM6010_REQ08_R09_A_MAIN_VOL, 0x18);
-		tm6000_set_reg(dev, TM6010_REQ08_R0A_A_I2S_MOD, 0x91);
-		tm6000_set_reg(dev, TM6010_REQ08_R16_A_AGC_GAIN_MAX, 0xfe);
-		tm6000_set_reg(dev, TM6010_REQ08_R17_A_AGC_GAIN_MIN, 0x01);
-		tm6000_set_reg(dev, TM6010_REQ08_R1E_A_GAIN_DEEMPH_OUT, 0x13);
-		tm6000_set_reg(dev, TM6010_REQ08_R01_A_INIT, 0x80);
-		return 0;
-		break;
 	case I_NICAM:
 		areg_05 = 0x08;
 		nicam_flag = 1;
@@ -1010,6 +1012,9 @@ static int tm6000_set_audio_std(struct tm6000_core *dev,
 		areg_05 = 0x0a;
 		nicam_flag = 1;
 		break;
+	default:
+		/* do nothink */
+		break;
 	}
 
 #if 0
diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
index eb9b9f1..b550340 100644
--- a/drivers/staging/tm6000/tm6000-video.c
+++ b/drivers/staging/tm6000/tm6000-video.c
@@ -53,11 +53,17 @@
 /* Declare static vars that will be used as parameters */
 static unsigned int vid_limit = 16;	/* Video memory limit, in Mb */
 static int video_nr = -1;		/* /dev/videoN, -1 for autodetect */
+static int radio_nr = -1;		/* /dev/radioN, -1 for autodetect */
 
 /* Debug level */
 int tm6000_debug;
 EXPORT_SYMBOL_GPL(tm6000_debug);
 
+static const struct v4l2_queryctrl no_ctrl = {
+	.name  = "42",
+	.flags = V4L2_CTRL_FLAG_DISABLED,
+};
+
 /* supported controls */
 static struct v4l2_queryctrl tm6000_qctrl[] = {
 	{
@@ -96,9 +102,26 @@ static struct v4l2_queryctrl tm6000_qctrl[] = {
 		.step          = 0x1,
 		.default_value = 0,
 		.flags         = 0,
+	},
+		/* --- audio --- */
+	{
+		.id            = V4L2_CID_AUDIO_MUTE,
+		.name          = "Mute",
+		.minimum       = 0,
+		.maximum       = 1,
+		.type          = V4L2_CTRL_TYPE_BOOLEAN,
+	}, {
+		.id            = V4L2_CID_AUDIO_VOLUME,
+		.name          = "Volume",
+		.minimum       = -15,
+		.maximum       = 15,
+		.step          = 1,
+		.default_value = 0,
+		.type          = V4L2_CTRL_TYPE_INTEGER,
 	}
 };
 
+static const unsigned int CTRLS = ARRAY_SIZE(tm6000_qctrl);
 static int qctl_regs[ARRAY_SIZE(tm6000_qctrl)];
 
 static struct tm6000_fmt format[] = {
@@ -117,6 +140,16 @@ static struct tm6000_fmt format[] = {
 	}
 };
 
+static const struct v4l2_queryctrl *ctrl_by_id(unsigned int id)
+{
+	unsigned int i;
+
+	for (i = 0; i < CTRLS; i++)
+		if (tm6000_qctrl[i].id == id)
+			return tm6000_qctrl+i;
+	return NULL;
+}
+
 /* ------------------------------------------------------------------
  *	DMA and thread functions
  * ------------------------------------------------------------------
@@ -199,13 +232,17 @@ static int copy_streams(u8 *data, unsigned long len,
 	char *voutp = NULL;
 	unsigned int linewidth;
 
-	/* get video buffer */
-	get_next_buf(dma_q, &vbuf);
-	if (!vbuf)
-		return rc;
-	voutp = videobuf_to_vmalloc(&vbuf->vb);
-	if (!voutp)
-		return 0;
+	if (!dev->radio) {
+		/* get video buffer */
+		get_next_buf(dma_q, &vbuf);
+
+		if (!vbuf)
+			return rc;
+		voutp = videobuf_to_vmalloc(&vbuf->vb);
+
+		if (!voutp)
+			return 0;
+	}
 
 	for (ptr = data; ptr < endp;) {
 		if (!dev->isoc_ctl.cmd) {
@@ -257,29 +294,31 @@ static int copy_streams(u8 *data, unsigned long len,
 			 */
 			switch (cmd) {
 			case TM6000_URB_MSG_VIDEO:
-				if ((dev->isoc_ctl.vfield != field) &&
-					(field == 1)) {
+				if (!dev->radio) {
+					if ((dev->isoc_ctl.vfield != field) &&
+						(field == 1)) {
 					/* Announces that a new buffer
 					 * were filled
 					 */
-					buffer_filled(dev, dma_q, vbuf);
-					dprintk(dev, V4L2_DEBUG_ISOC,
+						buffer_filled(dev, dma_q, vbuf);
+						dprintk(dev, V4L2_DEBUG_ISOC,
 							"new buffer filled\n");
-					get_next_buf(dma_q, &vbuf);
-					if (!vbuf)
-						return rc;
-					voutp = videobuf_to_vmalloc(&vbuf->vb);
-					if (!voutp)
-						return rc;
-					memset(voutp, 0, vbuf->vb.size);
-				}
-				linewidth = vbuf->vb.width << 1;
-				pos = ((line << 1) - field - 1) * linewidth +
-					block * TM6000_URB_MSG_LEN;
-				/* Don't allow to write out of the buffer */
-				if (pos + size > vbuf->vb.size)
-					cmd = TM6000_URB_MSG_ERR;
-				dev->isoc_ctl.vfield = field;
+						get_next_buf(dma_q, &vbuf);
+						if (!vbuf)
+							return rc;
+						voutp = videobuf_to_vmalloc(&vbuf->vb);
+						if (!voutp)
+							return rc;
+						memset(voutp, 0, vbuf->vb.size);
+					}
+					linewidth = vbuf->vb.width << 1;
+					pos = ((line << 1) - field - 1) *
+					linewidth + block * TM6000_URB_MSG_LEN;
+					/* Don't allow to write out of the buffer */
+					if (pos + size > vbuf->vb.size)
+						cmd = TM6000_URB_MSG_ERR;
+					dev->isoc_ctl.vfield = field;
+			}
 				break;
 			case TM6000_URB_MSG_VBI:
 				break;
@@ -537,7 +576,7 @@ static void tm6000_uninit_isoc(struct tm6000_core *dev)
 /*
  * Allocate URBs and start IRQ
  */
-static int tm6000_prepare_isoc(struct tm6000_core *dev, unsigned int framesize)
+static int tm6000_prepare_isoc(struct tm6000_core *dev)
 {
 	struct tm6000_dmaqueue *dma_q = &dev->vidq;
 	int i, j, sb_size, pipe, size, max_packets, num_bufs = 8;
@@ -566,11 +605,7 @@ static int tm6000_prepare_isoc(struct tm6000_core *dev, unsigned int framesize)
 
 	dev->isoc_ctl.max_pkt_size = size;
 
-	max_packets = (framesize + size - 1) / size;
-
-	if (max_packets > TM6000_MAX_ISO_PACKETS)
-		max_packets = TM6000_MAX_ISO_PACKETS;
-
+	max_packets = TM6000_MAX_ISO_PACKETS;
 	sb_size = max_packets * size;
 
 	dev->isoc_ctl.num_bufs = num_bufs;
@@ -746,7 +781,7 @@ buffer_prepare(struct videobuf_queue *vq, struct videobuf_buffer *vb,
 		urb_init = 1;
 
 	if (urb_init) {
-		rc = tm6000_prepare_isoc(dev, buf->vb.size);
+		rc = tm6000_prepare_isoc(dev);
 		if (rc < 0)
 			goto fail;
 
@@ -1143,6 +1178,12 @@ static int vidioc_g_ctrl(struct file *file, void *priv,
 	case V4L2_CID_HUE:
 		val = tm6000_get_reg(dev, TM6010_REQ07_R0B_CHROMA_HUE_PHASE_ADJ, 0);
 		return 0;
+	case V4L2_CID_AUDIO_MUTE:
+		val = dev->ctl_mute;
+		return 0;
+	case V4L2_CID_AUDIO_VOLUME:
+		val = dev->ctl_volume;
+		return 0;
 	default:
 		return -EINVAL;
 	}
@@ -1174,6 +1215,14 @@ static int vidioc_s_ctrl(struct file *file, void *priv,
 	case V4L2_CID_HUE:
 		tm6000_set_reg(dev, TM6010_REQ07_R0B_CHROMA_HUE_PHASE_ADJ, val);
 		return 0;
+	case V4L2_CID_AUDIO_MUTE:
+		dev->ctl_mute = val;
+		tm6000_tvaudio_set_mute(dev, val);
+		return 0;
+	case V4L2_CID_AUDIO_VOLUME:
+		dev->ctl_volume = val;
+		tm6000_set_volume(dev, val);
+		return 0;
 	}
 	return -EINVAL;
 }
@@ -1221,7 +1270,7 @@ static int vidioc_g_frequency(struct file *file, void *priv,
 	if (unlikely(UNSET == dev->tuner_type))
 		return -EINVAL;
 
-	f->type = V4L2_TUNER_ANALOG_TV;
+	f->type = fh->radio ? V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
 	f->frequency = dev->freq;
 
 	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, g_frequency, f);
@@ -1235,13 +1284,14 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 	struct tm6000_fh   *fh  = priv;
 	struct tm6000_core *dev = fh->dev;
 
-	if (unlikely(f->type != V4L2_TUNER_ANALOG_TV))
-		return -EINVAL;
-
 	if (unlikely(UNSET == dev->tuner_type))
 		return -EINVAL;
 	if (unlikely(f->tuner != 0))
 		return -EINVAL;
+	if (0 == fh->radio && V4L2_TUNER_ANALOG_TV != f->type)
+		return -EINVAL;
+	if (1 == fh->radio && V4L2_TUNER_RADIO != f->type)
+		return -EINVAL;
 
 	dev->freq = f->frequency;
 	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_frequency, f);
@@ -1249,6 +1299,122 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 	return 0;
 }
 
+static int radio_querycap(struct file *file, void *priv,
+					struct v4l2_capability *cap)
+{
+	struct tm6000_fh *fh = file->private_data;
+	struct tm6000_core *dev = fh->dev;
+
+	strcpy(cap->driver, "tm6000");
+	strlcpy(cap->card, dev->name, sizeof(dev->name));
+	sprintf(cap->bus_info, "USB%04x:%04x",
+		le16_to_cpu(dev->udev->descriptor.idVendor),
+		le16_to_cpu(dev->udev->descriptor.idProduct));
+	cap->version = dev->dev_type;
+	cap->capabilities = V4L2_CAP_TUNER;
+
+	return 0;
+}
+
+static int radio_g_tuner(struct file *file, void *priv,
+					struct v4l2_tuner *t)
+{
+	struct tm6000_fh *fh = file->private_data;
+	struct tm6000_core *dev = fh->dev;
+
+	if (0 != t->index)
+		return -EINVAL;
+
+	memset(t, 0, sizeof(*t));
+	strcpy(t->name, "Radio");
+	t->type = V4L2_TUNER_RADIO;
+
+	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, g_tuner, t);
+
+	if ((dev->aradio == TM6000_AIP_LINE1) ||
+				(dev->aradio == TM6000_AIP_LINE2)) {
+		t->rxsubchans = V4L2_TUNER_SUB_MONO;
+	}
+	else {
+		t->rxsubchans = V4L2_TUNER_SUB_STEREO;
+	}
+
+	return 0;
+}
+
+static int radio_s_tuner(struct file *file, void *priv,
+					struct v4l2_tuner *t)
+{
+	struct tm6000_fh *fh = file->private_data;
+	struct tm6000_core *dev = fh->dev;
+
+	if (0 != t->index)
+		return -EINVAL;
+
+	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_tuner, t);
+
+	return 0;
+}
+
+static int radio_enum_input(struct file *file, void *priv,
+					struct v4l2_input *i)
+{
+	if (i->index != 0)
+		return -EINVAL;
+
+	strcpy(i->name, "Radio");
+	i->type = V4L2_INPUT_TYPE_TUNER;
+
+	return 0;
+}
+
+static int radio_g_input(struct file *filp, void *priv, unsigned int *i)
+{
+	*i = 0;
+	return 0;
+}
+
+static int radio_g_audio(struct file *file, void *priv,
+					struct v4l2_audio *a)
+{
+	memset(a, 0, sizeof(*a));
+	strcpy(a->name, "Radio");
+	return 0;
+}
+
+static int radio_s_audio(struct file *file, void *priv,
+					struct v4l2_audio *a)
+{
+	return 0;
+}
+
+static int radio_s_input(struct file *filp, void *priv, unsigned int i)
+{
+	return 0;
+}
+
+static int radio_s_std(struct file *file, void *fh, v4l2_std_id *norm)
+{
+	return 0;
+}
+
+static int radio_queryctrl(struct file *file, void *priv,
+					struct v4l2_queryctrl *c)
+{
+	const struct v4l2_queryctrl *ctrl;
+
+	if (c->id <  V4L2_CID_BASE ||
+	    c->id >= V4L2_CID_LASTP1)
+		return -EINVAL;
+	if (c->id == V4L2_CID_AUDIO_MUTE) {
+		ctrl = ctrl_by_id(c->id);
+		*c = *ctrl;
+	} else
+		*c = no_ctrl;
+
+	return 0;
+}
+
 /* ------------------------------------------------------------------
 	File operations for the device
    ------------------------------------------------------------------*/
@@ -1260,6 +1426,7 @@ static int tm6000_open(struct file *file)
 	struct tm6000_fh *fh;
 	enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	int i, rc;
+	int radio = 0;
 
 	printk(KERN_INFO "tm6000: open called (dev=%s)\n",
 		video_device_node_name(vdev));
@@ -1267,6 +1434,17 @@ static int tm6000_open(struct file *file)
 	dprintk(dev, V4L2_DEBUG_OPEN, "tm6000: open called (dev=%s)\n",
 		video_device_node_name(vdev));
 
+	switch (vdev->vfl_type) {
+	case VFL_TYPE_GRABBER:
+		type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+		break;
+	case VFL_TYPE_VBI:
+		type = V4L2_BUF_TYPE_VBI_CAPTURE;
+		break;
+	case VFL_TYPE_RADIO:
+		radio = 1;
+		break;
+	}
 
 	/* If more than one user, mutex should be added */
 	dev->users++;
@@ -1284,8 +1462,9 @@ static int tm6000_open(struct file *file)
 
 	file->private_data = fh;
 	fh->dev      = dev;
-
-	fh->type     = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	fh->radio    = radio;
+	dev->radio   = radio;
+	fh->type     = type;
 	dev->fourcc  = format[0].fourcc;
 
 	fh->fmt      = format_by_fourcc(dev->fourcc);
@@ -1322,6 +1501,19 @@ static int tm6000_open(struct file *file)
 			V4L2_FIELD_INTERLACED,
 			sizeof(struct tm6000_buffer), fh, &dev->lock);
 
+	if (fh->radio) {
+		dprintk(dev, V4L2_DEBUG_OPEN, "video_open: setting radio device\n");
+		tm6000_set_audio_input(dev, dev->aradio);
+		tm6000_set_volume(dev, dev->ctl_volume);
+		v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_radio);
+		tm6000_prepare_isoc(dev);
+		tm6000_start_thread(dev);
+	}
+	else {
+		tm6000_set_audio_input(dev, dev->avideo);
+		tm6000_set_volume(dev, dev->ctl_volume);
+	}
+
 	return 0;
 }
 
@@ -1445,6 +1637,36 @@ static struct video_device tm6000_template = {
 	.current_norm   = V4L2_STD_NTSC_M,
 };
 
+static const struct v4l2_file_operations radio_fops = {
+	.owner	  = THIS_MODULE,
+	.open	  = tm6000_open,
+	.release  = tm6000_release,
+	.ioctl	  = video_ioctl2,
+};
+
+static const struct v4l2_ioctl_ops radio_ioctl_ops = {
+	.vidioc_querycap	= radio_querycap,
+	.vidioc_g_tuner		= radio_g_tuner,
+	.vidioc_enum_input	= radio_enum_input,
+	.vidioc_g_audio		= radio_g_audio,
+	.vidioc_s_tuner		= radio_s_tuner,
+	.vidioc_s_audio		= radio_s_audio,
+	.vidioc_s_input		= radio_s_input,
+	.vidioc_s_std		= radio_s_std,
+	.vidioc_queryctrl	= radio_queryctrl,
+	.vidioc_g_input		= radio_g_input,
+	.vidioc_g_ctrl		= vidioc_g_ctrl,
+	.vidioc_s_ctrl		= vidioc_s_ctrl,
+	.vidioc_g_frequency	= vidioc_g_frequency,
+	.vidioc_s_frequency	= vidioc_s_frequency,
+};
+
+struct video_device tm6000_radio_template = {
+	.name			= "tm6000",
+	.fops			= &radio_fops,
+	.ioctl_ops 		= &radio_ioctl_ops,
+};
+
 /* -----------------------------------------------------------------
  *	Initialization and module stuff
  * ------------------------------------------------------------------
@@ -1499,6 +1721,25 @@ int tm6000_v4l2_register(struct tm6000_core *dev)
 	printk(KERN_INFO "%s: registered device %s\n",
 	       dev->name, video_device_node_name(dev->vfd));
 
+	dev->radio_dev = vdev_init(dev, &tm6000_radio_template,
+						   "radio");
+	if (!dev->radio_dev) {
+		printk(KERN_INFO "%s: can't register radio device\n",
+		       dev->name);
+		return ret; /* FIXME release resource */
+	}
+
+	ret = video_register_device(dev->radio_dev, VFL_TYPE_RADIO,
+				    radio_nr);
+	if (ret < 0) {
+		printk(KERN_INFO "%s: can't register radio device\n",
+		       dev->name);
+		return ret; /* FIXME release resource */
+	}
+
+	printk(KERN_INFO "%s: registered device %s\n",
+	       dev->name, video_device_node_name(dev->radio_dev));
+
 	printk(KERN_INFO "Trident TVMaster TM5600/TM6000/TM6010 USB2 board (Load status: %d)\n", ret);
 	return ret;
 }
@@ -1507,6 +1748,14 @@ int tm6000_v4l2_unregister(struct tm6000_core *dev)
 {
 	video_unregister_device(dev->vfd);
 
+	if (dev->radio_dev) {
+		if (video_is_registered(dev->radio_dev))
+			video_unregister_device(dev->radio_dev);
+		else
+			video_device_release(dev->radio_dev);
+		dev->radio_dev = NULL;
+	}
+
 	return 0;
 }
 
diff --git a/drivers/staging/tm6000/tm6000.h b/drivers/staging/tm6000/tm6000.h
index bf11eee..ccd120f 100644
--- a/drivers/staging/tm6000/tm6000.h
+++ b/drivers/staging/tm6000/tm6000.h
@@ -53,6 +53,14 @@ enum tm6000_devtype {
 	TM6010,
 };
 
+enum tm6000_inaudio {
+	TM6000_AIP_UNK = 0,
+	TM6000_AIP_SIF1,
+	TM6000_AIP_SIF2,
+	TM6000_AIP_LINE1,
+	TM6000_AIP_LINE2,
+};
+
 /* ------------------------------------------------------------------
  *	Basic structures
  * ------------------------------------------------------------------
@@ -174,6 +182,8 @@ struct tm6000_core {
 
 	char				*ir_codes;
 
+	__u8				radio;
+
 	/* Demodulator configuration */
 	int				demod_addr;	/* demodulator address */
 
@@ -194,6 +204,7 @@ struct tm6000_core {
 	bool				is_res_read;
 
 	struct video_device		*vfd;
+	struct video_device		*radio_dev;
 	struct tm6000_dmaqueue		vidq;
 	struct v4l2_device		v4l2_dev;
 
@@ -203,6 +214,9 @@ struct tm6000_core {
 
 	enum tm6000_mode		mode;
 
+	int				ctl_mute;             /* audio */
+	int				ctl_volume;
+
 	/* DVB-T support */
 	struct tm6000_dvb		*dvb;
 
@@ -210,7 +224,8 @@ struct tm6000_core {
 	struct snd_tm6000_card		*adev;
 	struct work_struct		wq_trigger;   /* Trigger to start/stop audio for alsa module */
 	atomic_t			stream_started;  /* stream should be running if true */
-
+	enum tm6000_inaudio		avideo;
+	enum tm6000_inaudio		aradio;
 
 	struct tm6000_IR		*ir;
 
@@ -248,6 +263,7 @@ struct tm6000_ops {
 
 struct tm6000_fh {
 	struct tm6000_core           *dev;
+	unsigned int                 radio;
 
 	/* video capture */
 	struct tm6000_fmt            *fmt;
@@ -276,12 +292,17 @@ int tm6000_get_reg(struct tm6000_core *dev, u8 req, u16 value, u16 index);
 int tm6000_get_reg16(struct tm6000_core *dev, u8 req, u16 value, u16 index);
 int tm6000_get_reg32(struct tm6000_core *dev, u8 req, u16 value, u16 index);
 int tm6000_set_reg(struct tm6000_core *dev, u8 req, u16 value, u16 index);
+int tm6000_set_reg_mask(struct tm6000_core *dev, u8 req, u16 value,
+						u16 index, u16 mask);
 int tm6000_i2c_reset(struct tm6000_core *dev, u16 tsleep);
 int tm6000_init(struct tm6000_core *dev);
 
 int tm6000_init_analog_mode(struct tm6000_core *dev);
 int tm6000_init_digital_mode(struct tm6000_core *dev);
 int tm6000_set_audio_bitrate(struct tm6000_core *dev, int bitrate);
+int tm6000_set_audio_input(struct tm6000_core *dev, enum tm6000_inaudio ainp);
+int tm6000_tvaudio_set_mute(struct tm6000_core *dev, u8 mute);
+void tm6000_set_volume(struct tm6000_core *dev, int vol);
 
 int tm6000_v4l2_register(struct tm6000_core *dev);
 int tm6000_v4l2_unregister(struct tm6000_core *dev);

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>


With my best regards, Dmitry.

--MP_/3xvKmQEYt4H2KpU/xp6D0ka
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=tm6000_radio.patch

diff --git a/drivers/staging/tm6000/tm6000-alsa.c b/drivers/staging/tm6000/tm6000-alsa.c
index 184cc50..acb0317 100644
--- a/drivers/staging/tm6000/tm6000-alsa.c
+++ b/drivers/staging/tm6000/tm6000-alsa.c
@@ -76,14 +76,11 @@ MODULE_PARM_DESC(debug, "enable debug messages");
 static int _tm6000_start_audio_dma(struct snd_tm6000_card *chip)
 {
 	struct tm6000_core *core = chip->core;
-	int val;
 
 	dprintk(1, "Starting audio DMA\n");
 
 	/* Enables audio */
-	val = tm6000_get_reg(core, TM6010_REQ07_RCC_ACTIVE_VIDEO_IF, 0x0);
-	val |= 0x20;
-	tm6000_set_reg(core, TM6010_REQ07_RCC_ACTIVE_VIDEO_IF, val);
+	tm6000_set_reg_mask(core, TM6010_REQ07_RCC_ACTIVE_VIDEO_IF, 0x40, 0x40);
 
 	tm6000_set_audio_bitrate(core, 48000);
 
@@ -98,13 +95,11 @@ static int _tm6000_start_audio_dma(struct snd_tm6000_card *chip)
 static int _tm6000_stop_audio_dma(struct snd_tm6000_card *chip)
 {
 	struct tm6000_core *core = chip->core;
-	int val;
+
 	dprintk(1, "Stopping audio DMA\n");
 
-	/* Enables audio */
-	val = tm6000_get_reg(core, TM6010_REQ07_RCC_ACTIVE_VIDEO_IF, 0x0);
-	val &= ~0x20;
-	tm6000_set_reg(core, TM6010_REQ07_RCC_ACTIVE_VIDEO_IF, val);
+	/* Disables audio */
+	tm6000_set_reg_mask(core, TM6010_REQ07_RCC_ACTIVE_VIDEO_IF, 0x00, 0x40);
 
 	tm6000_set_reg(core, TM6010_REQ08_R01_A_INIT, 0);
 
diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index 455038b..c2aa889 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -63,6 +63,8 @@ struct tm6000_board {
 	char            *name;
 
 	struct tm6000_capabilities caps;
+	enum            tm6000_inaudio aradio;
+	enum            tm6000_inaudio avideo;
 
 	enum		tm6000_devtype type;	/* variant of the chipset */
 	int             tuner_type;     /* type of the tuner */
@@ -227,6 +229,8 @@ struct tm6000_board tm6000_boards[] = {
 		.tuner_addr   = 0xc2 >> 1,
 		.demod_addr   = 0x1e >> 1,
 		.type         = TM6010,
+		.avideo       = TM6000_AIP_SIF1,
+		.aradio       = TM6000_AIP_LINE1,
 		.caps = {
 			.has_tuner    = 1,
 			.has_dvb      = 1,
@@ -245,6 +249,8 @@ struct tm6000_board tm6000_boards[] = {
 		.tuner_type   = TUNER_XC5000,
 		.tuner_addr   = 0xc2 >> 1,
 		.type         = TM6010,
+		.avideo       = TM6000_AIP_SIF1,
+		.aradio       = TM6000_AIP_LINE1,
 		.caps = {
 			.has_tuner    = 1,
 			.has_dvb      = 0,
@@ -644,13 +650,12 @@ static void tm6000_config_tuner(struct tm6000_core *dev)
 		struct xc5000_config ctl = {
 			.i2c_address = dev->tuner_addr,
 			.if_khz      = 4570,
-			.radio_input = XC5000_RADIO_FM1,
+			.radio_input = XC5000_RADIO_FM1_MONO,
 			};
 
 		xc5000_cfg.tuner = TUNER_XC5000;
 		xc5000_cfg.priv  = &ctl;
 
-
 		v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_config,
 				     &xc5000_cfg);
 		}
@@ -683,6 +688,8 @@ static int tm6000_init_dev(struct tm6000_core *dev)
 
 	dev->caps = tm6000_boards[dev->model].caps;
 
+	dev->avideo = tm6000_boards[dev->model].avideo;
+	dev->aradio = tm6000_boards[dev->model].aradio;
 	/* initialize hardware */
 	rc = tm6000_init(dev);
 	if (rc < 0)
diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
index 96aed4a..b9d9624 100644
--- a/drivers/staging/tm6000/tm6000-core.c
+++ b/drivers/staging/tm6000/tm6000-core.c
@@ -116,6 +116,29 @@ int tm6000_get_reg(struct tm6000_core *dev, u8 req, u16 value, u16 index)
 }
 EXPORT_SYMBOL_GPL(tm6000_get_reg);
 
+int tm6000_set_reg_mask(struct tm6000_core *dev, u8 req, u16 value,
+						u16 index, u16 mask)
+{
+	int rc;
+	u8 buf[1];
+	u8 new_index;
+
+	rc = tm6000_read_write_usb(dev, USB_DIR_IN | USB_TYPE_VENDOR, req,
+					value, index, buf, 1);
+
+	if (rc < 0)
+		return rc;
+
+	new_index = (buf[0] & ~mask) | (index & mask);
+
+	if (new_index == index)
+		return 0;
+
+	return tm6000_read_write_usb(dev, USB_DIR_OUT | USB_TYPE_VENDOR,
+				      req, value, new_index, NULL, 0);
+}
+EXPORT_SYMBOL_GPL(tm6000_set_reg_mask);
+
 int tm6000_get_reg16(struct tm6000_core *dev, u8 req, u16 value, u16 index)
 {
 	int rc;
@@ -245,17 +268,12 @@ int tm6000_init_analog_mode(struct tm6000_core *dev)
 	struct v4l2_frequency f;
 
 	if (dev->dev_type == TM6010) {
-		int val;
-
 		/* Enable video */
-		val = tm6000_get_reg(dev, TM6010_REQ07_RCC_ACTIVE_VIDEO_IF, 0);
-		val |= 0x60;
-		tm6000_set_reg(dev, TM6010_REQ07_RCC_ACTIVE_VIDEO_IF, val);
-		val = tm6000_get_reg(dev,
-			TM6010_REQ07_RC0_ACTIVE_VIDEO_SOURCE, 0);
-		val &= ~0x40;
-		tm6000_set_reg(dev, TM6010_REQ07_RC0_ACTIVE_VIDEO_SOURCE, val);
 
+		tm6000_set_reg_mask(dev, TM6010_REQ07_RCC_ACTIVE_VIDEO_IF,
+							0x60, 0x60);
+		tm6000_set_reg_mask(dev, TM6010_REQ07_RC0_ACTIVE_VIDEO_SOURCE,
+							0x00, 0x40);
 		tm6000_set_reg(dev, TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc);
 
 	} else {
@@ -470,6 +488,14 @@ struct reg_init tm6010_init_tab[] = {
 	{ TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xf0 },
 	{ TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2 },
 	{ TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x60 },
+	{ TM6010_REQ08_R03_A_AUTO_GAIN_CTRL, 0x00},
+	{ TM6010_REQ08_R04_A_SIF_AMP_CTRL, 0x80},
+	{ TM6010_REQ08_R0C_A_ASD_THRES2, 0x0a},
+	{ TM6010_REQ08_R0D_A_AMD_THRES, 0x40},
+	{ TM6010_REQ08_R1A_A_NICAM_SER_MAX, 0x64},
+	{ TM6010_REQ08_R1B_A_NICAM_SER_MIN, 0x20},
+	{ TM6010_REQ08_R16_A_AGC_GAIN_MAX, 0xfe},
+	{ TM6010_REQ08_R17_A_AGC_GAIN_MIN, 0x01},
 	{ TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc },
 
 	{ TM6010_REQ07_R3F_RESET, 0x01 },
@@ -590,38 +616,213 @@ int tm6000_init(struct tm6000_core *dev)
 
 int tm6000_set_audio_bitrate(struct tm6000_core *dev, int bitrate)
 {
-	int val;
+	int val = 0;
+	u8 areg_f0 = 0x60; /* ADC MCLK = 250 Fs */
+	u8 areg_0a = 0x91; /* SIF 48KHz */
+
+	switch (bitrate) {
+	case 48000:
+		areg_f0 = 0x60; /* ADC MCLK = 250 Fs */
+		areg_0a = 0x91; /* SIF 48KHz */
+		dev->audio_bitrate = bitrate;
+		break;
+	case 32000:
+		areg_f0 = 0x00; /* ADC MCLK = 375 Fs */
+		areg_0a = 0x90; /* SIF 32KHz */
+		dev->audio_bitrate = bitrate;
+		break;
+	default:
+		return -EINVAL;
+	}
+
 
 	if (dev->dev_type == TM6010) {
-		val = tm6000_get_reg(dev, TM6010_REQ08_R0A_A_I2S_MOD, 0);
+		val = tm6000_set_reg(dev, TM6010_REQ08_R0A_A_I2S_MOD, areg_0a);
 		if (val < 0)
 			return val;
-		val = (val & 0xf0) | 0x1; /* 48 kHz, not muted */
-		val = tm6000_set_reg(dev, TM6010_REQ08_R0A_A_I2S_MOD, val);
+
+		val = tm6000_set_reg_mask(dev, TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG,
+							areg_f0, 0xf0);
+		if (val < 0)
+			return val;
+	} else {
+		val = tm6000_set_reg_mask(dev, TM6000_REQ07_REB_VADC_AADC_MODE,
+							areg_f0, 0xf0);
 		if (val < 0)
 			return val;
 	}
 
-	val = tm6000_get_reg(dev, REQ_07_SET_GET_AVREG, 0xeb, 0x0);
-	if (val < 0)
-		return val;
+	return val;
+}
+EXPORT_SYMBOL_GPL(tm6000_set_audio_bitrate);
 
-	val &= 0x0f;		/* Preserve the audio input control bits */
-	switch (bitrate) {
-	case 44100:
-		val |= 0xd0;
-		dev->audio_bitrate = bitrate;
+int tm6000_set_audio_input(struct tm6000_core *dev, enum tm6000_inaudio ainp)
+{
+	if (dev->dev_type == TM6010) {
+		/* Audio crossbar setting, default SIF1 */
+		u8 areg_f0 = 0x03;
+
+		switch (ainp) {
+		case TM6000_AIP_SIF1:
+		case TM6000_AIP_SIF2:
+			areg_f0 = 0x03;
+			break;
+		case TM6000_AIP_LINE1:
+			areg_f0 = 0x00;
+			break;
+		case TM6000_AIP_LINE2:
+			areg_f0 = 0x08;
+			break;
+		default:
+			return 0;
+			break;
+		}
+		/* Set audio input crossbar */
+		tm6000_set_reg_mask(dev, TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG,
+							areg_f0, 0x0f);
+	} else {
+		/* Audio setting, default LINE1 */
+		u8 areg_eb = 0x00;
+
+		switch (ainp) {
+		case TM6000_AIP_LINE1:
+			areg_eb = 0x00;
+			break;
+		case TM6000_AIP_LINE2:
+			areg_eb = 0x04;
+			break;
+		default:
+			return 0;
+			break;
+		}
+		/* Set audio input */
+		tm6000_set_reg_mask(dev, TM6000_REQ07_REB_VADC_AADC_MODE,
+							areg_eb, 0x0f);
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(tm6000_set_audio_input);
+
+void tm6010_set_mute_sif(struct tm6000_core *dev, u8 mute)
+{
+	u8 mute_reg = 0;
+
+	if (mute)
+		mute_reg = 0x08;
+
+	tm6000_set_reg_mask(dev, TM6010_REQ08_R0A_A_I2S_MOD, mute_reg, 0x08);
+}
+
+void tm6010_set_mute_adc(struct tm6000_core *dev, u8 mute)
+{
+	u8 mute_reg = 0;
+
+	if (mute)
+		mute_reg = 0x20;
+
+	if (dev->dev_type == TM6010) {
+		tm6000_set_reg_mask(dev, TM6010_REQ08_RF2_LEFT_CHANNEL_VOL,
+							mute_reg, 0x20);
+		tm6000_set_reg_mask(dev, TM6010_REQ08_RF3_RIGHT_CHANNEL_VOL,
+							mute_reg, 0x20);
+	} else {
+		tm6000_set_reg_mask(dev, TM6000_REQ07_REC_VADC_AADC_LVOL,
+							mute_reg, 0x20);
+		tm6000_set_reg_mask(dev, TM6000_REQ07_RED_VADC_AADC_RVOL,
+							mute_reg, 0x20);
+	}
+}
+
+int tm6000_tvaudio_set_mute(struct tm6000_core *dev, u8 mute)
+{
+	enum tm6000_inaudio ainp;
+
+	if (dev->radio)
+		ainp = dev->aradio;
+	else
+		ainp = dev->avideo;
+
+	switch (ainp) {
+	case TM6000_AIP_SIF1:
+	case TM6000_AIP_SIF2:
+		if (dev->dev_type == TM6010)
+			tm6010_set_mute_sif(dev, mute);
+		else {
+			printk(KERN_INFO "ERROR: TM5600 and TM6000 don't has"
+					" SIF audio inputs. Please check the %s"
+					" configuration.\n", dev->name);
+			return -EINVAL;
+		}
 		break;
-	case 48000:
-		val |= 0x60;
-		dev->audio_bitrate = bitrate;
+	case TM6000_AIP_LINE1:
+	case TM6000_AIP_LINE2:
+		tm6010_set_mute_adc(dev, mute);
+		break;
+	default:
+		return -EINVAL;
 		break;
 	}
-	val = tm6000_set_reg(dev, REQ_07_SET_GET_AVREG, 0xeb, val);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(tm6000_tvaudio_set_mute);
 
-	return val;
+void tm6010_set_volume_sif(struct tm6000_core *dev, int vol)
+{
+	u8 vol_reg;
+
+	vol_reg = vol & 0x0F;
+
+	if (vol < 0)
+		vol_reg |= 0x40;
+
+	tm6000_set_reg(dev, TM6010_REQ08_R07_A_LEFT_VOL, vol_reg);
+	tm6000_set_reg(dev, TM6010_REQ08_R08_A_RIGHT_VOL, vol_reg);
 }
-EXPORT_SYMBOL_GPL(tm6000_set_audio_bitrate);
+
+void tm6010_set_volume_adc(struct tm6000_core *dev, int vol)
+{
+	u8 vol_reg;
+
+	vol_reg = (vol + 0x10) & 0x1f;
+
+	if (dev->dev_type == TM6010) {
+		tm6000_set_reg(dev, TM6010_REQ08_RF2_LEFT_CHANNEL_VOL, vol_reg);
+		tm6000_set_reg(dev, TM6010_REQ08_RF3_RIGHT_CHANNEL_VOL, vol_reg);
+	} else {
+		tm6000_set_reg(dev, TM6000_REQ07_REC_VADC_AADC_LVOL, vol_reg);
+		tm6000_set_reg(dev, TM6000_REQ07_RED_VADC_AADC_RVOL, vol_reg);
+	}
+}
+
+void tm6000_set_volume(struct tm6000_core *dev, int vol)
+{
+	enum tm6000_inaudio ainp;
+
+	if (dev->radio) {
+		ainp = dev->aradio;
+		vol += 8; /* Offset to 0 dB */
+	} else
+		ainp = dev->avideo;
+
+	switch (ainp) {
+	case TM6000_AIP_SIF1:
+	case TM6000_AIP_SIF2:
+		if (dev->dev_type == TM6010)
+			tm6010_set_volume_sif(dev, vol);
+		else
+			printk(KERN_INFO "ERROR: TM5600 and TM6000 don't has"
+					" SIF audio inputs. Please check the %s"
+					" configuration.\n", dev->name);
+		break;
+	case TM6000_AIP_LINE1:
+	case TM6000_AIP_LINE2:
+		tm6010_set_volume_adc(dev, vol);
+		break;
+	default:
+		break;
+	}
+}
+EXPORT_SYMBOL_GPL(tm6000_set_volume);
 
 static LIST_HEAD(tm6000_devlist);
 static DEFINE_MUTEX(tm6000_devlist_mutex);
diff --git a/drivers/staging/tm6000/tm6000-stds.c b/drivers/staging/tm6000/tm6000-stds.c
index cc7b866..a4c07e5 100644
--- a/drivers/staging/tm6000/tm6000-stds.c
+++ b/drivers/staging/tm6000/tm6000-stds.c
@@ -952,6 +952,22 @@ static int tm6000_set_audio_std(struct tm6000_core *dev,
 	uint8_t mono_flag = 0;  /* No mono */
 	uint8_t nicam_flag = 0; /* No NICAM */
 
+	if (dev->radio) {
+		tm6000_set_reg(dev, TM6010_REQ08_R01_A_INIT, 0x00);
+		tm6000_set_reg(dev, TM6010_REQ08_R02_A_FIX_GAIN_CTRL, 0x04);
+		tm6000_set_reg(dev, TM6010_REQ08_R03_A_AUTO_GAIN_CTRL, 0x00);
+		tm6000_set_reg(dev, TM6010_REQ08_R04_A_SIF_AMP_CTRL, 0x80);
+		tm6000_set_reg(dev, TM6010_REQ08_R05_A_STANDARD_MOD, 0x0c);
+		tm6000_set_reg(dev, TM6010_REQ08_R06_A_SOUND_MOD, 0x00);
+		tm6000_set_reg(dev, TM6010_REQ08_R09_A_MAIN_VOL, 0x18);
+		tm6000_set_reg(dev, TM6010_REQ08_R0C_A_ASD_THRES2, 0x0a);
+		tm6000_set_reg(dev, TM6010_REQ08_R0D_A_AMD_THRES, 0x40);
+		tm6000_set_reg(dev, TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc);
+		tm6000_set_reg(dev, TM6010_REQ08_R1E_A_GAIN_DEEMPH_OUT, 0x13);
+		tm6000_set_reg(dev, TM6010_REQ08_R01_A_INIT, 0x80);
+		return 0;
+	}
+
 	switch (std) {
 #if 0
 	case DK_MONO:
@@ -984,20 +1000,6 @@ static int tm6000_set_audio_std(struct tm6000_core *dev,
 	case EIAJ:
 		areg_05 = 0x02;
 		break;
-	case FM_RADIO:
-		tm6000_set_reg(dev, TM6010_REQ08_R01_A_INIT, 0x00);
-		tm6000_set_reg(dev, TM6010_REQ08_R02_A_FIX_GAIN_CTRL, 0x04);
-		tm6000_set_reg(dev, TM6010_REQ08_R03_A_AUTO_GAIN_CTRL, 0x00);
-		tm6000_set_reg(dev, TM6010_REQ08_R05_A_STANDARD_MOD, 0x0c);
-		tm6000_set_reg(dev, TM6010_REQ08_R06_A_SOUND_MOD, 0x00);
-		tm6000_set_reg(dev, TM6010_REQ08_R09_A_MAIN_VOL, 0x18);
-		tm6000_set_reg(dev, TM6010_REQ08_R0A_A_I2S_MOD, 0x91);
-		tm6000_set_reg(dev, TM6010_REQ08_R16_A_AGC_GAIN_MAX, 0xfe);
-		tm6000_set_reg(dev, TM6010_REQ08_R17_A_AGC_GAIN_MIN, 0x01);
-		tm6000_set_reg(dev, TM6010_REQ08_R1E_A_GAIN_DEEMPH_OUT, 0x13);
-		tm6000_set_reg(dev, TM6010_REQ08_R01_A_INIT, 0x80);
-		return 0;
-		break;
 	case I_NICAM:
 		areg_05 = 0x08;
 		nicam_flag = 1;
@@ -1010,6 +1012,9 @@ static int tm6000_set_audio_std(struct tm6000_core *dev,
 		areg_05 = 0x0a;
 		nicam_flag = 1;
 		break;
+	default:
+		/* do nothink */
+		break;
 	}
 
 #if 0
diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
index eb9b9f1..b550340 100644
--- a/drivers/staging/tm6000/tm6000-video.c
+++ b/drivers/staging/tm6000/tm6000-video.c
@@ -53,11 +53,17 @@
 /* Declare static vars that will be used as parameters */
 static unsigned int vid_limit = 16;	/* Video memory limit, in Mb */
 static int video_nr = -1;		/* /dev/videoN, -1 for autodetect */
+static int radio_nr = -1;		/* /dev/radioN, -1 for autodetect */
 
 /* Debug level */
 int tm6000_debug;
 EXPORT_SYMBOL_GPL(tm6000_debug);
 
+static const struct v4l2_queryctrl no_ctrl = {
+	.name  = "42",
+	.flags = V4L2_CTRL_FLAG_DISABLED,
+};
+
 /* supported controls */
 static struct v4l2_queryctrl tm6000_qctrl[] = {
 	{
@@ -96,9 +102,26 @@ static struct v4l2_queryctrl tm6000_qctrl[] = {
 		.step          = 0x1,
 		.default_value = 0,
 		.flags         = 0,
+	},
+		/* --- audio --- */
+	{
+		.id            = V4L2_CID_AUDIO_MUTE,
+		.name          = "Mute",
+		.minimum       = 0,
+		.maximum       = 1,
+		.type          = V4L2_CTRL_TYPE_BOOLEAN,
+	}, {
+		.id            = V4L2_CID_AUDIO_VOLUME,
+		.name          = "Volume",
+		.minimum       = -15,
+		.maximum       = 15,
+		.step          = 1,
+		.default_value = 0,
+		.type          = V4L2_CTRL_TYPE_INTEGER,
 	}
 };
 
+static const unsigned int CTRLS = ARRAY_SIZE(tm6000_qctrl);
 static int qctl_regs[ARRAY_SIZE(tm6000_qctrl)];
 
 static struct tm6000_fmt format[] = {
@@ -117,6 +140,16 @@ static struct tm6000_fmt format[] = {
 	}
 };
 
+static const struct v4l2_queryctrl *ctrl_by_id(unsigned int id)
+{
+	unsigned int i;
+
+	for (i = 0; i < CTRLS; i++)
+		if (tm6000_qctrl[i].id == id)
+			return tm6000_qctrl+i;
+	return NULL;
+}
+
 /* ------------------------------------------------------------------
  *	DMA and thread functions
  * ------------------------------------------------------------------
@@ -199,13 +232,17 @@ static int copy_streams(u8 *data, unsigned long len,
 	char *voutp = NULL;
 	unsigned int linewidth;
 
-	/* get video buffer */
-	get_next_buf(dma_q, &vbuf);
-	if (!vbuf)
-		return rc;
-	voutp = videobuf_to_vmalloc(&vbuf->vb);
-	if (!voutp)
-		return 0;
+	if (!dev->radio) {
+		/* get video buffer */
+		get_next_buf(dma_q, &vbuf);
+
+		if (!vbuf)
+			return rc;
+		voutp = videobuf_to_vmalloc(&vbuf->vb);
+
+		if (!voutp)
+			return 0;
+	}
 
 	for (ptr = data; ptr < endp;) {
 		if (!dev->isoc_ctl.cmd) {
@@ -257,29 +294,31 @@ static int copy_streams(u8 *data, unsigned long len,
 			 */
 			switch (cmd) {
 			case TM6000_URB_MSG_VIDEO:
-				if ((dev->isoc_ctl.vfield != field) &&
-					(field == 1)) {
+				if (!dev->radio) {
+					if ((dev->isoc_ctl.vfield != field) &&
+						(field == 1)) {
 					/* Announces that a new buffer
 					 * were filled
 					 */
-					buffer_filled(dev, dma_q, vbuf);
-					dprintk(dev, V4L2_DEBUG_ISOC,
+						buffer_filled(dev, dma_q, vbuf);
+						dprintk(dev, V4L2_DEBUG_ISOC,
 							"new buffer filled\n");
-					get_next_buf(dma_q, &vbuf);
-					if (!vbuf)
-						return rc;
-					voutp = videobuf_to_vmalloc(&vbuf->vb);
-					if (!voutp)
-						return rc;
-					memset(voutp, 0, vbuf->vb.size);
-				}
-				linewidth = vbuf->vb.width << 1;
-				pos = ((line << 1) - field - 1) * linewidth +
-					block * TM6000_URB_MSG_LEN;
-				/* Don't allow to write out of the buffer */
-				if (pos + size > vbuf->vb.size)
-					cmd = TM6000_URB_MSG_ERR;
-				dev->isoc_ctl.vfield = field;
+						get_next_buf(dma_q, &vbuf);
+						if (!vbuf)
+							return rc;
+						voutp = videobuf_to_vmalloc(&vbuf->vb);
+						if (!voutp)
+							return rc;
+						memset(voutp, 0, vbuf->vb.size);
+					}
+					linewidth = vbuf->vb.width << 1;
+					pos = ((line << 1) - field - 1) *
+					linewidth + block * TM6000_URB_MSG_LEN;
+					/* Don't allow to write out of the buffer */
+					if (pos + size > vbuf->vb.size)
+						cmd = TM6000_URB_MSG_ERR;
+					dev->isoc_ctl.vfield = field;
+			}
 				break;
 			case TM6000_URB_MSG_VBI:
 				break;
@@ -537,7 +576,7 @@ static void tm6000_uninit_isoc(struct tm6000_core *dev)
 /*
  * Allocate URBs and start IRQ
  */
-static int tm6000_prepare_isoc(struct tm6000_core *dev, unsigned int framesize)
+static int tm6000_prepare_isoc(struct tm6000_core *dev)
 {
 	struct tm6000_dmaqueue *dma_q = &dev->vidq;
 	int i, j, sb_size, pipe, size, max_packets, num_bufs = 8;
@@ -566,11 +605,7 @@ static int tm6000_prepare_isoc(struct tm6000_core *dev, unsigned int framesize)
 
 	dev->isoc_ctl.max_pkt_size = size;
 
-	max_packets = (framesize + size - 1) / size;
-
-	if (max_packets > TM6000_MAX_ISO_PACKETS)
-		max_packets = TM6000_MAX_ISO_PACKETS;
-
+	max_packets = TM6000_MAX_ISO_PACKETS;
 	sb_size = max_packets * size;
 
 	dev->isoc_ctl.num_bufs = num_bufs;
@@ -746,7 +781,7 @@ buffer_prepare(struct videobuf_queue *vq, struct videobuf_buffer *vb,
 		urb_init = 1;
 
 	if (urb_init) {
-		rc = tm6000_prepare_isoc(dev, buf->vb.size);
+		rc = tm6000_prepare_isoc(dev);
 		if (rc < 0)
 			goto fail;
 
@@ -1143,6 +1178,12 @@ static int vidioc_g_ctrl(struct file *file, void *priv,
 	case V4L2_CID_HUE:
 		val = tm6000_get_reg(dev, TM6010_REQ07_R0B_CHROMA_HUE_PHASE_ADJ, 0);
 		return 0;
+	case V4L2_CID_AUDIO_MUTE:
+		val = dev->ctl_mute;
+		return 0;
+	case V4L2_CID_AUDIO_VOLUME:
+		val = dev->ctl_volume;
+		return 0;
 	default:
 		return -EINVAL;
 	}
@@ -1174,6 +1215,14 @@ static int vidioc_s_ctrl(struct file *file, void *priv,
 	case V4L2_CID_HUE:
 		tm6000_set_reg(dev, TM6010_REQ07_R0B_CHROMA_HUE_PHASE_ADJ, val);
 		return 0;
+	case V4L2_CID_AUDIO_MUTE:
+		dev->ctl_mute = val;
+		tm6000_tvaudio_set_mute(dev, val);
+		return 0;
+	case V4L2_CID_AUDIO_VOLUME:
+		dev->ctl_volume = val;
+		tm6000_set_volume(dev, val);
+		return 0;
 	}
 	return -EINVAL;
 }
@@ -1221,7 +1270,7 @@ static int vidioc_g_frequency(struct file *file, void *priv,
 	if (unlikely(UNSET == dev->tuner_type))
 		return -EINVAL;
 
-	f->type = V4L2_TUNER_ANALOG_TV;
+	f->type = fh->radio ? V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
 	f->frequency = dev->freq;
 
 	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, g_frequency, f);
@@ -1235,13 +1284,14 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 	struct tm6000_fh   *fh  = priv;
 	struct tm6000_core *dev = fh->dev;
 
-	if (unlikely(f->type != V4L2_TUNER_ANALOG_TV))
-		return -EINVAL;
-
 	if (unlikely(UNSET == dev->tuner_type))
 		return -EINVAL;
 	if (unlikely(f->tuner != 0))
 		return -EINVAL;
+	if (0 == fh->radio && V4L2_TUNER_ANALOG_TV != f->type)
+		return -EINVAL;
+	if (1 == fh->radio && V4L2_TUNER_RADIO != f->type)
+		return -EINVAL;
 
 	dev->freq = f->frequency;
 	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_frequency, f);
@@ -1249,6 +1299,122 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 	return 0;
 }
 
+static int radio_querycap(struct file *file, void *priv,
+					struct v4l2_capability *cap)
+{
+	struct tm6000_fh *fh = file->private_data;
+	struct tm6000_core *dev = fh->dev;
+
+	strcpy(cap->driver, "tm6000");
+	strlcpy(cap->card, dev->name, sizeof(dev->name));
+	sprintf(cap->bus_info, "USB%04x:%04x",
+		le16_to_cpu(dev->udev->descriptor.idVendor),
+		le16_to_cpu(dev->udev->descriptor.idProduct));
+	cap->version = dev->dev_type;
+	cap->capabilities = V4L2_CAP_TUNER;
+
+	return 0;
+}
+
+static int radio_g_tuner(struct file *file, void *priv,
+					struct v4l2_tuner *t)
+{
+	struct tm6000_fh *fh = file->private_data;
+	struct tm6000_core *dev = fh->dev;
+
+	if (0 != t->index)
+		return -EINVAL;
+
+	memset(t, 0, sizeof(*t));
+	strcpy(t->name, "Radio");
+	t->type = V4L2_TUNER_RADIO;
+
+	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, g_tuner, t);
+
+	if ((dev->aradio == TM6000_AIP_LINE1) ||
+				(dev->aradio == TM6000_AIP_LINE2)) {
+		t->rxsubchans = V4L2_TUNER_SUB_MONO;
+	}
+	else {
+		t->rxsubchans = V4L2_TUNER_SUB_STEREO;
+	}
+
+	return 0;
+}
+
+static int radio_s_tuner(struct file *file, void *priv,
+					struct v4l2_tuner *t)
+{
+	struct tm6000_fh *fh = file->private_data;
+	struct tm6000_core *dev = fh->dev;
+
+	if (0 != t->index)
+		return -EINVAL;
+
+	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_tuner, t);
+
+	return 0;
+}
+
+static int radio_enum_input(struct file *file, void *priv,
+					struct v4l2_input *i)
+{
+	if (i->index != 0)
+		return -EINVAL;
+
+	strcpy(i->name, "Radio");
+	i->type = V4L2_INPUT_TYPE_TUNER;
+
+	return 0;
+}
+
+static int radio_g_input(struct file *filp, void *priv, unsigned int *i)
+{
+	*i = 0;
+	return 0;
+}
+
+static int radio_g_audio(struct file *file, void *priv,
+					struct v4l2_audio *a)
+{
+	memset(a, 0, sizeof(*a));
+	strcpy(a->name, "Radio");
+	return 0;
+}
+
+static int radio_s_audio(struct file *file, void *priv,
+					struct v4l2_audio *a)
+{
+	return 0;
+}
+
+static int radio_s_input(struct file *filp, void *priv, unsigned int i)
+{
+	return 0;
+}
+
+static int radio_s_std(struct file *file, void *fh, v4l2_std_id *norm)
+{
+	return 0;
+}
+
+static int radio_queryctrl(struct file *file, void *priv,
+					struct v4l2_queryctrl *c)
+{
+	const struct v4l2_queryctrl *ctrl;
+
+	if (c->id <  V4L2_CID_BASE ||
+	    c->id >= V4L2_CID_LASTP1)
+		return -EINVAL;
+	if (c->id == V4L2_CID_AUDIO_MUTE) {
+		ctrl = ctrl_by_id(c->id);
+		*c = *ctrl;
+	} else
+		*c = no_ctrl;
+
+	return 0;
+}
+
 /* ------------------------------------------------------------------
 	File operations for the device
    ------------------------------------------------------------------*/
@@ -1260,6 +1426,7 @@ static int tm6000_open(struct file *file)
 	struct tm6000_fh *fh;
 	enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	int i, rc;
+	int radio = 0;
 
 	printk(KERN_INFO "tm6000: open called (dev=%s)\n",
 		video_device_node_name(vdev));
@@ -1267,6 +1434,17 @@ static int tm6000_open(struct file *file)
 	dprintk(dev, V4L2_DEBUG_OPEN, "tm6000: open called (dev=%s)\n",
 		video_device_node_name(vdev));
 
+	switch (vdev->vfl_type) {
+	case VFL_TYPE_GRABBER:
+		type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+		break;
+	case VFL_TYPE_VBI:
+		type = V4L2_BUF_TYPE_VBI_CAPTURE;
+		break;
+	case VFL_TYPE_RADIO:
+		radio = 1;
+		break;
+	}
 
 	/* If more than one user, mutex should be added */
 	dev->users++;
@@ -1284,8 +1462,9 @@ static int tm6000_open(struct file *file)
 
 	file->private_data = fh;
 	fh->dev      = dev;
-
-	fh->type     = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	fh->radio    = radio;
+	dev->radio   = radio;
+	fh->type     = type;
 	dev->fourcc  = format[0].fourcc;
 
 	fh->fmt      = format_by_fourcc(dev->fourcc);
@@ -1322,6 +1501,19 @@ static int tm6000_open(struct file *file)
 			V4L2_FIELD_INTERLACED,
 			sizeof(struct tm6000_buffer), fh, &dev->lock);
 
+	if (fh->radio) {
+		dprintk(dev, V4L2_DEBUG_OPEN, "video_open: setting radio device\n");
+		tm6000_set_audio_input(dev, dev->aradio);
+		tm6000_set_volume(dev, dev->ctl_volume);
+		v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_radio);
+		tm6000_prepare_isoc(dev);
+		tm6000_start_thread(dev);
+	}
+	else {
+		tm6000_set_audio_input(dev, dev->avideo);
+		tm6000_set_volume(dev, dev->ctl_volume);
+	}
+
 	return 0;
 }
 
@@ -1445,6 +1637,36 @@ static struct video_device tm6000_template = {
 	.current_norm   = V4L2_STD_NTSC_M,
 };
 
+static const struct v4l2_file_operations radio_fops = {
+	.owner	  = THIS_MODULE,
+	.open	  = tm6000_open,
+	.release  = tm6000_release,
+	.ioctl	  = video_ioctl2,
+};
+
+static const struct v4l2_ioctl_ops radio_ioctl_ops = {
+	.vidioc_querycap	= radio_querycap,
+	.vidioc_g_tuner		= radio_g_tuner,
+	.vidioc_enum_input	= radio_enum_input,
+	.vidioc_g_audio		= radio_g_audio,
+	.vidioc_s_tuner		= radio_s_tuner,
+	.vidioc_s_audio		= radio_s_audio,
+	.vidioc_s_input		= radio_s_input,
+	.vidioc_s_std		= radio_s_std,
+	.vidioc_queryctrl	= radio_queryctrl,
+	.vidioc_g_input		= radio_g_input,
+	.vidioc_g_ctrl		= vidioc_g_ctrl,
+	.vidioc_s_ctrl		= vidioc_s_ctrl,
+	.vidioc_g_frequency	= vidioc_g_frequency,
+	.vidioc_s_frequency	= vidioc_s_frequency,
+};
+
+struct video_device tm6000_radio_template = {
+	.name			= "tm6000",
+	.fops			= &radio_fops,
+	.ioctl_ops 		= &radio_ioctl_ops,
+};
+
 /* -----------------------------------------------------------------
  *	Initialization and module stuff
  * ------------------------------------------------------------------
@@ -1499,6 +1721,25 @@ int tm6000_v4l2_register(struct tm6000_core *dev)
 	printk(KERN_INFO "%s: registered device %s\n",
 	       dev->name, video_device_node_name(dev->vfd));
 
+	dev->radio_dev = vdev_init(dev, &tm6000_radio_template,
+						   "radio");
+	if (!dev->radio_dev) {
+		printk(KERN_INFO "%s: can't register radio device\n",
+		       dev->name);
+		return ret; /* FIXME release resource */
+	}
+
+	ret = video_register_device(dev->radio_dev, VFL_TYPE_RADIO,
+				    radio_nr);
+	if (ret < 0) {
+		printk(KERN_INFO "%s: can't register radio device\n",
+		       dev->name);
+		return ret; /* FIXME release resource */
+	}
+
+	printk(KERN_INFO "%s: registered device %s\n",
+	       dev->name, video_device_node_name(dev->radio_dev));
+
 	printk(KERN_INFO "Trident TVMaster TM5600/TM6000/TM6010 USB2 board (Load status: %d)\n", ret);
 	return ret;
 }
@@ -1507,6 +1748,14 @@ int tm6000_v4l2_unregister(struct tm6000_core *dev)
 {
 	video_unregister_device(dev->vfd);
 
+	if (dev->radio_dev) {
+		if (video_is_registered(dev->radio_dev))
+			video_unregister_device(dev->radio_dev);
+		else
+			video_device_release(dev->radio_dev);
+		dev->radio_dev = NULL;
+	}
+
 	return 0;
 }
 
diff --git a/drivers/staging/tm6000/tm6000.h b/drivers/staging/tm6000/tm6000.h
index bf11eee..ccd120f 100644
--- a/drivers/staging/tm6000/tm6000.h
+++ b/drivers/staging/tm6000/tm6000.h
@@ -53,6 +53,14 @@ enum tm6000_devtype {
 	TM6010,
 };
 
+enum tm6000_inaudio {
+	TM6000_AIP_UNK = 0,
+	TM6000_AIP_SIF1,
+	TM6000_AIP_SIF2,
+	TM6000_AIP_LINE1,
+	TM6000_AIP_LINE2,
+};
+
 /* ------------------------------------------------------------------
  *	Basic structures
  * ------------------------------------------------------------------
@@ -174,6 +182,8 @@ struct tm6000_core {
 
 	char				*ir_codes;
 
+	__u8				radio;
+
 	/* Demodulator configuration */
 	int				demod_addr;	/* demodulator address */
 
@@ -194,6 +204,7 @@ struct tm6000_core {
 	bool				is_res_read;
 
 	struct video_device		*vfd;
+	struct video_device		*radio_dev;
 	struct tm6000_dmaqueue		vidq;
 	struct v4l2_device		v4l2_dev;
 
@@ -203,6 +214,9 @@ struct tm6000_core {
 
 	enum tm6000_mode		mode;
 
+	int				ctl_mute;             /* audio */
+	int				ctl_volume;
+
 	/* DVB-T support */
 	struct tm6000_dvb		*dvb;
 
@@ -210,7 +224,8 @@ struct tm6000_core {
 	struct snd_tm6000_card		*adev;
 	struct work_struct		wq_trigger;   /* Trigger to start/stop audio for alsa module */
 	atomic_t			stream_started;  /* stream should be running if true */
-
+	enum tm6000_inaudio		avideo;
+	enum tm6000_inaudio		aradio;
 
 	struct tm6000_IR		*ir;
 
@@ -248,6 +263,7 @@ struct tm6000_ops {
 
 struct tm6000_fh {
 	struct tm6000_core           *dev;
+	unsigned int                 radio;
 
 	/* video capture */
 	struct tm6000_fmt            *fmt;
@@ -276,12 +292,17 @@ int tm6000_get_reg(struct tm6000_core *dev, u8 req, u16 value, u16 index);
 int tm6000_get_reg16(struct tm6000_core *dev, u8 req, u16 value, u16 index);
 int tm6000_get_reg32(struct tm6000_core *dev, u8 req, u16 value, u16 index);
 int tm6000_set_reg(struct tm6000_core *dev, u8 req, u16 value, u16 index);
+int tm6000_set_reg_mask(struct tm6000_core *dev, u8 req, u16 value,
+						u16 index, u16 mask);
 int tm6000_i2c_reset(struct tm6000_core *dev, u16 tsleep);
 int tm6000_init(struct tm6000_core *dev);
 
 int tm6000_init_analog_mode(struct tm6000_core *dev);
 int tm6000_init_digital_mode(struct tm6000_core *dev);
 int tm6000_set_audio_bitrate(struct tm6000_core *dev, int bitrate);
+int tm6000_set_audio_input(struct tm6000_core *dev, enum tm6000_inaudio ainp);
+int tm6000_tvaudio_set_mute(struct tm6000_core *dev, u8 mute);
+void tm6000_set_volume(struct tm6000_core *dev, int vol);
 
 int tm6000_v4l2_register(struct tm6000_core *dev);
 int tm6000_v4l2_unregister(struct tm6000_core *dev);

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

--MP_/3xvKmQEYt4H2KpU/xp6D0ka--
