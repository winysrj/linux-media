Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44156 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758122Ab2ILC1r (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Sep 2012 22:27:47 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Thomas Mair <mair.thomas86@gmail.com>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 7/8] tua9001: use dev_foo logging
Date: Wed, 12 Sep 2012 05:27:10 +0300
Message-Id: <1347416831-1413-7-git-send-email-crope@iki.fi>
In-Reply-To: <1347416831-1413-1-git-send-email-crope@iki.fi>
References: <1347416831-1413-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/tua9001.c | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/media/tuners/tua9001.c b/drivers/media/tuners/tua9001.c
index 6147eee..e6394fc 100644
--- a/drivers/media/tuners/tua9001.c
+++ b/drivers/media/tuners/tua9001.c
@@ -39,8 +39,8 @@ static int tua9001_wr_reg(struct tua9001_priv *priv, u8 reg, u16 val)
 	if (ret == 1) {
 		ret = 0;
 	} else {
-		printk(KERN_WARNING "%s: I2C wr failed=%d reg=%02x\n",
-				__func__, ret, reg);
+		dev_warn(&priv->i2c->dev, "%s: i2c wr failed=%d reg=%02x\n",
+				KBUILD_MODNAME, ret, reg);
 		ret = -EREMOTEIO;
 	}
 
@@ -52,6 +52,8 @@ static int tua9001_release(struct dvb_frontend *fe)
 	struct tua9001_priv *priv = fe->tuner_priv;
 	int ret = 0;
 
+	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
+
 	if (fe->callback)
 		ret = fe->callback(priv->i2c, DVB_FRONTEND_COMPONENT_TUNER,
 				TUA9001_CMD_CEN, 0);
@@ -85,6 +87,8 @@ static int tua9001_init(struct dvb_frontend *fe)
 		{ 0x34, 0x0a40 },
 	};
 
+	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
+
 	if (fe->callback) {
 		ret = fe->callback(priv->i2c, DVB_FRONTEND_COMPONENT_TUNER,
 				TUA9001_CMD_RESETN, 0);
@@ -106,7 +110,7 @@ err_i2c_gate_ctrl:
 		fe->ops.i2c_gate_ctrl(fe, 0); /* close i2c-gate */
 err:
 	if (ret < 0)
-		pr_debug("%s: failed=%d\n", __func__, ret);
+		dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
@@ -116,12 +120,14 @@ static int tua9001_sleep(struct dvb_frontend *fe)
 	struct tua9001_priv *priv = fe->tuner_priv;
 	int ret = 0;
 
+	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
+
 	if (fe->callback)
 		ret = fe->callback(priv->i2c, DVB_FRONTEND_COMPONENT_TUNER,
 				TUA9001_CMD_RESETN, 1);
 
 	if (ret < 0)
-		pr_debug("%s: failed=%d\n", __func__, ret);
+		dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
@@ -135,9 +141,9 @@ static int tua9001_set_params(struct dvb_frontend *fe)
 	u32 frequency;
 	struct reg_val data[2];
 
-	pr_debug("%s: delivery_system=%d frequency=%d bandwidth_hz=%d\n",
-			__func__, c->delivery_system, c->frequency,
-			c->bandwidth_hz);
+	dev_dbg(&priv->i2c->dev, "%s: delivery_system=%d frequency=%d " \
+			"bandwidth_hz=%d\n", __func__,
+			c->delivery_system, c->frequency, c->bandwidth_hz);
 
 	switch (c->delivery_system) {
 	case SYS_DVBT:
@@ -203,13 +209,17 @@ err_i2c_gate_ctrl:
 		fe->ops.i2c_gate_ctrl(fe, 0); /* close i2c-gate */
 err:
 	if (ret < 0)
-		pr_debug("%s: failed=%d\n", __func__, ret);
+		dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
 
 static int tua9001_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
 {
+	struct tua9001_priv *priv = fe->tuner_priv;
+
+	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
+
 	*frequency = 0; /* Zero-IF */
 
 	return 0;
@@ -253,7 +263,9 @@ struct dvb_frontend *tua9001_attach(struct dvb_frontend *fe,
 			goto err;
 	}
 
-	printk(KERN_INFO "Infineon TUA 9001 successfully attached.");
+	dev_info(&priv->i2c->dev,
+			"%s: Infineon TUA 9001 successfully attached\n",
+			KBUILD_MODNAME);
 
 	memcpy(&fe->ops.tuner_ops, &tua9001_tuner_ops,
 			sizeof(struct dvb_tuner_ops));
@@ -261,6 +273,7 @@ struct dvb_frontend *tua9001_attach(struct dvb_frontend *fe,
 	fe->tuner_priv = priv;
 	return fe;
 err:
+	dev_dbg(&i2c->dev, "%s: failed=%d\n", __func__, ret);
 	kfree(priv);
 	return NULL;
 }
-- 
1.7.11.4

