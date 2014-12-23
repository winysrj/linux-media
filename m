Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35416 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756630AbaLWUuc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 15:50:32 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 30/66] rtl2832: convert to regmap API
Date: Tue, 23 Dec 2014 22:49:23 +0200
Message-Id: <1419367799-14263-30-git-send-email-crope@iki.fi>
In-Reply-To: <1419367799-14263-1-git-send-email-crope@iki.fi>
References: <1419367799-14263-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use regmap to cover register access routines.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/Kconfig        |   1 +
 drivers/media/dvb-frontends/rtl2832.c      | 329 +++++++++++++++--------------
 drivers/media/dvb-frontends/rtl2832_priv.h |   4 +-
 3 files changed, 173 insertions(+), 161 deletions(-)

diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
index 0e12634..bb76727 100644
--- a/drivers/media/dvb-frontends/Kconfig
+++ b/drivers/media/dvb-frontends/Kconfig
@@ -452,6 +452,7 @@ config DVB_RTL2830
 config DVB_RTL2832
 	tristate "Realtek RTL2832 DVB-T"
 	depends on DVB_CORE && I2C && I2C_MUX
+	select REGMAP
 	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y when you want to support this frontend.
diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index 907d8e8..c7148c9 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -22,8 +22,6 @@
 #include "dvb_math.h"
 #include <linux/bitops.h>
 
