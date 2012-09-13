Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59444 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756528Ab2IMAY0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Sep 2012 20:24:26 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 06/16] rtl2830: use Kernel dev_foo() logging
Date: Thu, 13 Sep 2012 03:23:47 +0300
Message-Id: <1347495837-3244-6-git-send-email-crope@iki.fi>
In-Reply-To: <1347495837-3244-1-git-send-email-crope@iki.fi>
References: <1347495837-3244-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2830.c      | 46 ++++++++++++++++--------------
 drivers/media/dvb-frontends/rtl2830.h      |  2 +-
 drivers/media/dvb-frontends/rtl2830_priv.h | 13 ---------
 3 files changed, 25 insertions(+), 36 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2830.c b/drivers/media/dvb-frontends/rtl2830.c
index b6ab858..5f53d0c 100644
--- a/drivers/media/dvb-frontends/rtl2830.c
+++ b/drivers/media/dvb-frontends/rtl2830.c
@@ -27,10 +27,6 @@
 
 #include "rtl2830_priv.h"
 
-int rtl2830_debug;
-module_param_named(debug, rtl2830_debug, int, 0644);
-MODULE_PARM_DESC(debug, "Turn on/off frontend debugging (default:off).");
-
 /* write multiple hardware registers */
 static int rtl2830_wr(struct rtl2830_priv *priv, u8 reg, u8 *val, int len)
 {
@@ -52,7 +48,8 @@ static int rtl2830_wr(struct rtl2830_priv *priv, u8 reg, u8 *val, int len)
 	if (ret == 1) {
 		ret = 0;
 	} else {
-		warn("i2c wr failed=%d reg=%02x len=%d", ret, reg, len);
+		dev_warn(&priv->i2c->dev, "%s: i2c wr failed=%d reg=%02x " \
+				"len=%d\n", KBUILD_MODNAME, ret, reg, len);
 		ret = -EREMOTEIO;
 	}
 	return ret;
@@ -80,7 +77,8 @@ static int rtl2830_rd(struct rtl2830_priv *priv, u8 reg, u8 *val, int len)
 	if (ret == 2) {
 		ret = 0;
 	} else {
-		warn("i2c rd failed=%d reg=%02x len=%d", ret, reg, len);
+		dev_warn(&priv->i2c->dev, "%s: i2c rd failed=%d reg=%02x " \
+				"len=%d\n", KBUILD_MODNAME, ret, reg, len);
 		ret = -EREMOTEIO;
 	}
 	return ret;
@@ -247,7 +245,7 @@ static int rtl2830_init(struct dvb_frontend *fe)
 	num = div_u64(num, priv->cfg.xtal);
 	num = -num;
 	if_ctl = num & 0x3fffff;
-	dbg("%s: if_ctl=%08x", __func__, if_ctl);
+	dev_dbg(&priv->i2c->dev, "%s: if_ctl=%08x\n", __func__, if_ctl);
 
 	ret = rtl2830_rd_reg_mask(priv, 0x119, &tmp, 0xc0); /* b[7:6] */
 	if (ret)
@@ -277,7 +275,7 @@ static int rtl2830_init(struct dvb_frontend *fe)
 
 	return ret;
 err:
-	dbg("%s: failed=%d", __func__, ret);
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -328,8 +326,9 @@ static int rtl2830_set_frontend(struct dvb_frontend *fe)
 	};
 
 
-	dbg("%s: frequency=%d bandwidth_hz=%d inversion=%d", __func__,
-		c->frequency, c->bandwidth_hz, c->inversion);
+	dev_dbg(&priv->i2c->dev,
+			"%s: frequency=%d bandwidth_hz=%d inversion=%d\n",
+			__func__, c->frequency, c->bandwidth_hz, c->inversion);
 
 	/* program tuner */
 	if (fe->ops.tuner_ops.set_params)
@@ -346,7 +345,7 @@ static int rtl2830_set_frontend(struct dvb_frontend *fe)
 		i = 2;
 		break;
 	default:
-		dbg("invalid bandwidth");
+		dev_dbg(&priv->i2c->dev, "%s: invalid bandwidth\n", __func__);
 		return -EINVAL;
 	}
 
@@ -370,7 +369,7 @@ static int rtl2830_set_frontend(struct dvb_frontend *fe)
 
 	return ret;
 err:
