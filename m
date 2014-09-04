Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:32782 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757065AbaIDChC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Sep 2014 22:37:02 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 15/37] it913x: rename 'state' to 'dev'
Date: Thu,  4 Sep 2014 05:36:23 +0300
Message-Id: <1409798205-25645-15-git-send-email-crope@iki.fi>
In-Reply-To: <1409798205-25645-1-git-send-email-crope@iki.fi>
References: <1409798205-25645-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

foo_dev seems to be most correct term for the structure holding data
of each device instance. It is most used term in Kernel and also
examples from book Linux Device Drivers, Third Edition, uses it.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/it913x.c | 150 +++++++++++++++++++++---------------------
 1 file changed, 75 insertions(+), 75 deletions(-)

diff --git a/drivers/media/tuners/it913x.c b/drivers/media/tuners/it913x.c
index 7664878..cc959c1 100644
--- a/drivers/media/tuners/it913x.c
+++ b/drivers/media/tuners/it913x.c
@@ -22,7 +22,7 @@
 
 #include "it913x_priv.h"
 
-struct it913x_state {
+struct it913x_dev {
 	struct i2c_client *client;
 	struct dvb_frontend *fe;
 	u8 chip_ver;
@@ -34,15 +34,15 @@ struct it913x_state {
 };
 
 /* read multiple registers */
-static int it913x_rd_regs(struct it913x_state *state,
+static int it913x_rd_regs(struct it913x_dev *dev,
 		u32 reg, u8 *data, u8 count)
 {
 	int ret;
 	u8 b[3];
 	struct i2c_msg msg[2] = {
-		{ .addr = state->client->addr, .flags = 0,
+		{ .addr = dev->client->addr, .flags = 0,
 			.buf = b, .len = sizeof(b) },
-		{ .addr = state->client->addr, .flags = I2C_M_RD,
+		{ .addr = dev->client->addr, .flags = I2C_M_RD,
 			.buf = data, .len = count }
 	};
 
@@ -50,18 +50,18 @@ static int it913x_rd_regs(struct it913x_state *state,
 	b[1] = (u8)(reg >> 8) & 0xff;
 	b[2] = (u8) reg & 0xff;
 
-	ret = i2c_transfer(state->client->adapter, msg, 2);
+	ret = i2c_transfer(dev->client->adapter, msg, 2);
 
 	return ret;
 }
 
 /* read single register */
-static int it913x_rd_reg(struct it913x_state *state, u32 reg, u8 *val)
+static int it913x_rd_reg(struct it913x_dev *dev, u32 reg, u8 *val)
 {
 	int ret;
 	u8 b[1];
 
-	ret = it913x_rd_regs(state, reg, &b[0], sizeof(b));
+	ret = it913x_rd_regs(dev, reg, &b[0], sizeof(b));
 	if (ret < 0)
 		return -ENODEV;
 	*val = b[0];
@@ -69,12 +69,12 @@ static int it913x_rd_reg(struct it913x_state *state, u32 reg, u8 *val)
 }
 
 /* write multiple registers */
-static int it913x_wr_regs(struct it913x_state *state,
+static int it913x_wr_regs(struct it913x_dev *dev,
 		u32 reg, u8 buf[], u8 count)
 {
 	u8 b[256];
 	struct i2c_msg msg[1] = {
-		{ .addr = state->client->addr, .flags = 0,
+		{ .addr = dev->client->addr, .flags = 0,
 		  .buf = b, .len = 3 + count }
 	};
 	int ret;
@@ -84,7 +84,7 @@ static int it913x_wr_regs(struct it913x_state *state,
 	b[2] = (u8) reg & 0xff;
 	memcpy(&b[3], buf, count);
 
-	ret = i2c_transfer(state->client->adapter, msg, 1);
+	ret = i2c_transfer(dev->client->adapter, msg, 1);
 
 	if (ret < 0)
 		return -EIO;
@@ -93,12 +93,12 @@ static int it913x_wr_regs(struct it913x_state *state,
 }
 
 /* write single register */
-static int it913x_wr_reg(struct it913x_state *state,
+static int it913x_wr_reg(struct it913x_dev *dev,
 		u32 reg, u32 data)
 {
 	int ret;
 	u8 b[4];
-	u8 s;
+	u8 len;
 
 	b[0] = data >> 24;
 	b[1] = (data >> 16) & 0xff;
@@ -106,20 +106,20 @@ static int it913x_wr_reg(struct it913x_state *state,
 	b[3] = data & 0xff;
 	/* expand write as needed */
 	if (data < 0x100)
-		s = 3;
+		len = 3;
 	else if (data < 0x1000)
-		s = 2;
+		len = 2;
 	else if (data < 0x100000)
-		s = 1;
+		len = 1;
 	else
-		s = 0;
+		len = 0;
 
-	ret = it913x_wr_regs(state, reg, &b[s], sizeof(b) - s);
+	ret = it913x_wr_regs(dev, reg, &b[len], sizeof(b) - len);
 
 	return ret;
 }
 
-static int it913x_script_loader(struct it913x_state *state,
+static int it913x_script_loader(struct it913x_dev *dev,
 		struct it913xset *loadscript)
 {
 	int ret, i;
@@ -130,7 +130,7 @@ static int it913x_script_loader(struct it913x_state *state,
 	for (i = 0; i < 1000; ++i) {
 		if (loadscript[i].address == 0x000000)
 			break;
-		ret = it913x_wr_regs(state,
+		ret = it913x_wr_regs(dev,
 			loadscript[i].address,
 			loadscript[i].reg, loadscript[i].count);
 		if (ret < 0)
@@ -141,31 +141,31 @@ static int it913x_script_loader(struct it913x_state *state,
 
 static int it913x_init(struct dvb_frontend *fe)
 {
-	struct it913x_state *state = fe->tuner_priv;
+	struct it913x_dev *dev = fe->tuner_priv;
 	int ret, i;
 	u8 reg = 0;
 	u8 val, nv_val;
 	u8 nv[] = {48, 32, 24, 16, 12, 8, 6, 4, 2};
 	u8 b[2];
 
-	ret = it913x_rd_reg(state, 0x80ec86, &reg);
+	ret = it913x_rd_reg(dev, 0x80ec86, &reg);
 	switch (reg) {
 	case 0:
-		state->tun_clk_mode = reg;
-		state->tun_xtal = 2000;
-		state->tun_fdiv = 3;
+		dev->tun_clk_mode = reg;
+		dev->tun_xtal = 2000;
+		dev->tun_fdiv = 3;
 		val = 16;
 		break;
 	case 1:
 	default: /* I/O error too */
-		state->tun_clk_mode = reg;
-		state->tun_xtal = 640;
-		state->tun_fdiv = 1;
+		dev->tun_clk_mode = reg;
+		dev->tun_xtal = 640;
+		dev->tun_fdiv = 1;
 		val = 6;
 		break;
 	}
 
-	ret = it913x_rd_reg(state, 0x80ed03,  &reg);
+	ret = it913x_rd_reg(dev, 0x80ed03,  &reg);
 
 	if (reg < 0)
 		return -ENODEV;
@@ -175,7 +175,7 @@ static int it913x_init(struct dvb_frontend *fe)
 		nv_val = 2;
 
 	for (i = 0; i < 50; i++) {
-		ret = it913x_rd_regs(state, 0x80ed23, &b[0], sizeof(b));
+		ret = it913x_rd_regs(dev, 0x80ed23, &b[0], sizeof(b));
 		reg = (b[1] << 8) + b[0];
 		if (reg > 0)
 			break;
@@ -183,15 +183,15 @@ static int it913x_init(struct dvb_frontend *fe)
 			return -ENODEV;
 		udelay(2000);
 	}
-	state->tun_fn_min = state->tun_xtal * reg;
-	state->tun_fn_min /= (state->tun_fdiv * nv_val);
-	dev_dbg(&state->client->dev, "Tuner fn_min %d\n", state->tun_fn_min);
+	dev->tun_fn_min = dev->tun_xtal * reg;
+	dev->tun_fn_min /= (dev->tun_fdiv * nv_val);
+	dev_dbg(&dev->client->dev, "Tuner fn_min %d\n", dev->tun_fn_min);
 
-	if (state->chip_ver > 1)
+	if (dev->chip_ver > 1)
 		msleep(50);
 	else {
 		for (i = 0; i < 50; i++) {
-			ret = it913x_rd_reg(state, 0x80ec82, &reg);
+			ret = it913x_rd_reg(dev, 0x80ec82, &reg);
 			if (ret < 0)
 				return -ENODEV;
 			if (reg > 0)
@@ -201,16 +201,16 @@ static int it913x_init(struct dvb_frontend *fe)
 	}
 
 	/* Power Up Tuner - common all versions */
-	ret = it913x_wr_reg(state, 0x80ec40, 0x1);
-	ret |= it913x_wr_reg(state, 0x80ec57, 0x0);
-	ret |= it913x_wr_reg(state, 0x80ec58, 0x0);
+	ret = it913x_wr_reg(dev, 0x80ec40, 0x1);
+	ret |= it913x_wr_reg(dev, 0x80ec57, 0x0);
+	ret |= it913x_wr_reg(dev, 0x80ec58, 0x0);
 
-	return it913x_wr_reg(state, 0x80ed81, val);
+	return it913x_wr_reg(dev, 0x80ed81, val);
 }
 
 static int it9137_set_params(struct dvb_frontend *fe)
 {
-	struct it913x_state *state = fe->tuner_priv;
+	struct it913x_dev *dev = fe->tuner_priv;
 	struct it913xset *set_tuner = set_it9137_template;
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	u32 bandwidth = p->bandwidth_hz;
@@ -226,12 +226,12 @@ static int it9137_set_params(struct dvb_frontend *fe)
 	u8 lna_band;
 	u8 bw;
 
-	if (state->firmware_ver == 1)
+	if (dev->firmware_ver == 1)
 		set_tuner = set_it9135_template;
 	else
 		set_tuner = set_it9137_template;
 
-	dev_dbg(&state->client->dev, "Tuner Frequency %d Bandwidth %d\n",
+	dev_dbg(&dev->client->dev, "Tuner Frequency %d Bandwidth %d\n",
 			frequency, bandwidth);
 
 	if (frequency >= 51000 && frequency <= 440000) {
@@ -305,10 +305,10 @@ static int it9137_set_params(struct dvb_frontend *fe)
 	} else if (frequency > 296000 && frequency <= 445000) {
 		n_div = 8;
 		n = 5;
-	} else if (frequency > 445000 && frequency <= state->tun_fn_min) {
+	} else if (frequency > 445000 && frequency <= dev->tun_fn_min) {
 		n_div = 6;
 		n = 6;
-	} else if (frequency > state->tun_fn_min && frequency <= 950000) {
+	} else if (frequency > dev->tun_fn_min && frequency <= 950000) {
 		n_div = 4;
 		n = 7;
 	} else if (frequency > 1450000 && frequency <= 1680000) {
@@ -317,27 +317,27 @@ static int it9137_set_params(struct dvb_frontend *fe)
 	} else
 		return -EINVAL;
 
-	ret = it913x_rd_reg(state, 0x80ed81, &reg);
+	ret = it913x_rd_reg(dev, 0x80ed81, &reg);
 	iqik_m_cal = (u16)reg * n_div;
 
 	if (reg < 0x20) {
-		if (state->tun_clk_mode == 0)
+		if (dev->tun_clk_mode == 0)
 			iqik_m_cal = (iqik_m_cal * 9) >> 5;
 		else
 			iqik_m_cal >>= 1;
 	} else {
 		iqik_m_cal = 0x40 - iqik_m_cal;
-		if (state->tun_clk_mode == 0)
+		if (dev->tun_clk_mode == 0)
 			iqik_m_cal = ~((iqik_m_cal * 9) >> 5);
 		else
 			iqik_m_cal = ~(iqik_m_cal >> 1);
 	}
 
-	temp_f = frequency * (u32)n_div * (u32)state->tun_fdiv;
-	freq = temp_f / state->tun_xtal;
-	tmp = freq * state->tun_xtal;
+	temp_f = frequency * (u32)n_div * (u32)dev->tun_fdiv;
+	freq = temp_f / dev->tun_xtal;
+	tmp = freq * dev->tun_xtal;
 
-	if ((temp_f - tmp) >= (state->tun_xtal >> 1))
+	if ((temp_f - tmp) >= (dev->tun_xtal >> 1))
 		freq++;
 
 	freq += (u32) n << 13;
@@ -347,15 +347,15 @@ static int it9137_set_params(struct dvb_frontend *fe)
 	set_tuner[3].reg[0] =  temp_f & 0xff;
 	set_tuner[4].reg[0] =  (temp_f >> 8) & 0xff;
 
-	dev_dbg(&state->client->dev, "High Frequency = %04x\n", temp_f);
+	dev_dbg(&dev->client->dev, "High Frequency = %04x\n", temp_f);
 
 	/* Lower frequency */
 	set_tuner[5].reg[0] =  freq & 0xff;
 	set_tuner[6].reg[0] =  (freq >> 8) & 0xff;
 
-	dev_dbg(&state->client->dev, "low Frequency = %04x\n", freq);
+	dev_dbg(&dev->client->dev, "low Frequency = %04x\n", freq);
 
-	ret = it913x_script_loader(state, set_tuner);
+	ret = it913x_script_loader(dev, set_tuner);
 
 	return (ret < 0) ? -ENODEV : 0;
 }
@@ -366,12 +366,12 @@ static int it9137_set_params(struct dvb_frontend *fe)
 
 static int it913x_sleep(struct dvb_frontend *fe)
 {
-	struct it913x_state *state = fe->tuner_priv;
+	struct it913x_dev *dev = fe->tuner_priv;
 
-	if (state->chip_ver == 0x01)
-		return it913x_script_loader(state, it9135ax_tuner_off);
+	if (dev->chip_ver == 0x01)
+		return it913x_script_loader(dev, it9135ax_tuner_off);
 	else
-		return it913x_script_loader(state, it9137_tuner_off);
+		return it913x_script_loader(dev, it9137_tuner_off);
 }
 
 static const struct dvb_tuner_ops it913x_tuner_ops = {
@@ -391,60 +391,60 @@ static int it913x_probe(struct i2c_client *client,
 {
 	struct it913x_config *cfg = client->dev.platform_data;
 	struct dvb_frontend *fe = cfg->fe;
-	struct it913x_state *state;
+	struct it913x_dev *dev;
 	int ret;
 	char *chip_ver_str;
 
-	state = kzalloc(sizeof(struct it913x_state), GFP_KERNEL);
-	if (state == NULL) {
+	dev = kzalloc(sizeof(struct it913x_dev), GFP_KERNEL);
+	if (dev == NULL) {
 		ret = -ENOMEM;
 		dev_err(&client->dev, "kzalloc() failed\n");
 		goto err;
 	}
 
-	state->client = client;
-	state->fe = cfg->fe;
-	state->chip_ver = cfg->chip_ver;
-	state->firmware_ver = 1;
+	dev->client = client;
+	dev->fe = cfg->fe;
+	dev->chip_ver = cfg->chip_ver;
+	dev->firmware_ver = 1;
 
 	/* tuner RF initial */
-	ret = it913x_wr_reg(state, 0x80ec4c, 0x68);
+	ret = it913x_wr_reg(dev, 0x80ec4c, 0x68);
 	if (ret < 0)
 		goto err;
 
-	fe->tuner_priv = state;
+	fe->tuner_priv = dev;
 	memcpy(&fe->ops.tuner_ops, &it913x_tuner_ops,
 			sizeof(struct dvb_tuner_ops));
-	i2c_set_clientdata(client, state);
+	i2c_set_clientdata(client, dev);
 
-	if (state->chip_ver == 1)
+	if (dev->chip_ver == 1)
 		chip_ver_str = "AX";
-	else if (state->chip_ver == 2)
+	else if (dev->chip_ver == 2)
 		chip_ver_str = "BX";
 	else
 		chip_ver_str = "??";
 
-	dev_info(&state->client->dev, "ITE IT913X %s successfully attached\n",
+	dev_info(&dev->client->dev, "ITE IT913X %s successfully attached\n",
 			chip_ver_str);
-	dev_dbg(&state->client->dev, "chip_ver=%02x\n", state->chip_ver);
+	dev_dbg(&dev->client->dev, "chip_ver=%02x\n", dev->chip_ver);
 	return 0;
 err:
 	dev_dbg(&client->dev, "failed %d\n", ret);
-	kfree(state);
+	kfree(dev);
 
 	return ret;
 }
 
 static int it913x_remove(struct i2c_client *client)
 {
-	struct it913x_state *state = i2c_get_clientdata(client);
-	struct dvb_frontend *fe = state->fe;
+	struct it913x_dev *dev = i2c_get_clientdata(client);
+	struct dvb_frontend *fe = dev->fe;
 
 	dev_dbg(&client->dev, "\n");
 
 	memset(&fe->ops.tuner_ops, 0, sizeof(struct dvb_tuner_ops));
 	fe->tuner_priv = NULL;
-	kfree(state);
+	kfree(dev);
 
 	return 0;
 }
-- 
http://palosaari.fi/

