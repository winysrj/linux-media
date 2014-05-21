Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35966 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856AbaEUSUP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 May 2014 14:20:15 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Changbing Xiong <cb.xiong@samsung.com>,
	Trevor G <trevor.forums@gmail.com>,
	"Reynaldo H. Verdejo Pinochet" <r.verdejo@sisa.samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 6/8] xc5000: fix CamelCase
Date: Wed, 21 May 2014 15:20:00 -0300
Message-Id: <1400696402-1805-7-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1400696402-1805-1-git-send-email-m.chehab@samsung.com>
References: <1400696402-1805-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several CamelCase non-codingstyle compliances here.

Fix them.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/tuners/xc5000.c | 138 +++++++++++++++++++++---------------------
 1 file changed, 69 insertions(+), 69 deletions(-)

diff --git a/drivers/media/tuners/xc5000.c b/drivers/media/tuners/xc5000.c
index a5dff9714836..da4c29ed48bd 100644
--- a/drivers/media/tuners/xc5000.c
+++ b/drivers/media/tuners/xc5000.c
@@ -145,16 +145,16 @@ struct xc5000_priv {
 
 */
 struct XC_TV_STANDARD {
-	char *Name;
-	u16 AudioMode;
-	u16 VideoMode;
+	char *name;
+	u16 audio_mode;
+	u16 video_mode;
 };
 
 /* Tuner standards */
 #define MN_NTSC_PAL_BTSC	0
 #define MN_NTSC_PAL_A2		1
 #define MN_NTSC_PAL_EIAJ	2
-#define MN_NTSC_PAL_Mono	3
+#define MN_NTSC_PAL_MONO	3
 #define BG_PAL_A2		4
 #define BG_PAL_NICAM		5
 #define BG_PAL_MONO		6
@@ -172,11 +172,11 @@ struct XC_TV_STANDARD {
 #define DTV8			18
 #define DTV7_8			19
 #define DTV7			20
-#define FM_Radio_INPUT2 	21
-#define FM_Radio_INPUT1 	22
-#define FM_Radio_INPUT1_MONO	23
+#define FM_RADIO_INPUT2 	21
+#define FM_RADIO_INPUT1 	22
+#define FM_RADIO_INPUT1_MONO	23
 
-static struct XC_TV_STANDARD XC5000_Standard[MAX_TV_STANDARD] = {
+static struct XC_TV_STANDARD xc5000_standard[MAX_TV_STANDARD] = {
 	{"M/N-NTSC/PAL-BTSC", 0x0400, 0x8020},
 	{"M/N-NTSC/PAL-A2",   0x0600, 0x8020},
 	{"M/N-NTSC/PAL-EIAJ", 0x0440, 0x8020},
@@ -242,7 +242,7 @@ static inline const struct xc5000_fw_cfg *xc5000_assign_firmware(int chip_id)
 static int xc_load_fw_and_init_tuner(struct dvb_frontend *fe, int force);
 static int xc5000_is_firmware_loaded(struct dvb_frontend *fe);
 static int xc5000_readreg(struct xc5000_priv *priv, u16 reg, u16 *val);
-static int xc5000_TunerReset(struct dvb_frontend *fe);
+static int xc5000_tuner_reset(struct dvb_frontend *fe);
 
 static int xc_send_i2c_data(struct xc5000_priv *priv, u8 *buf, int len)
 {
@@ -293,7 +293,7 @@ static int xc5000_readreg(struct xc5000_priv *priv, u16 reg, u16 *val)
 	return 0;
 }
 
-static int xc5000_TunerReset(struct dvb_frontend *fe)
+static int xc5000_tuner_reset(struct dvb_frontend *fe)
 {
 	struct xc5000_priv *priv = fe->tuner_priv;
 	int ret;
@@ -317,20 +317,20 @@ static int xc5000_TunerReset(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int xc_write_reg(struct xc5000_priv *priv, u16 regAddr, u16 i2cData)
+static int xc_write_reg(struct xc5000_priv *priv, u16 reg_addr, u16 i2c_data)
 {
 	u8 buf[4];
-	int WatchDogTimer = 100;
+	int watch_dog_timer = 100;
 	int result;
 
-	buf[0] = (regAddr >> 8) & 0xFF;
-	buf[1] = regAddr & 0xFF;
-	buf[2] = (i2cData >> 8) & 0xFF;
-	buf[3] = i2cData & 0xFF;
+	buf[0] = (reg_addr >> 8) & 0xFF;
+	buf[1] = reg_addr & 0xFF;
+	buf[2] = (i2c_data >> 8) & 0xFF;
+	buf[3] = i2c_data & 0xFF;
 	result = xc_send_i2c_data(priv, buf, 4);
 	if (result == 0) {
 		/* wait for busy flag to clear */
-		while ((WatchDogTimer > 0) && (result == 0)) {
+		while ((watch_dog_timer > 0) && (result == 0)) {
 			result = xc5000_readreg(priv, XREG_BUSY, (u16 *)buf);
 			if (result == 0) {
 				if ((buf[0] == 0) && (buf[1] == 0)) {
@@ -338,12 +338,12 @@ static int xc_write_reg(struct xc5000_priv *priv, u16 regAddr, u16 i2cData)
 					break;
 				} else {
 					msleep(5); /* wait 5 ms */
-					WatchDogTimer--;
+					watch_dog_timer--;
 				}
 			}
 		}
 	}
-	if (WatchDogTimer <= 0)
+	if (watch_dog_timer <= 0)
 		result = -EREMOTEIO;
 
 	return result;
@@ -363,7 +363,7 @@ static int xc_load_i2c_sequence(struct dvb_frontend *fe, const u8 *i2c_sequence)
 		len = i2c_sequence[index] * 256 + i2c_sequence[index+1];
 		if (len == 0x0000) {
 			/* RESET command */
-			result = xc5000_TunerReset(fe);
+			result = xc5000_tuner_reset(fe);
 			index += 2;
 			if (result != 0)
 				return result;
@@ -409,29 +409,29 @@ static int xc_initialize(struct xc5000_priv *priv)
 	return xc_write_reg(priv, XREG_INIT, 0);
 }
 
-static int xc_SetTVStandard(struct xc5000_priv *priv,
-	u16 VideoMode, u16 AudioMode, u8 RadioMode)
+static int xc_set_tv_standard(struct xc5000_priv *priv,
+	u16 video_mode, u16 audio_mode, u8 radio_mode)
 {
 	int ret;
-	dprintk(1, "%s(0x%04x,0x%04x)\n", __func__, VideoMode, AudioMode);
-	if (RadioMode) {
+	dprintk(1, "%s(0x%04x,0x%04x)\n", __func__, video_mode, audio_mode);
+	if (radio_mode) {
 		dprintk(1, "%s() Standard = %s\n",
 			__func__,
-			XC5000_Standard[RadioMode].Name);
+			xc5000_standard[radio_mode].name);
 	} else {
 		dprintk(1, "%s() Standard = %s\n",
 			__func__,
-			XC5000_Standard[priv->video_standard].Name);
+			xc5000_standard[priv->video_standard].name);
 	}
 
-	ret = xc_write_reg(priv, XREG_VIDEO_MODE, VideoMode);
+	ret = xc_write_reg(priv, XREG_VIDEO_MODE, video_mode);
 	if (ret == 0)
-		ret = xc_write_reg(priv, XREG_AUDIO_MODE, AudioMode);
+		ret = xc_write_reg(priv, XREG_AUDIO_MODE, audio_mode);
 
 	return ret;
 }
 
-static int xc_SetSignalSource(struct xc5000_priv *priv, u16 rf_mode)
+static int xc_set_signal_source(struct xc5000_priv *priv, u16 rf_mode)
 {
 	dprintk(1, "%s(%d) Source = %s\n", __func__, rf_mode,
 		rf_mode == XC_RF_MODE_AIR ? "ANTENNA" : "CABLE");
@@ -447,7 +447,7 @@ static int xc_SetSignalSource(struct xc5000_priv *priv, u16 rf_mode)
 
 static const struct dvb_tuner_ops xc5000_tuner_ops;
 
-static int xc_set_RF_frequency(struct xc5000_priv *priv, u32 freq_hz)
+static int xc_set_rf_frequency(struct xc5000_priv *priv, u32 freq_hz)
 {
 	u16 freq_code;
 
@@ -476,7 +476,7 @@ static int xc_set_IF_frequency(struct xc5000_priv *priv, u32 freq_khz)
 }
 
 
-static int xc_get_ADC_Envelope(struct xc5000_priv *priv, u16 *adc_envelope)
+static int xc_get_adc_envelope(struct xc5000_priv *priv, u16 *adc_envelope)
 {
 	return xc5000_readreg(priv, XREG_ADC_ENV, adc_envelope);
 }
@@ -484,14 +484,14 @@ static int xc_get_ADC_Envelope(struct xc5000_priv *priv, u16 *adc_envelope)
 static int xc_get_frequency_error(struct xc5000_priv *priv, u32 *freq_error_hz)
 {
 	int result;
-	u16 regData;
+	u16 reg_data;
 	u32 tmp;
 
-	result = xc5000_readreg(priv, XREG_FREQ_ERROR, &regData);
+	result = xc5000_readreg(priv, XREG_FREQ_ERROR, &reg_data);
 	if (result != 0)
 		return result;
 
-	tmp = (u32)regData;
+	tmp = (u32)reg_data;
 	(*freq_error_hz) = (tmp * 15625) / 1000;
 	return result;
 }
@@ -527,14 +527,14 @@ static int xc_get_buildversion(struct xc5000_priv *priv, u16 *buildrev)
 
 static int xc_get_hsync_freq(struct xc5000_priv *priv, u32 *hsync_freq_hz)
 {
-	u16 regData;
+	u16 reg_data;
 	int result;
 
-	result = xc5000_readreg(priv, XREG_HSYNC_FREQ, &regData);
+	result = xc5000_readreg(priv, XREG_HSYNC_FREQ, &reg_data);
 	if (result != 0)
 		return result;
 
-	(*hsync_freq_hz) = ((regData & 0x0fff) * 763)/100;
+	(*hsync_freq_hz) = ((reg_data & 0x0fff) * 763)/100;
 	return result;
 }
 
@@ -558,19 +558,19 @@ static int xc_get_totalgain(struct xc5000_priv *priv, u16 *totalgain)
 	return xc5000_readreg(priv, XREG_TOTALGAIN, totalgain);
 }
 
-static u16 WaitForLock(struct xc5000_priv *priv)
+static u16 wait_for_lock(struct xc5000_priv *priv)
 {
-	u16 lockState = 0;
-	int watchDogCount = 40;
+	u16 lock_state = 0;
+	int watch_dog_count = 40;
 
-	while ((lockState == 0) && (watchDogCount > 0)) {
-		xc_get_lock_status(priv, &lockState);
-		if (lockState != 1) {
+	while ((lock_state == 0) && (watch_dog_count > 0)) {
+		xc_get_lock_status(priv, &lock_state);
+		if (lock_state != 1) {
 			msleep(5);
-			watchDogCount--;
+			watch_dog_count--;
 		}
 	}
-	return lockState;
+	return lock_state;
 }
 
 #define XC_TUNE_ANALOG  0
@@ -581,11 +581,11 @@ static int xc_tune_channel(struct xc5000_priv *priv, u32 freq_hz, int mode)
 
 	dprintk(1, "%s(%u)\n", __func__, freq_hz);
 
-	if (xc_set_RF_frequency(priv, freq_hz) != 0)
+	if (xc_set_rf_frequency(priv, freq_hz) != 0)
 		return 0;
 
 	if (mode == XC_TUNE_ANALOG) {
-		if (WaitForLock(priv) == 1)
+		if (wait_for_lock(priv) == 1)
 			found = 1;
 	}
 
@@ -684,7 +684,7 @@ static void xc_debug_dump(struct xc5000_priv *priv)
 	 */
 	msleep(100);
 
-	xc_get_ADC_Envelope(priv,  &adc_envelope);
+	xc_get_adc_envelope(priv,  &adc_envelope);
 	dprintk(1, "*** ADC envelope (0-1023) = %d\n", adc_envelope);
 
 	xc_get_frequency_error(priv, &freq_error_hz);
@@ -807,19 +807,19 @@ static int xc5000_set_params(struct dvb_frontend *fe)
 	dprintk(1, "%s() frequency=%d (compensated to %d)\n",
 		__func__, freq, priv->freq_hz);
 
-	ret = xc_SetSignalSource(priv, priv->rf_mode);
+	ret = xc_set_signal_source(priv, priv->rf_mode);
 	if (ret != 0) {
 		printk(KERN_ERR
-			"xc5000: xc_SetSignalSource(%d) failed\n",
+			"xc5000: xc_set_signal_source(%d) failed\n",
 			priv->rf_mode);
 		return -EREMOTEIO;
 	}
 
-	ret = xc_SetTVStandard(priv,
-		XC5000_Standard[priv->video_standard].VideoMode,
-		XC5000_Standard[priv->video_standard].AudioMode, 0);
+	ret = xc_set_tv_standard(priv,
+		xc5000_standard[priv->video_standard].video_mode,
+		xc5000_standard[priv->video_standard].audio_mode, 0);
 	if (ret != 0) {
-		printk(KERN_ERR "xc5000: xc_SetTVStandard failed\n");
+		printk(KERN_ERR "xc5000: xc_set_tv_standard failed\n");
 		return -EREMOTEIO;
 	}
 
@@ -923,19 +923,19 @@ static int xc5000_set_tv_freq(struct dvb_frontend *fe,
 	}
 
 tune_channel:
-	ret = xc_SetSignalSource(priv, priv->rf_mode);
+	ret = xc_set_signal_source(priv, priv->rf_mode);
 	if (ret != 0) {
 		printk(KERN_ERR
-			"xc5000: xc_SetSignalSource(%d) failed\n",
+			"xc5000: xc_set_signal_source(%d) failed\n",
 			priv->rf_mode);
 		return -EREMOTEIO;
 	}
 
-	ret = xc_SetTVStandard(priv,
-		XC5000_Standard[priv->video_standard].VideoMode,
-		XC5000_Standard[priv->video_standard].AudioMode, 0);
+	ret = xc_set_tv_standard(priv,
+		xc5000_standard[priv->video_standard].video_mode,
+		xc5000_standard[priv->video_standard].audio_mode, 0);
 	if (ret != 0) {
-		printk(KERN_ERR "xc5000: xc_SetTVStandard failed\n");
+		printk(KERN_ERR "xc5000: xc_set_tv_standard failed\n");
 		return -EREMOTEIO;
 	}
 
@@ -980,11 +980,11 @@ static int xc5000_set_radio_freq(struct dvb_frontend *fe,
 	}
 
 	if (priv->radio_input == XC5000_RADIO_FM1)
-		radio_input = FM_Radio_INPUT1;
+		radio_input = FM_RADIO_INPUT1;
 	else if  (priv->radio_input == XC5000_RADIO_FM2)
-		radio_input = FM_Radio_INPUT2;
+		radio_input = FM_RADIO_INPUT2;
 	else if  (priv->radio_input == XC5000_RADIO_FM1_MONO)
-		radio_input = FM_Radio_INPUT1_MONO;
+		radio_input = FM_RADIO_INPUT1_MONO;
 	else {
 		dprintk(1, "%s() unknown radio input %d\n", __func__,
 			priv->radio_input);
@@ -995,18 +995,18 @@ static int xc5000_set_radio_freq(struct dvb_frontend *fe,
 
 	priv->rf_mode = XC_RF_MODE_AIR;
 
-	ret = xc_SetTVStandard(priv, XC5000_Standard[radio_input].VideoMode,
-			       XC5000_Standard[radio_input].AudioMode, radio_input);
+	ret = xc_set_tv_standard(priv, xc5000_standard[radio_input].video_mode,
+			       xc5000_standard[radio_input].audio_mode, radio_input);
 
 	if (ret != 0) {
-		printk(KERN_ERR "xc5000: xc_SetTVStandard failed\n");
+		printk(KERN_ERR "xc5000: xc_set_tv_standard failed\n");
 		return -EREMOTEIO;
 	}
 
-	ret = xc_SetSignalSource(priv, priv->rf_mode);
+	ret = xc_set_signal_source(priv, priv->rf_mode);
 	if (ret != 0) {
 		printk(KERN_ERR
-			"xc5000: xc_SetSignalSource(%d) failed\n",
+			"xc5000: xc_set_signal_source(%d) failed\n",
 			priv->rf_mode);
 		return -EREMOTEIO;
 	}
@@ -1177,7 +1177,7 @@ static int xc5000_sleep(struct dvb_frontend *fe)
 	/* According to Xceive technical support, the "powerdown" register
 	   was removed in newer versions of the firmware.  The "supported"
 	   way to sleep the tuner is to pull the reset pin low for 10ms */
-	ret = xc5000_TunerReset(fe);
+	ret = xc5000_tuner_reset(fe);
 	if (ret != 0) {
 		printk(KERN_ERR
 			"xc5000: %s() unable to shutdown tuner\n",
-- 
1.9.0

