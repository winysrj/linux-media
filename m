Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48529 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752562AbbFFL7J (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Jun 2015 07:59:09 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 7/8] m88ds3103: use regmap for I2C register access
Date: Sat,  6 Jun 2015 14:58:47 +0300
Message-Id: <1433591928-30915-7-git-send-email-crope@iki.fi>
In-Reply-To: <1433591928-30915-1-git-send-email-crope@iki.fi>
References: <1433591928-30915-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use regmap for I2C register access.
Remove own I2C repeated mutex as it should not be needed. I2C adapter
lock is already taken when I2C mux adapter is called, no need for
double locking.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/Kconfig          |   1 +
 drivers/media/dvb-frontends/m88ds3103.c      | 429 +++++++++------------------
 drivers/media/dvb-frontends/m88ds3103_priv.h |   5 +-
 3 files changed, 145 insertions(+), 290 deletions(-)

diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
index b7627ca..0d35f58 100644
--- a/drivers/media/dvb-frontends/Kconfig
+++ b/drivers/media/dvb-frontends/Kconfig
@@ -38,6 +38,7 @@ config DVB_STV6110x
 config DVB_M88DS3103
 	tristate "Montage Technology M88DS3103"
 	depends on DVB_CORE && I2C && I2C_MUX
+	select REGMAP_I2C
 	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y when you want to support this frontend.
diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
index c4d5a7a..6c33eca 100644
--- a/drivers/media/dvb-frontends/m88ds3103.c
+++ b/drivers/media/dvb-frontends/m88ds3103.c
@@ -18,141 +18,6 @@
 
 static struct dvb_frontend_ops m88ds3103_ops;
 
-/* write multiple registers */
-static int m88ds3103_wr_regs(struct m88ds3103_dev *dev,
-		u8 reg, const u8 *val, int len)
-{
-#define MAX_WR_LEN 32
-#define MAX_WR_XFER_LEN (MAX_WR_LEN + 1)
-	struct i2c_client *client = dev->client;
-	int ret;
-	u8 buf[MAX_WR_XFER_LEN];
-	struct i2c_msg msg[1] = {
-		{
-			.addr = client->addr,
-			.flags = 0,
-			.len = 1 + len,
-			.buf = buf,
-		}
-	};
-
-	if (WARN_ON(len > MAX_WR_LEN))
-		return -EINVAL;
-
-	buf[0] = reg;
-	memcpy(&buf[1], val, len);
-
-	mutex_lock(&dev->i2c_mutex);
-	ret = i2c_transfer(client->adapter, msg, 1);
-	mutex_unlock(&dev->i2c_mutex);
-	if (ret == 1) {
-		ret = 0;
-	} else {
-		dev_warn(&client->dev, "i2c wr failed=%d reg=%02x len=%d\n",
-			 ret, reg, len);
-		ret = -EREMOTEIO;
-	}
-
-	return ret;
-}
-
-/* read multiple registers */
-static int m88ds3103_rd_regs(struct m88ds3103_dev *dev,
-		u8 reg, u8 *val, int len)
-{
-#define MAX_RD_LEN 3
-#define MAX_RD_XFER_LEN (MAX_RD_LEN)
-	struct i2c_client *client = dev->client;
-	int ret;
-	u8 buf[MAX_RD_XFER_LEN];
-	struct i2c_msg msg[2] = {
-		{
-			.addr = client->addr,
-			.flags = 0,
-			.len = 1,
-			.buf = &reg,
-		}, {
-			.addr = client->addr,
-			.flags = I2C_M_RD,
-			.len = len,
-			.buf = buf,
-		}
-	};
-
-	if (WARN_ON(len > MAX_RD_LEN))
-		return -EINVAL;
-
-	mutex_lock(&dev->i2c_mutex);
-	ret = i2c_transfer(client->adapter, msg, 2);
-	mutex_unlock(&dev->i2c_mutex);
-	if (ret == 2) {
-		memcpy(val, buf, len);
-		ret = 0;
-	} else {
-		dev_warn(&client->dev, "i2c rd failed=%d reg=%02x len=%d\n",
-			 ret, reg, len);
-		ret = -EREMOTEIO;
-	}
-
-	return ret;
-}
-
-/* write single register */
-static int m88ds3103_wr_reg(struct m88ds3103_dev *dev, u8 reg, u8 val)
-{
-	return m88ds3103_wr_regs(dev, reg, &val, 1);
-}
-
-/* read single register */
-static int m88ds3103_rd_reg(struct m88ds3103_dev *dev, u8 reg, u8 *val)
-{
-	return m88ds3103_rd_regs(dev, reg, val, 1);
-}
-
-/* write single register with mask */
-static int m88ds3103_wr_reg_mask(struct m88ds3103_dev *dev,
-		u8 reg, u8 val, u8 mask)
-{
-	int ret;
-	u8 u8tmp;
-
-	/* no need for read if whole reg is written */
-	if (mask != 0xff) {
-		ret = m88ds3103_rd_regs(dev, reg, &u8tmp, 1);
-		if (ret)
-			return ret;
-
-		val &= mask;
-		u8tmp &= ~mask;
-		val |= u8tmp;
-	}
-
-	return m88ds3103_wr_regs(dev, reg, &val, 1);
-}
-
-/* read single register with mask */
-static int m88ds3103_rd_reg_mask(struct m88ds3103_dev *dev,
-		u8 reg, u8 *val, u8 mask)
-{
-	int ret, i;
-	u8 u8tmp;
-
-	ret = m88ds3103_rd_regs(dev, reg, &u8tmp, 1);
-	if (ret)
-		return ret;
-
-	u8tmp &= mask;
-
-	/* find position of the first bit */
-	for (i = 0; i < 8; i++) {
-		if ((mask >> i) & 0x01)
-			break;
-	}
-	*val = u8tmp >> i;
-
-	return 0;
-}
-
 /* write reg val table using reg addr auto increment */
 static int m88ds3103_wr_reg_val_tab(struct m88ds3103_dev *dev,
 		const struct m88ds3103_reg_val *tab, int tab_len)
