Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([91.232.154.25]:46819 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932801AbeCMXkN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 19:40:13 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 08/18] af9013: add i2c mux adapter for tuner bus
Date: Wed, 14 Mar 2018 01:39:34 +0200
Message-Id: <20180313233944.7234-8-crope@iki.fi>
In-Reply-To: <20180313233944.7234-1-crope@iki.fi>
References: <20180313233944.7234-1-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add muxed i2c adapter for demod tuner i2c bus gate control.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/Kconfig       |   2 +-
 drivers/media/dvb-frontends/af9013.c      | 126 +++++++++++++++++++++++++-----
 drivers/media/dvb-frontends/af9013.h      |   1 +
 drivers/media/dvb-frontends/af9013_priv.h |   1 +
 4 files changed, 111 insertions(+), 19 deletions(-)

diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
index 687086cdb870..0712069fd9fe 100644
--- a/drivers/media/dvb-frontends/Kconfig
+++ b/drivers/media/dvb-frontends/Kconfig
@@ -462,7 +462,7 @@ config DVB_TDA10048
 
 config DVB_AF9013
 	tristate "Afatech AF9013 demodulator"
-	depends on DVB_CORE && I2C
+	depends on DVB_CORE && I2C && I2C_MUX
 	select REGMAP
 	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
diff --git a/drivers/media/dvb-frontends/af9013.c b/drivers/media/dvb-frontends/af9013.c
index 87a55cd67e03..d55c5f67ce0f 100644
--- a/drivers/media/dvb-frontends/af9013.c
+++ b/drivers/media/dvb-frontends/af9013.c
@@ -23,6 +23,7 @@
 struct af9013_state {
 	struct i2c_client *client;
 	struct regmap *regmap;
+	struct i2c_mux_core *muxc;
 	struct dvb_frontend fe;
 	u32 clk;
 	u8 tuner;
@@ -1257,9 +1258,65 @@ static struct dvb_frontend *af9013_get_dvb_frontend(struct i2c_client *client)
 	return &state->fe;
 }
 
