Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47779 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752324AbaAYRLC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jan 2014 12:11:02 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 11/52] rtl2832: style changes and minor cleanup
Date: Sat, 25 Jan 2014 19:10:05 +0200
Message-Id: <1390669846-8131-12-git-send-email-crope@iki.fi>
In-Reply-To: <1390669846-8131-1-git-send-email-crope@iki.fi>
References: <1390669846-8131-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Most of those were reported by checkpatch.pl...

debug module parameter is not used anywhere so remove it.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832.c      | 26 +++++++---------
 drivers/media/dvb-frontends/rtl2832.h      |  2 +-
 drivers/media/dvb-frontends/rtl2832_priv.h | 50 +++++++++++++++---------------
 3 files changed, 38 insertions(+), 40 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index 61d4ecb..00e63b9 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -24,11 +24,6 @@
 
 /* Max transfer size done by I2C transfer functions */
 #define MAX_XFER_SIZE  64
-
-int rtl2832_debug;
-module_param_named(debug, rtl2832_debug, int, 0644);
-MODULE_PARM_DESC(debug, "Turn on/off frontend debugging (default:off).");
-
 #define REG_MASK(b) (BIT(b + 1) - 1)
 
 static const struct rtl2832_reg_entry registers[] = {
@@ -189,8 +184,9 @@ static int rtl2832_wr(struct rtl2832_priv *priv, u8 reg, u8 *val, int len)
 	if (ret == 1) {
 		ret = 0;
 	} else {
-		dev_warn(&priv->i2c->dev, "%s: i2c wr failed=%d reg=%02x " \
-				"len=%d\n", KBUILD_MODNAME, ret, reg, len);
+		dev_warn(&priv->i2c->dev,
+				"%s: i2c wr failed=%d reg=%02x len=%d\n",
+				KBUILD_MODNAME, ret, reg, len);
 		ret = -EREMOTEIO;
 	}
 	return ret;
@@ -218,8 +214,9 @@ static int rtl2832_rd(struct rtl2832_priv *priv, u8 reg, u8 *val, int len)
 	if (ret == 2) {
 		ret = 0;
 	} else {
-		dev_warn(&priv->i2c->dev, "%s: i2c rd failed=%d reg=%02x " \
-				"len=%d\n", KBUILD_MODNAME, ret, reg, len);
+		dev_warn(&priv->i2c->dev,
+				"%s: i2c rd failed=%d reg=%02x len=%d\n",
+				KBUILD_MODNAME, ret, reg, len);
 		ret = -EREMOTEIO;
 	}
 	return ret;
@@ -417,7 +414,7 @@ static int rtl2832_set_if(struct dvb_frontend *fe, u32 if_freq)
 
 	ret = rtl2832_wr_demod_reg(priv, DVBT_PSET_IFFREQ, pset_iffreq);
 
-	return (ret);
+	return ret;
 }
 
 static int rtl2832_init(struct dvb_frontend *fe)
@@ -516,7 +513,8 @@ static int rtl2832_init(struct dvb_frontend *fe)
 
 	/*
 	 * r820t NIM code does a software reset here at the demod -
-	 * may not be needed, as there's already a software reset at set_params()
+	 * may not be needed, as there's already a software reset at
+	 * set_params()
 	 */
 #if 1
 	/* soft reset */
@@ -593,9 +591,9 @@ static int rtl2832_set_frontend(struct dvb_frontend *fe)
 	};
 
 
-	dev_dbg(&priv->i2c->dev, "%s: frequency=%d bandwidth_hz=%d " \
-			"inversion=%d\n", __func__, c->frequency,
-			c->bandwidth_hz, c->inversion);
+	dev_dbg(&priv->i2c->dev,
+			"%s: frequency=%d bandwidth_hz=%d inversion=%d\n",
+			__func__, c->frequency, c->bandwidth_hz, c->inversion);
 
 	/* program tuner */
 	if (fe->ops.tuner_ops.set_params)
diff --git a/drivers/media/dvb-frontends/rtl2832.h b/drivers/media/dvb-frontends/rtl2832.h
index e543081..fa4e5f6 100644
--- a/drivers/media/dvb-frontends/rtl2832.h
+++ b/drivers/media/dvb-frontends/rtl2832.h
@@ -51,7 +51,7 @@ struct rtl2832_config {
 };
 
 #if IS_ENABLED(CONFIG_DVB_RTL2832)