@@ -173,7 +38,7 @@ static int m88ds3103_wr_reg_val_tab(struct m88ds3103_dev *dev,
 
 		if (i == tab_len - 1 || tab[i].reg != tab[i + 1].reg - 1 ||
 				!((j + 1) % (dev->cfg->i2c_wr_max - 1))) {
-			ret = m88ds3103_wr_regs(dev, tab[i].reg - j, buf, j + 1);
+			ret = regmap_bulk_write(dev->regmap, tab[i].reg - j, buf, j + 1);
 			if (ret)
 				goto err;
 
@@ -193,7 +58,7 @@ static int m88ds3103_read_status(struct dvb_frontend *fe, fe_status_t *status)
 	struct i2c_client *client = dev->client;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, i, itmp;
-	u8 u8tmp;
+	unsigned int utmp;
 	u8 buf[3];
 
 	*status = 0;
@@ -205,21 +70,21 @@ static int m88ds3103_read_status(struct dvb_frontend *fe, fe_status_t *status)
 
 	switch (c->delivery_system) {
 	case SYS_DVBS:
-		ret = m88ds3103_rd_reg_mask(dev, 0xd1, &u8tmp, 0x07);
+		ret = regmap_read(dev->regmap, 0xd1, &utmp);
 		if (ret)
 			goto err;
 
-		if (u8tmp == 0x07)
+		if ((utmp & 0x07) == 0x07)
 			*status = FE_HAS_SIGNAL | FE_HAS_CARRIER |
 					FE_HAS_VITERBI | FE_HAS_SYNC |
 					FE_HAS_LOCK;
 		break;
 	case SYS_DVBS2:
-		ret = m88ds3103_rd_reg_mask(dev, 0x0d, &u8tmp, 0x8f);
+		ret = regmap_read(dev->regmap, 0x0d, &utmp);
 		if (ret)
 			goto err;
 
-		if (u8tmp == 0x8f)
+		if ((utmp & 0x8f) == 0x8f)
 			*status = FE_HAS_SIGNAL | FE_HAS_CARRIER |
 					FE_HAS_VITERBI | FE_HAS_SYNC |
 					FE_HAS_LOCK;
@@ -231,8 +96,7 @@ static int m88ds3103_read_status(struct dvb_frontend *fe, fe_status_t *status)
 	}
 
 	dev->fe_status = *status;
-
-	dev_dbg(&client->dev, "lock=%02x status=%02x\n", u8tmp, *status);
+	dev_dbg(&client->dev, "lock=%02x status=%02x\n", utmp, *status);
 
 	/* CNR */
 	if (dev->fe_status & FE_HAS_VITERBI) {
@@ -247,11 +111,11 @@ static int m88ds3103_read_status(struct dvb_frontend *fe, fe_status_t *status)
 			itmp = 0;
 
 			for (i = 0; i < M88DS3103_SNR_ITERATIONS; i++) {
-				ret = m88ds3103_rd_reg(dev, 0xff, &buf[0]);
+				ret = regmap_read(dev->regmap, 0xff, &utmp);
 				if (ret)
 					goto err;
 
-				itmp += buf[0];
+				itmp += utmp;
 			}
 
 			/* use of single register limits max value to 15 dB */
@@ -265,7 +129,7 @@ static int m88ds3103_read_status(struct dvb_frontend *fe, fe_status_t *status)
 			signal_tot = 0;
 
 			for (i = 0; i < M88DS3103_SNR_ITERATIONS; i++) {
-				ret = m88ds3103_rd_regs(dev, 0x8c, buf, 3);
+				ret = regmap_bulk_read(dev->regmap, 0x8c, buf, 3);
 				if (ret)
 					goto err;
 
@@ -310,17 +174,17 @@ static int m88ds3103_read_status(struct dvb_frontend *fe, fe_status_t *status)
 
 		switch (c->delivery_system) {
 		case SYS_DVBS:
-			ret = m88ds3103_wr_reg(dev, 0xf9, 0x04);
+			ret = regmap_write(dev->regmap, 0xf9, 0x04);
 			if (ret)
 				goto err;
 
-			ret = m88ds3103_rd_reg(dev, 0xf8, &u8tmp);
+			ret = regmap_read(dev->regmap, 0xf8, &utmp);
 			if (ret)
 				goto err;
 
 			/* measurement ready? */
-			if (!(u8tmp & 0x10)) {
-				ret = m88ds3103_rd_regs(dev, 0xf6, buf, 2);
+			if (!(utmp & 0x10)) {
+				ret = regmap_bulk_read(dev->regmap, 0xf6, buf, 2);
 				if (ret)
 					goto err;
 
@@ -331,14 +195,14 @@ static int m88ds3103_read_status(struct dvb_frontend *fe, fe_status_t *status)
 				dev->dvbv3_ber = post_bit_error;
 
 				/* restart measurement */
-				u8tmp |= 0x10;
-				ret = m88ds3103_wr_reg(dev, 0xf8, u8tmp);
+				utmp |= 0x10;
+				ret = regmap_write(dev->regmap, 0xf8, utmp);
 				if (ret)
 					goto err;
 			}
 			break;
 		case SYS_DVBS2:
-			ret = m88ds3103_rd_regs(dev, 0xd5, buf, 3);
+			ret = regmap_bulk_read(dev->regmap, 0xd5, buf, 3);
 			if (ret)
 				goto err;
 
@@ -346,7 +210,7 @@ static int m88ds3103_read_status(struct dvb_frontend *fe, fe_status_t *status)
 
 			/* enough data? */
 			if (utmp > 4000) {
-				ret = m88ds3103_rd_regs(dev, 0xf7, buf, 2);
+				ret = regmap_bulk_read(dev->regmap, 0xf7, buf, 2);
 				if (ret)
 					goto err;
 
@@ -357,19 +221,19 @@ static int m88ds3103_read_status(struct dvb_frontend *fe, fe_status_t *status)
 				dev->dvbv3_ber = post_bit_error;
 
 				/* restart measurement */
-				ret = m88ds3103_wr_reg(dev, 0xd1, 0x01);
+				ret = regmap_write(dev->regmap, 0xd1, 0x01);
 				if (ret)
 					goto err;
 
-				ret = m88ds3103_wr_reg(dev, 0xf9, 0x01);
+				ret = regmap_write(dev->regmap, 0xf9, 0x01);
 				if (ret)
 					goto err;
 
-				ret = m88ds3103_wr_reg(dev, 0xf9, 0x00);
+				ret = regmap_write(dev->regmap, 0xf9, 0x00);
 				if (ret)
 					goto err;
 
-				ret = m88ds3103_wr_reg(dev, 0xd1, 0x00);
+				ret = regmap_write(dev->regmap, 0xd1, 0x00);
 				if (ret)
 					goto err;
 			}
@@ -419,17 +283,17 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 	}
 
 	/* reset */
-	ret = m88ds3103_wr_reg(dev, 0x07, 0x80);
+	ret = regmap_write(dev->regmap, 0x07, 0x80);
 	if (ret)
 		goto err;
 
-	ret = m88ds3103_wr_reg(dev, 0x07, 0x00);
+	ret = regmap_write(dev->regmap, 0x07, 0x00);
 	if (ret)
 		goto err;
 
 	/* Disable demod clock path */
 	if (dev->chip_id == M88RS6000_CHIP_ID) {
-		ret = m88ds3103_wr_reg(dev, 0x06, 0xe0);
+		ret = regmap_write(dev->regmap, 0x06, 0xe0);
 		if (ret)
 			goto err;
 	}
@@ -467,7 +331,7 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 			target_mclk = 144000;
 
 		/* Enable demod clock path */
-		ret = m88ds3103_wr_reg(dev, 0x06, 0x00);
+		ret = regmap_write(dev->regmap, 0x06, 0x00);
 		if (ret)
 			goto err;
 		usleep_range(10000, 20000);
@@ -513,19 +377,19 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 			u8tmp2 = 0x00; /* 0b00 */
 			break;
 		}
-		ret = m88ds3103_wr_reg_mask(dev, 0x22, u8tmp1 << 6, 0xc0);
+		ret = regmap_update_bits(dev->regmap, 0x22, 0xc0, u8tmp1 << 6);
 		if (ret)
 			goto err;
-		ret = m88ds3103_wr_reg_mask(dev, 0x24, u8tmp2 << 6, 0xc0);
+		ret = regmap_update_bits(dev->regmap, 0x24, 0xc0, u8tmp2 << 6);
 		if (ret)
 			goto err;
 	}
 
-	ret = m88ds3103_wr_reg(dev, 0xb2, 0x01);
+	ret = regmap_write(dev->regmap, 0xb2, 0x01);
 	if (ret)
 		goto err;
 
-	ret = m88ds3103_wr_reg(dev, 0x00, 0x01);
+	ret = regmap_write(dev->regmap, 0x00, 0x01);
 	if (ret)
 		goto err;
 
@@ -564,23 +428,23 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 	if (dev->chip_id == M88RS6000_CHIP_ID) {
 		if ((c->delivery_system == SYS_DVBS2)
 			&& ((c->symbol_rate / 1000) <= 5000)) {
-			ret = m88ds3103_wr_reg(dev, 0xc0, 0x04);
+			ret = regmap_write(dev->regmap, 0xc0, 0x04);
 			if (ret)
 				goto err;
 			buf[0] = 0x09;
 			buf[1] = 0x22;
 			buf[2] = 0x88;
-			ret = m88ds3103_wr_regs(dev, 0x8a, buf, 3);
+			ret = regmap_bulk_write(dev->regmap, 0x8a, buf, 3);
 			if (ret)
 				goto err;
 		}
-		ret = m88ds3103_wr_reg_mask(dev, 0x9d, 0x08, 0x08);
+		ret = regmap_update_bits(dev->regmap, 0x9d, 0x08, 0x08);
 		if (ret)
 			goto err;
-		ret = m88ds3103_wr_reg(dev, 0xf1, 0x01);
+		ret = regmap_write(dev->regmap, 0xf1, 0x01);
 		if (ret)
 			goto err;
-		ret = m88ds3103_wr_reg_mask(dev, 0x30, 0x80, 0x80);
+		ret = regmap_update_bits(dev->regmap, 0x30, 0x80, 0x80);
 		if (ret)
 			goto err;
 	}
@@ -610,14 +474,14 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 		u8tmp |= 0x40;
 
 	/* TS mode */
-	ret = m88ds3103_wr_reg(dev, 0xfd, u8tmp);
+	ret = regmap_write(dev->regmap, 0xfd, u8tmp);
 	if (ret)
 		goto err;
 
 	switch (dev->cfg->ts_mode) {
 	case M88DS3103_TS_SERIAL:
 	case M88DS3103_TS_SERIAL_D7:
-		ret = m88ds3103_wr_reg_mask(dev, 0x29, u8tmp1, 0x20);
+		ret = regmap_update_bits(dev->regmap, 0x29, 0x20, u8tmp1);
 		if (ret)
 			goto err;
 		u8tmp1 = 0;
@@ -642,17 +506,17 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 	/* u8tmp2[5:0] => ea[5:0] */
 	u8tmp2 &= 0x3f;
 
-	ret = m88ds3103_rd_reg(dev, 0xfe, &u8tmp);
+	ret = regmap_bulk_read(dev->regmap, 0xfe, &u8tmp, 1);
 	if (ret)
 		goto err;
 
 	u8tmp = ((u8tmp  & 0xf0) << 0) | u8tmp1 >> 2;
-	ret = m88ds3103_wr_reg(dev, 0xfe, u8tmp);
+	ret = regmap_write(dev->regmap, 0xfe, u8tmp);
 	if (ret)
 		goto err;
 
 	u8tmp = ((u8tmp1 & 0x03) << 6) | u8tmp2 >> 0;
-	ret = m88ds3103_wr_reg(dev, 0xea, u8tmp);
+	ret = regmap_write(dev->regmap, 0xea, u8tmp);
 	if (ret)
 		goto err;
 
@@ -663,38 +527,38 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 	else
 		u8tmp = 0x06;
 
-	ret = m88ds3103_wr_reg(dev, 0xc3, 0x08);
+	ret = regmap_write(dev->regmap, 0xc3, 0x08);
 	if (ret)
 		goto err;
 
-	ret = m88ds3103_wr_reg(dev, 0xc8, u8tmp);
+	ret = regmap_write(dev->regmap, 0xc8, u8tmp);
 	if (ret)
 		goto err;
 
-	ret = m88ds3103_wr_reg(dev, 0xc4, 0x08);
+	ret = regmap_write(dev->regmap, 0xc4, 0x08);
 	if (ret)
 		goto err;
 
-	ret = m88ds3103_wr_reg(dev, 0xc7, 0x00);
+	ret = regmap_write(dev->regmap, 0xc7, 0x00);
 	if (ret)
 		goto err;
 
 	u16tmp = DIV_ROUND_CLOSEST((c->symbol_rate / 1000) << 15, dev->mclk_khz / 2);
 	buf[0] = (u16tmp >> 0) & 0xff;
 	buf[1] = (u16tmp >> 8) & 0xff;
-	ret = m88ds3103_wr_regs(dev, 0x61, buf, 2);
+	ret = regmap_bulk_write(dev->regmap, 0x61, buf, 2);
 	if (ret)
 		goto err;
 
-	ret = m88ds3103_wr_reg_mask(dev, 0x4d, dev->cfg->spec_inv << 1, 0x02);
+	ret = regmap_update_bits(dev->regmap, 0x4d, 0x02, dev->cfg->spec_inv << 1);
 	if (ret)
 		goto err;
 
-	ret = m88ds3103_wr_reg_mask(dev, 0x30, dev->cfg->agc_inv << 4, 0x10);
+	ret = regmap_update_bits(dev->regmap, 0x30, 0x10, dev->cfg->agc_inv << 4);
 	if (ret)
 		goto err;
 
-	ret = m88ds3103_wr_reg(dev, 0x33, dev->cfg->agc);
+	ret = regmap_write(dev->regmap, 0x33, dev->cfg->agc);
 	if (ret)
 		goto err;
 
@@ -708,15 +572,15 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 
 	buf[0] = (s32tmp >> 0) & 0xff;
 	buf[1] = (s32tmp >> 8) & 0xff;
-	ret = m88ds3103_wr_regs(dev, 0x5e, buf, 2);
+	ret = regmap_bulk_write(dev->regmap, 0x5e, buf, 2);
 	if (ret)
 		goto err;
 
-	ret = m88ds3103_wr_reg(dev, 0x00, 0x00);
+	ret = regmap_write(dev->regmap, 0x00, 0x00);
 	if (ret)
 		goto err;
 
-	ret = m88ds3103_wr_reg(dev, 0xb2, 0x00);
+	ret = regmap_write(dev->regmap, 0xb2, 0x00);
 	if (ret)
 		goto err;
 
@@ -734,9 +598,9 @@ static int m88ds3103_init(struct dvb_frontend *fe)
 	struct i2c_client *client = dev->client;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, len, remaining;
+	unsigned int utmp;
 	const struct firmware *fw = NULL;
 	u8 *fw_file;
-	u8 u8tmp;
 
 	dev_dbg(&client->dev, "\n");
 
@@ -744,34 +608,31 @@ static int m88ds3103_init(struct dvb_frontend *fe)
 	dev->warm = false;
 
 	/* wake up device from sleep */
-	ret = m88ds3103_wr_reg_mask(dev, 0x08, 0x01, 0x01);
+	ret = regmap_update_bits(dev->regmap, 0x08, 0x01, 0x01);
 	if (ret)
 		goto err;
-
-	ret = m88ds3103_wr_reg_mask(dev, 0x04, 0x00, 0x01);
+	ret = regmap_update_bits(dev->regmap, 0x04, 0x01, 0x00);
 	if (ret)
 		goto err;
-
-	ret = m88ds3103_wr_reg_mask(dev, 0x23, 0x00, 0x10);
+	ret = regmap_update_bits(dev->regmap, 0x23, 0x10, 0x00);
 	if (ret)
 		goto err;
 
 	/* firmware status */
-	ret = m88ds3103_rd_reg(dev, 0xb9, &u8tmp);
+	ret = regmap_read(dev->regmap, 0xb9, &utmp);
 	if (ret)
 		goto err;
 
-	dev_dbg(&client->dev, "firmware=%02x\n", u8tmp);
+	dev_dbg(&client->dev, "firmware=%02x\n", utmp);
 
-	if (u8tmp)
+	if (utmp)
 		goto skip_fw_download;
 
 	/* global reset, global diseqc reset, golbal fec reset */
-	ret = m88ds3103_wr_reg(dev, 0x07, 0xe0);
+	ret = regmap_write(dev->regmap, 0x07, 0xe0);
 	if (ret)
 		goto err;
-
-	ret = m88ds3103_wr_reg(dev, 0x07, 0x00);
+	ret = regmap_write(dev->regmap, 0x07, 0x00);
 	if (ret)
 		goto err;
 
@@ -793,7 +654,7 @@ static int m88ds3103_init(struct dvb_frontend *fe)
 	dev_info(&client->dev, "downloading firmware from file '%s'\n",
 		 fw_file);
 
-	ret = m88ds3103_wr_reg(dev, 0xb2, 0x01);
+	ret = regmap_write(dev->regmap, 0xb2, 0x01);
 	if (ret)
 		goto error_fw_release;
 
@@ -803,7 +664,7 @@ static int m88ds3103_init(struct dvb_frontend *fe)
 		if (len > (dev->cfg->i2c_wr_max - 1))
 			len = (dev->cfg->i2c_wr_max - 1);
 
-		ret = m88ds3103_wr_regs(dev, 0xb0,
+		ret = regmap_bulk_write(dev->regmap, 0xb0,
 				&fw->data[fw->size - remaining], len);
 		if (ret) {
 			dev_err(&client->dev, "firmware download failed=%d\n",
@@ -812,18 +673,18 @@ static int m88ds3103_init(struct dvb_frontend *fe)
 		}
 	}
 
-	ret = m88ds3103_wr_reg(dev, 0xb2, 0x00);
+	ret = regmap_write(dev->regmap, 0xb2, 0x00);
 	if (ret)
 		goto error_fw_release;
 
 	release_firmware(fw);
 	fw = NULL;
 
-	ret = m88ds3103_rd_reg(dev, 0xb9, &u8tmp);
+	ret = regmap_read(dev->regmap, 0xb9, &utmp);
 	if (ret)
 		goto err;
 
-	if (!u8tmp) {
+	if (!utmp) {
 		dev_info(&client->dev, "firmware did not run\n");
 		ret = -EFAULT;
 		goto err;
@@ -832,7 +693,7 @@ static int m88ds3103_init(struct dvb_frontend *fe)
 	dev_info(&client->dev, "found a '%s' in warm state\n",
 		 m88ds3103_ops.info.name);
 	dev_info(&client->dev, "firmware version: %X.%X\n",
-		 (u8tmp >> 4) & 0xf, (u8tmp >> 0 & 0xf));
+		 (utmp >> 4) & 0xf, (utmp >> 0 & 0xf));
 
 skip_fw_download:
 	/* warm state */
@@ -859,7 +720,7 @@ static int m88ds3103_sleep(struct dvb_frontend *fe)
 	struct m88ds3103_dev *dev = fe->demodulator_priv;
 	struct i2c_client *client = dev->client;
 	int ret;
-	u8 u8tmp;
+	unsigned int utmp;
 
 	dev_dbg(&client->dev, "\n");
 
@@ -868,23 +729,21 @@ static int m88ds3103_sleep(struct dvb_frontend *fe)
 
 	/* TS Hi-Z */
 	if (dev->chip_id == M88RS6000_CHIP_ID)
-		u8tmp = 0x29;
+		utmp = 0x29;
 	else
-		u8tmp = 0x27;
-	ret = m88ds3103_wr_reg_mask(dev, u8tmp, 0x00, 0x01);
+		utmp = 0x27;
+	ret = regmap_update_bits(dev->regmap, utmp, 0x01, 0x00);
 	if (ret)
 		goto err;
 
 	/* sleep */
-	ret = m88ds3103_wr_reg_mask(dev, 0x08, 0x00, 0x01);
+	ret = regmap_update_bits(dev->regmap, 0x08, 0x01, 0x00);
 	if (ret)
 		goto err;
-
-	ret = m88ds3103_wr_reg_mask(dev, 0x04, 0x01, 0x01);
+	ret = regmap_update_bits(dev->regmap, 0x04, 0x01, 0x01);
 	if (ret)
 		goto err;
-
-	ret = m88ds3103_wr_reg_mask(dev, 0x23, 0x10, 0x10);
+	ret = regmap_update_bits(dev->regmap, 0x23, 0x10, 0x10);
 	if (ret)
 		goto err;
 
@@ -911,11 +770,11 @@ static int m88ds3103_get_frontend(struct dvb_frontend *fe)
 
 	switch (c->delivery_system) {
 	case SYS_DVBS:
-		ret = m88ds3103_rd_reg(dev, 0xe0, &buf[0]);
+		ret = regmap_bulk_read(dev->regmap, 0xe0, &buf[0], 1);
 		if (ret)
 			goto err;
 
-		ret = m88ds3103_rd_reg(dev, 0xe6, &buf[1]);
+		ret = regmap_bulk_read(dev->regmap, 0xe6, &buf[1], 1);
 		if (ret)
 			goto err;
 
@@ -952,15 +811,15 @@ static int m88ds3103_get_frontend(struct dvb_frontend *fe)
 
 		break;
 	case SYS_DVBS2:
-		ret = m88ds3103_rd_reg(dev, 0x7e, &buf[0]);
+		ret = regmap_bulk_read(dev->regmap, 0x7e, &buf[0], 1);
 		if (ret)
 			goto err;
 
-		ret = m88ds3103_rd_reg(dev, 0x89, &buf[1]);
+		ret = regmap_bulk_read(dev->regmap, 0x89, &buf[1], 1);
 		if (ret)
 			goto err;
 
-		ret = m88ds3103_rd_reg(dev, 0xf2, &buf[2]);
+		ret = regmap_bulk_read(dev->regmap, 0xf2, &buf[2], 1);
 		if (ret)
 			goto err;
 
@@ -1051,7 +910,7 @@ static int m88ds3103_get_frontend(struct dvb_frontend *fe)
 		goto err;
 	}
 
-	ret = m88ds3103_rd_regs(dev, 0x6d, buf, 2);
+	ret = regmap_bulk_read(dev->regmap, 0x6d, buf, 2);
 	if (ret)
 		goto err;
 
@@ -1091,7 +950,7 @@ static int m88ds3103_set_tone(struct dvb_frontend *fe,
 	struct m88ds3103_dev *dev = fe->demodulator_priv;
 	struct i2c_client *client = dev->client;
 	int ret;
-	u8 u8tmp, tone, reg_a1_mask;
+	unsigned int utmp, tone, reg_a1_mask;
 
 	dev_dbg(&client->dev, "fe_sec_tone_mode=%d\n", fe_sec_tone_mode);
 
@@ -1115,13 +974,13 @@ static int m88ds3103_set_tone(struct dvb_frontend *fe,
 		goto err;
 	}
 
-	u8tmp = tone << 7 | dev->cfg->envelope_mode << 5;
-	ret = m88ds3103_wr_reg_mask(dev, 0xa2, u8tmp, 0xe0);
+	utmp = tone << 7 | dev->cfg->envelope_mode << 5;
+	ret = regmap_update_bits(dev->regmap, 0xa2, 0xe0, utmp);
 	if (ret)
 		goto err;
 
-	u8tmp = 1 << 2;
-	ret = m88ds3103_wr_reg_mask(dev, 0xa1, u8tmp, reg_a1_mask);
+	utmp = 1 << 2;
+	ret = regmap_update_bits(dev->regmap, 0xa1, reg_a1_mask, utmp);
 	if (ret)
 		goto err;
 
@@ -1137,7 +996,7 @@ static int m88ds3103_set_voltage(struct dvb_frontend *fe,
 	struct m88ds3103_dev *dev = fe->demodulator_priv;
 	struct i2c_client *client = dev->client;
 	int ret;
-	u8 u8tmp;
+	unsigned int utmp;
 	bool voltage_sel, voltage_dis;
 
 	dev_dbg(&client->dev, "fe_sec_voltage=%d\n", fe_sec_voltage);
@@ -1170,8 +1029,8 @@ static int m88ds3103_set_voltage(struct dvb_frontend *fe,
 	voltage_sel ^= dev->cfg->lnb_hv_pol;
 	voltage_dis ^= dev->cfg->lnb_en_pol;
 
-	u8tmp = voltage_dis << 1 | voltage_sel << 0;
-	ret = m88ds3103_wr_reg_mask(dev, 0xa2, u8tmp, 0x03);
+	utmp = voltage_dis << 1 | voltage_sel << 0;
+	ret = regmap_update_bits(dev->regmap, 0xa2, 0x03, utmp);
 	if (ret)
 		goto err;
 
@@ -1187,8 +1046,8 @@ static int m88ds3103_diseqc_send_master_cmd(struct dvb_frontend *fe,
 	struct m88ds3103_dev *dev = fe->demodulator_priv;
 	struct i2c_client *client = dev->client;
 	int ret;
+	unsigned int utmp;
 	unsigned long timeout;
-	u8 u8tmp;
 
 	dev_dbg(&client->dev, "msg=%*ph\n",
 		diseqc_cmd->msg_len, diseqc_cmd->msg);
@@ -1203,17 +1062,17 @@ static int m88ds3103_diseqc_send_master_cmd(struct dvb_frontend *fe,
 		goto err;
 	}
 
-	u8tmp = dev->cfg->envelope_mode << 5;
-	ret = m88ds3103_wr_reg_mask(dev, 0xa2, u8tmp, 0xe0);
+	utmp = dev->cfg->envelope_mode << 5;
+	ret = regmap_update_bits(dev->regmap, 0xa2, 0xe0, utmp);
 	if (ret)
 		goto err;
 
-	ret = m88ds3103_wr_regs(dev, 0xa3, diseqc_cmd->msg,
+	ret = regmap_bulk_write(dev->regmap, 0xa3, diseqc_cmd->msg,
 			diseqc_cmd->msg_len);
 	if (ret)
 		goto err;
 
-	ret = m88ds3103_wr_reg(dev, 0xa1,
+	ret = regmap_write(dev->regmap, 0xa1,
 			(diseqc_cmd->msg_len - 1) << 3 | 0x07);
 	if (ret)
 		goto err;
@@ -1225,29 +1084,30 @@ static int m88ds3103_diseqc_send_master_cmd(struct dvb_frontend *fe,
 	/* DiSEqC message typical period is 54 ms */
 	usleep_range(50000, 54000);
 
-	for (u8tmp = 1; !time_after(jiffies, timeout) && u8tmp;) {
-		ret = m88ds3103_rd_reg_mask(dev, 0xa1, &u8tmp, 0x40);
+	for (utmp = 1; !time_after(jiffies, timeout) && utmp;) {
+		ret = regmap_read(dev->regmap, 0xa1, &utmp);
 		if (ret)
 			goto err;
+		utmp = (utmp >> 6) & 0x1;
 	}
 
-	if (u8tmp == 0) {
+	if (utmp == 0) {
 		dev_dbg(&client->dev, "diseqc tx took %u ms\n",
 			jiffies_to_msecs(jiffies) -
 			(jiffies_to_msecs(timeout) - SEND_MASTER_CMD_TIMEOUT));
 	} else {
 		dev_dbg(&client->dev, "diseqc tx timeout\n");
 
-		ret = m88ds3103_wr_reg_mask(dev, 0xa1, 0x40, 0xc0);
+		ret = regmap_update_bits(dev->regmap, 0xa1, 0xc0, 0x40);
 		if (ret)
 			goto err;
 	}
 
-	ret = m88ds3103_wr_reg_mask(dev, 0xa2, 0x80, 0xc0);
+	ret = regmap_update_bits(dev->regmap, 0xa2, 0xc0, 0x80);
 	if (ret)
 		goto err;
 
-	if (u8tmp == 1) {
+	if (utmp == 1) {
 		ret = -ETIMEDOUT;
 		goto err;
 	}
@@ -1264,8 +1124,8 @@ static int m88ds3103_diseqc_send_burst(struct dvb_frontend *fe,
 	struct m88ds3103_dev *dev = fe->demodulator_priv;
 	struct i2c_client *client = dev->client;
 	int ret;
+	unsigned int utmp, burst;
 	unsigned long timeout;
-	u8 u8tmp, burst;
 
 	dev_dbg(&client->dev, "fe_sec_mini_cmd=%d\n", fe_sec_mini_cmd);
 
@@ -1274,8 +1134,8 @@ static int m88ds3103_diseqc_send_burst(struct dvb_frontend *fe,
 		goto err;
 	}
 
-	u8tmp = dev->cfg->envelope_mode << 5;
-	ret = m88ds3103_wr_reg_mask(dev, 0xa2, u8tmp, 0xe0);
+	utmp = dev->cfg->envelope_mode << 5;
+	ret = regmap_update_bits(dev->regmap, 0xa2, 0xe0, utmp);
 	if (ret)
 		goto err;
 
@@ -1292,7 +1152,7 @@ static int m88ds3103_diseqc_send_burst(struct dvb_frontend *fe,
 		goto err;
 	}
 
-	ret = m88ds3103_wr_reg(dev, 0xa1, burst);
+	ret = regmap_write(dev->regmap, 0xa1, burst);
 	if (ret)
 		goto err;
 
@@ -1303,29 +1163,30 @@ static int m88ds3103_diseqc_send_burst(struct dvb_frontend *fe,
 	/* DiSEqC ToneBurst period is 12.5 ms */
 	usleep_range(8500, 12500);
 
-	for (u8tmp = 1; !time_after(jiffies, timeout) && u8tmp;) {
-		ret = m88ds3103_rd_reg_mask(dev, 0xa1, &u8tmp, 0x40);
+	for (utmp = 1; !time_after(jiffies, timeout) && utmp;) {
+		ret = regmap_read(dev->regmap, 0xa1, &utmp);
 		if (ret)
 			goto err;
+		utmp = (utmp >> 6) & 0x1;
 	}
 
-	if (u8tmp == 0) {
+	if (utmp == 0) {
 		dev_dbg(&client->dev, "diseqc tx took %u ms\n",
 			jiffies_to_msecs(jiffies) -
 			(jiffies_to_msecs(timeout) - SEND_BURST_TIMEOUT));
 	} else {
 		dev_dbg(&client->dev, "diseqc tx timeout\n");
 
-		ret = m88ds3103_wr_reg_mask(dev, 0xa1, 0x40, 0xc0);
+		ret = regmap_update_bits(dev->regmap, 0xa1, 0xc0, 0x40);
 		if (ret)
 			goto err;
 	}
 
-	ret = m88ds3103_wr_reg_mask(dev, 0xa2, 0x80, 0xc0);
+	ret = regmap_update_bits(dev->regmap, 0xa2, 0xc0, 0x80);
 	if (ret)
 		goto err;
 
-	if (u8tmp == 1) {
+	if (utmp == 1) {
 		ret = -ETIMEDOUT;
 		goto err;
 	}
@@ -1357,40 +1218,25 @@ static int m88ds3103_select(struct i2c_adapter *adap, void *mux_priv, u32 chan)
 	struct m88ds3103_dev *dev = mux_priv;
 	struct i2c_client *client = dev->client;
 	int ret;
-	struct i2c_msg gate_open_msg[1] = {
-		{
-			.addr = client->addr,
-			.flags = 0,
-			.len = 2,
-			.buf = "\x03\x11",
-		}
+	struct i2c_msg msg = {
+		.addr = client->addr,
+		.flags = 0,
+		.len = 2,
+		.buf = "\x03\x11",
 	};
 
-	mutex_lock(&dev->i2c_mutex);
-
-	/* open tuner I2C repeater for 1 xfer, closes automatically */
-	ret = __i2c_transfer(client->adapter, gate_open_msg, 1);
+	/* Open tuner I2C repeater for 1 xfer, closes automatically */
+	ret = __i2c_transfer(client->adapter, &msg, 1);
 	if (ret != 1) {
 		dev_warn(&client->dev, "i2c wr failed=%d\n", ret);
 		if (ret >= 0)
 			ret = -EREMOTEIO;
-
 		return ret;
 	}
 
 	return 0;
 }
 
-static int m88ds3103_deselect(struct i2c_adapter *adap, void *mux_priv,
-		u32 chan)
-{
-	struct m88ds3103_dev *dev = mux_priv;
-
-	mutex_unlock(&dev->i2c_mutex);
-
-	return 0;
-}
-
 /*
  * XXX: That is wrapper to m88ds3103_probe() via driver core in order to provide
  * proper I2C client for legacy media attach binding.
@@ -1499,7 +1345,7 @@ static int m88ds3103_probe(struct i2c_client *client,
 	struct m88ds3103_dev *dev;
 	struct m88ds3103_platform_data *pdata = client->dev.platform_data;
 	int ret;
-	u8 chip_id, u8tmp;
+	unsigned int utmp;
 
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 	if (!dev) {
@@ -1521,34 +1367,41 @@ static int m88ds3103_probe(struct i2c_client *client,
 	dev->config.lnb_hv_pol = pdata->lnb_hv_pol;
 	dev->config.lnb_en_pol = pdata->lnb_en_pol;
 	dev->cfg = &dev->config;
-	mutex_init(&dev->i2c_mutex);
+	/* create regmap */
+	dev->regmap_config.reg_bits = 8,
+	dev->regmap_config.val_bits = 8,
+	dev->regmap_config.lock_arg = dev,
+	dev->regmap = devm_regmap_init_i2c(client, &dev->regmap_config);
+	if (IS_ERR(dev->regmap)) {
+		ret = PTR_ERR(dev->regmap);
+		goto err_kfree;
+	}
 
 	/* 0x00: chip id[6:0], 0x01: chip ver[7:0], 0x02: chip ver[15:8] */
-	ret = m88ds3103_rd_reg(dev, 0x00, &chip_id);
+	ret = regmap_read(dev->regmap, 0x00, &utmp);
 	if (ret)
 		goto err_kfree;
 
-	chip_id >>= 1;
-	dev_dbg(&client->dev, "chip_id=%02x\n", chip_id);
+	dev->chip_id = utmp >> 1;
+	dev_dbg(&client->dev, "chip_id=%02x\n", dev->chip_id);
 
-	switch (chip_id) {
+	switch (dev->chip_id) {
 	case M88RS6000_CHIP_ID:
 	case M88DS3103_CHIP_ID:
 		break;
 	default:
 		goto err_kfree;
 	}
-	dev->chip_id = chip_id;
 
 	switch (dev->cfg->clock_out) {
 	case M88DS3103_CLOCK_OUT_DISABLED:
-		u8tmp = 0x80;
+		utmp = 0x80;
 		break;
 	case M88DS3103_CLOCK_OUT_ENABLED:
-		u8tmp = 0x00;
+		utmp = 0x00;
 		break;
 	case M88DS3103_CLOCK_OUT_ENABLED_DIV2:
-		u8tmp = 0x10;
+		utmp = 0x10;
 		break;
 	default:
 		ret = -EINVAL;
@@ -1557,28 +1410,28 @@ static int m88ds3103_probe(struct i2c_client *client,
 
 	/* 0x29 register is defined differently for m88rs6000. */
 	/* set internal tuner address to 0x21 */
-	if (chip_id == M88RS6000_CHIP_ID)
-		u8tmp = 0x00;
+	if (dev->chip_id == M88RS6000_CHIP_ID)
+		utmp = 0x00;
 
-	ret = m88ds3103_wr_reg(dev, 0x29, u8tmp);
+	ret = regmap_write(dev->regmap, 0x29, utmp);
 	if (ret)
 		goto err_kfree;
 
 	/* sleep */
-	ret = m88ds3103_wr_reg_mask(dev, 0x08, 0x00, 0x01);
+	ret = regmap_update_bits(dev->regmap, 0x08, 0x01, 0x00);
 	if (ret)
 		goto err_kfree;
-	ret = m88ds3103_wr_reg_mask(dev, 0x04, 0x01, 0x01);
+	ret = regmap_update_bits(dev->regmap, 0x04, 0x01, 0x01);
 	if (ret)
 		goto err_kfree;
-	ret = m88ds3103_wr_reg_mask(dev, 0x23, 0x10, 0x10);
+	ret = regmap_update_bits(dev->regmap, 0x23, 0x10, 0x10);
 	if (ret)
 		goto err_kfree;
 
 	/* create mux i2c adapter for tuner */
 	dev->i2c_adapter = i2c_add_mux_adapter(client->adapter, &client->dev,
 					       dev, 0, 0, 0, m88ds3103_select,
-					       m88ds3103_deselect);
+					       NULL);
 	if (dev->i2c_adapter == NULL) {
 		ret = -ENOMEM;
 		goto err_kfree;
diff --git a/drivers/media/dvb-frontends/m88ds3103_priv.h b/drivers/media/dvb-frontends/m88ds3103_priv.h
index 7461e6b..09b3034 100644
--- a/drivers/media/dvb-frontends/m88ds3103_priv.h
+++ b/drivers/media/dvb-frontends/m88ds3103_priv.h
@@ -22,6 +22,7 @@
 #include "dvb_math.h"
 #include <linux/firmware.h>
 #include <linux/i2c-mux.h>
+#include <linux/regmap.h>
 #include <linux/math64.h>
 
 #define M88DS3103_FIRMWARE "dvb-demod-m88ds3103.fw"
@@ -32,8 +33,8 @@
 
 struct m88ds3103_dev {
 	struct i2c_client *client;
-	/* mutex needed due to own tuner I2C adapter */
-	struct mutex i2c_mutex;
+	struct regmap_config regmap_config;
+	struct regmap *regmap;
 	struct m88ds3103_config config;
 	const struct m88ds3103_config *cfg;
 	struct dvb_frontend fe;
-- 
http://palosaari.fi/

