Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54739 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757442Ab2ILC1n (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Sep 2012 22:27:43 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Thomas Mair <mair.thomas86@gmail.com>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 4/8] tua9001: implement control pin callbacks
Date: Wed, 12 Sep 2012 05:27:07 +0300
Message-Id: <1347416831-1413-4-git-send-email-crope@iki.fi>
In-Reply-To: <1347416831-1413-1-git-send-email-crope@iki.fi>
References: <1347416831-1413-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is three pins used for controlling that tuner.
Implement those using frontend callback.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/tua9001.c | 66 ++++++++++++++++++++++++++++++++++++++----
 drivers/media/tuners/tua9001.h | 20 +++++++++++++
 2 files changed, 81 insertions(+), 5 deletions(-)

diff --git a/drivers/media/tuners/tua9001.c b/drivers/media/tuners/tua9001.c
index de26070..6147eee 100644
--- a/drivers/media/tuners/tua9001.c
+++ b/drivers/media/tuners/tua9001.c
@@ -49,10 +49,17 @@ static int tua9001_wr_reg(struct tua9001_priv *priv, u8 reg, u16 val)
 
 static int tua9001_release(struct dvb_frontend *fe)
 {
+	struct tua9001_priv *priv = fe->tuner_priv;
+	int ret = 0;
+
+	if (fe->callback)
+		ret = fe->callback(priv->i2c, DVB_FRONTEND_COMPONENT_TUNER,
+				TUA9001_CMD_CEN, 0);
+
 	kfree(fe->tuner_priv);
 	fe->tuner_priv = NULL;
 
-	return 0;
+	return ret;
 }
 
 static int tua9001_init(struct dvb_frontend *fe)
@@ -78,17 +85,40 @@ static int tua9001_init(struct dvb_frontend *fe)
 		{ 0x34, 0x0a40 },
 	};
 
+	if (fe->callback) {
+		ret = fe->callback(priv->i2c, DVB_FRONTEND_COMPONENT_TUNER,
+				TUA9001_CMD_RESETN, 0);
+		if (ret < 0)
+			goto err;
+	}
+
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1); /* open i2c-gate */
 
 	for (i = 0; i < ARRAY_SIZE(data); i++) {
 		ret = tua9001_wr_reg(priv, data[i].reg, data[i].val);
-		if (ret)
-			break;
+		if (ret < 0)
+			goto err_i2c_gate_ctrl;
 	}
 
+err_i2c_gate_ctrl:
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 0); /* close i2c-gate */
+err:
+	if (ret < 0)
+		pr_debug("%s: failed=%d\n", __func__, ret);
+
+	return ret;
+}
+
+static int tua9001_sleep(struct dvb_frontend *fe)
+{
+	struct tua9001_priv *priv = fe->tuner_priv;
+	int ret = 0;
+
+	if (fe->callback)
+		ret = fe->callback(priv->i2c, DVB_FRONTEND_COMPONENT_TUNER,
+				TUA9001_CMD_RESETN, 1);
 
 	if (ret < 0)
 		pr_debug("%s: failed=%d\n", __func__, ret);
@@ -148,15 +178,29 @@ static int tua9001_set_params(struct dvb_frontend *fe)
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1); /* open i2c-gate */
 
+	if (fe->callback) {
+		ret = fe->callback(priv->i2c, DVB_FRONTEND_COMPONENT_TUNER,
+				TUA9001_CMD_RXEN, 0);
+		if (ret < 0)
+			goto err_i2c_gate_ctrl;
+	}
+
 	for (i = 0; i < ARRAY_SIZE(data); i++) {
 		ret = tua9001_wr_reg(priv, data[i].reg, data[i].val);
 		if (ret < 0)
-			break;
+			goto err_i2c_gate_ctrl;
+	}
+
+	if (fe->callback) {
+		ret = fe->callback(priv->i2c, DVB_FRONTEND_COMPONENT_TUNER,
+				TUA9001_CMD_RXEN, 1);
+		if (ret < 0)
+			goto err_i2c_gate_ctrl;
 	}
 
+err_i2c_gate_ctrl:
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 0); /* close i2c-gate */
-
 err:
 	if (ret < 0)
 		pr_debug("%s: failed=%d\n", __func__, ret);
@@ -183,6 +227,7 @@ static const struct dvb_tuner_ops tua9001_tuner_ops = {
 	.release = tua9001_release,
 
 	.init = tua9001_init,
+	.sleep = tua9001_sleep,
 	.set_params = tua9001_set_params,
 
 	.get_if_frequency = tua9001_get_if_frequency,
@@ -192,6 +237,7 @@ struct dvb_frontend *tua9001_attach(struct dvb_frontend *fe,
 		struct i2c_adapter *i2c, struct tua9001_config *cfg)
 {
 	struct tua9001_priv *priv = NULL;
+	int ret;
 
 	priv = kzalloc(sizeof(struct tua9001_priv), GFP_KERNEL);
 	if (priv == NULL)
@@ -200,6 +246,13 @@ struct dvb_frontend *tua9001_attach(struct dvb_frontend *fe,
 	priv->cfg = cfg;
 	priv->i2c = i2c;
 
+	if (fe->callback) {
+		ret = fe->callback(priv->i2c, DVB_FRONTEND_COMPONENT_TUNER,
+				TUA9001_CMD_CEN, 1);
+		if (ret < 0)
+			goto err;
+	}
+
 	printk(KERN_INFO "Infineon TUA 9001 successfully attached.");
 
 	memcpy(&fe->ops.tuner_ops, &tua9001_tuner_ops,
@@ -207,6 +260,9 @@ struct dvb_frontend *tua9001_attach(struct dvb_frontend *fe,
 
 	fe->tuner_priv = priv;
 	return fe;
+err:
+	kfree(priv);
+	return NULL;
 }
 EXPORT_SYMBOL(tua9001_attach);
 
diff --git a/drivers/media/tuners/tua9001.h b/drivers/media/tuners/tua9001.h
index 38d6ae7..cf5b815 100644
--- a/drivers/media/tuners/tua9001.h
+++ b/drivers/media/tuners/tua9001.h
@@ -30,6 +30,26 @@ struct tua9001_config {
 	u8 i2c_addr;
 };
 
+/*
+ * TUA9001 I/O PINs:
+ *
+ * CEN - chip enable
+ * 0 = chip disabled (chip off)
+ * 1 = chip enabled (chip on)
+ *
+ * RESETN - chip reset
+ * 0 = reset disabled (chip reset off)
+ * 1 = reset enabled (chip reset on)
+ *
+ * RXEN - RX enable
+ * 0 = RX disabled (chip idle)
+ * 1 = RX enabled (chip tuned)
+ */
+
+#define TUA9001_CMD_CEN     0
+#define TUA9001_CMD_RESETN  1
+#define TUA9001_CMD_RXEN    2
+
 #if defined(CONFIG_MEDIA_TUNER_TUA9001) || \
 	(defined(CONFIG_MEDIA_TUNER_TUA9001_MODULE) && defined(MODULE))
 extern struct dvb_frontend *tua9001_attach(struct dvb_frontend *fe,
-- 
1.7.11.4

