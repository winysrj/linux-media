Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51051 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774Ab3CJCEi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Mar 2013 21:04:38 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [REVIEW PATCH 02/41] af9033: support for it913x tuners
Date: Sun, 10 Mar 2013 04:02:54 +0200
Message-Id: <1362881013-5271-2-git-send-email-crope@iki.fi>
In-Reply-To: <1362881013-5271-1-git-send-email-crope@iki.fi>
References: <1362881013-5271-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for tuners integrated to the IT9135 and IT9137.

Cc: Malcolm Priestley <tvboxspy@gmail.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9033.c | 34 +++++++++++++++++++++-------------
 drivers/media/dvb-frontends/af9033.h | 15 +++++++++++++++
 2 files changed, 36 insertions(+), 13 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index c9cad98..dece775 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -223,6 +223,7 @@ static int af9033_init(struct dvb_frontend *fe)
 		{ 0x80f986, state->ts_mode_parallel, 0x01 },
 		{ 0x00d827, 0x00, 0xff },
 		{ 0x00d829, 0x00, 0xff },
+		{ 0x800045, state->cfg.adc_multiplier, 0xff },
 	};
 
 	/* program clock control */
@@ -322,6 +323,14 @@ static int af9033_init(struct dvb_frontend *fe)
 		len = ARRAY_SIZE(tuner_init_fc0012);
 		init = tuner_init_fc0012;
 		break;
+	case AF9033_TUNER_IT9135_38:
+	case AF9033_TUNER_IT9135_51:
+	case AF9033_TUNER_IT9135_52:
+	case AF9033_TUNER_IT9135_60:
+	case AF9033_TUNER_IT9135_61:
+	case AF9033_TUNER_IT9135_62:
+		len = 0;
+		break;
 	default:
 		dev_dbg(&state->i2c->dev, "%s: unsupported tuner ID=%d\n",
 				__func__, state->cfg.tuner);
@@ -498,12 +507,7 @@ static int af9033_set_frontend(struct dvb_frontend *fe)
 		if (spec_inv == -1)
 			freq_cw = 0x800000 - freq_cw;
 
-		/* get adc multiplies */
-		ret = af9033_rd_reg(state, 0x800045, &tmp);
-		if (ret < 0)
-			goto err;
-
-		if (tmp == 1)
+		if (state->cfg.adc_multiplier == AF9033_ADC_MULTIPLIER_2X)
 			freq_cw /= 2;
 
 		buf[0] = (freq_cw >>  0) & 0xff;
@@ -933,14 +937,18 @@ struct dvb_frontend *af9033_attach(const struct af9033_config *config,
 			"OFDM=%d.%d.%d.%d\n", KBUILD_MODNAME, buf[0], buf[1],
 			buf[2], buf[3], buf[4], buf[5], buf[6], buf[7]);
 
-	/* sleep */
-	ret = af9033_wr_reg(state, 0x80004c, 1);
-	if (ret < 0)
-		goto err;
 
-	ret = af9033_wr_reg(state, 0x800000, 0);
-	if (ret < 0)
-		goto err;
+	/* FIXME: Do not abuse adc_multiplier for detecting IT9135 */
+	if (state->cfg.adc_multiplier != AF9033_ADC_MULTIPLIER_2X) {
+		/* sleep */
+		ret = af9033_wr_reg(state, 0x80004c, 1);
+		if (ret < 0)
+			goto err;
+
+		ret = af9033_wr_reg(state, 0x800000, 0);
+		if (ret < 0)
+			goto err;
+	}
 
 	/* configure internal TS mode */
 	switch (state->cfg.ts_mode) {
diff --git a/drivers/media/dvb-frontends/af9033.h b/drivers/media/dvb-frontends/af9033.h
index 82bd8c1..53fd304 100644
--- a/drivers/media/dvb-frontends/af9033.h
+++ b/drivers/media/dvb-frontends/af9033.h
@@ -36,6 +36,13 @@ struct af9033_config {
 	u32 clock;
 
 	/*
+	 * ADC multiplier
+	 */
+#define AF9033_ADC_MULTIPLIER_1X   0
+#define AF9033_ADC_MULTIPLIER_2X   1
+	u8 adc_multiplier;
+
+	/*
 	 * tuner
 	 */
 #define AF9033_TUNER_TUA9001     0x27 /* Infineon TUA 9001 */
@@ -44,6 +51,14 @@ struct af9033_config {
 #define AF9033_TUNER_MXL5007T    0xa0 /* MaxLinear MxL5007T */
 #define AF9033_TUNER_TDA18218    0xa1 /* NXP TDA 18218HN */
 #define AF9033_TUNER_FC2580      0x32 /* FCI FC2580 */
+/* 50-5f Omega */
+#define AF9033_TUNER_IT9135_38   0x38 /* Omega */
+#define AF9033_TUNER_IT9135_51   0x51 /* Omega LNA config 1 */
+#define AF9033_TUNER_IT9135_52   0x52 /* Omega LNA config 2 */
+/* 60-6f Omega v2 */
+#define AF9033_TUNER_IT9135_60   0x60 /* Omega v2 */
+#define AF9033_TUNER_IT9135_61   0x61 /* Omega v2 LNA config 1 */
+#define AF9033_TUNER_IT9135_62   0x62 /* Omega v2 LNA config 2 */
 	u8 tuner;
 
 	/*
-- 
1.7.11.7

