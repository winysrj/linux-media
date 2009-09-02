Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:47797 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370AbZIBBgx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Sep 2009 21:36:53 -0400
Received: by ewy2 with SMTP id 2so369606ewy.17
        for <linux-media@vger.kernel.org>; Tue, 01 Sep 2009 18:36:54 -0700 (PDT)
Date: Wed, 2 Sep 2009 11:37:05 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: linux-media@vger.kernel.org, video4linux-list@redhat.com
Subject: [PATCH] Add FM radio for the XC5000
Message-ID: <20090902113705.168af9f0@glory.loctelecom.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/BSa3l3l91q4nnwkvq41c0GF"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/BSa3l3l91q4nnwkvq41c0GF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi All

Add FM radio for the xc5000 silicon tuner chip.

diff -r 28f8b0ebd224 linux/drivers/media/common/tuners/xc5000.c
--- a/linux/drivers/media/common/tuners/xc5000.c	Sun Aug 23 13:55:25 2009 -0300
+++ b/linux/drivers/media/common/tuners/xc5000.c	Wed Sep 02 06:32:12 2009 +1000
@@ -747,14 +747,11 @@
 	return ret;
 }
 
-static int xc5000_set_analog_params(struct dvb_frontend *fe,
+static int xc5000_set_tv_freq(struct dvb_frontend *fe,
 	struct analog_parameters *params)
 {
 	struct xc5000_priv *priv = fe->tuner_priv;
 	int ret;
-
-	if (xc5000_is_firmware_loaded(fe) != XC_RESULT_SUCCESS)
-		xc_load_fw_and_init_tuner(fe);
 
 	dprintk(1, "%s() frequency=%d (in units of 62.5khz)\n",
 		__func__, params->frequency);
@@ -834,6 +831,67 @@
 
 	return 0;
 }
+
+static int xc5000_set_radio_freq(struct dvb_frontend *fe,
+	struct analog_parameters *params)
+{
+	struct xc5000_priv *priv = fe->tuner_priv;
+	int ret = -EINVAL;
+
+	dprintk(1, "%s() frequency=%d (in units of khz)\n",
+		__func__, params->frequency);
+
+	priv->freq_hz = params->frequency * 125 / 2;
+
+	priv->rf_mode = XC_RF_MODE_AIR;
+
+	ret = xc_SetTVStandard(priv,
+		XC5000_Standard[FM_Radio_INPUT1].VideoMode,
+		XC5000_Standard[FM_Radio_INPUT1].AudioMode);
+
+	if (ret != XC_RESULT_SUCCESS) {
+		printk(KERN_ERR "xc5000: xc_SetTVStandard failed\n");
+		return -EREMOTEIO;
+	}
+
+	ret = xc_SetSignalSource(priv, priv->rf_mode);
+	if (ret != XC_RESULT_SUCCESS) {
+		printk(KERN_ERR
+			"xc5000: xc_SetSignalSource(%d) failed\n",
+			priv->rf_mode);
+		return -EREMOTEIO;
+	}
+
+	xc_tune_channel(priv, priv->freq_hz, XC_TUNE_ANALOG);
+
+	return 0;
+}
+
+static int xc5000_set_analog_params(struct dvb_frontend *fe,
+			     struct analog_parameters *params)
+{
+	struct xc5000_priv *priv = fe->tuner_priv;
+	int ret = -EINVAL;
+
+	if (priv->i2c_props.adap == NULL)
+		return -EINVAL;
+
+	if (xc5000_is_firmware_loaded(fe) != XC_RESULT_SUCCESS)
+		xc_load_fw_and_init_tuner(fe);
+
+	switch (params->mode) {
+	case V4L2_TUNER_RADIO:
+		ret = xc5000_set_radio_freq(fe, params);
+		break;
+	case V4L2_TUNER_ANALOG_TV:
+	case V4L2_TUNER_DIGITAL_TV:
+		ret = xc5000_set_tv_freq(fe, params);
+		break;
+	}
+
+	return ret;
+}
+
 
 static int xc5000_get_frequency(struct dvb_frontend *fe, u32 *freq)
 {

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

With my best regards, Dmitry.
--MP_/BSa3l3l91q4nnwkvq41c0GF
Content-Type: text/x-patch; name=xc5000_fm_radio.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=xc5000_fm_radio.patch

diff -r 28f8b0ebd224 linux/drivers/media/common/tuners/xc5000.c
--- a/linux/drivers/media/common/tuners/xc5000.c	Sun Aug 23 13:55:25 2009 -0300
+++ b/linux/drivers/media/common/tuners/xc5000.c	Wed Sep 02 06:32:12 2009 +1000
@@ -747,14 +747,11 @@
 	return ret;
 }
 
-static int xc5000_set_analog_params(struct dvb_frontend *fe,
+static int xc5000_set_tv_freq(struct dvb_frontend *fe,
 	struct analog_parameters *params)
 {
 	struct xc5000_priv *priv = fe->tuner_priv;
 	int ret;
-
-	if (xc5000_is_firmware_loaded(fe) != XC_RESULT_SUCCESS)
-		xc_load_fw_and_init_tuner(fe);
 
 	dprintk(1, "%s() frequency=%d (in units of 62.5khz)\n",
 		__func__, params->frequency);
@@ -834,6 +831,67 @@
 
 	return 0;
 }
+
+static int xc5000_set_radio_freq(struct dvb_frontend *fe,
+	struct analog_parameters *params)
+{
+	struct xc5000_priv *priv = fe->tuner_priv;
+	int ret = -EINVAL;
+
+	dprintk(1, "%s() frequency=%d (in units of khz)\n",
+		__func__, params->frequency);
+
+	priv->freq_hz = params->frequency * 125 / 2;
+
+	priv->rf_mode = XC_RF_MODE_AIR;
+
+	ret = xc_SetTVStandard(priv,
+		XC5000_Standard[FM_Radio_INPUT1].VideoMode,
+		XC5000_Standard[FM_Radio_INPUT1].AudioMode);
+
+	if (ret != XC_RESULT_SUCCESS) {
+		printk(KERN_ERR "xc5000: xc_SetTVStandard failed\n");
+		return -EREMOTEIO;
+	}
+
+	ret = xc_SetSignalSource(priv, priv->rf_mode);
+	if (ret != XC_RESULT_SUCCESS) {
+		printk(KERN_ERR
+			"xc5000: xc_SetSignalSource(%d) failed\n",
+			priv->rf_mode);
+		return -EREMOTEIO;
+	}
+
+	xc_tune_channel(priv, priv->freq_hz, XC_TUNE_ANALOG);
+
+	return 0;
+}
+
+static int xc5000_set_analog_params(struct dvb_frontend *fe,
+			     struct analog_parameters *params)
+{
+	struct xc5000_priv *priv = fe->tuner_priv;
+	int ret = -EINVAL;
+
+	if (priv->i2c_props.adap == NULL)
+		return -EINVAL;
+
+	if (xc5000_is_firmware_loaded(fe) != XC_RESULT_SUCCESS)
+		xc_load_fw_and_init_tuner(fe);
+
+	switch (params->mode) {
+	case V4L2_TUNER_RADIO:
+		ret = xc5000_set_radio_freq(fe, params);
+		break;
+	case V4L2_TUNER_ANALOG_TV:
+	case V4L2_TUNER_DIGITAL_TV:
+		ret = xc5000_set_tv_freq(fe, params);
+		break;
+	}
+
+	return ret;
+}
+
 
 static int xc5000_get_frequency(struct dvb_frontend *fe, u32 *freq)
 {

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

--MP_/BSa3l3l91q4nnwkvq41c0GF--
