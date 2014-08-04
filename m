Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44878 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925AbaHDE3s (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Aug 2014 00:29:48 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/9] ddbridge: I2C client for tda18212
Date: Mon,  4 Aug 2014 07:29:24 +0300
Message-Id: <1407126571-21629-2-git-send-email-crope@iki.fi>
In-Reply-To: <1407126571-21629-1-git-send-email-crope@iki.fi>
References: <1407126571-21629-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Used tda18212 tuner is implemented as a I2C driver. Implement I2C
client to ddbridge and use it for tda18212.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 70 +++++++++++++++++-------------
 drivers/media/pci/ddbridge/ddbridge.h      |  1 +
 2 files changed, 40 insertions(+), 31 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index c66b1b3..ccd6a57 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -834,45 +834,47 @@ static int tuner_attach_tda18271(struct ddb_input *input)
 	return 0;
 }
 
-static struct tda18212_config tda18212_config_60 = {
-	.i2c_address = 0x60,
-	.if_dvbt_6 = 3550,
-	.if_dvbt_7 = 3700,
-	.if_dvbt_8 = 4150,
-	.if_dvbt2_6 = 3250,
-	.if_dvbt2_7 = 4000,
-	.if_dvbt2_8 = 4000,
-	.if_dvbc = 5000,
-};
-
-static struct tda18212_config tda18212_config_63 = {
-	.i2c_address = 0x63,
-	.if_dvbt_6 = 3550,
-	.if_dvbt_7 = 3700,
-	.if_dvbt_8 = 4150,
-	.if_dvbt2_6 = 3250,
-	.if_dvbt2_7 = 4000,
-	.if_dvbt2_8 = 4000,
-	.if_dvbc = 5000,
-};
-
 static int tuner_attach_tda18212(struct ddb_input *input)
 {
-	struct i2c_adapter *i2c = &input->port->i2c->adap;
+	struct i2c_adapter *adapter = &input->port->i2c->adap;
 	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
-	struct dvb_frontend *fe;
-	struct tda18212_config *config;
+	struct i2c_client *client;
+	struct tda18212_config config = {
+		.fe = dvb->fe,
+		.if_dvbt_6 = 3550,
+		.if_dvbt_7 = 3700,
+		.if_dvbt_8 = 4150,
+		.if_dvbt2_6 = 3250,
+		.if_dvbt2_7 = 4000,
+		.if_dvbt2_8 = 4000,
+		.if_dvbc = 5000,
+	};
+	struct i2c_board_info board_info = {
+		.type = "tda18212",
+		.platform_data = &config,
+	};
 
 	if (input->nr & 1)
-		config = &tda18212_config_63;
+		board_info.addr = 0x63;
 	else
-		config = &tda18212_config_60;
+		board_info.addr = 0x60;
 
-	fe = dvb_attach(tda18212_attach, dvb->fe, i2c, config);
-	if (!fe) {
-		pr_err("No TDA18212 found!\n");
-		return -ENODEV;
+	request_module(board_info.type);
+
+	client = i2c_new_device(adapter, &board_info);
+	if (client == NULL || client->dev.driver == NULL)
+		goto err;
+
+	if (!try_module_get(client->dev.driver->owner)) {
+		i2c_unregister_device(client);
+		goto err;
 	}
+
+	dvb->i2c_client[0] = client;
+
+	return 0;
+err:
+	dev_notice(input->port->dev->dev, "TDA18212 tuner not found. Device is not fully operational.\n");
 	return 0;
 }
 
@@ -1059,9 +1061,15 @@ static void dvb_input_detach(struct ddb_input *input)
 {
 	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
 	struct dvb_demux *dvbdemux = &dvb->demux;
+	struct i2c_client *client;
 
 	switch (dvb->attached) {
 	case 0x31:
+		client = dvb->i2c_client[0];
+		if (client) {
+			module_put(client->dev.driver->owner);
+			i2c_unregister_device(client);
+		}
 		if (dvb->fe2)
 			dvb_unregister_frontend(dvb->fe2);
 		if (dvb->fe)
diff --git a/drivers/media/pci/ddbridge/ddbridge.h b/drivers/media/pci/ddbridge/ddbridge.h
index 601cf24..2f98ac6 100644
--- a/drivers/media/pci/ddbridge/ddbridge.h
+++ b/drivers/media/pci/ddbridge/ddbridge.h
@@ -181,6 +181,7 @@ struct ddb_dvb {
 	struct dvb_adapter    *adap;
 	int                    adap_registered;
 	struct dvb_device     *dev;
+	struct i2c_client     *i2c_client[1];
 	struct dvb_frontend   *fe;
 	struct dvb_frontend   *fe2;
 	struct dmxdev          dmxdev;
-- 
http://palosaari.fi/

