Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39144 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753620AbaB0Aam (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Feb 2014 19:30:42 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [REVIEW PATCH 14/16] r820t: add manual gain controls
Date: Thu, 27 Feb 2014 02:30:23 +0200
Message-Id: <1393461025-11857-15-git-send-email-crope@iki.fi>
In-Reply-To: <1393461025-11857-1-git-send-email-crope@iki.fi>
References: <1393461025-11857-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add gain control for LNA, Mixer and IF. Expose controls via
V4L control framework.

Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/r820t.c | 137 ++++++++++++++++++++++++++++++++++++++++++-
 drivers/media/tuners/r820t.h |  10 ++++
 2 files changed, 146 insertions(+), 1 deletion(-)

diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
index 319adc4..452a486 100644
--- a/drivers/media/tuners/r820t.c
+++ b/drivers/media/tuners/r820t.c
@@ -36,6 +36,7 @@
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/bitrev.h>
+#include <media/v4l2-ctrls.h>
 
 #include "tuner-i2c.h"
 #include "r820t.h"
@@ -80,6 +81,7 @@ struct r820t_sect_type {
 
 struct r820t_priv {
 	struct list_head		hybrid_tuner_instance_list;
+	struct dvb_frontend		*fe;
 	const struct r820t_config	*cfg;
 	struct tuner_i2c_props		i2c_props;
 	struct mutex			lock;
@@ -100,6 +102,15 @@ struct r820t_priv {
 	enum v4l2_tuner_type		type;
 	v4l2_std_id			std;
 	u32				bw;	/* in MHz */
+
+	/* Controls */
+	struct v4l2_ctrl_handler hdl;
+	struct v4l2_ctrl *lna_gain_auto;
+	struct v4l2_ctrl *lna_gain;
+	struct v4l2_ctrl *mixer_gain_auto;
+	struct v4l2_ctrl *mixer_gain;
+	struct v4l2_ctrl *if_gain_auto;
+	struct v4l2_ctrl *if_gain;
 };
 
 struct r820t_freq_range {
@@ -2255,8 +2266,10 @@ static int r820t_release(struct dvb_frontend *fe)
 
 	mutex_lock(&r820t_list_mutex);
 
-	if (priv)
+	if (priv) {
+		v4l2_ctrl_handler_free(&priv->hdl);
 		hybrid_tuner_release_state(priv);
+	}
 
 	mutex_unlock(&r820t_list_mutex);
 
@@ -2265,6 +2278,96 @@ static int r820t_release(struct dvb_frontend *fe)
 	return 0;
 }
 
+static int r820t_set_lna_gain(struct r820t_priv *priv)
+{
+	struct dvb_frontend *fe = priv->fe;
+	int rc;
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+
+	if (priv->lna_gain_auto->val)
+		rc = r820t_write_reg_mask(priv, 0x05, 0x00, 0x10);
+	else
+		rc = r820t_write_reg_mask(priv, 0x05,
+				0x10 | priv->lna_gain->val, 0x1f);
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+
+	return rc;
+}
+
+static int r820t_set_mixer_gain(struct r820t_priv *priv)
+{
+	struct dvb_frontend *fe = priv->fe;
+	int rc;
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+
+	if (priv->mixer_gain_auto->val)
+		rc = r820t_write_reg_mask(priv, 0x07, 0x10, 0x10);
+	else
+		rc = r820t_write_reg_mask(priv, 0x07,
+				0x00 | priv->mixer_gain->val, 0x1f);
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+
+	return rc;
+}
+
+static int r820t_set_if_gain(struct r820t_priv *priv)
+{
+	struct dvb_frontend *fe = priv->fe;
+	int rc;
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+
+	if (priv->if_gain_auto->val)
+		rc = r820t_write_reg_mask(priv, 0x0c, 0x10, 0x10);
+	else
+		rc = r820t_write_reg_mask(priv, 0x0c,
+				0x00 | priv->if_gain->val, 0x1f);
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+
+	return rc;
+}
+
+static int r820t_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct r820t_priv *priv =
+			container_of(ctrl->handler, struct r820t_priv, hdl);
+	int rc;
+
+	switch (ctrl->id) {
+	case  V4L2_CID_RF_TUNER_LNA_GAIN_AUTO:
+	case  V4L2_CID_RF_TUNER_LNA_GAIN:
+		rc = r820t_set_lna_gain(priv);
+		break;
+	case  V4L2_CID_RF_TUNER_MIXER_GAIN_AUTO:
+	case  V4L2_CID_RF_TUNER_MIXER_GAIN:
+		rc = r820t_set_mixer_gain(priv);
+		break;
+	case  V4L2_CID_RF_TUNER_IF_GAIN_AUTO:
+	case  V4L2_CID_RF_TUNER_IF_GAIN:
+		rc = r820t_set_if_gain(priv);
+		break;
+	default:
+		rc = -EINVAL;
+	}
+
+	return rc;
+}
+
+static const struct v4l2_ctrl_ops r820t_ctrl_ops = {
+	.s_ctrl = r820t_s_ctrl,
+};
+
 static const struct dvb_tuner_ops r820t_tuner_ops = {
 	.info = {
 		.name           = "Rafael Micro R820T",
@@ -2280,6 +2383,13 @@ static const struct dvb_tuner_ops r820t_tuner_ops = {
 	.get_rf_strength = r820t_signal,
 };
 
+struct v4l2_ctrl_handler *r820t_get_ctrl_handler(struct dvb_frontend *fe)
+{
+	struct r820t_priv *priv = fe->tuner_priv;
+	return &priv->hdl;
+}
+EXPORT_SYMBOL(r820t_get_ctrl_handler);
+
 struct dvb_frontend *r820t_attach(struct dvb_frontend *fe,
 				  struct i2c_adapter *i2c,
 				  const struct r820t_config *cfg)
@@ -2314,6 +2424,8 @@ struct dvb_frontend *r820t_attach(struct dvb_frontend *fe,
 		break;
 	}
 
+	priv->fe = fe;
+
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
 
@@ -2326,6 +2438,29 @@ struct dvb_frontend *r820t_attach(struct dvb_frontend *fe,
 	if (rc < 0)
 		goto err;
 
+	/* Register controls */
+	v4l2_ctrl_handler_init(&priv->hdl, 6);
+	priv->lna_gain_auto = v4l2_ctrl_new_std(&priv->hdl, &r820t_ctrl_ops,
+			V4L2_CID_RF_TUNER_LNA_GAIN_AUTO, 0, 1, 1, 1);
+	priv->lna_gain = v4l2_ctrl_new_std(&priv->hdl, &r820t_ctrl_ops,
+			V4L2_CID_RF_TUNER_LNA_GAIN, 0, 15, 1, 6);
+	v4l2_ctrl_auto_cluster(2, &priv->lna_gain_auto, 0, false);
+	priv->mixer_gain_auto = v4l2_ctrl_new_std(&priv->hdl, &r820t_ctrl_ops,
+			V4L2_CID_RF_TUNER_MIXER_GAIN_AUTO, 0, 1, 1, 1);
+	priv->mixer_gain = v4l2_ctrl_new_std(&priv->hdl, &r820t_ctrl_ops,
+			V4L2_CID_RF_TUNER_MIXER_GAIN, 0, 15, 1, 5);
+	v4l2_ctrl_auto_cluster(2, &priv->mixer_gain_auto, 0, false);
+	priv->if_gain_auto = v4l2_ctrl_new_std(&priv->hdl, &r820t_ctrl_ops,
+			V4L2_CID_RF_TUNER_IF_GAIN_AUTO, 0, 1, 1, 1);
+	priv->if_gain = v4l2_ctrl_new_std(&priv->hdl, &r820t_ctrl_ops,
+			V4L2_CID_RF_TUNER_IF_GAIN, 0, 15, 1, 4);
+	v4l2_ctrl_auto_cluster(2, &priv->if_gain_auto, 0, false);
+	if (priv->hdl.error) {
+		rc = priv->hdl.error;
+		tuner_info("Could not initialize controls\n");
+		goto err;
+	}
+
 	tuner_info("Rafael Micro r820t successfully identified\n");
 
 	if (fe->ops.i2c_gate_ctrl)
diff --git a/drivers/media/tuners/r820t.h b/drivers/media/tuners/r820t.h
index 48af354..b61d6ea 100644
--- a/drivers/media/tuners/r820t.h
+++ b/drivers/media/tuners/r820t.h
@@ -46,6 +46,9 @@ struct r820t_config {
 struct dvb_frontend *r820t_attach(struct dvb_frontend *fe,
 				  struct i2c_adapter *i2c,
 				  const struct r820t_config *cfg);
+
+extern struct v4l2_ctrl_handler *r820t_get_ctrl_handler(
+				struct dvb_frontend *fe);
 #else
 static inline struct dvb_frontend *r820t_attach(struct dvb_frontend *fe,
 						struct i2c_adapter *i2c,
@@ -54,6 +57,13 @@ static inline struct dvb_frontend *r820t_attach(struct dvb_frontend *fe,
 	pr_warn("%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
+
+static inline struct v4l2_ctrl_handler *r820t_get_ctrl_handler(
+				struct dvb_frontend *fe)
+{
+	pr_warn("%s: driver disabled by Kconfig\n", __func__);
+	return NULL;
+}
 #endif
 
 #endif
-- 
1.8.5.3

