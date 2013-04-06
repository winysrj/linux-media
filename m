Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2335 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932382Ab3DFIn3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Apr 2013 04:43:29 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 2/2] tuner-core/simple: get_rf_strength can be tuner mode specific
Date: Sat,  6 Apr 2013 10:43:14 +0200
Message-Id: <1365237794-32380-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1365237794-32380-1-git-send-email-hverkuil@xs4all.nl>
References: <1365237794-32380-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The get_rf_strength op in tuner-simple is valid only for the radio mode.
But due to the way get_signal in analog_demod_ops was designed it would
overwrite the signal value with a bogus value when in TV mode.

Pass a pointer to the signal value instead, and when not in radio mode
leave it alone in the tuner-simple.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/dvb-core/dvb_frontend.h |    2 +-
 drivers/media/tuners/tda8290.c        |   15 +++++++++------
 drivers/media/tuners/tuner-simple.c   |    5 ++++-
 drivers/media/v4l2-core/tuner-core.c  |   29 +++++++++++++----------------
 4 files changed, 27 insertions(+), 24 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index 44fad1c..371b6ca 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -245,7 +245,7 @@ struct analog_demod_ops {
 
 	void (*set_params)(struct dvb_frontend *fe,
 			   struct analog_parameters *params);
-	int  (*has_signal)(struct dvb_frontend *fe);
+	int  (*has_signal)(struct dvb_frontend *fe, u16 *signal);
 	int  (*get_afc)(struct dvb_frontend *fe, s32 *afc);
 	void (*tuner_status)(struct dvb_frontend *fe);
 	void (*standby)(struct dvb_frontend *fe);
diff --git a/drivers/media/tuners/tda8290.c b/drivers/media/tuners/tda8290.c
index 8c48521..119339bd 100644
--- a/drivers/media/tuners/tda8290.c
+++ b/drivers/media/tuners/tda8290.c
@@ -388,7 +388,7 @@ static void tda8295_agc2_out(struct dvb_frontend *fe, int enable)
 	tuner_i2c_xfer_send(&priv->i2c_props, set_gpio_val, 2);
 }
 
-static int tda8295_has_signal(struct dvb_frontend *fe)
+static int tda8295_has_signal(struct dvb_frontend *fe, u16 *signal)
 {
 	struct tda8290_priv *priv = fe->analog_demod_priv;
 
@@ -396,7 +396,8 @@ static int tda8295_has_signal(struct dvb_frontend *fe)
 	unsigned char ret;
 
 	tuner_i2c_xfer_send_recv(&priv->i2c_props, &hvpll_stat, 1, &ret, 1);
-	return (ret & 0x01) ? 65535 : 0;
+	*signal = (ret & 0x01) ? 65535 : 0;
+	return 0;
 }
 
 /*---------------------------------------------------------------------*/
