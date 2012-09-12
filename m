Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35462 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752468Ab2ILC1i (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Sep 2012 22:27:38 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Thomas Mair <mair.thomas86@gmail.com>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/8] rtl2832: separate tuner specific init from general
Date: Wed, 12 Sep 2012 05:27:04 +0300
Message-Id: <1347416831-1413-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is first step closer to support multiple tuners.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832.c      | 58 ++++++++++++------------------
 drivers/media/dvb-frontends/rtl2832.h      |  5 ++-
 drivers/media/dvb-frontends/rtl2832_priv.h | 33 +++++++++++++++++
 drivers/media/usb/dvb-usb-v2/rtl28xxu.h    |  5 +--
 4 files changed, 63 insertions(+), 38 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index 4d40b4f..d670fe7 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -382,10 +382,10 @@ err:
 static int rtl2832_init(struct dvb_frontend *fe)
 {
 	struct rtl2832_priv *priv = fe->demodulator_priv;
-	int i, ret;
-
+	int i, ret, len;
 	u8 en_bbin;
 	u64 pset_iffreq;
+	const struct rtl2832_reg_value *init;
 
 	/* initialization values for the demodulator registers */
 	struct rtl2832_reg_value rtl2832_initial_regs[] = {
@@ -432,39 +432,8 @@ static int rtl2832_init(struct dvb_frontend *fe)
 		{DVBT_TRK_KC_I2,		0x5},
 		{DVBT_CR_THD_SET2,		0x1},
 		{DVBT_SPEC_INV,			0x0},
-		{DVBT_DAGC_TRG_VAL,		0x5a},
-		{DVBT_AGC_TARG_VAL_0,		0x0},
-		{DVBT_AGC_TARG_VAL_8_1,		0x5a},
-		{DVBT_AAGC_LOOP_GAIN,		0x16},
-		{DVBT_LOOP_GAIN2_3_0,		0x6},
-		{DVBT_LOOP_GAIN2_4,		0x1},
-		{DVBT_LOOP_GAIN3,		0x16},
-		{DVBT_VTOP1,			0x35},
-		{DVBT_VTOP2,			0x21},
-		{DVBT_VTOP3,			0x21},
-		{DVBT_KRF1,			0x0},
-		{DVBT_KRF2,			0x40},
-		{DVBT_KRF3,			0x10},
-		{DVBT_KRF4,			0x10},
-		{DVBT_IF_AGC_MIN,		0x80},
-		{DVBT_IF_AGC_MAX,		0x7f},
-		{DVBT_RF_AGC_MIN,		0x80},
-		{DVBT_RF_AGC_MAX,		0x7f},
-		{DVBT_POLAR_RF_AGC,		0x0},
-		{DVBT_POLAR_IF_AGC,		0x0},
-		{DVBT_AD7_SETTING,		0xe9bf},
-		{DVBT_EN_GI_PGA,		0x0},
-		{DVBT_THD_LOCK_UP,		0x0},
-		{DVBT_THD_LOCK_DW,		0x0},
-		{DVBT_THD_UP1,			0x11},
-		{DVBT_THD_DW1,			0xef},
-		{DVBT_INTER_CNT_LEN,		0xc},
-		{DVBT_GI_PGA_STATE,		0x0},
-		{DVBT_EN_AGC_PGA,		0x1},
-		{DVBT_IF_AGC_MAN,		0x0},
 	};
 
-
 	dbg("%s", __func__);
 
 	en_bbin = (priv->cfg.if_dvbt == 0 ? 0x1 : 0x0);
@@ -478,8 +447,6 @@ static int rtl2832_init(struct dvb_frontend *fe)
 	pset_iffreq = div_u64(pset_iffreq, priv->cfg.xtal);
 	pset_iffreq = pset_iffreq & 0x3fffff;
 
-
-
 	for (i = 0; i < ARRAY_SIZE(rtl2832_initial_regs); i++) {
 		ret = rtl2832_wr_demod_reg(priv, rtl2832_initial_regs[i].reg,
 			rtl2832_initial_regs[i].value);
@@ -487,6 +454,27 @@ static int rtl2832_init(struct dvb_frontend *fe)
 			goto err;
 	}
 
+	/* load tuner specific settings */
+	dbg("%s: load settings for tuner=%02x", __func__, priv->cfg.tuner);
+	switch (priv->cfg.tuner) {
+	case RTL2832_TUNER_FC0012:
+	case RTL2832_TUNER_FC0013:
+		len = ARRAY_SIZE(rtl2832_tuner_init_fc0012);
+		init = rtl2832_tuner_init_fc0012;
+		break;
+	default:
+		ret = -EINVAL;
+		goto err;
+	}
+
+	for (i = 0; i < len; i++) {
+		ret = rtl2832_wr_demod_reg(priv,
+				rtl2832_tuner_init_fc0012[i].reg,
+				rtl2832_tuner_init_fc0012[i].value);
+		if (ret)
+			goto err;
+	}
+
 	/* if frequency settings */
 	ret = rtl2832_wr_demod_reg(priv, DVBT_EN_BBIN, en_bbin);
 		if (ret)
diff --git a/drivers/media/dvb-frontends/rtl2832.h b/drivers/media/dvb-frontends/rtl2832.h
index d94dc9a..5da0cc4 100644
--- a/drivers/media/dvb-frontends/rtl2832.h
+++ b/drivers/media/dvb-frontends/rtl2832.h
@@ -44,11 +44,14 @@ struct rtl2832_config {
 	u32 if_dvbt;
 
 	/*
+	 * tuner
+	 * XXX: This must be keep sync with dvb_usb_rtl28xxu demod driver.
 	 */
+#define RTL2832_TUNER_FC0012    0x26
+#define RTL2832_TUNER_FC0013    0x29
 	u8 tuner;
 };
 
-
 #if defined(CONFIG_DVB_RTL2832) || \
 	(defined(CONFIG_DVB_RTL2832_MODULE) && defined(MODULE))
 extern struct dvb_frontend *rtl2832_attach(
diff --git a/drivers/media/dvb-frontends/rtl2832_priv.h b/drivers/media/dvb-frontends/rtl2832_priv.h
index 0ce9502..65dd62a 100644
--- a/drivers/media/dvb-frontends/rtl2832_priv.h
+++ b/drivers/media/dvb-frontends/rtl2832_priv.h
@@ -257,4 +257,37 @@ enum DVBT_REG_BIT_NAME {
 	DVBT_REG_BIT_NAME_ITEM_TERMINATOR,
 };
 
+static const struct rtl2832_reg_value rtl2832_tuner_init_fc0012[] = {
+	{DVBT_DAGC_TRG_VAL,             0x5a},
+	{DVBT_AGC_TARG_VAL_0,            0x0},
+	{DVBT_AGC_TARG_VAL_8_1,         0x5a},
+	{DVBT_AAGC_LOOP_GAIN,           0x16},
+	{DVBT_LOOP_GAIN2_3_0,            0x6},
+	{DVBT_LOOP_GAIN2_4,              0x1},
+	{DVBT_LOOP_GAIN3,               0x16},
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
+	{DVBT_AD7_SETTING,            0xe9bf},
+	{DVBT_EN_GI_PGA,                 0x0},
+	{DVBT_THD_LOCK_UP,               0x0},
+	{DVBT_THD_LOCK_DW,               0x0},
+	{DVBT_THD_UP1,                  0x11},
+	{DVBT_THD_DW1,                  0xef},
+	{DVBT_INTER_CNT_LEN,             0xc},
+	{DVBT_GI_PGA_STATE,              0x0},
+	{DVBT_EN_AGC_PGA,                0x1},
+	{DVBT_IF_AGC_MAN,                0x0},
+};
+
 #endif /* RTL2832_PRIV_H */
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.h b/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
index 035a9c8..c6c8a4f 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
@@ -63,14 +63,15 @@ enum rtl28xxu_chip_id {
 	CHIP_ID_RTL2832U,
 };
 
+/* XXX: Hack. This must be keep sync with rtl2832 demod driver. */
 enum rtl28xxu_tuner {
 	TUNER_NONE,
 
-	TUNER_RTL2830_QT1010,
+	TUNER_RTL2830_QT1010          = 0x10,
 	TUNER_RTL2830_MT2060,
 	TUNER_RTL2830_MXL5005S,
 
-	TUNER_RTL2832_MT2266,
+	TUNER_RTL2832_MT2266          = 0x20,
 	TUNER_RTL2832_FC2580,
 	TUNER_RTL2832_MT2063,
 	TUNER_RTL2832_MAX3543,
-- 
1.7.11.4

