Return-path: <mchehab@pedra>
Received: from mail.juropnet.hu ([212.24.188.131]:40419 "EHLO mail.juropnet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754473Ab1FDPMq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 4 Jun 2011 11:12:46 -0400
Received: from [94.248.226.52]
	by mail.juropnet.hu with esmtps (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <istvan_v@mailbox.hu>)
	id 1QSsWo-0003L3-Pw
	for linux-media@vger.kernel.org; Sat, 04 Jun 2011 17:12:45 +0200
Message-ID: <4DEA4B6A.70602@mailbox.hu>
Date: Sat, 04 Jun 2011 17:12:42 +0200
From: "istvan_v@mailbox.hu" <istvan_v@mailbox.hu>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: XC4000: setting registers
References: <4D764337.6050109@email.cz>	<20110531124843.377a2a80@glory.local>	<BANLkTi=Lq+FF++yGhRmOa4NCigSt6ZurHg@mail.gmail.com>	<20110531174323.0f0c45c0@glory.local> <BANLkTimEEGsMP6PDXf5W5p9wW7wdWEEOiA@mail.gmail.com>
In-Reply-To: <BANLkTimEEGsMP6PDXf5W5p9wW7wdWEEOiA@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------010600050603060909060700"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a multi-part message in MIME format.
--------------010600050603060909060700
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

This patch implements setting the registers in xc4000_set_params()
and xc4000_set_analog_params(). A new register is defined which enables
filtering of the composite video output (this is needed to avoid bad
picture quality with some boards).

Signed-off-by: Istvan Varga <istvan_v@mailbox.hu>


--------------010600050603060909060700
Content-Type: text/x-patch;
 name="xc4000_registers.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="xc4000_registers.patch"

diff -uNr xc4000_orig/drivers/media/common/tuners/xc4000.c xc4000/drivers/media/common/tuners/xc4000.c
--- xc4000_orig/drivers/media/common/tuners/xc4000.c	2011-06-04 14:46:15.000000000 +0200
+++ xc4000/drivers/media/common/tuners/xc4000.c	2011-06-04 15:22:06.000000000 +0200
@@ -131,6 +131,7 @@
 #define XREG_SEEK_MODE    0x06
 #define XREG_POWER_DOWN   0x08
 #define XREG_SIGNALSOURCE 0x0A
+#define XREG_SMOOTHEDCVBS 0x0E
 #define XREG_AMPLITUDE    0x10
 
 /* Registers (Read-only) */
@@ -1218,15 +1219,35 @@
 		       "xc4000: xc_SetSignalSource(%d) failed\n",
 		       priv->rf_mode);
 		goto fail;
+	} else {
+		u16	video_mode, audio_mode;
+		video_mode = XC4000_Standard[priv->video_standard].VideoMode;
+		audio_mode = XC4000_Standard[priv->video_standard].AudioMode;
+		if (type == DTV6 && priv->firm_version != 0x0102)
+			video_mode |= 0x0001;
+		ret = xc_SetTVStandard(priv, video_mode, audio_mode);
+		if (ret != XC_RESULT_SUCCESS) {
+			printk(KERN_ERR "xc4000: xc_SetTVStandard failed\n");
+			/* DJH - do not return when it fails... */
+			/* goto fail; */
+		}
 	}
 
-	ret = xc_SetTVStandard(priv,
-		XC4000_Standard[priv->video_standard].VideoMode,
-		XC4000_Standard[priv->video_standard].AudioMode);
-	if (ret != XC_RESULT_SUCCESS) {
-		printk(KERN_ERR "xc4000: xc_SetTVStandard failed\n");
-		goto fail;
+	if (priv->card_type == XC4000_CARD_WINFAST_CX88) {
+		if (xc_write_reg(priv, XREG_D_CODE, 0) == 0)
+			ret = 0;
+		if (xc_write_reg(priv, XREG_AMPLITUDE,
+				 (priv->firm_version == 0x0102 ? 132 : 134))
+		    != 0)
+			ret = -EREMOTEIO;
+		if (xc_write_reg(priv, XREG_SMOOTHEDCVBS, 1) != 0)
+			ret = -EREMOTEIO;
+		if (ret != 0) {
+			printk(KERN_ERR "xc4000: setting registers failed\n");
+			/* goto fail; */
+		}
 	}
+
 	xc_tune_channel(priv, priv->freq_hz, XC_TUNE_DIGITAL);
 
 	ret = 0;
@@ -1311,14 +1332,36 @@
 		       "xc4000: xc_SetSignalSource(%d) failed\n",
 		       priv->rf_mode);
 		goto fail;
+	} else {
+		u16	video_mode, audio_mode;
+		video_mode = XC4000_Standard[priv->video_standard].VideoMode;
+		audio_mode = XC4000_Standard[priv->video_standard].AudioMode;
+		if (priv->video_standard < XC4000_BG_PAL_A2) {
+			if (type & NOGD)
+				video_mode &= 0xFF7F;
+		} else if (priv->video_standard < XC4000_I_PAL_NICAM) {
+			if (priv->card_type == XC4000_CARD_WINFAST_CX88 &&
+			    priv->firm_version == 0x0102)
+				video_mode &= 0xFEFF;
+		}
+		ret = xc_SetTVStandard(priv, video_mode, audio_mode);
+		if (ret != XC_RESULT_SUCCESS) {
+			printk(KERN_ERR "xc4000: xc_SetTVStandard failed\n");
+			goto fail;
+		}
 	}
 
-	ret = xc_SetTVStandard(priv,
-		XC4000_Standard[priv->video_standard].VideoMode,
-		XC4000_Standard[priv->video_standard].AudioMode);
-	if (ret != XC_RESULT_SUCCESS) {
-		printk(KERN_ERR "xc4000: xc_SetTVStandard failed\n");
-		goto fail;
+	if (priv->card_type == XC4000_CARD_WINFAST_CX88) {
+		if (xc_write_reg(priv, XREG_D_CODE, 0) == 0)
+			ret = 0;
+		if (xc_write_reg(priv, XREG_AMPLITUDE, 1) != 0)
+			ret = -EREMOTEIO;
+		if (xc_write_reg(priv, XREG_SMOOTHEDCVBS, 1) != 0)
+			ret = -EREMOTEIO;
+		if (ret != 0) {
+			printk(KERN_ERR "xc4000: setting registers failed\n");
+			goto fail;
+		}
 	}
 
 	xc_tune_channel(priv, priv->freq_hz, XC_TUNE_ANALOG);

--------------010600050603060909060700--
