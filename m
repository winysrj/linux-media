Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.lysator.liu.se ([130.236.254.3]:40144 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbcCDLBu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Mar 2016 06:01:50 -0500
Message-ID: <56D96B15.8090806@lysator.liu.se>
Date: Fri, 04 Mar 2016 12:01:41 +0100
From: Peter Rosin <peda@lysator.liu.se>
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Peter Rosin <peda@axentia.se>, Wolfram Sang <wsa@the-dreams.de>,
	Peter Korsgaard <peter.korsgaard@barco.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Jonathan Cameron <jic23@kernel.org>,
	Hartmut Knaack <knaack.h@gmx.de>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Peter Meerwald <pmeerw@pmeerw.net>,
	Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Rob Herring <robh+dt@kernel.org>,
	Frank Rowand <frowand.list@gmail.com>,
	Grant Likely <grant.likely@linaro.org>,
	Viorel Suman <viorel.suman@intel.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Terry Heo <terryheo@google.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Tommi Rantala <tt.rantala@gmail.com>,
	linux-i2c@vger.kernel.org, linux-iio@vger.kernel.org,
	linux-media@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v4 00/18] i2c mux cleanup and locking update
References: <1457044050-15230-1-git-send-email-peda@lysator.liu.se>
In-Reply-To: <1457044050-15230-1-git-send-email-peda@lysator.liu.se>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I wrote:
> Concerns:
> - The locking is perhaps too complex?

Ok, to highlight the benefits of this series, I expect that patches such as
[1] and the one inlined below can follow up to clean up ad-hoc i2c locking
in drivers. Putting this locking in one place instead of having it spread
out in random drivers is a good thing.

PS. the inlined patch has not been tested as I have no hw, it's a proof of
concept. Maybe the simplifications can be extended into rtl2832_sdr.c as well?
Anyway, please do test this patch on top of the v4 series if you have the hw.

Cheers,
Peter

[1] https://lkml.org/lkml/2016/3/3/932

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index 775444898599..fd1f05e9e79a 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -158,36 +158,24 @@ static int rtl2832_bulk_write(struct i2c_client *client, unsigned int reg,
 			      const void *val, size_t val_count)
 {
 	struct rtl2832_dev *dev = i2c_get_clientdata(client);
-	int ret;
 
-	i2c_lock_adapter(client->adapter);
-	ret = regmap_bulk_write(dev->regmap, reg, val, val_count);
-	i2c_unlock_adapter(client->adapter);
-	return ret;
+	return regmap_bulk_write(dev->regmap, reg, val, val_count);
 }
 
 static int rtl2832_update_bits(struct i2c_client *client, unsigned int reg,
 			       unsigned int mask, unsigned int val)
 {
 	struct rtl2832_dev *dev = i2c_get_clientdata(client);
-	int ret;
 
-	i2c_lock_adapter(client->adapter);
-	ret = regmap_update_bits(dev->regmap, reg, mask, val);
-	i2c_unlock_adapter(client->adapter);
-	return ret;
+	return regmap_update_bits(dev->regmap, reg, mask, val);
 }
 
 static int rtl2832_bulk_read(struct i2c_client *client, unsigned int reg,
 			     void *val, size_t val_count)
 {
 	struct rtl2832_dev *dev = i2c_get_clientdata(client);
-	int ret;
 
-	i2c_lock_adapter(client->adapter);
-	ret = regmap_bulk_read(dev->regmap, reg, val, val_count);
-	i2c_unlock_adapter(client->adapter);
-	return ret;
+	return regmap_bulk_read(dev->regmap, reg, val, val_count);
 }
 
 static int rtl2832_rd_demod_reg(struct rtl2832_dev *dev, int reg, u32 *val)
@@ -204,7 +192,7 @@ static int rtl2832_rd_demod_reg(struct rtl2832_dev *dev, int reg, u32 *val)
 	len = (msb >> 3) + 1;
 	mask = REG_MASK(msb - lsb);
 
-	ret = rtl2832_bulk_read(client, reg_start_addr, reading, len);
+	ret = regmap_bulk_read(dev->regmap, reg_start_addr, reading, len);
 	if (ret)
 		goto err;
 
@@ -234,7 +222,7 @@ static int rtl2832_wr_demod_reg(struct rtl2832_dev *dev, int reg, u32 val)
 	len = (msb >> 3) + 1;
 	mask = REG_MASK(msb - lsb);
 
-	ret = rtl2832_bulk_read(client, reg_start_addr, reading, len);
+	ret = regmap_bulk_read(dev->regmap, reg_start_addr, reading, len);
 	if (ret)
 		goto err;
 
