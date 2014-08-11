Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:36607 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbaHKEW6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Aug 2014 00:22:58 -0400
Received: by mail-pd0-f174.google.com with SMTP id fp1so10143550pdb.33
        for <linux-media@vger.kernel.org>; Sun, 10 Aug 2014 21:22:57 -0700 (PDT)
Date: Mon, 11 Aug 2014 12:22:45 +0800
From: "nibble.max" <nibble.max@gmail.com>
To: "Antti Palosaari" <crope@iki.fi>
Cc: "linux-media" <linux-media@vger.kernel.org>
Subject: [PATCH 1/4 v3] support for DVBSky dvb-s2 usb: Add ts clock and clock polarity, lnb set voltage and lnb ctrl pin for m88ds3103
Message-ID: <201408111222428595683@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add ts clock and clock polarity, lnb set voltage and lnb control pin.

Signed-off-by: Nibble Max <nibble.max@gmail.com>
---
 drivers/media/dvb-frontends/m88ds3103.c | 72 ++++++++++++++++++++-------------
 drivers/media/dvb-frontends/m88ds3103.h | 35 +++++++++++++---
 2 files changed, 75 insertions(+), 32 deletions(-)

diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
index dfe0c2f..238b04e 100644
--- a/drivers/media/dvb-frontends/m88ds3103.c
+++ b/drivers/media/dvb-frontends/m88ds3103.c
@@ -247,7 +247,7 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 	u8 u8tmp, u8tmp1, u8tmp2;
 	u8 buf[2];
 	u16 u16tmp, divide_ratio;
-	u32 tuner_frequency, target_mclk, ts_clk;
+	u32 tuner_frequency, target_mclk;
 	s32 s32tmp;
 	dev_dbg(&priv->i2c->dev,
 			"%s: delivery_system=%d modulation=%d frequency=%d symbol_rate=%d inversion=%d pilot=%d rolloff=%d\n",
@@ -316,9 +316,6 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 				target_mclk = 144000;
 			break;
 		case M88DS3103_TS_PARALLEL:
-		case M88DS3103_TS_PARALLEL_12:
-		case M88DS3103_TS_PARALLEL_16:
-		case M88DS3103_TS_PARALLEL_19_2:
 		case M88DS3103_TS_CI:
 			if (c->symbol_rate < 18000000)
 				target_mclk = 96000;
@@ -352,33 +349,17 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 	switch (priv->cfg->ts_mode) {
 	case M88DS3103_TS_SERIAL:
 		u8tmp1 = 0x00;
-		ts_clk = 0;
-		u8tmp = 0x46;
+		u8tmp = 0x06;
 		break;
 	case M88DS3103_TS_SERIAL_D7:
 		u8tmp1 = 0x20;
-		ts_clk = 0;
-		u8tmp = 0x46;
+		u8tmp = 0x06;
 		break;
 	case M88DS3103_TS_PARALLEL:
-		ts_clk = 24000;
-		u8tmp = 0x42;
-		break;
-	case M88DS3103_TS_PARALLEL_12:
-		ts_clk = 12000;
-		u8tmp = 0x42;
-		break;
-	case M88DS3103_TS_PARALLEL_16:
-		ts_clk = 16000;
-		u8tmp = 0x42;
-		break;
-	case M88DS3103_TS_PARALLEL_19_2:
-		ts_clk = 19200;
-		u8tmp = 0x42;
+		u8tmp = 0x02;
 		break;
 	case M88DS3103_TS_CI:
-		ts_clk = 6000;
-		u8tmp = 0x43;
+		u8tmp = 0x03;
 		break;
 	default:
 		dev_dbg(&priv->i2c->dev, "%s: invalid ts_mode\n", __func__);
@@ -386,6 +367,9 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 		goto err;
 	}
 
+	if (priv->cfg->ts_clk_pol)
+		u8tmp |= 0x40;
+
 	/* TS mode */
 	ret = m88ds3103_wr_reg(priv, 0xfd, u8tmp);
 	if (ret)
@@ -399,8 +383,8 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 			goto err;
 	}
 
