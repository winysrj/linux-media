Return-path: <mchehab@pedra>
Received: from mail.juropnet.hu ([212.24.188.131]:36336 "EHLO mail.juropnet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755898Ab1FFPzW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Jun 2011 11:55:22 -0400
Received: from [94.248.228.122] (helo=linux-mrjj.localnet)
	by mail.juropnet.hu with esmtps (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <istvan_v@mailbox.hu>)
	id 1QTc91-0004YR-2h
	for linux-media@vger.kernel.org; Mon, 06 Jun 2011 17:55:19 +0200
From: Istvan Varga <istvan_v@mailbox.hu>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/4] XC4000: code cleanup
MIME-Version: 1.0
Date: Mon, 6 Jun 2011 17:54:54 +0200
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201106061754.54992.istvan_v@mailbox.hu>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Various coding style changes:
  - removed unused / commented out code
  - changed C++ style comments to C format
  - renamed functions and variables that included upper case letters in the name
  - removed tabs from module parameter descriptions
  - replaced the use of XC_RESULT_* with standard error codes

Signed-off-by: Istvan Varga <istvan_v@mailbox.hu>

diff -uNr xc4000_orig/drivers/media/common/tuners/xc4000.c xc4000/drivers/media/common/tuners/xc4000.c
--- xc4000_orig/drivers/media/common/tuners/xc4000.c	2011-06-06 14:10:12.000000000 +0200
+++ xc4000/drivers/media/common/tuners/xc4000.c	2011-06-06 14:37:35.000000000 +0200
@@ -5,6 +5,7 @@
  *  Copyright (c) 2007 Steven Toth <stoth@linuxtv.org>
  *  Copyright (c) 2009 Devin Heitmueller <dheitmueller@kernellabs.com>
  *  Copyright (c) 2009 Davide Ferri <d.ferri@zero11.it>
+ *  Copyright (c) 2010 Istvan Varga <istvan_v@mailbox.hu>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -14,7 +15,6 @@
  *  This program is distributed in the hope that it will be useful,
  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *
  *  GNU General Public License for more details.
  *
  *  You should have received a copy of the GNU General Public License
@@ -39,44 +39,29 @@
 
 static int debug;
 module_param(debug, int, 0644);
-MODULE_PARM_DESC(debug, "\n\t\tDebugging level (0 to 2, default: 0 (off)).");
+MODULE_PARM_DESC(debug, "Debugging level (0 to 2, default: 0 (off)).");
 
 static int no_poweroff;
 module_param(no_poweroff, int, 0644);
-MODULE_PARM_DESC(no_poweroff, "\n\t\t1: keep device energized and with tuner "
-	"ready all the times.\n"
-	"\t\tFaster, but consumes more power and keeps the device hotter.\n"
-	"\t\t2: powers device off when not used.\n"
-	"\t\t0 (default): use device-specific default mode.");
-
-#define XC4000_AUDIO_STD_B		 1
-#define XC4000_AUDIO_STD_A2		 2
-#define XC4000_AUDIO_STD_K3		 4
-#define XC4000_AUDIO_STD_L		 8
-#define XC4000_AUDIO_STD_INPUT1		16
-#define XC4000_AUDIO_STD_MONO		32
+MODULE_PARM_DESC(no_poweroff, "Power management (1: disabled, 2: enabled, "
+	"0 (default): use device-specific default mode).");
 
 static int audio_std;
 module_param(audio_std, int, 0644);
