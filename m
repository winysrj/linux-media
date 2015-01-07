Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:46974 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063AbbAGNVL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Jan 2015 08:21:11 -0500
Received: by mail-pa0-f50.google.com with SMTP id bj1so4831978pad.9
        for <linux-media@vger.kernel.org>; Wed, 07 Jan 2015 05:21:10 -0800 (PST)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH v2 3/4] dvb: tc90522: use dvb-core i2c binding model template
Date: Wed,  7 Jan 2015 22:20:43 +0900
Message-Id: <1420636844-32553-4-git-send-email-tskd08@gmail.com>
In-Reply-To: <1420636844-32553-1-git-send-email-tskd08@gmail.com>
References: <1420636844-32553-1-git-send-email-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
---
 drivers/media/dvb-frontends/tc90522.c | 143 ++++++++++++++--------------------
 drivers/media/dvb-frontends/tc90522.h |   8 +-
 2 files changed, 63 insertions(+), 88 deletions(-)

diff --git a/drivers/media/dvb-frontends/tc90522.c b/drivers/media/dvb-frontends/tc90522.c
index b35d65c..7d9c9cd 100644
--- a/drivers/media/dvb-frontends/tc90522.c
+++ b/drivers/media/dvb-frontends/tc90522.c
@@ -30,6 +30,7 @@
 #include <linux/kernel.h>
 #include <linux/math64.h>
 #include <linux/dvb/frontend.h>
+#include "dvb_i2c.h"
 #include "dvb_math.h"
 #include "tc90522.h"
 
@@ -39,8 +40,6 @@
 
 struct tc90522_state {
 	struct tc90522_config cfg;
-	struct dvb_frontend fe;
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
+	msg.addr = fe->fe_i2c_client->addr;
 	msg.flags = 0;
 	msg.len = 2;
 	for (i = 0; i < num; i++) {
 		msg.buf = (u8 *)&regs[i];
-		ret = i2c_transfer(state->i2c_client->adapter, &msg, 1);
+		ret = i2c_transfer(fe->fe_i2c_client->adapter, &msg, 1);
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
+			.addr = fe->fe_i2c_client->addr,
 			.flags = 0,
 			.buf = &reg,
 			.len = 1,
 		},
 		{
-			.addr = state->i2c_client->addr,
+			.addr = fe->fe_i2c_client->addr,
 			.flags = I2C_M_RD,
 			.buf = val,
 			.len = len,
@@ -90,7 +89,7 @@ static int reg_read(struct tc90522_state *state, u8 reg, u8 *val, u8 len)
 	};
 	int ret;
 
-	ret = i2c_transfer(state->i2c_client->adapter, msgs, ARRAY_SIZE(msgs));
+	ret = i2c_transfer(fe->fe_i2c_client->adapter, msgs, ARRAY_SIZE(msgs));
 	if (ret == ARRAY_SIZE(msgs))
 		ret = 0;
 	else if (ret >= 0)
@@ -98,11 +97,6 @@ static int reg_read(struct tc90522_state *state, u8 reg, u8 *val, u8 len)
 	return ret;
 }
 
-static struct tc90522_state *cfg_to_state(struct tc90522_config *c)
-{
-	return container_of(c, struct tc90522_state, cfg);
-}
-
 
 static int tc90522s_set_tsid(struct dvb_frontend *fe)
 {
@@ -113,7 +107,7 @@ static int tc90522s_set_tsid(struct dvb_frontend *fe)
 
 	set_tsid[0].val = (fe->dtv_property_cache.stream_id & 0xff00) >> 8;
 	set_tsid[1].val = fe->dtv_property_cache.stream_id & 0xff;
-	return reg_write(fe->demodulator_priv, set_tsid, ARRAY_SIZE(set_tsid));
+	return reg_write(fe, set_tsid, ARRAY_SIZE(set_tsid));
 }
 
 static int tc90522t_set_layers(struct dvb_frontend *fe)
@@ -125,19 +119,17 @@ static int tc90522t_set_layers(struct dvb_frontend *fe)
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
 
@@ -152,7 +144,7 @@ static int tc90522s_read_status(struct dvb_frontend *fe, fe_status_t *status)
 
 	if (reg & 0x10)
 		return 0;
