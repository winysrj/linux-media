Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38746 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480AbaHDE3t (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Aug 2014 00:29:49 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 7/9] tda18212: rename state from 'priv' to 's'
Date: Mon,  4 Aug 2014 07:29:29 +0300
Message-Id: <1407126571-21629-7-git-send-email-crope@iki.fi>
In-Reply-To: <1407126571-21629-1-git-send-email-crope@iki.fi>
References: <1407126571-21629-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rename driver state pointer to 's' through whole driver, just
because I like use shortest possible name for such common struct
used everywhere in the driver.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/tda18212.c | 104 ++++++++++++++++++++--------------------
 1 file changed, 51 insertions(+), 53 deletions(-)

diff --git a/drivers/media/tuners/tda18212.c b/drivers/media/tuners/tda18212.c
index 5d1d785..95a5ebf 100644
--- a/drivers/media/tuners/tda18212.c
+++ b/drivers/media/tuners/tda18212.c
@@ -23,7 +23,7 @@
 /* Max transfer size done by I2C transfer functions */
 #define MAX_XFER_SIZE  64
 
-struct tda18212_priv {
+struct tda18212 {
 	struct tda18212_config cfg;
 	struct i2c_client *client;
 
@@ -31,14 +31,13 @@ struct tda18212_priv {
 };
 
 /* write multiple registers */
-static int tda18212_wr_regs(struct tda18212_priv *priv, u8 reg, u8 *val,
-	int len)
+static int tda18212_wr_regs(struct tda18212 *s, u8 reg, u8 *val, int len)
 {
 	int ret;
 	u8 buf[MAX_XFER_SIZE];
 	struct i2c_msg msg[1] = {
 		{
-			.addr = priv->client->addr,
+			.addr = s->client->addr,
 			.flags = 0,
 			.len = 1 + len,
 			.buf = buf,
@@ -46,7 +45,7 @@ static int tda18212_wr_regs(struct tda18212_priv *priv, u8 reg, u8 *val,
 	};
 
 	if (1 + len > sizeof(buf)) {
-		dev_warn(&priv->client->dev,
+		dev_warn(&s->client->dev,
 				"i2c wr reg=%04x: len=%d is too big!\n",
 				reg, len);
 		return -EINVAL;
@@ -55,11 +54,11 @@ static int tda18212_wr_regs(struct tda18212_priv *priv, u8 reg, u8 *val,
 	buf[0] = reg;
 	memcpy(&buf[1], val, len);
 
-	ret = i2c_transfer(priv->client->adapter, msg, 1);
+	ret = i2c_transfer(s->client->adapter, msg, 1);
 	if (ret == 1) {
 		ret = 0;
 	} else {
-		dev_warn(&priv->client->dev,
+		dev_warn(&s->client->dev,
 				"i2c wr failed=%d reg=%02x len=%d\n",
 				ret, reg, len);
 		ret = -EREMOTEIO;
@@ -68,19 +67,18 @@ static int tda18212_wr_regs(struct tda18212_priv *priv, u8 reg, u8 *val,
 }
 
 /* read multiple registers */
-static int tda18212_rd_regs(struct tda18212_priv *priv, u8 reg, u8 *val,
-	int len)
+static int tda18212_rd_regs(struct tda18212 *s, u8 reg, u8 *val, int len)
 {
 	int ret;
 	u8 buf[MAX_XFER_SIZE];
 	struct i2c_msg msg[2] = {
 		{
-			.addr = priv->client->addr,
+			.addr = s->client->addr,
 			.flags = 0,
 			.len = 1,
 			.buf = &reg,
 		}, {
-			.addr = priv->client->addr,
+			.addr = s->client->addr,
 			.flags = I2C_M_RD,
 			.len = len,
 			.buf = buf,
@@ -88,18 +86,18 @@ static int tda18212_rd_regs(struct tda18212_priv *priv, u8 reg, u8 *val,
 	};
 
 	if (len > sizeof(buf)) {
-		dev_warn(&priv->client->dev,
+		dev_warn(&s->client->dev,
 				"i2c rd reg=%04x: len=%d is too big!\n",
 				reg, len);
 		return -EINVAL;
 	}
 
-	ret = i2c_transfer(priv->client->adapter, msg, 2);
+	ret = i2c_transfer(s->client->adapter, msg, 2);
 	if (ret == 2) {
 		memcpy(val, buf, len);
 		ret = 0;
 	} else {
-		dev_warn(&priv->client->dev,
+		dev_warn(&s->client->dev,
 				"i2c rd failed=%d reg=%02x len=%d\n",
 				ret, reg, len);
 		ret = -EREMOTEIO;
@@ -109,26 +107,26 @@ static int tda18212_rd_regs(struct tda18212_priv *priv, u8 reg, u8 *val,
 }
 
 /* write single register */
-static int tda18212_wr_reg(struct tda18212_priv *priv, u8 reg, u8 val)
+static int tda18212_wr_reg(struct tda18212 *s, u8 reg, u8 val)
 {
-	return tda18212_wr_regs(priv, reg, &val, 1);
+	return tda18212_wr_regs(s, reg, &val, 1);
 }
 
 /* read single register */
-static int tda18212_rd_reg(struct tda18212_priv *priv, u8 reg, u8 *val)
+static int tda18212_rd_reg(struct tda18212 *s, u8 reg, u8 *val)
 {
-	return tda18212_rd_regs(priv, reg, val, 1);
+	return tda18212_rd_regs(s, reg, val, 1);
 }
 
 #if 0 /* keep, useful when developing driver */
-static void tda18212_dump_regs(struct tda18212_priv *priv)
+static void tda18212_dump_regs(struct tda18212 *s)
 {
 	int i;
 	u8 buf[256];
 
 	#define TDA18212_RD_LEN 32
 	for (i = 0; i < sizeof(buf); i += TDA18212_RD_LEN)
-		tda18212_rd_regs(priv, i, &buf[i], TDA18212_RD_LEN);
+		tda18212_rd_regs(s, i, &buf[i], TDA18212_RD_LEN);
 
 	print_hex_dump(KERN_INFO, "", DUMP_PREFIX_OFFSET, 32, 1, buf,
 		sizeof(buf), true);
@@ -139,7 +137,7 @@ static void tda18212_dump_regs(struct tda18212_priv *priv)
 
 static int tda18212_set_params(struct dvb_frontend *fe)
 {
-	struct tda18212_priv *priv = fe->tuner_priv;
+	struct tda18212 *s = fe->tuner_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, i;
 	u32 if_khz;
@@ -168,7 +166,7 @@ static int tda18212_set_params(struct dvb_frontend *fe)
 		[ATSC_QAM] = { 0x7d, 0x20, 0x63 },
 	};
 
-	dev_dbg(&priv->client->dev,
+	dev_dbg(&s->client->dev,
 			"delivery_system=%d frequency=%d bandwidth_hz=%d\n",
 			c->delivery_system, c->frequency,
 			c->bandwidth_hz);
@@ -178,25 +176,25 @@ static int tda18212_set_params(struct dvb_frontend *fe)
 
 	switch (c->delivery_system) {
 	case SYS_ATSC:
-		if_khz = priv->cfg.if_atsc_vsb;
+		if_khz = s->cfg.if_atsc_vsb;
 		i = ATSC_VSB;
 		break;
 	case SYS_DVBC_ANNEX_B:
-		if_khz = priv->cfg.if_atsc_qam;
+		if_khz = s->cfg.if_atsc_qam;
 		i = ATSC_QAM;
 		break;
 	case SYS_DVBT:
 		switch (c->bandwidth_hz) {
 		case 6000000:
-			if_khz = priv->cfg.if_dvbt_6;
+			if_khz = s->cfg.if_dvbt_6;
 			i = DVBT_6;
 			break;
 		case 7000000:
-			if_khz = priv->cfg.if_dvbt_7;
+			if_khz = s->cfg.if_dvbt_7;
 			i = DVBT_7;
 			break;
 		case 8000000:
-			if_khz = priv->cfg.if_dvbt_8;
+			if_khz = s->cfg.if_dvbt_8;
 			i = DVBT_8;
 			break;
 		default:
@@ -207,15 +205,15 @@ static int tda18212_set_params(struct dvb_frontend *fe)
 	case SYS_DVBT2:
 		switch (c->bandwidth_hz) {
 		case 6000000:
-			if_khz = priv->cfg.if_dvbt2_6;
+			if_khz = s->cfg.if_dvbt2_6;
 			i = DVBT2_6;
 			break;
 		case 7000000:
-			if_khz = priv->cfg.if_dvbt2_7;
+			if_khz = s->cfg.if_dvbt2_7;
 			i = DVBT2_7;
 			break;
 		case 8000000:
-			if_khz = priv->cfg.if_dvbt2_8;
+			if_khz = s->cfg.if_dvbt2_8;
 			i = DVBT2_8;
 			break;
 		default:
@@ -225,7 +223,7 @@ static int tda18212_set_params(struct dvb_frontend *fe)
 		break;
 	case SYS_DVBC_ANNEX_A:
 	case SYS_DVBC_ANNEX_C:
-		if_khz = priv->cfg.if_dvbc;
+		if_khz = s->cfg.if_dvbc;
 		i = DVBC_8;
 		break;
 	default:
@@ -233,15 +231,15 @@ static int tda18212_set_params(struct dvb_frontend *fe)
 		goto error;
 	}
 
-	ret = tda18212_wr_reg(priv, 0x23, bw_params[i][2]);
+	ret = tda18212_wr_reg(s, 0x23, bw_params[i][2]);
 	if (ret)
 		goto error;
 
-	ret = tda18212_wr_reg(priv, 0x06, 0x00);
+	ret = tda18212_wr_reg(s, 0x06, 0x00);
 	if (ret)
 		goto error;
 
-	ret = tda18212_wr_reg(priv, 0x0f, bw_params[i][0]);
+	ret = tda18212_wr_reg(s, 0x0f, bw_params[i][0]);
 	if (ret)
 		goto error;
 
@@ -254,12 +252,12 @@ static int tda18212_set_params(struct dvb_frontend *fe)
 	buf[6] = ((c->frequency / 1000) >>  0) & 0xff;
 	buf[7] = 0xc1;
 	buf[8] = 0x01;
-	ret = tda18212_wr_regs(priv, 0x12, buf, sizeof(buf));
+	ret = tda18212_wr_regs(s, 0x12, buf, sizeof(buf));
 	if (ret)
 		goto error;
 
 	/* actual IF rounded as it is on register */
-	priv->if_frequency = buf[3] * 50 * 1000;
+	s->if_frequency = buf[3] * 50 * 1000;
 
 exit:
 	if (fe->ops.i2c_gate_ctrl)
@@ -268,15 +266,15 @@ exit:
 	return ret;
 
 error:
-	dev_dbg(&priv->client->dev, "failed=%d\n", ret);
+	dev_dbg(&s->client->dev, "failed=%d\n", ret);
 	goto exit;
 }
 
 static int tda18212_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
 {
-	struct tda18212_priv *priv = fe->tuner_priv;
+	struct tda18212 *s = fe->tuner_priv;
 
-	*frequency = priv->if_frequency;
+	*frequency = s->if_frequency;
 
 	return 0;
 }
@@ -299,27 +297,27 @@ static int tda18212_probe(struct i2c_client *client,
 {
 	struct tda18212_config *cfg = client->dev.platform_data;
 	struct dvb_frontend *fe = cfg->fe;
-	struct tda18212_priv *priv;
+	struct tda18212 *s;
 	int ret;
 	u8 chip_id = chip_id;
 	char *version;
 
-	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
-	if (!priv) {
+	s = kzalloc(sizeof(*s), GFP_KERNEL);
+	if (!s) {
 		ret = -ENOMEM;
 		dev_err(&client->dev, "kzalloc() failed\n");
 		goto err;
 	}
 
-	memcpy(&priv->cfg, cfg, sizeof(struct tda18212_config));
-	priv->client = client;
+	memcpy(&s->cfg, cfg, sizeof(struct tda18212_config));
+	s->client = client;
 
 	/* check if the tuner is there */
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1); /* open I2C-gate */
 
-	ret = tda18212_rd_reg(priv, 0x00, &chip_id);
-	dev_dbg(&priv->client->dev, "chip_id=%02x\n", chip_id);
+	ret = tda18212_rd_reg(s, 0x00, &chip_id);
+	dev_dbg(&s->client->dev, "chip_id=%02x\n", chip_id);
 
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 0); /* close I2C-gate */
@@ -339,31 +337,31 @@ static int tda18212_probe(struct i2c_client *client,
 		goto err;
 	}
 
-	dev_info(&priv->client->dev,
+	dev_info(&s->client->dev,
 			"NXP TDA18212HN/%s successfully identified\n", version);
 
-	fe->tuner_priv = priv;
+	fe->tuner_priv = s;
 	memcpy(&fe->ops.tuner_ops, &tda18212_tuner_ops,
 			sizeof(struct dvb_tuner_ops));
-	i2c_set_clientdata(client, priv);
+	i2c_set_clientdata(client, s);
 
 	return 0;
 err:
 	dev_dbg(&client->dev, "failed=%d\n", ret);
-	kfree(priv);
+	kfree(s);
 	return ret;
 }
 
 static int tda18212_remove(struct i2c_client *client)
 {
-	struct tda18212_priv *priv = i2c_get_clientdata(client);
-	struct dvb_frontend *fe = priv->cfg.fe;
+	struct tda18212 *s = i2c_get_clientdata(client);
+	struct dvb_frontend *fe = s->cfg.fe;
 
 	dev_dbg(&client->dev, "\n");
 
 	memset(&fe->ops.tuner_ops, 0, sizeof(struct dvb_tuner_ops));
 	fe->tuner_priv = NULL;
-	kfree(priv);
+	kfree(s);
 
 	return 0;
 }
-- 
http://palosaari.fi/

