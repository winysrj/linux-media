Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34791 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351AbbGIEHB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Jul 2015 00:07:01 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 12/12] tda10071: implement DVBv5 statistics
Date: Thu,  9 Jul 2015 07:06:32 +0300
Message-Id: <1436414792-9716-12-git-send-email-crope@iki.fi>
In-Reply-To: <1436414792-9716-1-git-send-email-crope@iki.fi>
References: <1436414792-9716-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement DVBv5 CNR, signal strength, BER and block errors.

Wrap legacy DVBv3 statistics to DVBv5 internally.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/tda10071.c      | 258 ++++++++++++++--------------
 drivers/media/dvb-frontends/tda10071_priv.h |   7 +-
 2 files changed, 135 insertions(+), 130 deletions(-)

diff --git a/drivers/media/dvb-frontends/tda10071.c b/drivers/media/dvb-frontends/tda10071.c
index c661b74..9f930cf 100644
--- a/drivers/media/dvb-frontends/tda10071.c
+++ b/drivers/media/dvb-frontends/tda10071.c
@@ -380,8 +380,11 @@ static int tda10071_read_status(struct dvb_frontend *fe, enum fe_status *status)
 {
 	struct tda10071_dev *dev = fe->demodulator_priv;
 	struct i2c_client *client = dev->client;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	struct tda10071_cmd cmd;
 	int ret;
 	unsigned int uitmp;
+	u8 buf[8];
 
 	*status = 0;
 
@@ -404,71 +407,105 @@ static int tda10071_read_status(struct dvb_frontend *fe, enum fe_status *status)
 
 	dev->fe_status = *status;
 
-	return ret;
-error:
-	dev_dbg(&client->dev, "failed=%d\n", ret);
-	return ret;
-}
+	/* signal strength */
+	if (dev->fe_status & FE_HAS_SIGNAL) {
+		cmd.args[0] = CMD_GET_AGCACC;
+		cmd.args[1] = 0;
+		cmd.len = 2;
+		ret = tda10071_cmd_execute(dev, &cmd);
+		if (ret)
+			goto error;
 
-static int tda10071_read_snr(struct dvb_frontend *fe, u16 *snr)
-{
-	struct tda10071_dev *dev = fe->demodulator_priv;
-	struct i2c_client *client = dev->client;
-	int ret;
-	u8 buf[2];
+		/* input power estimate dBm */
+		ret = regmap_read(dev->regmap, 0x50, &uitmp);
+		if (ret)
+			goto error;
 
-	if (!dev->warm || !(dev->fe_status & FE_HAS_LOCK)) {
-		*snr = 0;
-		ret = 0;
-		goto error;
+		c->strength.stat[0].scale = FE_SCALE_DECIBEL;
+		c->strength.stat[0].svalue = (int) (uitmp - 256) * 1000;
+	} else {
+		c->strength.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 	}
 
-	ret = regmap_bulk_read(dev->regmap, 0x3a, buf, 2);
-	if (ret)
-		goto error;
+	/* CNR */
+	if (dev->fe_status & FE_HAS_VITERBI) {
+		/* Es/No */
+		ret = regmap_bulk_read(dev->regmap, 0x3a, buf, 2);
+		if (ret)
+			goto error;
 
-	/* Es/No dBx10 */
-	*snr = buf[0] << 8 | buf[1];
+		c->cnr.stat[0].scale = FE_SCALE_DECIBEL;
+		c->cnr.stat[0].svalue = (buf[0] << 8 | buf[1] << 0) * 100;
+	} else {
+		c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	}
 
-	return ret;
-error:
-	dev_dbg(&client->dev, "failed=%d\n", ret);
-	return ret;
-}
+	/* UCB/PER/BER */
+	if (dev->fe_status & FE_HAS_LOCK) {
+		/* TODO: report total bits/packets */
+		u8 delivery_system, reg, len;
 
-static int tda10071_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
-{
-	struct tda10071_dev *dev = fe->demodulator_priv;
-	struct i2c_client *client = dev->client;
-	struct tda10071_cmd cmd;
-	int ret;
-	unsigned int uitmp;
+		switch (dev->delivery_system) {
+		case SYS_DVBS:
+			reg = 0x4c;
+			len = 8;
+			delivery_system = 1;
+			break;
+		case SYS_DVBS2:
+			reg = 0x4d;
+			len = 4;
+			delivery_system = 0;
+			break;
+		default:
+			ret = -EINVAL;
+			goto error;
+		}
 
-	if (!dev->warm || !(dev->fe_status & FE_HAS_LOCK)) {
-		*strength = 0;
-		ret = 0;
-		goto error;
-	}
+		ret = regmap_read(dev->regmap, reg, &uitmp);
+		if (ret)
+			goto error;
 
-	cmd.args[0] = CMD_GET_AGCACC;
-	cmd.args[1] = 0;
-	cmd.len = 2;
-	ret = tda10071_cmd_execute(dev, &cmd);
-	if (ret)
-		goto error;
+		if (dev->meas_count == uitmp) {
+			dev_dbg(&client->dev, "meas not ready=%02x\n", uitmp);
+			ret = 0;
+			goto error;
+		} else {
+			dev->meas_count = uitmp;
+		}
 
-	/* input power estimate dBm */
-	ret = regmap_read(dev->regmap, 0x50, &uitmp);
-	if (ret)
-		goto error;
+		cmd.args[0] = CMD_BER_UPDATE_COUNTERS;
+		cmd.args[1] = 0;
+		cmd.args[2] = delivery_system;
+		cmd.len = 3;
+		ret = tda10071_cmd_execute(dev, &cmd);
+		if (ret)
+			goto error;
 
-	if (uitmp < 181)
-		uitmp = 181; /* -75 dBm */
-	else if (uitmp > 236)
-		uitmp = 236; /* -20 dBm */
+		ret = regmap_bulk_read(dev->regmap, cmd.len, buf, len);
+		if (ret)
+			goto error;
 
-	/* scale value to 0x0000-0xffff */
-	*strength = (uitmp-181) * 0xffff / (236-181);
+		if (dev->delivery_system == SYS_DVBS) {
+			dev->dvbv3_ber = buf[0] << 24 | buf[1] << 16 |
+					 buf[2] << 8 | buf[3] << 0;
+			dev->post_bit_error += buf[0] << 24 | buf[1] << 16 |
+					       buf[2] << 8 | buf[3] << 0;
+			c->post_bit_error.stat[0].scale = FE_SCALE_COUNTER;
+			c->post_bit_error.stat[0].uvalue = dev->post_bit_error;
+			dev->block_error += buf[4] << 8 | buf[5] << 0;
+			c->block_error.stat[0].scale = FE_SCALE_COUNTER;
+			c->block_error.stat[0].uvalue = dev->block_error;
+		} else {
+			dev->dvbv3_ber = buf[0] << 8 | buf[1] << 0;
+			dev->post_bit_error += buf[0] << 8 | buf[1] << 0;
+			c->post_bit_error.stat[0].scale = FE_SCALE_COUNTER;
+			c->post_bit_error.stat[0].uvalue = dev->post_bit_error;
+			c->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		}
+	} else {
+		c->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		c->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	}
 
 	return ret;
 error:
@@ -476,94 +513,50 @@ error:
 	return ret;
 }
 
-static int tda10071_read_ber(struct dvb_frontend *fe, u32 *ber)
+static int tda10071_read_snr(struct dvb_frontend *fe, u16 *snr)
 {
-	struct tda10071_dev *dev = fe->demodulator_priv;
-	struct i2c_client *client = dev->client;
-	struct tda10071_cmd cmd;
-	int ret, i, len;
-	unsigned int uitmp;
-	u8 reg, buf[8];
-
-	if (!dev->warm || !(dev->fe_status & FE_HAS_LOCK)) {
-		*ber = dev->ber = 0;
-		ret = 0;
-		goto error;
-	}
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 
-	switch (dev->delivery_system) {
-	case SYS_DVBS:
-		reg = 0x4c;
-		len = 8;
-		i = 1;
-		break;
-	case SYS_DVBS2:
-		reg = 0x4d;
-		len = 4;
-		i = 0;
-		break;
-	default:
-		*ber = dev->ber = 0;
-		return 0;
-	}
+	if (c->cnr.stat[0].scale == FE_SCALE_DECIBEL)
+		*snr = div_s64(c->cnr.stat[0].svalue, 100);
+	else
+		*snr = 0;
+	return 0;
+}
 
-	ret = regmap_read(dev->regmap, reg, &uitmp);
-	if (ret)
-		goto error;
+static int tda10071_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
+{
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	unsigned int uitmp;
 
-	if (dev->meas_count[i] == uitmp) {
-		dev_dbg(&client->dev, "meas not ready=%02x\n", uitmp);
-		*ber = dev->ber;
-		return 0;
+	if (c->strength.stat[0].scale == FE_SCALE_DECIBEL) {
+		uitmp = c->strength.stat[0].svalue / 1000 + 256;
+		uitmp = clamp(uitmp, 181U, 236U); /* -75dBm - -20dBm */
+		/* scale value to 0x0000-0xffff */
+		*strength = (uitmp-181) * 0xffff / (236-181);
 	} else {
-		dev->meas_count[i] = uitmp;
+		*strength = 0;
 	}
+	return 0;
+}
 
-	cmd.args[0] = CMD_BER_UPDATE_COUNTERS;
-	cmd.args[1] = 0;
-	cmd.args[2] = i;
-	cmd.len = 3;
-	ret = tda10071_cmd_execute(dev, &cmd);
-	if (ret)
-		goto error;
-
-	ret = regmap_bulk_read(dev->regmap, cmd.len, buf, len);
-	if (ret)
-		goto error;
-
-	if (dev->delivery_system == SYS_DVBS) {
-		*ber = (buf[0] << 24) | (buf[1] << 16) | (buf[2] << 8) | buf[3];
-		dev->ucb += (buf[4] << 8) | buf[5];
-	} else {
-		*ber = (buf[0] << 8) | buf[1];
-	}
-	dev->ber = *ber;
+static int tda10071_read_ber(struct dvb_frontend *fe, u32 *ber)
+{
+	struct tda10071_dev *dev = fe->demodulator_priv;
 
-	return ret;
-error:
-	dev_dbg(&client->dev, "failed=%d\n", ret);
-	return ret;
+	*ber = dev->dvbv3_ber;
+	return 0;
 }
 
 static int tda10071_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 {
-	struct tda10071_dev *dev = fe->demodulator_priv;
-	struct i2c_client *client = dev->client;
-	int ret = 0;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 
-	if (!dev->warm || !(dev->fe_status & FE_HAS_LOCK)) {
+	if (c->block_error.stat[0].scale == FE_SCALE_COUNTER)
+		*ucblocks = c->block_error.stat[0].uvalue;
+	else
 		*ucblocks = 0;
-		goto error;
-	}
-
-	/* UCB is updated when BER is read. Assume BER is read anyway. */
-
-	*ucblocks = dev->ucb;
-
-	return ret;
-error:
-	dev_dbg(&client->dev, "failed=%d\n", ret);
-	return ret;
+	return 0;
 }
 
 static int tda10071_set_frontend(struct dvb_frontend *fe)
@@ -773,6 +766,7 @@ static int tda10071_init(struct dvb_frontend *fe)
 {
 	struct tda10071_dev *dev = fe->demodulator_priv;
 	struct i2c_client *client = dev->client;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct tda10071_cmd cmd;
 	int ret, i, len, remaining, fw_size;
 	unsigned int uitmp;
@@ -1038,6 +1032,16 @@ static int tda10071_init(struct dvb_frontend *fe)
 			goto error;
 	}
 
+	/* init stats here in order signal app which stats are supported */
+	c->strength.len = 1;
+	c->strength.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	c->cnr.len = 1;
+	c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	c->post_bit_error.len = 1;
+	c->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	c->block_error.len = 1;
+	c->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+
 	return ret;
 error_release_firmware:
 	release_firmware(fw);
diff --git a/drivers/media/dvb-frontends/tda10071_priv.h b/drivers/media/dvb-frontends/tda10071_priv.h
index cf5b433..b9c3601 100644
--- a/drivers/media/dvb-frontends/tda10071_priv.h
+++ b/drivers/media/dvb-frontends/tda10071_priv.h
@@ -38,12 +38,13 @@ struct tda10071_dev {
 	u8 pll_multiplier;
 	u8 tuner_i2c_addr;
 
-	u8 meas_count[2];
-	u32 ber;
-	u32 ucb;
+	u8 meas_count;
+	u32 dvbv3_ber;
 	enum fe_status fe_status;
 	enum fe_delivery_system delivery_system;
 	bool warm; /* FW running */
+	u64 post_bit_error;
+	u64 block_error;
 };
 
 static struct tda10071_modcod {
-- 
http://palosaari.fi/

