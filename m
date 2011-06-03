Return-path: <mchehab@pedra>
Received: from mail.juropnet.hu ([212.24.188.131]:50949 "EHLO mail.juropnet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456Ab1FCPXk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Jun 2011 11:23:40 -0400
Received: from [94.248.227.103]
	by mail.juropnet.hu with esmtps (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <istvan_v@mailbox.hu>)
	id 1QSWDl-0002zq-Qq
	for linux-media@vger.kernel.org; Fri, 03 Jun 2011 17:23:39 +0200
Message-ID: <4DE8FC75.8060008@mailbox.hu>
Date: Fri, 03 Jun 2011 17:23:33 +0200
From: "istvan_v@mailbox.hu" <istvan_v@mailbox.hu>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: XC4000: added mutex
References: <4D764337.6050109@email.cz>	<20110531124843.377a2a80@glory.local>	<BANLkTi=Lq+FF++yGhRmOa4NCigSt6ZurHg@mail.gmail.com>	<20110531174323.0f0c45c0@glory.local> <BANLkTimEEGsMP6PDXf5W5p9wW7wdWEEOiA@mail.gmail.com>
In-Reply-To: <BANLkTimEEGsMP6PDXf5W5p9wW7wdWEEOiA@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------080805080604030202000902"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a multi-part message in MIME format.
--------------080805080604030202000902
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

This patch adds a mutex to xc4000_priv, to protect the driver
from being accessed by multiple processes at the same time.

Signed-off-by: Istvan Varga <istvan_v@mailbox.hu>


--------------080805080604030202000902
Content-Type: text/x-patch;
 name="xc4000_mutex.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="xc4000_mutex.patch"

diff -uNr xc4000_orig/drivers/media/common/tuners/xc4000.c xc4000/drivers/media/common/tuners/xc4000.c
--- xc4000_orig/drivers/media/common/tuners/xc4000.c	2011-06-03 16:35:23.000000000 +0200
+++ xc4000/drivers/media/common/tuners/xc4000.c	2011-06-03 17:02:59.000000000 +0200
@@ -28,6 +28,7 @@
 #include <linux/delay.h>
 #include <linux/dvb/frontend.h>
 #include <linux/i2c.h>
+#include <linux/mutex.h>
 #include <asm/unaligned.h>
 
 #include "dvb_frontend.h"
@@ -91,6 +92,7 @@
 	struct firmware_properties cur_fw;
 	__u16	hwmodel;
 	__u16	hwvers;
+	struct mutex	lock;
 };
 
 /* Misc Defines */
@@ -1144,10 +1146,12 @@
 {
 	struct xc4000_priv *priv = fe->tuner_priv;
 	unsigned int type;
-	int	ret;
+	int	ret = -EREMOTEIO;
 
 	dprintk(1, "%s() frequency=%d (Hz)\n", __func__, params->frequency);
 
+	mutex_lock(&priv->lock);
+
 	if (fe->ops.info.type == FE_ATSC) {
 		dprintk(1, "%s() ATSC\n", __func__);
 		switch (params->u.vsb.modulation) {
@@ -1171,7 +1175,8 @@
 			type = DTV6;
 			break;
 		default:
-			return -EINVAL;
+			ret = -EINVAL;
+			goto fail;
 		}
 	} else if (fe->ops.info.type == FE_OFDM) {
 		dprintk(1, "%s() OFDM\n", __func__);
@@ -1207,28 +1212,29 @@
 			break;
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
+		       "xc4000: xc_SetSignalSource(%d) failed\n",
+		       priv->rf_mode);
+		goto fail;
 	}
 
 	ret = xc_SetTVStandard(priv,
@@ -1236,33 +1242,32 @@
 		XC4000_Standard[priv->video_standard].AudioMode);
 	if (ret != XC_RESULT_SUCCESS) {
 		printk(KERN_ERR "xc4000: xc_SetTVStandard failed\n");
-		return -EREMOTEIO;
-	}
-#ifdef DJH_DEBUG
-	ret = xc_set_IF_frequency(priv, priv->if_khz);
-	if (ret != XC_RESULT_SUCCESS) {
-		printk(KERN_ERR "xc4000: xc_Set_IF_frequency(%d) failed\n",
-		       priv->if_khz);
-		return -EIO;
+		goto fail;
 	}
