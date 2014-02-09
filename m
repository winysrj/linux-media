Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:41846 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782AbaBIJVZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Feb 2014 04:21:25 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [REVIEW PATCH 75/86] r820t/rtl2832u_sdr: implement gains using v4l2 controls
Date: Sun,  9 Feb 2014 10:49:20 +0200
Message-Id: <1391935771-18670-76-git-send-email-crope@iki.fi>
In-Reply-To: <1391935771-18670-1-git-send-email-crope@iki.fi>
References: <1391935771-18670-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement gain controls using v4l2 control framework.
Pointer to control handler is provided by exported symbol.

Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/r820t.c                     | 175 ++++++++++++++++++-----
 drivers/media/tuners/r820t.h                     |  17 ++-
 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c |  72 +---------
 3 files changed, 151 insertions(+), 113 deletions(-)

diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
index 231c614..5150a18 100644
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
@@ -1251,43 +1262,6 @@ static int r820t_set_gain_mode(struct r820t_priv *priv,
 }
 #endif
 
-static int r820t_set_config(struct dvb_frontend *fe, void *priv_cfg)
-{
-	struct r820t_priv *priv = fe->tuner_priv;
-	struct r820t_ctrl *ctrl = priv_cfg;
-	int rc;
-
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 1);
-
-	if (ctrl->lna_gain == INT_MIN)
-		rc = r820t_write_reg_mask(priv, 0x05, 0x00, 0x10);
-	else
-		rc = r820t_write_reg_mask(priv, 0x05,
-				0x10 | ctrl->lna_gain, 0x1f);
-	if (rc < 0)
-		goto err;
-
-	if (ctrl->mixer_gain == INT_MIN)
-		rc = r820t_write_reg_mask(priv, 0x07, 0x10, 0x10);
-	else
-		rc = r820t_write_reg_mask(priv, 0x07,
-				0x00 | ctrl->mixer_gain, 0x1f);
-	if (rc < 0)
-		goto err;
-
-	if (ctrl->if_gain == INT_MIN)
-		rc = r820t_write_reg_mask(priv, 0x0c, 0x10, 0x10);
-	else
-		rc = r820t_write_reg_mask(priv, 0x0c,
-				0x00 | ctrl->if_gain, 0x1f);
-err:
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 0);
-
-	return rc;
-}
-
 static int generic_set_freq(struct dvb_frontend *fe,
 			    u32 freq /* in HZ */,
 			    unsigned bw,
@@ -2292,8 +2266,10 @@ static int r820t_release(struct dvb_frontend *fe)
 
 	mutex_lock(&r820t_list_mutex);
 
-	if (priv)
+	if (priv) {
+		v4l2_ctrl_handler_free(&priv->hdl);
 		hybrid_tuner_release_state(priv);
+	}
 
 	mutex_unlock(&r820t_list_mutex);
 
@@ -2302,6 +2278,96 @@ static int r820t_release(struct dvb_frontend *fe)
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
+	case  V4L2_CID_LNA_GAIN_AUTO:
+	case  V4L2_CID_LNA_GAIN:
+		rc = r820t_set_lna_gain(priv);
+		break;
+	case  V4L2_CID_MIXER_GAIN_AUTO:
+	case  V4L2_CID_MIXER_GAIN:
+		rc = r820t_set_mixer_gain(priv);
+		break;
+	case  V4L2_CID_IF_GAIN_AUTO:
+	case  V4L2_CID_IF_GAIN:
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
@@ -2312,12 +2378,18 @@ static const struct dvb_tuner_ops r820t_tuner_ops = {
 	.release = r820t_release,
 	.sleep = r820t_sleep,
 	.set_params = r820t_set_params,
-	.set_config = r820t_set_config,
 	.set_analog_params = r820t_set_analog_freq,
 	.get_if_frequency = r820t_get_if_frequency,
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
@@ -2352,6 +2424,8 @@ struct dvb_frontend *r820t_attach(struct dvb_frontend *fe,
 		break;
 	}
 
+	priv->fe = fe;
+
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
 
@@ -2364,6 +2438,29 @@ struct dvb_frontend *r820t_attach(struct dvb_frontend *fe,
 	if (rc < 0)
 		goto err;
 
+	/* Register controls */
+	v4l2_ctrl_handler_init(&priv->hdl, 6);
+	priv->lna_gain_auto = v4l2_ctrl_new_std(&priv->hdl, &r820t_ctrl_ops,
+			V4L2_CID_LNA_GAIN_AUTO, 0, 1, 1, 1);
+	priv->lna_gain = v4l2_ctrl_new_std(&priv->hdl, &r820t_ctrl_ops,
+			V4L2_CID_LNA_GAIN, 0, 15, 1, 6);
+	v4l2_ctrl_auto_cluster(2, &priv->lna_gain_auto, 0, false);
+	priv->mixer_gain_auto = v4l2_ctrl_new_std(&priv->hdl, &r820t_ctrl_ops,
+			V4L2_CID_MIXER_GAIN_AUTO, 0, 1, 1, 1);
+	priv->mixer_gain = v4l2_ctrl_new_std(&priv->hdl, &r820t_ctrl_ops,
+			V4L2_CID_MIXER_GAIN, 0, 15, 1, 5);
+	v4l2_ctrl_auto_cluster(2, &priv->mixer_gain_auto, 0, false);
+	priv->if_gain_auto = v4l2_ctrl_new_std(&priv->hdl, &r820t_ctrl_ops,
+			V4L2_CID_IF_GAIN_AUTO, 0, 1, 1, 1);
+	priv->if_gain = v4l2_ctrl_new_std(&priv->hdl, &r820t_ctrl_ops,
+			V4L2_CID_IF_GAIN, 0, 15, 1, 4);
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
index 42c0d8e..b61d6ea 100644
--- a/drivers/media/tuners/r820t.h
+++ b/drivers/media/tuners/r820t.h
@@ -42,17 +42,13 @@ struct r820t_config {
 	bool use_predetect;
 };
 
-/* set INT_MIN for automode */
-struct r820t_ctrl {
-	int lna_gain;
-	int mixer_gain;
-	int if_gain;
-};
-
 #if IS_ENABLED(CONFIG_MEDIA_TUNER_R820T)
 struct dvb_frontend *r820t_attach(struct dvb_frontend *fe,
 				  struct i2c_adapter *i2c,
 				  const struct r820t_config *cfg);
+
+extern struct v4l2_ctrl_handler *r820t_get_ctrl_handler(
+				struct dvb_frontend *fe);
 #else
 static inline struct dvb_frontend *r820t_attach(struct dvb_frontend *fe,
 						struct i2c_adapter *i2c,
@@ -61,6 +57,13 @@ static inline struct dvb_frontend *r820t_attach(struct dvb_frontend *fe,
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
diff --git a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
index e89abd8..0d96aea 100644
--- a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
+++ b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
@@ -145,12 +145,6 @@ struct rtl2832_sdr_state {
 	struct v4l2_ctrl_handler hdl;
 	struct v4l2_ctrl *bandwidth_auto;
 	struct v4l2_ctrl *bandwidth;
-	struct v4l2_ctrl *lna_gain_auto;
-	struct v4l2_ctrl *lna_gain;
-	struct v4l2_ctrl *mixer_gain_auto;
-	struct v4l2_ctrl *mixer_gain;
-	struct v4l2_ctrl *if_gain_auto;
-	struct v4l2_ctrl *if_gain;
 
 	/* for sample rate calc */
 	unsigned int sample;
@@ -918,51 +912,12 @@ err:
 	return;
 };
 
-static int rtl2832_sdr_set_gain_r820t(struct rtl2832_sdr_state *s)
-{
-	int ret;
-	struct dvb_frontend *fe = s->fe;
-	struct r820t_ctrl ctrl;
-	dev_dbg(&s->udev->dev, "%s: lna=%d mixer=%d if=%d\n", __func__,
-			s->lna_gain->val, s->mixer_gain->val, s->if_gain->val);
-
-	ctrl.lna_gain = s->lna_gain_auto->val ? INT_MIN : s->lna_gain->val;
-	ctrl.mixer_gain = s->mixer_gain_auto->val ? INT_MIN : s->mixer_gain->val;
-	ctrl.if_gain = s->if_gain_auto->val ? INT_MIN : s->if_gain->val;
-
-	if (fe->ops.tuner_ops.set_config) {
-		ret = fe->ops.tuner_ops.set_config(fe, &ctrl);
-		if (ret)
-			goto err;
-	}
-
-	return 0;
-err:
-	dev_dbg(&s->udev->dev, "%s: failed %d\n", __func__, ret);
-	return ret;
-};
-
-static int rtl2832_sdr_set_gain(struct rtl2832_sdr_state *s)
-{
-	int ret;
-
-	switch (s->cfg->tuner) {
-	case RTL2832_TUNER_R820T:
-		ret = rtl2832_sdr_set_gain_r820t(s);
-		break;
-	default:
-		ret = 0;
-	}
-	return ret;
-}
-
 static int rtl2832_sdr_set_tuner(struct rtl2832_sdr_state *s)
 {
 	struct dvb_frontend *fe = s->fe;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct v4l2_ctrl *bandwidth_auto;
 	struct v4l2_ctrl *bandwidth;
-	int ret;
 
 	/*
 	 * tuner RF (Hz)
@@ -997,8 +952,6 @@ static int rtl2832_sdr_set_tuner(struct rtl2832_sdr_state *s)
 	if (fe->ops.tuner_ops.set_params)
 		fe->ops.tuner_ops.set_params(fe);
 
-	ret = rtl2832_sdr_set_gain(s);
-
 	return 0;
 };
 
@@ -1202,7 +1155,7 @@ static int rtl2832_sdr_s_frequency(struct file *file, void *priv,
 				__func__, f->frequency);
 		ret = rtl2832_sdr_set_tuner(s);
 	} else {
-		return -EINVAL;
+		ret = -EINVAL;
 	}
 
 	return ret;
@@ -1353,15 +1306,6 @@ static int rtl2832_sdr_s_ctrl(struct v4l2_ctrl *ctrl)
 		else
 			ret = 0;
 		break;
-	case  V4L2_CID_LNA_GAIN_AUTO:
-	case  V4L2_CID_LNA_GAIN:
-	case  V4L2_CID_MIXER_GAIN_AUTO:
-	case  V4L2_CID_MIXER_GAIN:
-	case  V4L2_CID_IF_GAIN_AUTO:
-	case  V4L2_CID_IF_GAIN:
-		dev_dbg(&s->udev->dev, "%s: GAIN IOCTL\n", __func__);
-		ret = rtl2832_sdr_set_gain(s);
-		break;
 	default:
 		ret = -EINVAL;
 	}
@@ -1436,19 +1380,13 @@ struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
 			v4l2_ctrl_add_handler(&s->hdl, hdl, NULL);
 		break;
 	case RTL2832_TUNER_R820T:
-		v4l2_ctrl_handler_init(&s->hdl, 8);
+		v4l2_ctrl_handler_init(&s->hdl, 2);
 		s->bandwidth_auto = v4l2_ctrl_new_std(&s->hdl, ops, V4L2_CID_BANDWIDTH_AUTO, 0, 1, 1, 1);
 		s->bandwidth = v4l2_ctrl_new_std(&s->hdl, ops, V4L2_CID_BANDWIDTH, 0, 8000000, 100000, 0);
 		v4l2_ctrl_auto_cluster(2, &s->bandwidth_auto, 0, false);
-		s->lna_gain_auto = v4l2_ctrl_new_std(&s->hdl, ops, V4L2_CID_LNA_GAIN_AUTO, 0, 1, 1, 1);
-		s->lna_gain = v4l2_ctrl_new_std(&s->hdl, ops, V4L2_CID_LNA_GAIN, 0, 15, 1, 6);
-		v4l2_ctrl_auto_cluster(2, &s->lna_gain_auto, 0, false);
-		s->mixer_gain_auto = v4l2_ctrl_new_std(&s->hdl, ops, V4L2_CID_MIXER_GAIN_AUTO, 0, 1, 1, 1);
-		s->mixer_gain = v4l2_ctrl_new_std(&s->hdl, ops, V4L2_CID_MIXER_GAIN, 0, 15, 1, 5);
-		v4l2_ctrl_auto_cluster(2, &s->mixer_gain_auto, 0, false);
-		s->if_gain_auto = v4l2_ctrl_new_std(&s->hdl, ops, V4L2_CID_IF_GAIN_AUTO, 0, 1, 1, 1);
-		s->if_gain = v4l2_ctrl_new_std(&s->hdl, ops, V4L2_CID_IF_GAIN, 0, 15, 1, 4);
-		v4l2_ctrl_auto_cluster(2, &s->if_gain_auto, 0, false);
+		hdl = r820t_get_ctrl_handler(fe);
+		if (hdl)
+			v4l2_ctrl_add_handler(&s->hdl, hdl, NULL);
 		break;
 	case RTL2832_TUNER_FC0012:
 	case RTL2832_TUNER_FC0013:
-- 
1.8.5.3