@@ -405,7 +406,7 @@ static void tda8295_set_params(struct dvb_frontend *fe,
 			       struct analog_parameters *params)
 {
 	struct tda8290_priv *priv = fe->analog_demod_priv;
-
+	u16 signal = 0;
 	unsigned char blanking_mode[]     = { 0x1d, 0x00 };
 
 	set_audio(fe, params);
@@ -432,7 +433,8 @@ static void tda8295_set_params(struct dvb_frontend *fe,
 	if (priv->cfg.agcf)
 		priv->cfg.agcf(fe);
 
-	if (tda8295_has_signal(fe))
+	tda8295_has_signal(fe, &signal);
+	if (signal)
 		tuner_dbg("tda8295 is locked\n");
 	else
 		tuner_dbg("tda8295 not locked, no signal?\n");
@@ -442,7 +444,7 @@ static void tda8295_set_params(struct dvb_frontend *fe,
 
 /*---------------------------------------------------------------------*/
 
-static int tda8290_has_signal(struct dvb_frontend *fe)
+static int tda8290_has_signal(struct dvb_frontend *fe, u16 *signal)
 {
 	struct tda8290_priv *priv = fe->analog_demod_priv;
 
@@ -451,7 +453,8 @@ static int tda8290_has_signal(struct dvb_frontend *fe)
 
 	tuner_i2c_xfer_send_recv(&priv->i2c_props,
 				 i2c_get_afc, ARRAY_SIZE(i2c_get_afc), &afc, 1);
-	return (afc & 0x80)? 65535:0;
+	*signal = (afc & 0x80) ? 65535 : 0;
+	return 0;
 }
 
 /*---------------------------------------------------------------------*/
diff --git a/drivers/media/tuners/tuner-simple.c b/drivers/media/tuners/tuner-simple.c
index 39e7e58..ca274c2 100644
--- a/drivers/media/tuners/tuner-simple.c
+++ b/drivers/media/tuners/tuner-simple.c
@@ -115,6 +115,7 @@ struct tuner_simple_priv {
 
 	u32 frequency;
 	u32 bandwidth;
+	bool radio_mode;
 };
 
 /* ---------------------------------------------------------------------- */
@@ -189,7 +190,7 @@ static int simple_get_rf_strength(struct dvb_frontend *fe, u16 *strength)
 	struct tuner_simple_priv *priv = fe->tuner_priv;
 	int signal;
 
-	if (priv->i2c_props.adap == NULL)
+	if (priv->i2c_props.adap == NULL || !priv->radio_mode)
 		return -EINVAL;
 
 	signal = tuner_signal(tuner_read_status(fe));
@@ -776,11 +777,13 @@ static int simple_set_params(struct dvb_frontend *fe,
 
 	switch (params->mode) {
 	case V4L2_TUNER_RADIO:
+		priv->radio_mode = true;
 		ret = simple_set_radio_freq(fe, params);
 		priv->frequency = params->frequency * 125 / 2;
 		break;
 	case V4L2_TUNER_ANALOG_TV:
 	case V4L2_TUNER_DIGITAL_TV:
+		priv->radio_mode = false;
 		ret = simple_set_tv_freq(fe, params);
 		priv->frequency = params->frequency * 62500;
 		break;
diff --git a/drivers/media/v4l2-core/tuner-core.c b/drivers/media/v4l2-core/tuner-core.c
index b2d057d..7702159 100644
--- a/drivers/media/v4l2-core/tuner-core.c
+++ b/drivers/media/v4l2-core/tuner-core.c
@@ -218,16 +218,6 @@ static void fe_standby(struct dvb_frontend *fe)
 		fe_tuner_ops->sleep(fe);
 }
 
-static int fe_has_signal(struct dvb_frontend *fe)
-{
-	u16 strength;
-
-	if (fe->ops.tuner_ops.get_rf_strength(fe, &strength) < 0)
-		return 0;
-
-	return strength;
-}
-
 static int fe_set_config(struct dvb_frontend *fe, void *priv_cfg)
 {
 	struct dvb_tuner_ops *fe_tuner_ops = &fe->ops.tuner_ops;
@@ -442,7 +432,7 @@ static void set_type(struct i2c_client *c, unsigned int type,
 		       sizeof(struct analog_demod_ops));
 
 		if (fe_tuner_ops->get_rf_strength)
-			analog_ops->has_signal = fe_has_signal;
+			analog_ops->has_signal = fe_tuner_ops->get_rf_strength;
 		if (fe_tuner_ops->get_afc)
 			analog_ops->get_afc = fe_tuner_ops->get_afc;
 
@@ -1066,9 +1056,12 @@ static void tuner_status(struct dvb_frontend *fe)
 		if (tuner_status & TUNER_STATUS_STEREO)
 			tuner_info("Stereo:          yes\n");
 	}
-	if (analog_ops->has_signal)
-		tuner_info("Signal strength: %d\n",
-			   analog_ops->has_signal(fe));
+	if (analog_ops->has_signal) {
+		u16 signal;
+
+		if (!analog_ops->has_signal(fe, &signal))
+			tuner_info("Signal strength: %hu\n", signal);
+	}
 }
 
 /*
@@ -1187,8 +1180,12 @@ static int tuner_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
 		return 0;
 	if (vt->type == t->mode && analog_ops->get_afc)
 		analog_ops->get_afc(&t->fe, &vt->afc);
-	if (analog_ops->has_signal)
-		vt->signal = analog_ops->has_signal(&t->fe);
+	if (vt->type == t->mode && analog_ops->has_signal) {
+		u16 signal = (u16)vt->signal;
+
+		if (!analog_ops->has_signal(&t->fe, &signal))
+			vt->signal = signal;
+	}
 	if (vt->type != V4L2_TUNER_RADIO) {
 		vt->capability |= V4L2_TUNER_CAP_NORM;
 		vt->rangelow = tv_range[0] * 16;
-- 
1.7.10.4

