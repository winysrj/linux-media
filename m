Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46138 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab1BAIYz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Feb 2011 03:24:55 -0500
Received: by fxm20 with SMTP id 20so6518801fxm.19
        for <linux-media@vger.kernel.org>; Tue, 01 Feb 2011 00:24:54 -0800 (PST)
Date: Tue, 1 Feb 2011 17:25:19 +0900
From: Dmitri Belimov <d.belimov@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH] xc5000: add set_config and other
Message-ID: <20110201172519.0bc62735@glory.local>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/OFq5YrdTzPg0as7m5CGfNb1"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--MP_/OFq5YrdTzPg0as7m5CGfNb1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi

Add one more radio input, usefull for tm6010
Add control output amplitude.
Add set_config function for configure tuner when TV card hasn't dvb part.

diff --git a/drivers/media/common/tuners/xc5000.c b/drivers/media/common/tuners/xc5000.c
index 76ac5cd..759f0cc 100644
--- a/drivers/media/common/tuners/xc5000.c
+++ b/drivers/media/common/tuners/xc5000.c
@@ -65,7 +65,7 @@ struct xc5000_priv {
 };
 
 /* Misc Defines */
-#define MAX_TV_STANDARD			23
+#define MAX_TV_STANDARD			24
 #define XC_MAX_I2C_WRITE_LENGTH		64
 
 /* Signal Types */
