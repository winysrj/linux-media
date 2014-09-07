Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35418 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426AbaIGCAR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Sep 2014 22:00:17 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH v2 1/8] tda18212: add support for slave chip version
Date: Sun,  7 Sep 2014 04:59:53 +0300
Message-Id: <1410055200-32170-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is 2 different versions of that chip available, master and
slave. Slave is used only on dual tuner devices with master tuner.
Laser printing top of chip is 18212/M or 18212/S according to chip
version.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/tda18212.c | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/media/tuners/tda18212.c b/drivers/media/tuners/tda18212.c
index 05a4ac9..15b09f8 100644
--- a/drivers/media/tuners/tda18212.c
+++ b/drivers/media/tuners/tda18212.c
@@ -306,7 +306,8 @@ struct dvb_frontend *tda18212_attach(struct dvb_frontend *fe,
 {
 	struct tda18212_priv *priv = NULL;
 	int ret;
-	u8 val;
+	u8 chip_id = chip_id;
+	char *version;
 
 	priv = kzalloc(sizeof(struct tda18212_priv), GFP_KERNEL);
 	if (priv == NULL)
@@ -320,26 +321,38 @@ struct dvb_frontend *tda18212_attach(struct dvb_frontend *fe,
 		fe->ops.i2c_gate_ctrl(fe, 1); /* open I2C-gate */
 
 	/* check if the tuner is there */
-	ret = tda18212_rd_reg(priv, 0x00, &val);
+	ret = tda18212_rd_reg(priv, 0x00, &chip_id);
+	dev_dbg(&priv->i2c->dev, "%s: chip_id=%02x\n", __func__, chip_id);
 
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 0); /* close I2C-gate */
 
-	if (!ret)
-		dev_dbg(&priv->i2c->dev, "%s: chip id=%02x\n", __func__, val);
-	if (ret || val != 0xc7) {
-		kfree(priv);
-		return NULL;
+	if (ret)
+		goto err;
+
+	switch (chip_id) {
+	case 0xc7:
+		version = "M"; /* master */
+		break;
+	case 0x47:
+		version = "S"; /* slave */
+		break;
+	default:
+		goto err;
 	}
 
 	dev_info(&priv->i2c->dev,
-			"%s: NXP TDA18212HN successfully identified\n",
-			KBUILD_MODNAME);
+			"%s: NXP TDA18212HN/%s successfully identified\n",
+			KBUILD_MODNAME, version);
 
 	memcpy(&fe->ops.tuner_ops, &tda18212_tuner_ops,
 		sizeof(struct dvb_tuner_ops));
 
 	return fe;
+err:
+	dev_dbg(&i2c->dev, "%s: failed=%d\n", __func__, ret);
+	kfree(priv);
+	return NULL;
 }
 EXPORT_SYMBOL(tda18212_attach);
 
-- 
http://palosaari.fi/