+static struct i2c_adapter *af9013_get_i2c_adapter(struct i2c_client *client)
+{
+	struct af9013_state *state = i2c_get_clientdata(client);
+
+	dev_dbg(&client->dev, "\n");
+
+	return state->muxc->adapter[0];
+}
+
+/*
+ * XXX: Hackish solution. We use virtual register, reg bit 16, to carry info
+ * about i2c adapter locking. Own locking is needed because i2c mux call has
+ * already locked i2c adapter.
+ */
+static int af9013_select(struct i2c_mux_core *muxc, u32 chan)
+{
+	struct af9013_state *state = i2c_mux_priv(muxc);
+	struct i2c_client *client = state->client;
+	int ret;
+
+	dev_dbg(&client->dev, "\n");
+
+	if (state->ts_mode == AF9013_TS_MODE_USB)
+		ret = regmap_update_bits(state->regmap, 0x1d417, 0x08, 0x08);
+	else
+		ret = regmap_update_bits(state->regmap, 0x1d607, 0x04, 0x04);
+	if (ret)
+		goto err;
+
+	return 0;
+err:
+	dev_dbg(&client->dev, "failed %d\n", ret);
+	return ret;
+}
+
+static int af9013_deselect(struct i2c_mux_core *muxc, u32 chan)
+{
+	struct af9013_state *state = i2c_mux_priv(muxc);
+	struct i2c_client *client = state->client;
+	int ret;
+
+	dev_dbg(&client->dev, "\n");
+
+	if (state->ts_mode == AF9013_TS_MODE_USB)
+		ret = regmap_update_bits(state->regmap, 0x1d417, 0x08, 0x00);
+	else
+		ret = regmap_update_bits(state->regmap, 0x1d607, 0x04, 0x00);
+	if (ret)
+		goto err;
+
+	return 0;
+err:
+	dev_dbg(&client->dev, "failed %d\n", ret);
+	return ret;
+}
+
 /* Own I2C access routines needed for regmap as chip uses extra command byte */
 static int af9013_wregs(struct i2c_client *client, u8 cmd, u16 reg,
-			const u8 *val, int len)
+			const u8 *val, int len, u8 lock)
 {
 	int ret;
 	u8 buf[21];
@@ -1281,7 +1338,12 @@ static int af9013_wregs(struct i2c_client *client, u8 cmd, u16 reg,
 	buf[1] = (reg >> 0) & 0xff;
 	buf[2] = cmd;
 	memcpy(&buf[3], val, len);
-	ret = i2c_transfer(client->adapter, msg, 1);
+
+	if (lock)
+		i2c_lock_adapter(client->adapter);
+	ret = __i2c_transfer(client->adapter, msg, 1);
+	if (lock)
+		i2c_unlock_adapter(client->adapter);
 	if (ret < 0) {
 		goto err;
 	} else if (ret != 1) {
@@ -1296,7 +1358,7 @@ static int af9013_wregs(struct i2c_client *client, u8 cmd, u16 reg,
 }
 
 static int af9013_rregs(struct i2c_client *client, u8 cmd, u16 reg,
-			u8 *val, int len)
+			u8 *val, int len, u8 lock)
 {
 	int ret;
 	u8 buf[3];
@@ -1317,7 +1379,12 @@ static int af9013_rregs(struct i2c_client *client, u8 cmd, u16 reg,
 	buf[0] = (reg >> 8) & 0xff;
 	buf[1] = (reg >> 0) & 0xff;
 	buf[2] = cmd;
-	ret = i2c_transfer(client->adapter, msg, 2);
+
+	if (lock)
+		i2c_lock_adapter(client->adapter);
+	ret = __i2c_transfer(client->adapter, msg, 2);
+	if (lock)
+		i2c_unlock_adapter(client->adapter);
 	if (ret < 0) {
 		goto err;
 	} else if (ret != 2) {
@@ -1337,25 +1404,27 @@ static int af9013_regmap_write(void *context, const void *data, size_t count)
 	struct af9013_state *state = i2c_get_clientdata(client);
 	int ret, i;
 	u8 cmd;
-	u16 reg = ((u8 *)data)[0] << 8|((u8 *)data)[1] << 0;
-	u8 *val = &((u8 *)data)[2];
-	const unsigned int len = count - 2;
+	u8 lock = !((u8 *)data)[0];
+	u16 reg = ((u8 *)data)[1] << 8 | ((u8 *)data)[2] << 0;
+	u8 *val = &((u8 *)data)[3];
+	const unsigned int len = count - 3;
 
 	if (state->ts_mode == AF9013_TS_MODE_USB && (reg & 0xff00) != 0xae00) {
 		cmd = 0 << 7|0 << 6|(len - 1) << 2|1 << 1|1 << 0;
-		ret = af9013_wregs(client, cmd, reg, val, len);
+		ret = af9013_wregs(client, cmd, reg, val, len, lock);
 		if (ret)
 			goto err;
 	} else if (reg >= 0x5100 && reg < 0x8fff) {
 		/* Firmware download */
 		cmd = 1 << 7|1 << 6|(len - 1) << 2|1 << 1|1 << 0;
-		ret = af9013_wregs(client, cmd, reg, val, len);
+		ret = af9013_wregs(client, cmd, reg, val, len, lock);
 		if (ret)
 			goto err;
 	} else {
 		cmd = 0 << 7|0 << 6|(1 - 1) << 2|1 << 1|1 << 0;
 		for (i = 0; i < len; i++) {
-			ret = af9013_wregs(client, cmd, reg + i, val + i, 1);
+			ret = af9013_wregs(client, cmd, reg + i, val + i, 1,
+					   lock);
 			if (ret)
 				goto err;
 		}
@@ -1374,19 +1443,21 @@ static int af9013_regmap_read(void *context, const void *reg_buf,
 	struct af9013_state *state = i2c_get_clientdata(client);
 	int ret, i;
 	u8 cmd;
-	u16 reg = ((u8 *)reg_buf)[0] << 8|((u8 *)reg_buf)[1] << 0;
+	u8 lock = !((u8 *)reg_buf)[0];
+	u16 reg = ((u8 *)reg_buf)[1] << 8 | ((u8 *)reg_buf)[2] << 0;
 	u8 *val = &((u8 *)val_buf)[0];
 	const unsigned int len = val_size;
 
 	if (state->ts_mode == AF9013_TS_MODE_USB && (reg & 0xff00) != 0xae00) {
 		cmd = 0 << 7|0 << 6|(len - 1) << 2|1 << 1|0 << 0;
-		ret = af9013_rregs(client, cmd, reg, val_buf, len);
+		ret = af9013_rregs(client, cmd, reg, val_buf, len, lock);
 		if (ret)
 			goto err;
 	} else {
 		cmd = 0 << 7|0 << 6|(1 - 1) << 2|1 << 1|0 << 0;
 		for (i = 0; i < len; i++) {
-			ret = af9013_rregs(client, cmd, reg + i, val + i, 1);
+			ret = af9013_rregs(client, cmd, reg + i, val + i, 1,
+					   lock);
 			if (ret)
 				goto err;
 		}
@@ -1411,8 +1482,9 @@ static int af9013_probe(struct i2c_client *client,
 		.write = af9013_regmap_write,
 	};
 	static const struct regmap_config regmap_config = {
-		.reg_bits    =  16,
-		.val_bits    =  8,
+		/* Actual reg is 16 bits, see i2c adapter lock */
+		.reg_bits = 24,
+		.val_bits = 8,
 	};
 
 	state = kzalloc(sizeof(*state), GFP_KERNEL);
@@ -1421,6 +1493,8 @@ static int af9013_probe(struct i2c_client *client,
 		goto err;
 	}
 
+	dev_dbg(&client->dev, "\n");
+
 	/* Setup the state */
 	state->client = client;
 	i2c_set_clientdata(client, state);
@@ -1438,25 +1512,36 @@ static int af9013_probe(struct i2c_client *client,
 		ret = PTR_ERR(state->regmap);
 		goto err_kfree;
 	}
+	/* Create mux i2c adapter */
+	state->muxc = i2c_mux_alloc(client->adapter, &client->dev, 1, 0, 0,
+				    af9013_select, af9013_deselect);
+	if (!state->muxc) {
+		ret = -ENOMEM;
+		goto err_regmap_exit;
+	}
+	state->muxc->priv = state;
+	ret = i2c_mux_add_adapter(state->muxc, 0, 0, 0);
+	if (ret)
+		goto err_regmap_exit;
 
 	/* Download firmware */
 	if (state->ts_mode != AF9013_TS_MODE_USB) {
 		ret = af9013_download_firmware(state);
 		if (ret)
-			goto err_regmap_exit;
+			goto err_i2c_mux_del_adapters;
 	}
 
 	/* Firmware version */
 	ret = regmap_bulk_read(state->regmap, 0x5103, firmware_version,
 			       sizeof(firmware_version));
 	if (ret)
-		goto err_regmap_exit;
+		goto err_i2c_mux_del_adapters;
 
 	/* Set GPIOs */
 	for (i = 0; i < sizeof(state->gpio); i++) {
 		ret = af9013_set_gpio(state, i, state->gpio[i]);
 		if (ret)
-			goto err_regmap_exit;
+			goto err_i2c_mux_del_adapters;
 	}
 
 	/* Create dvb frontend */
@@ -1467,6 +1552,7 @@ static int af9013_probe(struct i2c_client *client,
 
 	/* Setup callbacks */
 	pdata->get_dvb_frontend = af9013_get_dvb_frontend;
+	pdata->get_i2c_adapter = af9013_get_i2c_adapter;
 
 	/* Init stats to indicate which stats are supported */
 	c = &state->fe.dtv_property_cache;
@@ -1482,6 +1568,8 @@ static int af9013_probe(struct i2c_client *client,
 		 firmware_version[0], firmware_version[1],
 		 firmware_version[2], firmware_version[3]);
 	return 0;
+err_i2c_mux_del_adapters:
+	i2c_mux_del_adapters(state->muxc);
 err_regmap_exit:
 	regmap_exit(state->regmap);
 err_kfree:
@@ -1497,6 +1585,8 @@ static int af9013_remove(struct i2c_client *client)
 
 	dev_dbg(&client->dev, "\n");
 
+	i2c_mux_del_adapters(state->muxc);
+
 	regmap_exit(state->regmap);
 
 	kfree(state);
diff --git a/drivers/media/dvb-frontends/af9013.h b/drivers/media/dvb-frontends/af9013.h
index a290722c04fd..ea63ff9242f2 100644
--- a/drivers/media/dvb-frontends/af9013.h
+++ b/drivers/media/dvb-frontends/af9013.h
@@ -84,6 +84,7 @@ struct af9013_platform_data {
 	u8 gpio[4];
 
 	struct dvb_frontend* (*get_dvb_frontend)(struct i2c_client *);
+	struct i2c_adapter* (*get_i2c_adapter)(struct i2c_client *);
 
 /* private: For legacy media attach wrapper. Do not set value. */
 	bool attach_in_use;
diff --git a/drivers/media/dvb-frontends/af9013_priv.h b/drivers/media/dvb-frontends/af9013_priv.h
index ec74edbb6d4d..3e95de7dba51 100644
--- a/drivers/media/dvb-frontends/af9013_priv.h
+++ b/drivers/media/dvb-frontends/af9013_priv.h
@@ -25,6 +25,7 @@
 #include <media/dvb_math.h>
 #include "af9013.h"
 #include <linux/firmware.h>
+#include <linux/i2c-mux.h>
 #include <linux/math64.h>
 #include <linux/regmap.h>
 
-- 
2.14.3
