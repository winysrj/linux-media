Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44595 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751956AbdFODbf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Jun 2017 23:31:35 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 07/15] af9013: fix error handling
Date: Thu, 15 Jun 2017 06:30:57 +0300
Message-Id: <20170615033105.13517-7-crope@iki.fi>
In-Reply-To: <20170615033105.13517-1-crope@iki.fi>
References: <20170615033105.13517-1-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use typical (return 0/goto err/return err) error handling everywhere.
Add missing error handling where missing.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9013.c | 86 +++++++++++++++++++++---------------
 1 file changed, 51 insertions(+), 35 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9013.c b/drivers/media/dvb-frontends/af9013.c
index 70102c1..a6b88ae 100644
--- a/drivers/media/dvb-frontends/af9013.c
+++ b/drivers/media/dvb-frontends/af9013.c
@@ -94,7 +94,7 @@ static int af9013_set_gpio(struct af9013_state *state, u8 gpio, u8 gpioval)
 	if (ret)
 		goto err;
 
-	return ret;
+	return 0;
 err:
 	dev_dbg(&client->dev, "failed %d\n", ret);
 	return ret;
@@ -147,7 +147,7 @@ static int af9013_power_ctrl(struct af9013_state *state, u8 onoff)
 			goto err;
 	}
 
-	return ret;
+	return 0;
 err:
 	dev_dbg(&client->dev, "failed %d\n", ret);
 	return ret;
@@ -166,7 +166,7 @@ static int af9013_statistics_ber_unc_start(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	return ret;
+	return 0;
 err:
 	dev_dbg(&client->dev, "failed %d\n", ret);
 	return ret;
@@ -199,7 +199,7 @@ static int af9013_statistics_ber_unc_result(struct dvb_frontend *fe)
 	state->ber = (buf[2] << 16) | (buf[1] << 8) | buf[0];
 	state->ucblocks += (buf[4] << 8) | buf[3];
 
-	return ret;
+	return 0;
 err:
 	dev_dbg(&client->dev, "failed %d\n", ret);
 	return ret;
@@ -218,7 +218,7 @@ static int af9013_statistics_snr_start(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	return ret;
+	return 0;
 err:
 	dev_dbg(&client->dev, "failed %d\n", ret);
 	return ret;
@@ -283,7 +283,7 @@ static int af9013_statistics_snr_result(struct dvb_frontend *fe)
 	}
 	state->snr = utmp * 10; /* dB/10 */
 
-	return ret;
+	return 0;
 err:
 	dev_dbg(&client->dev, "failed %d\n", ret);
 	return ret;
@@ -321,7 +321,7 @@ static int af9013_statistics_signal_strength(struct dvb_frontend *fe)
 
 	state->signal_strength = signal_strength;
 
-	return ret;
+	return 0;
 err:
 	dev_dbg(&client->dev, "failed %d\n", ret);
 	return ret;
@@ -398,8 +398,11 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
 		c->frequency, c->bandwidth_hz);
 
 	/* program tuner */
-	if (fe->ops.tuner_ops.set_params)
-		fe->ops.tuner_ops.set_params(fe);
+	if (fe->ops.tuner_ops.set_params) {
+		ret = fe->ops.tuner_ops.set_params(fe);
+		if (ret)
+			goto err;
+	}
 
 	/* program CFOE coefficients */
 	if (c->bandwidth_hz != state->bandwidth_hz) {
@@ -411,20 +414,28 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
 		}
 
 		/* Return an error if can't find bandwidth or the right clock */
-		if (i == ARRAY_SIZE(coeff_lut))
-			return -EINVAL;
+		if (i == ARRAY_SIZE(coeff_lut)) {
+			ret = -EINVAL;
+			goto err;
+		}
 
 		ret = regmap_bulk_write(state->regmap, 0xae00, coeff_lut[i].val,
 					sizeof(coeff_lut[i].val));
