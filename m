Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54028 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757626Ab2HQBft (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 21:35:49 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/6] cxd2820r: switch to Kernel dev_* logging
Date: Fri, 17 Aug 2012 04:35:06 +0300
Message-Id: <1345167310-8738-3-git-send-email-crope@iki.fi>
In-Reply-To: <1345167310-8738-1-git-send-email-crope@iki.fi>
References: <1345167310-8738-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/cxd2820r_c.c    | 26 ++++-----
 drivers/media/dvb-frontends/cxd2820r_core.c | 84 ++++++++++++++++++++---------
 drivers/media/dvb-frontends/cxd2820r_priv.h | 13 -----
 drivers/media/dvb-frontends/cxd2820r_t.c    | 28 +++++-----
 drivers/media/dvb-frontends/cxd2820r_t2.c   | 26 ++++-----
 5 files changed, 101 insertions(+), 76 deletions(-)

diff --git a/drivers/media/dvb-frontends/cxd2820r_c.c b/drivers/media/dvb-frontends/cxd2820r_c.c
index ed3b0ba6..d2a0c28 100644
--- a/drivers/media/dvb-frontends/cxd2820r_c.c
+++ b/drivers/media/dvb-frontends/cxd2820r_c.c
@@ -47,7 +47,8 @@ int cxd2820r_set_frontend_c(struct dvb_frontend *fe)
 		{ 0x10070, priv->cfg.ts_mode, 0xff },
 	};
 
-	dbg("%s: RF=%d SR=%d", __func__, c->frequency, c->symbol_rate);
+	dev_dbg(&priv->i2c->dev, "%s: frequency=%d symbol_rate=%d\n", __func__,
+			c->frequency, c->symbol_rate);
 
 	/* update GPIOs */
 	ret = cxd2820r_gpio(fe);
@@ -78,7 +79,7 @@ int cxd2820r_set_frontend_c(struct dvb_frontend *fe)
 	} else
 		if_freq = 0;
 
-	dbg("%s: if_freq=%d", __func__, if_freq);
+	dev_dbg(&priv->i2c->dev, "%s: if_freq=%d\n", __func__, if_freq);
 
 	num = if_freq / 1000; /* Hz => kHz */
 	num *= 0x4000;
@@ -100,7 +101,7 @@ int cxd2820r_set_frontend_c(struct dvb_frontend *fe)
 
 	return ret;
 error:
-	dbg("%s: failed:%d", __func__, ret);
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -150,7 +151,7 @@ int cxd2820r_get_frontend_c(struct dvb_frontend *fe)
 
 	return ret;
 error:
-	dbg("%s: failed:%d", __func__, ret);
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -184,7 +185,7 @@ int cxd2820r_read_ber_c(struct dvb_frontend *fe, u32 *ber)
 
 	return ret;
 error:
-	dbg("%s: failed:%d", __func__, ret);
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -214,7 +215,7 @@ int cxd2820r_read_signal_strength_c(struct dvb_frontend *fe,
 
 	return ret;
 error:
-	dbg("%s: failed:%d", __func__, ret);
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -251,7 +252,7 @@ int cxd2820r_read_snr_c(struct dvb_frontend *fe, u16 *snr)
 
 	return ret;
 error:
-	dbg("%s: failed:%d", __func__, ret);
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -283,11 +284,12 @@ int cxd2820r_read_status_c(struct dvb_frontend *fe, fe_status_t *status)
 		}
 	}
 
-	dbg("%s: lock=%02x %02x", __func__, buf[0], buf[1]);
+	dev_dbg(&priv->i2c->dev, "%s: lock=%02x %02x\n", __func__, buf[0],
+			buf[1]);
 
 	return ret;
 error:
-	dbg("%s: failed:%d", __func__, ret);
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -302,7 +304,7 @@ int cxd2820r_init_c(struct dvb_frontend *fe)
 
 	return ret;
 error:
-	dbg("%s: failed:%d", __func__, ret);
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -318,7 +320,7 @@ int cxd2820r_sleep_c(struct dvb_frontend *fe)
 		{ 0x00080, 0x00, 0xff },
 	};
 
-	dbg("%s", __func__);
+	dev_dbg(&priv->i2c->dev, "%s\n", __func__);
 
 	priv->delivery_system = SYS_UNDEFINED;
 
