Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55298 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbaHJArh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Aug 2014 20:47:37 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Shuah Khan <shuah.kh@samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 16/18] [media] xc5000: Split config and set code for analog/radio
Date: Sat,  9 Aug 2014 21:47:22 -0300
Message-Id: <1407631644-11990-17-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1407631644-11990-1-git-send-email-m.chehab@samsung.com>
References: <1407631644-11990-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As we need a function that reapply the last tuned radio,
in order to do resume, split the code that validates and
updates the internal priv struct from the ones that
actually set radio and TV.

A latter patch will add support for resume.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/tuners/xc5000.c | 81 ++++++++++++++++++++++++++++++-------------
 1 file changed, 56 insertions(+), 25 deletions(-)

diff --git a/drivers/media/tuners/xc5000.c b/drivers/media/tuners/xc5000.c
index 3293fd8df59b..78695ed4549c 100644
--- a/drivers/media/tuners/xc5000.c
+++ b/drivers/media/tuners/xc5000.c
@@ -863,12 +863,10 @@ static int xc5000_is_firmware_loaded(struct dvb_frontend *fe)
 	return ret;
 }
 
-static int xc5000_set_tv_freq(struct dvb_frontend *fe,
-	struct analog_parameters *params)
+static void xc5000_config_tv(struct dvb_frontend *fe,
+			     struct analog_parameters *params)
 {
 	struct xc5000_priv *priv = fe->tuner_priv;
-	u16 pll_lock_status;
-	int ret;
 
 	dprintk(1, "%s() frequency=%d (in units of 62.5khz)\n",
 		__func__, params->frequency);
@@ -887,42 +885,49 @@ static int xc5000_set_tv_freq(struct dvb_frontend *fe,
 	if (params->std & V4L2_STD_MN) {
 		/* default to BTSC audio standard */
 		priv->video_standard = MN_NTSC_PAL_BTSC;
-		goto tune_channel;
+		return;
 	}
 
 	if (params->std & V4L2_STD_PAL_BG) {
 		/* default to NICAM audio standard */
 		priv->video_standard = BG_PAL_NICAM;
-		goto tune_channel;
+		return;
 	}
 
 	if (params->std & V4L2_STD_PAL_I) {
 		/* default to NICAM audio standard */
 		priv->video_standard = I_PAL_NICAM;
-		goto tune_channel;
+		return;
 	}
 
 	if (params->std & V4L2_STD_PAL_DK) {
 		/* default to NICAM audio standard */
 		priv->video_standard = DK_PAL_NICAM;
-		goto tune_channel;
+		return;
 	}
 
 	if (params->std & V4L2_STD_SECAM_DK) {
 		/* default to A2 DK1 audio standard */
 		priv->video_standard = DK_SECAM_A2DK1;
-		goto tune_channel;
+		return;
 	}
 
 	if (params->std & V4L2_STD_SECAM_L) {
 		priv->video_standard = L_SECAM_NICAM;
-		goto tune_channel;
+		return;
 	}
 
 	if (params->std & V4L2_STD_SECAM_LC) {
 		priv->video_standard = LC_SECAM_NICAM;
-		goto tune_channel;
+		return;
 	}
+}
+
+static int xc5000_set_tv_freq(struct dvb_frontend *fe)
+{
+	struct xc5000_priv *priv = fe->tuner_priv;
+	u16 pll_lock_status;
+	int ret;
 
 tune_channel:
 	ret = xc_set_signal_source(priv, priv->rf_mode);
@@ -966,12 +971,11 @@ tune_channel:
 	return 0;
 }
 
-static int xc5000_set_radio_freq(struct dvb_frontend *fe,
-	struct analog_parameters *params)
+static int xc5000_config_radio(struct dvb_frontend *fe,
+			       struct analog_parameters *params)
+
 {
 	struct xc5000_priv *priv = fe->tuner_priv;
-	int ret = -EINVAL;
-	u8 radio_input;
 
 	dprintk(1, "%s() frequency=%d (in units of khz)\n",
 		__func__, params->frequency);
@@ -981,6 +985,18 @@ static int xc5000_set_radio_freq(struct dvb_frontend *fe,
 		return -EINVAL;
 	}
 
+	priv->freq_hz = params->frequency * 125 / 2;
+	priv->rf_mode = XC_RF_MODE_AIR;
+
+	return 0;
+}
+
+static int xc5000_set_radio_freq(struct dvb_frontend *fe)
+{
+	struct xc5000_priv *priv = fe->tuner_priv;
+	int ret;
+	u8 radio_input;
+
 	if (priv->radio_input == XC5000_RADIO_FM1)
 		radio_input = FM_RADIO_INPUT1;
 	else if  (priv->radio_input == XC5000_RADIO_FM2)
@@ -993,10 +1009,6 @@ static int xc5000_set_radio_freq(struct dvb_frontend *fe,
 		return -EINVAL;
 	}
 
-	priv->freq_hz = params->frequency * 125 / 2;
-
-	priv->rf_mode = XC_RF_MODE_AIR;
-
 	ret = xc_set_tv_standard(priv, xc5000_standard[radio_input].video_mode,
 			       xc5000_standard[radio_input].audio_mode, radio_input);
 
@@ -1024,11 +1036,27 @@ static int xc5000_set_radio_freq(struct dvb_frontend *fe,
 	return 0;
 }
 
+static int xc5000_apply_params(struct dvb_frontend *fe)
+{
+	struct xc5000_priv *priv = fe->tuner_priv;
+
+	switch (priv->mode) {
+	case V4L2_TUNER_RADIO:
+		return xc5000_set_radio_freq(fe);
+	case V4L2_TUNER_ANALOG_TV:
+		return xc5000_set_tv_freq(fe);
+	case V4L2_TUNER_DIGITAL_TV:
+		return xc5000_tune_digital(fe);
+	}
+
+	return 0;
+}
+
 static int xc5000_set_analog_params(struct dvb_frontend *fe,
 			     struct analog_parameters *params)
 {
 	struct xc5000_priv *priv = fe->tuner_priv;
-	int ret = -EINVAL;
+	int ret;
 
 	if (priv->i2c_props.adap == NULL)
 		return -EINVAL;
@@ -1040,18 +1068,21 @@ static int xc5000_set_analog_params(struct dvb_frontend *fe,
 
 	switch (params->mode) {
 	case V4L2_TUNER_RADIO:
-		ret = xc5000_set_radio_freq(fe, params);
+		ret = xc5000_config_radio(fe, params);
+		if (ret)
+			return ret;
 		break;
 	case V4L2_TUNER_ANALOG_TV:
-	case V4L2_TUNER_DIGITAL_TV:
-		ret = xc5000_set_tv_freq(fe, params);
+		xc5000_config_tv(fe, params);
+		break;
+	default:
 		break;
 	}
+	priv->mode = params->mode;
 
-	return ret;
+	return xc5000_apply_params(fe);
 }
 
-
 static int xc5000_get_frequency(struct dvb_frontend *fe, u32 *freq)
 {
 	struct xc5000_priv *priv = fe->tuner_priv;
-- 
1.9.3