-MODULE_PARM_DESC(audio_std, "\n\t\tAudio standard. XC4000 audio decoder "
-	"explicitly needs to know\n"
-	"\t\twhat audio standard is needed for some video standards with\n"
-	"\t\taudio A2 or NICAM.\n"
-	"\t\tThe valid settings are a sum of:\n"
-	"\t\t 1: use NICAM/B or A2/B instead of NICAM/A or A2/A\n"
-	"\t\t 2: use A2 instead of NICAM or BTSC\n"
-	"\t\t 4: use SECAM/K3 instead of K1\n"
-	"\t\t 8: use PAL-D/K audio for SECAM-D/K\n"
-	"\t\t16: use FM radio input 1 instead of input 2\n"
-	"\t\t32: use mono audio (the lower three bits are ignored)");
-
-#define XC4000_DEFAULT_FIRMWARE "xc4000.fw"
+MODULE_PARM_DESC(audio_std, "Audio standard. XC4000 audio decoder explicitly "
+	"needs to know what audio standard is needed for some video standards "
+	"with audio A2 or NICAM. The valid settings are a sum of:\n"
+	" 1: use NICAM/B or A2/B instead of NICAM/A or A2/A\n"
+	" 2: use A2 instead of NICAM or BTSC\n"
+	" 4: use SECAM/K3 instead of K1\n"
+	" 8: use PAL-D/K audio for SECAM-D/K\n"
+	"16: use FM radio input 1 instead of input 2\n"
+	"32: use mono audio (the lower three bits are ignored)");
 
 static char firmware_name[30];
 module_param_string(firmware_name, firmware_name, sizeof(firmware_name), 0);
-MODULE_PARM_DESC(firmware_name, "\n\t\tFirmware file name. Allows overriding "
-	"the default firmware\n"
-	"\t\tname.");
+MODULE_PARM_DESC(firmware_name, "Firmware file name. Allows overriding the "
+	"default firmware name.");
 
 static DEFINE_MUTEX(xc4000_list_mutex);
 static LIST_HEAD(hybrid_tuner_instance_list);
@@ -115,13 +100,21 @@
 	u8	rf_mode;
 	u8	card_type;
 	u8	ignore_i2c_write_errors;
- /*	struct xc2028_ctrl	ctrl; */
 	struct firmware_properties cur_fw;
 	__u16	hwmodel;
 	__u16	hwvers;
 	struct mutex	lock;
 };
 
+#define XC4000_AUDIO_STD_B		 1
+#define XC4000_AUDIO_STD_A2		 2
+#define XC4000_AUDIO_STD_K3		 4
+#define XC4000_AUDIO_STD_L		 8
+#define XC4000_AUDIO_STD_INPUT1		16
+#define XC4000_AUDIO_STD_MONO		32
+
+#define XC4000_DEFAULT_FIRMWARE "dvb-fe-xc4000-1.4.fw"
+
 /* Misc Defines */
 #define MAX_TV_STANDARD			24
 #define XC_MAX_I2C_WRITE_LENGTH		64
@@ -131,13 +124,6 @@
 #define XC_RF_MODE_AIR			0
 #define XC_RF_MODE_CABLE		1
 
-/* Result codes */
-#define XC_RESULT_SUCCESS		0
-#define XC_RESULT_RESET_FAILURE		1
-#define XC_RESULT_I2C_WRITE_FAILURE	2
-#define XC_RESULT_I2C_READ_FAILURE	3
-#define XC_RESULT_OUT_OF_RANGE		5
-
 /* Product id */
 #define XC_PRODUCT_ID_FW_NOT_LOADED	0x2000
 #define XC_PRODUCT_ID_XC4000		0x0FA0
@@ -202,8 +188,8 @@
 
 struct XC_TV_STANDARD {
 	const char  *Name;
-	u16	    AudioMode;
-	u16	    VideoMode;
+	u16	    audio_mode;
+	u16	    video_mode;
 	u16	    int_freq;
 };
 
@@ -233,7 +219,7 @@
 #define XC4000_FM_Radio_INPUT2		22
 #define XC4000_FM_Radio_INPUT1		23
 
