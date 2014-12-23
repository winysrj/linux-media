Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38435 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756621AbaLWUub (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 15:50:31 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 22/66] rtl2830: convert to regmap API
Date: Tue, 23 Dec 2014 22:49:15 +0200
Message-Id: <1419367799-14263-22-git-send-email-crope@iki.fi>
In-Reply-To: <1419367799-14263-1-git-send-email-crope@iki.fi>
References: <1419367799-14263-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use regmap to cover register access routines.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/Kconfig        |   1 +
 drivers/media/dvb-frontends/rtl2830.c      | 415 +++++++++++++----------------
 drivers/media/dvb-frontends/rtl2830_priv.h |   4 +-
 3 files changed, 182 insertions(+), 238 deletions(-)

diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
index e8827fc..0e12634 100644
--- a/drivers/media/dvb-frontends/Kconfig
+++ b/drivers/media/dvb-frontends/Kconfig
@@ -444,6 +444,7 @@ config DVB_CXD2820R
 config DVB_RTL2830
 	tristate "Realtek RTL2830 DVB-T"
 	depends on DVB_CORE && I2C && I2C_MUX
+	select REGMAP
 	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y when you want to support this frontend.
diff --git a/drivers/media/dvb-frontends/rtl2830.c b/drivers/media/dvb-frontends/rtl2830.c
index 3a9e4e9..a90f155 100644
--- a/drivers/media/dvb-frontends/rtl2830.c
+++ b/drivers/media/dvb-frontends/rtl2830.c
@@ -17,176 +17,43 @@
 
 #include "rtl2830_priv.h"
 
-/* Max transfer size done by I2C transfer functions */
-#define MAX_XFER_SIZE  64
-
-/* write multiple hardware registers */
-static int rtl2830_wr(struct i2c_client *client, u8 reg, const u8 *val, int len)
+/* Our regmap is bypassing I2C adapter lock, thus we do it! */
+int rtl2830_bulk_write(struct i2c_client *client, unsigned int reg,
+		       const void *val, size_t val_count)
 {
+	struct rtl2830_dev *dev = i2c_get_clientdata(client);
 	int ret;
-	u8 buf[MAX_XFER_SIZE];
-	struct i2c_msg msg[1] = {
-		{
-			.addr = client->addr,
-			.flags = 0,
-			.len = 1 + len,
-			.buf = buf,
-		}
-	};
-
-	if (1 + len > sizeof(buf)) {
-		dev_warn(&client->dev, "i2c wr reg=%04x: len=%d is too big!\n",
-			 reg, len);
-		return -EINVAL;
-	}
-
-	buf[0] = reg;
-	memcpy(&buf[1], val, len);
-
-	ret = __i2c_transfer(client->adapter, msg, 1);
-	if (ret == 1) {
-		ret = 0;
-	} else {
-		dev_warn(&client->dev, "i2c wr failed=%d reg=%02x len=%d\n",
-			 ret, reg, len);
-		ret = -EREMOTEIO;
-	}
 
+	i2c_lock_adapter(client->adapter);
+	ret = regmap_bulk_write(dev->regmap, reg, val, val_count);
+	i2c_unlock_adapter(client->adapter);
 	return ret;
 }
 