-/* Max transfer size done by I2C transfer functions */
-#define MAX_XFER_SIZE  64
 #define REG_MASK(b) (BIT(b + 1) - 1)
 
 static const struct rtl2832_reg_entry registers[] = {
@@ -156,103 +154,53 @@ static const struct rtl2832_reg_entry registers[] = {
 	[DVBT_REG_4MSEL]	= {0x0, 0x13,  0, 0},
 };
 
-/* write multiple hardware registers */
-static int rtl2832_wr(struct rtl2832_dev *dev, u8 reg, u8 *val, int len)
+/* Our regmap is bypassing I2C adapter lock, thus we do it! */
+int rtl2832_bulk_write(struct i2c_client *client, unsigned int reg,
+		       const void *val, size_t val_count)
 {
-	struct i2c_client *client = dev->client;
+	struct rtl2832_dev *dev = i2c_get_clientdata(client);
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
 
-	if (1 + len > sizeof(buf)) {
-		dev_warn(&client->dev, "i2c wr reg=%04x: len=%d is too big!\n",
-			 reg, len);
-		return -EINVAL;
-	}
-
-	buf[0] = reg;
-	memcpy(&buf[1], val, len);
-
-	ret = i2c_transfer(dev->i2c_adapter, msg, 1);
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
-static int rtl2832_rd(struct rtl2832_dev *dev, u8 reg, u8 *val, int len)
+int rtl2832_update_bits(struct i2c_client *client, unsigned int reg,
+			unsigned int mask, unsigned int val)
 {
-	struct i2c_client *client = dev->client;
+	struct rtl2832_dev *dev = i2c_get_clientdata(client);
 	int ret;
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
 
-	ret = i2c_transfer(dev->i2c_adapter, msg, 2);
-	if (ret == 2) {
-		ret = 0;
-	} else {
-		dev_warn(&client->dev, "i2c rd failed=%d reg=%02x len=%d\n",
-			 ret, reg, len);
-		ret = -EREMOTEIO;
-	}
+	i2c_lock_adapter(client->adapter);
+	ret = regmap_update_bits(dev->regmap, reg, mask, val);
+	i2c_unlock_adapter(client->adapter);
 	return ret;
 }
 
-/* write multiple registers */
-static int rtl2832_wr_regs(struct rtl2832_dev *dev, u8 reg, u8 page, u8 *val,
-	int len)
+int rtl2832_bulk_read(struct i2c_client *client, unsigned int reg, void *val,
+		      size_t val_count)
 {
+	struct rtl2832_dev *dev = i2c_get_clientdata(client);
 	int ret;
 
-	/* switch bank if needed */
-	if (page != dev->page) {
-		ret = rtl2832_wr(dev, 0x00, &page, 1);
-		if (ret)
-			return ret;
+	i2c_lock_adapter(client->adapter);
+	ret = regmap_bulk_read(dev->regmap, reg, val, val_count);
+	i2c_unlock_adapter(client->adapter);
+	return ret;
+}
 
-		dev->page = page;
-	}
-	return rtl2832_wr(dev, reg, val, len);
+/* write multiple registers */
+static int rtl2832_wr_regs(struct rtl2832_dev *dev, u8 reg, u8 page, u8 *val, int len)
+{
+	return rtl2832_bulk_write(dev->client, page << 8 | reg, val, len);
 }
 
 /* read multiple registers */
-static int rtl2832_rd_regs(struct rtl2832_dev *dev, u8 reg, u8 page, u8 *val,
-	int len)
+static int rtl2832_rd_regs(struct rtl2832_dev *dev, u8 reg, u8 page, u8 *val, int len)
 {
-	int ret;
-
-	/* switch bank if needed */
-	if (page != dev->page) {
-		ret = rtl2832_wr(dev, 0x00, &page, 1);
-		if (ret)
-			return ret;
-
-		dev->page = page;
-	}
-	return rtl2832_rd(dev, reg, val, len);
+	return rtl2832_bulk_read(dev->client, page << 8 | reg, val, len);
 }
 
 /* write single register */
@@ -385,7 +333,6 @@ err:
 	return ret;
 }
 
-
 static int rtl2832_set_if(struct dvb_frontend *fe, u32 if_freq)
 {
 	struct rtl2832_dev *dev = fe->demodulator_priv;
@@ -897,44 +844,22 @@ err:
 }
 
 /*
- * Delay mechanism to avoid unneeded I2C gate open / close. Gate close is
- * delayed here a little bit in order to see if there is sequence of I2C
+ * I2C gate/mux/repeater logic
+ * We must use unlocked __i2c_transfer() here (through regmap) because of I2C
+ * adapter lock is already taken by tuner driver.
+ * There is delay mechanism to avoid unneeded I2C gate open / close. Gate close
+ * is delayed here a little bit in order to see if there is sequence of I2C
  * messages sent to same I2C bus.
- * We must use unlocked version of __i2c_transfer() in order to avoid deadlock
- * as lock is already taken by calling muxed i2c_transfer().
  */
 static void rtl2832_i2c_gate_work(struct work_struct *work)
 {
-	struct rtl2832_dev *dev = container_of(work,
-			struct rtl2832_dev, i2c_gate_work.work);
+	struct rtl2832_dev *dev = container_of(work, struct rtl2832_dev, i2c_gate_work.work);
 	struct i2c_client *client = dev->client;
 	int ret;
-	u8 buf[2];
-	struct i2c_msg msg[1] = {
-		{
-			.addr = client->addr,
-			.flags = 0,
-			.len = sizeof(buf),
-			.buf = buf,
-		}
-	};
-
-	dev_dbg(&client->dev, "\n");
 
-	/* select reg bank 1 */
-	buf[0] = 0x00;
-	buf[1] = 0x01;
-	ret = __i2c_transfer(client->adapter, msg, 1);
-	if (ret != 1)
-		goto err;
-
-	dev->page = 1;
-
-	/* close I2C repeater gate */
-	buf[0] = 0x01;
-	buf[1] = 0x10;
-	ret = __i2c_transfer(client->adapter, msg, 1);
-	if (ret != 1)
+	/* close gate */
+	ret = rtl2832_update_bits(dev->client, 0x101, 0x08, 0x00);
+	if (ret)
 		goto err;
 
 	dev->i2c_gate_state = false;
@@ -950,58 +875,24 @@ static int rtl2832_select(struct i2c_adapter *adap, void *mux_priv, u32 chan_id)
 	struct rtl2832_dev *dev = mux_priv;
 	struct i2c_client *client = dev->client;
 	int ret;
-	u8 buf[2], val;
-	struct i2c_msg msg[1] = {
-		{
-			.addr = client->addr,
-			.flags = 0,
-			.len = sizeof(buf),
-			.buf = buf,
-		}
-	};
-	struct i2c_msg msg_rd[2] = {
-		{
-			.addr = client->addr,
-			.flags = 0,
-			.len = 1,
-			.buf = "\x01",
-		}, {
-			.addr = client->addr,
-			.flags = I2C_M_RD,
-			.len = 1,
-			.buf = &val,
-		}
-	};
 
 	/* terminate possible gate closing */
-	cancel_delayed_work_sync(&dev->i2c_gate_work);
+	cancel_delayed_work(&dev->i2c_gate_work);
 
 	if (dev->i2c_gate_state == chan_id)
 		return 0;
 
-	/* select reg bank 1 */
-	buf[0] = 0x00;
-	buf[1] = 0x01;
-	ret = __i2c_transfer(client->adapter, msg, 1);
-	if (ret != 1)
-		goto err;
-
-	dev->page = 1;
-
-	/* we must read that register, otherwise there will be errors */
-	ret = __i2c_transfer(client->adapter, msg_rd, 2);
-	if (ret != 2)
-		goto err;
-
-	/* open or close I2C repeater gate */
-	buf[0] = 0x01;
+	/*
+	 * chan_id 1 is muxed adapter demod provides and chan_id 0 is demod
+	 * itself. We need open gate when request is for chan_id 1. On that case
+	 * I2C adapter lock is already taken and due to that we will use
+	 * regmap_update_bits() which does not lock again I2C adapter.
+	 */
 	if (chan_id == 1)
-		buf[1] = 0x18; /* open */
+		ret = regmap_update_bits(dev->regmap, 0x101, 0x08, 0x08);
 	else
-		buf[1] = 0x10; /* close */
-
-	ret = __i2c_transfer(client->adapter, msg, 1);
-	if (ret != 1)
+		ret = rtl2832_update_bits(dev->client, 0x101, 0x08, 0x00);
+	if (ret)
 		goto err;
 
 	dev->i2c_gate_state = chan_id;
@@ -1009,11 +900,11 @@ static int rtl2832_select(struct i2c_adapter *adap, void *mux_priv, u32 chan_id)
 	return 0;
 err:
 	dev_dbg(&client->dev, "failed=%d\n", ret);
-	return -EREMOTEIO;
+	return ret;
 }
 
 static int rtl2832_deselect(struct i2c_adapter *adap, void *mux_priv,
-		u32 chan_id)
+			    u32 chan_id)
 {
 	struct rtl2832_dev *dev = mux_priv;
 
@@ -1060,6 +951,91 @@ static struct dvb_frontend_ops rtl2832_ops = {
 	.i2c_gate_ctrl = rtl2832_i2c_gate_ctrl,
 };
 
+/*
+ * We implement own I2C access routines for regmap in order to get manual access
+ * to I2C adapter lock, which is needed for I2C mux adapter.
+ */
+static int rtl2832_regmap_read(void *context, const void *reg_buf,
+			       size_t reg_size, void *val_buf, size_t val_size)
+{
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
+
+	ret = __i2c_transfer(client->adapter, msg, 2);
+	if (ret != 2) {
+		dev_warn(&client->dev, "i2c reg read failed %d\n", ret);
+		if (ret >= 0)
+			ret = -EREMOTEIO;
+		return ret;
+	}
+	return 0;
+}
+
+static int rtl2832_regmap_write(void *context, const void *data, size_t count)
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
+static int rtl2832_regmap_gather_write(void *context, const void *reg,
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
+}
+
 static struct dvb_frontend *rtl2832_get_dvb_frontend(struct i2c_client *client)
 {
 	struct rtl2832_dev *dev = i2c_get_clientdata(client);
@@ -1142,6 +1118,30 @@ static int rtl2832_probe(struct i2c_client *client,
 	struct rtl2832_dev *dev;
 	int ret;
 	u8 tmp;
+	static const struct regmap_bus regmap_bus = {
+		.read = rtl2832_regmap_read,
+		.write = rtl2832_regmap_write,
+		.gather_write = rtl2832_regmap_gather_write,
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
 
@@ -1158,6 +1158,7 @@ static int rtl2832_probe(struct i2c_client *client,
 	}
 
 	/* setup the state */
+	i2c_set_clientdata(client, dev);
 	dev->client = client;
 	dev->pdata = client->dev.platform_data;
 	if (pdata->config) {
@@ -1166,12 +1167,19 @@ static int rtl2832_probe(struct i2c_client *client,
 	}
 	dev->sleeping = true;
 	INIT_DELAYED_WORK(&dev->i2c_gate_work, rtl2832_i2c_gate_work);
+	/* create regmap */
+	dev->regmap = regmap_init(&client->dev, &regmap_bus, client,
+				  &regmap_config);
+	if (IS_ERR(dev->regmap)) {
+		ret = PTR_ERR(dev->regmap);
+		goto err_kfree;
+	}
 	/* create muxed i2c adapter for demod itself */
 	dev->i2c_adapter = i2c_add_mux_adapter(i2c, &i2c->dev, dev, 0, 0, 0,
 			rtl2832_select, NULL);
 	if (dev->i2c_adapter == NULL) {
 		ret = -ENODEV;
-		goto err_kfree;
+		goto err_regmap_exit;
 	}
 
 	/* check if the demod is there */
@@ -1190,7 +1198,6 @@ static int rtl2832_probe(struct i2c_client *client,
 	/* create dvb_frontend */
 	memcpy(&dev->fe.ops, &rtl2832_ops, sizeof(struct dvb_frontend_ops));
 	dev->fe.demodulator_priv = dev;
-	i2c_set_clientdata(client, dev);
 
 	/* setup callbacks */
 	pdata->get_dvb_frontend = rtl2832_get_dvb_frontend;
@@ -1202,6 +1209,8 @@ static int rtl2832_probe(struct i2c_client *client,
 	return 0;
 err_i2c_del_mux_adapter:
 	i2c_del_mux_adapter(dev->i2c_adapter);
+err_regmap_exit:
+	regmap_exit(dev->regmap);
 err_kfree:
 	kfree(dev);
 err:
@@ -1221,6 +1230,8 @@ static int rtl2832_remove(struct i2c_client *client)
 
 	i2c_del_mux_adapter(dev->i2c_adapter);
 
+	regmap_exit(dev->regmap);
+
 	kfree(dev);
 
 	return 0;
diff --git a/drivers/media/dvb-frontends/rtl2832_priv.h b/drivers/media/dvb-frontends/rtl2832_priv.h
index 8995332..eacd4e4 100644
--- a/drivers/media/dvb-frontends/rtl2832_priv.h
+++ b/drivers/media/dvb-frontends/rtl2832_priv.h
@@ -24,18 +24,18 @@
 #include "dvb_frontend.h"
 #include "rtl2832.h"
 #include <linux/i2c-mux.h>
+#include <linux/regmap.h>
 
 struct rtl2832_dev {
 	struct rtl2832_platform_data *pdata;
 	struct i2c_client *client;
+	struct regmap *regmap;
 	struct i2c_adapter *i2c_adapter;
 	struct i2c_adapter *i2c_adapter_tuner;
 	struct dvb_frontend fe;
 
 	bool i2c_gate_state;
 	bool sleeping;
-
-	u8 page; /* active register page */
 	struct delayed_work i2c_gate_work;
 };
 
-- 
http://palosaari.fi/

