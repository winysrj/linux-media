Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:58922 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbaLEK4V (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Dec 2014 05:56:21 -0500
Received: by mail-pd0-f178.google.com with SMTP id g10so503056pdj.9
        for <linux-media@vger.kernel.org>; Fri, 05 Dec 2014 02:56:21 -0800 (PST)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH 4/5] dvb: tc90522: remove a redundant state variable
Date: Fri,  5 Dec 2014 19:55:39 +0900
Message-Id: <1417776940-16381-5-git-send-email-tskd08@gmail.com>
In-Reply-To: <1417776940-16381-1-git-send-email-tskd08@gmail.com>
References: <1417776940-16381-1-git-send-email-tskd08@gmail.com>
In-Reply-To: <1417776573-16182-1-git-send-email-tskd08@gmail.com>
References: <1417776573-16182-1-git-send-email-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
---
 drivers/media/dvb-frontends/tc90522.c | 91 ++++++++++++++---------------------
 1 file changed, 36 insertions(+), 55 deletions(-)

diff --git a/drivers/media/dvb-frontends/tc90522.c b/drivers/media/dvb-frontends/tc90522.c
index 0f4ddd7..a06d6f5 100644
--- a/drivers/media/dvb-frontends/tc90522.c
+++ b/drivers/media/dvb-frontends/tc90522.c
@@ -40,7 +40,6 @@
 
 struct tc90522_state {
 	struct tc90522_config cfg;
-	struct i2c_client *i2c_client;
 	struct i2c_adapter tuner_i2c;
 
 	bool lna;
@@ -52,18 +51,18 @@ struct reg_val {
 };
 
 static int
-reg_write(struct tc90522_state *state, const struct reg_val *regs, int num)
+reg_write(struct dvb_frontend *fe, const struct reg_val *regs, int num)
 {
 	int i, ret;
 	struct i2c_msg msg;
 
 	ret = 0;
-	msg.addr = state->i2c_client->addr;
+	msg.addr = fe->fe_cl->addr;
 	msg.flags = 0;
 	msg.len = 2;
 	for (i = 0; i < num; i++) {
 		msg.buf = (u8 *)&regs[i];
-		ret = i2c_transfer(state->i2c_client->adapter, &msg, 1);
+		ret = i2c_transfer(fe->fe_cl->adapter, &msg, 1);
 		if (ret == 0)
 			ret = -EIO;
 		if (ret < 0)
@@ -72,17 +71,17 @@ reg_write(struct tc90522_state *state, const struct reg_val *regs, int num)
 	return 0;
 }
 
-static int reg_read(struct tc90522_state *state, u8 reg, u8 *val, u8 len)
+static int reg_read(struct dvb_frontend *fe, u8 reg, u8 *val, u8 len)
 {
 	struct i2c_msg msgs[2] = {
 		{
-			.addr = state->i2c_client->addr,
+			.addr = fe->fe_cl->addr,
 			.flags = 0,
 			.buf = &reg,
 			.len = 1,
 		},
 		{
-			.addr = state->i2c_client->addr,
+			.addr = fe->fe_cl->addr,
 			.flags = I2C_M_RD,
 			.buf = val,
 			.len = len,
@@ -90,7 +89,7 @@ static int reg_read(struct tc90522_state *state, u8 reg, u8 *val, u8 len)
 	};
 	int ret;
 
-	ret = i2c_transfer(state->i2c_client->adapter, msgs, ARRAY_SIZE(msgs));
+	ret = i2c_transfer(fe->fe_cl->adapter, msgs, ARRAY_SIZE(msgs));
 	if (ret == ARRAY_SIZE(msgs))
 		ret = 0;
 	else if (ret >= 0)
@@ -108,7 +107,7 @@ static int tc90522s_set_tsid(struct dvb_frontend *fe)
 
 	set_tsid[0].val = (fe->dtv_property_cache.stream_id & 0xff00) >> 8;
 	set_tsid[1].val = fe->dtv_property_cache.stream_id & 0xff;
-	return reg_write(fe->demodulator_priv, set_tsid, ARRAY_SIZE(set_tsid));
+	return reg_write(fe, set_tsid, ARRAY_SIZE(set_tsid));
 }
 
 static int tc90522t_set_layers(struct dvb_frontend *fe)
@@ -120,19 +119,17 @@ static int tc90522t_set_layers(struct dvb_frontend *fe)
 	laysel = (laysel & 0x01) << 2 | (laysel & 0x02) | (laysel & 0x04) >> 2;
 	rv.reg = 0x71;
 	rv.val = laysel;
-	return reg_write(fe->demodulator_priv, &rv, 1);
+	return reg_write(fe, &rv, 1);
 }
 
 /* frontend ops */
 
 static int tc90522s_read_status(struct dvb_frontend *fe, fe_status_t *status)
 {
-	struct tc90522_state *state;
 	int ret;
 	u8 reg;
 
-	state = fe->demodulator_priv;
-	ret = reg_read(state, 0xc3, &reg, 1);
+	ret = reg_read(fe, 0xc3, &reg, 1);
 	if (ret < 0)
 		return ret;
 
@@ -147,7 +144,7 @@ static int tc90522s_read_status(struct dvb_frontend *fe, fe_status_t *status)
 
 	if (reg & 0x10)
 		return 0;
-	if (reg_read(state, 0xc5, &reg, 1) < 0 || !(reg & 0x03))
+	if (reg_read(fe, 0xc5, &reg, 1) < 0 || !(reg & 0x03))
 		return 0;
 	*status |= FE_HAS_LOCK;
 	return 0;
@@ -155,12 +152,10 @@ static int tc90522s_read_status(struct dvb_frontend *fe, fe_status_t *status)
 
 static int tc90522t_read_status(struct dvb_frontend *fe, fe_status_t *status)
 {
-	struct tc90522_state *state;
 	int ret;
 	u8 reg;
 
-	state = fe->demodulator_priv;
-	ret = reg_read(state, 0x96, &reg, 1);
+	ret = reg_read(fe, 0x96, &reg, 1);
 	if (ret < 0)
 		return ret;
 
@@ -171,7 +166,7 @@ static int tc90522t_read_status(struct dvb_frontend *fe, fe_status_t *status)
 		return 0;
 	}
 
-	ret = reg_read(state, 0x80, &reg, 1);
+	ret = reg_read(fe, 0x80, &reg, 1);
 	if (ret < 0)
 		return ret;
 
@@ -198,7 +193,6 @@ static const fe_code_rate_t fec_conv_sat[] = {
 
 static int tc90522s_get_frontend(struct dvb_frontend *fe)
 {
-	struct tc90522_state *state;
 	struct dtv_frontend_properties *c;
 	struct dtv_fe_stats *stats;
 	int ret, i;
@@ -206,12 +200,11 @@ static int tc90522s_get_frontend(struct dvb_frontend *fe)
 	u8 val[10];
 	u32 cndat;
 
-	state = fe->demodulator_priv;
 	c = &fe->dtv_property_cache;
 	c->delivery_system = SYS_ISDBS;
 
 	layers = 0;
-	ret = reg_read(state, 0xe6, val, 5);
+	ret = reg_read(fe, 0xe6, val, 5);
 	if (ret == 0) {
 		u8 v;
 
@@ -252,7 +245,7 @@ static int tc90522s_get_frontend(struct dvb_frontend *fe)
 	stats->len = 1;
 	stats->stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 	cndat = 0;
-	ret = reg_read(state, 0xbc, val, 2);
+	ret = reg_read(fe, 0xbc, val, 2);
 	if (ret == 0)
 		cndat = val[0] << 8 | val[1];
 	if (cndat >= 3000) {
@@ -283,7 +276,7 @@ static int tc90522s_get_frontend(struct dvb_frontend *fe)
 	stats = &c->post_bit_error;
 	memset(stats, 0, sizeof(*stats));
 	stats->len = layers;
-	ret = reg_read(state, 0xeb, val, 10);
+	ret = reg_read(fe, 0xeb, val, 10);
 	if (ret < 0)
 		for (i = 0; i < layers; i++)
 			stats->stat[i].scale = FE_SCALE_NOT_AVAILABLE;
@@ -330,7 +323,6 @@ static const fe_modulation_t mod_conv[] = {
 
 static int tc90522t_get_frontend(struct dvb_frontend *fe)
 {
-	struct tc90522_state *state;
 	struct dtv_frontend_properties *c;
 	struct dtv_fe_stats *stats;
 	int ret, i;
@@ -338,19 +330,18 @@ static int tc90522t_get_frontend(struct dvb_frontend *fe)
 	u8 val[15], mode;
 	u32 cndat;
 
-	state = fe->demodulator_priv;
 	c = &fe->dtv_property_cache;
 	c->delivery_system = SYS_ISDBT;
 	c->bandwidth_hz = 6000000;
 	mode = 1;
-	ret = reg_read(state, 0xb0, val, 1);
+	ret = reg_read(fe, 0xb0, val, 1);
 	if (ret == 0) {
 		mode = (val[0] & 0xc0) >> 2;
 		c->transmission_mode = tm_conv[mode];
 		c->guard_interval = (val[0] & 0x30) >> 4;
 	}
 
-	ret = reg_read(state, 0xb2, val, 6);
+	ret = reg_read(fe, 0xb2, val, 6);
 	layers = 0;
 	if (ret == 0) {
 		u8 v;
@@ -411,7 +402,7 @@ static int tc90522t_get_frontend(struct dvb_frontend *fe)
 	stats->len = 1;
 	stats->stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 	cndat = 0;
-	ret = reg_read(state, 0x8b, val, 3);
+	ret = reg_read(fe, 0x8b, val, 3);
 	if (ret == 0)
 		cndat = val[0] << 16 | val[1] << 8 | val[2];
 	if (cndat != 0) {
@@ -444,7 +435,7 @@ static int tc90522t_get_frontend(struct dvb_frontend *fe)
 	stats = &c->post_bit_error;
 	memset(stats, 0, sizeof(*stats));
 	stats->len = layers;
-	ret = reg_read(state, 0x9d, val, 15);
+	ret = reg_read(fe, 0x9d, val, 15);
 	if (ret < 0)
 		for (i = 0; i < layers; i++)
 			stats->stat[i].scale = FE_SCALE_NOT_AVAILABLE;
@@ -478,11 +469,8 @@ static const struct reg_val reset_ter = { 0x01, 0x40 };
 
 static int tc90522_set_frontend(struct dvb_frontend *fe)
 {
-	struct tc90522_state *state;
 	int ret;
 
-	state = fe->demodulator_priv;
-
 	if (fe->ops.tuner_ops.set_params)
 		ret = fe->ops.tuner_ops.set_params(fe);
 	else
@@ -494,12 +482,12 @@ static int tc90522_set_frontend(struct dvb_frontend *fe)
 		ret = tc90522s_set_tsid(fe);
 		if (ret < 0)
 			goto failed;
-		ret = reg_write(state, &reset_sat, 1);
+		ret = reg_write(fe, &reset_sat, 1);
 	} else {
 		ret = tc90522t_set_layers(fe);
 		if (ret < 0)
 			goto failed;
-		ret = reg_write(state, &reset_ter, 1);
+		ret = reg_write(fe, &reset_ter, 1);
 	}
 	if (ret < 0)
 		goto failed;
@@ -507,7 +495,7 @@ static int tc90522_set_frontend(struct dvb_frontend *fe)
 	return 0;
 
 failed:
-	dev_warn(&state->tuner_i2c.dev, "(%s) failed. [adap%d-fe%d]\n",
+	dev_warn(&fe->fe_cl->dev, "(%s) failed. [adap%d-fe%d]\n",
 			__func__, fe->dvb->num, fe->id);
 	return ret;
 }
@@ -540,11 +528,9 @@ static int tc90522_set_if_agc(struct dvb_frontend *fe, bool on)
 		{ 0x23, 0x4c },
 		{ 0x01, 0x40 },
 	};
-	struct tc90522_state *state;
 	struct reg_val *rv;
 	int num;
 
-	state = fe->demodulator_priv;
 	if (fe->ops.delsys[0] == SYS_ISDBS) {
 		agc_sat[0].val = on ? 0xff : 0x00;
 		agc_sat[1].val |= 0x80;
@@ -558,7 +544,7 @@ static int tc90522_set_if_agc(struct dvb_frontend *fe, bool on)
 		rv = agc_ter;
 		num = ARRAY_SIZE(agc_ter);
 	}
-	return reg_write(state, rv, num);
+	return reg_write(fe, rv, num);
 }
 
 static const struct reg_val sleep_sat = { 0x17, 0x01 };
@@ -566,14 +552,12 @@ static const struct reg_val sleep_ter = { 0x03, 0x90 };
 
 static int tc90522_sleep(struct dvb_frontend *fe)
 {
-	struct tc90522_state *state;
 	int ret;
 
-	state = fe->demodulator_priv;
 	if (fe->ops.delsys[0] == SYS_ISDBS)
-		ret = reg_write(state, &sleep_sat, 1);
+		ret = reg_write(fe, &sleep_sat, 1);
 	else {
-		ret = reg_write(state, &sleep_ter, 1);
+		ret = reg_write(fe, &sleep_ter, 1);
 		if (ret == 0 && fe->ops.set_lna &&
 		    fe->dtv_property_cache.lna == LNA_AUTO) {
 			fe->dtv_property_cache.lna = 0;
@@ -582,7 +566,7 @@ static int tc90522_sleep(struct dvb_frontend *fe)
 		}
 	}
 	if (ret < 0)
-		dev_warn(&state->tuner_i2c.dev,
+		dev_warn(&fe->fe_cl->dev,
 			"(%s) failed. [adap%d-fe%d]\n",
 			__func__, fe->dvb->num, fe->id);
 	return ret;
@@ -593,7 +577,6 @@ static const struct reg_val wakeup_ter = { 0x03, 0x80 };
 
 static int tc90522_init(struct dvb_frontend *fe)
 {
-	struct tc90522_state *state;
 	int ret;
 
 	/*
@@ -602,11 +585,10 @@ static int tc90522_init(struct dvb_frontend *fe)
 	 * just wake up the device here.
 	 */
 
-	state = fe->demodulator_priv;
 	if (fe->ops.delsys[0] == SYS_ISDBS)
-		ret = reg_write(state, &wakeup_sat, 1);
+		ret = reg_write(fe, &wakeup_sat, 1);
 	else {
-		ret = reg_write(state, &wakeup_ter, 1);
+		ret = reg_write(fe, &wakeup_ter, 1);
 		if (ret == 0 && fe->ops.set_lna &&
 		    fe->dtv_property_cache.lna == LNA_AUTO) {
 			fe->dtv_property_cache.lna = 1;
@@ -615,7 +597,7 @@ static int tc90522_init(struct dvb_frontend *fe)
 		}
 	}
 	if (ret < 0) {
-		dev_warn(&state->tuner_i2c.dev,
+		dev_warn(&fe->fe_cl->dev,
 			"(%s) failed. [adap%d-fe%d]\n",
 			__func__, fe->dvb->num, fe->id);
 		return ret;
@@ -635,7 +617,7 @@ static int tc90522_init(struct dvb_frontend *fe)
 static int
 tc90522_master_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 {
-	struct tc90522_state *state;
+	struct dvb_frontend *fe;
 	struct i2c_msg *new_msgs;
 	int i, j;
 	int ret, rd_num;
@@ -653,11 +635,11 @@ tc90522_master_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 	if (!new_msgs)
 		return -ENOMEM;
 
-	state = i2c_get_adapdata(adap);
+	fe = i2c_get_adapdata(adap);
 	p = wbuf;
 	bufend = wbuf + sizeof(wbuf);
 	for (i = 0, j = 0; i < num; i++, j++) {
-		new_msgs[j].addr = state->i2c_client->addr;
+		new_msgs[j].addr = fe->fe_cl->addr;
 		new_msgs[j].flags = msgs[i].flags;
 
 		if (msgs[i].flags & I2C_M_RD) {
@@ -670,7 +652,7 @@ tc90522_master_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 			new_msgs[j].len = 2;
 			p += 2;
 			j++;
-			new_msgs[j].addr = state->i2c_client->addr;
+			new_msgs[j].addr = fe->fe_cl->addr;
 			new_msgs[j].flags = msgs[i].flags;
 			new_msgs[j].buf = msgs[i].buf;
 			new_msgs[j].len = msgs[i].len;
@@ -690,7 +672,7 @@ tc90522_master_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 	if (i < num)
 		ret = -ENOMEM;
 	else
-		ret = i2c_transfer(state->i2c_client->adapter, new_msgs, j);
+		ret = i2c_transfer(fe->fe_cl->adapter, new_msgs, j);
 	if (ret >= 0 && ret < j)
 		ret = -EIO;
 	kfree(new_msgs);
@@ -770,7 +752,6 @@ static int tc90522_probe(struct i2c_client *client,
 
 	fe = i2c_get_clientdata(client);
 	state = fe->demodulator_priv;
-	state->i2c_client = client;
 
 	dcfg = client->dev.platform_data;
 	if (dcfg && dcfg->priv_cfg)
@@ -788,7 +769,7 @@ static int tc90522_probe(struct i2c_client *client,
 		goto err_mem;
 	if (dcfg && dcfg->out)
 		*dcfg->out = (struct tc90522_out *)adap;
-	i2c_set_adapdata(adap, state); /* used in tc90522_master_xfer() */
+	i2c_set_adapdata(adap, fe); /* used in tc90522_master_xfer() */
 
 	dev_info(&client->dev, "Toshiba TC90522 attached.\n");
 	return 0;
-- 
2.1.3