-	if (ts_clk) {
-		divide_ratio = DIV_ROUND_UP(target_mclk, ts_clk);
+	if (priv->cfg->ts_clk) {
+		divide_ratio = DIV_ROUND_UP(target_mclk, priv->cfg->ts_clk);
 		u8tmp1 = divide_ratio / 2;
 		u8tmp2 = DIV_ROUND_UP(divide_ratio, 2);
 	} else {
@@ -411,7 +395,7 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 
 	dev_dbg(&priv->i2c->dev,
 			"%s: target_mclk=%d ts_clk=%d divide_ratio=%d\n",
-			__func__, target_mclk, ts_clk, divide_ratio);
+			__func__, target_mclk, priv->cfg->ts_clk, divide_ratio);
 
 	u8tmp1--;
 	u8tmp2--;
@@ -1053,6 +1037,39 @@ err:
 	return ret;
 }
 
+static int m88ds3103_set_voltage(struct dvb_frontend *fe,
+	fe_sec_voltage_t voltage)
+{
+	struct m88ds3103_priv *priv = fe->demodulator_priv;
+	u8 data;
+
+	m88ds3103_rd_reg(priv, 0xa2, &data);
+
+	data &= ~0x03; /* bit0 V/H, bit1 off/on */
+	if (priv->cfg->lnb_en_pol)
+		data |= 0x02;
+
+	switch (voltage) {
+	case SEC_VOLTAGE_18:
+		if (priv->cfg->lnb_hv_pol == 0)
+			data |= 0x01;
+		break;
+	case SEC_VOLTAGE_13:
+		if (priv->cfg->lnb_hv_pol)
+			data |= 0x01;
+		break;
+	case SEC_VOLTAGE_OFF:
+		if (priv->cfg->lnb_en_pol)
+			data &= ~0x02;
+		else
+			data |= 0x02;
+		break;
+	}
+	m88ds3103_wr_reg(priv, 0xa2, data);
+
+	return 0;
+}
+
 static int m88ds3103_diseqc_send_master_cmd(struct dvb_frontend *fe,
 		struct dvb_diseqc_master_cmd *diseqc_cmd)
 {
@@ -1370,6 +1387,7 @@ static struct dvb_frontend_ops m88ds3103_ops = {
 	.diseqc_send_burst = m88ds3103_diseqc_send_burst,
 
 	.set_tone = m88ds3103_set_tone,
+	.set_voltage = m88ds3103_set_voltage,
 };
 
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
diff --git a/drivers/media/dvb-frontends/m88ds3103.h b/drivers/media/dvb-frontends/m88ds3103.h
index bbb7e3a..9b3b496 100644
--- a/drivers/media/dvb-frontends/m88ds3103.h
+++ b/drivers/media/dvb-frontends/m88ds3103.h
@@ -47,14 +47,23 @@ struct m88ds3103_config {
 	 */
 #define M88DS3103_TS_SERIAL             0 /* TS output pin D0, normal */
 #define M88DS3103_TS_SERIAL_D7          1 /* TS output pin D7 */
-#define M88DS3103_TS_PARALLEL           2 /* 24 MHz, normal */
-#define M88DS3103_TS_PARALLEL_12        3 /* 12 MHz */
-#define M88DS3103_TS_PARALLEL_16        4 /* 16 MHz */
-#define M88DS3103_TS_PARALLEL_19_2      5 /* 19.2 MHz */
-#define M88DS3103_TS_CI                 6 /* 6 MHz */
+#define M88DS3103_TS_PARALLEL           2 /* TS Parallel mode */
+#define M88DS3103_TS_CI                 3 /* TS CI Mode */
 	u8 ts_mode;
 
 	/*
+	 * TS clk in KHz
+	 * Default: 0.
+	 */
+	u32 ts_clk;
+
+	/*
+	 * TS clk polarity.
+	 * Default: 0. 1-active at falling edge; 0-active at rising edge.
+	 */
+	u8 ts_clk_pol:1;
+
+	/*
 	 * spectrum inversion
 	 * Default: 0
 	 */
@@ -86,6 +95,22 @@ struct m88ds3103_config {
 	 * Default: none, must set
 	 */
 	u8 agc;
+
+	/*
+	 * LNB H/V pin polarity
+	 * Default: 0.
+	 * 1: pin high set to VOLTAGE_13, pin low to set VOLTAGE_18.
+	 * 0: pin high set to VOLTAGE_18, pin low to set VOLTAGE_13.
+	 */
+	u8 lnb_hv_pol:1;
+
+	/*
+	 * LNB enable pin polarity
+	 * Default: 0.
+	 * 1: pin high to enable, pin low to disable.
+	 * 0: pin high to disable, pin low to enable.
+	 */
+	u8 lnb_en_pol:1;
 };
 
 /*
-- 
1.9.1

