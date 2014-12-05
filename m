Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:60713 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbaLEK4M (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Dec 2014 05:56:12 -0500
Received: by mail-pd0-f179.google.com with SMTP id fp1so178148pdb.10
        for <linux-media@vger.kernel.org>; Fri, 05 Dec 2014 02:56:12 -0800 (PST)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH 2/5] dvb: mxl301rf: use dvb-core i2c binding model template
Date: Fri,  5 Dec 2014 19:55:37 +0900
Message-Id: <1417776940-16381-3-git-send-email-tskd08@gmail.com>
In-Reply-To: <1417776940-16381-1-git-send-email-tskd08@gmail.com>
References: <1417776940-16381-1-git-send-email-tskd08@gmail.com>
In-Reply-To: <1417776573-16182-1-git-send-email-tskd08@gmail.com>
References: <1417776573-16182-1-git-send-email-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
---
 drivers/media/tuners/mxl301rf.c | 50 +++++++++++------------------------------
 drivers/media/tuners/mxl301rf.h |  2 +-
 2 files changed, 14 insertions(+), 38 deletions(-)

diff --git a/drivers/media/tuners/mxl301rf.c b/drivers/media/tuners/mxl301rf.c
index 1575a5d..d428132 100644
--- a/drivers/media/tuners/mxl301rf.c
+++ b/drivers/media/tuners/mxl301rf.c
@@ -29,6 +29,8 @@
  */
 
 #include <linux/kernel.h>
+#include "dvb_i2c.h"
+
 #include "mxl301rf.h"
 
 struct mxl301rf_state {
@@ -36,11 +38,6 @@ struct mxl301rf_state {
 	struct i2c_client *i2c;
 };
 
-static struct mxl301rf_state *cfg_to_state(struct mxl301rf_config *c)
-{
-	return container_of(c, struct mxl301rf_state, cfg);
-}
-
 static int raw_write(struct mxl301rf_state *state, const u8 *buf, int len)
 {
 	int ret;
@@ -295,54 +292,33 @@ static const struct dvb_tuner_ops mxl301rf_ops = {
 static int mxl301rf_probe(struct i2c_client *client,
 			  const struct i2c_device_id *id)
 {
+	struct dvb_i2c_tuner_config *tcfg;
 	struct mxl301rf_state *state;
-	struct mxl301rf_config *cfg;
-	struct dvb_frontend *fe;
-
-	state = kzalloc(sizeof(*state), GFP_KERNEL);
-	if (!state)
-		return -ENOMEM;
 
+	tcfg = client->dev.platform_data;
+	state = tcfg->fe->tuner_priv;
 	state->i2c = client;
-	cfg = client->dev.platform_data;
 
-	memcpy(&state->cfg, cfg, sizeof(state->cfg));
-	fe = cfg->fe;
-	fe->tuner_priv = state;
-	memcpy(&fe->ops.tuner_ops, &mxl301rf_ops, sizeof(mxl301rf_ops));
+	memcpy(&state->cfg, tcfg->devcfg.priv_cfg, sizeof(state->cfg));
 
-	i2c_set_clientdata(client, &state->cfg);
 	dev_info(&client->dev, "MaxLinear MxL301RF attached.\n");
 	return 0;
 }
 
-static int mxl301rf_remove(struct i2c_client *client)
-{
-	struct mxl301rf_state *state;
-
-	state = cfg_to_state(i2c_get_clientdata(client));
-	state->cfg.fe->tuner_priv = NULL;
-	kfree(state);
-	return 0;
-}
-
-
 static const struct i2c_device_id mxl301rf_id[] = {
 	{"mxl301rf", 0},
 	{}
 };
-MODULE_DEVICE_TABLE(i2c, mxl301rf_id);
 
-static struct i2c_driver mxl301rf_driver = {
-	.driver = {
-		.name	= "mxl301rf",
-	},
-	.probe		= mxl301rf_probe,
-	.remove		= mxl301rf_remove,
-	.id_table	= mxl301rf_id,
+static const struct dvb_i2c_module_param mxl301rf_param = {
+	.ops.tuner_ops = &mxl301rf_ops,
+	.priv_probe = mxl301rf_probe,
+
+	.priv_size = sizeof(struct mxl301rf_state),
+	.is_tuner = true,
 };
 
-module_i2c_driver(mxl301rf_driver);
+DEFINE_DVB_I2C_MODULE(mxl301rf, mxl301rf_id, mxl301rf_param);
 
 MODULE_DESCRIPTION("MaxLinear MXL301RF tuner");
 MODULE_AUTHOR("Akihiro TSUKADA");
diff --git a/drivers/media/tuners/mxl301rf.h b/drivers/media/tuners/mxl301rf.h
index 19e6840..069a6a0 100644
--- a/drivers/media/tuners/mxl301rf.h
+++ b/drivers/media/tuners/mxl301rf.h
@@ -20,7 +20,7 @@
 #include "dvb_frontend.h"
 
 struct mxl301rf_config {
-	struct dvb_frontend *fe;
+	/* none now */
 };
 
 #endif /* MXL301RF_H */
-- 
2.1.3