-/* read multiple hardware registers */
-static int rtl2830_rd(struct i2c_client *client, u8 reg, u8 *val, int len)
-{
-	int ret;
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
-			.buf = val,
-		}
-	};
-
-	ret = __i2c_transfer(client->adapter, msg, 2);
-	if (ret == 2) {
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
-/* write multiple registers */
-static int rtl2830_wr_regs(struct i2c_client *client, u16 reg, const u8 *val, int len)
+int rtl2830_update_bits(struct i2c_client *client, unsigned int reg,
+			unsigned int mask, unsigned int val)
 {
 	struct rtl2830_dev *dev = i2c_get_clientdata(client);
 	int ret;
-	u8 reg2 = (reg >> 0) & 0xff;
-	u8 page = (reg >> 8) & 0xff;
-
-	mutex_lock(&dev->i2c_mutex);
-
-	/* switch bank if needed */
-	if (page != dev->page) {
-		ret = rtl2830_wr(client, 0x00, &page, 1);
-		if (ret)
-			goto err_mutex_unlock;
-
-		dev->page = page;
-	}
-
-	ret = rtl2830_wr(client, reg2, val, len);
-
-err_mutex_unlock:
-	mutex_unlock(&dev->i2c_mutex);
 
+	i2c_lock_adapter(client->adapter);
+	ret = regmap_update_bits(dev->regmap, reg, mask, val);
+	i2c_unlock_adapter(client->adapter);
 	return ret;
 }
 
-/* read multiple registers */
-static int rtl2830_rd_regs(struct i2c_client *client, u16 reg, u8 *val, int len)
+int rtl2830_bulk_read(struct i2c_client *client, unsigned int reg, void *val,
+		      size_t val_count)
 {
 	struct rtl2830_dev *dev = i2c_get_clientdata(client);
 	int ret;
-	u8 reg2 = (reg >> 0) & 0xff;
-	u8 page = (reg >> 8) & 0xff;
-
-	mutex_lock(&dev->i2c_mutex);
-
-	/* switch bank if needed */
-	if (page != dev->page) {
-		ret = rtl2830_wr(client, 0x00, &page, 1);
-		if (ret)
-			goto err_mutex_unlock;
-
-		dev->page = page;
-	}
-
-	ret = rtl2830_rd(client, reg2, val, len);
-
-err_mutex_unlock:
-	mutex_unlock(&dev->i2c_mutex);
 
+	i2c_lock_adapter(client->adapter);
+	ret = regmap_bulk_read(dev->regmap, reg, val, val_count);
+	i2c_unlock_adapter(client->adapter);
 	return ret;
 }
 
-/* read single register */
-static int rtl2830_rd_reg(struct i2c_client *client, u16 reg, u8 *val)
-{
-	return rtl2830_rd_regs(client, reg, val, 1);
-}
-
-/* write single register with mask */
-static int rtl2830_wr_reg_mask(struct i2c_client *client, u16 reg, u8 val, u8 mask)
-{
-	int ret;
-	u8 tmp;
-
-	/* no need for read if whole reg is written */
-	if (mask != 0xff) {
-		ret = rtl2830_rd_regs(client, reg, &tmp, 1);
-		if (ret)
-			return ret;
-
-		val &= mask;
-		tmp &= ~mask;
-		val |= tmp;
-	}
-
-	return rtl2830_wr_regs(client, reg, &val, 1);
-}
-
-/* read single register with mask */
-static int rtl2830_rd_reg_mask(struct i2c_client *client, u16 reg, u8 *val, u8 mask)
-{
-	int ret, i;
-	u8 tmp;
-
-	ret = rtl2830_rd_regs(client, reg, &tmp, 1);
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
 static int rtl2830_init(struct dvb_frontend *fe)
 {
 	struct i2c_client *client = fe->demodulator_priv;
@@ -233,29 +100,29 @@ static int rtl2830_init(struct dvb_frontend *fe)
 	};
 
 	for (i = 0; i < ARRAY_SIZE(tab); i++) {
-		ret = rtl2830_wr_reg_mask(client, tab[i].reg, tab[i].val,
-					  tab[i].mask);
+		ret = rtl2830_update_bits(client, tab[i].reg, tab[i].mask,
+					  tab[i].val);
 		if (ret)
 			goto err;
 	}
 
-	ret = rtl2830_wr_regs(client, 0x18f, "\x28\x00", 2);
+	ret = rtl2830_bulk_write(client, 0x18f, "\x28\x00", 2);
 	if (ret)
 		goto err;
 
-	ret = rtl2830_wr_regs(client, 0x195,
-			      "\x04\x06\x0a\x12\x0a\x12\x1e\x28", 8);
+	ret = rtl2830_bulk_write(client, 0x195,
+				 "\x04\x06\x0a\x12\x0a\x12\x1e\x28", 8);
 	if (ret)
 		goto err;
 
 	/* TODO: spec init */
 
 	/* soft reset */
-	ret = rtl2830_wr_reg_mask(client, 0x101, 0x04, 0x04);
+	ret = rtl2830_update_bits(client, 0x101, 0x04, 0x04);
 	if (ret)
 		goto err;
 
-	ret = rtl2830_wr_reg_mask(client, 0x101, 0x00, 0x04);
+	ret = rtl2830_update_bits(client, 0x101, 0x04, 0x00);
 	if (ret)
 		goto err;
 
@@ -309,7 +176,7 @@ static int rtl2830_set_frontend(struct dvb_frontend *fe)
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, i;
 	u64 num;
-	u8 buf[3], tmp;
+	u8 buf[3], u8tmp;
 	u32 if_ctl, if_frequency;
 	static const u8 bw_params1[3][34] = {
 		{
@@ -358,7 +225,7 @@ static int rtl2830_set_frontend(struct dvb_frontend *fe)
 		return -EINVAL;
 	}
 
-	ret = rtl2830_wr_reg_mask(client, 0x008, i << 1, 0x06);
+	ret = rtl2830_update_bits(client, 0x008, 0x06, i << 1);
 	if (ret)
 		goto err;
 
@@ -378,30 +245,31 @@ static int rtl2830_set_frontend(struct dvb_frontend *fe)
 	dev_dbg(&client->dev, "if_frequency=%d if_ctl=%08x\n",
 		if_frequency, if_ctl);
 
-	ret = rtl2830_rd_reg_mask(client, 0x119, &tmp, 0xc0); /* b[7:6] */
+	buf[0] = (if_ctl >> 16) & 0x3f;
+	buf[1] = (if_ctl >>  8) & 0xff;
+	buf[2] = (if_ctl >>  0) & 0xff;
+
+	ret = rtl2830_bulk_read(client, 0x119, &u8tmp, 1);
 	if (ret)
 		goto err;
 
-	buf[0] = tmp << 6;
-	buf[0] |= (if_ctl >> 16) & 0x3f;
-	buf[1] = (if_ctl >>  8) & 0xff;
-	buf[2] = (if_ctl >>  0) & 0xff;
+	buf[0] |= u8tmp & 0xc0;  /* [7:6] */
 
-	ret = rtl2830_wr_regs(client, 0x119, buf, 3);
+	ret = rtl2830_bulk_write(client, 0x119, buf, 3);
 	if (ret)
 		goto err;
 
 	/* 1/2 split I2C write */
-	ret = rtl2830_wr_regs(client, 0x11c, &bw_params1[i][0], 17);
+	ret = rtl2830_bulk_write(client, 0x11c, &bw_params1[i][0], 17);
 	if (ret)
 		goto err;
 
 	/* 2/2 split I2C write */
-	ret = rtl2830_wr_regs(client, 0x12d, &bw_params1[i][17], 17);
+	ret = rtl2830_bulk_write(client, 0x12d, &bw_params1[i][17], 17);
 	if (ret)
 		goto err;
 
-	ret = rtl2830_wr_regs(client, 0x19d, bw_params2[i], 6);
+	ret = rtl2830_bulk_write(client, 0x19d, bw_params2[i], 6);
 	if (ret)
 		goto err;
 
@@ -422,11 +290,11 @@ static int rtl2830_get_frontend(struct dvb_frontend *fe)
 	if (dev->sleeping)
 		return 0;
 
-	ret = rtl2830_rd_regs(client, 0x33c, buf, 2);
+	ret = rtl2830_bulk_read(client, 0x33c, buf, 2);
 	if (ret)
 		goto err;
 
-	ret = rtl2830_rd_reg(client, 0x351, &buf[2]);
+	ret = rtl2830_bulk_read(client, 0x351, &buf[2], 1);
 	if (ret)
 		goto err;
 
@@ -529,21 +397,22 @@ static int rtl2830_read_status(struct dvb_frontend *fe, fe_status_t *status)
 	struct i2c_client *client = fe->demodulator_priv;
 	struct rtl2830_dev *dev = i2c_get_clientdata(client);
 	int ret;
-	u8 tmp;
+	u8 u8tmp;
 
 	*status = 0;
 
 	if (dev->sleeping)
 		return 0;
 
-	ret = rtl2830_rd_reg_mask(client, 0x351, &tmp, 0x78); /* [6:3] */
+	ret = rtl2830_bulk_read(client, 0x351, &u8tmp, 1);
 	if (ret)
 		goto err;
 
-	if (tmp == 11) {
+	u8tmp = (u8tmp >> 3) & 0x0f; /* [6:3] */
+	if (u8tmp == 11) {
 		*status |= FE_HAS_SIGNAL | FE_HAS_CARRIER |
 			FE_HAS_VITERBI | FE_HAS_SYNC | FE_HAS_LOCK;
-	} else if (tmp == 10) {
+	} else if (u8tmp == 10) {
 		*status |= FE_HAS_SIGNAL | FE_HAS_CARRIER |
 			FE_HAS_VITERBI;
 	}
@@ -650,7 +519,7 @@ static void rtl2830_stat_work(struct work_struct *work)
 		struct {signed int x:14; } s;
 
 		/* read IF AGC */
-		ret = rtl2830_rd_regs(client, 0x359, buf, 2);
+		ret = rtl2830_bulk_read(client, 0x359, buf, 2);
 		if (ret)
 			goto err;
 
@@ -678,7 +547,7 @@ static void rtl2830_stat_work(struct work_struct *work)
 			{92888734, 92888734, 95487525, 99770748},
 		};
 
-		ret = rtl2830_rd_reg(client, 0x33c, &u8tmp);
+		ret = rtl2830_bulk_read(client, 0x33c, &u8tmp, 1);
 		if (ret)
 			goto err;
 
@@ -690,7 +559,7 @@ static void rtl2830_stat_work(struct work_struct *work)
 		if (hierarchy > HIERARCHY_NUM - 1)
 			goto err_schedule_delayed_work;
 
-		ret = rtl2830_rd_regs(client, 0x40c, buf, 2);
+		ret = rtl2830_bulk_read(client, 0x40c, buf, 2);
 		if (ret)
 			goto err;
 
@@ -711,7 +580,7 @@ static void rtl2830_stat_work(struct work_struct *work)
 
 	/* BER */
 	if (dev->fe_status & FE_HAS_LOCK) {
-		ret = rtl2830_rd_regs(client, 0x34e, buf, 2);
+		ret = rtl2830_bulk_read(client, 0x34e, buf, 2);
 		if (ret)
 			goto err;
 
@@ -751,7 +620,7 @@ static int rtl2830_pid_filter_ctrl(struct dvb_frontend *fe, int onoff)
 	else
 		u8tmp = 0x00;
 
-	ret = rtl2830_wr_reg_mask(client, 0x061, u8tmp, 0x80);
+	ret = rtl2830_update_bits(client, 0x061, 0x80, u8tmp);
 	if (ret)
 		goto err;
 
@@ -785,14 +654,14 @@ static int rtl2830_pid_filter(struct dvb_frontend *fe, u8 index, u16 pid, int on
 	buf[1] = (dev->filters >>  8) & 0xff;
 	buf[2] = (dev->filters >> 16) & 0xff;
 	buf[3] = (dev->filters >> 24) & 0xff;
-	ret = rtl2830_wr_regs(client, 0x062, buf, 4);
+	ret = rtl2830_bulk_write(client, 0x062, buf, 4);
 	if (ret)
 		goto err;
 
 	/* add PID */
 	buf[0] = (pid >> 8) & 0xff;
 	buf[1] = (pid >> 0) & 0xff;
-	ret = rtl2830_wr_regs(client, 0x066 + 2 * index, buf, 2);
+	ret = rtl2830_bulk_write(client, 0x066 + 2 * index, buf, 2);
 	if (ret)
 		goto err;
 
@@ -803,55 +672,24 @@ err:
 }
 
 /*
- * I2C gate/repeater logic
- * We must use unlocked i2c_transfer() here because I2C lock is already taken
- * by tuner driver. Gate is closed automatically after single I2C xfer.
+ * I2C gate/mux/repeater logic
+ * We must use unlocked __i2c_transfer() here (through regmap) because of I2C
+ * adapter lock is already taken by tuner driver.
+ * Gate is closed automatically after single I2C transfer.
  */
 static int rtl2830_select(struct i2c_adapter *adap, void *mux_priv, u32 chan_id)
 {
 	struct i2c_client *client = mux_priv;
 	struct rtl2830_dev *dev = i2c_get_clientdata(client);
-	struct i2c_msg select_reg_page_msg[1] = {
-		{
-			.addr = client->addr,
-			.flags = 0,
-			.len = 2,
-			.buf = "\x00\x01",
-		}
-	};
-	struct i2c_msg gate_open_msg[1] = {
-		{
-			.addr = client->addr,
-			.flags = 0,
-			.len = 2,
-			.buf = "\x01\x08",
-		}
-	};
 	int ret;
 
 	dev_dbg(&client->dev, "\n");
 
-	mutex_lock(&dev->i2c_mutex);
-
-	/* select register page */
-	ret = __i2c_transfer(client->adapter, select_reg_page_msg, 1);
-	if (ret != 1) {
-		dev_warn(&client->dev, "i2c write failed %d\n", ret);
-		if (ret >= 0)
-			ret = -EREMOTEIO;
+	/* open I2C repeater for 1 transfer, closes automatically */
+	/* XXX: regmap_update_bits() does not lock I2C adapter */
+	ret = regmap_update_bits(dev->regmap, 0x101, 0x08, 0x08);
+	if (ret)
 		goto err;
-	}
-
-	dev->page = 1;
-
-	/* open tuner I2C repeater for 1 xfer, closes automatically */
-	ret = __i2c_transfer(client->adapter, gate_open_msg, 1);
-	if (ret != 1) {
-		dev_warn(&client->dev, "i2c write failed %d\n", ret);
-		if (ret >= 0)
-			ret = -EREMOTEIO;
-		goto err;
-	}
 
 	return 0;
 err:
@@ -859,34 +697,107 @@ err:
 	return ret;
 }
 
-static int rtl2830_deselect(struct i2c_adapter *adap, void *mux_priv, u32 chan)
+static struct dvb_frontend *rtl2830_get_dvb_frontend(struct i2c_client *client)
 {
-	struct i2c_client *client = mux_priv;
 	struct rtl2830_dev *dev = i2c_get_clientdata(client);
 
 	dev_dbg(&client->dev, "\n");
 
-	mutex_unlock(&dev->i2c_mutex);
-
-	return 0;
+	return &dev->fe;
 }
 
-static struct dvb_frontend *rtl2830_get_dvb_frontend(struct i2c_client *client)
+static struct i2c_adapter *rtl2830_get_i2c_adapter(struct i2c_client *client)
 {
 	struct rtl2830_dev *dev = i2c_get_clientdata(client);
 
 	dev_dbg(&client->dev, "\n");
 
-	return &dev->fe;
+	return dev->adapter;
 }
 
-static struct i2c_adapter *rtl2830_get_i2c_adapter(struct i2c_client *client)
+/*
+ * We implement own I2C access routines for regmap in order to get manual access
+ * to I2C adapter lock, which is needed for I2C mux adapter.
+ */
+static int rtl2830_regmap_read(void *context, const void *reg_buf,
+			       size_t reg_size, void *val_buf, size_t val_size)
 {
-	struct rtl2830_dev *dev = i2c_get_clientdata(client);
+	struct i2c_client *client = context;
+	int ret;
+	struct i2c_msg msg[2] = {
+		{
+			.addr = client->addr,
+			.flags = 0,
+			.len = reg_size,
+			.buf = (u8 *)reg_buf,
+		}, {
+			.addr = client->addr,
+			.flags = I2C_M_RD,
+			.len = val_size,
+			.buf = val_buf,
+		}
+	};
 
-	dev_dbg(&client->dev, "\n");
+	ret = __i2c_transfer(client->adapter, msg, 2);
+	if (ret != 2) {
+		dev_warn(&client->dev, "i2c reg read failed %d\n", ret);
+		if (ret >= 0)
+			ret = -EREMOTEIO;
+		return ret;
+	}
+	return 0;
+}
 
-	return dev->adapter;
+static int rtl2830_regmap_write(void *context, const void *data, size_t count)
+{
+	struct i2c_client *client = context;
+	int ret;
+	struct i2c_msg msg[1] = {
+		{
+			.addr = client->addr,
+			.flags = 0,
+			.len = count,
+			.buf = (u8 *)data,
+		}
+	};
+
+	ret = __i2c_transfer(client->adapter, msg, 1);
+	if (ret != 1) {
+		dev_warn(&client->dev, "i2c reg write failed %d\n", ret);
+		if (ret >= 0)
+			ret = -EREMOTEIO;
+		return ret;
+	}
+	return 0;
+}
+
+static int rtl2830_regmap_gather_write(void *context, const void *reg,
+				       size_t reg_len, const void *val,
+				       size_t val_len)
+{
+	struct i2c_client *client = context;
+	int ret;
+	u8 buf[256];
+	struct i2c_msg msg[1] = {
+		{
+			.addr = client->addr,
+			.flags = 0,
+			.len = 1 + val_len,
+			.buf = buf,
+		}
+	};
+
+	buf[0] = *(u8 const *)reg;
+	memcpy(&buf[1], val, val_len);
+
+	ret = __i2c_transfer(client->adapter, msg, 1);
+	if (ret != 1) {
+		dev_warn(&client->dev, "i2c reg write failed %d\n", ret);
+		if (ret >= 0)
+			ret = -EREMOTEIO;
+		return ret;
+	}
+	return 0;
 }
 
 static int rtl2830_probe(struct i2c_client *client,
@@ -896,6 +807,30 @@ static int rtl2830_probe(struct i2c_client *client,
 	struct rtl2830_dev *dev;
 	int ret;
 	u8 u8tmp;
+	static const struct regmap_bus regmap_bus = {
+		.read = rtl2830_regmap_read,
+		.write = rtl2830_regmap_write,
+		.gather_write = rtl2830_regmap_gather_write,
+		.val_format_endian_default = REGMAP_ENDIAN_NATIVE,
+	};
+	static const struct regmap_range_cfg regmap_range_cfg[] = {
+		{
+			.selector_reg     = 0x00,
+			.selector_mask    = 0xff,
+			.selector_shift   = 0,
+			.window_start     = 0,
+			.window_len       = 0x100,
+			.range_min        = 0 * 0x100,
+			.range_max        = 5 * 0x100,
+		},
+	};
+	static const struct regmap_config regmap_config = {
+		.reg_bits    =  8,
+		.val_bits    =  8,
+		.max_register = 5 * 0x100,
+		.ranges = regmap_range_cfg,
+		.num_ranges = ARRAY_SIZE(regmap_range_cfg),
+	};
 
 	dev_dbg(&client->dev, "\n");
 
@@ -916,20 +851,25 @@ static int rtl2830_probe(struct i2c_client *client,
 	dev->client = client;
 	dev->pdata = client->dev.platform_data;
 	dev->sleeping = true;
-	mutex_init(&dev->i2c_mutex);
 	INIT_DELAYED_WORK(&dev->stat_work, rtl2830_stat_work);
+	dev->regmap = regmap_init(&client->dev, &regmap_bus, client,
+				  &regmap_config);
+	if (IS_ERR(dev->regmap)) {
+		ret = PTR_ERR(dev->regmap);
+		goto err_kfree;
+	}
 
 	/* check if the demod is there */
-	ret = rtl2830_rd_reg(client, 0x000, &u8tmp);
+	ret = rtl2830_bulk_read(client, 0x000, &u8tmp, 1);
 	if (ret)
-		goto err_kfree;
+		goto err_regmap_exit;
 
 	/* create muxed i2c adapter for tuner */
 	dev->adapter = i2c_add_mux_adapter(client->adapter, &client->dev,
-			client, 0, 0, 0, rtl2830_select, rtl2830_deselect);
+			client, 0, 0, 0, rtl2830_select, NULL);
 	if (dev->adapter == NULL) {
 		ret = -ENODEV;
-		goto err_kfree;
+		goto err_regmap_exit;
 	}
 
 	/* create dvb frontend */
@@ -945,6 +885,8 @@ static int rtl2830_probe(struct i2c_client *client,
 	dev_info(&client->dev, "Realtek RTL2830 successfully attached\n");
 
 	return 0;
+err_regmap_exit:
+	regmap_exit(dev->regmap);
 err_kfree:
 	kfree(dev);
 err:
@@ -959,6 +901,7 @@ static int rtl2830_remove(struct i2c_client *client)
 	dev_dbg(&client->dev, "\n");
 
 	i2c_del_mux_adapter(dev->adapter);
+	regmap_exit(dev->regmap);
 	kfree(dev);
 
 	return 0;
diff --git a/drivers/media/dvb-frontends/rtl2830_priv.h b/drivers/media/dvb-frontends/rtl2830_priv.h
index 517758a..d50d537 100644
--- a/drivers/media/dvb-frontends/rtl2830_priv.h
+++ b/drivers/media/dvb-frontends/rtl2830_priv.h
@@ -23,15 +23,15 @@
 #include "rtl2830.h"
 #include <linux/i2c-mux.h>
 #include <linux/math64.h>
+#include <linux/regmap.h>
 
 struct rtl2830_dev {
 	struct rtl2830_platform_data *pdata;
 	struct i2c_client *client;
+	struct regmap *regmap;
 	struct i2c_adapter *adapter;
 	struct dvb_frontend fe;
 	bool sleeping;
-	struct mutex i2c_mutex;
-	u8 page; /* active register page */
 	unsigned long filters;
 	struct delayed_work stat_work;
 	fe_status_t fe_status;
-- 
http://palosaari.fi/

