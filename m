Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44607 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752718AbcKLKey (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 Nov 2016 05:34:54 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/9] af9033: convert to regmap api
Date: Sat, 12 Nov 2016 12:33:54 +0200
Message-Id: <1478946841-2807-2-git-send-email-crope@iki.fi>
In-Reply-To: <1478946841-2807-1-git-send-email-crope@iki.fi>
References: <1478946841-2807-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use regmap to cover I2C register operations.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/Kconfig       |   1 +
 drivers/media/dvb-frontends/af9033.c      | 420 ++++++++++--------------------
 drivers/media/dvb-frontends/af9033_priv.h |   1 +
 3 files changed, 145 insertions(+), 277 deletions(-)

diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
index 0122255..51244e6 100644
--- a/drivers/media/dvb-frontends/Kconfig
+++ b/drivers/media/dvb-frontends/Kconfig
@@ -847,6 +847,7 @@ config DVB_M88RS2000
 config DVB_AF9033
 	tristate "Afatech AF9033 DVB-T demodulator"
 	depends on DVB_CORE && I2C
+	select REGMAP_I2C
 	default m if !MEDIA_SUBDRV_AUTOSELECT
 
 config DVB_HORUS3A
diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index 9a8157a..5b806e8 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -21,11 +21,9 @@
 
 #include "af9033_priv.h"
 
