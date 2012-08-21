Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38806 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757892Ab2HUQNL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Aug 2012 12:13:11 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/2] tda18218: switch to Kernel logging
Date: Tue, 21 Aug 2012 19:12:49 +0300
Message-Id: <1345565570-30887-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/tda18218.c      | 28 ++++++++++++++--------------
 drivers/media/tuners/tda18218_priv.h | 13 +------------
 2 files changed, 15 insertions(+), 26 deletions(-)

diff --git a/drivers/media/tuners/tda18218.c b/drivers/media/tuners/tda18218.c
index 8a6f9ca..ffbec9e 100644
--- a/drivers/media/tuners/tda18218.c
+++ b/drivers/media/tuners/tda18218.c
@@ -18,13 +18,8 @@
  *    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#include "tda18218.h"
 #include "tda18218_priv.h"
 
-static int debug;
-module_param(debug, int, 0644);
-MODULE_PARM_DESC(debug, "Turn on/off debugging (default:off).");
-
 /* write multiple registers */
 static int tda18218_wr_regs(struct tda18218_priv *priv, u8 reg, u8 *val, u8 len)
 {
@@ -58,7 +53,8 @@ static int tda18218_wr_regs(struct tda18218_priv *priv, u8 reg, u8 *val, u8 len)
 	if (ret == 1) {
 		ret = 0;
 	} else {
-		warn("i2c wr failed ret:%d reg:%02x len:%d", ret, reg, len);
+		dev_warn(&priv->i2c->dev, "%s: i2c wr failed=%d reg=%02x " \
+				"len=%d\n", KBUILD_MODNAME, ret, reg, len);
 		ret = -EREMOTEIO;
 	}
 
@@ -89,7 +85,8 @@ static int tda18218_rd_regs(struct tda18218_priv *priv, u8 reg, u8 *val, u8 len)
 		memcpy(val, &buf[reg], len);
 		ret = 0;
 	} else {
-		warn("i2c rd failed ret:%d reg:%02x len:%d", ret, reg, len);
+		dev_warn(&priv->i2c->dev, "%s: i2c rd failed=%d reg=%02x " \
+				"len=%d\n", KBUILD_MODNAME, ret, reg, len);
 		ret = -EREMOTEIO;
 	}
 
@@ -199,7 +196,7 @@ error:
 		fe->ops.i2c_gate_ctrl(fe, 0); /* close I2C-gate */
 
 	if (ret)
-		dbg("%s: failed ret:%d", __func__, ret);
+		dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
@@ -208,7 +205,7 @@ static int tda18218_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
 {
 	struct tda18218_priv *priv = fe->tuner_priv;
 	*frequency = priv->if_frequency;
-	dbg("%s: if=%d", __func__, *frequency);
+	dev_dbg(&priv->i2c->dev, "%s: if_frequency=%d\n", __func__, *frequency);
 	return 0;
 }
 
@@ -227,7 +224,7 @@ static int tda18218_sleep(struct dvb_frontend *fe)
 		fe->ops.i2c_gate_ctrl(fe, 0); /* close I2C-gate */
 
 	if (ret)
-		dbg("%s: failed ret:%d", __func__, ret);
+		dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
@@ -248,7 +245,7 @@ static int tda18218_init(struct dvb_frontend *fe)
 		fe->ops.i2c_gate_ctrl(fe, 0); /* close I2C-gate */
 
 	if (ret)
-		dbg("%s: failed ret:%d", __func__, ret);
+		dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
@@ -307,13 +304,16 @@ struct dvb_frontend *tda18218_attach(struct dvb_frontend *fe,
 
 	/* check if the tuner is there */
 	ret = tda18218_rd_reg(priv, R00_ID, &val);
-	dbg("%s: ret:%d chip ID:%02x", __func__, ret, val);
+	dev_dbg(&priv->i2c->dev, "%s: ret=%d chip id=%02x\n", __func__, ret,
+			val);
 	if (ret || val != def_regs[R00_ID]) {
 		kfree(priv);
 		return NULL;
 	}
 
-	info("NXP TDA18218HN successfully identified.");
+	dev_info(&priv->i2c->dev,
+			"%s: NXP TDA18218HN successfully identified\n",
+			KBUILD_MODNAME);
 
 	memcpy(&fe->ops.tuner_ops, &tda18218_tuner_ops,
 		sizeof(struct dvb_tuner_ops));
@@ -328,7 +328,7 @@ struct dvb_frontend *tda18218_attach(struct dvb_frontend *fe,
 	/* standby */
 	ret = tda18218_wr_reg(priv, R17_PD1, priv->regs[R17_PD1] | (1 << 0));
 	if (ret)
-		dbg("%s: failed ret:%d", __func__, ret);
+		dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 0); /* close I2C-gate */
diff --git a/drivers/media/tuners/tda18218_priv.h b/drivers/media/tuners/tda18218_priv.h
index dc52b72..285b773 100644
--- a/drivers/media/tuners/tda18218_priv.h
+++ b/drivers/media/tuners/tda18218_priv.h
@@ -21,18 +21,7 @@
 #ifndef TDA18218_PRIV_H
 #define TDA18218_PRIV_H
 
-#define LOG_PREFIX "tda18218"
-
-#undef dbg
-#define dbg(f, arg...) \
-	if (debug) \
-		printk(KERN_DEBUG   LOG_PREFIX": " f "\n" , ## arg)
-#undef err
-#define err(f, arg...)  printk(KERN_ERR     LOG_PREFIX": " f "\n" , ## arg)
-#undef info
-#define info(f, arg...) printk(KERN_INFO    LOG_PREFIX": " f "\n" , ## arg)
-#undef warn
-#define warn(f, arg...) printk(KERN_WARNING LOG_PREFIX": " f "\n" , ## arg)
+#include "tda18218.h"
 
 #define R00_ID         0x00	/* ID byte */
 #define R01_R1         0x01	/* Read byte 1 */
-- 
1.7.11.4

