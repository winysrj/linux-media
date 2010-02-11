Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.juropnet.hu ([212.24.188.131]:46804 "EHLO mail.juropnet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756675Ab0BKTMk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Feb 2010 14:12:40 -0500
Received: from kabelnet-194-138.juropnet.hu ([91.147.194.138])
	by mail.juropnet.hu with esmtps (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <istvan_v@mailbox.hu>)
	id 1NfeQE-0004hY-42
	for linux-media@vger.kernel.org; Thu, 11 Feb 2010 20:09:58 +0100
Message-ID: <4B745781.2020408@mailbox.hu>
Date: Thu, 11 Feb 2010 20:16:17 +0100
From: "istvan_v@mailbox.hu" <istvan_v@mailbox.hu>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: DTV2000 H Plus issues
References: <4B3F6FE0.4040307@internode.on.net> <4B3F7B0D.4030601@mailbox.hu> <4B405381.9090407@internode.on.net> <4B421BCB.6050909@mailbox.hu> <4B4294FE.8000309@internode.on.net> <4B463AC6.2000901@mailbox.hu> <4B719CD0.6060804@mailbox.hu>
In-Reply-To: <4B719CD0.6060804@mailbox.hu>
Content-Type: multipart/mixed;
 boundary="------------040508040903080806040408"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040508040903080806040408
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Update: the following patch, which should be applied after the previous
ones, makes a few additional changes to the XC4000 driver:
  - adds support for DTV7
  - implements power management
  - adds a mutex and locking for tuner operations
  - some unused or unneeded code has been removed

On 02/09/2010 06:35 PM, istvan_v@mailbox.hu wrote:

> There are two separate patches for v4l-dvb revision 28f5eca12bb0: the
> first one adds the XC4000 driver, while the second one adds support for
> the Leadtek WinFast DTV2000H Plus card in the CX88 driver.
> 
> http://www.sharemation.com/IstvanV/v4l/xc4000-28f5eca12bb0.patch
> http://www.sharemation.com/IstvanV/v4l/cx88-dtv2000h+-28f5eca12bb0.patch
> 
> These new firmware files are more complete than the previous ones, but
> are not compatible with the original driver. Both version 1.2 and 1.4
> are available:
> 
> http://www.sharemation.com/IstvanV/v4l/xc4000-1.2.fw
> http://www.sharemation.com/IstvanV/v4l/xc4000-1.4.fw
> 
> The following simple utility was used for creating the firmware files.
> 
> http://www.sharemation.com/IstvanV/v4l/xc4000fw.c

--------------040508040903080806040408
Content-Type: text/x-patch;
 name="xc4000-2-28f5eca12bb0.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="xc4000-2-28f5eca12bb0.patch"

diff -r -d -N -U4 v4l-dvb-28f5eca12bb0.old/linux/drivers/media/common/tuners/xc4000.c v4l-dvb-28f5eca12bb0/linux/drivers/media/common/tuners/xc4000.c
--- v4l-dvb-28f5eca12bb0.old/linux/drivers/media/common/tuners/xc4000.c	2010-02-11 20:08:39.000000000 +0100
+++ v4l-dvb-28f5eca12bb0/linux/drivers/media/common/tuners/xc4000.c	2010-02-11 20:05:01.000000000 +0100
@@ -27,8 +27,9 @@
 #include <linux/videodev2.h>
 #include <linux/delay.h>
 #include <linux/dvb/frontend.h>
 #include <linux/i2c.h>
+#include <linux/mutex.h>
 #include <asm/unaligned.h>
 
 #include "dvb_frontend.h"
 
@@ -61,9 +62,9 @@
 	"The valid values are a sum of:\n"
 	" 1: use NICAM/B and A2/B instead of NICAM/A and A2/A\n"
 	" 2: use A2 instead of NICAM or BTSC\n"
 	" 4: use SECAM/K3 instead of K1\n"
-	" 8: force SECAM-L audio\n"
+	" 8: use PAL-D/K audio for SECAM-D/K\n"
 	"16: use FM radio input 1 instead of input 2\n"
 	"32: use mono audio (the lower three bits are ignored)\n");
 
 #define XC4000_DEFAULT_FIRMWARE "xc4000.fw"
