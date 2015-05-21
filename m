Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42357 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161086AbbEUVYL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2015 17:24:11 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 5/8] cx23885: add support for DVB I2C SEC client
Date: Fri, 22 May 2015 00:23:55 +0300
Message-Id: <1432243438-12225-5-git-send-email-crope@iki.fi>
In-Reply-To: <1432243438-12225-1-git-send-email-crope@iki.fi>
References: <1432243438-12225-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for I2C SEC (satellite equipment controller) client.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/pci/cx23885/cx23885-dvb.c | 16 ++++++++++++++++
 drivers/media/pci/cx23885/cx23885.h     |  1 +
 2 files changed, 17 insertions(+)

diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index 37fd013..ac062a5 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -1190,6 +1190,7 @@ static int dvb_register(struct cx23885_tsport *port)
 	struct i2c_board_info info;
 	struct i2c_adapter *adapter;
 	struct i2c_client *client_demod = NULL, *client_tuner = NULL;
+	struct i2c_client *client_sec = NULL;
 	const struct m88ds3103_config *p_m88ds3103_config = NULL;
 	int (*p_set_voltage)(struct dvb_frontend *fe, fe_sec_voltage_t voltage) = NULL;
 	int mfe_shared = 0; /* bus not shared by default */
@@ -2242,6 +2243,14 @@ static int dvb_register(struct cx23885_tsport *port)
 	return 0;
 
 frontend_detach:
+	/* remove I2C client for SEC */
+	client_sec = port->i2c_client_sec;
+	if (client_sec) {
+		module_put(client_sec->dev.driver->owner);
+		i2c_unregister_device(client_sec);
+		port->i2c_client_sec = NULL;
+	}
+
 	/* remove I2C client for tuner */
 	client_tuner = port->i2c_client_tuner;
 	if (client_tuner) {
@@ -2343,6 +2352,13 @@ int cx23885_dvb_unregister(struct cx23885_tsport *port)
 		i2c_unregister_device(client);
 	}
 
+	/* remove I2C client for SEC */
+	client = port->i2c_client_sec;
+	if (client) {
+		module_put(client->dev.driver->owner);
+		i2c_unregister_device(client);
+	}
+
 	/* remove I2C client for tuner */
 	client = port->i2c_client_tuner;
 	if (client) {
diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
index aeda8d3..81e2519 100644
--- a/drivers/media/pci/cx23885/cx23885.h
+++ b/drivers/media/pci/cx23885/cx23885.h
@@ -304,6 +304,7 @@ struct cx23885_tsport {
 
 	struct i2c_client *i2c_client_demod;
 	struct i2c_client *i2c_client_tuner;
+	struct i2c_client *i2c_client_sec;
 	struct i2c_client *i2c_client_ci;
 
 	int (*set_frontend)(struct dvb_frontend *fe);
-- 
http://palosaari.fi/