-static struct XC_TV_STANDARD XC4000_Standard[MAX_TV_STANDARD] = {
+static struct XC_TV_STANDARD xc4000_standard[MAX_TV_STANDARD] = {
 	{"M/N-NTSC/PAL-BTSC",	0x0000, 0x80A0, 4500},
 	{"M/N-NTSC/PAL-A2",	0x0000, 0x80A0, 4600},
 	{"M/N-NTSC/PAL-EIAJ",	0x0040, 0x80A0, 4500},
@@ -261,7 +247,7 @@
 };
 
 static int xc4000_readreg(struct xc4000_priv *priv, u16 reg, u16 *val);
-static int xc4000_TunerReset(struct dvb_frontend *fe);
+static int xc4000_tuner_reset(struct dvb_frontend *fe);
 static void xc_debug_dump(struct xc4000_priv *priv);
 
 static int xc_send_i2c_data(struct xc4000_priv *priv, u8 *buf, int len)
@@ -276,18 +262,13 @@
 				printk("bytes %02x %02x %02x %02x\n", buf[0],
 				       buf[1], buf[2], buf[3]);
 			}
-			return XC_RESULT_I2C_WRITE_FAILURE;
+			return -EREMOTEIO;
 		}
 	}
-	return XC_RESULT_SUCCESS;
-}
-
-static void xc_wait(int wait_ms)
-{
-	msleep(wait_ms);
+	return 0;
 }
 
-static int xc4000_TunerReset(struct dvb_frontend *fe)
+static int xc4000_tuner_reset(struct dvb_frontend *fe)
 {
 	struct xc4000_priv *priv = fe->tuner_priv;
 	int ret;
@@ -302,13 +283,14 @@
 					   XC4000_TUNER_RESET, 0);
 		if (ret) {
 			printk(KERN_ERR "xc4000: reset failed\n");
-			return XC_RESULT_RESET_FAILURE;
+			return -EREMOTEIO;
 		}
 	} else {
-		printk(KERN_ERR "xc4000: no tuner reset callback function, fatal\n");
-		return XC_RESULT_RESET_FAILURE;
+		printk(KERN_ERR "xc4000: no tuner reset callback function, "
+				"fatal\n");
+		return -EINVAL;
 	}
-	return XC_RESULT_SUCCESS;
+	return 0;
 }
 
 static int xc_write_reg(struct xc4000_priv *priv, u16 regAddr, u16 i2cData)
@@ -339,15 +321,12 @@
 		len = i2c_sequence[index] * 256 + i2c_sequence[index+1];
 		if (len == 0x0000) {
 			/* RESET command */
+			/* NOTE: this is ignored, as the reset callback was */
+			/* already called by check_firmware() */
 			index += 2;
-#if 0			/* not needed, as already called by check_firmware() */
-			result = xc4000_TunerReset(fe);
-			if (result != XC_RESULT_SUCCESS)
-				return result;
-#endif
 		} else if (len & 0x8000) {
 			/* WAIT command */
-			xc_wait(len & 0x7FFF);
+			msleep(len & 0x7FFF);
 			index += 2;
 		} else {
 			/* Send i2c data whilst ensuring individual transactions
@@ -370,7 +349,7 @@
 				result = xc_send_i2c_data(priv, buf,
 					nbytes_to_send);
 
-				if (result != XC_RESULT_SUCCESS)
+				if (result != 0)
 					return result;
 
 				pos += nbytes_to_send - 2;
@@ -378,31 +357,31 @@
 			index += len;
 		}
 	}
-	return XC_RESULT_SUCCESS;
+	return 0;
 }
 
-static int xc_SetTVStandard(struct xc4000_priv *priv,
-	u16 VideoMode, u16 AudioMode)
+static int xc_set_tv_standard(struct xc4000_priv *priv,
+	u16 video_mode, u16 audio_mode)
 {
 	int ret;
-	dprintk(1, "%s(0x%04x,0x%04x)\n", __func__, VideoMode, AudioMode);
+	dprintk(1, "%s(0x%04x,0x%04x)\n", __func__, video_mode, audio_mode);
 	dprintk(1, "%s() Standard = %s\n",
 		__func__,
-		XC4000_Standard[priv->video_standard].Name);
+		xc4000_standard[priv->video_standard].Name);
 
 	/* Don't complain when the request fails because of i2c stretching */
 	priv->ignore_i2c_write_errors = 1;
 
-	ret = xc_write_reg(priv, XREG_VIDEO_MODE, VideoMode);
-	if (ret == XC_RESULT_SUCCESS)
-		ret = xc_write_reg(priv, XREG_AUDIO_MODE, AudioMode);
+	ret = xc_write_reg(priv, XREG_VIDEO_MODE, video_mode);
+	if (ret == 0)
+		ret = xc_write_reg(priv, XREG_AUDIO_MODE, audio_mode);
 
 	priv->ignore_i2c_write_errors = 0;
 
 	return ret;
 }
 