@@ -92,6 +92,8 @@ struct xc5000_priv {
 #define XREG_IF_OUT       0x05
 #define XREG_SEEK_MODE    0x07
 #define XREG_POWER_DOWN   0x0A /* Obsolete */
+/* Set the output amplitude - SIF for analog, DTVP/DTVN for digital */
+#define XREG_OUTPUT_AMP   0x0B
 #define XREG_SIGNALSOURCE 0x0D /* 0=Air, 1=Cable */
 #define XREG_SMOOTHEDCVBS 0x0E
 #define XREG_XTALFREQ     0x0F
@@ -173,6 +175,7 @@ struct XC_TV_STANDARD {
 #define DTV7			20
 #define FM_Radio_INPUT2 	21
 #define FM_Radio_INPUT1 	22
+#define FM_Radio_INPUT1_MONO	23
 
 static struct XC_TV_STANDARD XC5000_Standard[MAX_TV_STANDARD] = {
 	{"M/N-NTSC/PAL-BTSC", 0x0400, 0x8020},
@@ -197,7 +200,8 @@ static struct XC_TV_STANDARD XC5000_Standard[MAX_TV_STANDARD] = {
 	{"DTV7/8",            0x00C0, 0x801B},
 	{"DTV7",              0x00C0, 0x8007},
 	{"FM Radio-INPUT2",   0x9802, 0x9002},
-	{"FM Radio-INPUT1",   0x0208, 0x9002}
+	{"FM Radio-INPUT1",   0x0208, 0x9002},
+	{"FM Radio-INPUT1_MONO", 0x0278, 0x9002}
 };
 
 static int xc_load_fw_and_init_tuner(struct dvb_frontend *fe);
@@ -714,6 +718,8 @@ static int xc5000_set_params(struct dvb_frontend *fe,
 		return -EIO;
 	}
 
+	xc_write_reg(priv, XREG_OUTPUT_AMP, 0x8a);
+
 	xc_tune_channel(priv, priv->freq_hz, XC_TUNE_DIGITAL);
 
 	if (debug)
@@ -818,6 +824,8 @@ tune_channel:
 		return -EREMOTEIO;
 	}
 
+	xc_write_reg(priv, XREG_OUTPUT_AMP, 0x09);
+
 	xc_tune_channel(priv, priv->freq_hz, XC_TUNE_ANALOG);
 
 	if (debug)
@@ -845,6 +853,8 @@ static int xc5000_set_radio_freq(struct dvb_frontend *fe,
 		radio_input = FM_Radio_INPUT1;
 	else if  (priv->radio_input == XC5000_RADIO_FM2)
 		radio_input = FM_Radio_INPUT2;
+	else if  (priv->radio_input == XC5000_RADIO_FM1_MONO)
+		radio_input = FM_Radio_INPUT1_MONO;
 	else {
 		dprintk(1, "%s() unknown radio input %d\n", __func__,
 			priv->radio_input);
@@ -871,6 +881,12 @@ static int xc5000_set_radio_freq(struct dvb_frontend *fe,
 		return -EREMOTEIO;
 	}
 
+	if ((priv->radio_input == XC5000_RADIO_FM1) ||
+				(priv->radio_input == XC5000_RADIO_FM2))
+		xc_write_reg(priv, XREG_OUTPUT_AMP, 0x09);
+	else if  (priv->radio_input == XC5000_RADIO_FM1_MONO)
+		xc_write_reg(priv, XREG_OUTPUT_AMP, 0x06);
+
 	xc_tune_channel(priv, priv->freq_hz, XC_TUNE_ANALOG);
 
 	return 0;
@@ -1021,6 +1037,23 @@ static int xc5000_release(struct dvb_frontend *fe)
 	return 0;
 }
 
+static int xc5000_set_config(struct dvb_frontend *fe, void *priv_cfg)
+{
+	struct xc5000_priv *priv = fe->tuner_priv;
+	struct xc5000_config *p = priv_cfg;
+
+	dprintk(1, "%s()\n", __func__);
+
+	if (p->if_khz)
+		priv->if_khz = p->if_khz;
+
+	if (p->radio_input)
+		priv->radio_input = p->radio_input;
+
+	return 0;
+}
+
+
 static const struct dvb_tuner_ops xc5000_tuner_ops = {
 	.info = {
 		.name           = "Xceive XC5000",
@@ -1033,6 +1066,7 @@ static const struct dvb_tuner_ops xc5000_tuner_ops = {
 	.init		   = xc5000_init,
 	.sleep		   = xc5000_sleep,
 
+	.set_config	   = xc5000_set_config,
 	.set_params	   = xc5000_set_params,
 	.set_analog_params = xc5000_set_analog_params,
 	.get_frequency	   = xc5000_get_frequency,
diff --git a/drivers/media/common/tuners/xc5000.h b/drivers/media/common/tuners/xc5000.h
index 3756e73..e295745 100644
--- a/drivers/media/common/tuners/xc5000.h
+++ b/drivers/media/common/tuners/xc5000.h
@@ -40,6 +40,7 @@ struct xc5000_config {
 #define XC5000_RADIO_NOT_CONFIGURED		0
 #define XC5000_RADIO_FM1			1
 #define XC5000_RADIO_FM2			2
+#define XC5000_RADIO_FM1_MONO			3
 
 /* For each bridge framework, when it attaches either analog or digital,
  * it has to store a reference back to its _core equivalent structure,

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>


With my best regards, Dmitry.
--MP_/OFq5YrdTzPg0as7m5CGfNb1
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=xc5000_radio_config.patch

diff --git a/drivers/media/common/tuners/xc5000.c b/drivers/media/common/tuners/xc5000.c
index 76ac5cd..759f0cc 100644
--- a/drivers/media/common/tuners/xc5000.c
+++ b/drivers/media/common/tuners/xc5000.c
@@ -65,7 +65,7 @@ struct xc5000_priv {
 };
 
 /* Misc Defines */
-#define MAX_TV_STANDARD			23
+#define MAX_TV_STANDARD			24
 #define XC_MAX_I2C_WRITE_LENGTH		64
 
 /* Signal Types */
@@ -92,6 +92,8 @@ struct xc5000_priv {
 #define XREG_IF_OUT       0x05
 #define XREG_SEEK_MODE    0x07
 #define XREG_POWER_DOWN   0x0A /* Obsolete */
+/* Set the output amplitude - SIF for analog, DTVP/DTVN for digital */
+#define XREG_OUTPUT_AMP   0x0B
 #define XREG_SIGNALSOURCE 0x0D /* 0=Air, 1=Cable */
 #define XREG_SMOOTHEDCVBS 0x0E
 #define XREG_XTALFREQ     0x0F
@@ -173,6 +175,7 @@ struct XC_TV_STANDARD {
 #define DTV7			20
 #define FM_Radio_INPUT2 	21
 #define FM_Radio_INPUT1 	22
+#define FM_Radio_INPUT1_MONO	23
 
 static struct XC_TV_STANDARD XC5000_Standard[MAX_TV_STANDARD] = {
 	{"M/N-NTSC/PAL-BTSC", 0x0400, 0x8020},
@@ -197,7 +200,8 @@ static struct XC_TV_STANDARD XC5000_Standard[MAX_TV_STANDARD] = {
 	{"DTV7/8",            0x00C0, 0x801B},
 	{"DTV7",              0x00C0, 0x8007},
 	{"FM Radio-INPUT2",   0x9802, 0x9002},
-	{"FM Radio-INPUT1",   0x0208, 0x9002}
+	{"FM Radio-INPUT1",   0x0208, 0x9002},
+	{"FM Radio-INPUT1_MONO", 0x0278, 0x9002}
 };
 
 static int xc_load_fw_and_init_tuner(struct dvb_frontend *fe);
@@ -714,6 +718,8 @@ static int xc5000_set_params(struct dvb_frontend *fe,
 		return -EIO;
 	}
 
+	xc_write_reg(priv, XREG_OUTPUT_AMP, 0x8a);
+
 	xc_tune_channel(priv, priv->freq_hz, XC_TUNE_DIGITAL);
 
 	if (debug)
@@ -818,6 +824,8 @@ tune_channel:
 		return -EREMOTEIO;
 	}
 
+	xc_write_reg(priv, XREG_OUTPUT_AMP, 0x09);
+
 	xc_tune_channel(priv, priv->freq_hz, XC_TUNE_ANALOG);
 
 	if (debug)
@@ -845,6 +853,8 @@ static int xc5000_set_radio_freq(struct dvb_frontend *fe,
 		radio_input = FM_Radio_INPUT1;
 	else if  (priv->radio_input == XC5000_RADIO_FM2)
 		radio_input = FM_Radio_INPUT2;
+	else if  (priv->radio_input == XC5000_RADIO_FM1_MONO)
+		radio_input = FM_Radio_INPUT1_MONO;
 	else {
 		dprintk(1, "%s() unknown radio input %d\n", __func__,
 			priv->radio_input);
@@ -871,6 +881,12 @@ static int xc5000_set_radio_freq(struct dvb_frontend *fe,
 		return -EREMOTEIO;
 	}
 
+	if ((priv->radio_input == XC5000_RADIO_FM1) ||
+				(priv->radio_input == XC5000_RADIO_FM2))
+		xc_write_reg(priv, XREG_OUTPUT_AMP, 0x09);
+	else if  (priv->radio_input == XC5000_RADIO_FM1_MONO)
+		xc_write_reg(priv, XREG_OUTPUT_AMP, 0x06);
+
 	xc_tune_channel(priv, priv->freq_hz, XC_TUNE_ANALOG);
 
 	return 0;
@@ -1021,6 +1037,23 @@ static int xc5000_release(struct dvb_frontend *fe)
 	return 0;
 }
 
+static int xc5000_set_config(struct dvb_frontend *fe, void *priv_cfg)
+{
+	struct xc5000_priv *priv = fe->tuner_priv;
+	struct xc5000_config *p = priv_cfg;
+
+	dprintk(1, "%s()\n", __func__);
+
+	if (p->if_khz)
+		priv->if_khz = p->if_khz;
+
+	if (p->radio_input)
+		priv->radio_input = p->radio_input;
+
+	return 0;
+}
+
+
 static const struct dvb_tuner_ops xc5000_tuner_ops = {
 	.info = {
 		.name           = "Xceive XC5000",
@@ -1033,6 +1066,7 @@ static const struct dvb_tuner_ops xc5000_tuner_ops = {
 	.init		   = xc5000_init,
 	.sleep		   = xc5000_sleep,
 
+	.set_config	   = xc5000_set_config,
 	.set_params	   = xc5000_set_params,
 	.set_analog_params = xc5000_set_analog_params,
 	.get_frequency	   = xc5000_get_frequency,
diff --git a/drivers/media/common/tuners/xc5000.h b/drivers/media/common/tuners/xc5000.h
index 3756e73..e295745 100644
--- a/drivers/media/common/tuners/xc5000.h
+++ b/drivers/media/common/tuners/xc5000.h
@@ -40,6 +40,7 @@ struct xc5000_config {
 #define XC5000_RADIO_NOT_CONFIGURED		0
 #define XC5000_RADIO_FM1			1
 #define XC5000_RADIO_FM2			2
+#define XC5000_RADIO_FM1_MONO			3
 
 /* For each bridge framework, when it attaches either analog or digital,
  * it has to store a reference back to its _core equivalent structure,

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

--MP_/OFq5YrdTzPg0as7m5CGfNb1--