+		if (ret)
+			goto err;
 	}
 
 	/* program frequency control */
 	if (c->bandwidth_hz != state->bandwidth_hz || state->first_tune) {
 		/* get used IF frequency */
-		if (fe->ops.tuner_ops.get_if_frequency)
-			fe->ops.tuner_ops.get_if_frequency(fe, &if_frequency);
-		else
+		if (fe->ops.tuner_ops.get_if_frequency) {
+			ret = fe->ops.tuner_ops.get_if_frequency(fe,
+								 &if_frequency);
+			if (ret)
+				goto err;
+		} else {
 			if_frequency = state->if_frequency;
+		}
 
 		dev_dbg(&client->dev, "if_frequency %u\n", if_frequency);
 
@@ -659,7 +670,7 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
 	state->set_frontend_jiffies = jiffies;
 	state->first_tune = false;
 
-	return ret;
+	return 0;
 err:
 	dev_dbg(&client->dev, "failed %d\n", ret);
 	return ret;
@@ -777,7 +788,7 @@ static int af9013_get_frontend(struct dvb_frontend *fe,
 		break;
 	}
 
-	return ret;
+	return 0;
 err:
 	dev_dbg(&client->dev, "failed %d\n", ret);
 	return ret;
@@ -828,7 +839,7 @@ static int af9013_read_status(struct dvb_frontend *fe, enum fe_status *status)
 	state->fe_status = *status;
 	state->read_status_jiffies = jiffies;
 
-	return ret;
+	return 0;
 err:
 	dev_dbg(&client->dev, "failed %d\n", ret);
 	return ret;
@@ -1087,7 +1098,7 @@ static int af9013_init(struct dvb_frontend *fe)
 	state->first_tune = true;
 	schedule_delayed_work(&state->statistics_work, msecs_to_jiffies(400));
 
-	return ret;
+	return 0;
 err:
 	dev_dbg(&client->dev, "failed %d\n", ret);
 	return ret;
@@ -1114,7 +1125,7 @@ static int af9013_sleep(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	return ret;
+	return 0;
 err:
 	dev_dbg(&client->dev, "failed %d\n", ret);
 	return ret;
@@ -1143,7 +1154,7 @@ static int af9013_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 
 	state->i2c_gate_state = enable;
 
-	return ret;
+	return 0;
 err:
 	dev_dbg(&client->dev, "failed %d\n", ret);
 	return ret;
@@ -1164,7 +1175,7 @@ static const struct dvb_frontend_ops af9013_ops;
 static int af9013_download_firmware(struct af9013_state *state)
 {
 	struct i2c_client *client = state->client;
-	int i, len, remaining, ret;
+	int ret, i, len, remaining;
 	unsigned int utmp;
 	const struct firmware *fw;
 	u16 checksum = 0;
@@ -1176,11 +1187,11 @@ static int af9013_download_firmware(struct af9013_state *state)
 	ret = regmap_read(state->regmap, 0x98be, &utmp);
 	if (ret)
 		goto err;
-	else
-		dev_dbg(&client->dev, "firmware status %02x\n", utmp);
+
+	dev_dbg(&client->dev, "firmware status %02x\n", utmp);
 
 	if (utmp == 0x0c) /* fw is running, no need for download */
-		goto exit;
+		return 0;
 
 	dev_info(&client->dev, "found a '%s' in cold state, will try to load a firmware\n",
 		 af9013_ops.info.name);
@@ -1210,7 +1221,7 @@ static int af9013_download_firmware(struct af9013_state *state)
 				sizeof(fw_params));
 
 	if (ret)
-		goto err_release;
+		goto err_release_firmware;
 
 	#define FW_ADDR 0x5100 /* firmware start address */
 	#define LEN_MAX 16 /* max packet size */
@@ -1225,39 +1236,44 @@ static int af9013_download_firmware(struct af9013_state *state)
 		if (ret) {
 			dev_err(&client->dev, "firmware download failed %d\n",
 				ret);
-			goto err_release;
+			goto err_release_firmware;
 		}
 	}
 
+	release_firmware(fw);
+
 	/* request boot firmware */
 	ret = regmap_write(state->regmap, 0xe205, 0x01);
 	if (ret)
-		goto err_release;
+		goto err;
 
 	/* Check firmware status. 0c=OK, 04=fail */
 	ret = regmap_read_poll_timeout(state->regmap, 0x98be, utmp,
 				       (utmp == 0x0c || utmp == 0x04),
 				       5000, 1000000);
 	if (ret)
-		goto err_release;
+		goto err;
 
 	dev_dbg(&client->dev, "firmware status %02x\n", utmp);
 
 	if (utmp == 0x04) {
-		dev_err(&client->dev, "firmware did not run\n");
 		ret = -ENODEV;
+		dev_err(&client->dev, "firmware did not run\n");
+		goto err;
 	} else if (utmp != 0x0c) {
-		dev_err(&client->dev, "firmware boot timeout\n");
 		ret = -ENODEV;
+		dev_err(&client->dev, "firmware boot timeout\n");
+		goto err;
 	}
 
-err_release:
+	dev_info(&client->dev, "found a '%s' in warm state\n",
+		 af9013_ops.info.name);
+
+	return 0;
+err_release_firmware:
 	release_firmware(fw);
 err:
-exit:
-	if (!ret)
-		dev_info(&client->dev, "found a '%s' in warm state\n",
-			 af9013_ops.info.name);
+	dev_dbg(&client->dev, "failed %d\n", ret);
 	return ret;
 }
 
-- 
http://palosaari.fi/