-#endif
 	xc_tune_channel(priv, priv->freq_hz, XC_TUNE_DIGITAL);
 
 	if (debug)
 		xc_debug_dump(priv);
 
-	return 0;
+	ret = 0;
+
+fail:
+	mutex_unlock(&priv->lock);
+
+	return ret;
 }
 
 static int xc4000_set_analog_params(struct dvb_frontend *fe,
 	struct analog_parameters *params)
 {
 	struct xc4000_priv *priv = fe->tuner_priv;
-	int	ret;
+	int	ret = -EREMOTEIO;
 
 	dprintk(1, "%s() frequency=%d (in units of 62.5khz)\n",
 		__func__, params->frequency);
 
+	mutex_lock(&priv->lock);
+
 	/* Fix me: it could be air. */
 	priv->rf_mode = params->mode;
 	if (params->mode > XC_RF_MODE_CABLE)
@@ -1317,16 +1322,15 @@
 tune_channel:
 
 	/* FIXME - firmware type not being set properly */
-	if (check_firmware(fe, DTV8, 0, priv->if_khz) != XC_RESULT_SUCCESS) {
-		return -EREMOTEIO;
-	}
+	if (check_firmware(fe, DTV8, 0, priv->if_khz) != XC_RESULT_SUCCESS)
+		goto fail;
 
 	ret = xc_SetSignalSource(priv, priv->rf_mode);
 	if (ret != XC_RESULT_SUCCESS) {
 		printk(KERN_ERR
-			"xc4000: xc_SetSignalSource(%d) failed\n",
-			priv->rf_mode);
-		return -EREMOTEIO;
+		       "xc4000: xc_SetSignalSource(%d) failed\n",
+		       priv->rf_mode);
+		goto fail;
 	}
 
 	ret = xc_SetTVStandard(priv,
@@ -1334,7 +1338,7 @@
 		XC4000_Standard[priv->video_standard].AudioMode);
 	if (ret != XC_RESULT_SUCCESS) {
 		printk(KERN_ERR "xc4000: xc_SetTVStandard failed\n");
-		return -EREMOTEIO;
+		goto fail;
 	}
 
 	xc_tune_channel(priv, priv->freq_hz, XC_TUNE_ANALOG);
@@ -1342,7 +1346,12 @@
 	if (debug)
 		xc_debug_dump(priv);
 
-	return 0;
+	ret = 0;
+
+fail:
+	mutex_unlock(&priv->lock);
+
+	return ret;
 }
 
 static int xc4000_get_frequency(struct dvb_frontend *fe, u32 *freq)
@@ -1367,8 +1376,12 @@
 	struct xc4000_priv *priv = fe->tuner_priv;
 	u16	lock_status = 0;
 
+	mutex_lock(&priv->lock);
+
 	xc_get_lock_status(priv, &lock_status);
 
+	mutex_unlock(&priv->lock);
+
 	dprintk(1, "%s() lock_status = 0x%08x\n", __func__, lock_status);
 
 	*status = lock_status;
@@ -1385,9 +1398,13 @@
 static int xc4000_init(struct dvb_frontend *fe)
 {
 	struct xc4000_priv *priv = fe->tuner_priv;
+	int	ret;
 	dprintk(1, "%s()\n", __func__);
 
-	if (check_firmware(fe, DTV8, 0, priv->if_khz) != XC_RESULT_SUCCESS) {
+	mutex_lock(&priv->lock);
+	ret = check_firmware(fe, DTV8, 0, priv->if_khz);
+	mutex_unlock(&priv->lock);
+	if (ret != XC_RESULT_SUCCESS) {
 		printk(KERN_ERR "xc4000: Unable to initialise tuner\n");
 		return -EREMOTEIO;
 	}
@@ -1471,6 +1488,7 @@
 	case 1:
 		/* new tuner instance */
 		priv->bandwidth = BANDWIDTH_6_MHZ;
+		mutex_init(&priv->lock);
 		fe->tuner_priv = priv;
 		break;
 	default:
@@ -1522,7 +1540,9 @@
 
 	/* FIXME: For now, load the firmware at startup.  We will remove this
 	   before the code goes to production... */
+	mutex_lock(&priv->lock);
 	check_firmware(fe, DTV8, 0, priv->if_khz);
+	mutex_unlock(&priv->lock);
 
 	return fe;
 fail:

--------------080805080604030202000902--
