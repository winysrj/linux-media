Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59698 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752478AbaBKCFP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 21:05:15 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [REVIEW PATCH 02/16] e4000: implement controls via v4l2 control framework
Date: Tue, 11 Feb 2014 04:04:45 +0200
Message-Id: <1392084299-16549-3-git-send-email-crope@iki.fi>
In-Reply-To: <1392084299-16549-1-git-send-email-crope@iki.fi>
References: <1392084299-16549-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement gain and bandwidth controls using v4l2 control framework.
Pointer to control handler is provided by exported symbol.

Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/e4000.c      | 210 +++++++++++++++++++++++++++++++++++++-
 drivers/media/tuners/e4000.h      |  14 +++
 drivers/media/tuners/e4000_priv.h |  75 ++++++++++++++
 3 files changed, 298 insertions(+), 1 deletion(-)

diff --git a/drivers/media/tuners/e4000.c b/drivers/media/tuners/e4000.c
index 0153169..ac44dd2 100644
--- a/drivers/media/tuners/e4000.c
+++ b/drivers/media/tuners/e4000.c
@@ -385,6 +385,178 @@ static int e4000_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
 	return 0;
 }
 
+static int e4000_set_lna_gain(struct dvb_frontend *fe)
+{
+	struct e4000_priv *priv = fe->tuner_priv;
+	int ret;
+	u8 u8tmp;
+	dev_dbg(&priv->client->dev, "%s: lna auto=%d->%d val=%d->%d\n",
+			__func__, priv->lna_gain_auto->cur.val,
+			priv->lna_gain_auto->val, priv->lna_gain->cur.val,
+			priv->lna_gain->val);
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+
+	if (priv->lna_gain_auto->val && priv->if_gain_auto->cur.val)
+		u8tmp = 0x17;
+	else if (priv->lna_gain_auto->val)
+		u8tmp = 0x19;
+	else if (priv->if_gain_auto->cur.val)
+		u8tmp = 0x16;
+	else
+		u8tmp = 0x10;
+
+	ret = e4000_wr_reg(priv, 0x1a, u8tmp);
+	if (ret)
+		goto err;
+
+	if (priv->lna_gain_auto->val == false) {
+		ret = e4000_wr_reg(priv, 0x14, priv->lna_gain->val);
+		if (ret)
+			goto err;
+	}
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+
+	return 0;
+err:
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+
+	dev_dbg(&priv->client->dev, "%s: failed=%d\n", __func__, ret);
+	return ret;
+}
+
+static int e4000_set_mixer_gain(struct dvb_frontend *fe)
+{
+	struct e4000_priv *priv = fe->tuner_priv;
+	int ret;
+	u8 u8tmp;
+	dev_dbg(&priv->client->dev, "%s: mixer auto=%d->%d val=%d->%d\n",
+			__func__, priv->mixer_gain_auto->cur.val,
+			priv->mixer_gain_auto->val, priv->mixer_gain->cur.val,
+			priv->mixer_gain->val);
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+
+	if (priv->mixer_gain_auto->val)
+		u8tmp = 0x15;
+	else
+		u8tmp = 0x14;
+
+	ret = e4000_wr_reg(priv, 0x20, u8tmp);
+	if (ret)
+		goto err;
+
+	if (priv->mixer_gain_auto->val == false) {
+		ret = e4000_wr_reg(priv, 0x15, priv->mixer_gain->val);
+		if (ret)
+			goto err;
+	}
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+
+	return 0;
+err:
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+
+	dev_dbg(&priv->client->dev, "%s: failed=%d\n", __func__, ret);
+	return ret;
+}
+
+static int e4000_set_if_gain(struct dvb_frontend *fe)
+{
+	struct e4000_priv *priv = fe->tuner_priv;
+	int ret;
+	u8 buf[2];
+	u8 u8tmp;
+	dev_dbg(&priv->client->dev, "%s: if auto=%d->%d val=%d->%d\n",
+			__func__, priv->if_gain_auto->cur.val,
+			priv->if_gain_auto->val, priv->if_gain->cur.val,
+			priv->if_gain->val);
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+
+	if (priv->if_gain_auto->val && priv->lna_gain_auto->cur.val)
+		u8tmp = 0x17;
+	else if (priv->lna_gain_auto->cur.val)
+		u8tmp = 0x19;
+	else if (priv->if_gain_auto->val)
+		u8tmp = 0x16;
+	else
+		u8tmp = 0x10;
+
+	ret = e4000_wr_reg(priv, 0x1a, u8tmp);
+	if (ret)
+		goto err;
+
+	if (priv->if_gain_auto->val == false) {
+		buf[0] = e4000_if_gain_lut[priv->if_gain->val].reg16_val;
+		buf[1] = e4000_if_gain_lut[priv->if_gain->val].reg17_val;
+		ret = e4000_wr_regs(priv, 0x16, buf, 2);
+		if (ret)
+			goto err;
+	}
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+
+	return 0;
+err:
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+
+	dev_dbg(&priv->client->dev, "%s: failed=%d\n", __func__, ret);
+	return ret;
+}
+
+static int e4000_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct e4000_priv *priv =
+			container_of(ctrl->handler, struct e4000_priv, hdl);
+	struct dvb_frontend *fe = priv->fe;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	int ret;
+	dev_dbg(&priv->client->dev,
+			"%s: id=%d name=%s val=%d min=%d max=%d step=%d\n",
+			__func__, ctrl->id, ctrl->name, ctrl->val,
+			ctrl->minimum, ctrl->maximum, ctrl->step);
+
+	switch (ctrl->id) {
+	case V4L2_CID_BANDWIDTH_AUTO:
+	case V4L2_CID_BANDWIDTH:
+		c->bandwidth_hz = priv->bandwidth->val;
+		ret = e4000_set_params(priv->fe);
+		break;
+	case  V4L2_CID_LNA_GAIN_AUTO:
+	case  V4L2_CID_LNA_GAIN:
+		ret = e4000_set_lna_gain(priv->fe);
+		break;
+	case  V4L2_CID_MIXER_GAIN_AUTO:
+	case  V4L2_CID_MIXER_GAIN:
+		ret = e4000_set_mixer_gain(priv->fe);
+		break;
+	case  V4L2_CID_IF_GAIN_AUTO:
+	case  V4L2_CID_IF_GAIN:
+		ret = e4000_set_if_gain(priv->fe);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+static const struct v4l2_ctrl_ops e4000_ctrl_ops = {
+	.s_ctrl = e4000_s_ctrl,
+};
+
 static const struct dvb_tuner_ops e4000_tuner_ops = {
 	.info = {
 		.name           = "Elonics E4000",
@@ -399,6 +571,13 @@ static const struct dvb_tuner_ops e4000_tuner_ops = {
 	.get_if_frequency = e4000_get_if_frequency,
 };
 
+struct v4l2_ctrl_handler *e4000_get_ctrl_handler(struct dvb_frontend *fe)
+{
+	struct e4000_priv *priv = fe->tuner_priv;
+	return &priv->hdl;
+}
+EXPORT_SYMBOL(e4000_get_ctrl_handler);
+
 static int e4000_probe(struct i2c_client *client,
 		const struct i2c_device_id *id)
 {
@@ -440,6 +619,35 @@ static int e4000_probe(struct i2c_client *client,
 	if (ret < 0)
 		goto err;
 
+	/* Register controls */
+	v4l2_ctrl_handler_init(&priv->hdl, 8);
+	priv->bandwidth_auto = v4l2_ctrl_new_std(&priv->hdl, &e4000_ctrl_ops,
+			V4L2_CID_BANDWIDTH_AUTO, 0, 1, 1, 1);
+	priv->bandwidth = v4l2_ctrl_new_std(&priv->hdl, &e4000_ctrl_ops,
+			V4L2_CID_BANDWIDTH, 4300000, 11000000, 100000, 4300000);
+	v4l2_ctrl_auto_cluster(2, &priv->bandwidth_auto, 0, false);
+	priv->lna_gain_auto = v4l2_ctrl_new_std(&priv->hdl, &e4000_ctrl_ops,
+			V4L2_CID_LNA_GAIN_AUTO, 0, 1, 1, 1);
+	priv->lna_gain = v4l2_ctrl_new_std(&priv->hdl, &e4000_ctrl_ops,
+			V4L2_CID_LNA_GAIN, 0, 15, 1, 10);
+	v4l2_ctrl_auto_cluster(2, &priv->lna_gain_auto, 0, false);
+	priv->mixer_gain_auto = v4l2_ctrl_new_std(&priv->hdl, &e4000_ctrl_ops,
+			V4L2_CID_MIXER_GAIN_AUTO, 0, 1, 1, 1);
+	priv->mixer_gain = v4l2_ctrl_new_std(&priv->hdl, &e4000_ctrl_ops,
+			V4L2_CID_MIXER_GAIN, 0, 1, 1, 1);
+	v4l2_ctrl_auto_cluster(2, &priv->mixer_gain_auto, 0, false);
+	priv->if_gain_auto = v4l2_ctrl_new_std(&priv->hdl, &e4000_ctrl_ops,
+			V4L2_CID_IF_GAIN_AUTO, 0, 1, 1, 1);
+	priv->if_gain = v4l2_ctrl_new_std(&priv->hdl, &e4000_ctrl_ops,
+			V4L2_CID_IF_GAIN, 0, 54, 1, 0);
+	v4l2_ctrl_auto_cluster(2, &priv->if_gain_auto, 0, false);
+	if (priv->hdl.error) {
+		ret = priv->hdl.error;
+		dev_err(&priv->client->dev, "Could not initialize controls\n");
+		v4l2_ctrl_handler_free(&priv->hdl);
+		goto err;
+	}
+
 	dev_info(&priv->client->dev,
 			"%s: Elonics E4000 successfully identified\n",
 			KBUILD_MODNAME);
@@ -469,7 +677,7 @@ static int e4000_remove(struct i2c_client *client)
 	struct dvb_frontend *fe = priv->fe;
 
 	dev_dbg(&client->dev, "%s:\n", __func__);
-
+	v4l2_ctrl_handler_free(&priv->hdl);
 	memset(&fe->ops.tuner_ops, 0, sizeof(struct dvb_tuner_ops));
 	fe->tuner_priv = NULL;
 	kfree(priv);
diff --git a/drivers/media/tuners/e4000.h b/drivers/media/tuners/e4000.h
index e74b8b2..989f2ea 100644
--- a/drivers/media/tuners/e4000.h
+++ b/drivers/media/tuners/e4000.h
@@ -40,4 +40,18 @@ struct e4000_config {
 	u32 clock;
 };
 
+#if IS_ENABLED(CONFIG_MEDIA_TUNER_E4000)
+extern struct v4l2_ctrl_handler *e4000_get_ctrl_handler(
+		struct dvb_frontend *fe
+);
+#else
+static inline struct v4l2_ctrl_handler *e4000_get_ctrl_handler(
+		struct dvb_frontend *fe
+)
+{
+	pr_warn("%s: driver disabled by Kconfig\n", __func__);
+	return NULL;
+}
+#endif
+
 #endif
diff --git a/drivers/media/tuners/e4000_priv.h b/drivers/media/tuners/e4000_priv.h
index 8f45a30..8cc27b3 100644
--- a/drivers/media/tuners/e4000_priv.h
+++ b/drivers/media/tuners/e4000_priv.h
@@ -22,11 +22,23 @@
 #define E4000_PRIV_H
 
 #include "e4000.h"
+#include <media/v4l2-ctrls.h>
 
 struct e4000_priv {
 	struct i2c_client *client;
 	u32 clock;
 	struct dvb_frontend *fe;
+
+	/* Controls */
+	struct v4l2_ctrl_handler hdl;
+	struct v4l2_ctrl *bandwidth_auto;
+	struct v4l2_ctrl *bandwidth;
+	struct v4l2_ctrl *lna_gain_auto;
+	struct v4l2_ctrl *lna_gain;
+	struct v4l2_ctrl *mixer_gain_auto;
+	struct v4l2_ctrl *mixer_gain;
+	struct v4l2_ctrl *if_gain_auto;
+	struct v4l2_ctrl *if_gain;
 };
 
 struct e4000_pll {
@@ -145,4 +157,67 @@ static const struct e4000_if_filter e4000_if_filter_lut[] = {
 	{ 0xffffffff, 0x00, 0x20 },
 };
 
+struct e4000_if_gain {
+	u8 reg16_val;
+	u8 reg17_val;
+};
+
+static const struct e4000_if_gain e4000_if_gain_lut[] = {
+	{0x00, 0x00},
+	{0x20, 0x00},
+	{0x40, 0x00},
+	{0x02, 0x00},
+	{0x22, 0x00},
+	{0x42, 0x00},
+	{0x04, 0x00},
+	{0x24, 0x00},
+	{0x44, 0x00},
+	{0x01, 0x00},
+	{0x21, 0x00},
+	{0x41, 0x00},
+	{0x03, 0x00},
+	{0x23, 0x00},
+	{0x43, 0x00},
+	{0x05, 0x00},
+	{0x25, 0x00},
+	{0x45, 0x00},
+	{0x07, 0x00},
+	{0x27, 0x00},
+	{0x47, 0x00},
+	{0x0f, 0x00},
+	{0x2f, 0x00},
+	{0x4f, 0x00},
+	{0x17, 0x00},
+	{0x37, 0x00},
+	{0x57, 0x00},
+	{0x1f, 0x00},
+	{0x3f, 0x00},
+	{0x5f, 0x00},
+	{0x1f, 0x01},
+	{0x3f, 0x01},
+	{0x5f, 0x01},
+	{0x1f, 0x02},
+	{0x3f, 0x02},
+	{0x5f, 0x02},
+	{0x1f, 0x03},
+	{0x3f, 0x03},
+	{0x5f, 0x03},
+	{0x1f, 0x04},
+	{0x3f, 0x04},
+	{0x5f, 0x04},
+	{0x1f, 0x0c},
+	{0x3f, 0x0c},
+	{0x5f, 0x0c},
+	{0x1f, 0x14},
+	{0x3f, 0x14},
+	{0x5f, 0x14},
+	{0x1f, 0x1c},
+	{0x3f, 0x1c},
+	{0x5f, 0x1c},
+	{0x1f, 0x24},
+	{0x3f, 0x24},
+	{0x5f, 0x24},
+	{0x7f, 0x24},
+};
+
 #endif
-- 
1.8.5.3