@@ -108,18 +109,20 @@
 	u32	bandwidth;
 	u8	video_standard;
 	u8	rf_mode;
 	u8	card_type;
+	u8	ignore_i2c_write_errors;
  /*	struct xc2028_ctrl	ctrl; */
 	struct firmware_properties cur_fw;
 	__u16	hwmodel;
 	__u16	hwvers;
-	u8	ignore_i2c_write_errors;
+	struct mutex	lock;
 };
 
 /* Misc Defines */
 #define MAX_TV_STANDARD			24
 #define XC_MAX_I2C_WRITE_LENGTH		64
+#define XC_POWERED_DOWN			0x80000000U
 
 /* Signal Types */
 #define XC_RF_MODE_AIR			0
 #define XC_RF_MODE_CABLE		1
@@ -240,9 +243,9 @@
 	{"D/K-PAL-MONO",	0x0078, 0x8049, 6500},
 	{"D/K-SECAM-A2 DK1",	0x0000, 0x8049, 6340},
 	{"D/K-SECAM-A2 L/DK3",	0x0000, 0x8049, 6000},
 	{"D/K-SECAM-A2 MONO",	0x0078, 0x8049, 6500},
-	{"D/K-SECAM-NICAM",	0x8080, 0x8049, 6200},
+	{"D/K-SECAM-NICAM",	0x0080, 0x8049, 6200},
 	{"L-SECAM-NICAM",	0x8080, 0x0009, 6200},
 	{"L'-SECAM-NICAM",	0x8080, 0x4009, 6200},
 	{"DTV6",		0x00C0, 0x8002,    0},
 	{"DTV8",		0x00C0, 0x800B,    0},
@@ -251,11 +254,8 @@
 	{"FM Radio-INPUT2",	0x0008, 0x9800,10700},
 	{"FM Radio-INPUT1",	0x0008, 0x9000,10700}
 };
 
-#if 0
-static int xc4000_is_firmware_loaded(struct dvb_frontend *fe);
-#endif
 static int xc4000_readreg(struct xc4000_priv *priv, u16 reg, u16 *val);
 static int xc4000_TunerReset(struct dvb_frontend *fe);
 
 static int xc_send_i2c_data(struct xc4000_priv *priv, u8 *buf, int len)
@@ -275,25 +275,8 @@
 	}
 	return XC_RESULT_SUCCESS;
 }
 
-/* This routine is never used because the only time we read data from the
-   i2c bus is when we read registers, and we want that to be an atomic i2c
-   transaction in case we are on a multi-master bus */
-#if 0
-static int xc_read_i2c_data(struct xc4000_priv *priv, u8 *buf, int len)
-{
-	struct i2c_msg msg = { .addr = priv->i2c_props.addr,
-		.flags = I2C_M_RD, .buf = buf, .len = len };
-
-	if (i2c_transfer(priv->i2c_props.adap, &msg, 1) != 1) {
-		printk(KERN_ERR "xc4000 I2C read failed (len=%i)\n", len);
-		return -EREMOTEIO;
-	}
-	return 0;
-}
-#endif
-
 static void xc_wait(int wait_ms)
 {
 	msleep(wait_ms);
 }
@@ -444,17 +427,8 @@
 	   only be used for fast scanning for channel lock) */
 	return xc_write_reg(priv, XREG_RF_FREQ, freq_code); /* WAS: XREG_FINERFREQ */
 }
 
-#if 0
-/* We'll probably need these for analog support */
-static int xc_set_Xtal_frequency(struct xc4000_priv *priv, u32 xtalFreqInKHz)
-{
-	u16 xtalRatio = (32000 * 0x8000)/xtalFreqInKHz;
-	return xc_write_reg(priv, XREG_XTALFREQ, xtalRatio);
-}
-#endif
-
 static int xc_get_ADC_Envelope(struct xc4000_priv *priv, u16 *adc_envelope)
 {
 	return xc4000_readreg(priv, XREG_ADC_ENV, adc_envelope);
 }
@@ -1134,8 +1108,11 @@
 	u16	quality;
 	u8	hw_majorversion = 0, hw_minorversion = 0;
 	u8	fw_majorversion = 0, fw_minorversion = 0;
 