-/* Max transfer size done by I2C transfer functions */
-#define MAX_XFER_SIZE  64
-
 struct af9033_dev {
 	struct i2c_client *client;
+	struct regmap *regmap;
 	struct dvb_frontend fe;
 	struct af9033_config cfg;
 	bool is_af9035;
@@ -43,134 +41,6 @@ struct af9033_dev {
 	u64 total_block_count;
 };
 
-/* write multiple registers */
-static int af9033_wr_regs(struct af9033_dev *dev, u32 reg, const u8 *val,
-		int len)
-{
-	int ret;
-	u8 buf[MAX_XFER_SIZE];
-	struct i2c_msg msg[1] = {
-		{
-			.addr = dev->client->addr,
-			.flags = 0,
-			.len = 3 + len,
-			.buf = buf,
-		}
-	};
-
-	if (3 + len > sizeof(buf)) {
-		dev_warn(&dev->client->dev,
-				"i2c wr reg=%04x: len=%d is too big!\n",
-				reg, len);
-		return -EINVAL;
-	}
-
-	buf[0] = (reg >> 16) & 0xff;
-	buf[1] = (reg >>  8) & 0xff;
-	buf[2] = (reg >>  0) & 0xff;
-	memcpy(&buf[3], val, len);
-
-	ret = i2c_transfer(dev->client->adapter, msg, 1);
-	if (ret == 1) {
-		ret = 0;
-	} else {
-		dev_warn(&dev->client->dev, "i2c wr failed=%d reg=%06x len=%d\n",
-				ret, reg, len);
-		ret = -EREMOTEIO;
-	}
-
-	return ret;
-}
-
-/* read multiple registers */
-static int af9033_rd_regs(struct af9033_dev *dev, u32 reg, u8 *val, int len)
-{
-	int ret;
-	u8 buf[3] = { (reg >> 16) & 0xff, (reg >> 8) & 0xff,
-			(reg >> 0) & 0xff };
-	struct i2c_msg msg[2] = {
-		{
-			.addr = dev->client->addr,
-			.flags = 0,
-			.len = sizeof(buf),
-			.buf = buf
-		}, {
-			.addr = dev->client->addr,
-			.flags = I2C_M_RD,
-			.len = len,
-			.buf = val
-		}
-	};
-
-	ret = i2c_transfer(dev->client->adapter, msg, 2);
-	if (ret == 2) {
-		ret = 0;
-	} else {
-		dev_warn(&dev->client->dev, "i2c rd failed=%d reg=%06x len=%d\n",
-				ret, reg, len);
-		ret = -EREMOTEIO;
-	}
-
-	return ret;
-}
-
-
-/* write single register */
-static int af9033_wr_reg(struct af9033_dev *dev, u32 reg, u8 val)
-{
-	return af9033_wr_regs(dev, reg, &val, 1);
-}
-
-/* read single register */
-static int af9033_rd_reg(struct af9033_dev *dev, u32 reg, u8 *val)
-{
-	return af9033_rd_regs(dev, reg, val, 1);
-}
-
-/* write single register with mask */
-static int af9033_wr_reg_mask(struct af9033_dev *dev, u32 reg, u8 val,
-		u8 mask)
-{
-	int ret;
-	u8 tmp;
-
-	/* no need for read if whole reg is written */
-	if (mask != 0xff) {
-		ret = af9033_rd_regs(dev, reg, &tmp, 1);
-		if (ret)
-			return ret;
-
-		val &= mask;
-		tmp &= ~mask;
-		val |= tmp;
-	}
-
-	return af9033_wr_regs(dev, reg, &val, 1);
-}
-
-/* read single register with mask */
-static int af9033_rd_reg_mask(struct af9033_dev *dev, u32 reg, u8 *val,
-		u8 mask)
-{
-	int ret, i;
-	u8 tmp;
-
-	ret = af9033_rd_regs(dev, reg, &tmp, 1);
-	if (ret)
-		return ret;
-
-	tmp &= mask;
-
-	/* find position of the first bit */
-	for (i = 0; i < 8; i++) {
-		if ((mask >> i) & 0x01)
-			break;
-	}
-	*val = tmp >> i;
-
-	return 0;
-}
-
 /* write reg val table using reg addr auto increment */
 static int af9033_wr_reg_val_tab(struct af9033_dev *dev,
 		const struct reg_val *tab, int tab_len)
@@ -190,8 +60,9 @@ static int af9033_wr_reg_val_tab(struct af9033_dev *dev,
 		buf[j] = tab[i].val;
 
 		if (i == tab_len - 1 || tab[i].reg != tab[i + 1].reg - 1) {
-			ret = af9033_wr_regs(dev, tab[i].reg - j, buf, j + 1);
-			if (ret < 0)
+			ret = regmap_bulk_write(dev->regmap, tab[i].reg - j,
+						buf, j + 1);
+			if (ret)
 				goto err;
 
 			j = 0;
@@ -281,8 +152,8 @@ static int af9033_init(struct dvb_frontend *fe)
 	dev_dbg(&dev->client->dev, "clock=%d clock_cw=%08x\n",
 			dev->cfg.clock, clock_cw);
 
-	ret = af9033_wr_regs(dev, 0x800025, buf, 4);
-	if (ret < 0)
+	ret = regmap_bulk_write(dev->regmap, 0x800025, buf, 4);
+	if (ret)
 		goto err;
 
 	/* program ADC control */
@@ -305,41 +176,39 @@ static int af9033_init(struct dvb_frontend *fe)
 	dev_dbg(&dev->client->dev, "adc=%d adc_cw=%06x\n",
 			clock_adc_lut[i].adc, adc_cw);
 
-	ret = af9033_wr_regs(dev, 0x80f1cd, buf, 3);
-	if (ret < 0)
+	ret = regmap_bulk_write(dev->regmap, 0x80f1cd, buf, 3);
+	if (ret)
 		goto err;
 
 	/* program register table */
 	for (i = 0; i < ARRAY_SIZE(tab); i++) {
-		ret = af9033_wr_reg_mask(dev, tab[i].reg, tab[i].val,
-				tab[i].mask);
-		if (ret < 0)
+		ret = regmap_update_bits(dev->regmap, tab[i].reg, tab[i].mask,
+					 tab[i].val);
+		if (ret)
 			goto err;
 	}
 
 	/* clock output */
 	if (dev->cfg.dyn0_clk) {
-		ret = af9033_wr_reg(dev, 0x80fba8, 0x00);
-		if (ret < 0)
+		ret = regmap_write(dev->regmap, 0x80fba8, 0x00);
+		if (ret)
 			goto err;
 	}
 
 	/* settings for TS interface */
 	if (dev->cfg.ts_mode == AF9033_TS_MODE_USB) {
-		ret = af9033_wr_reg_mask(dev, 0x80f9a5, 0x00, 0x01);
-		if (ret < 0)
+		ret = regmap_update_bits(dev->regmap, 0x80f9a5, 0x01, 0x00);
+		if (ret)
 			goto err;
-
-		ret = af9033_wr_reg_mask(dev, 0x80f9b5, 0x01, 0x01);
-		if (ret < 0)
+		ret = regmap_update_bits(dev->regmap, 0x80f9b5, 0x01, 0x01);
+		if (ret)
 			goto err;
 	} else {
-		ret = af9033_wr_reg_mask(dev, 0x80f990, 0x00, 0x01);
-		if (ret < 0)
+		ret = regmap_update_bits(dev->regmap, 0x80f990, 0x01, 0x00);
+		if (ret)
 			goto err;
-
-		ret = af9033_wr_reg_mask(dev, 0x80f9b5, 0x00, 0x01);
-		if (ret < 0)
+		ret = regmap_update_bits(dev->regmap, 0x80f9b5, 0x01, 0x00);
+		if (ret)
 			goto err;
 	}
 
@@ -365,7 +234,7 @@ static int af9033_init(struct dvb_frontend *fe)
 	}
 
 	ret = af9033_wr_reg_val_tab(dev, init, len);
-	if (ret < 0)
+	if (ret)
 		goto err;
 
 	/* load tuner specific settings */
@@ -427,20 +296,18 @@ static int af9033_init(struct dvb_frontend *fe)
 	}
 
 	ret = af9033_wr_reg_val_tab(dev, init, len);
-	if (ret < 0)
+	if (ret)
 		goto err;
 
 	if (dev->cfg.ts_mode == AF9033_TS_MODE_SERIAL) {
-		ret = af9033_wr_reg_mask(dev, 0x00d91c, 0x01, 0x01);
-		if (ret < 0)
+		ret = regmap_update_bits(dev->regmap, 0x00d91c, 0x01, 0x01);
+		if (ret)
 			goto err;
-
-		ret = af9033_wr_reg_mask(dev, 0x00d917, 0x00, 0x01);
-		if (ret < 0)
+		ret = regmap_update_bits(dev->regmap, 0x00d917, 0x01, 0x00);
+		if (ret)
 			goto err;
-
-		ret = af9033_wr_reg_mask(dev, 0x00d916, 0x00, 0x01);
-		if (ret < 0)
+		ret = regmap_update_bits(dev->regmap, 0x00d916, 0x01, 0x00);
+		if (ret)
 			goto err;
 	}
 
@@ -448,8 +315,8 @@ static int af9033_init(struct dvb_frontend *fe)
 	case AF9033_TUNER_IT9135_60:
 	case AF9033_TUNER_IT9135_61:
 	case AF9033_TUNER_IT9135_62:
-		ret = af9033_wr_reg(dev, 0x800000, 0x01);
-		if (ret < 0)
+		ret = regmap_write(dev->regmap, 0x800000, 0x01);
+		if (ret)
 			goto err;
 	}
 
