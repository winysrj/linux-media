Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37843 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467AbaBIJ1B (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Feb 2014 04:27:01 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [REVIEW PATCH 65/86] e4000: remove .set_config() which was for controls
Date: Sun,  9 Feb 2014 10:49:10 +0200
Message-Id: <1391935771-18670-66-git-send-email-crope@iki.fi>
In-Reply-To: <1391935771-18670-1-git-send-email-crope@iki.fi>
References: <1391935771-18670-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That custom DVB callback is not needed anymore for setting gain
controls as those are now implemented using V4L2 control framework.

That change was proposed by Mauro.

Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/e4000.c | 68 --------------------------------------------
 drivers/media/tuners/e4000.h |  6 ----
 2 files changed, 74 deletions(-)

diff --git a/drivers/media/tuners/e4000.c b/drivers/media/tuners/e4000.c
index 77318e9..019dc62 100644
--- a/drivers/media/tuners/e4000.c
+++ b/drivers/media/tuners/e4000.c
@@ -381,73 +381,6 @@ static int e4000_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
 	return 0;
 }
 
-static int e4000_set_config(struct dvb_frontend *fe, void *priv_cfg)
-{
-	struct e4000_priv *priv = fe->tuner_priv;
-	struct e4000_ctrl *ctrl = priv_cfg;
-	int ret;
-	u8 buf[2];
-	u8 u8tmp;
-	dev_dbg(&priv->client->dev, "%s: lna=%d mixer=%d if=%d\n", __func__,
-			ctrl->lna_gain, ctrl->mixer_gain, ctrl->if_gain);
-
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 1);
-
-	if (ctrl->lna_gain == INT_MIN && ctrl->if_gain == INT_MIN)
-		u8tmp = 0x17;
-	else if (ctrl->lna_gain == INT_MIN)
-		u8tmp = 0x19;
-	else if (ctrl->if_gain == INT_MIN)
-		u8tmp = 0x16;
-	else
-		u8tmp = 0x10;
-
-	ret = e4000_wr_reg(priv, 0x1a, u8tmp);
-	if (ret)
-		goto err;
-
-	if (ctrl->mixer_gain == INT_MIN)
-		u8tmp = 0x15;
-	else
-		u8tmp = 0x14;
-
-	ret = e4000_wr_reg(priv, 0x20, u8tmp);
-	if (ret)
-		goto err;
-
-	if (ctrl->lna_gain != INT_MIN) {
-		ret = e4000_wr_reg(priv, 0x14, ctrl->lna_gain);
-		if (ret)
-			goto err;
-	}
-
-	if (ctrl->mixer_gain != INT_MIN) {
-		ret = e4000_wr_reg(priv, 0x15, ctrl->mixer_gain);
-		if (ret)
-			goto err;
-	}
-
-	if (ctrl->if_gain != INT_MIN) {
-		buf[0] = e4000_if_gain_lut[ctrl->if_gain].reg16_val;
-		buf[1] = e4000_if_gain_lut[ctrl->if_gain].reg17_val;
-		ret = e4000_wr_regs(priv, 0x16, buf, 2);
-		if (ret)
-			goto err;
-	}
-
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 0);
-
-	return 0;
-err:
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 0);
-
-	dev_dbg(&priv->client->dev, "%s: failed=%d\n", __func__, ret);
-	return ret;
-}
-
 static int e4000_set_lna_gain(struct dvb_frontend *fe)
 {
 	struct e4000_priv *priv = fe->tuner_priv;
@@ -630,7 +563,6 @@ static const struct dvb_tuner_ops e4000_tuner_ops = {
 	.init = e4000_init,
 	.sleep = e4000_sleep,
 	.set_params = e4000_set_params,
-	.set_config = e4000_set_config,
 
 	.get_if_frequency = e4000_get_if_frequency,
 };
diff --git a/drivers/media/tuners/e4000.h b/drivers/media/tuners/e4000.h
index d86de6d..989f2ea 100644
--- a/drivers/media/tuners/e4000.h
+++ b/drivers/media/tuners/e4000.h
@@ -40,12 +40,6 @@ struct e4000_config {
 	u32 clock;
 };
 
-struct e4000_ctrl {
-	int lna_gain;
-	int mixer_gain;
-	int if_gain;
-};
-
 #if IS_ENABLED(CONFIG_MEDIA_TUNER_E4000)
 extern struct v4l2_ctrl_handler *e4000_get_ctrl_handler(
 		struct dvb_frontend *fe
-- 
1.8.5.3

