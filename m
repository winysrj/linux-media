Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:50516 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754705AbeCGTX6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Mar 2018 14:23:58 -0500
Received: by mail-wm0-f67.google.com with SMTP id w128so6989421wmw.0
        for <linux-media@vger.kernel.org>; Wed, 07 Mar 2018 11:23:57 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH 3/4] [media] ddbridge: use common DVB I2C client handling helpers
Date: Wed,  7 Mar 2018 20:23:49 +0100
Message-Id: <20180307192350.930-4-d.scheller.oss@gmail.com>
In-Reply-To: <20180307192350.930-1-d.scheller.oss@gmail.com>
References: <20180307192350.930-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Instead of keeping duplicated I2C client handling construct, make use of
the newly introduced dvb_module_*() helpers. This not only keeps things
way cleaner and removes the need for duplicated I2C client attach code,
but even allows to get rid of some variables that won't help in making
things look cleaner anymore.

The check on a valid ptr on port->en isn't really needed since the cxd2099
driver will set it at a time where it is going to return successfully
from probing.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-ci.c   | 33 ++++++--------------------
 drivers/media/pci/ddbridge/ddbridge-core.c | 37 +++++++-----------------------
 2 files changed, 15 insertions(+), 55 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-ci.c b/drivers/media/pci/ddbridge/ddbridge-ci.c
index 6585ef54ac22..d0ce6a1f1bd0 100644
--- a/drivers/media/pci/ddbridge/ddbridge-ci.c
+++ b/drivers/media/pci/ddbridge/ddbridge-ci.c
@@ -324,34 +324,20 @@ static int ci_cxd2099_attach(struct ddb_port *port, u32 bitrate)
 {
 	struct cxd2099_cfg cxd_cfg = cxd_cfgtmpl;
 	struct i2c_client *client;
-	struct i2c_board_info board_info = {
-		.type = "cxd2099",
-		.addr = 0x40,
-		.platform_data = &cxd_cfg,
-	};
 
 	cxd_cfg.bitrate = bitrate;
 	cxd_cfg.en = &port->en;
 
-	request_module(board_info.type);
-
-	client = i2c_new_device(&port->i2c->adap, &board_info);
-	if (!client || !client->dev.driver)
-		goto err_ret;
-
-	if (!try_module_get(client->dev.driver->owner))
-		goto err_i2c;
-
-	if (!port->en)
-		goto err_i2c;
+	client = dvb_module_probe("cxd2099", "cxd2099", &port->i2c->adap,
+				  0x40, &cxd_cfg);
+	if (!client)
+		goto err;
 
 	port->dvb[0].i2c_client[0] = client;
 	port->en_freedata = 0;
 	return 0;
 
-err_i2c:
-	i2c_unregister_device(client);
-err_ret:
+err:
 	dev_err(port->dev->dev, "CXD2099AR attach failed\n");
 	return -ENODEV;
 }
@@ -385,18 +371,13 @@ int ddb_ci_attach(struct ddb_port *port, u32 bitrate)
 
 void ddb_ci_detach(struct ddb_port *port)
 {
-	struct i2c_client *client;
-
 	if (port->dvb[0].dev)
 		dvb_unregister_device(port->dvb[0].dev);
 	if (port->en) {
 		dvb_ca_en50221_release(port->en);
 
-		client = port->dvb[0].i2c_client[0];
-		if (client) {
-			module_put(client->dev.driver->owner);
-			i2c_unregister_device(client);
-		}
+		dvb_module_release(port->dvb[0].i2c_client[0]);
+		port->dvb[0].i2c_client[0] = NULL;
 
 		/* free alloc'ed memory if needed */
 		if (port->en_freedata)
diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index f9bee36f1cad..36d2deb1c106 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -999,37 +999,22 @@ static int tuner_attach_tda18212(struct ddb_input *input, u32 porttype)
 		.if_dvbt2_8 = 4000,
 		.if_dvbc = 5000,
 	};
-	struct i2c_board_info board_info = {
-		.type = "tda18212",
-		.platform_data = &config,
-	};
-
-	if (input->nr & 1)
-		board_info.addr = 0x63;
-	else
-		board_info.addr = 0x60;
+	u8 addr = (input->nr & 1) ? 0x63 : 0x60;
 
 	/* due to a hardware quirk with the I2C gate on the stv0367+tda18212
 	 * combo, the tda18212 must be probed by reading it's id _twice_ when
 	 * cold started, or it very likely will fail.
 	 */
 	if (porttype == DDB_TUNER_DVBCT_ST)
-		tuner_tda18212_ping(input, board_info.addr);
-
-	request_module(board_info.type);
-
-	/* perform tuner init/attach */
-	client = i2c_new_device(adapter, &board_info);
-	if (!client || !client->dev.driver)
-		goto err;
+		tuner_tda18212_ping(input, addr);
 
-	if (!try_module_get(client->dev.driver->owner)) {
-		i2c_unregister_device(client);
+	/* perform tuner probe/init/attach */
+	client = dvb_module_probe("tda18212", "tda18212",
+				  adapter, addr, &config);
+	if (!client)
 		goto err;
-	}
 
 	dvb->i2c_client[0] = client;
-
 	return 0;
 err:
 	dev_err(dev, "TDA18212 tuner not found. Device is not fully operational.\n");
@@ -1253,7 +1238,6 @@ static void dvb_input_detach(struct ddb_input *input)
 {
 	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
 	struct dvb_demux *dvbdemux = &dvb->demux;
-	struct i2c_client *client;
 
 	switch (dvb->attached) {
 	case 0x31:
@@ -1263,13 +1247,8 @@ static void dvb_input_detach(struct ddb_input *input)
 			dvb_unregister_frontend(dvb->fe);
 		/* fallthrough */
 	case 0x30:
-		client = dvb->i2c_client[0];
-		if (client) {
-			module_put(client->dev.driver->owner);
-			i2c_unregister_device(client);
-			dvb->i2c_client[0] = NULL;
-			client = NULL;
-		}
+		dvb_module_release(dvb->i2c_client[0]);
+		dvb->i2c_client[0] = NULL;
 
 		if (dvb->fe2)
 			dvb_frontend_detach(dvb->fe2);
-- 
2.16.1
