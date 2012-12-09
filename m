Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60787 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758880Ab2LIT5M (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Dec 2012 14:57:12 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>, Hans-Frieder Vogt <hfvogt@gmx.net>
Subject: [PATCH RFC 11/17] fc0012: use Kernel dev_foo() logging
Date: Sun,  9 Dec 2012 21:56:22 +0200
Message-Id: <1355082988-6211-11-git-send-email-crope@iki.fi>
In-Reply-To: <1355082988-6211-1-git-send-email-crope@iki.fi>
References: <1355082988-6211-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cc: Hans-Frieder Vogt <hfvogt@gmx.net>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/fc0012-priv.h |  9 ---------
 drivers/media/tuners/fc0012.c      | 20 ++++++++++++++------
 drivers/media/tuners/fc0012.h      |  2 +-
 3 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/media/tuners/fc0012-priv.h b/drivers/media/tuners/fc0012-priv.h
index 3b98bf9..1a86ce1 100644
--- a/drivers/media/tuners/fc0012-priv.h
+++ b/drivers/media/tuners/fc0012-priv.h
@@ -21,15 +21,6 @@
 #ifndef _FC0012_PRIV_H_
 #define _FC0012_PRIV_H_
 
-#define LOG_PREFIX "fc0012"
-
-#undef err
-#define err(f, arg...)  printk(KERN_ERR     LOG_PREFIX": " f "\n" , ## arg)
-#undef info
-#define info(f, arg...) printk(KERN_INFO    LOG_PREFIX": " f "\n" , ## arg)
-#undef warn
-#define warn(f, arg...) printk(KERN_WARNING LOG_PREFIX": " f "\n" , ## arg)
-
 struct fc0012_priv {
 	struct i2c_adapter *i2c;
 	const struct fc0012_config *cfg;
diff --git a/drivers/media/tuners/fc0012.c b/drivers/media/tuners/fc0012.c
index feb1594..4491f06 100644
--- a/drivers/media/tuners/fc0012.c
+++ b/drivers/media/tuners/fc0012.c
@@ -29,7 +29,9 @@ static int fc0012_writereg(struct fc0012_priv *priv, u8 reg, u8 val)
 	};
 
 	if (i2c_transfer(priv->i2c, &msg, 1) != 1) {
-		err("I2C write reg failed, reg: %02x, val: %02x", reg, val);
+		dev_err(&priv->i2c->dev,
+			"%s: I2C write reg failed, reg: %02x, val: %02x\n",
+			KBUILD_MODNAME, reg, val);
 		return -EREMOTEIO;
 	}
 	return 0;
@@ -45,7 +47,9 @@ static int fc0012_readreg(struct fc0012_priv *priv, u8 reg, u8 *val)
 	};
 
 	if (i2c_transfer(priv->i2c, msg, 2) != 2) {
-		err("I2C read reg failed, reg: %02x", reg);
+		dev_err(&priv->i2c->dev,
+			"%s: I2C read reg failed, reg: %02x\n",
+			KBUILD_MODNAME, reg);
 		return -EREMOTEIO;
 	}
 	return 0;
@@ -119,7 +123,8 @@ static int fc0012_init(struct dvb_frontend *fe)
 		fe->ops.i2c_gate_ctrl(fe, 0); /* close I2C-gate */
 
 	if (ret)
-		err("fc0012_writereg failed: %d", ret);
+		dev_err(&priv->i2c->dev, "%s: fc0012_writereg failed: %d\n",
+				KBUILD_MODNAME, ret);
 
 	return ret;
 }
@@ -261,7 +266,8 @@ static int fc0012_set_params(struct dvb_frontend *fe)
 			break;
 		}
 	} else {
-		err("%s: modulation type not supported!", __func__);
+		dev_err(&priv->i2c->dev, "%s: modulation type not supported!\n",
+				KBUILD_MODNAME);
 		return -EINVAL;
 	}
 
@@ -323,7 +329,8 @@ exit:
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 0); /* close I2C-gate */
 	if (ret)
-		warn("%s: failed: %d", __func__, ret);
+		dev_warn(&priv->i2c->dev, "%s: %s failed: %d\n",
+				KBUILD_MODNAME, __func__, ret);
 	return ret;
 }
 
@@ -413,7 +420,8 @@ err:
 		fe->ops.i2c_gate_ctrl(fe, 0); /* close I2C-gate */
 exit:
 	if (ret)
-		warn("%s: failed: %d", __func__, ret);
+		dev_warn(&priv->i2c->dev, "%s: %s failed: %d\n",
+				KBUILD_MODNAME, __func__, ret);
 	return ret;
 }
 
diff --git a/drivers/media/tuners/fc0012.h b/drivers/media/tuners/fc0012.h
index 3fb53b8..54508fc 100644
--- a/drivers/media/tuners/fc0012.h
+++ b/drivers/media/tuners/fc0012.h
@@ -58,7 +58,7 @@ static inline struct dvb_frontend *fc0012_attach(struct dvb_frontend *fe,
 					struct i2c_adapter *i2c,
 					const struct fc0012_config *cfg)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
+	pr_warn("%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif
-- 
1.7.11.7

