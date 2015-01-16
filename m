Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:53905 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070AbbAPLZA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Jan 2015 06:25:00 -0500
Received: by mail-pd0-f169.google.com with SMTP id z10so22256012pdj.0
        for <linux-media@vger.kernel.org>; Fri, 16 Jan 2015 03:25:00 -0800 (PST)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH v3 3/4] dvb: tc90522: use dvb-core i2c binding model template
Date: Fri, 16 Jan 2015 20:24:39 +0900
Message-Id: <1421407480-9122-4-git-send-email-tskd08@gmail.com>
In-Reply-To: <1421407480-9122-1-git-send-email-tskd08@gmail.com>
References: <1421407480-9122-1-git-send-email-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
---
 drivers/media/dvb-frontends/tc90522.c | 64 ++++++++++++++++-------------------
 drivers/media/dvb-frontends/tc90522.h |  8 ++---
 2 files changed, 34 insertions(+), 38 deletions(-)

diff --git a/drivers/media/dvb-frontends/tc90522.c b/drivers/media/dvb-frontends/tc90522.c
index b35d65c..123f42d 100644
--- a/drivers/media/dvb-frontends/tc90522.c
+++ b/drivers/media/dvb-frontends/tc90522.c
@@ -30,6 +30,7 @@
 #include <linux/kernel.h>
 #include <linux/math64.h>
 #include <linux/dvb/frontend.h>
+#include "dvb_i2c.h"
 #include "dvb_math.h"
 #include "tc90522.h"
 
@@ -39,7 +40,6 @@
 
 struct tc90522_state {
 	struct tc90522_config cfg;
-	struct dvb_frontend fe;
 	struct i2c_client *i2c_client;
 	struct i2c_adapter tuner_i2c;
 
@@ -98,11 +98,6 @@ static int reg_read(struct tc90522_state *state, u8 reg, u8 *val, u8 len)
 	return ret;
 }
 
-static struct tc90522_state *cfg_to_state(struct tc90522_config *c)
-{
-	return container_of(c, struct tc90522_state, cfg);
-}
-
 
 static int tc90522s_set_tsid(struct dvb_frontend *fe)
 {
@@ -512,7 +507,7 @@ static int tc90522_set_frontend(struct dvb_frontend *fe)
 	return 0;
 
 failed:
-	dev_warn(&state->tuner_i2c.dev, "(%s) failed. [adap%d-fe%d]\n",
+	dev_warn(&state->i2c_client->dev, "(%s) failed. [adap%d-fe%d]\n",
 			__func__, fe->dvb->num, fe->id);
 	return ret;
 }
@@ -587,7 +582,7 @@ static int tc90522_sleep(struct dvb_frontend *fe)
 		}
 	}
 	if (ret < 0)
-		dev_warn(&state->tuner_i2c.dev,
+		dev_warn(&state->i2c_client->dev,
 			"(%s) failed. [adap%d-fe%d]\n",
 			__func__, fe->dvb->num, fe->id);
 	return ret;
@@ -620,7 +615,7 @@ static int tc90522_init(struct dvb_frontend *fe)
 		}
 	}
 	if (ret < 0) {
-		dev_warn(&state->tuner_i2c.dev,
+		dev_warn(&state->i2c_client->dev,
 			"(%s) failed. [adap%d-fe%d]\n",
 			__func__, fe->dvb->num, fe->id);
 		return ret;
@@ -640,6 +635,7 @@ static int tc90522_init(struct dvb_frontend *fe)
 static int
 tc90522_master_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 {
+	struct dvb_frontend *fe;
 	struct tc90522_state *state;
 	struct i2c_msg *new_msgs;
 	int i, j;
@@ -658,7 +654,8 @@ tc90522_master_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 	if (!new_msgs)
 		return -ENOMEM;
 
-	state = i2c_get_adapdata(adap);
+	fe = i2c_get_adapdata(adap);
+	state = fe->demodulator_priv;
 	p = wbuf;
 	bufend = wbuf + sizeof(wbuf);
 	for (i = 0, j = 0; i < num; i++, j++) {
@@ -766,51 +763,51 @@ static const struct dvb_frontend_ops tc90522_ops_ter = {
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
+	fe = i2c_get_clientdata(client);
+	state = fe->demodulator_priv;
 	state->i2c_client = client;
 
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
 
@@ -820,18 +817,17 @@ static const struct i2c_device_id tc90522_id[] = {
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
2.2.2