-static int xc_SetSignalSource(struct xc4000_priv *priv, u16 rf_mode)
+static int xc_set_signal_source(struct xc4000_priv *priv, u16 rf_mode)
 {
 	dprintk(1, "%s(%d) Source = %s\n", __func__, rf_mode,
 		rf_mode == XC_RF_MODE_AIR ? "ANTENNA" : "CABLE");
@@ -418,25 +397,26 @@
 
 static const struct dvb_tuner_ops xc4000_tuner_ops;
 
-static int xc_set_RF_frequency(struct xc4000_priv *priv, u32 freq_hz)
+static int xc_set_rf_frequency(struct xc4000_priv *priv, u32 freq_hz)
 {
 	u16 freq_code;
 
 	dprintk(1, "%s(%u)\n", __func__, freq_hz);
 
 	if ((freq_hz > xc4000_tuner_ops.info.frequency_max) ||
-		(freq_hz < xc4000_tuner_ops.info.frequency_min))
-		return XC_RESULT_OUT_OF_RANGE;
+	    (freq_hz < xc4000_tuner_ops.info.frequency_min))
+		return -EINVAL;
 
 	freq_code = (u16)(freq_hz / 15625);
 
 	/* WAS: Starting in firmware version 1.1.44, Xceive recommends using the
 	   FINERFREQ for all normal tuning (the doc indicates reg 0x03 should
 	   only be used for fast scanning for channel lock) */
-	return xc_write_reg(priv, XREG_RF_FREQ, freq_code); /* WAS: XREG_FINERFREQ */
+	/* WAS: XREG_FINERFREQ */
+	return xc_write_reg(priv, XREG_RF_FREQ, freq_code);
 }
 
-static int xc_get_ADC_Envelope(struct xc4000_priv *priv, u16 *adc_envelope)
+static int xc_get_adc_envelope(struct xc4000_priv *priv, u16 *adc_envelope)
 {
 	return xc4000_readreg(priv, XREG_ADC_ENV, adc_envelope);
 }
@@ -448,7 +428,7 @@
 	u32 tmp;
 
 	result = xc4000_readreg(priv, XREG_FREQ_ERROR, &regData);
-	if (result != XC_RESULT_SUCCESS)
+	if (result != 0)
 		return result;
 
 	tmp = (u32)regData & 0xFFFFU;
@@ -470,7 +450,7 @@
 	int result;
 
 	result = xc4000_readreg(priv, XREG_VERSION, &data);
-	if (result != XC_RESULT_SUCCESS)
+	if (result != 0)
 		return result;
 
 	(*hw_majorversion) = (data >> 12) & 0x0F;
@@ -487,7 +467,7 @@
 	int result;
 
 	result = xc4000_readreg(priv, XREG_HSYNC_FREQ, &regData);
-	if (result != XC_RESULT_SUCCESS)
+	if (result != 0)
 		return result;
 
 	(*hsync_freq_hz) = ((regData & 0x0fff) * 763)/100;
