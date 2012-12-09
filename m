Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43744 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919Ab2LIT5M (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Dec 2012 14:57:12 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>, Hans-Frieder Vogt <hfvogt@gmx.net>
Subject: [PATCH RFC 06/17] fc0012: add RF loop through
Date: Sun,  9 Dec 2012 21:56:17 +0200
Message-Id: <1355082988-6211-6-git-send-email-crope@iki.fi>
In-Reply-To: <1355082988-6211-1-git-send-email-crope@iki.fi>
References: <1355082988-6211-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cc: Hans-Frieder Vogt <hfvogt@gmx.net>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/fc0012-priv.h | 1 +
 drivers/media/tuners/fc0012.c      | 7 +++++++
 drivers/media/tuners/fc0012.h      | 5 +++++
 3 files changed, 13 insertions(+)

diff --git a/drivers/media/tuners/fc0012-priv.h b/drivers/media/tuners/fc0012-priv.h
index 4577c91..1195ee9 100644
--- a/drivers/media/tuners/fc0012-priv.h
+++ b/drivers/media/tuners/fc0012-priv.h
@@ -32,6 +32,7 @@
 
 struct fc0012_priv {
 	struct i2c_adapter *i2c;
+	const struct fc0012_config *cfg;
 	u8 addr;
 	u8 dual_master;
 	u8 xtal_freq;
diff --git a/drivers/media/tuners/fc0012.c b/drivers/media/tuners/fc0012.c
index 5ede0c0..636f951 100644
--- a/drivers/media/tuners/fc0012.c
+++ b/drivers/media/tuners/fc0012.c
@@ -101,6 +101,9 @@ static int fc0012_init(struct dvb_frontend *fe)
 	if (priv->dual_master)
 		reg[0x0c] |= 0x02;
 
+	if (priv->cfg->loop_through)
+		reg[0x09] |= 0x01;
+
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1); /* open I2C-gate */
 
@@ -445,6 +448,7 @@ struct dvb_frontend *fc0012_attach(struct dvb_frontend *fe,
 		return NULL;
 
 	priv->i2c = i2c;
+	priv->cfg = cfg;
 	priv->dual_master = cfg->dual_master;
 	priv->addr = cfg->i2c_address;
 	priv->xtal_freq = cfg->xtal_freq;
@@ -453,6 +457,9 @@ struct dvb_frontend *fc0012_attach(struct dvb_frontend *fe,
 
 	fe->tuner_priv = priv;
 
+	if (priv->cfg->loop_through)
+		fc0012_writereg(priv, 0x09, 0x6f);
+
 	memcpy(&fe->ops.tuner_ops, &fc0012_tuner_ops,
 		sizeof(struct dvb_tuner_ops));
 
diff --git a/drivers/media/tuners/fc0012.h b/drivers/media/tuners/fc0012.h
index 41946f8..891d66d 100644
--- a/drivers/media/tuners/fc0012.h
+++ b/drivers/media/tuners/fc0012.h
@@ -36,6 +36,11 @@ struct fc0012_config {
 	enum fc001x_xtal_freq xtal_freq;
 
 	int dual_master;
+
+	/*
+	 * RF loop-through
+	 */
+	bool loop_through;
 };
 
 #if defined(CONFIG_MEDIA_TUNER_FC0012) || \
-- 
1.7.11.7

