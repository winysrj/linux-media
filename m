Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.lysator.liu.se ([130.236.254.3]:53264 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbcDCI5s (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Apr 2016 04:57:48 -0400
From: Peter Rosin <peda@lysator.liu.se>
To: linux-kernel@vger.kernel.org
Cc: Peter Rosin <peda@axentia.se>, Wolfram Sang <wsa@the-dreams.de>,
	Jonathan Corbet <corbet@lwn.net>,
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
	Andrew Morton <akpm@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Kalle Valo <kvalo@codeaurora.org>,
	Joe Perches <joe@perches.com>, Jiri Slaby <jslaby@suse.com>,
	Daniel Baluta <daniel.baluta@intel.com>,
	Adriana Reus <adriana.reus@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Matt Ranostay <matt.ranostay@intel.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Terry Heo <terryheo@google.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Tommi Rantala <tt.rantala@gmail.com>,
	linux-i2c@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-iio@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org, Peter Rosin <peda@lysator.liu.se>
Subject: [PATCH v6 22/24] [media] rtl2832: change the i2c gate to be mux-locked
Date: Sun,  3 Apr 2016 10:52:52 +0200
Message-Id: <1459673574-11440-23-git-send-email-peda@lysator.liu.se>
In-Reply-To: <1459673574-11440-1-git-send-email-peda@lysator.liu.se>
References: <1459673574-11440-1-git-send-email-peda@lysator.liu.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Peter Rosin <peda@axentia.se>

The root i2c adapter lock is then no longer held by the i2c mux during
accesses behind the i2c gate, and such accesses need to take that lock
just like any other ordinary i2c accesses do.

So, declare the i2c gate mux-locked, and zap the regmap overrides
that makes the i2c accesses unlocked and use plain old regmap
accesses. This also removes the need for the regmap wrappers used by
rtl2832_sdr, so deconvolute the code further and provide the regmap
handle directly instead of the wrapper functions.

Signed-off-by: Peter Rosin <peda@axentia.se>
---
 Documentation/i2c/i2c-topology            |   2 +-
 drivers/media/dvb-frontends/rtl2832.c     | 191 +++++-------------------------
 drivers/media/dvb-frontends/rtl2832.h     |   4 +-
 drivers/media/dvb-frontends/rtl2832_sdr.c |  13 +-
 drivers/media/dvb-frontends/rtl2832_sdr.h |   5 +-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c   |   5 +-
 6 files changed, 38 insertions(+), 182 deletions(-)

diff --git a/Documentation/i2c/i2c-topology b/Documentation/i2c/i2c-topology
index a9ca97df7661..3f359bd93591 100644
--- a/Documentation/i2c/i2c-topology
+++ b/Documentation/i2c/i2c-topology
@@ -55,7 +55,7 @@ imu/inv_mpu6050/          Mux-locked
 In drivers/media/
 dvb-frontends/m88ds3103   Parent-locked
 dvb-frontends/rtl2830     Parent-locked
-dvb-frontends/rtl2832     Parent-locked
+dvb-frontends/rtl2832     Mux-locked
 dvb-frontends/si2168      Mux-locked
 usb/cx231xx/              Parent-locked
 
diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index 545c3bbbc668..ac5ac5f7a335 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -153,43 +153,6 @@ static const struct rtl2832_reg_entry registers[] = {
 	[DVBT_REG_4MSEL]	= {0x013,  0, 0},
 };
 
-/* Our regmap is bypassing I2C adapter lock, thus we do it! */
-static int rtl2832_bulk_write(struct i2c_client *client, unsigned int reg,
-			      const void *val, size_t val_count)
-{
-	struct rtl2832_dev *dev = i2c_get_clientdata(client);
-	int ret;
-
-	i2c_lock_adapter(client->adapter);
-	ret = regmap_bulk_write(dev->regmap, reg, val, val_count);
-	i2c_unlock_adapter(client->adapter);
-	return ret;
-}
-
-static int rtl2832_update_bits(struct i2c_client *client, unsigned int reg,
-			       unsigned int mask, unsigned int val)
-{
-	struct rtl2832_dev *dev = i2c_get_clientdata(client);
-	int ret;
-
-	i2c_lock_adapter(client->adapter);
-	ret = regmap_update_bits(dev->regmap, reg, mask, val);
-	i2c_unlock_adapter(client->adapter);
-	return ret;
-}
-
-static int rtl2832_bulk_read(struct i2c_client *client, unsigned int reg,
-			     void *val, size_t val_count)
-{
-	struct rtl2832_dev *dev = i2c_get_clientdata(client);
-	int ret;
-
-	i2c_lock_adapter(client->adapter);
-	ret = regmap_bulk_read(dev->regmap, reg, val, val_count);
-	i2c_unlock_adapter(client->adapter);
-	return ret;
-}
-
 static int rtl2832_rd_demod_reg(struct rtl2832_dev *dev, int reg, u32 *val)
 {
 	struct i2c_client *client = dev->client;
@@ -204,7 +167,7 @@ static int rtl2832_rd_demod_reg(struct rtl2832_dev *dev, int reg, u32 *val)
 	len = (msb >> 3) + 1;
 	mask = REG_MASK(msb - lsb);
 
-	ret = rtl2832_bulk_read(client, reg_start_addr, reading, len);
+	ret = regmap_bulk_read(dev->regmap, reg_start_addr, reading, len);
 	if (ret)
 		goto err;
 
@@ -234,7 +197,7 @@ static int rtl2832_wr_demod_reg(struct rtl2832_dev *dev, int reg, u32 val)
 	len = (msb >> 3) + 1;
 	mask = REG_MASK(msb - lsb);
 
-	ret = rtl2832_bulk_read(client, reg_start_addr, reading, len);
+	ret = regmap_bulk_read(dev->regmap, reg_start_addr, reading, len);
 	if (ret)
 		goto err;
 
@@ -248,7 +211,7 @@ static int rtl2832_wr_demod_reg(struct rtl2832_dev *dev, int reg, u32 val)
 	for (i = 0; i < len; i++)
 		writing[i] = (writing_tmp >> ((len - 1 - i) * 8)) & 0xff;
 
-	ret = rtl2832_bulk_write(client, reg_start_addr, writing, len);
+	ret = regmap_bulk_write(dev->regmap, reg_start_addr, writing, len);
 	if (ret)
 		goto err;
 
@@ -525,7 +488,8 @@ static int rtl2832_set_frontend(struct dvb_frontend *fe)
 	}
 
 	for (j = 0; j < sizeof(bw_params[0]); j++) {
-		ret = rtl2832_bulk_write(client, 0x11c + j, &bw_params[i][j], 1);
+		ret = regmap_bulk_write(dev->regmap,
+					0x11c + j, &bw_params[i][j], 1);
 		if (ret)
 			goto err;
 	}
@@ -581,11 +545,11 @@ static int rtl2832_get_frontend(struct dvb_frontend *fe,
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
 
@@ -716,7 +680,7 @@ static int rtl2832_read_status(struct dvb_frontend *fe, enum fe_status *status)
 	/* signal strength */
 	if (dev->fe_status & FE_HAS_SIGNAL) {
 		/* read digital AGC */
-		ret = rtl2832_bulk_read(client, 0x305, &u8tmp, 1);
+		ret = regmap_bulk_read(dev->regmap, 0x305, &u8tmp, 1);
 		if (ret)
 			goto err;
 
@@ -742,7 +706,7 @@ static int rtl2832_read_status(struct dvb_frontend *fe, enum fe_status *status)
 			{87659938, 87659938, 87885178, 88241743},
 		};
 
-		ret = rtl2832_bulk_read(client, 0x33c, &u8tmp, 1);
+		ret = regmap_bulk_read(dev->regmap, 0x33c, &u8tmp, 1);
 		if (ret)
 			goto err;
 
@@ -754,7 +718,7 @@ static int rtl2832_read_status(struct dvb_frontend *fe, enum fe_status *status)
 		if (hierarchy > HIERARCHY_NUM - 1)
 			goto err;
 
-		ret = rtl2832_bulk_read(client, 0x40c, buf, 2);
+		ret = regmap_bulk_read(dev->regmap, 0x40c, buf, 2);
 		if (ret)
 			goto err;
 
@@ -775,7 +739,7 @@ static int rtl2832_read_status(struct dvb_frontend *fe, enum fe_status *status)
 
 	/* BER */
 	if (dev->fe_status & FE_HAS_LOCK) {
-		ret = rtl2832_bulk_read(client, 0x34e, buf, 2);
+		ret = regmap_bulk_read(dev->regmap, 0x34e, buf, 2);
 		if (ret)
 			goto err;
 
@@ -825,8 +789,6 @@ static int rtl2832_read_ber(struct dvb_frontend *fe, u32 *ber)
 
 /*
  * I2C gate/mux/repeater logic
- * We must use unlocked __i2c_transfer() here (through regmap) because of I2C
- * adapter lock is already taken by tuner driver.
  * There is delay mechanism to avoid unneeded I2C gate open / close. Gate close
  * is delayed here a little bit in order to see if there is sequence of I2C
  * messages sent to same I2C bus.
@@ -838,7 +800,7 @@ static void rtl2832_i2c_gate_work(struct work_struct *work)
 	int ret;
 
 	/* close gate */
-	ret = rtl2832_update_bits(dev->client, 0x101, 0x08, 0x00);
+	ret = regmap_update_bits(dev->regmap, 0x101, 0x08, 0x00);
 	if (ret)
 		goto err;
 
@@ -856,10 +818,7 @@ static int rtl2832_select(struct i2c_mux_core *muxc, u32 chan_id)
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
@@ -932,94 +891,6 @@ static bool rtl2832_volatile_reg(struct device *dev, unsigned int reg)
 }
 
 /*
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
  * FIXME: Hack. Implement own regmap locking in order to silence lockdep
  * recursive lock warning. That happens when regmap I2C client calls I2C mux
  * adapter, which leads demod I2C repeater enable via demod regmap. Operation
@@ -1072,29 +943,29 @@ static int rtl2832_slave_ts_ctrl(struct i2c_client *client, bool enable)
 		ret = rtl2832_wr_demod_reg(dev, DVBT_SOFT_RST, 0x0);
 		if (ret)
 			goto err;
-		ret = rtl2832_bulk_write(client, 0x10c, "\x5f\xff", 2);
+		ret = regmap_bulk_write(dev->regmap, 0x10c, "\x5f\xff", 2);
 		if (ret)
 			goto err;
 		ret = rtl2832_wr_demod_reg(dev, DVBT_PIP_ON, 0x1);
 		if (ret)
 			goto err;
-		ret = rtl2832_bulk_write(client, 0x0bc, "\x18", 1);
+		ret = regmap_bulk_write(dev->regmap, 0x0bc, "\x18", 1);
 		if (ret)
 			goto err;
-		ret = rtl2832_bulk_write(client, 0x192, "\x7f\xf7\xff", 3);
+		ret = regmap_bulk_write(dev->regmap, 0x192, "\x7f\xf7\xff", 3);
 		if (ret)
 			goto err;
 	} else {
-		ret = rtl2832_bulk_write(client, 0x192, "\x00\x0f\xff", 3);
+		ret = regmap_bulk_write(dev->regmap, 0x192, "\x00\x0f\xff", 3);
 		if (ret)
 			goto err;
-		ret = rtl2832_bulk_write(client, 0x0bc, "\x08", 1);
+		ret = regmap_bulk_write(dev->regmap, 0x0bc, "\x08", 1);
 		if (ret)
 			goto err;
 		ret = rtl2832_wr_demod_reg(dev, DVBT_PIP_ON, 0x0);
 		if (ret)
 			goto err;
-		ret = rtl2832_bulk_write(client, 0x10c, "\x00\x00", 2);
+		ret = regmap_bulk_write(dev->regmap, 0x10c, "\x00\x00", 2);
 		if (ret)
 			goto err;
 		ret = rtl2832_wr_demod_reg(dev, DVBT_SOFT_RST, 0x1);
@@ -1123,7 +994,7 @@ static int rtl2832_pid_filter_ctrl(struct dvb_frontend *fe, int onoff)
 	else
 		u8tmp = 0x00;
 
-	ret = rtl2832_update_bits(client, 0x061, 0xc0, u8tmp);
+	ret = regmap_update_bits(dev->regmap, 0x061, 0xc0, u8tmp);
 	if (ret)
 		goto err;
 
@@ -1158,14 +1029,14 @@ static int rtl2832_pid_filter(struct dvb_frontend *fe, u8 index, u16 pid,
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
 
@@ -1183,12 +1054,6 @@ static int rtl2832_probe(struct i2c_client *client,
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
@@ -1228,20 +1093,20 @@ static int rtl2832_probe(struct i2c_client *client,
 	dev->regmap_config.ranges = regmap_range_cfg,
 	dev->regmap_config.num_ranges = ARRAY_SIZE(regmap_range_cfg),
 	dev->regmap_config.cache_type = REGCACHE_NONE,
-	dev->regmap = regmap_init(&client->dev, &regmap_bus, client,
-				  &dev->regmap_config);
+	dev->regmap = regmap_init_i2c(client, &dev->regmap_config);
 	if (IS_ERR(dev->regmap)) {
 		ret = PTR_ERR(dev->regmap);
 		goto err_kfree;
 	}
 
 	/* check if the demod is there */
-	ret = rtl2832_bulk_read(client, 0x000, &tmp, 1);
+	ret = regmap_bulk_read(dev->regmap, 0x000, &tmp, 1);
 	if (ret)
 		goto err_regmap_exit;
 
 	/* create muxed i2c adapter for demod tuner bus */
-	dev->muxc = i2c_mux_one_adapter(i2c, &i2c->dev, 0, 0, 0, 0, 0,
+	dev->muxc = i2c_mux_one_adapter(i2c, &i2c->dev, 0,
+					I2C_MUX_LOCKED, 0, 0, 0,
 					rtl2832_select, rtl2832_deselect);
 	if (IS_ERR(dev->muxc)) {
 		ret = PTR_ERR(dev->muxc);
@@ -1259,9 +1124,7 @@ static int rtl2832_probe(struct i2c_client *client,
 	pdata->slave_ts_ctrl = rtl2832_slave_ts_ctrl;
 	pdata->pid_filter = rtl2832_pid_filter;
 	pdata->pid_filter_ctrl = rtl2832_pid_filter_ctrl;
-	pdata->bulk_read = rtl2832_bulk_read;
-	pdata->bulk_write = rtl2832_bulk_write;
-	pdata->update_bits = rtl2832_update_bits;
+	pdata->regmap = dev->regmap;
 
 	dev_info(&client->dev, "Realtek RTL2832 successfully attached\n");
 	return 0;
diff --git a/drivers/media/dvb-frontends/rtl2832.h b/drivers/media/dvb-frontends/rtl2832.h
index 6390af64cf45..03c0de039fa9 100644
--- a/drivers/media/dvb-frontends/rtl2832.h
+++ b/drivers/media/dvb-frontends/rtl2832.h
@@ -57,9 +57,7 @@ struct rtl2832_platform_data {
 	int (*pid_filter)(struct dvb_frontend *, u8, u16, int);
 	int (*pid_filter_ctrl)(struct dvb_frontend *, int);
 /* private: Register access for SDR module use only */
-	int (*bulk_read)(struct i2c_client *, unsigned int, void *, size_t);
-	int (*bulk_write)(struct i2c_client *, unsigned int, const void *, size_t);
-	int (*update_bits)(struct i2c_client *, unsigned int, unsigned int, unsigned int);
+	struct regmap *regmap;
 };
 
 #endif /* RTL2832_H */
diff --git a/drivers/media/dvb-frontends/rtl2832_sdr.c b/drivers/media/dvb-frontends/rtl2832_sdr.c
index b860f02a4e55..6a6b1debe277 100644
--- a/drivers/media/dvb-frontends/rtl2832_sdr.c
+++ b/drivers/media/dvb-frontends/rtl2832_sdr.c
@@ -35,6 +35,7 @@
 #include <linux/platform_device.h>
 #include <linux/jiffies.h>
 #include <linux/math64.h>
+#include <linux/regmap.h>
 
 static bool rtl2832_sdr_emulated_fmt;
 module_param_named(emulated_formats, rtl2832_sdr_emulated_fmt, bool, 0644);
@@ -169,9 +170,9 @@ static int rtl2832_sdr_wr_regs(struct rtl2832_sdr_dev *dev, u16 reg,
 {
 	struct platform_device *pdev = dev->pdev;
 	struct rtl2832_sdr_platform_data *pdata = pdev->dev.platform_data;
-	struct i2c_client *client = pdata->i2c_client;
+	struct regmap *regmap = pdata->regmap;
 
-	return pdata->bulk_write(client, reg, val, len);
+	return regmap_bulk_write(regmap, reg, val, len);
 }
 
 #if 0
@@ -181,9 +182,9 @@ static int rtl2832_sdr_rd_regs(struct rtl2832_sdr_dev *dev, u16 reg, u8 *val,
 {
 	struct platform_device *pdev = dev->pdev;
 	struct rtl2832_sdr_platform_data *pdata = pdev->dev.platform_data;
-	struct i2c_client *client = pdata->i2c_client;
+	struct regmap *regmap = pdata->regmap;
 
-	return pdata->bulk_read(client, reg, val, len);
+	return regmap_bulk_read(regmap, reg, val, len);
 }
 #endif
 
@@ -199,9 +200,9 @@ static int rtl2832_sdr_wr_reg_mask(struct rtl2832_sdr_dev *dev, u16 reg,
 {
 	struct platform_device *pdev = dev->pdev;
 	struct rtl2832_sdr_platform_data *pdata = pdev->dev.platform_data;
-	struct i2c_client *client = pdata->i2c_client;
+	struct regmap *regmap = pdata->regmap;
 
-	return pdata->update_bits(client, reg, mask, val);
+	return regmap_update_bits(regmap, reg, mask, val);
 }
 
 /* Private functions */
diff --git a/drivers/media/dvb-frontends/rtl2832_sdr.h b/drivers/media/dvb-frontends/rtl2832_sdr.h
index 342ea84860df..d8fc7e7212e3 100644
--- a/drivers/media/dvb-frontends/rtl2832_sdr.h
+++ b/drivers/media/dvb-frontends/rtl2832_sdr.h
@@ -56,10 +56,7 @@ struct rtl2832_sdr_platform_data {
 #define RTL2832_SDR_TUNER_R828D     0x2b
 	u8 tuner;
 
-	struct i2c_client *i2c_client;
-	int (*bulk_read)(struct i2c_client *, unsigned int, void *, size_t);
-	int (*bulk_write)(struct i2c_client *, unsigned int, const void *, size_t);
-	int (*update_bits)(struct i2c_client *, unsigned int, unsigned int, unsigned int);
+	struct regmap *regmap;
 	struct dvb_frontend *dvb_frontend;
 	struct v4l2_subdev *v4l2_subdev;
 	struct dvb_usb_device *dvb_usb_device;
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index fa72642d41f3..eb7af8cb8aca 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1333,10 +1333,7 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 	case TUNER_RTL2832_R828D:
 		pdata.clk = dev->rtl2832_platform_data.clk;
 		pdata.tuner = dev->tuner;
-		pdata.i2c_client = dev->i2c_client_demod;
-		pdata.bulk_read = dev->rtl2832_platform_data.bulk_read;
-		pdata.bulk_write = dev->rtl2832_platform_data.bulk_write;
-		pdata.update_bits = dev->rtl2832_platform_data.update_bits;
+		pdata.regmap = dev->rtl2832_platform_data.regmap;
 		pdata.dvb_frontend = adap->fe[0];
 		pdata.dvb_usb_device = d;
 		pdata.v4l2_subdev = subdev;
-- 
2.1.4