-extern struct dvb_frontend *rtl2832_attach(
+struct dvb_frontend *rtl2832_attach(
 	const struct rtl2832_config *cfg,
 	struct i2c_adapter *i2c
 );
diff --git a/drivers/media/dvb-frontends/rtl2832_priv.h b/drivers/media/dvb-frontends/rtl2832_priv.h
index b5f2b80..4c845af 100644
--- a/drivers/media/dvb-frontends/rtl2832_priv.h
+++ b/drivers/media/dvb-frontends/rtl2832_priv.h
@@ -267,7 +267,7 @@ static const struct rtl2832_reg_value rtl2832_tuner_init_tua9001[] = {
 	{DVBT_OPT_ADC_IQ,                0x1},
 	{DVBT_AD_AVI,                    0x0},
 	{DVBT_AD_AVQ,                    0x0},
-	{DVBT_SPEC_INV,			 0x0},
+	{DVBT_SPEC_INV,                  0x0},
 };
 
 static const struct rtl2832_reg_value rtl2832_tuner_init_fc0012[] = {
@@ -301,7 +301,7 @@ static const struct rtl2832_reg_value rtl2832_tuner_init_fc0012[] = {
 	{DVBT_GI_PGA_STATE,              0x0},
 	{DVBT_EN_AGC_PGA,                0x1},
 	{DVBT_IF_AGC_MAN,                0x0},
-	{DVBT_SPEC_INV,			 0x0},
+	{DVBT_SPEC_INV,                  0x0},
 };
 
 static const struct rtl2832_reg_value rtl2832_tuner_init_e4000[] = {
@@ -339,32 +339,32 @@ static const struct rtl2832_reg_value rtl2832_tuner_init_e4000[] = {
 	{DVBT_REG_MONSEL,                0x1},
 	{DVBT_REG_MON,                   0x1},
 	{DVBT_REG_4MSEL,                 0x0},
-	{DVBT_SPEC_INV,			 0x0},
+	{DVBT_SPEC_INV,                  0x0},
 };
 
 static const struct rtl2832_reg_value rtl2832_tuner_init_r820t[] = {
-	{DVBT_DAGC_TRG_VAL,		0x39},
-	{DVBT_AGC_TARG_VAL_0,		0x0},
-	{DVBT_AGC_TARG_VAL_8_1,		0x40},
-	{DVBT_AAGC_LOOP_GAIN,		0x16},
-	{DVBT_LOOP_GAIN2_3_0,		0x8},
-	{DVBT_LOOP_GAIN2_4,		0x1},
-	{DVBT_LOOP_GAIN3,		0x18},
-	{DVBT_VTOP1,			0x35},
-	{DVBT_VTOP2,			0x21},
-	{DVBT_VTOP3,			0x21},
-	{DVBT_KRF1,			0x0},
-	{DVBT_KRF2,			0x40},
-	{DVBT_KRF3,			0x10},
-	{DVBT_KRF4,			0x10},
-	{DVBT_IF_AGC_MIN,		0x80},
-	{DVBT_IF_AGC_MAX,		0x7f},
-	{DVBT_RF_AGC_MIN,		0x80},
-	{DVBT_RF_AGC_MAX,		0x7f},
-	{DVBT_POLAR_RF_AGC,		0x0},
-	{DVBT_POLAR_IF_AGC,		0x0},
-	{DVBT_AD7_SETTING,		0xe9f4},
-	{DVBT_SPEC_INV,			0x1},
+	{DVBT_DAGC_TRG_VAL,             0x39},
+	{DVBT_AGC_TARG_VAL_0,            0x0},
+	{DVBT_AGC_TARG_VAL_8_1,         0x40},
+	{DVBT_AAGC_LOOP_GAIN,           0x16},
+	{DVBT_LOOP_GAIN2_3_0,            0x8},
+	{DVBT_LOOP_GAIN2_4,              0x1},
+	{DVBT_LOOP_GAIN3,               0x18},
+	{DVBT_VTOP1,                    0x35},
+	{DVBT_VTOP2,                    0x21},
+	{DVBT_VTOP3,                    0x21},
+	{DVBT_KRF1,                      0x0},
+	{DVBT_KRF2,                     0x40},
+	{DVBT_KRF3,                     0x10},
+	{DVBT_KRF4,                     0x10},
+	{DVBT_IF_AGC_MIN,               0x80},
+	{DVBT_IF_AGC_MAX,               0x7f},
+	{DVBT_RF_AGC_MIN,               0x80},
+	{DVBT_RF_AGC_MAX,               0x7f},
+	{DVBT_POLAR_RF_AGC,              0x0},
+	{DVBT_POLAR_IF_AGC,              0x0},
+	{DVBT_AD7_SETTING,            0xe9f4},
+	{DVBT_SPEC_INV,                  0x1},
 };
 
 #endif /* RTL2832_PRIV_H */
-- 
1.8.5.3