@@ -504,19 +484,19 @@
 	return xc4000_readreg(priv, XREG_QUALITY, quality);
 }
 
-static u16 WaitForLock(struct xc4000_priv *priv)
+static u16 xc_wait_for_lock(struct xc4000_priv *priv)
 {
-	u16 lockState = 0;
-	int watchDogCount = 40;
+	u16	lock_state = 0;
+	int	watchdog_count = 40;
 
-	while ((lockState == 0) && (watchDogCount > 0)) {
-		xc_get_lock_status(priv, &lockState);
-		if (lockState != 1) {
-			xc_wait(5);
-			watchDogCount--;
+	while ((lock_state == 0) && (watchdog_count > 0)) {
+		xc_get_lock_status(priv, &lock_state);
+		if (lock_state != 1) {
+			msleep(5);
+			watchdog_count--;
 		}
 	}
-	return lockState;
+	return lock_state;
 }
 
 static int xc_tune_channel(struct xc4000_priv *priv, u32 freq_hz)
@@ -528,15 +508,15 @@
 
 	/* Don't complain when the request fails because of i2c stretching */
 	priv->ignore_i2c_write_errors = 1;
-	result = xc_set_RF_frequency(priv, freq_hz);
+	result = xc_set_rf_frequency(priv, freq_hz);
 	priv->ignore_i2c_write_errors = 0;
 
-	if (result != XC_RESULT_SUCCESS)
+	if (result != 0)
 		return 0;
 
 	/* wait for lock only in analog TV mode */
 	if ((priv->cur_fw.type & (FM | DTV6 | DTV7 | DTV78 | DTV8)) == 0) {
-		if (WaitForLock(priv) != 1)
+		if (xc_wait_for_lock(priv) != 1)
 			found = 0;
 	}
 
@@ -544,7 +524,7 @@
 	 * Frame Lines needs two frame times after initial lock
 	 * before it is valid.
 	 */
-	xc_wait(debug ? 100 : 10);
+	msleep(debug ? 100 : 10);
 
 	if (debug)
 		xc_debug_dump(priv);
@@ -569,7 +549,7 @@
 	}
 
 	*val = (bval[0] << 8) | bval[1];
-	return XC_RESULT_SUCCESS;
+	return 0;
 }
 
 #define dump_firm_type(t)	dump_firm_type_and_int_freq(t, 0)
@@ -647,7 +627,7 @@
 	unsigned int	best_nr_diffs = 255U;
 
 	if (!priv->firm) {
-		printk("Error! firmware not loaded\n");
+		printk(KERN_ERR "Error! firmware not loaded\n");
 		return -EINVAL;
 	}
 
@@ -685,8 +665,8 @@
 
 	if (best_nr_diffs > 0U) {
 		printk("Selecting best matching firmware (%u bits differ) for "
-		       "type=", best_nr_diffs);
-		printk("(%x), id %016llx:\n", type, (unsigned long long)*id);
+		       "type=(%x), id %016llx:\n",
+		       best_nr_diffs, type, (unsigned long long)*id);
 		i = best_i;
 	}
 
@@ -695,8 +675,8 @@
 
 ret:
 	if (debug) {
-		printk("%s firmware for type=", (i < 0) ? "Can't find" :
-		       "Found");
+		printk("%s firmware for type=",
+		       (i < 0) ? "Can't find" : "Found");
 		dump_firm_type(type);
 		printk("(%x), id %016llx.\n", type, (unsigned long long)*id);
 	}
@@ -745,11 +725,10 @@
 	rc = request_firmware(&fw, fname, priv->i2c_props.adap->dev.parent);
 	if (rc < 0) {
 		if (rc == -ENOENT)
-			printk("Error: firmware %s not found.\n",
-				   fname);
+			printk("Error: firmware %s not found.\n", fname);
 		else
 			printk("Error %d while requesting firmware %s \n",
-				   rc, fname);
+			       rc, fname);
 
 		return rc;
 	}
