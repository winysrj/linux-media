Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39575 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753674AbaB0Aam (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Feb 2014 19:30:42 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [REVIEW PATCH 04/16] e4000: implement PLL lock v4l control
Date: Thu, 27 Feb 2014 02:30:13 +0200
Message-Id: <1393461025-11857-5-git-send-email-crope@iki.fi>
In-Reply-To: <1393461025-11857-1-git-send-email-crope@iki.fi>
References: <1393461025-11857-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement PLL lock control to get PLL lock flag status from tuner
synthesizer.

Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/e4000.c      | 53 ++++++++++++++++++++++++++++++++++++++-
 drivers/media/tuners/e4000_priv.h |  2 ++
 2 files changed, 54 insertions(+), 1 deletion(-)

diff --git a/drivers/media/tuners/e4000.c b/drivers/media/tuners/e4000.c
index e439ef6..82c6b33 100644
--- a/drivers/media/tuners/e4000.c
+++ b/drivers/media/tuners/e4000.c
@@ -181,6 +181,8 @@ static int e4000_init(struct dvb_frontend *fe)
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 0);
 
+	priv->active = true;
+
 	return 0;
 err:
 	if (fe->ops.i2c_gate_ctrl)
@@ -197,6 +199,8 @@ static int e4000_sleep(struct dvb_frontend *fe)
 
 	dev_dbg(&priv->client->dev, "%s:\n", __func__);
 
+	priv->active = false;
+
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
 
@@ -512,6 +516,50 @@ err:
 	return ret;
 }
 
+static int e4000_pll_lock(struct dvb_frontend *fe)
+{
+	struct e4000_priv *priv = fe->tuner_priv;
+	int ret;
+	u8 u8tmp;
+
+	if (priv->active == false)
+		return 0;
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+
+	ret = e4000_rd_reg(priv, 0x07, &u8tmp);
+	if (ret)
+		goto err;
+
+	priv->pll_lock->val = (u8tmp & 0x01);
+err:
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+
+	if (ret)
+		dev_dbg(&priv->client->dev, "%s: failed=%d\n", __func__, ret);
+
+	return ret;
+}
+
+static int e4000_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct e4000_priv *priv =
+			container_of(ctrl->handler, struct e4000_priv, hdl);
+	int ret;
+
+	switch (ctrl->id) {
+	case  V4L2_CID_RF_TUNER_PLL_LOCK:
+		ret = e4000_pll_lock(priv->fe);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
 static int e4000_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct e4000_priv *priv =
@@ -550,6 +598,7 @@ static int e4000_s_ctrl(struct v4l2_ctrl *ctrl)
 }
 
 static const struct v4l2_ctrl_ops e4000_ctrl_ops = {
+	.g_volatile_ctrl = e4000_g_volatile_ctrl,
 	.s_ctrl = e4000_s_ctrl,
 };
 
@@ -616,7 +665,7 @@ static int e4000_probe(struct i2c_client *client,
 		goto err;
 
 	/* Register controls */
-	v4l2_ctrl_handler_init(&priv->hdl, 8);
+	v4l2_ctrl_handler_init(&priv->hdl, 9);
 	priv->bandwidth_auto = v4l2_ctrl_new_std(&priv->hdl, &e4000_ctrl_ops,
 			V4L2_CID_RF_TUNER_BANDWIDTH_AUTO, 0, 1, 1, 1);
 	priv->bandwidth = v4l2_ctrl_new_std(&priv->hdl, &e4000_ctrl_ops,
@@ -637,6 +686,8 @@ static int e4000_probe(struct i2c_client *client,
 	priv->if_gain = v4l2_ctrl_new_std(&priv->hdl, &e4000_ctrl_ops,
 			V4L2_CID_RF_TUNER_IF_GAIN, 0, 54, 1, 0);
 	v4l2_ctrl_auto_cluster(2, &priv->if_gain_auto, 0, false);
+	priv->pll_lock = v4l2_ctrl_new_std(&priv->hdl, &e4000_ctrl_ops,
+			V4L2_CID_RF_TUNER_PLL_LOCK,  0, 1, 1, 0);
 	if (priv->hdl.error) {
 		ret = priv->hdl.error;
 		dev_err(&priv->client->dev, "Could not initialize controls\n");
diff --git a/drivers/media/tuners/e4000_priv.h b/drivers/media/tuners/e4000_priv.h
index 8cc27b3..d41dbcc 100644
--- a/drivers/media/tuners/e4000_priv.h
+++ b/drivers/media/tuners/e4000_priv.h
@@ -28,6 +28,7 @@ struct e4000_priv {
 	struct i2c_client *client;
 	u32 clock;
 	struct dvb_frontend *fe;
+	bool active;
 
 	/* Controls */
 	struct v4l2_ctrl_handler hdl;
@@ -39,6 +40,7 @@ struct e4000_priv {
 	struct v4l2_ctrl *mixer_gain;
 	struct v4l2_ctrl *if_gain_auto;
 	struct v4l2_ctrl *if_gain;
+	struct v4l2_ctrl *pll_lock;
 };
 
 struct e4000_pll {
-- 
1.8.5.3