+	if (!(priv->cur_fw.type & BASE))
+		return;
+
 	/* Wait for stats to stabilize.
 	 * Frame Lines needs two frame times after initial lock
 	 * before it is valid.
 	 */
@@ -1174,12 +1151,14 @@
 	struct dvb_frontend_parameters *params)
 {
 	struct xc4000_priv *priv = fe->tuner_priv;
 	unsigned int type;
-	int ret;
+	int	ret = -EREMOTEIO;
 
 	dprintk(1, "%s() frequency=%d (Hz)\n", __func__, params->frequency);
 
+	mutex_lock(&priv->lock);
+
 	if (fe->ops.info.type == FE_ATSC) {
 		dprintk(1, "%s() ATSC\n", __func__);
 		switch (params->u.vsb.modulation) {
 		case VSB_8:
@@ -1201,9 +1180,10 @@
 			priv->video_standard = XC4000_DTV6;
 			type = DTV6;
 			break;
 		default:
-			return -EINVAL;
+			ret = -EINVAL;
+			goto fail;
 		}
 	} else if (fe->ops.info.type == FE_OFDM) {
 		dprintk(1, "%s() OFDM\n", __func__);
 		switch (params->u.ofdm.bandwidth) {
@@ -1213,44 +1193,56 @@
 			priv->freq_hz = params->frequency - 1750000;
 			type = DTV6;
 			break;
 		case BANDWIDTH_7_MHZ:
-			printk(KERN_ERR "xc4000 bandwidth 7MHz not supported\n");
+			priv->bandwidth = BANDWIDTH_7_MHZ;
+			priv->video_standard = XC4000_DTV7;
+			priv->freq_hz = params->frequency - 2250000;
 			type = DTV7;
-			return -EINVAL;
+			break;
 		case BANDWIDTH_8_MHZ:
 			priv->bandwidth = BANDWIDTH_8_MHZ;
 			priv->video_standard = XC4000_DTV8;
 			priv->freq_hz = params->frequency - 2750000;
 			type = DTV8;
 			break;
+		case BANDWIDTH_AUTO:
+			if (params->frequency < 400000000) {
+				priv->bandwidth = BANDWIDTH_7_MHZ;
+				priv->freq_hz = params->frequency - 2250000;
+			} else {
+				priv->bandwidth = BANDWIDTH_8_MHZ;
+				priv->freq_hz = params->frequency - 2750000;
+			}
+			priv->video_standard = XC4000_DTV7_8;
+			type = DTV78;
+			break;
 		default:
 			printk(KERN_ERR "xc4000 bandwidth not set!\n");
-			return -EINVAL;
+			ret = -EINVAL;
+			goto fail;
 		}
 		priv->rf_mode = XC_RF_MODE_AIR;
 	} else {
 		printk(KERN_ERR "xc4000 modulation type not supported!\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto fail;
 	}
 
 	dprintk(1, "%s() frequency=%d (compensated)\n",
 		__func__, priv->freq_hz);
 
 	/* Make sure the correct firmware type is loaded */
-	if (check_firmware(fe, type, 0, priv->if_khz) != XC_RESULT_SUCCESS) {
-		return -EREMOTEIO;
-	}
+	if (check_firmware(fe, type, 0, priv->if_khz) != XC_RESULT_SUCCESS)
+		goto fail;
 
 	ret = xc_SetSignalSource(priv, priv->rf_mode);
 	if (ret != XC_RESULT_SUCCESS) {
 		printk(KERN_ERR
-			"xc4000: xc_SetSignalSource(%d) failed\n",
-			priv->rf_mode);
-		return -EREMOTEIO;
-	}
-
-	{
+		       "xc4000: xc_SetSignalSource(%d) failed\n",
+		       priv->rf_mode);
+		goto fail;
+	} else {
 		u16	video_mode, audio_mode;
 		video_mode = XC4000_Standard[priv->video_standard].VideoMode;
 		audio_mode = XC4000_Standard[priv->video_standard].AudioMode;
 		if (type == DTV6 && priv->firm_version != 0x0102)
@@ -1258,79 +1250,52 @@
 		ret = xc_SetTVStandard(priv, video_mode, audio_mode);
 		if (ret != XC_RESULT_SUCCESS) {
 			printk(KERN_ERR "xc4000: xc_SetTVStandard failed\n");
 			/* DJH - do not return when it fails... */
-			/* return -EREMOTEIO; */
+			/* goto fail; */
 		}
 	}
 
 	if (priv->card_type == XC4000_CARD_DTV2000H_PLUS) {
-		ret = 0;
-		if (xc_write_reg(priv, XREG_D_CODE, 0) != 0)
-			ret = -EREMOTEIO;
+		if (xc_write_reg(priv, XREG_D_CODE, 0) == 0)
+			ret = 0;
 		if (xc_write_reg(priv, XREG_AMPLITUDE,
 				 (priv->firm_version == 0x0102 ? 132 : 134))
 		    != 0)
 			ret = -EREMOTEIO;
 		if (xc_write_reg(priv, XREG_SMOOTHEDCVBS, 1) != 0)
 			ret = -EREMOTEIO;
 		if (ret != 0) {
 			printk(KERN_ERR "xc4000: setting registers failed\n");
-			/* return ret; */
+			/* goto fail; */
 		}
 	}
 
-#ifdef DJH_DEBUG
-	ret = xc_set_IF_frequency(priv, priv->if_khz);
-	if (ret != XC_RESULT_SUCCESS) {
-		printk(KERN_ERR "xc4000: xc_Set_IF_frequency(%d) failed\n",
-		       priv->if_khz);
-		return -EIO;
-	}
-#endif
 	xc_tune_channel(priv, priv->freq_hz, XC_TUNE_DIGITAL);
 
 	if (debug)
 		xc_debug_dump(priv);
+	ret = 0;
 
-	return 0;
-}
-
-#if 0
-static int xc4000_is_firmware_loaded(struct dvb_frontend *fe)
-{
-	struct xc4000_priv *priv = fe->tuner_priv;
-	int ret;
-	u16 id;
-
-	ret = xc4000_readreg(priv, XREG_PRODUCT_ID, &id);
-	if (ret == XC_RESULT_SUCCESS) {
-		if (id == XC_PRODUCT_ID_FW_NOT_LOADED)
-			ret = XC_RESULT_RESET_FAILURE;
-		else
-			ret = XC_RESULT_SUCCESS;
-	}
+fail:
+	mutex_unlock(&priv->lock);
 
-	dprintk(1, "%s() returns %s id = 0x%x\n", __func__,
-		ret == XC_RESULT_SUCCESS ? "True" : "False", id);
 	return ret;
 }