@@ -757,13 +736,12 @@
 	endp = p + fw->size;
 
 	if (fw->size < sizeof(name) - 1 + 2 + 2) {
-		printk("Error: firmware file %s has invalid size!\n",
-		       fname);
+		printk("Error: firmware file %s has invalid size!\n", fname);
 		goto corrupt;
 	}
 
 	memcpy(name, p, sizeof(name) - 1);
-	name[sizeof(name) - 1] = 0;
+	name[sizeof(name) - 1] = '\0';
 	p += sizeof(name) - 1;
 
 	priv->firm_version = get_unaligned_le16(p);
@@ -920,7 +898,7 @@
 	}
 
 	rc = xc_send_i2c_data(priv, scode_buf, 13);
-	if (rc != XC_RESULT_SUCCESS) {
+	if (rc != 0) {
 		/* Even if the send failed, make sure we set back to indirect
 		   mode */
 		printk("Failed to set scode %d\n", rc);
@@ -953,16 +931,11 @@
 			return rc;
 	}
 
-#ifdef DJH_DEBUG
-	if (priv->ctrl.mts && !(type & FM))
-		type |= MTS;
-#endif
-
 retry:
 	new_fw.type = type;
 	new_fw.id = std;
 	new_fw.std_req = std;
-	new_fw.scode_table = SCODE /* | priv->ctrl.scode_table */;
+	new_fw.scode_table = SCODE;
 	new_fw.scode_nr = 0;
 	new_fw.int_freq = int_freq;
 
@@ -971,15 +944,11 @@
 		dump_firm_type(new_fw.type);
 		printk("(%x), id %016llx, ", new_fw.type,
 		       (unsigned long long)new_fw.std_req);
-		if (!int_freq) {
-			printk("scode_tbl ");
-#ifdef DJH_DEBUG
-			dump_firm_type(priv->ctrl.scode_table);
-			printk("(%x), ", priv->ctrl.scode_table);
-#endif
-		} else
-			printk("int_freq %d, ", new_fw.int_freq);
-		printk("scode_nr %d\n", new_fw.scode_nr);
+		if (!int_freq)
+			printk(KERN_CONT "scode_tbl ");
+		else
+			printk(KERN_CONT "int_freq %d, ", new_fw.int_freq);
+		printk(KERN_CONT "scode_nr %d\n", new_fw.scode_nr);
 	}
 
 	/* No need to reload base firmware if it matches */
@@ -992,7 +961,7 @@
 	memset(&priv->cur_fw, 0, sizeof(priv->cur_fw));
 
 	/* Reset is needed before loading firmware */
-	rc = xc4000_TunerReset(fe);
+	rc = xc4000_tuner_reset(fe);
 	if (rc < 0)
 		goto fail;
 
@@ -1046,14 +1015,14 @@
 	/* Load SCODE firmware, if exists */
 	rc = load_scode(fe, new_fw.type | new_fw.scode_table, &new_fw.id,
 			new_fw.int_freq, new_fw.scode_nr);
-	if (rc != XC_RESULT_SUCCESS)
+	if (rc != 0)
 		dprintk(1, "load scode failed %d\n", rc);
 
 check_device:
 	rc = xc4000_readreg(priv, XREG_PRODUCT_ID, &hwmodel);
 
 	if (xc_get_version(priv, &hw_major, &hw_minor, &fw_major,
-			   &fw_minor) != XC_RESULT_SUCCESS) {
+			   &fw_minor) != 0) {
 		printk("Unable to read tuner registers.\n");
 		goto fail;
 	}
@@ -1121,7 +1090,7 @@
 	u8	hw_majorversion = 0, hw_minorversion = 0;
 	u8	fw_majorversion = 0, fw_minorversion = 0;
 
