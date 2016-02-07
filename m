Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52198 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997AbcBGTzJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Feb 2016 14:55:09 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Benjamin Larsson <benjamin@southpole.se>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/4] mn88473: finalize driver
Date: Sun,  7 Feb 2016 21:54:48 +0200
Message-Id: <1454874890-10724-3-git-send-email-crope@iki.fi>
In-Reply-To: <1454874890-10724-1-git-send-email-crope@iki.fi>
References: <1454874890-10724-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Finalize the driver.
It still lacks a lot of features, like all statistics and PLP
filtering, but basic functionality and sensitivity is pretty good
shape.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/mn88473.c      | 388 ++++++++++++++++++-----------
 drivers/media/dvb-frontends/mn88473.h      |  14 +-
 drivers/media/dvb-frontends/mn88473_priv.h |   7 +-
 3 files changed, 246 insertions(+), 163 deletions(-)

diff --git a/drivers/media/dvb-frontends/mn88473.c b/drivers/media/dvb-frontends/mn88473.c
index a222e99..6c5d5921 100644
--- a/drivers/media/dvb-frontends/mn88473.c
+++ b/drivers/media/dvb-frontends/mn88473.c
@@ -29,21 +29,17 @@ static int mn88473_set_frontend(struct dvb_frontend *fe)
 	struct mn88473_dev *dev = i2c_get_clientdata(client);
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, i;
+	unsigned int uitmp;
 	u32 if_frequency;
-	u64 tmp;
-	u8 delivery_system_val, if_val[3], bw_val[7];
+	u8 delivery_system_val, if_val[3], *conf_val_ptr;
+	u8 reg_bank2_2d_val, reg_bank0_d2_val;
 
 	dev_dbg(&client->dev,
 		"delivery_system=%u modulation=%u frequency=%u bandwidth_hz=%u symbol_rate=%u inversion=%d stream_id=%d\n",
-		c->delivery_system,
-		c->modulation,
-		c->frequency,
-		c->bandwidth_hz,
-		c->symbol_rate,
-		c->inversion,
-		c->stream_id);
-
-	if (!dev->warm) {
+		c->delivery_system, c->modulation, c->frequency,
+		c->bandwidth_hz, c->symbol_rate, c->inversion, c->stream_id);
+
+	if (!dev->active) {
 		ret = -EAGAIN;
 		goto err;
 	}
@@ -51,30 +47,50 @@ static int mn88473_set_frontend(struct dvb_frontend *fe)
 	switch (c->delivery_system) {
 	case SYS_DVBT:
 		delivery_system_val = 0x02;
+		reg_bank2_2d_val = 0x23;
+		reg_bank0_d2_val = 0x2a;
 		break;
 	case SYS_DVBT2:
 		delivery_system_val = 0x03;
+		reg_bank2_2d_val = 0x3b;
+		reg_bank0_d2_val = 0x29;
 		break;
 	case SYS_DVBC_ANNEX_A:
 		delivery_system_val = 0x04;
+		reg_bank2_2d_val = 0x3b;
+		reg_bank0_d2_val = 0x29;
 		break;
 	default:
 		ret = -EINVAL;
 		goto err;
 	}
 
