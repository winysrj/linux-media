Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38376 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751980AbdFODbg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Jun 2017 23:31:36 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 11/15] af9013: add configurable TS output pin
Date: Thu, 15 Jun 2017 06:31:01 +0300
Message-Id: <20170615033105.13517-11-crope@iki.fi>
In-Reply-To: <20170615033105.13517-1-crope@iki.fi>
References: <20170615033105.13517-1-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On serial TS mode output pin could be selected from D0 or D7.
Add configuration option to for it.

Rename TS mode config option prefix from AF9013_TS_ to AF9013_TS_MODE_.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9013.c | 27 ++++++++++++++-------------
 drivers/media/dvb-frontends/af9013.h |  2 ++
 2 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9013.c b/drivers/media/dvb-frontends/af9013.c
index 68091f2..6b86437 100644
--- a/drivers/media/dvb-frontends/af9013.c
+++ b/drivers/media/dvb-frontends/af9013.c
@@ -28,6 +28,7 @@ struct af9013_state {
 	u8 tuner;
 	u32 if_frequency;
 	u8 ts_mode;
+	u8 ts_output_pin;
 	bool spec_inv;
 	u8 api_version[4];
 	u8 gpio[4];
@@ -955,17 +956,12 @@ static int af9013_init(struct dvb_frontend *fe)
 		goto err;
 
 	/* settings for mp2if */
-	if (state->ts_mode == AF9013_TS_USB) {
+	if (state->ts_mode == AF9013_TS_MODE_USB) {
 		/* AF9015 split PSB to 1.5k + 0.5k */
 		ret = regmap_update_bits(state->regmap, 0xd50b, 0x04, 0x04);
 		if (ret)
 			goto err;
 	} else {
-		/* AF9013 change the output bit to data7 */
-		ret = regmap_update_bits(state->regmap, 0xd500, 0x08, 0x08);
-		if (ret)
-			goto err;
-
 		/* AF9013 set mpeg to full speed */
 		ret = regmap_update_bits(state->regmap, 0xd502, 0x10, 0x10);
 		if (ret)
@@ -1046,9 +1042,12 @@ static int af9013_init(struct dvb_frontend *fe)
 			goto err;
 	}
 
-	/* TS mode */
-	ret = regmap_update_bits(state->regmap, 0xd500, 0x06,
-				 state->ts_mode << 1);
+	/* TS interface */
+	if (state->ts_output_pin == 7)
+		utmp = 1 << 3 | state->ts_mode << 1;
+	else
+		utmp = 0 << 3 | state->ts_mode << 1;
+	ret = regmap_update_bits(state->regmap, 0xd500, 0x0e, utmp);
 	if (ret)
 		goto err;
 
@@ -1147,7 +1146,7 @@ static int af9013_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 	if (state->i2c_gate_state == enable)
 		return 0;
 
-	if (state->ts_mode == AF9013_TS_USB)
+	if (state->ts_mode == AF9013_TS_MODE_USB)
 		ret = regmap_update_bits(state->regmap, 0xd417, 0x08,
 					 enable << 3);
 	else
@@ -1297,6 +1296,7 @@ struct dvb_frontend *af9013_attach(const struct af9013_config *config,
 	pdata.tuner = config->tuner;
 	pdata.if_frequency = config->if_frequency;
 	pdata.ts_mode = config->ts_mode;
+	pdata.ts_output_pin = 7;
 	pdata.spec_inv = config->spec_inv;
 	memcpy(&pdata.api_version, config->api_version, sizeof(pdata.api_version));
 	memcpy(&pdata.gpio, config->gpio, sizeof(pdata.gpio));
@@ -1450,7 +1450,7 @@ static int af9013_regmap_write(void *context, const void *data, size_t count)
 	u8 *val = &((u8 *)data)[2];
 	const unsigned int len = count - 2;
 
-	if (state->ts_mode == AF9013_TS_USB && (reg & 0xff00) != 0xae00) {
+	if (state->ts_mode == AF9013_TS_MODE_USB && (reg & 0xff00) != 0xae00) {
 		cmd = 0 << 7|0 << 6|(len - 1) << 2|1 << 1|1 << 0;
 		ret = af9013_wregs(client, cmd, reg, val, len);
 		if (ret)
@@ -1487,7 +1487,7 @@ static int af9013_regmap_read(void *context, const void *reg_buf,
 	u8 *val = &((u8 *)val_buf)[0];
 	const unsigned int len = val_size;
 
-	if (state->ts_mode == AF9013_TS_USB && (reg & 0xff00) != 0xae00) {
+	if (state->ts_mode == AF9013_TS_MODE_USB && (reg & 0xff00) != 0xae00) {
 		cmd = 0 << 7|0 << 6|(len - 1) << 2|1 << 1|0 << 0;
 		ret = af9013_rregs(client, cmd, reg, val_buf, len);
 		if (ret)
@@ -1537,6 +1537,7 @@ static int af9013_probe(struct i2c_client *client,
 	state->tuner = pdata->tuner;
 	state->if_frequency = pdata->if_frequency;
 	state->ts_mode = pdata->ts_mode;
+	state->ts_output_pin = pdata->ts_output_pin;
 	state->spec_inv = pdata->spec_inv;
 	memcpy(&state->api_version, pdata->api_version, sizeof(state->api_version));
 	memcpy(&state->gpio, pdata->gpio, sizeof(state->gpio));
@@ -1549,7 +1550,7 @@ static int af9013_probe(struct i2c_client *client,
 	}
 
 	/* Download firmware */
-	if (state->ts_mode != AF9013_TS_USB) {
+	if (state->ts_mode != AF9013_TS_MODE_USB) {
 		ret = af9013_download_firmware(state);
 		if (ret)
 			goto err_regmap_exit;
diff --git a/drivers/media/dvb-frontends/af9013.h b/drivers/media/dvb-frontends/af9013.h
index 3f18258..3532745 100644
--- a/drivers/media/dvb-frontends/af9013.h
+++ b/drivers/media/dvb-frontends/af9013.h
@@ -33,6 +33,7 @@
  * @tuner: Used tuner model.
  * @if_frequency: IF frequency.
  * @ts_mode: TS mode.
+ * @ts_output_pin: TS output pin.
  * @spec_inv: Input spectrum inverted.
  * @api_version: Firmware API version.
  * @gpio: GPIOs.
@@ -62,6 +63,7 @@ struct af9013_platform_data {
 #define AF9013_TS_MODE_PARALLEL  1
 #define AF9013_TS_MODE_SERIAL    2
 	u8 ts_mode;
+	u8 ts_output_pin;
 	bool spec_inv;
 	u8 api_version[4];
 #define AF9013_GPIO_ON (1 << 0)
-- 
http://palosaari.fi/
