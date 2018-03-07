Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:36716 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754706AbeCGTX7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Mar 2018 14:23:59 -0500
Received: by mail-wr0-f194.google.com with SMTP id v111so3334405wrb.3
        for <linux-media@vger.kernel.org>; Wed, 07 Mar 2018 11:23:58 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH 4/4] [media] ngene: use common DVB I2C client handling helpers
Date: Wed,  7 Mar 2018 20:23:50 +0100
Message-Id: <20180307192350.930-5-d.scheller.oss@gmail.com>
In-Reply-To: <20180307192350.930-1-d.scheller.oss@gmail.com>
References: <20180307192350.930-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Like in ddbridge, get rid of all duplicated I2C client handling constructs
and rather make use of the newly added dvb_module_*() helpers. Makes
things more clean and removes the (cosmetic) need for some variables.

The check on a valid ptr on ci->en isn't really needed since the cxd2099
driver will set	it at a	time where it is going to return successfully
from probing.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ngene/ngene-cards.c | 25 ++++----------------
 drivers/media/pci/ngene/ngene-core.c  | 43 ++++++++---------------------------
 2 files changed, 15 insertions(+), 53 deletions(-)

diff --git a/drivers/media/pci/ngene/ngene-cards.c b/drivers/media/pci/ngene/ngene-cards.c
index 37e9f0eb6d20..3ae7da2e9858 100644
--- a/drivers/media/pci/ngene/ngene-cards.c
+++ b/drivers/media/pci/ngene/ngene-cards.c
@@ -253,15 +253,7 @@ static int tuner_attach_tda18212(struct ngene_channel *chan, u32 dmdtype)
 		.if_dvbt2_8 = 4000,
 		.if_dvbc = 5000,
 	};
-	struct i2c_board_info board_info = {
-		.type = "tda18212",
-		.platform_data = &config,
-	};
-
-	if (chan->number & 1)
-		board_info.addr = 0x63;
-	else
-		board_info.addr = 0x60;
+	u8 addr = (chan->number & 1) ? 0x63 : 0x60;
 
 	/*
 	 * due to a hardware quirk with the I2C gate on the stv0367+tda18212
@@ -269,20 +261,13 @@ static int tuner_attach_tda18212(struct ngene_channel *chan, u32 dmdtype)
 	 * cold started, or it very likely will fail.
 	 */
 	if (dmdtype == DEMOD_TYPE_STV0367)
-		tuner_tda18212_ping(chan, i2c, board_info.addr);
-
-	request_module(board_info.type);
+		tuner_tda18212_ping(chan, i2c, addr);
 
-	/* perform tuner init/attach */
-	client = i2c_new_device(i2c, &board_info);
-	if (!client || !client->dev.driver)
+	/* perform tuner probe/init/attach */
+	client = dvb_module_probe("tda18212", "tda18212", i2c, addr, &config);
+	if (!client)
 		goto err;
 
-	if (!try_module_get(client->dev.driver->owner)) {
-		i2c_unregister_device(client);
-		goto err;
-	}
-
 	chan->i2c_client[0] = client;
 	chan->i2c_client_fe = 1;
 
diff --git a/drivers/media/pci/ngene/ngene-core.c b/drivers/media/pci/ngene/ngene-core.c
index f69a8fc1ec2a..bef3c9fd75ce 100644
--- a/drivers/media/pci/ngene/ngene-core.c
+++ b/drivers/media/pci/ngene/ngene-core.c
@@ -1408,7 +1408,6 @@ static void release_channel(struct ngene_channel *chan)
 {
 	struct dvb_demux *dvbdemux = &chan->demux;
 	struct ngene *dev = chan->dev;
-	struct i2c_client *client;
 
 	if (chan->running)
 		set_transfer(chan, 0);
@@ -1427,12 +1426,9 @@ static void release_channel(struct ngene_channel *chan)
 		dvb_unregister_frontend(chan->fe);
 
 		/* release I2C client (tuner) if needed */
-		client = chan->i2c_client[0];
-		if (chan->i2c_client_fe && client) {
-			module_put(client->dev.driver->owner);
-			i2c_unregister_device(client);
+		if (chan->i2c_client_fe) {
+			dvb_module_release(chan->i2c_client[0]);
 			chan->i2c_client[0] = NULL;
-			client = NULL;
 		}
 
 		dvb_frontend_detach(chan->fe);
@@ -1584,11 +1580,6 @@ static void cxd_attach(struct ngene *dev)
 	struct ngene_ci *ci = &dev->ci;
 	struct cxd2099_cfg cxd_cfg = cxd_cfgtmpl;
 	struct i2c_client *client;
-	struct i2c_board_info board_info = {
-		.type = "cxd2099",
-		.addr = 0x40,
-		.platform_data = &cxd_cfg,
-	};
 	int ret;
 	u8 type;
 
@@ -1605,26 +1596,17 @@ static void cxd_attach(struct ngene *dev)
 	}
 
 	cxd_cfg.en = &ci->en;
-
-	request_module(board_info.type);
-
-	client = i2c_new_device(&dev->channel[0].i2c_adapter, &board_info);
-	if (!client || !client->dev.driver)
-		goto err_ret;
-
-	if (!try_module_get(client->dev.driver->owner))
-		goto err_i2c;
-
-	if (!ci->en)
-		goto err_i2c;
+	client = dvb_module_probe("cxd2099", "cxd2099",
+				  &dev->channel[0].i2c_adapter,
+				  0x40, &cxd_cfg);
+	if (!client)
+		goto err;
 
 	ci->dev = dev;
 	dev->channel[0].i2c_client[0] = client;
 	return;
 
-err_i2c:
-	i2c_unregister_device(client);
-err_ret:
+err:
 	dev_err(pdev, "CXD2099AR attach failed\n");
 	return;
 }
@@ -1632,16 +1614,11 @@ static void cxd_attach(struct ngene *dev)
 static void cxd_detach(struct ngene *dev)
 {
 	struct ngene_ci *ci = &dev->ci;
-	struct i2c_client *client;
 
 	dvb_ca_en50221_release(ci->en);
 
-	client = dev->channel[0].i2c_client[0];
-	if (client) {
-		module_put(client->dev.driver->owner);
-		i2c_unregister_device(client);
-	}
-
+	dvb_module_release(dev->channel[0].i2c_client[0]);
+	dev->channel[0].i2c_client[0] = NULL;
 	ci->en = NULL;
 }
 
-- 
2.16.1