-	if (c->bandwidth_hz <= 6000000) {
-		memcpy(bw_val, "\xe9\x55\x55\x1c\x29\x1c\x29", 7);
-	} else if (c->bandwidth_hz <= 7000000) {
-		memcpy(bw_val, "\xc8\x00\x00\x17\x0a\x17\x0a", 7);
-	} else if (c->bandwidth_hz <= 8000000) {
-		memcpy(bw_val, "\xaf\x00\x00\x11\xec\x11\xec", 7);
-	} else {
-		ret = -EINVAL;
-		goto err;
+	switch (c->delivery_system) {
+	case SYS_DVBT:
+	case SYS_DVBT2:
+		switch (c->bandwidth_hz) {
+		case 6000000:
+			conf_val_ptr = "\xe9\x55\x55\x1c\x29\x1c\x29";
+			break;
+		case 7000000:
+			conf_val_ptr = "\xc8\x00\x00\x17\x0a\x17\x0a";
+			break;
+		case 8000000:
+			conf_val_ptr = "\xaf\x00\x00\x11\xec\x11\xec";
+			break;
+		default:
+			ret = -EINVAL;
+			goto err;
+		}
+		break;
+	case SYS_DVBC_ANNEX_A:
+		conf_val_ptr = "\x10\xab\x0d\xae\x1d\x9d";
+		break;
+	default:
+		break;
 	}
 
-	/* program tuner */
+	/* Program tuner */
 	if (fe->ops.tuner_ops.set_params) {
 		ret = fe->ops.tuner_ops.set_params(fe);
 		if (ret)
@@ -86,27 +102,45 @@ static int mn88473_set_frontend(struct dvb_frontend *fe)
 		if (ret)
 			goto err;
 
-		dev_dbg(&client->dev, "get_if_frequency=%d\n", if_frequency);
+		dev_dbg(&client->dev, "get_if_frequency=%u\n", if_frequency);
 	} else {
-		if_frequency = 0;
+		ret = -EINVAL;
+		goto err;
 	}
 
-	/* Calculate IF registers ( (1<<24)*IF / Xtal ) */
-	tmp =  div_u64(if_frequency * (u64)(1<<24) + (dev->xtal / 2),
-				   dev->xtal);
-	if_val[0] = ((tmp >> 16) & 0xff);
-	if_val[1] = ((tmp >>  8) & 0xff);
-	if_val[2] = ((tmp >>  0) & 0xff);
+	/* Calculate IF registers */
+	uitmp = DIV_ROUND_CLOSEST_ULL((u64) if_frequency * 0x1000000, dev->clk);
+	if_val[0] = (uitmp >> 16) & 0xff;
+	if_val[1] = (uitmp >>  8) & 0xff;
+	if_val[2] = (uitmp >>  0) & 0xff;
 
 	ret = regmap_write(dev->regmap[2], 0x05, 0x00);
+	if (ret)
+		goto err;
 	ret = regmap_write(dev->regmap[2], 0xfb, 0x13);
+	if (ret)
+		goto err;
 	ret = regmap_write(dev->regmap[2], 0xef, 0x13);
+	if (ret)
+		goto err;
 	ret = regmap_write(dev->regmap[2], 0xf9, 0x13);
+	if (ret)
+		goto err;
 	ret = regmap_write(dev->regmap[2], 0x00, 0x18);
+	if (ret)
+		goto err;
 	ret = regmap_write(dev->regmap[2], 0x01, 0x01);
+	if (ret)
+		goto err;
 	ret = regmap_write(dev->regmap[2], 0x02, 0x21);
+	if (ret)
+		goto err;
 	ret = regmap_write(dev->regmap[2], 0x03, delivery_system_val);
+	if (ret)
+		goto err;
 	ret = regmap_write(dev->regmap[2], 0x0b, 0x00);
+	if (ret)
+		goto err;
 
 	for (i = 0; i < sizeof(if_val); i++) {
 		ret = regmap_write(dev->regmap[2], 0x10 + i, if_val[i]);
@@ -114,52 +148,85 @@ static int mn88473_set_frontend(struct dvb_frontend *fe)
 			goto err;
 	}
 
-	for (i = 0; i < sizeof(bw_val); i++) {
-		ret = regmap_write(dev->regmap[2], 0x13 + i, bw_val[i]);
+	switch (c->delivery_system) {
+	case SYS_DVBT:
+	case SYS_DVBT2:
+		for (i = 0; i < 7; i++) {
+			ret = regmap_write(dev->regmap[2], 0x13 + i,
+					   conf_val_ptr[i]);
+			if (ret)
+				goto err;
+		}
+		break;
+	case SYS_DVBC_ANNEX_A:
+		ret = regmap_bulk_write(dev->regmap[1], 0x10, conf_val_ptr, 6);
 		if (ret)
 			goto err;
+		break;
+	default:
+		break;
 	}
 
-	ret = regmap_write(dev->regmap[2], 0x2d, 0x3b);
+	ret = regmap_write(dev->regmap[2], 0x2d, reg_bank2_2d_val);
+	if (ret)
+		goto err;
 	ret = regmap_write(dev->regmap[2], 0x2e, 0x00);
+	if (ret)
+		goto err;
 	ret = regmap_write(dev->regmap[2], 0x56, 0x0d);
-	ret = regmap_write(dev->regmap[0], 0x01, 0xba);
-	ret = regmap_write(dev->regmap[0], 0x02, 0x13);
-	ret = regmap_write(dev->regmap[0], 0x03, 0x80);
-	ret = regmap_write(dev->regmap[0], 0x04, 0xba);
-	ret = regmap_write(dev->regmap[0], 0x05, 0x91);
-	ret = regmap_write(dev->regmap[0], 0x07, 0xe7);
-	ret = regmap_write(dev->regmap[0], 0x08, 0x28);
+	if (ret)
+		goto err;
+	ret = regmap_bulk_write(dev->regmap[0], 0x01,
+				"\xba\x13\x80\xba\x91\xdd\xe7\x28", 8);
+	if (ret)
+		goto err;
 	ret = regmap_write(dev->regmap[0], 0x0a, 0x1a);
+	if (ret)
+		goto err;
 	ret = regmap_write(dev->regmap[0], 0x13, 0x1f);
+	if (ret)
+		goto err;
 	ret = regmap_write(dev->regmap[0], 0x19, 0x03);
+	if (ret)
+		goto err;
 	ret = regmap_write(dev->regmap[0], 0x1d, 0xb0);
+	if (ret)
+		goto err;
 	ret = regmap_write(dev->regmap[0], 0x2a, 0x72);
+	if (ret)
+		goto err;
 	ret = regmap_write(dev->regmap[0], 0x2d, 0x00);
+	if (ret)
+		goto err;
 	ret = regmap_write(dev->regmap[0], 0x3c, 0x00);
+	if (ret)
+		goto err;
 	ret = regmap_write(dev->regmap[0], 0x3f, 0xf8);
-	ret = regmap_write(dev->regmap[0], 0x40, 0xf4);
-	ret = regmap_write(dev->regmap[0], 0x41, 0x08);
-	ret = regmap_write(dev->regmap[0], 0xd2, 0x29);
+	if (ret)
+		goto err;
+	ret = regmap_bulk_write(dev->regmap[0], 0x40, "\xf4\x08", 2);
+	if (ret)
+		goto err;
+	ret = regmap_write(dev->regmap[0], 0xd2, reg_bank0_d2_val);
+	if (ret)
+		goto err;
 	ret = regmap_write(dev->regmap[0], 0xd4, 0x55);
-	ret = regmap_write(dev->regmap[1], 0x10, 0x10);
-	ret = regmap_write(dev->regmap[1], 0x11, 0xab);
-	ret = regmap_write(dev->regmap[1], 0x12, 0x0d);
-	ret = regmap_write(dev->regmap[1], 0x13, 0xae);
-	ret = regmap_write(dev->regmap[1], 0x14, 0x1d);
-	ret = regmap_write(dev->regmap[1], 0x15, 0x9d);
+	if (ret)
+		goto err;
 	ret = regmap_write(dev->regmap[1], 0xbe, 0x08);
-	ret = regmap_write(dev->regmap[2], 0x09, 0x08);
-	ret = regmap_write(dev->regmap[2], 0x08, 0x1d);
+	if (ret)
+		goto err;
 	ret = regmap_write(dev->regmap[0], 0xb2, 0x37);
+	if (ret)
+		goto err;
 	ret = regmap_write(dev->regmap[0], 0xd7, 0x04);
-	ret = regmap_write(dev->regmap[2], 0x32, 0x80);
-	ret = regmap_write(dev->regmap[2], 0x36, 0x00);
-	ret = regmap_write(dev->regmap[2], 0xf8, 0x9f);
 	if (ret)
 		goto err;
 
-	dev->delivery_system = c->delivery_system;
+	/* Reset FSM */
+	ret = regmap_write(dev->regmap[2], 0xf8, 0x9f);
+	if (ret)
+		goto err;
 
 	return 0;
 err:
@@ -173,51 +240,61 @@ static int mn88473_read_status(struct dvb_frontend *fe, enum fe_status *status)
 	struct mn88473_dev *dev = i2c_get_clientdata(client);
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
-	unsigned int utmp;
-	int lock = 0;
-
-	*status = 0;
+	unsigned int uitmp;
 
-	if (!dev->warm) {
+	if (!dev->active) {
 		ret = -EAGAIN;
 		goto err;
 	}
 
+	*status = 0;
+
 	switch (c->delivery_system) {
 	case SYS_DVBT:
-		ret = regmap_read(dev->regmap[0], 0x62, &utmp);
+		ret = regmap_read(dev->regmap[0], 0x62, &uitmp);
 		if (ret)
 			goto err;
-		if (!(utmp & 0xA0)) {
-			if ((utmp & 0xF) >= 0x03)
-				*status |= FE_HAS_SIGNAL;
-			if ((utmp & 0xF) >= 0x09)
-				lock = 1;
+
+		if (!(uitmp & 0xa0)) {
+			if ((uitmp & 0x0f) >= 0x09)
+				*status = FE_HAS_SIGNAL | FE_HAS_CARRIER |
+					  FE_HAS_VITERBI | FE_HAS_SYNC |
+					  FE_HAS_LOCK;
+			else if ((uitmp & 0x0f) >= 0x03)
+				*status = FE_HAS_SIGNAL | FE_HAS_CARRIER;
 		}
 		break;
 	case SYS_DVBT2:
-		ret = regmap_read(dev->regmap[2], 0x8B, &utmp);
+		ret = regmap_read(dev->regmap[2], 0x8b, &uitmp);
 		if (ret)
 			goto err;
-		if (!(utmp & 0x40)) {
-			if ((utmp & 0xF) >= 0x07)
-				*status |= FE_HAS_SIGNAL;
-			if ((utmp & 0xF) >= 0x0a)
-				*status |= FE_HAS_CARRIER;
-			if ((utmp & 0xF) >= 0x0d)
-				*status |= FE_HAS_VITERBI | FE_HAS_SYNC | FE_HAS_LOCK;
+
+		if (!(uitmp & 0x40)) {
+			if ((uitmp & 0x0f) >= 0x0d)
+				*status = FE_HAS_SIGNAL | FE_HAS_CARRIER |
+					  FE_HAS_VITERBI | FE_HAS_SYNC |
+					  FE_HAS_LOCK;
+			else if ((uitmp & 0x0f) >= 0x0a)
+				*status = FE_HAS_SIGNAL | FE_HAS_CARRIER |
+					  FE_HAS_VITERBI;
+			else if ((uitmp & 0x0f) >= 0x07)
+				*status = FE_HAS_SIGNAL | FE_HAS_CARRIER;
 		}
 		break;
 	case SYS_DVBC_ANNEX_A:
-		ret = regmap_read(dev->regmap[1], 0x85, &utmp);
+		ret = regmap_read(dev->regmap[1], 0x85, &uitmp);
 		if (ret)
 			goto err;
-		if (!(utmp & 0x40)) {
-			ret = regmap_read(dev->regmap[1], 0x89, &utmp);
+
+		if (!(uitmp & 0x40)) {
+			ret = regmap_read(dev->regmap[1], 0x89, &uitmp);
 			if (ret)
 				goto err;
-			if (utmp & 0x01)
-				lock = 1;
+
+			if (uitmp & 0x01)
+				*status = FE_HAS_SIGNAL | FE_HAS_CARRIER |
+					  FE_HAS_VITERBI | FE_HAS_SYNC |
+					  FE_HAS_LOCK;
 		}
 		break;
 	default:
@@ -225,10 +302,6 @@ static int mn88473_read_status(struct dvb_frontend *fe, enum fe_status *status)
 		goto err;
 	}
 
-	if (lock)
-		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_VITERBI |
-				FE_HAS_SYNC | FE_HAS_LOCK;
-
 	return 0;
 err:
 	dev_dbg(&client->dev, "failed=%d\n", ret);
@@ -239,85 +312,76 @@ static int mn88473_init(struct dvb_frontend *fe)
 {
 	struct i2c_client *client = fe->demodulator_priv;
 	struct mn88473_dev *dev = i2c_get_clientdata(client);
-	int ret, len, remaining;
-	const struct firmware *fw = NULL;
-	u8 *fw_file = MN88473_FIRMWARE;
-	unsigned int tmp;
+	int ret, len, remain;
+	unsigned int uitmp;
+	const struct firmware *fw;
+	const char *name = MN88473_FIRMWARE;
 
 	dev_dbg(&client->dev, "\n");
 
-	/* set cold state by default */
-	dev->warm = false;
-
-	/* check if firmware is already running */
-	ret = regmap_read(dev->regmap[0], 0xf5, &tmp);
+	/* Check if firmware is already running */
+	ret = regmap_read(dev->regmap[0], 0xf5, &uitmp);
 	if (ret)
 		goto err;
 
-	if (!(tmp & 0x1)) {
-		dev_info(&client->dev, "firmware already running\n");
-		dev->warm = true;
-		return 0;
-	}
+	if (!(uitmp & 0x01))
+		goto warm;
 
-	/* request the firmware, this will block and timeout */
-	ret = request_firmware(&fw, fw_file, &client->dev);
+	/* Request the firmware, this will block and timeout */
+	ret = request_firmware(&fw, name, &client->dev);
 	if (ret) {
-		dev_err(&client->dev, "firmare file '%s' not found\n", fw_file);
-		goto err_request_firmware;
+		dev_err(&client->dev, "firmare file '%s' not found\n", name);
+		goto err;
 	}
 
-	dev_info(&client->dev, "downloading firmware from file '%s'\n",
-		 fw_file);
+	dev_info(&client->dev, "downloading firmware from file '%s'\n", name);
 
 	ret = regmap_write(dev->regmap[0], 0xf5, 0x03);
 	if (ret)
-		goto err;
-
-	for (remaining = fw->size; remaining > 0;
-			remaining -= (dev->i2c_wr_max - 1)) {
-		len = remaining;
-		if (len > (dev->i2c_wr_max - 1))
-			len = dev->i2c_wr_max - 1;
+		goto err_release_firmware;
 
+	for (remain = fw->size; remain > 0; remain -= (dev->i2c_wr_max - 1)) {
+		len = min(dev->i2c_wr_max - 1, remain);
 		ret = regmap_bulk_write(dev->regmap[0], 0xf6,
-					&fw->data[fw->size - remaining], len);
+					&fw->data[fw->size - remain], len);
 		if (ret) {
-			dev_err(&client->dev, "firmware download failed=%d\n",
+			dev_err(&client->dev, "firmware download failed %d\n",
 				ret);
-			goto err;
+			goto err_release_firmware;
 		}
 	}
 
-	/* parity check of firmware */
-	ret = regmap_read(dev->regmap[0], 0xf8, &tmp);
-	if (ret) {
-		dev_err(&client->dev,
-				"parity reg read failed=%d\n", ret);
+	release_firmware(fw);
+
+	/* Parity check of firmware */
+	ret = regmap_read(dev->regmap[0], 0xf8, &uitmp);
+	if (ret)
 		goto err;
-	}
-	if (tmp & 0x10) {
-		dev_err(&client->dev,
-				"firmware parity check failed=0x%x\n", tmp);
+
+	if (uitmp & 0x10) {
+		dev_err(&client->dev, "firmware parity check failed\n");
+		ret = -EINVAL;
 		goto err;
 	}
-	dev_err(&client->dev, "firmware parity check succeeded=0x%x\n", tmp);
 
 	ret = regmap_write(dev->regmap[0], 0xf5, 0x00);
 	if (ret)
 		goto err;
+warm:
+	/* TS config */
+	ret = regmap_write(dev->regmap[2], 0x09, 0x08);
+	if (ret)
+		goto err;
+	ret = regmap_write(dev->regmap[2], 0x08, 0x1d);
+	if (ret)
+		goto err;
 
-	release_firmware(fw);
-	fw = NULL;
-
-	/* warm state */
-	dev->warm = true;
+	dev->active = true;
 
 	return 0;
-
-err:
+err_release_firmware:
 	release_firmware(fw);
-err_request_firmware:
+err:
 	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
@@ -330,20 +394,20 @@ static int mn88473_sleep(struct dvb_frontend *fe)
 
 	dev_dbg(&client->dev, "\n");
 
+	dev->active = false;
+
 	ret = regmap_write(dev->regmap[2], 0x05, 0x3e);
 	if (ret)
 		goto err;
 
-	dev->delivery_system = SYS_UNDEFINED;
-
 	return 0;
 err:
 	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
-static struct dvb_frontend_ops mn88473_ops = {
-	.delsys = {SYS_DVBT, SYS_DVBT2, SYS_DVBC_ANNEX_AC},
+static const struct dvb_frontend_ops mn88473_ops = {
+	.delsys = {SYS_DVBT, SYS_DVBT2, SYS_DVBC_ANNEX_A},
 	.info = {
 		.name = "Panasonic MN88473",
 		.symbol_rate_min = 1000000,
@@ -365,8 +429,7 @@ static struct dvb_frontend_ops mn88473_ops = {
 			FE_CAN_GUARD_INTERVAL_AUTO     |
 			FE_CAN_HIERARCHY_AUTO          |
 			FE_CAN_MUTE_TS                 |
-			FE_CAN_2G_MODULATION           |
-			FE_CAN_MULTISTREAM
+			FE_CAN_2G_MODULATION
 	},
 
 	.get_tune_settings = mn88473_get_tune_settings,
@@ -385,7 +448,7 @@ static int mn88473_probe(struct i2c_client *client,
 	struct mn88473_config *config = client->dev.platform_data;
 	struct mn88473_dev *dev;
 	int ret;
-	unsigned int utmp;
+	unsigned int uitmp;
 	static const struct regmap_config regmap_config = {
 		.reg_bits = 8,
 		.val_bits = 8,
@@ -393,7 +456,7 @@ static int mn88473_probe(struct i2c_client *client,
 
 	dev_dbg(&client->dev, "\n");
 
-	/* Caller really need to provide pointer for frontend we create. */
+	/* Caller really need to provide pointer for frontend we create */
 	if (config->fe == NULL) {
 		dev_err(&client->dev, "frontend pointer not defined\n");
 		ret = -EINVAL;
@@ -406,11 +469,15 @@ static int mn88473_probe(struct i2c_client *client,
 		goto err;
 	}
 
-	dev->i2c_wr_max = config->i2c_wr_max;
-	if (!config->xtal)
-		dev->xtal = 25000000;
+	if (config->i2c_wr_max)
+		dev->i2c_wr_max = config->i2c_wr_max;
 	else
-		dev->xtal = config->xtal;
+		dev->i2c_wr_max = ~0;
+
+	if (config->xtal)
+		dev->clk = config->xtal;
+	else
+		dev->clk = 25000000;
 	dev->client[0] = client;
 	dev->regmap[0] = regmap_init_i2c(dev->client[0], &regmap_config);
 	if (IS_ERR(dev->regmap[0])) {
@@ -418,15 +485,25 @@ static int mn88473_probe(struct i2c_client *client,
 		goto err_kfree;
 	}
 
-	/* check demod answers to I2C */
-	ret = regmap_read(dev->regmap[0], 0x00, &utmp);
+	/* Check demod answers with correct chip id */
+	ret = regmap_read(dev->regmap[0], 0xff, &uitmp);
 	if (ret)
 		goto err_regmap_0_regmap_exit;
 
+	dev_dbg(&client->dev, "chip id=%02x\n", uitmp);
+
+	if (uitmp != 0x03) {
+		ret = -ENODEV;
+		goto err_regmap_0_regmap_exit;
+	}
+
 	/*
-	 * Chip has three I2C addresses for different register pages. Used
+	 * Chip has three I2C addresses for different register banks. Used
 	 * addresses are 0x18, 0x1a and 0x1c. We register two dummy clients,
-	 * 0x1a and 0x1c, in order to get own I2C client for each register page.
+	 * 0x1a and 0x1c, in order to get own I2C client for each register bank.
+	 *
+	 * Also, register bank 2 do not support sequential I/O. Only single
+	 * register write or read is allowed to that bank.
 	 */
 	dev->client[1] = i2c_new_dummy(client->adapter, 0x1a);
 	if (dev->client[1] == NULL) {
@@ -456,13 +533,19 @@ static int mn88473_probe(struct i2c_client *client,
 	}
 	i2c_set_clientdata(dev->client[2], dev);
 
-	/* create dvb_frontend */
-	memcpy(&dev->fe.ops, &mn88473_ops, sizeof(struct dvb_frontend_ops));
-	dev->fe.demodulator_priv = client;
-	*config->fe = &dev->fe;
+	/* Sleep because chip is active by default */
+	ret = regmap_write(dev->regmap[2], 0x05, 0x3e);
+	if (ret)
+		goto err_client_2_i2c_unregister_device;
+
+	/* Create dvb frontend */
+	memcpy(&dev->frontend.ops, &mn88473_ops, sizeof(dev->frontend.ops));
+	dev->frontend.demodulator_priv = client;
+	*config->fe = &dev->frontend;
 	i2c_set_clientdata(client, dev);
 
-	dev_info(&dev->client[0]->dev, "Panasonic MN88473 successfully attached\n");
+	dev_info(&client->dev, "Panasonic MN88473 successfully identified\n");
+
 	return 0;
 
 err_client_2_i2c_unregister_device:
@@ -507,7 +590,8 @@ MODULE_DEVICE_TABLE(i2c, mn88473_id_table);
 
 static struct i2c_driver mn88473_driver = {
 	.driver = {
-		.name	= "mn88473",
+		.name	             = "mn88473",
+		.suppress_bind_attrs = true,
 	},
 	.probe		= mn88473_probe,
 	.remove		= mn88473_remove,
diff --git a/drivers/media/dvb-frontends/mn88473.h b/drivers/media/dvb-frontends/mn88473.h
index c717ebed..2aa5181 100644
--- a/drivers/media/dvb-frontends/mn88473.h
+++ b/drivers/media/dvb-frontends/mn88473.h
@@ -22,10 +22,16 @@
 struct mn88473_config {
 	/*
 	 * Max num of bytes given I2C adapter could write at once.
-	 * Default: none
+	 * Default: unlimited
 	 */
 	u16 i2c_wr_max;
 
+	/*
+	 * Xtal frequency Hz.
+	 * Default: 25000000
+	 */
+	u32 xtal;
+
 
 	/* Everything after that is returned by the driver. */
 
@@ -33,12 +39,6 @@ struct mn88473_config {
 	 * DVB frontend.
 	 */
 	struct dvb_frontend **fe;
-
-	/*
-	 * Xtal frequency.
-	 * Hz
-	 */
-	u32 xtal;
 };
 
 #endif
diff --git a/drivers/media/dvb-frontends/mn88473_priv.h b/drivers/media/dvb-frontends/mn88473_priv.h
index 54beb42..e6c6589 100644
--- a/drivers/media/dvb-frontends/mn88473_priv.h
+++ b/drivers/media/dvb-frontends/mn88473_priv.h
@@ -27,11 +27,10 @@
 struct mn88473_dev {
 	struct i2c_client *client[3];
 	struct regmap *regmap[3];
-	struct dvb_frontend fe;
+	struct dvb_frontend frontend;
 	u16 i2c_wr_max;
-	enum fe_delivery_system delivery_system;
-	bool warm; /* FW running */
-	u32 xtal;
+	bool active;
+	u32 clk;
 };
 
 #endif
-- 
http://palosaari.fi/