@@ -331,7 +333,7 @@ int cxd2820r_sleep_c(struct dvb_frontend *fe)
 
 	return ret;
 error:
-	dbg("%s: failed:%d", __func__, ret);
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
diff --git a/drivers/media/dvb-frontends/cxd2820r_core.c b/drivers/media/dvb-frontends/cxd2820r_core.c
index 3bba37d..a3656ba 100644
--- a/drivers/media/dvb-frontends/cxd2820r_core.c
+++ b/drivers/media/dvb-frontends/cxd2820r_core.c
@@ -21,10 +21,6 @@
 
 #include "cxd2820r_priv.h"
 
-int cxd2820r_debug;
-module_param_named(debug, cxd2820r_debug, int, 0644);
-MODULE_PARM_DESC(debug, "Turn on/off frontend debugging (default:off).");
-
 /* write multiple registers */
 static int cxd2820r_wr_regs_i2c(struct cxd2820r_priv *priv, u8 i2c, u8 reg,
 	u8 *val, int len)
@@ -47,7 +43,8 @@ static int cxd2820r_wr_regs_i2c(struct cxd2820r_priv *priv, u8 i2c, u8 reg,
 	if (ret == 1) {
 		ret = 0;
 	} else {
-		warn("i2c wr failed ret:%d reg:%02x len:%d", ret, reg, len);
+		dev_warn(&priv->i2c->dev, "%s: i2c wr failed=%d reg=%02x " \
+				"len=%d\n", KBUILD_MODNAME, ret, reg, len);
 		ret = -EREMOTEIO;
 	}
 	return ret;
@@ -78,7 +75,8 @@ static int cxd2820r_rd_regs_i2c(struct cxd2820r_priv *priv, u8 i2c, u8 reg,
 		memcpy(val, buf, len);
 		ret = 0;
 	} else {
-		warn("i2c rd failed ret:%d reg:%02x len:%d", ret, reg, len);
+		dev_warn(&priv->i2c->dev, "%s: i2c rd failed=%d reg=%02x " \
+				"len=%d\n", KBUILD_MODNAME, ret, reg, len);
 		ret = -EREMOTEIO;
 	}
 
@@ -175,7 +173,9 @@ int cxd2820r_gpio(struct dvb_frontend *fe)
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
 	int ret, i;
 	u8 *gpio, tmp0, tmp1;
-	dbg("%s: delsys=%d", __func__, fe->dtv_property_cache.delivery_system);
+
+	dev_dbg(&priv->i2c->dev, "%s: delsys=%d\n", __func__,
+			fe->dtv_property_cache.delivery_system);
 
 	switch (fe->dtv_property_cache.delivery_system) {
 	case SYS_DVBT:
@@ -217,10 +217,12 @@ int cxd2820r_gpio(struct dvb_frontend *fe)
 		else
 			tmp1 |= (0 << (0 + i));
 
-		dbg("%s: GPIO i=%d %02x %02x", __func__, i, tmp0, tmp1);
+		dev_dbg(&priv->i2c->dev, "%s: gpio i=%d %02x %02x\n", __func__,
+				i, tmp0, tmp1);
 	}
 
-	dbg("%s: wr gpio=%02x %02x", __func__, tmp0, tmp1);
+	dev_dbg(&priv->i2c->dev, "%s: wr gpio=%02x %02x\n", __func__, tmp0,
+			tmp1);
 
 	/* write bits [7:2] */
 	ret = cxd2820r_wr_reg_mask(priv, 0x00089, tmp0, 0xfc);
@@ -236,7 +238,7 @@ int cxd2820r_gpio(struct dvb_frontend *fe)
 
 	return ret;
 error:
-	dbg("%s: failed:%d", __func__, ret);
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -248,10 +250,13 @@ u32 cxd2820r_div_u64_round_closest(u64 dividend, u32 divisor)
 
 static int cxd2820r_set_frontend(struct dvb_frontend *fe)
 {
+	struct cxd2820r_priv *priv = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
 
-	dbg("%s: delsys=%d", __func__, fe->dtv_property_cache.delivery_system);
+	dev_dbg(&priv->i2c->dev, "%s: delsys=%d\n", __func__,
+			fe->dtv_property_cache.delivery_system);
+
 	switch (c->delivery_system) {
 	case SYS_DVBT:
 		ret = cxd2820r_init_t(fe);
@@ -278,7 +283,8 @@ static int cxd2820r_set_frontend(struct dvb_frontend *fe)
 			goto err;
 		break;
 	default:
-		dbg("%s: error state=%d", __func__, fe->dtv_property_cache.delivery_system);
+		dev_dbg(&priv->i2c->dev, "%s: error state=%d\n", __func__,
+				fe->dtv_property_cache.delivery_system);
 		ret = -EINVAL;
 		break;
 	}
@@ -287,9 +293,12 @@ err:
 }
 static int cxd2820r_read_status(struct dvb_frontend *fe, fe_status_t *status)
 {
+	struct cxd2820r_priv *priv = fe->demodulator_priv;
 	int ret;
 
-	dbg("%s: delsys=%d", __func__, fe->dtv_property_cache.delivery_system);
+	dev_dbg(&priv->i2c->dev, "%s: delsys=%d\n", __func__,
+			fe->dtv_property_cache.delivery_system);
+
 	switch (fe->dtv_property_cache.delivery_system) {
 	case SYS_DVBT:
 		ret = cxd2820r_read_status_t(fe, status);
@@ -312,7 +321,8 @@ static int cxd2820r_get_frontend(struct dvb_frontend *fe)
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
 	int ret;
 
-	dbg("%s: delsys=%d", __func__, fe->dtv_property_cache.delivery_system);
+	dev_dbg(&priv->i2c->dev, "%s: delsys=%d\n", __func__,
+			fe->dtv_property_cache.delivery_system);
 
 	if (priv->delivery_system == SYS_UNDEFINED)
 		return 0;
@@ -336,9 +346,12 @@ static int cxd2820r_get_frontend(struct dvb_frontend *fe)
 
 static int cxd2820r_read_ber(struct dvb_frontend *fe, u32 *ber)
 {
+	struct cxd2820r_priv *priv = fe->demodulator_priv;
 	int ret;
 
-	dbg("%s: delsys=%d", __func__, fe->dtv_property_cache.delivery_system);
+	dev_dbg(&priv->i2c->dev, "%s: delsys=%d\n", __func__,
+			fe->dtv_property_cache.delivery_system);
+
 	switch (fe->dtv_property_cache.delivery_system) {
 	case SYS_DVBT:
 		ret = cxd2820r_read_ber_t(fe, ber);
@@ -358,9 +371,12 @@ static int cxd2820r_read_ber(struct dvb_frontend *fe, u32 *ber)
 
 static int cxd2820r_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
 {
+	struct cxd2820r_priv *priv = fe->demodulator_priv;
 	int ret;
 
-	dbg("%s: delsys=%d", __func__, fe->dtv_property_cache.delivery_system);
+	dev_dbg(&priv->i2c->dev, "%s: delsys=%d\n", __func__,
+			fe->dtv_property_cache.delivery_system);
+
 	switch (fe->dtv_property_cache.delivery_system) {
 	case SYS_DVBT:
 		ret = cxd2820r_read_signal_strength_t(fe, strength);
@@ -380,9 +396,12 @@ static int cxd2820r_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
 
 static int cxd2820r_read_snr(struct dvb_frontend *fe, u16 *snr)
 {
+	struct cxd2820r_priv *priv = fe->demodulator_priv;
 	int ret;
 
-	dbg("%s: delsys=%d", __func__, fe->dtv_property_cache.delivery_system);
+	dev_dbg(&priv->i2c->dev, "%s: delsys=%d\n", __func__,
+			fe->dtv_property_cache.delivery_system);
+
 	switch (fe->dtv_property_cache.delivery_system) {
 	case SYS_DVBT:
 		ret = cxd2820r_read_snr_t(fe, snr);
@@ -402,9 +421,12 @@ static int cxd2820r_read_snr(struct dvb_frontend *fe, u16 *snr)
 
 static int cxd2820r_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 {
+	struct cxd2820r_priv *priv = fe->demodulator_priv;
 	int ret;
 
-	dbg("%s: delsys=%d", __func__, fe->dtv_property_cache.delivery_system);
+	dev_dbg(&priv->i2c->dev, "%s: delsys=%d\n", __func__,
+			fe->dtv_property_cache.delivery_system);
+
 	switch (fe->dtv_property_cache.delivery_system) {
 	case SYS_DVBT:
 		ret = cxd2820r_read_ucblocks_t(fe, ucblocks);
@@ -429,9 +451,12 @@ static int cxd2820r_init(struct dvb_frontend *fe)
 
 static int cxd2820r_sleep(struct dvb_frontend *fe)
 {
+	struct cxd2820r_priv *priv = fe->demodulator_priv;
 	int ret;
 
-	dbg("%s: delsys=%d", __func__, fe->dtv_property_cache.delivery_system);
+	dev_dbg(&priv->i2c->dev, "%s: delsys=%d\n", __func__,
+			fe->dtv_property_cache.delivery_system);
+
 	switch (fe->dtv_property_cache.delivery_system) {
 	case SYS_DVBT:
 		ret = cxd2820r_sleep_t(fe);
@@ -452,9 +477,12 @@ static int cxd2820r_sleep(struct dvb_frontend *fe)
 static int cxd2820r_get_tune_settings(struct dvb_frontend *fe,
 				      struct dvb_frontend_tune_settings *s)
 {
+	struct cxd2820r_priv *priv = fe->demodulator_priv;
 	int ret;
 
-	dbg("%s: delsys=%d", __func__, fe->dtv_property_cache.delivery_system);
+	dev_dbg(&priv->i2c->dev, "%s: delsys=%d\n", __func__,
+			fe->dtv_property_cache.delivery_system);
+
 	switch (fe->dtv_property_cache.delivery_system) {
 	case SYS_DVBT:
 		ret = cxd2820r_get_tune_settings_t(fe, s);
@@ -478,7 +506,9 @@ static enum dvbfe_search cxd2820r_search(struct dvb_frontend *fe)
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, i;
 	fe_status_t status = 0;
-	dbg("%s: delsys=%d", __func__, fe->dtv_property_cache.delivery_system);
+
+	dev_dbg(&priv->i2c->dev, "%s: delsys=%d\n", __func__,
+			fe->dtv_property_cache.delivery_system);
 
 	/* switch between DVB-T and DVB-T2 when tune fails */
 	if (priv->last_tune_failed) {
@@ -520,7 +550,7 @@ static enum dvbfe_search cxd2820r_search(struct dvb_frontend *fe)
 
 	/* wait frontend lock */
 	for (; i > 0; i--) {
-		dbg("%s: LOOP=%d", __func__, i);
+		dev_dbg(&priv->i2c->dev, "%s: loop=%d\n", __func__, i);
 		msleep(50);
 		ret = cxd2820r_read_status(fe, &status);
 		if (ret)
@@ -540,7 +570,7 @@ static enum dvbfe_search cxd2820r_search(struct dvb_frontend *fe)
 	}
 
 error:
-	dbg("%s: failed:%d", __func__, ret);
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return DVBFE_ALGO_SEARCH_ERROR;
 }
 
@@ -552,7 +582,8 @@ static int cxd2820r_get_frontend_algo(struct dvb_frontend *fe)
 static void cxd2820r_release(struct dvb_frontend *fe)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
-	dbg("%s", __func__);
+
+	dev_dbg(&priv->i2c->dev, "%s\n", __func__);
 
 	kfree(priv);
 	return;
@@ -561,7 +592,8 @@ static void cxd2820r_release(struct dvb_frontend *fe)
 static int cxd2820r_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
-	dbg("%s: %d", __func__, enable);
+
+	dev_dbg(&priv->i2c->dev, "%s: %d\n", __func__, enable);
 
 	/* Bit 0 of reg 0xdb in bank 0x00 controls I2C repeater */
 	return cxd2820r_wr_reg_mask(priv, 0xdb, enable ? 1 : 0, 0x1);
@@ -628,7 +660,7 @@ struct dvb_frontend *cxd2820r_attach(const struct cxd2820r_config *cfg,
 
 	priv->bank[0] = priv->bank[1] = 0xff;
 	ret = cxd2820r_rd_reg(priv, 0x000fd, &tmp);
-	dbg("%s: chip id=%02x", __func__, tmp);
+	dev_dbg(&priv->i2c->dev, "%s: chip id=%02x\n", __func__, tmp);
 	if (ret || tmp != 0xe1)
 		goto error;
 
diff --git a/drivers/media/dvb-frontends/cxd2820r_priv.h b/drivers/media/dvb-frontends/cxd2820r_priv.h
index 9a9822c..9396492 100644
--- a/drivers/media/dvb-frontends/cxd2820r_priv.h
+++ b/drivers/media/dvb-frontends/cxd2820r_priv.h
@@ -27,19 +27,6 @@
 #include "dvb_math.h"
 #include "cxd2820r.h"
 
-#define LOG_PREFIX "cxd2820r"
-
-#undef dbg
-#define dbg(f, arg...) \
-	if (cxd2820r_debug) \
-		printk(KERN_INFO   LOG_PREFIX": " f "\n" , ## arg)
-#undef err
-#define err(f, arg...)  printk(KERN_ERR     LOG_PREFIX": " f "\n" , ## arg)
-#undef info
-#define info(f, arg...) printk(KERN_INFO    LOG_PREFIX": " f "\n" , ## arg)
-#undef warn
-#define warn(f, arg...) printk(KERN_WARNING LOG_PREFIX": " f "\n" , ## arg)
-
 struct reg_val_mask {
 	u32 reg;
 	u8  val;
diff --git a/drivers/media/dvb-frontends/cxd2820r_t.c b/drivers/media/dvb-frontends/cxd2820r_t.c
index e5dd22b..af5890e 100644
--- a/drivers/media/dvb-frontends/cxd2820r_t.c
+++ b/drivers/media/dvb-frontends/cxd2820r_t.c
@@ -54,7 +54,8 @@ int cxd2820r_set_frontend_t(struct dvb_frontend *fe)
 		{ 0x00427, 0x41, 0xff },
 	};
 
-	dbg("%s: RF=%d BW=%d", __func__, c->frequency, c->bandwidth_hz);
+	dev_dbg(&priv->i2c->dev, "%s: frequency=%d bandwidth_hz=%d\n", __func__,
+			c->frequency, c->bandwidth_hz);
 
 	switch (c->bandwidth_hz) {
 	case 6000000:
@@ -102,7 +103,7 @@ int cxd2820r_set_frontend_t(struct dvb_frontend *fe)
 	} else
 		if_freq = 0;
 
-	dbg("%s: if_freq=%d", __func__, if_freq);
+	dev_dbg(&priv->i2c->dev, "%s: if_freq=%d\n", __func__, if_freq);
 
 	num = if_freq / 1000; /* Hz => kHz */
 	num *= 0x1000000;
@@ -137,7 +138,7 @@ int cxd2820r_set_frontend_t(struct dvb_frontend *fe)
 
 	return ret;
 error:
-	dbg("%s: failed:%d", __func__, ret);
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -254,7 +255,7 @@ int cxd2820r_get_frontend_t(struct dvb_frontend *fe)
 
 	return ret;
 error:
-	dbg("%s: failed:%d", __func__, ret);
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -288,7 +289,7 @@ int cxd2820r_read_ber_t(struct dvb_frontend *fe, u32 *ber)
 
 	return ret;
 error:
-	dbg("%s: failed:%d", __func__, ret);
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -312,7 +313,7 @@ int cxd2820r_read_signal_strength_t(struct dvb_frontend *fe,
 
 	return ret;
 error:
-	dbg("%s: failed:%d", __func__, ret);
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -336,11 +337,12 @@ int cxd2820r_read_snr_t(struct dvb_frontend *fe, u16 *snr)
 	else
 		*snr = 0;
 
-	dbg("%s: dBx10=%d val=%04x", __func__, *snr, tmp);
+	dev_dbg(&priv->i2c->dev, "%s: dBx10=%d val=%04x\n", __func__, *snr,
+			tmp);
 
 	return ret;
 error:
-	dbg("%s: failed:%d", __func__, ret);
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -389,11 +391,11 @@ int cxd2820r_read_status_t(struct dvb_frontend *fe, fe_status_t *status)
 		}
 	}
 
-	dbg("%s: lock=%*ph", __func__, 4, buf);
+	dev_dbg(&priv->i2c->dev, "%s: lock=%*ph\n", __func__, 4, buf);
 
 	return ret;
 error:
-	dbg("%s: failed:%d", __func__, ret);
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -408,7 +410,7 @@ int cxd2820r_init_t(struct dvb_frontend *fe)
 
 	return ret;
 error:
-	dbg("%s: failed:%d", __func__, ret);
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -424,7 +426,7 @@ int cxd2820r_sleep_t(struct dvb_frontend *fe)
 		{ 0x00080, 0x00, 0xff },
 	};
 
-	dbg("%s", __func__);
+	dev_dbg(&priv->i2c->dev, "%s\n", __func__);
 
 	priv->delivery_system = SYS_UNDEFINED;
 
@@ -437,7 +439,7 @@ int cxd2820r_sleep_t(struct dvb_frontend *fe)
 
 	return ret;
 error:
-	dbg("%s: failed:%d", __func__, ret);
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
diff --git a/drivers/media/dvb-frontends/cxd2820r_t2.c b/drivers/media/dvb-frontends/cxd2820r_t2.c
index 3a5759e..653c56e 100644
--- a/drivers/media/dvb-frontends/cxd2820r_t2.c
+++ b/drivers/media/dvb-frontends/cxd2820r_t2.c
@@ -68,7 +68,8 @@ int cxd2820r_set_frontend_t2(struct dvb_frontend *fe)
 		{ 0x027ef, 0x10, 0x18 },
 	};
 
-	dbg("%s: RF=%d BW=%d", __func__, c->frequency, c->bandwidth_hz);
+	dev_dbg(&priv->i2c->dev, "%s: frequency=%d bandwidth_hz=%d\n", __func__,
+			c->frequency, c->bandwidth_hz);
 
 	switch (c->bandwidth_hz) {
 	case 5000000:
@@ -119,7 +120,7 @@ int cxd2820r_set_frontend_t2(struct dvb_frontend *fe)
 	} else
 		if_freq = 0;
 
-	dbg("%s: if_freq=%d", __func__, if_freq);
+	dev_dbg(&priv->i2c->dev, "%s: if_freq=%d\n", __func__, if_freq);
 
 	num = if_freq / 1000; /* Hz => kHz */
 	num *= 0x1000000;
@@ -150,7 +151,7 @@ int cxd2820r_set_frontend_t2(struct dvb_frontend *fe)
 
 	return ret;
 error:
-	dbg("%s: failed:%d", __func__, ret);
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 
 }
@@ -266,7 +267,7 @@ int cxd2820r_get_frontend_t2(struct dvb_frontend *fe)
 
 	return ret;
 error:
-	dbg("%s: failed:%d", __func__, ret);
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -291,11 +292,11 @@ int cxd2820r_read_status_t2(struct dvb_frontend *fe, fe_status_t *status)
 		}
 	}
 
-	dbg("%s: lock=%02x", __func__, buf[0]);
+	dev_dbg(&priv->i2c->dev, "%s: lock=%02x\n", __func__, buf[0]);
 
 	return ret;
 error:
-	dbg("%s: failed:%d", __func__, ret);
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -322,7 +323,7 @@ int cxd2820r_read_ber_t2(struct dvb_frontend *fe, u32 *ber)
 
 	return ret;
 error:
-	dbg("%s: failed:%d", __func__, ret);
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -346,7 +347,7 @@ int cxd2820r_read_signal_strength_t2(struct dvb_frontend *fe,
 
 	return ret;
 error:
-	dbg("%s: failed:%d", __func__, ret);
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -370,11 +371,12 @@ int cxd2820r_read_snr_t2(struct dvb_frontend *fe, u16 *snr)
 	else
 		*snr = 0;
 
-	dbg("%s: dBx10=%d val=%04x", __func__, *snr, tmp);
+	dev_dbg(&priv->i2c->dev, "%s: dBx10=%d val=%04x\n", __func__, *snr,
+			tmp);
 
 	return ret;
 error:
-	dbg("%s: failed:%d", __func__, ret);
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -398,7 +400,7 @@ int cxd2820r_sleep_t2(struct dvb_frontend *fe)
 		{ 0x00080, 0x00, 0xff },
 	};
 
-	dbg("%s", __func__);
+	dev_dbg(&priv->i2c->dev, "%s\n", __func__);
 
 	for (i = 0; i < ARRAY_SIZE(tab); i++) {
 		ret = cxd2820r_wr_reg_mask(priv, tab[i].reg, tab[i].val,
@@ -411,7 +413,7 @@ int cxd2820r_sleep_t2(struct dvb_frontend *fe)
 
 	return ret;
 error:
-	dbg("%s: failed:%d", __func__, ret);
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
-- 
1.7.11.2

