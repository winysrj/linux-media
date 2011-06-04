Return-path: <mchehab@pedra>
Received: from mail.juropnet.hu ([212.24.188.131]:45915 "EHLO mail.juropnet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462Ab1FDPR1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 4 Jun 2011 11:17:27 -0400
Received: from [94.248.226.52]
	by mail.juropnet.hu with esmtps (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <istvan_v@mailbox.hu>)
	id 1QSsbL-0003oe-BX
	for linux-media@vger.kernel.org; Sat, 04 Jun 2011 17:17:26 +0200
Message-ID: <4DEA4C82.60309@mailbox.hu>
Date: Sat, 04 Jun 2011 17:17:22 +0200
From: "istvan_v@mailbox.hu" <istvan_v@mailbox.hu>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: XC4000: implemented analog TV and radio
References: <4D764337.6050109@email.cz>	<20110531124843.377a2a80@glory.local>	<BANLkTi=Lq+FF++yGhRmOa4NCigSt6ZurHg@mail.gmail.com>	<20110531174323.0f0c45c0@glory.local> <BANLkTimEEGsMP6PDXf5W5p9wW7wdWEEOiA@mail.gmail.com>
In-Reply-To: <BANLkTimEEGsMP6PDXf5W5p9wW7wdWEEOiA@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------020800050908060606070003"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a multi-part message in MIME format.
--------------020800050908060606070003
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

The following patch implements support for analog TV and FM radio.

Signed-off-by: Istvan Varga <istvan_v@mailbox.hu>


--------------020800050908060606070003
Content-Type: text/x-patch;
 name="xc4000_analog.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="xc4000_analog.patch"

diff -uNr xc4000_orig/drivers/media/common/tuners/xc4000.c xc4000/drivers/media/common/tuners/xc4000.c
--- xc4000_orig/drivers/media/common/tuners/xc4000.c	2011-06-04 15:40:26.000000000 +0200
+++ xc4000/drivers/media/common/tuners/xc4000.c	2011-06-04 16:19:36.000000000 +0200
@@ -1283,69 +1283,150 @@
 	struct analog_parameters *params)
 {
 	struct xc4000_priv *priv = fe->tuner_priv;
+	unsigned int type = 0;
 	int	ret = -EREMOTEIO;
 
+	if (params->mode == V4L2_TUNER_RADIO) {
+		dprintk(1, "%s() frequency=%d (in units of 62.5Hz)\n",
+			__func__, params->frequency);
+
+		mutex_lock(&priv->lock);
+
+		params->std = 0;
+		priv->freq_hz = params->frequency * 125L / 2;
+
+		if (audio_std & XC4000_AUDIO_STD_INPUT1) {
+			priv->video_standard = XC4000_FM_Radio_INPUT1;
+			type = FM | INPUT1;
+		} else {
+			priv->video_standard = XC4000_FM_Radio_INPUT2;
+			type = FM | INPUT2;
+		}
+
+		goto tune_channel;
+	}
+
 	dprintk(1, "%s() frequency=%d (in units of 62.5khz)\n",
 		__func__, params->frequency);
 
 	mutex_lock(&priv->lock);
 
-	/* Fix me: it could be air. */
-	priv->rf_mode = params->mode;
-	if (params->mode > XC_RF_MODE_CABLE)
-		priv->rf_mode = XC_RF_MODE_CABLE;
-
 	/* params->frequency is in units of 62.5khz */
 	priv->freq_hz = params->frequency * 62500;
 
-	/* FIX ME: Some video standards may have several possible audio
-		   standards. We simply default to one of them here.
-	 */
+	params->std &= V4L2_STD_ALL;
+	/* if std is not defined, choose one */
+	if (!params->std)
+		params->std = V4L2_STD_PAL_BG;
+
+	if (audio_std & XC4000_AUDIO_STD_MONO)
+		type = MONO;
+
 	if (params->std & V4L2_STD_MN) {
-		/* default to BTSC audio standard */
-		priv->video_standard = XC4000_MN_NTSC_PAL_BTSC;
+		params->std = V4L2_STD_MN;
+		if (audio_std & XC4000_AUDIO_STD_MONO) {
+			priv->video_standard = XC4000_MN_NTSC_PAL_Mono;
+		} else if (audio_std & XC4000_AUDIO_STD_A2) {
+			params->std |= V4L2_STD_A2;
+			priv->video_standard = XC4000_MN_NTSC_PAL_A2;
+		} else {
+			params->std |= V4L2_STD_BTSC;
+			priv->video_standard = XC4000_MN_NTSC_PAL_BTSC;
+		}
 		goto tune_channel;
 	}
 
 	if (params->std & V4L2_STD_PAL_BG) {
-		/* default to NICAM audio standard */
-		priv->video_standard = XC4000_BG_PAL_NICAM;
+		params->std = V4L2_STD_PAL_BG;
+		if (audio_std & XC4000_AUDIO_STD_MONO) {
+			priv->video_standard = XC4000_BG_PAL_MONO;
+		} else if (!(audio_std & XC4000_AUDIO_STD_A2)) {
+			if (!(audio_std & XC4000_AUDIO_STD_B)) {
+				params->std |= V4L2_STD_NICAM_A;
+				priv->video_standard = XC4000_BG_PAL_NICAM;
+			} else {
+				params->std |= V4L2_STD_NICAM_B;
+				priv->video_standard = XC4000_BG_PAL_NICAM;
+			}
+		} else {
+			if (!(audio_std & XC4000_AUDIO_STD_B)) {
+				params->std |= V4L2_STD_A2_A;
+				priv->video_standard = XC4000_BG_PAL_A2;
+			} else {
+				params->std |= V4L2_STD_A2_B;
+				priv->video_standard = XC4000_BG_PAL_A2;
+			}
+		}
 		goto tune_channel;
 	}
 
 	if (params->std & V4L2_STD_PAL_I) {
 		/* default to NICAM audio standard */
-		priv->video_standard = XC4000_I_PAL_NICAM;
+		params->std = V4L2_STD_PAL_I | V4L2_STD_NICAM;
+		if (audio_std & XC4000_AUDIO_STD_MONO) {
+			priv->video_standard = XC4000_I_PAL_NICAM_MONO;
+		} else {
+			priv->video_standard = XC4000_I_PAL_NICAM;
+		}
 		goto tune_channel;
 	}
 
 	if (params->std & V4L2_STD_PAL_DK) {
-		/* default to NICAM audio standard */
-		priv->video_standard = XC4000_DK_PAL_NICAM;
+		params->std = V4L2_STD_PAL_DK;
+		if (audio_std & XC4000_AUDIO_STD_MONO) {
+			priv->video_standard = XC4000_DK_PAL_MONO;
+		} else if (audio_std & XC4000_AUDIO_STD_A2) {
+			params->std |= V4L2_STD_A2;
+			priv->video_standard = XC4000_DK_PAL_A2;
+		} else {
+			params->std |= V4L2_STD_NICAM;
+			priv->video_standard = XC4000_DK_PAL_NICAM;
+		}
 		goto tune_channel;
 	}
 
 	if (params->std & V4L2_STD_SECAM_DK) {
-		/* default to A2 DK1 audio standard */
-		priv->video_standard = XC4000_DK_SECAM_A2DK1;
+		/* default to A2 audio standard */
+		params->std = V4L2_STD_SECAM_DK | V4L2_STD_A2;
+		if (audio_std & XC4000_AUDIO_STD_L) {
+			type = 0;
+			priv->video_standard = XC4000_DK_SECAM_NICAM;
+		} else if (audio_std & XC4000_AUDIO_STD_MONO) {
+			priv->video_standard = XC4000_DK_SECAM_A2MONO;
+		} else if (audio_std & XC4000_AUDIO_STD_K3) {
+			params->std |= V4L2_STD_SECAM_K3;
+			priv->video_standard = XC4000_DK_SECAM_A2LDK3;
+		} else {
+			priv->video_standard = XC4000_DK_SECAM_A2DK1;
+		}
 		goto tune_channel;
 	}
 
 	if (params->std & V4L2_STD_SECAM_L) {
+		/* default to NICAM audio standard */
+		type = 0;
+		params->std = V4L2_STD_SECAM_L | V4L2_STD_NICAM;
 		priv->video_standard = XC4000_L_SECAM_NICAM;
 		goto tune_channel;
 	}
 
 	if (params->std & V4L2_STD_SECAM_LC) {
+		/* default to NICAM audio standard */
+		type = 0;
+		params->std = V4L2_STD_SECAM_LC | V4L2_STD_NICAM;
 		priv->video_standard = XC4000_LC_SECAM_NICAM;
 		goto tune_channel;
 	}
 
 tune_channel:
+	/* Fix me: it could be air. */
+	priv->rf_mode = XC_RF_MODE_CABLE;
 
-	/* FIXME - firmware type not being set properly */
-	if (check_firmware(fe, DTV8, 0, priv->if_khz) != XC_RESULT_SUCCESS)
+	if (check_firmware(fe, type, params->std,
+			   XC4000_Standard[priv->video_standard].int_freq)
+	    != XC_RESULT_SUCCESS) {
 		goto fail;
+	}
 
 	ret = xc_SetSignalSource(priv, priv->rf_mode);
 	if (ret != XC_RESULT_SUCCESS) {

--------------020800050908060606070003--
