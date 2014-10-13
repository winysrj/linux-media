Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:44643 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbaJMGoR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Oct 2014 02:44:17 -0400
Received: by mail-pd0-f182.google.com with SMTP id y10so5195029pdj.13
        for <linux-media@vger.kernel.org>; Sun, 12 Oct 2014 23:44:17 -0700 (PDT)
Date: Mon, 13 Oct 2014 14:44:14 +0800
From: "Nibble Max" <nibble.max@gmail.com>
To: "Antti Palosaari" <crope@iki.fi>
Cc: "linux-media" <linux-media@vger.kernel.org>,
	"Olli Salonen" <olli.salonen@iki.fi>
Subject: [PATCH 3/3] DVBSky V3 PCIe card: add some changes to M88DS3103 for supporting the demod of M88RS6000
Message-ID: <201410131444110937756@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

M88RS6000 is the integrated chip, which includes tuner and demod.
Its internal demod is similar with M88DS3103 except some registers definition.
The main different part of this internal demod from others is its clock/pll generation IP block sitting inside the tuner die.
So clock/pll functions should be configed through its tuner i2c bus, NOT its demod i2c bus.
The demod of M88RS6000 need the firmware: dvb-demod-m88rs6000.fw
firmware download link: http://www.dvbsky.net/download/linux/dvbsky-firmware.tar.gz

Signed-off-by: Nibble Max <nibble.max@gmail.com>
---
 drivers/media/dvb-frontends/m88ds3103.c      | 253 ++++++++++++++++++++-------
 drivers/media/dvb-frontends/m88ds3103_priv.h | 188 ++++++++++++++++++++
 2 files changed, 374 insertions(+), 67 deletions(-)

diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
index 81657e9..7fbbf67 100644
--- a/drivers/media/dvb-frontends/m88ds3103.c
+++ b/drivers/media/dvb-frontends/m88ds3103.c
@@ -1,5 +1,5 @@
 /*
- * Montage M88DS3103 demodulator driver
+ * Montage M88DS3103/M88RS6000 demodulator driver
  *
  * Copyright (C) 2013 Antti Palosaari <crope@iki.fi>
  *
@@ -162,7 +162,7 @@ static int m88ds3103_wr_reg_val_tab(struct m88ds3103_priv *priv,
 
 	dev_dbg(&priv->i2c->dev, "%s: tab_len=%d\n", __func__, tab_len);
 
-	if (tab_len > 83) {
+	if (tab_len > 86) {
 		ret = -EINVAL;
 		goto err;
 	}
@@ -172,7 +172,8 @@ static int m88ds3103_wr_reg_val_tab(struct m88ds3103_priv *priv,
 
 		if (i == tab_len - 1 || tab[i].reg != tab[i + 1].reg - 1 ||
 				!((j + 1) % (priv->cfg->i2c_wr_max - 1))) {
-			ret = m88ds3103_wr_regs(priv, tab[i].reg - j, buf, j + 1);
+			ret = m88ds3103_wr_regs(priv,
+					tab[i].reg - j, buf, j + 1);
 			if (ret)
 				goto err;
 
@@ -250,6 +251,7 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 	u16 u16tmp, divide_ratio;
 	u32 tuner_frequency, target_mclk;
 	s32 s32tmp;
+	struct m88rs6000_mclk_config mclk_cfg;
 
 	dev_dbg(&priv->i2c->dev,
 			"%s: delivery_system=%d modulation=%d frequency=%d symbol_rate=%d inversion=%d pilot=%d rolloff=%d\n",
@@ -291,6 +293,26 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
+	if (priv->chip_id == M88RS6000_CHIP_ID) {
+		ret = m88ds3103_wr_reg(priv, 0x06, 0xe0);
+		if (ret)
+			goto err;
+		if (fe->ops.tuner_ops.set_config) {
+			/* select main mclk */
+			mclk_cfg.config_op = 0;
+			mclk_cfg.TunerfreqMHz = c->frequency / 1000;
+			mclk_cfg.SymRateKSs = c->symbol_rate / 1000;
+			ret = fe->ops.tuner_ops.set_config(fe, &mclk_cfg);
+			if (ret)
+				goto err;
+			priv->mclk_khz = mclk_cfg.MclkKHz;
+		}
+		ret = m88ds3103_wr_reg(priv, 0x06, 0x00);
+		if (ret)
+			goto err;
+		usleep_range(10000, 20000);
+	}
+
 	ret = m88ds3103_wr_reg(priv, 0xb2, 0x01);
 	if (ret)
 		goto err;