@@ -479,45 +346,31 @@ static int af9033_init(struct dvb_frontend *fe)
 static int af9033_sleep(struct dvb_frontend *fe)
 {
 	struct af9033_dev *dev = fe->demodulator_priv;
-	int ret, i;
-	u8 tmp;
+	int ret;
+	unsigned int utmp;
 
-	ret = af9033_wr_reg(dev, 0x80004c, 1);
-	if (ret < 0)
+	ret = regmap_write(dev->regmap, 0x80004c, 0x01);
+	if (ret)
 		goto err;
-
-	ret = af9033_wr_reg(dev, 0x800000, 0);
-	if (ret < 0)
+	ret = regmap_write(dev->regmap, 0x800000, 0x00);
+	if (ret)
 		goto err;
-
-	for (i = 100, tmp = 1; i && tmp; i--) {
-		ret = af9033_rd_reg(dev, 0x80004c, &tmp);
-		if (ret < 0)
-			goto err;
-
-		usleep_range(200, 10000);
-	}
-
-	dev_dbg(&dev->client->dev, "loop=%d\n", i);
-
-	if (i == 0) {
-		ret = -ETIMEDOUT;
+	ret = regmap_read_poll_timeout(dev->regmap, 0x80004c, utmp, utmp == 0,
+				       5000, 1000000);
+	if (ret)
 		goto err;
-	}
-
-	ret = af9033_wr_reg_mask(dev, 0x80fb24, 0x08, 0x08);
-	if (ret < 0)
+	ret = regmap_update_bits(dev->regmap, 0x80fb24, 0x08, 0x08);
+	if (ret)
 		goto err;
 
 	/* prevent current leak (?) */
 	if (dev->cfg.ts_mode == AF9033_TS_MODE_SERIAL) {
 		/* enable parallel TS */
-		ret = af9033_wr_reg_mask(dev, 0x00d917, 0x00, 0x01);
-		if (ret < 0)
+		ret = regmap_update_bits(dev->regmap, 0x00d917, 0x01, 0x00);
+		if (ret)
 			goto err;
-
-		ret = af9033_wr_reg_mask(dev, 0x00d916, 0x01, 0x01);
-		if (ret < 0)
+		ret = regmap_update_bits(dev->regmap, 0x00d916, 0x01, 0x01);
+		if (ret)
 			goto err;
 	}
 
@@ -588,8 +441,10 @@ static int af9033_set_frontend(struct dvb_frontend *fe)
 			goto err;
 		}
 
