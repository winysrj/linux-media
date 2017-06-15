Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36375 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751955AbdFODbf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Jun 2017 23:31:35 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 06/15] af9013: convert to regmap api
Date: Thu, 15 Jun 2017 06:30:56 +0300
Message-Id: <20170615033105.13517-6-crope@iki.fi>
In-Reply-To: <20170615033105.13517-1-crope@iki.fi>
References: <20170615033105.13517-1-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use regmap for register access. Own low level i2c read and write
routines for regmap is still needed because chip uses single command
byte in addition to typical i2c register access.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/Kconfig       |   1 +
 drivers/media/dvb-frontends/af9013.c      | 598 +++++++++++++++---------------
 drivers/media/dvb-frontends/af9013_priv.h |   1 +
 3 files changed, 294 insertions(+), 306 deletions(-)

diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
index e8c6554..3a260b8 100644
--- a/drivers/media/dvb-frontends/Kconfig
+++ b/drivers/media/dvb-frontends/Kconfig
@@ -436,6 +436,7 @@ config DVB_TDA10048
 config DVB_AF9013
 	tristate "Afatech AF9013 demodulator"
 	depends on DVB_CORE && I2C
+	select REGMAP
 	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y when you want to support this frontend.
diff --git a/drivers/media/dvb-frontends/af9013.c b/drivers/media/dvb-frontends/af9013.c
index 781e958..70102c1 100644
--- a/drivers/media/dvb-frontends/af9013.c
+++ b/drivers/media/dvb-frontends/af9013.c
@@ -20,11 +20,9 @@
 
 #include "af9013_priv.h"
 
