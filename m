Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1322 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932690Ab3DFIn3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Apr 2013 04:43:29 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 1/2] tuner-core/tda9887: get_afc can be tuner mode specific
Date: Sat,  6 Apr 2013 10:43:13 +0200
Message-Id: <1365237794-32380-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1365237794-32380-1-git-send-email-hverkuil@xs4all.nl>
References: <1365237794-32380-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The get_afc op in tda9887 is valid only for the radio mode.
But due to the way get_afc in analog_demod_ops was designed it would
overwrite the afc value with a bogus value when in TV mode.

Pass a pointer to the afc value instead, and when not in radio mode
leave it alone in the tda9887.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/dvb-core/dvb_frontend.h |    2 +-
 drivers/media/tuners/tda9887.c        |   14 +++++++-------
 drivers/media/v4l2-core/tuner-core.c  |   14 ++------------
 3 files changed, 10 insertions(+), 20 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index b34922a..44fad1c 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -246,7 +246,7 @@ struct analog_demod_ops {
 	void (*set_params)(struct dvb_frontend *fe,
 			   struct analog_parameters *params);
 	int  (*has_signal)(struct dvb_frontend *fe);
-	int  (*get_afc)(struct dvb_frontend *fe);
+	int  (*get_afc)(struct dvb_frontend *fe, s32 *afc);
 	void (*tuner_status)(struct dvb_frontend *fe);
 	void (*standby)(struct dvb_frontend *fe);
 	void (*release)(struct dvb_frontend *fe);
diff --git a/drivers/media/tuners/tda9887.c b/drivers/media/tuners/tda9887.c
index cdb645d..300005c 100644
--- a/drivers/media/tuners/tda9887.c
+++ b/drivers/media/tuners/tda9887.c
@@ -596,22 +596,22 @@ static void tda9887_tuner_status(struct dvb_frontend *fe)
 		   priv->data[1], priv->data[2], priv->data[3]);
 }
 
-static int tda9887_get_afc(struct dvb_frontend *fe)
+static int tda9887_get_afc(struct dvb_frontend *fe, s32 *afc)
 {
 	struct tda9887_priv *priv = fe->analog_demod_priv;
-	static int AFC_BITS_2_kHz[] = {
+	static const int AFC_BITS_2_kHz[] = {
 		-12500,  -37500,  -62500,  -97500,
 		-112500, -137500, -162500, -187500,
 		187500,  162500,  137500,  112500,
 		97500 ,  62500,   37500 ,  12500
 	};
-	int afc=0;
 	__u8 reg = 0;
 
-	if (1 == tuner_i2c_xfer_recv(&priv->i2c_props,&reg,1))
-		afc = AFC_BITS_2_kHz[(reg>>1)&0x0f];
-
-	return afc;
+	if (priv->mode != V4L2_TUNER_RADIO)
+		return 0;
+	if (1 == tuner_i2c_xfer_recv(&priv->i2c_props, &reg, 1))
+		*afc = AFC_BITS_2_kHz[(reg >> 1) & 0x0f];
+	return 0;
 }
 
 static void tda9887_standby(struct dvb_frontend *fe)
diff --git a/drivers/media/v4l2-core/tuner-core.c b/drivers/media/v4l2-core/tuner-core.c
index cf9a9af..b2d057d 100644
--- a/drivers/media/v4l2-core/tuner-core.c
+++ b/drivers/media/v4l2-core/tuner-core.c
@@ -228,16 +228,6 @@ static int fe_has_signal(struct dvb_frontend *fe)
 	return strength;
 }
 
-static int fe_get_afc(struct dvb_frontend *fe)
-{
-	s32 afc;
-
-	if (fe->ops.tuner_ops.get_afc(fe, &afc) < 0)
-		return 0;
-
-	return afc;
-}
-
 static int fe_set_config(struct dvb_frontend *fe, void *priv_cfg)
 {
 	struct dvb_tuner_ops *fe_tuner_ops = &fe->ops.tuner_ops;
@@ -454,7 +444,7 @@ static void set_type(struct i2c_client *c, unsigned int type,
 		if (fe_tuner_ops->get_rf_strength)
 			analog_ops->has_signal = fe_has_signal;
 		if (fe_tuner_ops->get_afc)
-			analog_ops->get_afc = fe_get_afc;
+			analog_ops->get_afc = fe_tuner_ops->get_afc;
 
 	} else {
 		t->name = analog_ops->info.name;
@@ -1196,7 +1186,7 @@ static int tuner_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
 	if (check_mode(t, vt->type) == -EINVAL)
 		return 0;
 	if (vt->type == t->mode && analog_ops->get_afc)
-		vt->afc = analog_ops->get_afc(&t->fe);
+		analog_ops->get_afc(&t->fe, &vt->afc);
 	if (analog_ops->has_signal)
 		vt->signal = analog_ops->has_signal(&t->fe);
 	if (vt->type != V4L2_TUNER_RADIO) {
-- 
1.7.10.4