-	if (reg_read(state, 0xc5, &reg, 1) < 0 || !(reg & 0x03))
+	if (reg_read(fe, 0xc5, &reg, 1) < 0 || !(reg & 0x03))
 		return 0;
 	*status |= FE_HAS_LOCK;
 	return 0;
@@ -160,12 +152,10 @@ static int tc90522s_read_status(struct dvb_frontend *fe, fe_status_t *status)
 
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
 
@@ -176,7 +166,7 @@ static int tc90522t_read_status(struct dvb_frontend *fe, fe_status_t *status)
 		return 0;
 	}
 
-	ret = reg_read(state, 0x80, &reg, 1);
+	ret = reg_read(fe, 0x80, &reg, 1);
 	if (ret < 0)
 		return ret;
 
@@ -203,7 +193,6 @@ static const fe_code_rate_t fec_conv_sat[] = {
 
 static int tc90522s_get_frontend(struct dvb_frontend *fe)
 {
-	struct tc90522_state *state;
 	struct dtv_frontend_properties *c;
 	struct dtv_fe_stats *stats;
 	int ret, i;
@@ -211,12 +200,11 @@ static int tc90522s_get_frontend(struct dvb_frontend *fe)
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
 
@@ -257,7 +245,7 @@ static int tc90522s_get_frontend(struct dvb_frontend *fe)
 	stats->len = 1;
 	stats->stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 	cndat = 0;
-	ret = reg_read(state, 0xbc, val, 2);
+	ret = reg_read(fe, 0xbc, val, 2);
 	if (ret == 0)
 		cndat = val[0] << 8 | val[1];
 	if (cndat >= 3000) {
@@ -288,7 +276,7 @@ static int tc90522s_get_frontend(struct dvb_frontend *fe)
 	stats = &c->post_bit_error;
 	memset(stats, 0, sizeof(*stats));
 	stats->len = layers;
-	ret = reg_read(state, 0xeb, val, 10);
+	ret = reg_read(fe, 0xeb, val, 10);
 	if (ret < 0)
 		for (i = 0; i < layers; i++)
 			stats->stat[i].scale = FE_SCALE_NOT_AVAILABLE;
@@ -335,7 +323,6 @@ static const fe_modulation_t mod_conv[] = {
 
 static int tc90522t_get_frontend(struct dvb_frontend *fe)
 {
-	struct tc90522_state *state;
 	struct dtv_frontend_properties *c;
 	struct dtv_fe_stats *stats;
 	int ret, i;
@@ -343,19 +330,18 @@ static int tc90522t_get_frontend(struct dvb_frontend *fe)
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
@@ -416,7 +402,7 @@ static int tc90522t_get_frontend(struct dvb_frontend *fe)
 	stats->len = 1;
 	stats->stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 	cndat = 0;
-	ret = reg_read(state, 0x8b, val, 3);
+	ret = reg_read(fe, 0x8b, val, 3);
 	if (ret == 0)
 		cndat = val[0] << 16 | val[1] << 8 | val[2];
 	if (cndat != 0) {
@@ -449,7 +435,7 @@ static int tc90522t_get_frontend(struct dvb_frontend *fe)
 	stats = &c->post_bit_error;
 	memset(stats, 0, sizeof(*stats));
 	stats->len = layers;
-	ret = reg_read(state, 0x9d, val, 15);
+	ret = reg_read(fe, 0x9d, val, 15);
 	if (ret < 0)
 		for (i = 0; i < layers; i++)
 			stats->stat[i].scale = FE_SCALE_NOT_AVAILABLE;
@@ -483,11 +469,8 @@ static const struct reg_val reset_ter = { 0x01, 0x40 };
 
 static int tc90522_set_frontend(struct dvb_frontend *fe)
 {
-	struct tc90522_state *state;
 	int ret;
 
-	state = fe->demodulator_priv;
-
 	if (fe->ops.tuner_ops.set_params)
 		ret = fe->ops.tuner_ops.set_params(fe);
 	else
@@ -499,12 +482,12 @@ static int tc90522_set_frontend(struct dvb_frontend *fe)
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
@@ -512,7 +495,7 @@ static int tc90522_set_frontend(struct dvb_frontend *fe)
 	return 0;
 
 failed:
-	dev_warn(&state->tuner_i2c.dev, "(%s) failed. [adap%d-fe%d]\n",
+	dev_warn(&fe->fe_i2c_client->dev, "(%s) failed. [adap%d-fe%d]\n",
 			__func__, fe->dvb->num, fe->id);
 	return ret;
 }
@@ -545,11 +528,9 @@ static int tc90522_set_if_agc(struct dvb_frontend *fe, bool on)
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
@@ -563,7 +544,7 @@ static int tc90522_set_if_agc(struct dvb_frontend *fe, bool on)
 		rv = agc_ter;
 		num = ARRAY_SIZE(agc_ter);
 	}
-	return reg_write(state, rv, num);
+	return reg_write(fe, rv, num);
 }
 
 static const struct reg_val sleep_sat = { 0x17, 0x01 };
@@ -571,14 +552,12 @@ static const struct reg_val sleep_ter = { 0x03, 0x90 };
 
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
@@ -587,7 +566,7 @@ static int tc90522_sleep(struct dvb_frontend *fe)
 		}
 	}
 	if (ret < 0)
-		dev_warn(&state->tuner_i2c.dev,
+		dev_warn(&fe->fe_i2c_client->dev,
 			"(%s) failed. [adap%d-fe%d]\n",
 			__func__, fe->dvb->num, fe->id);
 	return ret;
@@ -598,7 +577,6 @@ static const struct reg_val wakeup_ter = { 0x03, 0x80 };
 
 static int tc90522_init(struct dvb_frontend *fe)
 {
-	struct tc90522_state *state;
 	int ret;
 
 	/*
@@ -607,11 +585,10 @@ static int tc90522_init(struct dvb_frontend *fe)
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
@@ -620,7 +597,7 @@ static int tc90522_init(struct dvb_frontend *fe)
 		}
 	}
 	if (ret < 0) {
-		dev_warn(&state->tuner_i2c.dev,
+		dev_warn(&fe->fe_i2c_client->dev,
 			"(%s) failed. [adap%d-fe%d]\n",
 			__func__, fe->dvb->num, fe->id);
 		return ret;
@@ -640,7 +617,7 @@ static int tc90522_init(struct dvb_frontend *fe)
 static int
 tc90522_master_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 {
-	struct tc90522_state *state;
+	struct dvb_frontend *fe;
 	struct i2c_msg *new_msgs;
 	int i, j;
 	int ret, rd_num;
@@ -658,11 +635,11 @@ tc90522_master_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 	if (!new_msgs)
 		return -ENOMEM;
 
-	state = i2c_get_adapdata(adap);
+	fe = i2c_get_adapdata(adap);
 	p = wbuf;
 	bufend = wbuf + sizeof(wbuf);
 	for (i = 0, j = 0; i < num; i++, j++) {
-		new_msgs[j].addr = state->i2c_client->addr;
+		new_msgs[j].addr = fe->fe_i2c_client->addr;
 		new_msgs[j].flags = msgs[i].flags;
 
 		if (msgs[i].flags & I2C_M_RD) {
@@ -675,7 +652,7 @@ tc90522_master_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 			new_msgs[j].len = 2;
 			p += 2;
 			j++;
-			new_msgs[j].addr = state->i2c_client->addr;
+			new_msgs[j].addr = fe->fe_i2c_client->addr;
 			new_msgs[j].flags = msgs[i].flags;
 			new_msgs[j].buf = msgs[i].buf;
 			new_msgs[j].len = msgs[i].len;
@@ -695,7 +672,7 @@ tc90522_master_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 	if (i < num)
 		ret = -ENOMEM;
 	else
-		ret = i2c_transfer(state->i2c_client->adapter, new_msgs, j);
+		ret = i2c_transfer(fe->fe_i2c_client->adapter, new_msgs, j);
 	if (ret >= 0 && ret < j)
 		ret = -EIO;
 	kfree(new_msgs);
@@ -766,51 +743,50 @@ static const struct dvb_frontend_ops tc90522_ops_ter = {
 static int tc90522_probe(struct i2c_client *client,
 			 const struct i2c_device_id *id)
 {
+	struct dvb_frontend *fe;
 	struct tc90522_state *state;
-	struct tc90522_config *cfg;
+	struct dvb_i2c_dev_config *cfg;
 	const struct dvb_frontend_ops *ops;
 	struct i2c_adapter *adap;
 	int ret;
 
-	state = kzalloc(sizeof(*state), GFP_KERNEL);
-	if (!state)
-		return -ENOMEM;
-	state->i2c_client = client;
+	fe = i2c_get_clientdata(client);
+	state = fe->demodulator_priv;
 
 	cfg = client->dev.platform_data;
-	memcpy(&state->cfg, cfg, sizeof(state->cfg));
-	cfg->fe = state->cfg.fe = &state->fe;
+	if (cfg && cfg->priv_cfg)
+		memcpy(&state->cfg, cfg->priv_cfg, sizeof(state->cfg));
 	ops =  id->driver_data == 0 ? &tc90522_ops_sat : &tc90522_ops_ter;
-	memcpy(&state->fe.ops, ops, sizeof(*ops));
-	state->fe.demodulator_priv = state;
+	memcpy(&fe->ops, ops, sizeof(*ops));
 
 	adap = &state->tuner_i2c;
 	adap->owner = THIS_MODULE;
 	adap->algo = &tc90522_tuner_i2c_algo;
 	adap->dev.parent = &client->dev;
 	strlcpy(adap->name, "tc90522_sub", sizeof(adap->name));
-	i2c_set_adapdata(adap, state);
 	ret = i2c_add_adapter(adap);
 	if (ret < 0)
-		goto err;
-	cfg->tuner_i2c = state->cfg.tuner_i2c = adap;
+		goto err_mem;
+	if (cfg && cfg->out)
+		*cfg->out = (struct tc90522_out *)adap;
+	i2c_set_adapdata(adap, fe); /* used in tc90522_master_xfer() */
 
-	i2c_set_clientdata(client, &state->cfg);
 	dev_info(&client->dev, "Toshiba TC90522 attached.\n");
 	return 0;
 
-err:
+err_mem:
 	kfree(state);
 	return ret;
 }
 
 static int tc90522_remove(struct i2c_client *client)
 {
+	struct dvb_frontend *fe;
 	struct tc90522_state *state;
 
-	state = cfg_to_state(i2c_get_clientdata(client));
+	fe = i2c_get_clientdata(client);
+	state = fe->demodulator_priv;
 	i2c_del_adapter(&state->tuner_i2c);
-	kfree(state);
 	return 0;
 }
 
@@ -820,18 +796,17 @@ static const struct i2c_device_id tc90522_id[] = {
 	{ TC90522_I2C_DEV_TER, 1 },
 	{}
 };
-MODULE_DEVICE_TABLE(i2c, tc90522_id);
 
-static struct i2c_driver tc90522_driver = {
-	.driver = {
-		.name	= "tc90522",
-	},
-	.probe		= tc90522_probe,
-	.remove		= tc90522_remove,
-	.id_table	= tc90522_id,
+static const struct dvb_i2c_module_param tc90522_param = {
+	.ops.fe_ops = NULL,
+	.priv_probe = tc90522_probe,
+	.priv_remove = tc90522_remove,
+
+	.priv_size = sizeof(struct tc90522_state),
+	.is_tuner = false,
 };
 
-module_i2c_driver(tc90522_driver);
+DEFINE_DVB_I2C_MODULE(tc90522, tc90522_id, tc90522_param);
 
 MODULE_DESCRIPTION("Toshiba TC90522 frontend");
 MODULE_AUTHOR("Akihiro TSUKADA");
diff --git a/drivers/media/dvb-frontends/tc90522.h b/drivers/media/dvb-frontends/tc90522.h
index b1cbddf..4b69d03 100644
--- a/drivers/media/dvb-frontends/tc90522.h
+++ b/drivers/media/dvb-frontends/tc90522.h
@@ -32,11 +32,11 @@
 #define TC90522_I2C_DEV_TER "tc90522ter"
 
 struct tc90522_config {
-	/* [OUT] frontend returned by driver */
-	struct dvb_frontend *fe;
+	/* none now */
+};
 
-	/* [OUT] tuner I2C adapter returned by driver */
-	struct i2c_adapter *tuner_i2c;
+struct tc90522_out {
+	struct i2c_adapter demod_bus;
 };
 
 #endif /* TC90522_H */
-- 
2.2.1

