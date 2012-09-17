Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57454 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756616Ab2IQU6k (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Sep 2012 16:58:40 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 6/7] rtl2832: add configuration for e4000 tuner
Date: Mon, 17 Sep 2012 23:58:11 +0300
Message-Id: <1347915492-24924-6-git-send-email-crope@iki.fi>
In-Reply-To: <1347915492-24924-1-git-send-email-crope@iki.fi>
References: <1347915492-24924-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832.c      |  4 ++++
 drivers/media/dvb-frontends/rtl2832.h      |  1 +
 drivers/media/dvb-frontends/rtl2832_priv.h | 37 ++++++++++++++++++++++++++++++
 3 files changed, 42 insertions(+)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index aaf0c29..80c8e5f 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -468,6 +468,10 @@ static int rtl2832_init(struct dvb_frontend *fe)
 		len = ARRAY_SIZE(rtl2832_tuner_init_tua9001);
 		init = rtl2832_tuner_init_tua9001;
 		break;
+	case RTL2832_TUNER_E4000:
+		len = ARRAY_SIZE(rtl2832_tuner_init_e4000);
+		init = rtl2832_tuner_init_e4000;
+		break;
 	default:
 		ret = -EINVAL;
 		goto err;
diff --git a/drivers/media/dvb-frontends/rtl2832.h b/drivers/media/dvb-frontends/rtl2832.h
index c4a6118..785a466 100644
--- a/drivers/media/dvb-frontends/rtl2832.h
+++ b/drivers/media/dvb-frontends/rtl2832.h
@@ -49,6 +49,7 @@ struct rtl2832_config {
 	 */
 #define RTL2832_TUNER_TUA9001   0x24
 #define RTL2832_TUNER_FC0012    0x26
+#define RTL2832_TUNER_E4000     0x27
 #define RTL2832_TUNER_FC0013    0x29
 	u8 tuner;
 };
diff --git a/drivers/media/dvb-frontends/rtl2832_priv.h b/drivers/media/dvb-frontends/rtl2832_priv.h
index 5e68955..7d97ce9 100644
--- a/drivers/media/dvb-frontends/rtl2832_priv.h
+++ b/drivers/media/dvb-frontends/rtl2832_priv.h
@@ -302,4 +302,41 @@ static const struct rtl2832_reg_value rtl2832_tuner_init_fc0012[] = {
 	{DVBT_IF_AGC_MAN,                0x0},
 };
 
+static const struct rtl2832_reg_value rtl2832_tuner_init_e4000[] = {
+	{DVBT_DAGC_TRG_VAL,             0x5a},
+	{DVBT_AGC_TARG_VAL_0,            0x0},
+	{DVBT_AGC_TARG_VAL_8_1,         0x5a},
+	{DVBT_AAGC_LOOP_GAIN,           0x18},
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
+	{DVBT_AD7_SETTING,            0xe9d4},
+	{DVBT_EN_GI_PGA,                 0x0},
+	{DVBT_THD_LOCK_UP,               0x0},
+	{DVBT_THD_LOCK_DW,               0x0},
+	{DVBT_THD_UP1,                  0x14},
+	{DVBT_THD_DW1,                  0xec},
+	{DVBT_INTER_CNT_LEN,             0xc},
+	{DVBT_GI_PGA_STATE,              0x0},
+	{DVBT_EN_AGC_PGA,                0x1},
+	{DVBT_REG_GPE,                   0x1},
+	{DVBT_REG_GPO,                   0x1},
+	{DVBT_REG_MONSEL,                0x1},
+	{DVBT_REG_MON,                   0x1},
+	{DVBT_REG_4MSEL,                 0x0},
+};
+
 #endif /* RTL2832_PRIV_H */
-- 
1.7.11.4

