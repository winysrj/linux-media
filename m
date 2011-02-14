Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:23885 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199Ab1BNVOo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 16:14:44 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1ELEinv029976
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 14 Feb 2011 16:14:44 -0500
Received: from pedra (vpn-239-121.phx2.redhat.com [10.3.239.121])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p1EL3TGE012908
	for <linux-media@vger.kernel.org>; Mon, 14 Feb 2011 16:14:44 -0500
Date: Mon, 14 Feb 2011 19:03:21 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 14/14] [media] Remove the remaining usages for T_STANDBY
Message-ID: <20110214190321.0f401e80@pedra>
In-Reply-To: <cover.1297716906.git.mchehab@redhat.com>
References: <cover.1297716906.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

tda9887 used to use the T_STANDBY type internally, while tea5761
used it to put the device to sleep. Fix the code for it to work
properly with the tuner core changes and remove this flag from
tuner.h.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/common/tuners/tda9887.c b/drivers/media/common/tuners/tda9887.c
index bf14bd7..cdb645d 100644
--- a/drivers/media/common/tuners/tda9887.c
+++ b/drivers/media/common/tuners/tda9887.c
@@ -36,6 +36,8 @@ struct tda9887_priv {
 	unsigned int       mode;
 	unsigned int       audmode;
 	v4l2_std_id        std;
+
+	bool               standby;
 };
 
 /* ---------------------------------------------------------------------- */
@@ -568,7 +570,7 @@ static void tda9887_configure(struct dvb_frontend *fe)
 	tda9887_do_config(fe);
 	tda9887_set_insmod(fe);
 
-	if (priv->mode == T_STANDBY)
+	if (priv->standby)
 		priv->data[1] |= cForcedMuteAudioON;
 
 	tuner_dbg("writing: b=0x%02x c=0x%02x e=0x%02x\n",
@@ -616,7 +618,7 @@ static void tda9887_standby(struct dvb_frontend *fe)
 {
 	struct tda9887_priv *priv = fe->analog_demod_priv;
 
-	priv->mode = T_STANDBY;
+	priv->standby = true;
 
 	tda9887_configure(fe);
 }
@@ -626,6 +628,7 @@ static void tda9887_set_params(struct dvb_frontend *fe,
 {
 	struct tda9887_priv *priv = fe->analog_demod_priv;
 
+	priv->standby = false;
 	priv->mode    = params->mode;
 	priv->audmode = params->audmode;
 	priv->std     = params->std;
@@ -686,7 +689,7 @@ struct dvb_frontend *tda9887_attach(struct dvb_frontend *fe,
 		return NULL;
 	case 1:
 		fe->analog_demod_priv = priv;
-		priv->mode = T_STANDBY;
+		priv->standby = true;
 		tuner_info("tda988[5/6/7] found\n");
 		break;
 	default:
diff --git a/drivers/media/common/tuners/tea5761.c b/drivers/media/common/tuners/tea5761.c
index 925399d..bf78cb9 100644
--- a/drivers/media/common/tuners/tea5761.c
+++ b/drivers/media/common/tuners/tea5761.c
@@ -23,6 +23,7 @@ struct tea5761_priv {
 	struct tuner_i2c_props i2c_props;
 
 	u32 frequency;
+	bool standby;
 };
 
 /*****************************************************************************/
@@ -135,18 +136,19 @@ static void tea5761_status_dump(unsigned char *buffer)
 }
 
 /* Freq should be specifyed at 62.5 Hz */
-static int set_radio_freq(struct dvb_frontend *fe,
-			  struct analog_parameters *params)
+static int __set_radio_freq(struct dvb_frontend *fe,
+			    unsigned int freq,
+			    bool mono)
 {
 	struct tea5761_priv *priv = fe->tuner_priv;
-	unsigned int frq = params->frequency;
+	unsigned int frq = freq;
 	unsigned char buffer[7] = {0, 0, 0, 0, 0, 0, 0 };
 	unsigned div;
 	int rc;
 
 	tuner_dbg("radio freq counter %d\n", frq);
 
-	if (params->mode == T_STANDBY) {
+	if (priv->standby) {
 		tuner_dbg("TEA5761 set to standby mode\n");
 		buffer[5] |= TEA5761_TNCTRL_MU;
 	} else {
@@ -154,7 +156,7 @@ static int set_radio_freq(struct dvb_frontend *fe,
 	}
 
 
-	if (params->audmode == V4L2_TUNER_MODE_MONO) {
+	if (mono) {
 		tuner_dbg("TEA5761 set to mono\n");
 		buffer[5] |= TEA5761_TNCTRL_MST;
 	} else {
@@ -176,6 +178,26 @@ static int set_radio_freq(struct dvb_frontend *fe,
 	return 0;
 }
 
+static int set_radio_freq(struct dvb_frontend *fe,
+			  struct analog_parameters *params)
+{
+	struct tea5761_priv *priv = fe->analog_demod_priv;
+
+	priv->standby = false;
+
+	return __set_radio_freq(fe, params->frequency,
+				params->audmode == V4L2_TUNER_MODE_MONO);
+}
+
+static int set_radio_sleep(struct dvb_frontend *fe)
+{
+	struct tea5761_priv *priv = fe->analog_demod_priv;
+
+	priv->standby = true;
+
+	return __set_radio_freq(fe, priv->frequency, false);
+}
+
 static int tea5761_read_status(struct dvb_frontend *fe, char *buffer)
 {
 	struct tea5761_priv *priv = fe->tuner_priv;
@@ -284,6 +306,7 @@ static struct dvb_tuner_ops tea5761_tuner_ops = {
 		.name           = "tea5761", // Philips TEA5761HN FM Radio
 	},
 	.set_analog_params = set_radio_freq,
+	.sleep		   = set_radio_sleep,
 	.release           = tea5761_release,
 	.get_frequency     = tea5761_get_frequency,
 	.get_status        = tea5761_get_status,
diff --git a/include/media/tuner.h b/include/media/tuner.h
index 1d59642..32dfd5f 100644
--- a/include/media/tuner.h
+++ b/include/media/tuner.h
@@ -21,6 +21,7 @@
 
 #ifndef _TUNER_H
 #define _TUNER_H
+#ifdef __KERNEL__
 
 #include <linux/videodev2.h>
 
@@ -157,13 +158,10 @@
 #define TDA9887_GAIN_NORMAL		(1<<20)
 #define TDA9887_RIF_41_3		(1<<21)  /* radio IF1 41.3 vs 33.3 */
 
-#ifdef __KERNEL__
-
 enum tuner_mode {
 	T_RADIO		= 1 << V4L2_TUNER_RADIO,
 	T_ANALOG_TV     = 1 << V4L2_TUNER_ANALOG_TV,
 	T_DIGITAL_TV    = 1 << V4L2_TUNER_DIGITAL_TV,
-	T_STANDBY	= 1 << 31
 };
 
 /* Older boards only had a single tuner device. Nowadays multiple tuner
@@ -193,11 +191,3 @@ struct tuner_setup {
 #endif /* __KERNEL__ */
 
 #endif /* _TUNER_H */
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
-- 
1.7.1