-	xc_get_ADC_Envelope(priv, &adc_envelope);
+	xc_get_adc_envelope(priv, &adc_envelope);
 	dprintk(1, "*** ADC envelope (0-1023) = %d\n", adc_envelope);
 
 	xc_get_frequency_error(priv, &freq_error_hz);
@@ -1235,24 +1204,23 @@
 		__func__, priv->freq_hz);
 
 	/* Make sure the correct firmware type is loaded */
-	if (check_firmware(fe, type, 0, priv->if_khz) != XC_RESULT_SUCCESS)
+	if (check_firmware(fe, type, 0, priv->if_khz) != 0)
 		goto fail;
 
-	ret = xc_SetSignalSource(priv, priv->rf_mode);
-	if (ret != XC_RESULT_SUCCESS) {
-		printk(KERN_ERR
-		       "xc4000: xc_SetSignalSource(%d) failed\n",
+	ret = xc_set_signal_source(priv, priv->rf_mode);
+	if (ret != 0) {
+		printk(KERN_ERR "xc4000: xc_set_signal_source(%d) failed\n",
 		       priv->rf_mode);
 		goto fail;
 	} else {
 		u16	video_mode, audio_mode;
-		video_mode = XC4000_Standard[priv->video_standard].VideoMode;
-		audio_mode = XC4000_Standard[priv->video_standard].AudioMode;
+		video_mode = xc4000_standard[priv->video_standard].video_mode;
+		audio_mode = xc4000_standard[priv->video_standard].audio_mode;
 		if (type == DTV6 && priv->firm_version != 0x0102)
 			video_mode |= 0x0001;
-		ret = xc_SetTVStandard(priv, video_mode, audio_mode);
-		if (ret != XC_RESULT_SUCCESS) {
-			printk(KERN_ERR "xc4000: xc_SetTVStandard failed\n");
+		ret = xc_set_tv_standard(priv, video_mode, audio_mode);
+		if (ret != 0) {
+			printk(KERN_ERR "xc4000: xc_set_tv_standard failed\n");
 			/* DJH - do not return when it fails... */
 			/* goto fail; */
 		}
@@ -1423,27 +1391,25 @@
 	}
 
 tune_channel:
-	/* Fix me: it could be air. */
+	/* FIXME: it could be air. */
 	priv->rf_mode = XC_RF_MODE_CABLE;
 
 	if (check_firmware(fe, type, params->std,
-			   XC4000_Standard[priv->video_standard].int_freq)
-	    != XC_RESULT_SUCCESS) {
+			   xc4000_standard[priv->video_standard].int_freq) != 0)
 		goto fail;
-	}
 
-	ret = xc_SetSignalSource(priv, priv->rf_mode);
-	if (ret != XC_RESULT_SUCCESS) {
+	ret = xc_set_signal_source(priv, priv->rf_mode);
+	if (ret != 0) {
 		printk(KERN_ERR
-		       "xc4000: xc_SetSignalSource(%d) failed\n",
+		       "xc4000: xc_set_signal_source(%d) failed\n",
 		       priv->rf_mode);
 		goto fail;
 	} else {
 		u16	video_mode, audio_mode;
-		video_mode = XC4000_Standard[priv->video_standard].VideoMode;
-		audio_mode = XC4000_Standard[priv->video_standard].AudioMode;
+		video_mode = xc4000_standard[priv->video_standard].video_mode;
+		audio_mode = xc4000_standard[priv->video_standard].audio_mode;
 		if (priv->video_standard < XC4000_BG_PAL_A2) {
-			if (0 /*type & NOGD*/)
+			if (type & NOGD)
 				video_mode &= 0xFF7F;
 		} else if (priv->video_standard < XC4000_I_PAL_NICAM) {
 			if (priv->card_type == XC4000_CARD_WINFAST_CX88 &&
@@ -1452,9 +1418,9 @@
 			if (audio_std & XC4000_AUDIO_STD_B)
 				video_mode |= 0x0080;
 		}
-		ret = xc_SetTVStandard(priv, video_mode, audio_mode);
-		if (ret != XC_RESULT_SUCCESS) {
-			printk(KERN_ERR "xc4000: xc_SetTVStandard failed\n");
+		ret = xc_set_tv_standard(priv, video_mode, audio_mode);
+		if (ret != 0) {
+			printk(KERN_ERR "xc4000: xc_set_tv_standard failed\n");
 			goto fail;
 		}
 	}
@@ -1542,7 +1508,7 @@
 static int xc4000_sleep(struct dvb_frontend *fe)
 {
 	struct xc4000_priv *priv = fe->tuner_priv;
-	int	ret = XC_RESULT_SUCCESS;
+	int	ret = 0;
 
 	dprintk(1, "%s()\n", __func__);
 
@@ -1556,14 +1522,13 @@
 		/* force reset and firmware reload */
 		priv->cur_fw.type = XC_POWERED_DOWN;
 
-		if (xc_write_reg(priv, XREG_POWER_DOWN, 0)
-		    != XC_RESULT_SUCCESS) {
+		if (xc_write_reg(priv, XREG_POWER_DOWN, 0) != 0) {
 			printk(KERN_ERR
 			       "xc4000: %s() unable to shutdown tuner\n",
 			       __func__);
 			ret = -EREMOTEIO;
 		}
-		xc_wait(20);
+		msleep(20);
 	}
 
 	mutex_unlock(&priv->lock);
@@ -1672,8 +1637,7 @@
 	 */
 
 	if (instance == 1) {
-		if (xc4000_readreg(priv, XREG_PRODUCT_ID, &id)
-		    != XC_RESULT_SUCCESS)
+		if (xc4000_readreg(priv, XREG_PRODUCT_ID, &id) != 0)
 			goto fail;
 	} else {
 		id = ((priv->cur_fw.type & BASE) != 0 ?
@@ -1713,7 +1677,7 @@
 		mutex_lock(&priv->lock);
 		ret = xc4000_fwupload(fe);
 		mutex_unlock(&priv->lock);
-		if (ret != XC_RESULT_SUCCESS)
+		if (ret != 0)
 			goto fail2;
 	}
 
diff -uNr xc4000_orig/drivers/media/dvb/dvb-usb/dib0700_devices.c xc4000/drivers/media/dvb/dvb-usb/dib0700_devices.c
--- xc4000_orig/drivers/media/dvb/dvb-usb/dib0700_devices.c	2011-06-06 14:10:12.000000000 +0200
+++ xc4000/drivers/media/dvb/dvb-usb/dib0700_devices.c	2011-06-06 14:39:45.000000000 +0200
@@ -2706,13 +2706,14 @@
 };
 
 static struct dibx000_bandwidth_config stk7700p_xc4000_pll_config = {
-	60000, 30000, // internal, sampling
-	1, 8, 3, 1, 0, // pll_cfg: prediv, ratio, range, reset, bypass
-	0, 0, 1, 1, 0, // misc: refdiv, bypclk_div, IO_CLK_en_core, ADClkSrc, modulo
-	(3 << 14) | (1 << 12) | (524 << 0), // sad_cfg: refsel, sel, freq_15k
-	39370534, // ifreq
-	20452225, // timf
-	30000000, // xtal
+	60000, 30000,	/* internal, sampling */
+	1, 8, 3, 1, 0,	/* pll_cfg: prediv, ratio, range, reset, bypass */
+	0, 0, 1, 1, 0,	/* misc: refdiv, bypclk_div, IO_CLK_en_core, */
+			/* ADClkSrc, modulo */
+	(3 << 14) | (1 << 12) | 524,	/* sad_cfg: refsel, sel, freq_15k */
+	39370534,	/* ifreq */
+	20452225,	/* timf */
+	30000000	/* xtal */
 };
 
 /* FIXME: none of these inputs are validated yet */