-#endif
 
 static int xc4000_set_analog_params(struct dvb_frontend *fe,
 	struct analog_parameters *params)
 {
 	struct xc4000_priv *priv = fe->tuner_priv;
 	unsigned int type = 0;
-	int	ret;
-
-	/* Fix me: it could be air. */
-	priv->rf_mode = XC_RF_MODE_CABLE;
+	int	ret = -EREMOTEIO;
 
 	if (params->mode == V4L2_TUNER_RADIO) {
 		dprintk(1, "%s() frequency=%d (in units of 62.5Hz)\n",
 			__func__, params->frequency);
 
+		mutex_lock(&priv->lock);
+
 		params->std = 0;
 		priv->freq_hz = params->frequency * 125L / 2;
 
 		if (audio_std & XC4000_AUDIO_STD_INPUT1) {
@@ -1346,8 +1311,10 @@
 
 	dprintk(1, "%s() frequency=%d (in units of 62.5khz)\n",
 		__func__, params->frequency);
 
+	mutex_lock(&priv->lock);
+
 	/* params->frequency is in units of 62.5khz */
 	priv->freq_hz = params->frequency * 62500;
 
 	/* if std is not defined, choose one */
@@ -1454,24 +1421,24 @@
 		goto tune_channel;
 	}
 
 tune_channel:
+	/* Fix me: it could be air. */
+	priv->rf_mode = XC_RF_MODE_CABLE;
 
 	if (check_firmware(fe, type, params->std,
 			   XC4000_Standard[priv->video_standard].int_freq)
 	    != XC_RESULT_SUCCESS) {
-		return -EREMOTEIO;
+		goto fail;
 	}
 
 	ret = xc_SetSignalSource(priv, priv->rf_mode);
 	if (ret != XC_RESULT_SUCCESS) {
 		printk(KERN_ERR
 			"xc4000: xc_SetSignalSource(%d) failed\n",
 			priv->rf_mode);
-		return -EREMOTEIO;
-	}
-
-	{
+		goto fail;
+	} else {
 		u16	video_mode, audio_mode;
 		video_mode = XC4000_Standard[priv->video_standard].VideoMode;
 		audio_mode = XC4000_Standard[priv->video_standard].AudioMode;
 		if (priv->video_standard < XC4000_BG_PAL_A2) {
@@ -1486,49 +1453,58 @@
 		}
 		ret = xc_SetTVStandard(priv, video_mode, audio_mode);
 		if (ret != XC_RESULT_SUCCESS) {
 			printk(KERN_ERR "xc4000: xc_SetTVStandard failed\n");
-			return -EREMOTEIO;
+			goto fail;
 		}
 	}
 
 	if (priv->card_type == XC4000_CARD_DTV2000H_PLUS) {
-		ret = 0;
-		if (xc_write_reg(priv, XREG_D_CODE, 0) != 0)
-			ret = -EREMOTEIO;
+		if (xc_write_reg(priv, XREG_D_CODE, 0) == 0)
+			ret = 0;
 		if (xc_write_reg(priv, XREG_AMPLITUDE, 1) != 0)
 			ret = -EREMOTEIO;
 		if (xc_write_reg(priv, XREG_SMOOTHEDCVBS, 1) != 0)
 			ret = -EREMOTEIO;
 		if (ret != 0) {
 			printk(KERN_ERR "xc4000: setting registers failed\n");
-			return ret;
+			goto fail;
 		}
 	}
 
 	xc_tune_channel(priv, priv->freq_hz, XC_TUNE_ANALOG);
 
 	if (debug)
 		xc_debug_dump(priv);
+	ret = 0;
 
-	return 0;
+fail:
+	mutex_unlock(&priv->lock);
+
+	return ret;
 }
 
 static int xc4000_get_frequency(struct dvb_frontend *fe, u32 *freq)
 {
 	struct xc4000_priv *priv = fe->tuner_priv;
 
 	*freq = priv->freq_hz;
 
-	if (debug && (priv->cur_fw.type
-		      & (BASE | FM | DTV6 | DTV7 | DTV78 | DTV8)) == BASE) {
-		u16	snr = 0;
-		if (xc4000_readreg(priv, XREG_SNR, &snr) == 0) {
-			dprintk(1, "%s() freq = %u, SNR = %d\n",
-				__func__, *freq, snr);
-			return 0;
+	if (debug) {
+		mutex_lock(&priv->lock);
+		if ((priv->cur_fw.type
+		     & (BASE | FM | DTV6 | DTV7 | DTV78 | DTV8)) == BASE) {
+			u16	snr = 0;
+			if (xc4000_readreg(priv, XREG_SNR, &snr) == 0) {
+				mutex_unlock(&priv->lock);
+				dprintk(1, "%s() freq = %u, SNR = %d\n",
+					__func__, *freq, snr);
+				return 0;
+			}
 		}
+		mutex_unlock(&priv->lock);
 	}
+
 	dprintk(1, "%s()\n", __func__);
 
 	return 0;
 }
@@ -1546,58 +1522,57 @@
 {
 	struct xc4000_priv *priv = fe->tuner_priv;
 	u16	lock_status = 0;
 
-	xc_get_lock_status(priv, &lock_status);
+	mutex_lock(&priv->lock);
 
-	dprintk(2, "%s() lock_status = %d\n", __func__, lock_status);
+	if (priv->cur_fw.type & BASE)
+		xc_get_lock_status(priv, &lock_status);
 
 	*status = (lock_status == 1 ?
 		   TUNER_STATUS_LOCKED | TUNER_STATUS_STEREO : 0);
+	if (priv->cur_fw.type & (DTV6 | DTV7 | DTV78 | DTV8))
+		*status &= (~TUNER_STATUS_STEREO);
+
+	mutex_unlock(&priv->lock);
+
+	dprintk(2, "%s() lock_status = %d\n", __func__, lock_status);
 
 	return 0;
 }
 
 static int xc4000_sleep(struct dvb_frontend *fe)
 {
-	/* FIXME: djh disable this for now... */
-	return XC_RESULT_SUCCESS;
-#if 0
-	int ret;
+	struct xc4000_priv *priv = fe->tuner_priv;
+	int	ret = XC_RESULT_SUCCESS;
 
 	dprintk(1, "%s()\n", __func__);
 
+	mutex_lock(&priv->lock);
+
 	/* Avoid firmware reload on slow devices */
-	if (no_poweroff)
-		return 0;
+	if (!no_poweroff && priv->cur_fw.type != XC_POWERED_DOWN) {
+		/* force reset and firmware reload */
+		priv->cur_fw.type = XC_POWERED_DOWN;
 
-	/* According to Xceive technical support, the "powerdown" register
-	   was removed in newer versions of the firmware.  The "supported"
-	   way to sleep the tuner is to pull the reset pin low for 10ms */
-	ret = xc4000_TunerReset(fe);
-	if (ret != XC_RESULT_SUCCESS) {
-		printk(KERN_ERR
-			"xc4000: %s() unable to shutdown tuner\n",
-			__func__);
-		return -EREMOTEIO;
-	} else
-		return XC_RESULT_SUCCESS;
-#endif
+		if (xc_write_reg(priv, XREG_POWER_DOWN, 0)
+		    != XC_RESULT_SUCCESS) {
+			printk(KERN_ERR
+			       "xc4000: %s() unable to shutdown tuner\n",
+			       __func__);
+			ret = -EREMOTEIO;
+		}
+	}
+
+	mutex_unlock(&priv->lock);
+
+	return ret;
 }
 
 static int xc4000_init(struct dvb_frontend *fe)
 {
-	struct xc4000_priv *priv = fe->tuner_priv;
 	dprintk(1, "%s()\n", __func__);
 
-	if (check_firmware(fe, DTV8, 0, priv->if_khz) != XC_RESULT_SUCCESS) {
-		printk(KERN_ERR "xc4000: Unable to initialise tuner\n");
-		return -EREMOTEIO;
-	}
-
-	if (debug)
-		xc_debug_dump(priv);
-
 	return 0;
 }
 
 static int xc4000_release(struct dvb_frontend *fe)
@@ -1641,10 +1616,10 @@
 				   struct i2c_adapter *i2c,
 				   struct xc4000_config *cfg)
 {
 	struct xc4000_priv *priv = NULL;
-	int instance;
-	u16 id = 0;
+	int	instance;
+	u16	id = 0;
 
 	if (cfg->card_type != XC4000_CARD_GENERIC) {
 		if (cfg->card_type == XC4000_CARD_DTV2000H_PLUS) {
 			cfg->i2c_address = 0x61;
@@ -1671,8 +1646,9 @@
 		break;
 	case 1:
 		/* new tuner instance */
 		priv->bandwidth = BANDWIDTH_6_MHZ;
+		mutex_init(&priv->lock);
 		fe->tuner_priv = priv;
 		break;
 	default:
 		/* existing tuner instance */
@@ -1690,10 +1666,17 @@
 	/* Check if firmware has been loaded. It is possible that another
 	   instance of the driver has loaded the firmware.
 	 */
 
-	if (xc4000_readreg(priv, XREG_PRODUCT_ID, &id) != XC_RESULT_SUCCESS)
+	if (instance == 1) {
+		if (xc4000_readreg(priv, XREG_PRODUCT_ID, &id)
+		    != XC_RESULT_SUCCESS)
 			goto fail;
+	}
+	else {
+		id = ((priv->cur_fw.type & BASE) == 0 ?
+		      XC_PRODUCT_ID_FW_NOT_LOADED : XC_PRODUCT_ID_FW_LOADED);
+	}
 
 	switch (id) {
 	case XC_PRODUCT_ID_FW_LOADED:
 		printk(KERN_INFO
@@ -1720,12 +1703,8 @@
 
 	memcpy(&fe->ops.tuner_ops, &xc4000_tuner_ops,
 		sizeof(struct dvb_tuner_ops));
 
-	/* FIXME: For now, load the firmware at startup.  We will remove this
-	   before the code goes to production... */
-	check_firmware(fe, DTV8, 0, priv->if_khz);
-
 	return fe;
 fail:
 	mutex_unlock(&xc4000_list_mutex);
 

--------------040508040903080806040408--