@@ -248,7 +236,7 @@ static int rtl2832_wr_demod_reg(struct rtl2832_dev *dev, int reg, u32 val)
 	for (i = 0; i < len; i++)
 		writing[i] = (writing_tmp >> ((len - 1 - i) * 8)) & 0xff;
 
-	ret = rtl2832_bulk_write(client, reg_start_addr, writing, len);
+	ret = regmap_bulk_write(dev->regmap, reg_start_addr, writing, len);
 	if (ret)
 		goto err;
 
@@ -492,7 +480,7 @@ static int rtl2832_set_frontend(struct dvb_frontend *fe)
 		fe->ops.tuner_ops.set_params(fe);
 
 	/* PIP mode related */
-	ret = rtl2832_bulk_write(client, 0x192, "\x00\x0f\xff", 3);
+	ret = regmap_bulk_write(dev->regmap, 0x192, "\x00\x0f\xff", 3);
 	if (ret)
 		goto err;
 
@@ -530,7 +518,7 @@ static int rtl2832_set_frontend(struct dvb_frontend *fe)
 	}
 
 	for (j = 0; j < sizeof(bw_params[0]); j++) {
-		ret = rtl2832_bulk_write(client, 0x11c + j, &bw_params[i][j], 1);
+		ret = regmap_bulk_write(dev->regmap, 0x11c + j, &bw_params[i][j], 1);
 		if (ret)
 			goto err;
 	}
@@ -586,11 +574,11 @@ static int rtl2832_get_frontend(struct dvb_frontend *fe)
 	if (dev->sleeping)
 		return 0;
 
-	ret = rtl2832_bulk_read(client, 0x33c, buf, 2);
+	ret = regmap_bulk_read(dev->regmap, 0x33c, buf, 2);
 	if (ret)
 		goto err;
 
-	ret = rtl2832_bulk_read(client, 0x351, &buf[2], 1);
+	ret = regmap_bulk_read(dev->regmap, 0x351, &buf[2], 1);
 	if (ret)
 		goto err;
 
@@ -757,7 +745,7 @@ static void rtl2832_stat_work(struct work_struct *work)
 	/* signal strength */
 	if (dev->fe_status & FE_HAS_SIGNAL) {
 		/* read digital AGC */
-		ret = rtl2832_bulk_read(client, 0x305, &u8tmp, 1);
+		ret = regmap_bulk_read(dev->regmap, 0x305, &u8tmp, 1);
 		if (ret)
 			goto err;
 
@@ -783,7 +771,7 @@ static void rtl2832_stat_work(struct work_struct *work)
 			{87659938, 87659938, 87885178, 88241743},
 		};
 
-		ret = rtl2832_bulk_read(client, 0x33c, &u8tmp, 1);
+		ret = regmap_bulk_read(dev->regmap, 0x33c, &u8tmp, 1);
 		if (ret)
 			goto err;
 
@@ -795,7 +783,7 @@ static void rtl2832_stat_work(struct work_struct *work)
 		if (hierarchy > HIERARCHY_NUM - 1)
 			goto err_schedule_delayed_work;
 
-		ret = rtl2832_bulk_read(client, 0x40c, buf, 2);
+		ret = regmap_bulk_read(dev->regmap, 0x40c, buf, 2);
 		if (ret)
 			goto err;
 
@@ -816,7 +804,7 @@ static void rtl2832_stat_work(struct work_struct *work)
 
 	/* BER */
 	if (dev->fe_status & FE_HAS_LOCK) {
-		ret = rtl2832_bulk_read(client, 0x34e, buf, 2);
+		ret = regmap_bulk_read(dev->regmap, 0x34e, buf, 2);
 		if (ret)
 			goto err;
 
@@ -844,8 +832,6 @@ err:
 
 /*
  * I2C gate/mux/repeater logic
- * We must use unlocked __i2c_transfer() here (through regmap) because of I2C
- * adapter lock is already taken by tuner driver.
  * There is delay mechanism to avoid unneeded I2C gate open / close. Gate close
  * is delayed here a little bit in order to see if there is sequence of I2C
  * messages sent to same I2C bus.
@@ -857,7 +843,7 @@ static void rtl2832_i2c_gate_work(struct work_struct *work)
 	int ret;
 
 	/* close gate */
-	ret = rtl2832_update_bits(dev->client, 0x101, 0x08, 0x00);
+	ret = regmap_update_bits(dev->regmap, 0x101, 0x08, 0x00);
 	if (ret)
 		goto err;
 
@@ -875,10 +861,7 @@ static int rtl2832_select(struct i2c_mux_core *muxc, u32 chan_id)
 	/* terminate possible gate closing */
 	cancel_delayed_work(&dev->i2c_gate_work);
 
-	/*
-	 * I2C adapter lock is already taken and due to that we will use
-	 * regmap_update_bits() which does not lock again I2C adapter.
-	 */
+	/* open gate */
 	ret = regmap_update_bits(dev->regmap, 0x101, 0x08, 0x08);
 	if (ret)
 		goto err;
@@ -950,120 +933,6 @@ static bool rtl2832_volatile_reg(struct device *dev, unsigned int reg)
 	return false;
 }
 
