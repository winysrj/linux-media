Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([91.232.154.25]:43231 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932806AbeCMXkO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 19:40:14 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 10/18] af9013: remove all legacy media attach releated stuff
Date: Wed, 14 Mar 2018 01:39:36 +0200
Message-Id: <20180313233944.7234-10-crope@iki.fi>
In-Reply-To: <20180313233944.7234-1-crope@iki.fi>
References: <20180313233944.7234-1-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

No one is binding that driver through media attach so remove it and
all related dead code.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9013.c | 80 ------------------------------------
 drivers/media/dvb-frontends/af9013.h | 42 ++++---------------
 2 files changed, 7 insertions(+), 115 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9013.c b/drivers/media/dvb-frontends/af9013.c
index d55c5f67ce0f..15af3e9482df 100644
--- a/drivers/media/dvb-frontends/af9013.c
+++ b/drivers/media/dvb-frontends/af9013.c
@@ -48,7 +48,6 @@ struct af9013_state {
 	u32 dvbv3_ber;
 	u32 dvbv3_ucblocks;
 	bool first_tune;
-	bool i2c_gate_state;
 };
 
 static int af9013_set_gpio(struct af9013_state *state, u8 gpio, u8 gpioval)
@@ -1031,45 +1030,6 @@ static int af9013_sleep(struct dvb_frontend *fe)
 	return ret;
 }
 
-static int af9013_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
-{
-	int ret;
-	struct af9013_state *state = fe->demodulator_priv;
-	struct i2c_client *client = state->client;
-
-	dev_dbg(&client->dev, "enable %d\n", enable);
-
-	/* gate already open or close */
-	if (state->i2c_gate_state == enable)
-		return 0;
-
-	if (state->ts_mode == AF9013_TS_MODE_USB)
-		ret = regmap_update_bits(state->regmap, 0xd417, 0x08,
-					 enable << 3);
-	else
-		ret = regmap_update_bits(state->regmap, 0xd607, 0x04,
-					 enable << 2);
-	if (ret)
-		goto err;
-
-	state->i2c_gate_state = enable;
-
-	return 0;
-err:
-	dev_dbg(&client->dev, "failed %d\n", ret);
-	return ret;
-}
-
-static void af9013_release(struct dvb_frontend *fe)
-{
-	struct af9013_state *state = fe->demodulator_priv;
-	struct i2c_client *client = state->client;
-
-	dev_dbg(&client->dev, "\n");
-
-	i2c_unregister_device(client);
-}
-
 static const struct dvb_frontend_ops af9013_ops;
 
 static int af9013_download_firmware(struct af9013_state *state)
@@ -1172,40 +1132,6 @@ static int af9013_download_firmware(struct af9013_state *state)
 	return ret;
 }
 
-/*
- * XXX: That is wrapper to af9013_probe() via driver core in order to provide
- * proper I2C client for legacy media attach binding.
- * New users must use I2C client binding directly!
- */
-struct dvb_frontend *af9013_attach(const struct af9013_config *config,
-				   struct i2c_adapter *i2c)
-{
-	struct i2c_client *client;
-	struct i2c_board_info board_info;
-	struct af9013_platform_data pdata;
-
-	pdata.clk = config->clock;
-	pdata.tuner = config->tuner;
-	pdata.if_frequency = config->if_frequency;
-	pdata.ts_mode = config->ts_mode;
-	pdata.ts_output_pin = 7;
-	pdata.spec_inv = config->spec_inv;
-	memcpy(&pdata.api_version, config->api_version, sizeof(pdata.api_version));
-	memcpy(&pdata.gpio, config->gpio, sizeof(pdata.gpio));
-	pdata.attach_in_use = true;
-
-	memset(&board_info, 0, sizeof(board_info));
-	strlcpy(board_info.type, "af9013", sizeof(board_info.type));
-	board_info.addr = config->i2c_addr;
-	board_info.platform_data = &pdata;
-	client = i2c_new_device(i2c, &board_info);
-	if (!client || !client->dev.driver)
-		return NULL;
-
-	return pdata.get_dvb_frontend(client);
-}
-EXPORT_SYMBOL(af9013_attach);
-
 static const struct dvb_frontend_ops af9013_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