-/* Max transfer size done by I2C transfer functions */
-#define MAX_XFER_SIZE  64
-
 struct af9013_state {
 	struct i2c_client *client;
+	struct regmap *regmap;
 	struct dvb_frontend fe;
 	u32 clk;
 	u8 tuner;
@@ -50,181 +48,6 @@ struct af9013_state {
 	struct delayed_work statistics_work;
 };
 
-/* write multiple registers */
-static int af9013_wr_regs_i2c(struct af9013_state *state, u8 mbox, u16 reg,
-	const u8 *val, int len)
-{
-	struct i2c_client *client = state->client;
-	int ret;
-	u8 buf[MAX_XFER_SIZE];
-	struct i2c_msg msg[1] = {
-		{
-			.addr = state->client->addr,
-			.flags = 0,
-			.len = 3 + len,
-			.buf = buf,
-		}
-	};
-
-	if (3 + len > sizeof(buf)) {
-		dev_warn(&client->dev, "i2c wr reg %04x, len %d, is too big!\n",
-			 reg, len);
-		return -EINVAL;
-	}
-
-	buf[0] = (reg >> 8) & 0xff;
-	buf[1] = (reg >> 0) & 0xff;
-	buf[2] = mbox;
-	memcpy(&buf[3], val, len);
-
-	ret = i2c_transfer(state->client->adapter, msg, 1);
-	if (ret == 1) {
-		ret = 0;
-	} else {
-		dev_warn(&client->dev, "i2c wr failed %d, reg %04x, len %d\n",
-			 ret, reg, len);
-		ret = -EREMOTEIO;
-	}
-	return ret;
-}
-
-/* read multiple registers */
-static int af9013_rd_regs_i2c(struct af9013_state *state, u8 mbox, u16 reg,
-	u8 *val, int len)
-{
-	struct i2c_client *client = state->client;
-	int ret;
-	u8 buf[3];
-	struct i2c_msg msg[2] = {
-		{
-			.addr = state->client->addr,
-			.flags = 0,
-			.len = 3,
-			.buf = buf,
-		}, {
-			.addr = state->client->addr,
-			.flags = I2C_M_RD,
-			.len = len,
-			.buf = val,
-		}
-	};
-
-	buf[0] = (reg >> 8) & 0xff;
-	buf[1] = (reg >> 0) & 0xff;
-	buf[2] = mbox;
-
-	ret = i2c_transfer(state->client->adapter, msg, 2);
-	if (ret == 2) {
-		ret = 0;
-	} else {
-		dev_warn(&client->dev, "i2c rd failed %d, reg %04x, len %d\n",
-			 ret, reg, len);
-		ret = -EREMOTEIO;
-	}
-	return ret;
-}
-
-/* write multiple registers */
-static int af9013_wr_regs(struct af9013_state *state, u16 reg, const u8 *val,
-	int len)
-{
-	int ret, i;
-	u8 mbox = (0 << 7)|(0 << 6)|(1 << 1)|(1 << 0);
-
-	if ((state->ts_mode == AF9013_TS_USB) &&
-		((reg & 0xff00) != 0xff00) && ((reg & 0xff00) != 0xae00)) {
-		mbox |= ((len - 1) << 2);
-		ret = af9013_wr_regs_i2c(state, mbox, reg, val, len);
-	} else {
-		for (i = 0; i < len; i++) {
-			ret = af9013_wr_regs_i2c(state, mbox, reg+i, val+i, 1);
-			if (ret)
-				goto err;
-		}
-	}
-
-err:
-	return 0;
-}
-
-/* read multiple registers */
-static int af9013_rd_regs(struct af9013_state *state, u16 reg, u8 *val, int len)
-{
-	int ret, i;
-	u8 mbox = (0 << 7)|(0 << 6)|(1 << 1)|(0 << 0);
-
-	if ((state->ts_mode == AF9013_TS_USB) &&
-		((reg & 0xff00) != 0xff00) && ((reg & 0xff00) != 0xae00)) {
-		mbox |= ((len - 1) << 2);
-		ret = af9013_rd_regs_i2c(state, mbox, reg, val, len);
-	} else {
-		for (i = 0; i < len; i++) {
-			ret = af9013_rd_regs_i2c(state, mbox, reg+i, val+i, 1);
-			if (ret)
-				goto err;
-		}
-	}
-
-err:
-	return 0;
-}
-
-/* write single register */
-static int af9013_wr_reg(struct af9013_state *state, u16 reg, u8 val)
-{
-	return af9013_wr_regs(state, reg, &val, 1);
-}
-
-/* read single register */
-static int af9013_rd_reg(struct af9013_state *state, u16 reg, u8 *val)
-{
-	return af9013_rd_regs(state, reg, val, 1);
-}
-
-static int af9013_write_ofsm_regs(struct af9013_state *state, u16 reg, u8 *val,
-	u8 len)
-{
-	u8 mbox = (1 << 7)|(1 << 6)|((len - 1) << 2)|(1 << 1)|(1 << 0);
-	return af9013_wr_regs_i2c(state, mbox, reg, val, len);
-}
-
-static int af9013_wr_reg_bits(struct af9013_state *state, u16 reg, int pos,
-	int len, u8 val)
-{
-	int ret;
-	u8 tmp, mask;
-
-	/* no need for read if whole reg is written */
-	if (len != 8) {
-		ret = af9013_rd_reg(state, reg, &tmp);
-		if (ret)
-			return ret;
-
-		mask = (0xff >> (8 - len)) << pos;
-		val <<= pos;
-		tmp &= ~mask;
-		val |= tmp;
-	}
-
-	return af9013_wr_reg(state, reg, val);
-}
-
-static int af9013_rd_reg_bits(struct af9013_state *state, u16 reg, int pos,
-	int len, u8 *val)
-{
-	int ret;
-	u8 tmp;
-
-	ret = af9013_rd_reg(state, reg, &tmp);
-	if (ret)
-		return ret;
-
-	*val = (tmp >> pos);
-	*val &= (0xff >> (8 - len));
-
-	return 0;
-}
-
 static int af9013_set_gpio(struct af9013_state *state, u8 gpio, u8 gpioval)
 {
 	struct i2c_client *client = state->client;
@@ -266,7 +89,8 @@ static int af9013_set_gpio(struct af9013_state *state, u8 gpio, u8 gpioval)
 		break;
 	}
 
-	ret = af9013_wr_reg_bits(state, addr, pos, 4, gpioval);
+	ret = regmap_update_bits(state->regmap, addr, 0x0f << pos,
+				 gpioval << pos);
 	if (ret)
 		goto err;
 
@@ -279,50 +103,48 @@ static int af9013_set_gpio(struct af9013_state *state, u8 gpio, u8 gpioval)
 static int af9013_power_ctrl(struct af9013_state *state, u8 onoff)
 {
 	struct i2c_client *client = state->client;
-	int ret, i;
-	u8 tmp;
+	int ret;
+	unsigned int utmp;
 
 	dev_dbg(&client->dev, "onoff %d\n", onoff);
 
 	/* enable reset */
-	ret = af9013_wr_reg_bits(state, 0xd417, 4, 1, 1);
+	ret = regmap_update_bits(state->regmap, 0xd417, 0x10, 0x10);
 	if (ret)
 		goto err;
 
 	/* start reset mechanism */
-	ret = af9013_wr_reg(state, 0xaeff, 1);
+	ret = regmap_write(state->regmap, 0xaeff, 0x01);
 	if (ret)
 		goto err;
 
 	/* wait reset performs */
-	for (i = 0; i < 150; i++) {
-		ret = af9013_rd_reg_bits(state, 0xd417, 1, 1, &tmp);
-		if (ret)
-			goto err;
-
-		if (tmp)
-			break; /* reset done */
-
-		usleep_range(5000, 25000);
-	}
+	ret = regmap_read_poll_timeout(state->regmap, 0xd417, utmp,
+				       (utmp >> 1) & 0x01, 5000, 1000000);
+	if (ret)
+		goto err;
 
-	if (!tmp)
+	if (!((utmp >> 1) & 0x01))
 		return -ETIMEDOUT;
 
 	if (onoff) {
 		/* clear reset */
-		ret = af9013_wr_reg_bits(state, 0xd417, 1, 1, 0);
+		ret = regmap_update_bits(state->regmap, 0xd417, 0x02, 0x00);
 		if (ret)
 			goto err;
-
 		/* disable reset */
-		ret = af9013_wr_reg_bits(state, 0xd417, 4, 1, 0);
-
+		ret = regmap_update_bits(state->regmap, 0xd417, 0x10, 0x00);
+		if (ret)
+			goto err;
 		/* power on */
-		ret = af9013_wr_reg_bits(state, 0xd73a, 3, 1, 0);
+		ret = regmap_update_bits(state->regmap, 0xd73a, 0x08, 0x00);
+		if (ret)
+			goto err;
 	} else {
 		/* power off */
-		ret = af9013_wr_reg_bits(state, 0xd73a, 3, 1, 1);
+		ret = regmap_update_bits(state->regmap, 0xd73a, 0x08, 0x08);
+		if (ret)
+			goto err;
 	}
 
 	return ret;
@@ -340,7 +162,7 @@ static int af9013_statistics_ber_unc_start(struct dvb_frontend *fe)
 	dev_dbg(&client->dev, "\n");
 
 	/* reset and start BER counter */
-	ret = af9013_wr_reg_bits(state, 0xd391, 4, 1, 1);
+	ret = regmap_update_bits(state->regmap, 0xd391, 0x10, 0x10);
 	if (ret)
 		goto err;
 
@@ -355,21 +177,22 @@ static int af9013_statistics_ber_unc_result(struct dvb_frontend *fe)
 	struct af9013_state *state = fe->demodulator_priv;
 	struct i2c_client *client = state->client;
 	int ret;
+	unsigned int utmp;
 	u8 buf[5];
 
 	dev_dbg(&client->dev, "\n");
 
 	/* check if error bit count is ready */
-	ret = af9013_rd_reg_bits(state, 0xd391, 4, 1, &buf[0]);
+	ret = regmap_read(state->regmap, 0xd391, &utmp);
 	if (ret)
 		goto err;
 
-	if (!buf[0]) {
+	if (!((utmp >> 4) & 0x01)) {
 		dev_dbg(&client->dev, "not ready\n");
 		return 0;
 	}
 
-	ret = af9013_rd_regs(state, 0xd387, buf, 5);
+	ret = regmap_bulk_read(state->regmap, 0xd387, buf, 5);
 	if (ret)
 		goto err;
 
@@ -391,7 +214,7 @@ static int af9013_statistics_snr_start(struct dvb_frontend *fe)
 	dev_dbg(&client->dev, "\n");
 
 	/* start SNR meas */
-	ret = af9013_wr_reg_bits(state, 0xd2e1, 3, 1, 1);
+	ret = regmap_update_bits(state->regmap, 0xd2e1, 0x08, 0x08);
 	if (ret)
 		goto err;
 
@@ -406,35 +229,36 @@ static int af9013_statistics_snr_result(struct dvb_frontend *fe)
 	struct af9013_state *state = fe->demodulator_priv;
 	struct i2c_client *client = state->client;
 	int ret, i, len;
-	u8 buf[3], tmp;
+	unsigned int utmp;
+	u8 buf[3];
 	u32 snr_val;
 	const struct af9013_snr *uninitialized_var(snr_lut);
 
 	dev_dbg(&client->dev, "\n");
 
 	/* check if SNR ready */
-	ret = af9013_rd_reg_bits(state, 0xd2e1, 3, 1, &tmp);
+	ret = regmap_read(state->regmap, 0xd2e1, &utmp);
 	if (ret)
 		goto err;
 
-	if (!tmp) {
+	if (!((utmp >> 3) & 0x01)) {
 		dev_dbg(&client->dev, "not ready\n");
 		return 0;
 	}
 
 	/* read value */
-	ret = af9013_rd_regs(state, 0xd2e3, buf, 3);
+	ret = regmap_bulk_read(state->regmap, 0xd2e3, buf, 3);
 	if (ret)
 		goto err;
 
 	snr_val = (buf[2] << 16) | (buf[1] << 8) | buf[0];
 
 	/* read current modulation */
-	ret = af9013_rd_reg(state, 0xd3c1, &tmp);
+	ret = regmap_read(state->regmap, 0xd3c1, &utmp);
 	if (ret)
 		goto err;
 
-	switch ((tmp >> 6) & 3) {
+	switch ((utmp >> 6) & 3) {
 	case 0:
 		len = ARRAY_SIZE(qpsk_snr_lut);
 		snr_lut = qpsk_snr_lut;
@@ -452,12 +276,12 @@ static int af9013_statistics_snr_result(struct dvb_frontend *fe)
 	}
 
 	for (i = 0; i < len; i++) {
-		tmp = snr_lut[i].snr;
+		utmp = snr_lut[i].snr;
 
 		if (snr_val < snr_lut[i].val)
 			break;
 	}
-	state->snr = tmp * 10; /* dB/10 */
+	state->snr = utmp * 10; /* dB/10 */
 
 	return ret;
 err:
@@ -478,7 +302,7 @@ static int af9013_statistics_signal_strength(struct dvb_frontend *fe)
 	if (!state->signal_strength_en)
 		return 0;
 
-	ret = af9013_rd_regs(state, 0xd07c, buf, 2);
+	ret = regmap_bulk_read(state->regmap, 0xd07c, buf, 2);
 	if (ret)
 		goto err;
 
@@ -590,8 +414,8 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
 		if (i == ARRAY_SIZE(coeff_lut))
 			return -EINVAL;
 
-		ret = af9013_wr_regs(state, 0xae00, coeff_lut[i].val,
-			sizeof(coeff_lut[i].val));
+		ret = regmap_bulk_write(state->regmap, 0xae00, coeff_lut[i].val,
+					sizeof(coeff_lut[i].val));
 	}
 
 	/* program frequency control */
@@ -632,32 +456,32 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
 		buf[4] = (freq_cw >>  8) & 0xff;
 		buf[5] = (freq_cw >> 16) & 0x7f;
 
-		ret = af9013_wr_regs(state, 0xd140, buf, 3);
+		ret = regmap_bulk_write(state->regmap, 0xd140, buf, 3);
 		if (ret)
 			goto err;
 
-		ret = af9013_wr_regs(state, 0x9be7, buf, 6);
+		ret = regmap_bulk_write(state->regmap, 0x9be7, buf, 6);
 		if (ret)
 			goto err;
 	}
 
 	/* clear TPS lock flag */
-	ret = af9013_wr_reg_bits(state, 0xd330, 3, 1, 1);
+	ret = regmap_update_bits(state->regmap, 0xd330, 0x08, 0x08);
 	if (ret)
 		goto err;
 
 	/* clear MPEG2 lock flag */
-	ret = af9013_wr_reg_bits(state, 0xd507, 6, 1, 0);
+	ret = regmap_update_bits(state->regmap, 0xd507, 0x40, 0x00);
 	if (ret)
 		goto err;
 
 	/* empty channel function */
-	ret = af9013_wr_reg_bits(state, 0x9bfe, 0, 1, 0);
+	ret = regmap_update_bits(state->regmap, 0x9bfe, 0x01, 0x00);
 	if (ret)
 		goto err;
 
 	/* empty DVB-T channel function */
-	ret = af9013_wr_reg_bits(state, 0x9bc2, 0, 1, 0);
+	ret = regmap_update_bits(state->regmap, 0x9bc2, 0x01, 0x00);
 	if (ret)
 		goto err;
 
@@ -802,32 +626,32 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
 		goto err;
 	}
 
-	ret = af9013_wr_regs(state, 0xd3c0, buf, 3);
+	ret = regmap_bulk_write(state->regmap, 0xd3c0, buf, 3);
 	if (ret)
 		goto err;
 
 	if (auto_mode) {
 		/* clear easy mode flag */
-		ret = af9013_wr_reg(state, 0xaefd, 0);
+		ret = regmap_write(state->regmap, 0xaefd, 0x00);
 		if (ret)
 			goto err;
 
 		dev_dbg(&client->dev, "auto params\n");
 	} else {
 		/* set easy mode flag */
-		ret = af9013_wr_reg(state, 0xaefd, 1);
+		ret = regmap_write(state->regmap, 0xaefd, 0x01);
 		if (ret)
 			goto err;
 
-		ret = af9013_wr_reg(state, 0xaefe, 0);
+		ret = regmap_write(state->regmap, 0xaefe, 0x00);
 		if (ret)
 			goto err;
 
 		dev_dbg(&client->dev, "manual params\n");
 	}
 
-	/* tune */
-	ret = af9013_wr_reg(state, 0xffff, 0);
+	/* Reset FSM */
+	ret = regmap_write(state->regmap, 0xffff, 0x00);
 	if (ret)
 		goto err;
 
@@ -851,7 +675,7 @@ static int af9013_get_frontend(struct dvb_frontend *fe,
 
 	dev_dbg(&client->dev, "\n");
 
-	ret = af9013_rd_regs(state, 0xd3c0, buf, 3);
+	ret = regmap_bulk_read(state->regmap, 0xd3c0, buf, 3);
 	if (ret)
 		goto err;
 
@@ -964,7 +788,7 @@ static int af9013_read_status(struct dvb_frontend *fe, enum fe_status *status)
 	struct af9013_state *state = fe->demodulator_priv;
 	struct i2c_client *client = state->client;
 	int ret;
-	u8 tmp;
+	unsigned int utmp;
 
 	/*
 	 * Return status from the cache if it is younger than 2000ms with the
@@ -982,21 +806,21 @@ static int af9013_read_status(struct dvb_frontend *fe, enum fe_status *status)
 	}
 
 	/* MPEG2 lock */
-	ret = af9013_rd_reg_bits(state, 0xd507, 6, 1, &tmp);
+	ret = regmap_read(state->regmap, 0xd507, &utmp);
 	if (ret)
 		goto err;
 
-	if (tmp)
+	if ((utmp >> 6) & 0x01)
 		*status |= FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_VITERBI |
 			FE_HAS_SYNC | FE_HAS_LOCK;
 
 	if (!*status) {
 		/* TPS lock */
-		ret = af9013_rd_reg_bits(state, 0xd330, 3, 1, &tmp);
+		ret = regmap_read(state->regmap, 0xd330, &utmp);
 		if (ret)
 			goto err;
 
-		if (tmp)
+		if ((utmp >> 3) & 0x01)
 			*status |= FE_HAS_SIGNAL | FE_HAS_CARRIER |
 				FE_HAS_VITERBI;
 	}
@@ -1043,8 +867,8 @@ static int af9013_init(struct dvb_frontend *fe)
 	struct af9013_state *state = fe->demodulator_priv;
 	struct i2c_client *client = state->client;
 	int ret, i, len;
-	u8 buf[3], tmp;
-	u32 adc_cw;
+	unsigned int utmp;
+	u8 buf[3];
 	const struct af9013_reg_bit *init;
 
 	dev_dbg(&client->dev, "\n");
@@ -1055,85 +879,85 @@ static int af9013_init(struct dvb_frontend *fe)
 		goto err;
 
 	/* enable ADC */
-	ret = af9013_wr_reg(state, 0xd73a, 0xa4);
+	ret = regmap_write(state->regmap, 0xd73a, 0xa4);
 	if (ret)
 		goto err;
 
 	/* write API version to firmware */
-	ret = af9013_wr_regs(state, 0x9bf2, state->api_version, 4);
+	ret = regmap_bulk_write(state->regmap, 0x9bf2, state->api_version, 4);
 	if (ret)
 		goto err;
 
 	/* program ADC control */
 	switch (state->clk) {
 	case 28800000: /* 28.800 MHz */
-		tmp = 0;
+		utmp = 0;
 		break;
 	case 20480000: /* 20.480 MHz */
-		tmp = 1;
+		utmp = 1;
 		break;
 	case 28000000: /* 28.000 MHz */
-		tmp = 2;
+		utmp = 2;
 		break;
 	case 25000000: /* 25.000 MHz */
-		tmp = 3;
+		utmp = 3;
 		break;
 	default:
 		ret = -EINVAL;
 		goto err;
 	}
 
-	adc_cw = div_u64((u64)state->clk * 0x80000, 1000000);
-	buf[0] = (adc_cw >>  0) & 0xff;
-	buf[1] = (adc_cw >>  8) & 0xff;
-	buf[2] = (adc_cw >> 16) & 0xff;
-	ret = af9013_wr_regs(state, 0xd180, buf, 3);
+	ret = regmap_update_bits(state->regmap, 0x9bd2, 0x0f, utmp);
 	if (ret)
 		goto err;
 
-	ret = af9013_wr_reg_bits(state, 0x9bd2, 0, 4, tmp);
+	utmp = div_u64((u64)state->clk * 0x80000, 1000000);
+	buf[0] = (utmp >>  0) & 0xff;
+	buf[1] = (utmp >>  8) & 0xff;
+	buf[2] = (utmp >> 16) & 0xff;
+	ret = regmap_bulk_write(state->regmap, 0xd180, buf, 3);
 	if (ret)
 		goto err;
 
 	/* set I2C master clock */
-	ret = af9013_wr_reg(state, 0xd416, 0x14);
+	ret = regmap_write(state->regmap, 0xd416, 0x14);
 	if (ret)
 		goto err;
 
 	/* set 16 embx */
-	ret = af9013_wr_reg_bits(state, 0xd700, 1, 1, 1);
+	ret = regmap_update_bits(state->regmap, 0xd700, 0x02, 0x02);
 	if (ret)
 		goto err;
 
 	/* set no trigger */
-	ret = af9013_wr_reg_bits(state, 0xd700, 2, 1, 0);
+	ret = regmap_update_bits(state->regmap, 0xd700, 0x04, 0x00);
 	if (ret)
 		goto err;
 
 	/* set read-update bit for constellation */
-	ret = af9013_wr_reg_bits(state, 0xd371, 1, 1, 1);
+	ret = regmap_update_bits(state->regmap, 0xd371, 0x02, 0x02);
 	if (ret)
 		goto err;
 
 	/* settings for mp2if */
 	if (state->ts_mode == AF9013_TS_USB) {
 		/* AF9015 split PSB to 1.5k + 0.5k */
-		ret = af9013_wr_reg_bits(state, 0xd50b, 2, 1, 1);
+		ret = regmap_update_bits(state->regmap, 0xd50b, 0x04, 0x04);
 		if (ret)
 			goto err;
 	} else {
 		/* AF9013 change the output bit to data7 */
-		ret = af9013_wr_reg_bits(state, 0xd500, 3, 1, 1);
+		ret = regmap_update_bits(state->regmap, 0xd500, 0x08, 0x08);
 		if (ret)
 			goto err;
 
 		/* AF9013 set mpeg to full speed */
-		ret = af9013_wr_reg_bits(state, 0xd502, 4, 1, 1);
+		ret = regmap_update_bits(state->regmap, 0xd502, 0x10, 0x10);
 		if (ret)
 			goto err;
 	}
 
-	ret = af9013_wr_reg_bits(state, 0xd520, 4, 1, 1);
+	ret = regmap_update_bits(state->regmap, 0xd520, 0x10, 0x10);
 	if (ret)
 		goto err;
 
@@ -1142,8 +966,11 @@ static int af9013_init(struct dvb_frontend *fe)
 	len = ARRAY_SIZE(ofsm_init);
 	init = ofsm_init;
 	for (i = 0; i < len; i++) {
-		ret = af9013_wr_reg_bits(state, init[i].addr, init[i].pos,
-			init[i].len, init[i].val);
+		u16 reg = init[i].addr;
+		u8 mask = GENMASK(init[i].pos + init[i].len - 1, init[i].pos);
+		u8 val = init[i].val << init[i].pos;
+
+		ret = regmap_update_bits(state->regmap, reg, mask, val);
 		if (ret)
 			goto err;
 	}
@@ -1195,63 +1022,65 @@ static int af9013_init(struct dvb_frontend *fe)
 	}
 
 	for (i = 0; i < len; i++) {
-		ret = af9013_wr_reg_bits(state, init[i].addr, init[i].pos,
-			init[i].len, init[i].val);
+		u16 reg = init[i].addr;
+		u8 mask = GENMASK(init[i].pos + init[i].len - 1, init[i].pos);
+		u8 val = init[i].val << init[i].pos;
+
+		ret = regmap_update_bits(state->regmap, reg, mask, val);
 		if (ret)
 			goto err;
 	}
 
 	/* TS mode */
-	ret = af9013_wr_reg_bits(state, 0xd500, 1, 2, state->ts_mode);
+	ret = regmap_update_bits(state->regmap, 0xd500, 0x06,
+				 state->ts_mode << 1);
 	if (ret)
 		goto err;
 
 	/* enable lock led */
-	ret = af9013_wr_reg_bits(state, 0xd730, 0, 1, 1);
+	ret = regmap_update_bits(state->regmap, 0xd730, 0x01, 0x01);
 	if (ret)
 		goto err;
 
 	/* check if we support signal strength */
 	if (!state->signal_strength_en) {
-		ret = af9013_rd_reg_bits(state, 0x9bee, 0, 1,
-			&state->signal_strength_en);
+		ret = regmap_read(state->regmap, 0x9bee, &utmp);
 		if (ret)
 			goto err;
+
+		state->signal_strength_en = (utmp >> 0) & 0x01;
 	}
 
 	/* read values needed for signal strength calculation */
 	if (state->signal_strength_en && !state->rf_50) {
-		ret = af9013_rd_reg(state, 0x9bbd, &state->rf_50);
+		ret = regmap_bulk_read(state->regmap, 0x9bbd, &state->rf_50, 1);
 		if (ret)
 			goto err;
-
-		ret = af9013_rd_reg(state, 0x9bd0, &state->rf_80);
+		ret = regmap_bulk_read(state->regmap, 0x9bd0, &state->rf_80, 1);
 		if (ret)
 			goto err;
-
-		ret = af9013_rd_reg(state, 0x9be2, &state->if_50);
+		ret = regmap_bulk_read(state->regmap, 0x9be2, &state->if_50, 1);
 		if (ret)
 			goto err;
-
-		ret = af9013_rd_reg(state, 0x9be4, &state->if_80);
+		ret = regmap_bulk_read(state->regmap, 0x9be4, &state->if_80, 1);
 		if (ret)
 			goto err;
 	}
 
 	/* SNR */
-	ret = af9013_wr_reg(state, 0xd2e2, 1);
+	ret = regmap_write(state->regmap, 0xd2e2, 0x01);
 	if (ret)
 		goto err;
 
 	/* BER / UCB */
 	buf[0] = (10000 >> 0) & 0xff;
 	buf[1] = (10000 >> 8) & 0xff;
-	ret = af9013_wr_regs(state, 0xd385, buf, 2);
+	ret = regmap_bulk_write(state->regmap, 0xd385, buf, 2);
 	if (ret)
 		goto err;
 
 	/* enable FEC monitor */
-	ret = af9013_wr_reg_bits(state, 0xd392, 1, 1, 1);
+	ret = regmap_update_bits(state->regmap, 0xd392, 0x02, 0x02);
 	if (ret)
 		goto err;
 
@@ -1276,7 +1105,7 @@ static int af9013_sleep(struct dvb_frontend *fe)
 	cancel_delayed_work_sync(&state->statistics_work);
 
 	/* disable lock led */
-	ret = af9013_wr_reg_bits(state, 0xd730, 0, 1, 0);
+	ret = regmap_update_bits(state->regmap, 0xd730, 0x01, 0x00);
 	if (ret)
 		goto err;
 
@@ -1304,9 +1133,11 @@ static int af9013_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 		return 0;
 
 	if (state->ts_mode == AF9013_TS_USB)
-		ret = af9013_wr_reg_bits(state, 0xd417, 3, 1, enable);
+		ret = regmap_update_bits(state->regmap, 0xd417, 0x08,
+					 enable << 3);
 	else
-		ret = af9013_wr_reg_bits(state, 0xd607, 2, 1, enable);
+		ret = regmap_update_bits(state->regmap, 0xd607, 0x04,
+					 enable << 2);
 	if (ret)
 		goto err;
 
@@ -1334,21 +1165,21 @@ static int af9013_download_firmware(struct af9013_state *state)
 {
 	struct i2c_client *client = state->client;
 	int i, len, remaining, ret;
+	unsigned int utmp;
 	const struct firmware *fw;
 	u16 checksum = 0;
-	u8 val;
 	u8 fw_params[4];
 	u8 *fw_file = AF9013_FIRMWARE;
 
 	msleep(100);
 	/* check whether firmware is already running */
-	ret = af9013_rd_reg(state, 0x98be, &val);
+	ret = regmap_read(state->regmap, 0x98be, &utmp);
 	if (ret)
 		goto err;
 	else
-		dev_dbg(&client->dev, "firmware status %02x\n", val);
+		dev_dbg(&client->dev, "firmware status %02x\n", utmp);
 
-	if (val == 0x0c) /* fw is running, no need for download */
+	if (utmp == 0x0c) /* fw is running, no need for download */
 		goto exit;
 
 	dev_info(&client->dev, "found a '%s' in cold state, will try to load a firmware\n",
@@ -1375,8 +1206,9 @@ static int af9013_download_firmware(struct af9013_state *state)
 	fw_params[3] = fw->size & 0xff;
 
 	/* write fw checksum & size */
-	ret = af9013_write_ofsm_regs(state, 0x50fc,
-		fw_params, sizeof(fw_params));
+	ret = regmap_bulk_write(state->regmap, 0x50fc, fw_params,
+				sizeof(fw_params));
+
 	if (ret)
 		goto err_release;
 
@@ -1387,9 +1219,9 @@ static int af9013_download_firmware(struct af9013_state *state)
 		if (len > LEN_MAX)
 			len = LEN_MAX;
 
-		ret = af9013_write_ofsm_regs(state,
-			FW_ADDR + fw->size - remaining,
-			(u8 *) &fw->data[fw->size - remaining], len);
+		ret = regmap_bulk_write(state->regmap,
+					FW_ADDR + fw->size - remaining,
+					&fw->data[fw->size - remaining], len);
 		if (ret) {
 			dev_err(&client->dev, "firmware download failed %d\n",
 				ret);
@@ -1398,28 +1230,23 @@ static int af9013_download_firmware(struct af9013_state *state)
 	}
 
 	/* request boot firmware */
-	ret = af9013_wr_reg(state, 0xe205, 1);
+	ret = regmap_write(state->regmap, 0xe205, 0x01);
 	if (ret)
 		goto err_release;
 
-	for (i = 0; i < 15; i++) {
-		msleep(100);
-
-		/* check firmware status */
-		ret = af9013_rd_reg(state, 0x98be, &val);
-		if (ret)
-			goto err_release;
-
-		dev_dbg(&client->dev, "firmware status %02x\n", val);
+	/* Check firmware status. 0c=OK, 04=fail */
+	ret = regmap_read_poll_timeout(state->regmap, 0x98be, utmp,
+				       (utmp == 0x0c || utmp == 0x04),
+				       5000, 1000000);
+	if (ret)
+		goto err_release;
 
-		if (val == 0x0c || val == 0x04) /* success or fail */
-			break;
-	}
+	dev_dbg(&client->dev, "firmware status %02x\n", utmp);
 
-	if (val == 0x04) {
+	if (utmp == 0x04) {
 		dev_err(&client->dev, "firmware did not run\n");
 		ret = -ENODEV;
-	} else if (val != 0x0c) {
+	} else if (utmp != 0x0c) {
 		dev_err(&client->dev, "firmware boot timeout\n");
 		ret = -ENODEV;
 	}
@@ -1519,6 +1346,147 @@ static struct dvb_frontend *af9013_get_dvb_frontend(struct i2c_client *client)
 	return &state->fe;
 }
 
+/* Own I2C access routines needed for regmap as chip uses extra command byte */
+static int af9013_wregs(struct i2c_client *client, u8 cmd, u16 reg,
+			const u8 *val, int len)
+{
+	int ret;
+	u8 buf[21];
+	struct i2c_msg msg[1] = {
+		{
+			.addr = client->addr,
+			.flags = 0,
+			.len = 3 + len,
+			.buf = buf,
+		}
+	};
+
+	if (3 + len > sizeof(buf)) {
+		ret = -EINVAL;
+		goto err;
+	}
+
+	buf[0] = (reg >> 8) & 0xff;
+	buf[1] = (reg >> 0) & 0xff;
+	buf[2] = cmd;
+	memcpy(&buf[3], val, len);
+	ret = i2c_transfer(client->adapter, msg, 1);
+	if (ret < 0) {
+		goto err;
+	} else if (ret != 1) {
+		ret = -EREMOTEIO;
+		goto err;
+	}
+
+	return 0;
+err:
+	dev_dbg(&client->dev, "failed %d\n", ret);
+	return ret;
+}
+
+static int af9013_rregs(struct i2c_client *client, u8 cmd, u16 reg,
+			u8 *val, int len)
+{
+	int ret;
+	u8 buf[3];
+	struct i2c_msg msg[2] = {
+		{
+			.addr = client->addr,
+			.flags = 0,
+			.len = 3,
+			.buf = buf,
+		}, {
+			.addr = client->addr,
+			.flags = I2C_M_RD,
+			.len = len,
+			.buf = val,
+		}
+	};
+
+	buf[0] = (reg >> 8) & 0xff;
+	buf[1] = (reg >> 0) & 0xff;
+	buf[2] = cmd;
+	ret = i2c_transfer(client->adapter, msg, 2);
+	if (ret < 0) {
+		goto err;
+	} else if (ret != 2) {
+		ret = -EREMOTEIO;
+		goto err;
+	}
+
+	return 0;
+err:
+	dev_dbg(&client->dev, "failed %d\n", ret);
+	return ret;
+}
+
+static int af9013_regmap_write(void *context, const void *data, size_t count)
+{
+	struct i2c_client *client = context;
+	struct af9013_state *state = i2c_get_clientdata(client);
+	int ret, i;
+	u8 cmd;
+	u16 reg = ((u8 *)data)[0] << 8|((u8 *)data)[1] << 0;
+	u8 *val = &((u8 *)data)[2];
+	const unsigned int len = count - 2;
+
+	if (state->ts_mode == AF9013_TS_USB && (reg & 0xff00) != 0xae00) {
+		cmd = 0 << 7|0 << 6|(len - 1) << 2|1 << 1|1 << 0;
+		ret = af9013_wregs(client, cmd, reg, val, len);
+		if (ret)
+			goto err;
+	} else if (reg >= 0x5100 && reg < 0x8fff) {
+		/* Firmware download */
+		cmd = 1 << 7|1 << 6|(len - 1) << 2|1 << 1|1 << 0;
+		ret = af9013_wregs(client, cmd, reg, val, len);
+		if (ret)
+			goto err;
+	} else {
+		cmd = 0 << 7|0 << 6|(1 - 1) << 2|1 << 1|1 << 0;
+		for (i = 0; i < len; i++) {
+			ret = af9013_wregs(client, cmd, reg + i, val + i, 1);
+			if (ret)
+				goto err;
+		}
+	}
+
+	return 0;
+err:
+	dev_dbg(&client->dev, "failed %d\n", ret);
+	return ret;
+}
+
+static int af9013_regmap_read(void *context, const void *reg_buf,
+			      size_t reg_size, void *val_buf, size_t val_size)
+{
+	struct i2c_client *client = context;
+	struct af9013_state *state = i2c_get_clientdata(client);
+	int ret, i;
+	u8 cmd;
+	u16 reg = ((u8 *)reg_buf)[0] << 8|((u8 *)reg_buf)[1] << 0;
+	u8 *val = &((u8 *)val_buf)[0];
+	const unsigned int len = val_size;
+
+	if (state->ts_mode == AF9013_TS_USB && (reg & 0xff00) != 0xae00) {
+		cmd = 0 << 7|0 << 6|(len - 1) << 2|1 << 1|0 << 0;
+		ret = af9013_rregs(client, cmd, reg, val_buf, len);
+		if (ret)
+			goto err;
+	} else {
+		cmd = 0 << 7|0 << 6|(1 - 1) << 2|1 << 1|0 << 0;
+		for (i = 0; i < len; i++) {
+			ret = af9013_rregs(client, cmd, reg + i, val + i, 1);
+			if (ret)
+				goto err;
+		}
+	}
+
+	return 0;
+err:
+	dev_dbg(&client->dev, "failed %d\n", ret);
+	return ret;
+}
+
 static int af9013_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
@@ -1526,6 +1494,14 @@ static int af9013_probe(struct i2c_client *client,
 	struct af9013_platform_data *pdata = client->dev.platform_data;
 	int ret, i;
 	u8 firmware_version[4];
+	static const struct regmap_bus regmap_bus = {
+		.read = af9013_regmap_read,
+		.write = af9013_regmap_write,
+	};
+	static const struct regmap_config regmap_config = {
+		.reg_bits    =  16,
+		.val_bits    =  8,
+	};
 
 	state = kzalloc(sizeof(*state), GFP_KERNEL);
 	if (!state) {
@@ -1544,25 +1520,31 @@ static int af9013_probe(struct i2c_client *client,
 	memcpy(&state->api_version, pdata->api_version, sizeof(state->api_version));
 	memcpy(&state->gpio, pdata->gpio, sizeof(state->gpio));
 	INIT_DELAYED_WORK(&state->statistics_work, af9013_statistics_work);
+	state->regmap = regmap_init(&client->dev, &regmap_bus, client,
+				  &regmap_config);
+	if (IS_ERR(state->regmap)) {
+		ret = PTR_ERR(state->regmap);
+		goto err_kfree;
+	}
 
 	/* Download firmware */
 	if (state->ts_mode != AF9013_TS_USB) {
 		ret = af9013_download_firmware(state);
 		if (ret)
-			goto err_kfree;
+			goto err_regmap_exit;
 	}
 
 	/* Firmware version */
-	ret = af9013_rd_regs(state, 0x5103, firmware_version,
-			     sizeof(firmware_version));
+	ret = regmap_bulk_read(state->regmap, 0x5103, firmware_version,
+			       sizeof(firmware_version));
 	if (ret)
-		goto err_kfree;
+		goto err_regmap_exit;
 
 	/* Set GPIOs */
 	for (i = 0; i < sizeof(state->gpio); i++) {
 		ret = af9013_set_gpio(state, i, state->gpio[i]);
 		if (ret)
-			goto err_kfree;
+			goto err_regmap_exit;
 	}
 
 	/* Create dvb frontend */
@@ -1579,6 +1561,8 @@ static int af9013_probe(struct i2c_client *client,
 		 firmware_version[0], firmware_version[1],
 		 firmware_version[2], firmware_version[3]);
 	return 0;
+err_regmap_exit:
+	regmap_exit(state->regmap);
 err_kfree:
 	kfree(state);
 err:
@@ -1595,6 +1579,8 @@ static int af9013_remove(struct i2c_client *client)
 	/* Stop statistics polling */
 	cancel_delayed_work_sync(&state->statistics_work);
 
+	regmap_exit(state->regmap);
+
 	kfree(state);
 
 	return 0;
diff --git a/drivers/media/dvb-frontends/af9013_priv.h b/drivers/media/dvb-frontends/af9013_priv.h
index 97b5b0c..35ca5c9 100644
--- a/drivers/media/dvb-frontends/af9013_priv.h
+++ b/drivers/media/dvb-frontends/af9013_priv.h
@@ -25,6 +25,7 @@
 #include "af9013.h"
 #include <linux/firmware.h>
 #include <linux/math64.h>
+#include <linux/regmap.h>
 
 #define AF9013_FIRMWARE "dvb-fe-af9013.fw"
 
-- 
http://palosaari.fi/