-/*
- * We implement own I2C access routines for regmap in order to get manual access
- * to I2C adapter lock, which is needed for I2C mux adapter.
- */
-static int rtl2832_regmap_read(void *context, const void *reg_buf,
-			       size_t reg_size, void *val_buf, size_t val_size)
-{
-	struct i2c_client *client = context;
-	int ret;
-	struct i2c_msg msg[2] = {
-		{
-			.addr = client->addr,
-			.flags = 0,
-			.len = reg_size,
-			.buf = (u8 *)reg_buf,
-		}, {
-			.addr = client->addr,
-			.flags = I2C_M_RD,
-			.len = val_size,
-			.buf = val_buf,
-		}
-	};
-
-	ret = __i2c_transfer(client->adapter, msg, 2);
-	if (ret != 2) {
-		dev_warn(&client->dev, "i2c reg read failed %d reg %02x\n",
-			 ret, *(u8 *)reg_buf);
-		if (ret >= 0)
-			ret = -EREMOTEIO;
-		return ret;
-	}
-	return 0;
-}
-
-static int rtl2832_regmap_write(void *context, const void *data, size_t count)
-{
-	struct i2c_client *client = context;
-	int ret;
-	struct i2c_msg msg[1] = {
-		{
-			.addr = client->addr,
-			.flags = 0,
-			.len = count,
-			.buf = (u8 *)data,
-		}
-	};
-
-	ret = __i2c_transfer(client->adapter, msg, 1);
-	if (ret != 1) {
-		dev_warn(&client->dev, "i2c reg write failed %d reg %02x\n",
-			 ret, *(u8 *)data);
-		if (ret >= 0)
-			ret = -EREMOTEIO;
-		return ret;
-	}
-	return 0;
-}
-
-static int rtl2832_regmap_gather_write(void *context, const void *reg,
-				       size_t reg_len, const void *val,
-				       size_t val_len)
-{
-	struct i2c_client *client = context;
-	int ret;
-	u8 buf[256];
-	struct i2c_msg msg[1] = {
-		{
-			.addr = client->addr,
-			.flags = 0,
-			.len = 1 + val_len,
-			.buf = buf,
-		}
-	};
-
-	buf[0] = *(u8 const *)reg;
-	memcpy(&buf[1], val, val_len);
-
-	ret = __i2c_transfer(client->adapter, msg, 1);
-	if (ret != 1) {
-		dev_warn(&client->dev, "i2c reg write failed %d reg %02x\n",
-			 ret, *(u8 const *)reg);
-		if (ret >= 0)
-			ret = -EREMOTEIO;
-		return ret;
-	}
-	return 0;
-}
-
-/*
- * FIXME: Hack. Implement own regmap locking in order to silence lockdep
- * recursive lock warning. That happens when regmap I2C client calls I2C mux
- * adapter, which leads demod I2C repeater enable via demod regmap. Operation
- * takes two regmap locks recursively - but those are different regmap instances
- * in a two different I2C drivers, so it is not deadlock. Proper fix is to make
- * regmap aware of lockdep.
- */
-static void rtl2832_regmap_lock(void *__dev)
-{
-	struct rtl2832_dev *dev = __dev;
-	struct i2c_client *client = dev->client;
-
-	dev_dbg(&client->dev, "\n");
-	mutex_lock(&dev->regmap_mutex);
-}
-
-static void rtl2832_regmap_unlock(void *__dev)
-{
-	struct rtl2832_dev *dev = __dev;
-	struct i2c_client *client = dev->client;
-
-	dev_dbg(&client->dev, "\n");
-	mutex_unlock(&dev->regmap_mutex);
-}
-
 static struct dvb_frontend *rtl2832_get_dvb_frontend(struct i2c_client *client)
 {
 	struct rtl2832_dev *dev = i2c_get_clientdata(client);
@@ -1087,7 +956,7 @@ static int rtl2832_enable_slave_ts(struct i2c_client *client)
 
 	dev_dbg(&client->dev, "\n");
 
-	ret = rtl2832_bulk_write(client, 0x10c, "\x5f\xff", 2);
+	ret = regmap_bulk_write(dev->regmap, 0x10c, "\x5f\xff", 2);
 	if (ret)
 		goto err;
 
@@ -1095,11 +964,11 @@ static int rtl2832_enable_slave_ts(struct i2c_client *client)
 	if (ret)
 		goto err;
 
-	ret = rtl2832_bulk_write(client, 0x0bc, "\x18", 1);
+	ret = regmap_bulk_write(dev->regmap, 0x0bc, "\x18", 1);
 	if (ret)
 		goto err;
 
-	ret = rtl2832_bulk_write(client, 0x192, "\x7f\xf7\xff", 3);
+	ret = regmap_bulk_write(dev->regmap, 0x192, "\x7f\xf7\xff", 3);
 	if (ret)
 		goto err;
 
@@ -1133,7 +1002,7 @@ static int rtl2832_pid_filter_ctrl(struct dvb_frontend *fe, int onoff)
 	else
 		u8tmp = 0x00;
 
-	ret = rtl2832_update_bits(client, 0x061, 0xc0, u8tmp);
+	ret = regmap_update_bits(dev->regmap, 0x061, 0xc0, u8tmp);
 	if (ret)
 		goto err;
 
@@ -1168,14 +1037,14 @@ static int rtl2832_pid_filter(struct dvb_frontend *fe, u8 index, u16 pid,
 	buf[1] = (dev->filters >>  8) & 0xff;
 	buf[2] = (dev->filters >> 16) & 0xff;
 	buf[3] = (dev->filters >> 24) & 0xff;
-	ret = rtl2832_bulk_write(client, 0x062, buf, 4);
+	ret = regmap_bulk_write(dev->regmap, 0x062, buf, 4);
 	if (ret)
 		goto err;
 
 	/* add PID */
 	buf[0] = (pid >> 8) & 0xff;
 	buf[1] = (pid >> 0) & 0xff;
-	ret = rtl2832_bulk_write(client, 0x066 + 2 * index, buf, 2);
+	ret = regmap_bulk_write(dev->regmap, 0x066 + 2 * index, buf, 2);
 	if (ret)
 		goto err;
 
@@ -1193,12 +1062,6 @@ static int rtl2832_probe(struct i2c_client *client,
 	struct rtl2832_dev *dev;
 	int ret;
 	u8 tmp;
-	static const struct regmap_bus regmap_bus = {
-		.read = rtl2832_regmap_read,
-		.write = rtl2832_regmap_write,
-		.gather_write = rtl2832_regmap_gather_write,
-		.val_format_endian_default = REGMAP_ENDIAN_NATIVE,
-	};
 	static const struct regmap_range_cfg regmap_range_cfg[] = {
 		{
 			.selector_reg     = 0x00,
@@ -1231,15 +1094,12 @@ static int rtl2832_probe(struct i2c_client *client,
 	mutex_init(&dev->regmap_mutex);
 	dev->regmap_config.reg_bits =  8,
 	dev->regmap_config.val_bits =  8,
-	dev->regmap_config.lock = rtl2832_regmap_lock,
-	dev->regmap_config.unlock = rtl2832_regmap_unlock,
-	dev->regmap_config.lock_arg = dev,
 	dev->regmap_config.volatile_reg = rtl2832_volatile_reg,
 	dev->regmap_config.max_register = 5 * 0x100,
 	dev->regmap_config.ranges = regmap_range_cfg,
 	dev->regmap_config.num_ranges = ARRAY_SIZE(regmap_range_cfg),
 	dev->regmap_config.cache_type = REGCACHE_NONE,
-	dev->regmap = regmap_init(&client->dev, &regmap_bus, client,
+	dev->regmap = regmap_init(&client->dev, NULL, client,
 				  &dev->regmap_config);
 	if (IS_ERR(dev->regmap)) {
 		ret = PTR_ERR(dev->regmap);
@@ -1247,12 +1107,13 @@ static int rtl2832_probe(struct i2c_client *client,
 	}
 
 	/* check if the demod is there */
-	ret = rtl2832_bulk_read(client, 0x000, &tmp, 1);
+	ret = regmap_bulk_read(dev->regmap, 0x000, &tmp, 1);
 	if (ret)
 		goto err_regmap_exit;
 
 	/* create muxed i2c adapter for demod tuner bus */
-	dev->muxc = i2c_mux_one_adapter(i2c, &i2c->dev, 0, 0, 0, 0, 0,
+	dev->muxc = i2c_mux_one_adapter(i2c, &i2c->dev, 0,
+					I2C_CONTROLLED_MUX, 0, 0, 0,
 					rtl2832_select, rtl2832_deselect);
 	if (IS_ERR(dev->muxc)) {
 		ret = PTR_ERR(dev->muxc);
-- 
2.1.4