@@ -1231,8 +1157,6 @@ static const struct dvb_frontend_ops af9013_ops = {
 			FE_CAN_MUTE_TS
 	},
 
-	.release = af9013_release,
-
 	.init = af9013_init,
 	.sleep = af9013_sleep,
 
@@ -1245,8 +1169,6 @@ static const struct dvb_frontend_ops af9013_ops = {
 	.read_signal_strength = af9013_read_signal_strength,
 	.read_ber = af9013_read_ber,
 	.read_ucblocks = af9013_read_ucblocks,
-
-	.i2c_gate_ctrl = af9013_i2c_gate_ctrl,
 };
 
 static struct dvb_frontend *af9013_get_dvb_frontend(struct i2c_client *client)
@@ -1546,8 +1468,6 @@ static int af9013_probe(struct i2c_client *client,
 
 	/* Create dvb frontend */
 	memcpy(&state->fe.ops, &af9013_ops, sizeof(state->fe.ops));
-	if (!pdata->attach_in_use)
-		state->fe.ops.release = NULL;
 	state->fe.demodulator_priv = state;
 
 	/* Setup callbacks */
diff --git a/drivers/media/dvb-frontends/af9013.h b/drivers/media/dvb-frontends/af9013.h
index ea63ff9242f2..8144d4270b58 100644
--- a/drivers/media/dvb-frontends/af9013.h
+++ b/drivers/media/dvb-frontends/af9013.h
@@ -38,13 +38,6 @@
  * @api_version: Firmware API version.
  * @gpio: GPIOs.
  * @get_dvb_frontend: Get DVB frontend callback.
- *
- * AF9013/5 GPIOs (mostly guessed):
- *   * demod#1-gpio#0 - set demod#2 i2c-addr for dual devices
- *   * demod#1-gpio#1 - xtal setting (?)
- *   * demod#1-gpio#3 - tuner#1
- *   * demod#2-gpio#0 - tuner#2
- *   * demod#2-gpio#1 - xtal setting (?)
  */
 struct af9013_platform_data {
 	/*
@@ -85,36 +78,15 @@ struct af9013_platform_data {
 
 	struct dvb_frontend* (*get_dvb_frontend)(struct i2c_client *);
 	struct i2c_adapter* (*get_i2c_adapter)(struct i2c_client *);
-
-/* private: For legacy media attach wrapper. Do not set value. */
-	bool attach_in_use;
-	u8 i2c_addr;
-	u32 clock;
 };
 
-#define af9013_config       af9013_platform_data
-#define AF9013_TS_USB       AF9013_TS_MODE_USB
-#define AF9013_TS_PARALLEL  AF9013_TS_MODE_PARALLEL
-#define AF9013_TS_SERIAL    AF9013_TS_MODE_SERIAL
-
-#if IS_REACHABLE(CONFIG_DVB_AF9013)
-/**
- * Attach an af9013 demod
- *
- * @config: pointer to &struct af9013_config with demod configuration.
- * @i2c: i2c adapter to use.
- *
- * return: FE pointer on success, NULL on failure.
+/*
+ * AF9013/5 GPIOs (mostly guessed)
+ * demod#1-gpio#0 - set demod#2 i2c-addr for dual devices
+ * demod#1-gpio#1 - xtal setting (?)
+ * demod#1-gpio#3 - tuner#1
+ * demod#2-gpio#0 - tuner#2
+ * demod#2-gpio#1 - xtal setting (?)
  */
-extern struct dvb_frontend *af9013_attach(const struct af9013_config *config,
-	struct i2c_adapter *i2c);
-#else
-static inline struct dvb_frontend *af9013_attach(
-const struct af9013_config *config, struct i2c_adapter *i2c)
-{
-	pr_warn("%s: driver disabled by Kconfig\n", __func__);
-	return NULL;
-}
-#endif /* CONFIG_DVB_AF9013 */
 
 #endif /* AF9013_H */
-- 
2.14.3
