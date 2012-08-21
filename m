Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38548 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813Ab2HUOTU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Aug 2012 10:19:20 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/2] qt1010: convert for Kernel logging
Date: Tue, 21 Aug 2012 17:18:58 +0300
Message-Id: <1345558739-12562-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/qt1010.c | 40 +++++++++++++++++++---------------------
 1 file changed, 19 insertions(+), 21 deletions(-)

diff --git a/drivers/media/tuners/qt1010.c b/drivers/media/tuners/qt1010.c
index 74e7d4c..5fab622 100644
--- a/drivers/media/tuners/qt1010.c
+++ b/drivers/media/tuners/qt1010.c
@@ -21,15 +21,6 @@
 #include "qt1010.h"
 #include "qt1010_priv.h"
 
-static int debug;
-module_param(debug, int, 0644);
-MODULE_PARM_DESC(debug, "Turn on/off debugging (default:off).");
-
-#define dprintk(args...) \
-	do { \
-		if (debug) printk(KERN_DEBUG "QT1010: " args); \
-	} while (0)
-
 /* read single register */
 static int qt1010_readreg(struct qt1010_priv *priv, u8 reg, u8 *val)
 {
@@ -41,7 +32,8 @@ static int qt1010_readreg(struct qt1010_priv *priv, u8 reg, u8 *val)
 	};
 
 	if (i2c_transfer(priv->i2c, msg, 2) != 2) {
-		printk(KERN_WARNING "qt1010 I2C read failed\n");
+		dev_warn(&priv->i2c->dev, "%s: i2c rd failed reg=%02x\n",
+				KBUILD_MODNAME, reg);
 		return -EREMOTEIO;
 	}
 	return 0;
@@ -55,7 +47,8 @@ static int qt1010_writereg(struct qt1010_priv *priv, u8 reg, u8 val)
 			       .flags = 0, .buf = buf, .len = 2 };
 
 	if (i2c_transfer(priv->i2c, &msg, 1) != 1) {
-		printk(KERN_WARNING "qt1010 I2C write failed\n");
+		dev_warn(&priv->i2c->dev, "%s: i2c wr failed reg=%02x\n",
+				KBUILD_MODNAME, reg);
 		return -EREMOTEIO;
 	}
 	return 0;
@@ -229,12 +222,14 @@ static int qt1010_set_params(struct dvb_frontend *fe)
 	/* 00 */
 	rd[45].val = 0x92; /* TODO: correct value calculation */
 
-	dprintk("freq:%u 05:%02x 07:%02x 09:%02x 0a:%02x 0b:%02x " \
-		"1a:%02x 11:%02x 12:%02x 22:%02x 05:%02x 1f:%02x " \
-		"20:%02x 25:%02x 00:%02x", \
-		freq, rd[2].val, rd[4].val, rd[6].val, rd[7].val, rd[8].val, \
-		rd[10].val, rd[13].val, rd[14].val, rd[15].val, rd[35].val, \
-		rd[40].val, rd[41].val, rd[43].val, rd[45].val);
+	dev_dbg(&priv->i2c->dev,
+			"%s: freq:%u 05:%02x 07:%02x 09:%02x 0a:%02x 0b:%02x " \
+			"1a:%02x 11:%02x 12:%02x 22:%02x 05:%02x 1f:%02x " \
+			"20:%02x 25:%02x 00:%02x\n", __func__, \
+			freq, rd[2].val, rd[4].val, rd[6].val, rd[7].val, \
+			rd[8].val, rd[10].val, rd[13].val, rd[14].val, \
+			rd[15].val, rd[35].val, rd[40].val, rd[41].val, \
+			rd[43].val, rd[45].val);
 
 	for (i = 0; i < ARRAY_SIZE(rd); i++) {
 		if (rd[i].oper == QT1010_WR) {
@@ -245,8 +240,7 @@ static int qt1010_set_params(struct dvb_frontend *fe)
 		if (err) return err;
 	}
 
-	if (debug)
-		qt1010_dump_regs(priv);
+	qt1010_dump_regs(priv);
 
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 0); /* close i2c_gate */
@@ -281,7 +275,8 @@ static int qt1010_init_meas1(struct qt1010_priv *priv,
 		val1 = val2;
 		err = qt1010_readreg(priv, reg, &val2);
 		if (err) return err;
-		dprintk("compare reg:%02x %02x %02x", reg, val1, val2);
+		dev_dbg(&priv->i2c->dev, "%s: compare reg:%02x %02x %02x\n",
+				__func__, reg, val1, val2);
 	} while (val1 != val2);
 	*retval = val1;
 
@@ -465,7 +460,10 @@ struct dvb_frontend * qt1010_attach(struct dvb_frontend *fe,
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 0); /* close i2c_gate */
 
-	printk(KERN_INFO "Quantek QT1010 successfully identified.\n");
+	dev_info(&priv->i2c->dev,
+			"%s: Quantek QT1010 successfully identified\n",
+			KBUILD_MODNAME);
+
 	memcpy(&fe->ops.tuner_ops, &qt1010_tuner_ops,
 	       sizeof(struct dvb_tuner_ops));
 
-- 
1.7.11.4