-		ret = af9033_wr_regs(dev, 0x800001,
-				coeff_lut[i].val, sizeof(coeff_lut[i].val));
+		ret = regmap_bulk_write(dev->regmap, 0x800001, coeff_lut[i].val,
+					sizeof(coeff_lut[i].val));
+		if (ret)
+			goto err;
 	}
 
 	/* program frequency control */
@@ -641,27 +496,25 @@ static int af9033_set_frontend(struct dvb_frontend *fe)
 		if (if_frequency == 0)
 			buf[2] = 0;
 
-		ret = af9033_wr_regs(dev, 0x800029, buf, 3);
-		if (ret < 0)
+		ret = regmap_bulk_write(dev->regmap, 0x800029, buf, 3);
+		if (ret)
 			goto err;
 
 		dev->bandwidth_hz = c->bandwidth_hz;
 	}
 
-	ret = af9033_wr_reg_mask(dev, 0x80f904, bandwidth_reg_val, 0x03);
-	if (ret < 0)
+	ret = regmap_update_bits(dev->regmap, 0x80f904, 0x03,
+				 bandwidth_reg_val);
+	if (ret)
 		goto err;
-
-	ret = af9033_wr_reg(dev, 0x800040, 0x00);
-	if (ret < 0)
+	ret = regmap_write(dev->regmap, 0x800040, 0x00);
+	if (ret)
 		goto err;
-
-	ret = af9033_wr_reg(dev, 0x800047, 0x00);
-	if (ret < 0)
+	ret = regmap_write(dev->regmap, 0x800047, 0x00);
+	if (ret)
 		goto err;
-
-	ret = af9033_wr_reg_mask(dev, 0x80f999, 0x00, 0x01);
-	if (ret < 0)
+	ret = regmap_update_bits(dev->regmap, 0x80f999, 0x01, 0x00);
+	if (ret)
 		goto err;
 
 	if (c->frequency <= 230000000)
@@ -669,12 +522,11 @@ static int af9033_set_frontend(struct dvb_frontend *fe)
 	else
 		tmp = 0x01; /* UHF */
 
-	ret = af9033_wr_reg(dev, 0x80004b, tmp);
-	if (ret < 0)
+	ret = regmap_write(dev->regmap, 0x80004b, tmp);
+	if (ret)
 		goto err;
-
-	ret = af9033_wr_reg(dev, 0x800000, 0x00);
-	if (ret < 0)
+	ret = regmap_write(dev->regmap, 0x800000, 0x00);
+	if (ret)
 		goto err;
 
 	return 0;
