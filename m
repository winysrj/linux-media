Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx.socionext.com ([202.248.49.38]:16358 "EHLO mx.socionext.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731193AbeGRBmQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Jul 2018 21:42:16 -0400
From: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        linux-media@vger.kernel.org
Cc: Masami Hiramatsu <masami.hiramatsu@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
Subject: [PATCH v5] media: helene: add I2C device probe function
Date: Wed, 18 Jul 2018 10:06:42 +0900
Message-Id: <20180718010642.18654-1-suzuki.katsuhiro@socionext.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds I2C probe function to use dvb_module_probe() with
this driver. And also support multiple delivery systems at the
same device.

Signed-off-by: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>

---

Changes since v4:
  - Fix wrong max/min frequency range
  - Depends on Mauro's DVB core fixes
    https://patchwork.linuxtv.org/patch/50886/
    https://patchwork.linuxtv.org/patch/50887/
    https://patchwork.linuxtv.org/patch/50888/

Changes since v3:
  - Drop wrong patch 2/2 from v3 series, no changes in this patch

Changes since v2:
  - Nothing

Changes since v1:
  - Add documents for dvb_frontend member of helene_config
---
 drivers/media/dvb-frontends/helene.c | 88 ++++++++++++++++++++++++++--
 drivers/media/dvb-frontends/helene.h |  3 +
 2 files changed, 87 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-frontends/helene.c b/drivers/media/dvb-frontends/helene.c
index dc70fb684681..d7790cb98a0c 100644
--- a/drivers/media/dvb-frontends/helene.c
+++ b/drivers/media/dvb-frontends/helene.c
@@ -666,7 +666,7 @@ static int helene_set_params_s(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int helene_set_params(struct dvb_frontend *fe)
+static int helene_set_params_t(struct dvb_frontend *fe)
 {
 	u8 data[MAX_WRITE_REGSIZE];
 	u32 frequency;
@@ -835,6 +835,19 @@ static int helene_set_params(struct dvb_frontend *fe)
 	return 0;
 }
 
+static int helene_set_params(struct dvb_frontend *fe)
+{
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
+
+	if (p->delivery_system == SYS_DVBT ||
+	    p->delivery_system == SYS_DVBT2 ||
+	    p->delivery_system == SYS_ISDBT ||
+	    p->delivery_system == SYS_DVBC_ANNEX_A)
+		return helene_set_params_t(fe);
+
+	return helene_set_params_s(fe);
+}
+
 static int helene_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 {
 	struct helene_priv *priv = fe->tuner_priv;
@@ -843,7 +856,7 @@ static int helene_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 	return 0;
 }
 
-static const struct dvb_tuner_ops helene_tuner_ops = {
+static const struct dvb_tuner_ops helene_tuner_ops_t = {
 	.info = {
 		.name = "Sony HELENE Ter tuner",
 		.frequency_min_hz  =    1 * MHz,
@@ -853,7 +866,7 @@ static const struct dvb_tuner_ops helene_tuner_ops = {
 	.init = helene_init,
 	.release = helene_release,
 	.sleep = helene_sleep,
-	.set_params = helene_set_params,
+	.set_params = helene_set_params_t,
 	.get_frequency = helene_get_frequency,
 };
 
@@ -871,6 +884,20 @@ static const struct dvb_tuner_ops helene_tuner_ops_s = {
 	.get_frequency = helene_get_frequency,
 };
 
+static const struct dvb_tuner_ops helene_tuner_ops = {
+	.info = {
+		.name = "Sony HELENE Sat/Ter tuner",
+		.frequency_min_hz  =    1 * MHz,
+		.frequency_max_hz  = 2500 * MHz,
+		.frequency_step_hz =   25 * kHz,
+	},
+	.init = helene_init,
+	.release = helene_release,
+	.sleep = helene_sleep,
+	.set_params = helene_set_params,
+	.get_frequency = helene_get_frequency,
+};
+
 /* power-on tuner
  * call once after reset
  */
@@ -1035,7 +1062,7 @@ struct dvb_frontend *helene_attach(struct dvb_frontend *fe,
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 0);
 
-	memcpy(&fe->ops.tuner_ops, &helene_tuner_ops,
+	memcpy(&fe->ops.tuner_ops, &helene_tuner_ops_t,
 			sizeof(struct dvb_tuner_ops));
 	fe->tuner_priv = priv;
 	dev_info(&priv->i2c->dev,
@@ -1045,6 +1072,59 @@ struct dvb_frontend *helene_attach(struct dvb_frontend *fe,
 }
 EXPORT_SYMBOL(helene_attach);
 
+static int helene_probe(struct i2c_client *client,
+			const struct i2c_device_id *id)
+{
+	struct helene_config *config = client->dev.platform_data;
+	struct dvb_frontend *fe = config->fe;
+	struct device *dev = &client->dev;
+	struct helene_priv *priv;
+
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->i2c_address = client->addr;
+	priv->i2c = client->adapter;
+	priv->set_tuner_data = config->set_tuner_priv;
+	priv->set_tuner = config->set_tuner_callback;
+	priv->xtal = config->xtal;
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+
+	if (helene_x_pon(priv) != 0)
+		return -EINVAL;
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+
+	memcpy(&fe->ops.tuner_ops, &helene_tuner_ops,
+	       sizeof(struct dvb_tuner_ops));
+	fe->tuner_priv = priv;
+	i2c_set_clientdata(client, priv);
+
+	dev_info(dev, "Sony HELENE attached on addr=%x at I2C adapter %p\n",
+		 priv->i2c_address, priv->i2c);
+
+	return 0;
+}
+
+static const struct i2c_device_id helene_id[] = {
+	{ "helene", },
+	{}
+};
+MODULE_DEVICE_TABLE(i2c, helene_id);
+
+static struct i2c_driver helene_driver = {
+	.driver = {
+		.name = "helene",
+	},
+	.probe    = helene_probe,
+	.id_table = helene_id,
+};
+module_i2c_driver(helene_driver);
+
 MODULE_DESCRIPTION("Sony HELENE Sat/Ter tuner driver");
 MODULE_AUTHOR("Abylay Ospan <aospan@netup.ru>");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/dvb-frontends/helene.h b/drivers/media/dvb-frontends/helene.h
index c9fc81c7e4e7..8562d01bc93e 100644
--- a/drivers/media/dvb-frontends/helene.h
+++ b/drivers/media/dvb-frontends/helene.h
@@ -39,6 +39,7 @@ enum helene_xtal {
  * @set_tuner_callback:	Callback function that notifies the parent driver
  *			which tuner is active now
  * @xtal: Cristal frequency as described by &enum helene_xtal
+ * @fe: Frontend for which connects this tuner
  */
 struct helene_config {
 	u8	i2c_address;
@@ -46,6 +47,8 @@ struct helene_config {
 	void	*set_tuner_priv;
 	int	(*set_tuner_callback)(void *, int);
 	enum helene_xtal xtal;
+
+	struct dvb_frontend *fe;
 };
 
 #if IS_REACHABLE(CONFIG_DVB_HELENE)
-- 
2.18.0
