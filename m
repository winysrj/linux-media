Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36937 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752827AbbEEV7B (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 May 2015 17:59:01 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 16/21] rtl2832: add inittab for FC2580 tuner
Date: Wed,  6 May 2015 00:58:37 +0300
Message-Id: <1430863122-9888-16-git-send-email-crope@iki.fi>
In-Reply-To: <1430863122-9888-1-git-send-email-crope@iki.fi>
References: <1430863122-9888-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add reg/val inittab for FC2580 tuner.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832.c      |  4 ++++
 drivers/media/dvb-frontends/rtl2832.h      |  1 +
 drivers/media/dvb-frontends/rtl2832_priv.h | 24 ++++++++++++++++++++++++
 3 files changed, 29 insertions(+)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index b400f7b..753496c 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -358,6 +358,10 @@ static int rtl2832_init(struct dvb_frontend *fe)
 	dev_dbg(&client->dev, "load settings for tuner=%02x\n",
 		dev->pdata->tuner);
 	switch (dev->pdata->tuner) {
+	case RTL2832_TUNER_FC2580:
+		len = ARRAY_SIZE(rtl2832_tuner_init_fc2580);
+		init = rtl2832_tuner_init_fc2580;
+		break;
 	case RTL2832_TUNER_FC0012:
 	case RTL2832_TUNER_FC0013:
 		len = ARRAY_SIZE(rtl2832_tuner_init_fc0012);
diff --git a/drivers/media/dvb-frontends/rtl2832.h b/drivers/media/dvb-frontends/rtl2832.h
index a8e912e..c1df881 100644
--- a/drivers/media/dvb-frontends/rtl2832.h
+++ b/drivers/media/dvb-frontends/rtl2832.h
@@ -41,6 +41,7 @@ struct rtl2832_platform_data {
 	/*
 	 * XXX: This list must be kept sync with dvb_usb_rtl28xxu USB IF driver.
 	 */
+#define RTL2832_TUNER_FC2580    0x21
 #define RTL2832_TUNER_TUA9001   0x24
 #define RTL2832_TUNER_FC0012    0x26
 #define RTL2832_TUNER_E4000     0x27
diff --git a/drivers/media/dvb-frontends/rtl2832_priv.h b/drivers/media/dvb-frontends/rtl2832_priv.h
index c3a922c..635556d 100644
--- a/drivers/media/dvb-frontends/rtl2832_priv.h
+++ b/drivers/media/dvb-frontends/rtl2832_priv.h
@@ -252,6 +252,30 @@ enum DVBT_REG_BIT_NAME {
 	DVBT_REG_BIT_NAME_ITEM_TERMINATOR,
 };
 
+static const struct rtl2832_reg_value rtl2832_tuner_init_fc2580[] = {
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
+};
+
 static const struct rtl2832_reg_value rtl2832_tuner_init_tua9001[] = {
 	{DVBT_DAGC_TRG_VAL,             0x39},
 	{DVBT_AGC_TARG_VAL_0,            0x0},
-- 
http://palosaari.fi/

