Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46523 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758017Ab2ILC1p (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Sep 2012 22:27:45 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Thomas Mair <mair.thomas86@gmail.com>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 5/8] rtl2832: support for tua9001 tuner
Date: Wed, 12 Sep 2012 05:27:08 +0300
Message-Id: <1347416831-1413-5-git-send-email-crope@iki.fi>
In-Reply-To: <1347416831-1413-1-git-send-email-crope@iki.fi>
References: <1347416831-1413-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832.c      |  8 +++++---
 drivers/media/dvb-frontends/rtl2832.h      |  1 +
 drivers/media/dvb-frontends/rtl2832_priv.h | 27 +++++++++++++++++++++++++++
 3 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index d670fe7..8f8a5b0 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -462,15 +462,17 @@ static int rtl2832_init(struct dvb_frontend *fe)
 		len = ARRAY_SIZE(rtl2832_tuner_init_fc0012);
 		init = rtl2832_tuner_init_fc0012;
 		break;
+	case RTL2832_TUNER_TUA9001:
+		len = ARRAY_SIZE(rtl2832_tuner_init_tua9001);
+		init = rtl2832_tuner_init_tua9001;
+		break;
 	default:
 		ret = -EINVAL;
 		goto err;
 	}
 
 	for (i = 0; i < len; i++) {
-		ret = rtl2832_wr_demod_reg(priv,
-				rtl2832_tuner_init_fc0012[i].reg,
-				rtl2832_tuner_init_fc0012[i].value);
+		ret = rtl2832_wr_demod_reg(priv, init[i].reg, init[i].value);
 		if (ret)
 			goto err;
 	}
diff --git a/drivers/media/dvb-frontends/rtl2832.h b/drivers/media/dvb-frontends/rtl2832.h
index 270fd1e..f7cb09a 100644
--- a/drivers/media/dvb-frontends/rtl2832.h
+++ b/drivers/media/dvb-frontends/rtl2832.h
@@ -47,6 +47,7 @@ struct rtl2832_config {
 	 * tuner
 	 * XXX: This must be keep sync with dvb_usb_rtl28xxu demod driver.
 	 */
+#define RTL2832_TUNER_TUA9001   0x24
 #define RTL2832_TUNER_FC0012    0x26
 #define RTL2832_TUNER_FC0013    0x29
 	u8 tuner;
diff --git a/drivers/media/dvb-frontends/rtl2832_priv.h b/drivers/media/dvb-frontends/rtl2832_priv.h
index 65dd62a..75af963 100644
--- a/drivers/media/dvb-frontends/rtl2832_priv.h
+++ b/drivers/media/dvb-frontends/rtl2832_priv.h
@@ -257,6 +257,33 @@ enum DVBT_REG_BIT_NAME {
 	DVBT_REG_BIT_NAME_ITEM_TERMINATOR,
 };
 
+static const struct rtl2832_reg_value rtl2832_tuner_init_tua9001[] = {
+	{DVBT_DAGC_TRG_VAL,             0x39},
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
+	{DVBT_RF_AGC_MIN,               0x9c},
+	{DVBT_RF_AGC_MAX,               0x7f},
+	{DVBT_POLAR_RF_AGC,              0x0},
+	{DVBT_POLAR_IF_AGC,              0x0},
+	{DVBT_AD7_SETTING,            0xe9f4},
+	{DVBT_OPT_ADC_IQ,                0x1},
+	{DVBT_AD_AVI,                    0x0},
+	{DVBT_AD_AVQ,                    0x0},
+};
+
 static const struct rtl2832_reg_value rtl2832_tuner_init_fc0012[] = {
 	{DVBT_DAGC_TRG_VAL,             0x5a},
 	{DVBT_AGC_TARG_VAL_0,            0x0},
-- 
1.7.11.4

