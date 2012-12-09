Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59156 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758879Ab2LIT5M (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Dec 2012 14:57:12 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>, Hans-Frieder Vogt <hfvogt@gmx.net>
Subject: [PATCH RFC 10/17] fc0012: rework attach() to check chip id and I/O errors
Date: Sun,  9 Dec 2012 21:56:21 +0200
Message-Id: <1355082988-6211-10-git-send-email-crope@iki.fi>
In-Reply-To: <1355082988-6211-1-git-send-email-crope@iki.fi>
References: <1355082988-6211-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cc: Hans-Frieder Vogt <hfvogt@gmx.net>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/fc0012.c | 59 +++++++++++++++++++++++++++++++++++--------
 1 file changed, 49 insertions(+), 10 deletions(-)

diff --git a/drivers/media/tuners/fc0012.c b/drivers/media/tuners/fc0012.c
index 01f5e40..feb1594 100644
--- a/drivers/media/tuners/fc0012.c
+++ b/drivers/media/tuners/fc0012.c
@@ -443,32 +443,71 @@ static const struct dvb_tuner_ops fc0012_tuner_ops = {
 struct dvb_frontend *fc0012_attach(struct dvb_frontend *fe,
 	struct i2c_adapter *i2c, const struct fc0012_config *cfg)
 {
-	struct fc0012_priv *priv = NULL;
+	struct fc0012_priv *priv;
+	int ret;
+	u8 chip_id;
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
 
 	priv = kzalloc(sizeof(struct fc0012_priv), GFP_KERNEL);
-	if (priv == NULL)
-		return NULL;
+	if (!priv) {
+		ret = -ENOMEM;
+		dev_err(&i2c->dev, "%s: kzalloc() failed\n", KBUILD_MODNAME);
+		goto err;
+	}
 
-	priv->i2c = i2c;
 	priv->cfg = cfg;
+	priv->i2c = i2c;
 
-	info("Fitipower FC0012 successfully attached.");
+	/* check if the tuner is there */
+	ret = fc0012_readreg(priv, 0x00, &chip_id);
+	if (ret < 0)
+		goto err;
 
-	fe->tuner_priv = priv;
+	dev_dbg(&i2c->dev, "%s: chip_id=%02x\n", __func__, chip_id);
 
-	if (priv->cfg->loop_through)
-		fc0012_writereg(priv, 0x09, 0x6f);
+	switch (chip_id) {
+	case 0xa1:
+		break;
+	default:
+		ret = -ENODEV;
+		goto err;
+	}
+
+	dev_info(&i2c->dev, "%s: Fitipower FC0012 successfully identified\n",
+			KBUILD_MODNAME);
+
+	if (priv->cfg->loop_through) {
+		ret = fc0012_writereg(priv, 0x09, 0x6f);
+		if (ret < 0)
+			goto err;
+	}
 
 	/*
 	 * TODO: Clock out en or div?
 	 * For dual tuner configuration clearing bit [0] is required.
 	 */
-	if (priv->cfg->clock_out)
-		fc0012_writereg(priv, 0x0b, 0x82);
+	if (priv->cfg->clock_out) {
+		ret =  fc0012_writereg(priv, 0x0b, 0x82);
+		if (ret < 0)
+			goto err;
+	}
 
+	fe->tuner_priv = priv;
 	memcpy(&fe->ops.tuner_ops, &fc0012_tuner_ops,
 		sizeof(struct dvb_tuner_ops));
 
+err:
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+
+	if (ret) {
+		dev_dbg(&i2c->dev, "%s: failed: %d\n", __func__, ret);
+		kfree(priv);
+		return NULL;
+	}
+
 	return fe;
 }
 EXPORT_SYMBOL(fc0012_attach);
-- 
1.7.11.7