@@ -301,36 +323,62 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 
 	switch (c->delivery_system) {
 	case SYS_DVBS:
-		len = ARRAY_SIZE(m88ds3103_dvbs_init_reg_vals);
-		init = m88ds3103_dvbs_init_reg_vals;
+		if (priv->chip_id == M88RS6000_CHIP_ID) {
+			len = ARRAY_SIZE(m88rs6000_dvbs_init_reg_vals);
+			init = m88rs6000_dvbs_init_reg_vals;
+		} else {
+			len = ARRAY_SIZE(m88ds3103_dvbs_init_reg_vals);
+			init = m88ds3103_dvbs_init_reg_vals;
+		}
 		target_mclk = 96000;
 		break;
 	case SYS_DVBS2:
-		len = ARRAY_SIZE(m88ds3103_dvbs2_init_reg_vals);
-		init = m88ds3103_dvbs2_init_reg_vals;
+		if (priv->chip_id == M88RS6000_CHIP_ID) {
+			len = ARRAY_SIZE(m88rs6000_dvbs2_init_reg_vals);
+			init = m88rs6000_dvbs2_init_reg_vals;
 
-		switch (priv->cfg->ts_mode) {
-		case M88DS3103_TS_SERIAL:
-		case M88DS3103_TS_SERIAL_D7:
-			if (c->symbol_rate < 18000000)
+			switch (priv->cfg->ts_mode) {
+			case M88DS3103_TS_SERIAL:
+			case M88DS3103_TS_SERIAL_D7:
 				target_mclk = 96000;
-			else
+				break;
+			case M88DS3103_TS_PARALLEL:
+			case M88DS3103_TS_CI:
 				target_mclk = 144000;
-			break;
-		case M88DS3103_TS_PARALLEL:
-		case M88DS3103_TS_CI:
-			if (c->symbol_rate < 18000000)
-				target_mclk = 96000;
-			else if (c->symbol_rate < 28000000)
-				target_mclk = 144000;
-			else
-				target_mclk = 192000;
-			break;
-		default:
-			dev_dbg(&priv->i2c->dev, "%s: invalid ts_mode\n",
-					__func__);
-			ret = -EINVAL;
-			goto err;
+				break;
+			default:
+				dev_dbg(&priv->i2c->dev, "%s: invalid ts_mode\n",
+						__func__);
+				ret = -EINVAL;
+				goto err;
+			}
+		} else {
+			len = ARRAY_SIZE(m88ds3103_dvbs2_init_reg_vals);
+			init = m88ds3103_dvbs2_init_reg_vals;
+
+			switch (priv->cfg->ts_mode) {
+			case M88DS3103_TS_SERIAL:
+			case M88DS3103_TS_SERIAL_D7:
+				if (c->symbol_rate < 18000000)
+					target_mclk = 96000;
+				else
+					target_mclk = 144000;
+				break;
+			case M88DS3103_TS_PARALLEL:
+			case M88DS3103_TS_CI:
+				if (c->symbol_rate < 18000000)
+					target_mclk = 96000;
+				else if (c->symbol_rate < 28000000)
+					target_mclk = 144000;
+				else
+					target_mclk = 192000;
+				break;
+			default:
+				dev_dbg(&priv->i2c->dev, "%s: invalid ts_mode\n",
+						__func__);
+				ret = -EINVAL;
+				goto err;
+			}
 		}
 		break;
 	default:
@@ -347,7 +395,25 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 			goto err;
 	}
 
+	if ((priv->chip_id == M88RS6000_CHIP_ID)
+		&& (c->delivery_system == SYS_DVBS2)
+		&& ((c->symbol_rate / 1000) <= 5000)) {
+		ret = m88ds3103_wr_reg(priv, 0xc0, 0x04);
+		if (ret)
+			goto err;
+		ret = m88ds3103_wr_reg(priv, 0x8a, 0x09);
+		if (ret)
+			goto err;
+		ret = m88ds3103_wr_reg(priv, 0x8b, 0x22);
+		if (ret)
+			goto err;
+		ret = m88ds3103_wr_reg(priv, 0x8c, 0x88);
+		if (ret)
+			goto err;
+	}
+
 	u8tmp1 = 0; /* silence compiler warning */
+	u8tmp2 = 0;
 	switch (priv->cfg->ts_mode) {
 	case M88DS3103_TS_SERIAL:
 		u8tmp1 = 0x00;
@@ -385,6 +451,56 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 			goto err;
 	}
 
+	/* set ts mclk */
+	if (priv->chip_id == M88RS6000_CHIP_ID) {
+		ret = m88ds3103_wr_reg(priv, 0x06, 0xe0);
+		if (ret)
+			goto err;
+		if (fe->ops.tuner_ops.set_config) {
+			/* set ts mclk */
+			mclk_cfg.config_op = 1;
+			mclk_cfg.SymRateKSs = c->symbol_rate / 1000;
+			mclk_cfg.MclkKHz = target_mclk;
+			ret = fe->ops.tuner_ops.set_config(fe, &mclk_cfg);
+			if (ret)
+				goto err;
+			target_mclk = mclk_cfg.MclkKHz;
+		}
+		ret = m88ds3103_wr_reg(priv, 0x06, 0x00);
+		if (ret)
+			goto err;
+		ret = m88ds3103_wr_reg_mask(priv, 0x9d, 0x08, 0x08);
+		if (ret)
+			goto err;
+		ret = m88ds3103_wr_reg(priv, 0xf1, 0x01);
+		if (ret)
+			goto err;
+		ret = m88ds3103_wr_reg_mask(priv, 0x30, 0x80, 0x80);
+		if (ret)
+			goto err;
+	} else {
+		switch (target_mclk) {
+		case 96000:
+			u8tmp1 = 0x02; /* 0b10 */
+			u8tmp2 = 0x01; /* 0b01 */
+			break;
+		case 144000:
+			u8tmp1 = 0x00; /* 0b00 */
+			u8tmp2 = 0x01; /* 0b01 */
+			break;
+		case 192000:
+			u8tmp1 = 0x03; /* 0b11 */
+			u8tmp2 = 0x00; /* 0b00 */
+			break;
+		}
+		ret = m88ds3103_wr_reg_mask(priv, 0x22, u8tmp1 << 6, 0xc0);
+		if (ret)
+			goto err;
+		ret = m88ds3103_wr_reg_mask(priv, 0x24, u8tmp2 << 6, 0xc0);
+		if (ret)
+			goto err;
+	}
+
 	if (priv->cfg->ts_clk) {
 		divide_ratio = DIV_ROUND_UP(target_mclk, priv->cfg->ts_clk);
 		u8tmp1 = divide_ratio / 2;
@@ -420,29 +536,6 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	switch (target_mclk) {
-	case 96000:
-		u8tmp1 = 0x02; /* 0b10 */
-		u8tmp2 = 0x01; /* 0b01 */
-		break;
-	case 144000:
-		u8tmp1 = 0x00; /* 0b00 */
-		u8tmp2 = 0x01; /* 0b01 */
-		break;
-	case 192000:
-		u8tmp1 = 0x03; /* 0b11 */
-		u8tmp2 = 0x00; /* 0b00 */
-		break;
-	}
-
-	ret = m88ds3103_wr_reg_mask(priv, 0x22, u8tmp1 << 6, 0xc0);
-	if (ret)
-		goto err;
-
-	ret = m88ds3103_wr_reg_mask(priv, 0x24, u8tmp2 << 6, 0xc0);
-	if (ret)
-		goto err;
-
 	if (c->symbol_rate <= 3000000)
 		u8tmp = 0x20;
 	else if (c->symbol_rate <= 10000000)
@@ -466,7 +559,8 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	u16tmp = DIV_ROUND_CLOSEST((c->symbol_rate / 1000) << 15, M88DS3103_MCLK_KHZ / 2);
+	u16tmp = DIV_ROUND_CLOSEST(
+		(c->symbol_rate / 1000) << 15, priv->mclk_khz / 2);
 	buf[0] = (u16tmp >> 0) & 0xff;
 	buf[1] = (u16tmp >> 8) & 0xff;
 	ret = m88ds3103_wr_regs(priv, 0x61, buf, 2);
@@ -489,7 +583,7 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 			(tuner_frequency - c->frequency));
 
 	s32tmp = 0x10000 * (tuner_frequency - c->frequency);
-	s32tmp = DIV_ROUND_CLOSEST(s32tmp, M88DS3103_MCLK_KHZ);
+	s32tmp = DIV_ROUND_CLOSEST(s32tmp, priv->mclk_khz);
 	if (s32tmp < 0)
 		s32tmp += 0x10000;
 
@@ -520,7 +614,7 @@ static int m88ds3103_init(struct dvb_frontend *fe)
 	struct m88ds3103_priv *priv = fe->demodulator_priv;
 	int ret, len, remaining;
 	const struct firmware *fw = NULL;
-	u8 *fw_file = M88DS3103_FIRMWARE;
+	u8 *fw_file;
 	u8 u8tmp;
 
 	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
@@ -541,15 +635,6 @@ static int m88ds3103_init(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	/* reset */
-	ret = m88ds3103_wr_reg(priv, 0x07, 0x60);
-	if (ret)
-		goto err;
-
-	ret = m88ds3103_wr_reg(priv, 0x07, 0x00);
-	if (ret)
-		goto err;
-
 	/* firmware status */
 	ret = m88ds3103_rd_reg(priv, 0xb9, &u8tmp);
 	if (ret)
@@ -560,10 +645,23 @@ static int m88ds3103_init(struct dvb_frontend *fe)
 	if (u8tmp)
 		goto skip_fw_download;
 
+	/* global reset, global diseqc reset, golbal fec reset */
+	ret = m88ds3103_wr_reg(priv, 0x07, 0xe0);
+	if (ret)
+		goto err;
+
+	ret = m88ds3103_wr_reg(priv, 0x07, 0x00);
+	if (ret)
+		goto err;
+
 	/* cold state - try to download firmware */
 	dev_info(&priv->i2c->dev, "%s: found a '%s' in cold state\n",
 			KBUILD_MODNAME, m88ds3103_ops.info.name);
 
+	if (priv->chip_id == M88RS6000_CHIP_ID)
+		fw_file = M88RS6000_FIRMWARE;
+	else
+		fw_file = M88DS3103_FIRMWARE;
 	/* request the firmware, this will block and timeout */
 	ret = request_firmware(&fw, fw_file, priv->i2c->dev.parent);
 	if (ret) {
@@ -635,13 +733,18 @@ static int m88ds3103_sleep(struct dvb_frontend *fe)
 {
 	struct m88ds3103_priv *priv = fe->demodulator_priv;
 	int ret;
+	u8 u8reg;
 
 	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
 
 	priv->delivery_system = SYS_UNDEFINED;
 
 	/* TS Hi-Z */
-	ret = m88ds3103_wr_reg_mask(priv, 0x27, 0x00, 0x01);
+	if (priv->chip_id == M88RS6000_CHIP_ID)
+		u8reg = 0x29;
+	else
+		u8reg = 0x27;
+	ret = m88ds3103_wr_reg_mask(priv, u8reg, 0x00, 0x01);
 	if (ret)
 		goto err;
 
@@ -830,7 +933,7 @@ static int m88ds3103_get_frontend(struct dvb_frontend *fe)
 		goto err;
 
 	c->symbol_rate = 1ull * ((buf[1] << 8) | (buf[0] << 0)) *
-			M88DS3103_MCLK_KHZ * 1000 / 0x10000;
+			priv->mclk_khz * 1000 / 0x10000;
 
 	return 0;
 err:
@@ -1310,18 +1413,22 @@ struct dvb_frontend *m88ds3103_attach(const struct m88ds3103_config *cfg,
 	priv->i2c = i2c;
 	mutex_init(&priv->i2c_mutex);
 
-	ret = m88ds3103_rd_reg(priv, 0x01, &chip_id);
+	/* 0x00: chip id[6:0], 0x01: chip ver[7:0], 0x02: chip ver[15:8] */
+	ret = m88ds3103_rd_reg(priv, 0x00, &chip_id);
 	if (ret)
 		goto err;
 
-	dev_dbg(&priv->i2c->dev, "%s: chip_id=%02x\n", __func__, chip_id);
+	chip_id >>= 1;
+	dev_info(&priv->i2c->dev, "%s: chip_id=%02x\n", __func__, chip_id);
 
 	switch (chip_id) {
-	case 0xd0:
+	case M88RS6000_CHIP_ID:
+	case M88DS3103_CHIP_ID:
 		break;
 	default:
 		goto err;
 	}
+	priv->chip_id = chip_id;
 
 	switch (priv->cfg->clock_out) {
 	case M88DS3103_CLOCK_OUT_DISABLED:
@@ -1337,6 +1444,11 @@ struct dvb_frontend *m88ds3103_attach(const struct m88ds3103_config *cfg,
 		goto err;
 	}
 
+	/* 0x29 register is defined differently for m88rs6000. */
+	/* set internal tuner address to 0x42 */
+	if (chip_id == M88RS6000_CHIP_ID)
+		u8tmp = 0x00;
+
 	ret = m88ds3103_wr_reg(priv, 0x29, u8tmp);
 	if (ret)
 		goto err;
@@ -1362,8 +1474,14 @@ struct dvb_frontend *m88ds3103_attach(const struct m88ds3103_config *cfg,
 
 	*tuner_i2c_adapter = priv->i2c_adapter;
 
+	/* set main mclk to default value */
+	priv->mclk_khz = M88DS3103_MCLK_KHZ;
+
 	/* create dvb_frontend */
 	memcpy(&priv->fe.ops, &m88ds3103_ops, sizeof(struct dvb_frontend_ops));
+	if (priv->chip_id == M88RS6000_CHIP_ID)
+		strncpy(priv->fe.ops.info.name,
+			"Montage M88RS6000", sizeof(priv->fe.ops.info.name));
 	priv->fe.demodulator_priv = priv;
 
 	return &priv->fe;
@@ -1423,3 +1541,4 @@ MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
 MODULE_DESCRIPTION("Montage M88DS3103 DVB-S/S2 demodulator driver");
 MODULE_LICENSE("GPL");
 MODULE_FIRMWARE(M88DS3103_FIRMWARE);
+MODULE_FIRMWARE(M88RS6000_FIRMWARE);
diff --git a/drivers/media/dvb-frontends/m88ds3103_priv.h b/drivers/media/dvb-frontends/m88ds3103_priv.h
index 9169fdd..fcd205c 100644
--- a/drivers/media/dvb-frontends/m88ds3103_priv.h
+++ b/drivers/media/dvb-frontends/m88ds3103_priv.h
@@ -25,7 +25,10 @@
 #include <linux/math64.h>
 
 #define M88DS3103_FIRMWARE "dvb-demod-m88ds3103.fw"
+#define M88RS6000_FIRMWARE "dvb-demod-m88rs6000.fw"
 #define M88DS3103_MCLK_KHZ 96000
+#define M88RS6000_CHIP_ID 0x74
+#define M88DS3103_CHIP_ID 0x70
 
 struct m88ds3103_priv {
 	struct i2c_adapter *i2c;
@@ -38,6 +41,10 @@ struct m88ds3103_priv {
 	u32 ber;
 	bool warm; /* FW running */
 	struct i2c_adapter *i2c_adapter;
+	/* auto detect chip id to do different config */
+	u8 chip_id;
+	/* main mclk is calculated for M88RS6000 dynamically */
+	u32 mclk_khz;
 };
 
 struct m88ds3103_reg_val {
@@ -45,6 +52,13 @@ struct m88ds3103_reg_val {
 	u8 val;
 };
 
+struct m88rs6000_mclk_config {
+	u8 config_op; /* 0: main mclk, 1: ts mclk. */
+	u32 TunerfreqMHz;
+	u32 SymRateKSs;
+	u32 MclkKHz; /* depend on config_op value, main mclk or ts mclk */
+};
+
 static const struct m88ds3103_reg_val m88ds3103_dvbs_init_reg_vals[] = {
 	{0x23, 0x07},
 	{0x08, 0x03},
@@ -214,4 +228,178 @@ static const struct m88ds3103_reg_val m88ds3103_dvbs2_init_reg_vals[] = {
 	{0xb8, 0x00},
 };
 
+static const struct m88ds3103_reg_val m88rs6000_dvbs_init_reg_vals[] = {
+	{0x23, 0x07},
+	{0x08, 0x03},
+	{0x0c, 0x02},
+	{0x20, 0x00},
+	{0x21, 0x54},
+	{0x25, 0x82},
+	{0x27, 0x31},
+	{0x30, 0x08},
+	{0x31, 0x40},
+	{0x32, 0x32},
+	{0x33, 0x35},
+	{0x35, 0xff},
+	{0x3a, 0x00},
+	{0x37, 0x10},
+	{0x38, 0x10},
+	{0x39, 0x02},
+	{0x42, 0x60},
+	{0x4a, 0x80},
+	{0x4b, 0x04},
+	{0x4d, 0x91},
+	{0x5d, 0xc8},
+	{0x50, 0x36},
+	{0x51, 0x36},
+	{0x52, 0x36},
+	{0x53, 0x36},
+	{0x63, 0x0f},
+	{0x64, 0x30},
+	{0x65, 0x40},
+	{0x68, 0x26},
+	{0x69, 0x4c},
+	{0x70, 0x20},
+	{0x71, 0x70},
+	{0x72, 0x04},
+	{0x73, 0x00},
+	{0x70, 0x40},
+	{0x71, 0x70},
+	{0x72, 0x04},
+	{0x73, 0x00},
+	{0x70, 0x60},
+	{0x71, 0x70},
+	{0x72, 0x04},
+	{0x73, 0x00},
+	{0x70, 0x80},
+	{0x71, 0x70},
+	{0x72, 0x04},
+	{0x73, 0x00},
+	{0x70, 0xa0},
+	{0x71, 0x70},
+	{0x72, 0x04},
+	{0x73, 0x00},
+	{0x70, 0x1f},
+	{0x76, 0x38},
+	{0x77, 0xa6},
+	{0x78, 0x0c},
+	{0x79, 0x80},
+	{0x7f, 0x14},
+	{0x7c, 0x00},
+	{0xae, 0x82},
+	{0x80, 0x64},
+	{0x81, 0x66},
+	{0x82, 0x44},
+	{0x85, 0x04},
+	{0xcd, 0xf4},
+	{0x90, 0x33},
+	{0xa0, 0x44},
+	{0xbe, 0x00},
+	{0xc0, 0x08},
+	{0xc3, 0x10},
+	{0xc4, 0x08},
+	{0xc5, 0xf0},
+	{0xc6, 0xff},
+	{0xc7, 0x00},
+	{0xc8, 0x1a},
+	{0xc9, 0x80},
+	{0xe0, 0xf8},
+	{0xe6, 0x8b},
+	{0xd0, 0x40},
+	{0xf8, 0x20},
+	{0xfa, 0x0f},
+	{0x00, 0x00},
+	{0xbd, 0x01},
+	{0xb8, 0x00},
+	{0x29, 0x11},
+};
+
+static const struct m88ds3103_reg_val m88rs6000_dvbs2_init_reg_vals[] = {
+	{0x23, 0x07},
+	{0x08, 0x07},
+	{0x0c, 0x02},
+	{0x20, 0x00},
+	{0x21, 0x54},
+	{0x25, 0x82},
+	{0x27, 0x31},
+	{0x30, 0x08},
+	{0x32, 0x32},
+	{0x33, 0x35},
+	{0x35, 0xff},
+	{0x3a, 0x00},
+	{0x37, 0x10},
+	{0x38, 0x10},
+	{0x39, 0x02},
+	{0x42, 0x60},
+	{0x4a, 0x80},
+	{0x4b, 0x04},
+	{0x4d, 0x91},
+	{0x5d, 0xc8},
+	{0x50, 0x36},
+	{0x51, 0x36},
+	{0x52, 0x36},
+	{0x53, 0x36},
+	{0x63, 0x0f},
+	{0x64, 0x10},
+	{0x65, 0x20},
+	{0x68, 0x46},
+	{0x69, 0xcd},
+	{0x70, 0x20},
+	{0x71, 0x70},
+	{0x72, 0x04},
+	{0x73, 0x00},
+	{0x70, 0x40},
+	{0x71, 0x70},
+	{0x72, 0x04},
+	{0x73, 0x00},
+	{0x70, 0x60},
+	{0x71, 0x70},
+	{0x72, 0x04},
+	{0x73, 0x00},
+	{0x70, 0x80},
+	{0x71, 0x70},
+	{0x72, 0x04},
+	{0x73, 0x00},
+	{0x70, 0xa0},
+	{0x71, 0x70},
+	{0x72, 0x04},
+	{0x73, 0x00},
+	{0x70, 0x1f},
+	{0x76, 0x38},
+	{0x77, 0xa6},
+	{0x78, 0x0c},
+	{0x79, 0x80},
+	{0x7f, 0x14},
+	{0x85, 0x08},
+	{0xcd, 0xf4},
+	{0x90, 0x33},
+	{0x86, 0x00},
+	{0x87, 0x0f},
+	{0x89, 0x00},
+	{0x8b, 0x44},
+	{0x8c, 0x66},
+	{0x9d, 0xc1},
+	{0x8a, 0x10},
+	{0xad, 0x40},
+	{0xa0, 0x44},
+	{0xbe, 0x00},
+	{0xc0, 0x08},
+	{0xc1, 0x10},
+	{0xc2, 0x08},
+	{0xc3, 0x10},
+	{0xc4, 0x08},
+	{0xc5, 0xf0},
+	{0xc6, 0xff},
+	{0xc7, 0x00},
+	{0xc8, 0x1a},
+	{0xc9, 0x80},
+	{0xca, 0x23},
+	{0xcb, 0x24},
+	{0xcc, 0xf4},
+	{0xce, 0x74},
+	{0x00, 0x00},
+	{0xbd, 0x01},
+	{0xb8, 0x00},
+	{0x29, 0x01},
+};
 #endif

-- 
1.9.1