-	dbg("%s: failed=%d", __func__, ret);
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -392,7 +391,7 @@ static int rtl2830_get_frontend(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	dbg("%s: TPS=%*ph", __func__, 3, buf);
+	dev_dbg(&priv->i2c->dev, "%s: TPS=%*ph\n", __func__, 3, buf);
 
 	switch ((buf[0] >> 2) & 3) {
 	case 0:
@@ -482,7 +481,7 @@ static int rtl2830_get_frontend(struct dvb_frontend *fe)
 
 	return 0;
 err:
-	dbg("%s: failed=%d", __func__, ret);
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -510,7 +509,7 @@ static int rtl2830_read_status(struct dvb_frontend *fe, fe_status_t *status)
 
 	return ret;
 err:
-	dbg("%s: failed=%d", __func__, ret);
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -559,7 +558,7 @@ static int rtl2830_read_snr(struct dvb_frontend *fe, u16 *snr)
 
 	return 0;
 err:
-	dbg("%s: failed=%d", __func__, ret);
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -580,7 +579,7 @@ static int rtl2830_read_ber(struct dvb_frontend *fe, u32 *ber)
 
 	return 0;
 err:
-	dbg("%s: failed=%d", __func__, ret);
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -616,7 +615,7 @@ static int rtl2830_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
 
 	return 0;
 err:
-	dbg("%s: failed=%d", __func__, ret);
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -640,11 +639,12 @@ static int rtl2830_tuner_i2c_xfer(struct i2c_adapter *i2c_adap,
 
 	ret = i2c_transfer(priv->i2c, msg, num);
 	if (ret < 0)
-		warn("tuner i2c failed=%d", ret);
+		dev_warn(&priv->i2c->dev, "%s: tuner i2c failed=%d\n",
+			KBUILD_MODNAME, ret);
 
 	return ret;
 err:
-	dbg("%s: failed=%d", __func__, ret);
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -700,7 +700,9 @@ struct dvb_frontend *rtl2830_attach(const struct rtl2830_config *cfg,
 	priv->tuner_i2c_adapter.algo_data = NULL;
 	i2c_set_adapdata(&priv->tuner_i2c_adapter, priv);
 	if (i2c_add_adapter(&priv->tuner_i2c_adapter) < 0) {
-		err("tuner I2C bus could not be initialized");
+		dev_err(&i2c->dev,
+				"%s: tuner i2c bus could not be initialized\n",
+				KBUILD_MODNAME);
 		goto err;
 	}
 
@@ -708,7 +710,7 @@ struct dvb_frontend *rtl2830_attach(const struct rtl2830_config *cfg,
 
 	return &priv->fe;
 err:
-	dbg("%s: failed=%d", __func__, ret);
+	dev_dbg(&i2c->dev, "%s: failed=%d\n", __func__, ret);
 	kfree(priv);
 	return NULL;
 }
diff --git a/drivers/media/dvb-frontends/rtl2830.h b/drivers/media/dvb-frontends/rtl2830.h
index 1c6ee91..e125166 100644
--- a/drivers/media/dvb-frontends/rtl2830.h
+++ b/drivers/media/dvb-frontends/rtl2830.h
@@ -82,7 +82,7 @@ static inline struct dvb_frontend *rtl2830_attach(
 	struct i2c_adapter *i2c
 )
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
+	pr_warn("%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 
diff --git a/drivers/media/dvb-frontends/rtl2830_priv.h b/drivers/media/dvb-frontends/rtl2830_priv.h
index 9b20557..fab10ec 100644
--- a/drivers/media/dvb-frontends/rtl2830_priv.h
+++ b/drivers/media/dvb-frontends/rtl2830_priv.h
@@ -25,19 +25,6 @@
 #include "dvb_math.h"
 #include "rtl2830.h"
 
-#define LOG_PREFIX "rtl2830"
-
-#undef dbg
-#define dbg(f, arg...) \
-	if (rtl2830_debug) \
-		printk(KERN_INFO            LOG_PREFIX": " f "\n" , ## arg)
-#undef err
-#define err(f, arg...)  printk(KERN_ERR     LOG_PREFIX": " f "\n" , ## arg)
-#undef info
-#define info(f, arg...) printk(KERN_INFO    LOG_PREFIX": " f "\n" , ## arg)
-#undef warn
-#define warn(f, arg...) printk(KERN_WARNING LOG_PREFIX": " f "\n" , ## arg)
-
 struct rtl2830_priv {
 	struct i2c_adapter *i2c;
 	struct dvb_frontend fe;
-- 
1.7.11.4

