Return-path: <mchehab@pedra>
Received: from mail.juropnet.hu ([212.24.188.131]:38766 "EHLO mail.juropnet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754473Ab1FDPId (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 4 Jun 2011 11:08:33 -0400
Received: from [94.248.226.52]
	by mail.juropnet.hu with esmtps (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <istvan_v@mailbox.hu>)
	id 1QSsSj-00034L-Hz
	for linux-media@vger.kernel.org; Sat, 04 Jun 2011 17:08:31 +0200
Message-ID: <4DEA4A6D.8010607@mailbox.hu>
Date: Sat, 04 Jun 2011 17:08:29 +0200
From: "istvan_v@mailbox.hu" <istvan_v@mailbox.hu>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: XC4000: debug message improvements
References: <4D764337.6050109@email.cz>	<20110531124843.377a2a80@glory.local>	<BANLkTi=Lq+FF++yGhRmOa4NCigSt6ZurHg@mail.gmail.com>	<20110531174323.0f0c45c0@glory.local> <BANLkTimEEGsMP6PDXf5W5p9wW7wdWEEOiA@mail.gmail.com>
In-Reply-To: <BANLkTimEEGsMP6PDXf5W5p9wW7wdWEEOiA@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------010500030607030705050008"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a multi-part message in MIME format.
--------------010500030607030705050008
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

The following patch makes a few minor changes to the printing
of debug messages, and reporting the tuner status. The 'debug'
module parameter can now be set from 0 to 2 to control the
verbosity of debug messages.

Signed-off-by: Istvan Varga <istvan_v@mailbox.hu>


--------------010500030607030705050008
Content-Type: text/x-patch;
 name="xc4000_debug.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="xc4000_debug.patch"

diff -uNr xc4000_orig/drivers/media/common/tuners/xc4000.c xc4000/drivers/media/common/tuners/xc4000.c
--- xc4000_orig/drivers/media/common/tuners/xc4000.c	2011-06-04 14:13:47.000000000 +0200
+++ xc4000/drivers/media/common/tuners/xc4000.c	2011-06-04 14:44:49.000000000 +0200
@@ -39,7 +39,7 @@
 
 static int debug;
 module_param(debug, int, 0644);
-MODULE_PARM_DESC(debug, "Turn on/off debugging (default:off).");
+MODULE_PARM_DESC(debug, "\n\t\tDebugging level (0 to 2, default: 0 (off)).");
 
 static int no_poweroff;
 module_param(no_poweroff, int, 0644);
@@ -239,6 +239,7 @@
 
 static int xc4000_readreg(struct xc4000_priv *priv, u16 reg, u16 *val);
 static int xc4000_TunerReset(struct dvb_frontend *fe);
+static void xc_debug_dump(struct xc4000_priv *priv);
 
 static int xc_send_i2c_data(struct xc4000_priv *priv, u8 *buf, int len)
 {
@@ -515,6 +516,15 @@
 			found = 1;
 	}
 
+	/* Wait for stats to stabilize.
+	 * Frame Lines needs two frame times after initial lock
+	 * before it is valid.
+	 */
+	xc_wait(debug ? 100 : 10);
+
+	if (debug)
+		xc_debug_dump(priv);
+
 	return found;
 }
 
@@ -1085,12 +1095,6 @@
 	u8	hw_majorversion = 0, hw_minorversion = 0;
 	u8	fw_majorversion = 0, fw_minorversion = 0;
 
-	/* Wait for stats to stabilize.
-	 * Frame Lines needs two frame times after initial lock
-	 * before it is valid.
-	 */
-	xc_wait(100);
-
 	xc_get_ADC_Envelope(priv, &adc_envelope);
 	dprintk(1, "*** ADC envelope (0-1023) = %d\n", adc_envelope);
 
@@ -1103,16 +1107,18 @@
 
 	xc_get_version(priv, &hw_majorversion, &hw_minorversion,
 		       &fw_majorversion, &fw_minorversion);
-
 	dprintk(1, "*** HW: V%02x.%02x, FW: V%02x.%02x\n",
 		hw_majorversion, hw_minorversion,
 		fw_majorversion, fw_minorversion);
 
-	xc_get_hsync_freq(priv, &hsync_freq_hz);
-	dprintk(1, "*** Horizontal sync frequency = %d Hz\n", hsync_freq_hz);
+	if (priv->video_standard < XC4000_DTV6) {
+		xc_get_hsync_freq(priv, &hsync_freq_hz);
+		dprintk(1, "*** Horizontal sync frequency = %d Hz\n",
+			hsync_freq_hz);
 
-	xc_get_frame_lines(priv, &frame_lines);
-	dprintk(1, "*** Frame lines = %d\n", frame_lines);
+		xc_get_frame_lines(priv, &frame_lines);
+		dprintk(1, "*** Frame lines = %d\n", frame_lines);
+	}
 
 	xc_get_quality(priv, &quality);
 	dprintk(1, "*** Quality (0:<8dB, 7:>56dB) = %d\n", quality);
@@ -1223,9 +1229,6 @@
 	}
 	xc_tune_channel(priv, priv->freq_hz, XC_TUNE_DIGITAL);
 
-	if (debug)
-		xc_debug_dump(priv);
-
 	ret = 0;
 
 fail:
@@ -1320,9 +1323,6 @@
 
 	xc_tune_channel(priv, priv->freq_hz, XC_TUNE_ANALOG);
 
-	if (debug)
-		xc_debug_dump(priv);
-
 	ret = 0;
 
 fail:
@@ -1334,8 +1334,26 @@
 static int xc4000_get_frequency(struct dvb_frontend *fe, u32 *freq)
 {
 	struct xc4000_priv *priv = fe->tuner_priv;
-	dprintk(1, "%s()\n", __func__);
+
 	*freq = priv->freq_hz;
+
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
+		}
+		mutex_unlock(&priv->lock);
+	}
+
+	dprintk(1, "%s()\n", __func__);
+
 	return 0;
 }
 
@@ -1355,13 +1373,17 @@
 
 	mutex_lock(&priv->lock);
 
-	xc_get_lock_status(priv, &lock_status);
+	if (priv->cur_fw.type & BASE)
+		xc_get_lock_status(priv, &lock_status);
 
-	mutex_unlock(&priv->lock);
+	*status = (lock_status == 1 ?
+		   TUNER_STATUS_LOCKED | TUNER_STATUS_STEREO : 0);
+	if (priv->cur_fw.type & (DTV6 | DTV7 | DTV78 | DTV8))
+		*status &= (~TUNER_STATUS_STEREO);
 
-	dprintk(1, "%s() lock_status = 0x%08x\n", __func__, lock_status);
+	mutex_unlock(&priv->lock);
 
-	*status = lock_status;
+	dprintk(2, "%s() lock_status = %d\n", __func__, lock_status);
 
 	return 0;
 }

--------------010500030607030705050008--
