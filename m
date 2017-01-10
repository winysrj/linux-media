Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:36416 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932557AbdAJDOV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Jan 2017 22:14:21 -0500
Received: by mail-qt0-f195.google.com with SMTP id l7so14567312qtd.3
        for <linux-media@vger.kernel.org>; Mon, 09 Jan 2017 19:14:21 -0800 (PST)
Date: Mon, 9 Jan 2017 22:14:18 -0500
From: Kevin Cheng <kcheng@gmail.com>
To: hverkuil@xs4all.nl, linux-media@vger.kernel.org
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v3 1/2] [media] lgdt3306a: support i2c mux for use by em28xx
Message-ID: <20170110031416.fjed4nmjxib46zlt@whisper>
References: <693918b2-bfbe-9827-a11a-e1f73f4ac019@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <693918b2-bfbe-9827-a11a-e1f73f4ac019@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds an i2c mux to the lgdt3306a demodulator.  This was done to support
the Hauppauge WinTV-dualHD 01595 USB TV tuner (em28xx), which utilizes two
si2157 tuners behind gate control.

Signed-off-by: Kevin Cheng <kcheng@gmail.com>
---
 drivers/media/dvb-frontends/Kconfig     |   2 +-
 drivers/media/dvb-frontends/lgdt3306a.c | 108 ++++++++++++++++++++++++++++++++
 drivers/media/dvb-frontends/lgdt3306a.h |   4 ++
 3 files changed, 113 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
index c841fa1..16f9afa 100644
--- a/drivers/media/dvb-frontends/Kconfig
+++ b/drivers/media/dvb-frontends/Kconfig
@@ -619,7 +619,7 @@ config DVB_LGDT3305
 
 config DVB_LGDT3306A
 	tristate "LG Electronics LGDT3306A based"
-	depends on DVB_CORE && I2C
+	depends on DVB_CORE && I2C && I2C_MUX
 	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  An ATSC 8VSB and QAM-B 64/256 demodulator module. Say Y when you want
diff --git a/drivers/media/dvb-frontends/lgdt3306a.c b/drivers/media/dvb-frontends/lgdt3306a.c
index 19dca46..c9b1eb3 100644
--- a/drivers/media/dvb-frontends/lgdt3306a.c
+++ b/drivers/media/dvb-frontends/lgdt3306a.c
@@ -22,6 +22,7 @@
 #include <linux/dvb/frontend.h>
 #include "dvb_math.h"
 #include "lgdt3306a.h"
+#include <linux/i2c-mux.h>
 
 
 static int debug;
@@ -65,6 +66,8 @@ struct lgdt3306a_state {
 	enum fe_modulation current_modulation;
 	u32 current_frequency;
 	u32 snr;
+
+	struct i2c_mux_core *muxc;
 };
 
 /*
@@ -2131,6 +2134,111 @@ static const struct dvb_frontend_ops lgdt3306a_ops = {
 	.search               = lgdt3306a_search,
 };
 
+static int lgdt3306a_select(struct i2c_mux_core *muxc, u32 chan)
+{
+	struct i2c_client *client = i2c_mux_priv(muxc);
+	struct lgdt3306a_state *state = i2c_get_clientdata(client);
+
+	return lgdt3306a_i2c_gate_ctrl(&state->frontend, 1);
+}
+
+static int lgdt3306a_deselect(struct i2c_mux_core *muxc, u32 chan)
+{
+	struct i2c_client *client = i2c_mux_priv(muxc);
+	struct lgdt3306a_state *state = i2c_get_clientdata(client);
+
+	return lgdt3306a_i2c_gate_ctrl(&state->frontend, 0);
+}
+
+static int lgdt3306a_probe(struct i2c_client *client,
+		const struct i2c_device_id *id)
+{
+	struct lgdt3306a_config *config;
+	struct lgdt3306a_state *state;
+	struct dvb_frontend *fe;
+	int ret;
+
+	config = kzalloc(sizeof(struct lgdt3306a_config), GFP_KERNEL);
+	if (config == NULL) {
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+	memcpy(config, client->dev.platform_data,
+			sizeof(struct lgdt3306a_config));
+
+	config->i2c_addr = client->addr;
+	fe = lgdt3306a_attach(config, client->adapter);
+	if (fe == NULL) {
+		ret = -ENODEV;
+		goto err_fe;
+	}
+
+	i2c_set_clientdata(client, fe->demodulator_priv);
+	state = fe->demodulator_priv;
+
+	/* create mux i2c adapter for tuner */
+	state->muxc = i2c_mux_alloc(client->adapter, &client->dev,
+				  1, 0, I2C_MUX_LOCKED,
+				  lgdt3306a_select, lgdt3306a_deselect);
+	if (!state->muxc) {
+		ret = -ENOMEM;
+		goto err_kfree;
+	}
+	state->muxc->priv = client;
+	ret = i2c_mux_add_adapter(state->muxc, 0, 0, 0);
+	if (ret)
+		goto err_kfree;
+
+	/* create dvb_frontend */
+	fe->ops.i2c_gate_ctrl = NULL;
+	*config->i2c_adapter = state->muxc->adapter[0];
+	*config->fe = fe;
+
+	return 0;
+
+err_kfree:
+	kfree(state);
+err_fe:
+	kfree(config);
+fail:
+	dev_dbg(&client->dev, "failed=%d\n", ret);
+	return ret;
+}
+
+static int lgdt3306a_remove(struct i2c_client *client)
+{
+	struct lgdt3306a_state *state = i2c_get_clientdata(client);
+
+	i2c_mux_del_adapters(state->muxc);
+
+	state->frontend.ops.release = NULL;
+	state->frontend.demodulator_priv = NULL;
+
+	kfree(state->cfg);
+	kfree(state);
+
+	return 0;
+}
+
+static const struct i2c_device_id lgdt3306a_id_table[] = {
+	{"lgdt3306a", 0},
+	{}
+};
+MODULE_DEVICE_TABLE(i2c, lgdt3306a_id_table);
+
+static struct i2c_driver lgdt3306a_driver = {
+	.driver = {
+		.name                = "lgdt3306a",
+		.suppress_bind_attrs = true,
+	},
+	.probe		= lgdt3306a_probe,
+	.remove		= lgdt3306a_remove,
+	.id_table	= lgdt3306a_id_table,
+};
+
+module_i2c_driver(lgdt3306a_driver);
+
 MODULE_DESCRIPTION("LG Electronics LGDT3306A ATSC/QAM-B Demodulator Driver");
 MODULE_AUTHOR("Fred Richter <frichter@hauppauge.com>");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/dvb-frontends/lgdt3306a.h b/drivers/media/dvb-frontends/lgdt3306a.h
index 9dbb2dc..6ce337e 100644
--- a/drivers/media/dvb-frontends/lgdt3306a.h
+++ b/drivers/media/dvb-frontends/lgdt3306a.h
@@ -56,6 +56,10 @@ struct lgdt3306a_config {
 
 	/* demod clock freq in MHz; 24 or 25 supported */
 	int  xtalMHz;
+
+	/* returned by driver if using i2c bus multiplexing */
+	struct dvb_frontend **fe;
+	struct i2c_adapter **i2c_adapter;
 };
 
 #if IS_REACHABLE(CONFIG_DVB_LGDT3306A)
-- 
2.9.3

