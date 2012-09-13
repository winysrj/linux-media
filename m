Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39514 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756439Ab2IMAY0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Sep 2012 20:24:26 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 05/16] hd29l2: use Kernel dev_foo() logging
Date: Thu, 13 Sep 2012 03:23:46 +0300
Message-Id: <1347495837-3244-5-git-send-email-crope@iki.fi>
In-Reply-To: <1347495837-3244-1-git-send-email-crope@iki.fi>
References: <1347495837-3244-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/hd29l2.c      | 75 ++++++++++++++++---------------
 drivers/media/dvb-frontends/hd29l2.h      |  2 +-
 drivers/media/dvb-frontends/hd29l2_priv.h | 13 ------
 3 files changed, 41 insertions(+), 49 deletions(-)

diff --git a/drivers/media/dvb-frontends/hd29l2.c b/drivers/media/dvb-frontends/hd29l2.c
index a003181..d7b9d54 100644
--- a/drivers/media/dvb-frontends/hd29l2.c
+++ b/drivers/media/dvb-frontends/hd29l2.c
@@ -22,10 +22,6 @@
 
 #include "hd29l2_priv.h"
 
-int hd29l2_debug;
-module_param_named(debug, hd29l2_debug, int, 0644);
-MODULE_PARM_DESC(debug, "Turn on/off frontend debugging (default:off).");
-
 /* write multiple registers */
 static int hd29l2_wr_regs(struct hd29l2_priv *priv, u8 reg, u8 *val, int len)
 {
@@ -48,7 +44,9 @@ static int hd29l2_wr_regs(struct hd29l2_priv *priv, u8 reg, u8 *val, int len)
 	if (ret == 1) {
 		ret = 0;
 	} else {
-		warn("i2c wr failed=%d reg=%02x len=%d", ret, reg, len);
+		dev_warn(&priv->i2c->dev,
+				"%s: i2c wr failed=%d reg=%02x len=%d\n",
+				KBUILD_MODNAME, ret, reg, len);
 		ret = -EREMOTEIO;
 	}
 
@@ -78,7 +76,9 @@ static int hd29l2_rd_regs(struct hd29l2_priv *priv, u8 reg, u8 *val, int len)
 	if (ret == 2) {
 		ret = 0;
 	} else {
-		warn("i2c rd failed=%d reg=%02x len=%d", ret, reg, len);
+		dev_warn(&priv->i2c->dev,
+				"%s: i2c rd failed=%d reg=%02x len=%d\n",
+				KBUILD_MODNAME, ret, reg, len);
 		ret = -EREMOTEIO;
 	}
 
@@ -160,7 +160,7 @@ static int hd29l2_soft_reset(struct hd29l2_priv *priv)
 
 	return 0;
 err:
-	dbg("%s: failed=%d", __func__, ret);
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -170,7 +170,7 @@ static int hd29l2_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 	struct hd29l2_priv *priv = fe->demodulator_priv;
 	u8 tmp;
 
-	dbg("%s: enable=%d", __func__, enable);
+	dev_dbg(&priv->i2c->dev, "%s: enable=%d\n", __func__, enable);
 
 	/* set tuner address for demod */
 	if (!priv->tuner_i2c_addr_programmed && enable) {
@@ -199,11 +199,11 @@ static int hd29l2_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 		usleep_range(5000, 10000);
 	}
 
-	dbg("%s: loop=%d", __func__, i);
+	dev_dbg(&priv->i2c->dev, "%s: loop=%d\n", __func__, i);
 
 	return ret;
 err:
-	dbg("%s: failed=%d", __func__, ret);
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -238,7 +238,7 @@ static int hd29l2_read_status(struct dvb_frontend *fe, fe_status_t *status)
 
 	return 0;
 err:
-	dbg("%s: failed=%d", __func__, ret);
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -270,7 +270,7 @@ static int hd29l2_read_snr(struct dvb_frontend *fe, u16 *snr)
 
 	return 0;
 err:
-	dbg("%s: failed=%d", __func__, ret);
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -295,7 +295,7 @@ static int hd29l2_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
 
 	return 0;
 err:
-	dbg("%s: failed=%d", __func__, ret);
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -322,7 +322,7 @@ static int hd29l2_read_ber(struct dvb_frontend *fe, u32 *ber)
 
 	return 0;
 err:
-	dbg("%s: failed=%d", __func__, ret);
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -344,11 +344,12 @@ static enum dvbfe_search hd29l2_search(struct dvb_frontend *fe)
 	u32 if_freq, if_ctl;
 	bool auto_mode;
 
-	dbg("%s: delivery_system=%d frequency=%d bandwidth_hz=%d " \
-		"modulation=%d inversion=%d fec_inner=%d guard_interval=%d",
-		 __func__,
-		c->delivery_system, c->frequency, c->bandwidth_hz,
-		c->modulation, c->inversion, c->fec_inner, c->guard_interval);
+	dev_dbg(&priv->i2c->dev, "%s: delivery_system=%d frequency=%d " \
+			"bandwidth_hz=%d modulation=%d inversion=%d " \
+			"fec_inner=%d guard_interval=%d\n", __func__,
+			c->delivery_system, c->frequency, c->bandwidth_hz,
+			c->modulation, c->inversion, c->fec_inner,
+			c->guard_interval);
 
 	/* as for now we detect always params automatically */
 	auto_mode = true;
@@ -394,7 +395,8 @@ static enum dvbfe_search hd29l2_search(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	dbg("%s: if_freq=%d if_ctl=%x", __func__, if_freq, if_ctl);
+	dev_dbg(&priv->i2c->dev, "%s: if_freq=%d if_ctl=%x\n",
+			__func__, if_freq, if_ctl);
 
 	if (auto_mode) {
 		/*
@@ -437,7 +439,7 @@ static enum dvbfe_search hd29l2_search(struct dvb_frontend *fe)
 				break;
 		}
 
-		dbg("%s: loop=%d", __func__, i);
+		dev_dbg(&priv->i2c->dev, "%s: loop=%d\n", __func__, i);
 
 		if (i == 0)
 			/* detection failed */
@@ -477,7 +479,8 @@ static enum dvbfe_search hd29l2_search(struct dvb_frontend *fe)
 	/* ensure modulation validy */
 	/* 0=QAM4_NR, 1=QAM4, 2=QAM16, 3=QAM32, 4=QAM64 */
 	if (modulation > (ARRAY_SIZE(reg_mod_vals_tab[0].val) - 1)) {
-		dbg("%s: modulation=%d not valid", __func__, modulation);
+		dev_dbg(&priv->i2c->dev, "%s: modulation=%d not valid\n",
+				__func__, modulation);
 		goto err;
 	}
 
@@ -499,12 +502,14 @@ static enum dvbfe_search hd29l2_search(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	dbg("%s: modulation=%d guard_interval=%d carrier=%d",
-		__func__, modulation, guard_interval, carrier);
+	dev_dbg(&priv->i2c->dev,
+			"%s: modulation=%d guard_interval=%d carrier=%d\n",
+			__func__, modulation, guard_interval, carrier);
 
 	if ((carrier == HD29L2_CARRIER_MULTI) && (modulation == HD29L2_QAM64) &&
 		(guard_interval == HD29L2_PN945)) {
-		dbg("%s: C=3780 && QAM64 && PN945", __func__);
+		dev_dbg(&priv->i2c->dev, "%s: C=3780 && QAM64 && PN945\n",
+				__func__);
 
 		ret = hd29l2_wr_reg(priv, 0x42, 0x33);
 		if (ret)
@@ -535,14 +540,14 @@ static enum dvbfe_search hd29l2_search(struct dvb_frontend *fe)
 			break;
 	}
 
-	dbg("%s: loop=%d", __func__, i);
+	dev_dbg(&priv->i2c->dev, "%s: loop=%d\n", __func__, i);
 
 	if (i == 0)
 		return DVBFE_ALGO_SEARCH_AGAIN;
 
 	return DVBFE_ALGO_SEARCH_SUCCESS;
 err:
-	dbg("%s: failed=%d", __func__, ret);
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return DVBFE_ALGO_SEARCH_ERROR;
 }
 
@@ -704,14 +709,14 @@ static int hd29l2_get_frontend(struct dvb_frontend *fe)
 
 	if_ctl = (buf[0] << 16) | ((buf[1] - 7) << 8) | buf[2];
 
-	dbg("%s: %s %s %s | %s %s %s | %s %s | NCO=%06x", __func__,
-		str_constellation, str_code_rate, str_constellation_code_rate,
-		str_guard_interval, str_carrier, str_guard_interval_carrier,
-		str_interleave, str_interleave_, if_ctl);
-
+	dev_dbg(&priv->i2c->dev, "%s: %s %s %s | %s %s %s | %s %s | NCO=%06x\n",
+			__func__, str_constellation, str_code_rate,
+			str_constellation_code_rate, str_guard_interval,
+			str_carrier, str_guard_interval_carrier, str_interleave,
+			str_interleave_, if_ctl);
 	return 0;
 err:
-	dbg("%s: failed=%d", __func__, ret);
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -730,7 +735,7 @@ static int hd29l2_init(struct dvb_frontend *fe)
 		{ 0x10, 0x38 },
 	};
 
-	dbg("%s:", __func__);
+	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
 
 	/* reset demod */
 	/* it is recommended to HW reset chip using RST_N pin */
@@ -774,7 +779,7 @@ static int hd29l2_init(struct dvb_frontend *fe)
 
 	return ret;
 err:
-	dbg("%s: failed=%d", __func__, ret);
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
diff --git a/drivers/media/dvb-frontends/hd29l2.h b/drivers/media/dvb-frontends/hd29l2.h
index a7a6443..4ad00d7 100644
--- a/drivers/media/dvb-frontends/hd29l2.h
+++ b/drivers/media/dvb-frontends/hd29l2.h
@@ -58,7 +58,7 @@ extern struct dvb_frontend *hd29l2_attach(const struct hd29l2_config *config,
 static inline struct dvb_frontend *hd29l2_attach(
 const struct hd29l2_config *config, struct i2c_adapter *i2c)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
+	pr_warn("%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif
diff --git a/drivers/media/dvb-frontends/hd29l2_priv.h b/drivers/media/dvb-frontends/hd29l2_priv.h
index ba16dc3..4d571a2 100644
--- a/drivers/media/dvb-frontends/hd29l2_priv.h
+++ b/drivers/media/dvb-frontends/hd29l2_priv.h
@@ -28,19 +28,6 @@
 #include "dvb_math.h"
 #include "hd29l2.h"
 
-#define LOG_PREFIX "hd29l2"
-
-#undef dbg
-#define dbg(f, arg...) \
-	if (hd29l2_debug) \
-		printk(KERN_INFO   LOG_PREFIX": " f "\n" , ## arg)
-#undef err
-#define err(f, arg...)  printk(KERN_ERR     LOG_PREFIX": " f "\n" , ## arg)
-#undef info
-#define info(f, arg...) printk(KERN_INFO    LOG_PREFIX": " f "\n" , ## arg)
-#undef warn
-#define warn(f, arg...) printk(KERN_WARNING LOG_PREFIX": " f "\n" , ## arg)
-
 #define HD29L2_XTAL 30400000 /* Hz */
 
 
-- 
1.7.11.4