@@ -695,8 +547,8 @@ static int af9033_get_frontend(struct dvb_frontend *fe,
 	dev_dbg(&dev->client->dev, "\n");
 
 	/* read all needed registers */
-	ret = af9033_rd_regs(dev, 0x80f900, buf, sizeof(buf));
-	if (ret < 0)
+	ret = regmap_bulk_read(dev->regmap, 0x80f900, buf, 8);
+	if (ret)
 		goto err;
 
 	switch ((buf[0] >> 0) & 3) {
@@ -817,37 +669,38 @@ static int af9033_read_status(struct dvb_frontend *fe, enum fe_status *status)
 	struct af9033_dev *dev = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, i, tmp = 0;
-	u8 u8tmp, buf[7];
+	u8 buf[7];
+	unsigned int utmp;
 
 	dev_dbg(&dev->client->dev, "\n");
 
 	*status = 0;
 
 	/* radio channel status, 0=no result, 1=has signal, 2=no signal */
-	ret = af9033_rd_reg(dev, 0x800047, &u8tmp);
-	if (ret < 0)
+	ret = regmap_read(dev->regmap, 0x800047, &utmp);
+	if (ret)
 		goto err;
 
 	/* has signal */
-	if (u8tmp == 0x01)
+	if (utmp == 0x01)
 		*status |= FE_HAS_SIGNAL;
 
-	if (u8tmp != 0x02) {
+	if (utmp != 0x02) {
 		/* TPS lock */
-		ret = af9033_rd_reg_mask(dev, 0x80f5a9, &u8tmp, 0x01);
-		if (ret < 0)
+		ret = regmap_read(dev->regmap, 0x80f5a9, &utmp);
+		if (ret)
 			goto err;
 
-		if (u8tmp)
+		if ((utmp >> 0) & 0x01)
 			*status |= FE_HAS_SIGNAL | FE_HAS_CARRIER |
 					FE_HAS_VITERBI;
 
 		/* full lock */
-		ret = af9033_rd_reg_mask(dev, 0x80f999, &u8tmp, 0x01);
-		if (ret < 0)
+		ret = regmap_read(dev->regmap, 0x80f999, &utmp);
+		if (ret)
 			goto err;
 
-		if (u8tmp)
+		if ((utmp >> 0) & 0x01)
 			*status |= FE_HAS_SIGNAL | FE_HAS_CARRIER |
 					FE_HAS_VITERBI | FE_HAS_SYNC |
 					FE_HAS_LOCK;
@@ -858,15 +711,15 @@ static int af9033_read_status(struct dvb_frontend *fe, enum fe_status *status)
 	/* signal strength */
 	if (dev->fe_status & FE_HAS_SIGNAL) {
 		if (dev->is_af9035) {
-			ret = af9033_rd_reg(dev, 0x80004a, &u8tmp);
+			ret = regmap_read(dev->regmap, 0x80004a, &utmp);
 			if (ret)
 				goto err;
-			tmp = -u8tmp * 1000;
+			tmp = -utmp * 1000;
 		} else {
-			ret = af9033_rd_reg(dev, 0x8000f7, &u8tmp);
+			ret = regmap_read(dev->regmap, 0x8000f7, &utmp);
 			if (ret)
 				goto err;
-			tmp = (u8tmp - 100) * 1000;
+			tmp = (utmp - 100) * 1000;
 		}
 
 		c->strength.len = 1;
@@ -883,26 +736,26 @@ static int af9033_read_status(struct dvb_frontend *fe, enum fe_status *status)
 		const struct val_snr *snr_lut = NULL;
 
 		/* read value */
-		ret = af9033_rd_regs(dev, 0x80002c, buf, 3);
+		ret = regmap_bulk_read(dev->regmap, 0x80002c, buf, 3);
 		if (ret)
 			goto err;
 
 		snr_val = (buf[2] << 16) | (buf[1] << 8) | (buf[0] << 0);
 
 		/* read superframe number */
-		ret = af9033_rd_reg(dev, 0x80f78b, &u8tmp);
+		ret = regmap_read(dev->regmap, 0x80f78b, &utmp);
 		if (ret)
 			goto err;
 
-		if (u8tmp)
-			snr_val /= u8tmp;
+		if (utmp)
+			snr_val /= utmp;
 
 		/* read current transmission mode */
-		ret = af9033_rd_reg(dev, 0x80f900, &u8tmp);
+		ret = regmap_read(dev->regmap, 0x80f900, &utmp);
 		if (ret)
 			goto err;
 
-		switch ((u8tmp >> 0) & 3) {
+		switch ((utmp >> 0) & 3) {
 		case 0:
 			snr_val *= 4;
 			break;
@@ -918,11 +771,11 @@ static int af9033_read_status(struct dvb_frontend *fe, enum fe_status *status)
 		}
 
 		/* read current modulation */
-		ret = af9033_rd_reg(dev, 0x80f903, &u8tmp);
+		ret = regmap_read(dev->regmap, 0x80f903, &utmp);
 		if (ret)
 			goto err;
 
-		switch ((u8tmp >> 0) & 3) {
+		switch ((utmp >> 0) & 3) {
 		case 0:
 			snr_lut_size = ARRAY_SIZE(qpsk_snr_lut);
 			snr_lut = qpsk_snr_lut;
@@ -967,7 +820,7 @@ static int af9033_read_status(struct dvb_frontend *fe, enum fe_status *status)
 		 * (rsd_packet_count). Maybe it should be increased?
 		 */
 
-		ret = af9033_rd_regs(dev, 0x800032, buf, 7);
+		ret = regmap_bulk_read(dev->regmap, 0x800032, buf, 7);
 		if (ret)
 			goto err;
 
@@ -1010,7 +863,7 @@ static int af9033_read_snr(struct dvb_frontend *fe, u16 *snr)
 	struct af9033_dev *dev = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &dev->fe.dtv_property_cache;
 	int ret;
-	u8 u8tmp;
+	unsigned int utmp;
 
 	/* use DVBv5 CNR */
 	if (c->cnr.stat[0].scale == FE_SCALE_DECIBEL) {
@@ -1023,12 +876,12 @@ static int af9033_read_snr(struct dvb_frontend *fe, u16 *snr)
 			*snr = div_s64(c->cnr.stat[0].svalue, 1000);
 
 			/* read current modulation */
-			ret = af9033_rd_reg(dev, 0x80f903, &u8tmp);
+			ret = regmap_read(dev->regmap, 0x80f903, &utmp);
 			if (ret)
 				goto err;
 
 			/* scale value to 0x0000-0xffff */
-			switch ((u8tmp >> 0) & 3) {
+			switch ((utmp >> 0) & 3) {
 			case 0:
 				*snr = *snr * 0xffff / 23;
 				break;
@@ -1059,23 +912,24 @@ static int af9033_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
 	struct af9033_dev *dev = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &dev->fe.dtv_property_cache;
 	int ret, tmp, power_real;
-	u8 u8tmp, gain_offset, buf[7];
+	unsigned int utmp;
+	u8 gain_offset, buf[7];
 
 	if (dev->is_af9035) {
 		/* read signal strength of 0-100 scale */
-		ret = af9033_rd_reg(dev, 0x800048, &u8tmp);
-		if (ret < 0)
+		ret = regmap_read(dev->regmap, 0x800048, &utmp);
+		if (ret)
 			goto err;
 
 		/* scale value to 0x0000-0xffff */
-		*strength = u8tmp * 0xffff / 100;
+		*strength = utmp * 0xffff / 100;
 	} else {
-		ret = af9033_rd_reg(dev, 0x8000f7, &u8tmp);
-		if (ret < 0)
+		ret = regmap_read(dev->regmap, 0x8000f7, &utmp);
+		if (ret)
 			goto err;
 
-		ret = af9033_rd_regs(dev, 0x80f900, buf, 7);
-		if (ret < 0)
+		ret = regmap_bulk_read(dev->regmap, 0x80f900, buf, 7);
+		if (ret)
 			goto err;
 
 		if (c->frequency <= 300000000)
@@ -1083,7 +937,7 @@ static int af9033_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
 		else
 			gain_offset = 4; /* UHF */
 
-		power_real = (u8tmp - 100 - gain_offset) -
+		power_real = (utmp - 100 - gain_offset) -
 			power_reference[((buf[3] >> 0) & 3)][((buf[6] >> 0) & 7)];
 
 		if (power_real < -15)
@@ -1134,8 +988,8 @@ static int af9033_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 
 	dev_dbg(&dev->client->dev, "enable=%d\n", enable);
 
-	ret = af9033_wr_reg_mask(dev, 0x00fa04, enable, 0x01);
-	if (ret < 0)
+	ret = regmap_update_bits(dev->regmap, 0x00fa04, 0x01, enable);
+	if (ret)
 		goto err;
 
 	return 0;
@@ -1153,8 +1007,8 @@ static int af9033_pid_filter_ctrl(struct dvb_frontend *fe, int onoff)
 
 	dev_dbg(&dev->client->dev, "onoff=%d\n", onoff);
 
-	ret = af9033_wr_reg_mask(dev, 0x80f993, onoff, 0x01);
-	if (ret < 0)
+	ret = regmap_update_bits(dev->regmap, 0x80f993, 0x01, onoff);
+	if (ret)
 		goto err;
 
 	return 0;
@@ -1178,16 +1032,14 @@ static int af9033_pid_filter(struct dvb_frontend *fe, int index, u16 pid,
 	if (pid > 0x1fff)
 		return 0;
 
-	ret = af9033_wr_regs(dev, 0x80f996, wbuf, 2);
-	if (ret < 0)
+	ret = regmap_bulk_write(dev->regmap, 0x80f996, wbuf, 2);
+	if (ret)
 		goto err;
-
-	ret = af9033_wr_reg(dev, 0x80f994, onoff);
-	if (ret < 0)
+	ret = regmap_write(dev->regmap, 0x80f994, onoff);
+	if (ret)
 		goto err;
-
-	ret = af9033_wr_reg(dev, 0x80f995, index);
-	if (ret < 0)
+	ret = regmap_write(dev->regmap, 0x80f995, index);
+	if (ret)
 		goto err;
 
 	return 0;
@@ -1247,6 +1099,11 @@ static int af9033_probe(struct i2c_client *client,
 	int ret;
 	u8 buf[8];
 	u32 reg;
+	static const struct regmap_config regmap_config = {
+		.reg_bits    =  24,
+		.val_bits    =  8,
+	};
+
 
 	/* allocate memory for the internal state */
 	dev = kzalloc(sizeof(struct af9033_dev), GFP_KERNEL);
@@ -1268,6 +1125,13 @@ static int af9033_probe(struct i2c_client *client,
 		goto err_kfree;
 	}
 
+	/* Create regmap */
+	dev->regmap = regmap_init_i2c(client, &regmap_config);
+	if (IS_ERR(dev->regmap)) {
+		ret = PTR_ERR(dev->regmap);
+		goto err_kfree;
+	}
+
 	/* firmware version */
 	switch (dev->cfg.tuner) {
 	case AF9033_TUNER_IT9135_38:
@@ -1285,13 +1149,12 @@ static int af9033_probe(struct i2c_client *client,
 		break;
 	}
 
-	ret = af9033_rd_regs(dev, reg, &buf[0], 4);
-	if (ret < 0)
-		goto err_kfree;
-
-	ret = af9033_rd_regs(dev, 0x804191, &buf[4], 4);
-	if (ret < 0)
-		goto err_kfree;
+	ret = regmap_bulk_read(dev->regmap, reg, &buf[0], 4);
+	if (ret)
+		goto err_regmap_exit;
+	ret = regmap_bulk_read(dev->regmap, 0x804191, &buf[4], 4);
+	if (ret)
+		goto err_regmap_exit;
 
 	dev_info(&dev->client->dev,
 			"firmware version: LINK %d.%d.%d.%d - OFDM %d.%d.%d.%d\n",
@@ -1309,13 +1172,12 @@ static int af9033_probe(struct i2c_client *client,
 		/* IT9135 did not like to sleep at that early */
 		break;
 	default:
-		ret = af9033_wr_reg(dev, 0x80004c, 1);
-		if (ret < 0)
-			goto err_kfree;
-
-		ret = af9033_wr_reg(dev, 0x800000, 0);
-		if (ret < 0)
-			goto err_kfree;
+		ret = regmap_write(dev->regmap, 0x80004c, 0x01);
+		if (ret)
+			goto err_regmap_exit;
+		ret = regmap_write(dev->regmap, 0x800000, 0x00);
+		if (ret)
+			goto err_regmap_exit;
 	}
 
 	/* configure internal TS mode */
@@ -1344,6 +1206,8 @@ static int af9033_probe(struct i2c_client *client,
 
 	dev_info(&dev->client->dev, "Afatech AF9033 successfully attached\n");
 	return 0;
+err_regmap_exit:
+	regmap_exit(dev->regmap);
 err_kfree:
 	kfree(dev);
 err:
@@ -1357,6 +1221,8 @@ static int af9033_remove(struct i2c_client *client)
 
 	dev_dbg(&dev->client->dev, "\n");
 
+	regmap_exit(dev->regmap);
+
 	dev->fe.ops.release = NULL;
 	dev->fe.demodulator_priv = NULL;
 	kfree(dev);
diff --git a/drivers/media/dvb-frontends/af9033_priv.h b/drivers/media/dvb-frontends/af9033_priv.h
index 8e23275..701c508 100644
--- a/drivers/media/dvb-frontends/af9033_priv.h
+++ b/drivers/media/dvb-frontends/af9033_priv.h
@@ -25,6 +25,7 @@
 #include "dvb_frontend.h"
 #include "af9033.h"
 #include <linux/math64.h>
+#include <linux/regmap.h>
 
 struct reg_val {
 	u32 reg;
-- 
http://palosaari.fi/

