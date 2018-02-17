Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:50404 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751102AbeBQPDh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 17 Feb 2018 10:03:37 -0500
Received: by mail-wm0-f66.google.com with SMTP id k87so7929422wmi.0
        for <linux-media@vger.kernel.org>; Sat, 17 Feb 2018 07:03:36 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at
Subject: [PATCH v2 3/7] [media] ddbridge: adapt cxd2099 attach to new i2c_client way
Date: Sat, 17 Feb 2018 16:03:24 +0100
Message-Id: <20180217150328.686-4-d.scheller.oss@gmail.com>
In-Reply-To: <20180217150328.686-1-d.scheller.oss@gmail.com>
References: <20180217150328.686-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Change the way the cxd2099 hardware is being attached to the new I2C
client interface way.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 drivers/media/pci/ddbridge/ddbridge-ci.c | 62 +++++++++++++++++++++++++++++---
 drivers/media/pci/ddbridge/ddbridge.h    |  1 +
 2 files changed, 58 insertions(+), 5 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-ci.c b/drivers/media/pci/ddbridge/ddbridge-ci.c
index ed19890710d6..6585ef54ac22 100644
--- a/drivers/media/pci/ddbridge/ddbridge-ci.c
+++ b/drivers/media/pci/ddbridge/ddbridge-ci.c
@@ -172,6 +172,7 @@ static void ci_attach(struct ddb_port *port)
 	memcpy(&ci->en, &en_templ, sizeof(en_templ));
 	ci->en.data = ci;
 	port->en = &ci->en;
+	port->en_freedata = 1;
 	ci->port = port;
 	ci->nr = port->nr - 2;
 }
@@ -304,6 +305,7 @@ static void ci_xo2_attach(struct ddb_port *port)
 	memcpy(&ci->en, &en_xo2_templ, sizeof(en_xo2_templ));
 	ci->en.data = ci;
 	port->en = &ci->en;
+	port->en_freedata = 1;
 	ci->port = port;
 	ci->nr = port->nr - 2;
 	ci->port->creg = 0;
@@ -311,20 +313,58 @@ static void ci_xo2_attach(struct ddb_port *port)
 	write_creg(ci, 0x08, 0x08);
 }
 
-static struct cxd2099_cfg cxd_cfg = {
+static const struct cxd2099_cfg cxd_cfgtmpl = {
 	.bitrate =  72000,
-	.adr     =  0x40,
 	.polarity = 1,
 	.clock_mode = 1,
 	.max_i2c = 512,
 };
 
+static int ci_cxd2099_attach(struct ddb_port *port, u32 bitrate)
+{
+	struct cxd2099_cfg cxd_cfg = cxd_cfgtmpl;
+	struct i2c_client *client;
+	struct i2c_board_info board_info = {
+		.type = "cxd2099",
+		.addr = 0x40,
+		.platform_data = &cxd_cfg,
+	};
+
+	cxd_cfg.bitrate = bitrate;
+	cxd_cfg.en = &port->en;
+
+	request_module(board_info.type);
+
+	client = i2c_new_device(&port->i2c->adap, &board_info);
+	if (!client || !client->dev.driver)
+		goto err_ret;
+
+	if (!try_module_get(client->dev.driver->owner))
+		goto err_i2c;
+
+	if (!port->en)
+		goto err_i2c;
+
+	port->dvb[0].i2c_client[0] = client;
+	port->en_freedata = 0;
+	return 0;
+
+err_i2c:
+	i2c_unregister_device(client);
+err_ret:
+	dev_err(port->dev->dev, "CXD2099AR attach failed\n");
+	return -ENODEV;
+}
+
 int ddb_ci_attach(struct ddb_port *port, u32 bitrate)
 {
+	int ret;
+
 	switch (port->type) {
 	case DDB_CI_EXTERNAL_SONY:
-		cxd_cfg.bitrate = bitrate;
-		port->en = cxd2099_attach(&cxd_cfg, port, &port->i2c->adap);
+		ret = ci_cxd2099_attach(port, bitrate);
+		if (ret)
+			return -ENODEV;
 		break;
 	case DDB_CI_EXTERNAL_XO2:
 	case DDB_CI_EXTERNAL_XO2_B:
@@ -345,11 +385,23 @@ int ddb_ci_attach(struct ddb_port *port, u32 bitrate)
 
 void ddb_ci_detach(struct ddb_port *port)
 {
+	struct i2c_client *client;
+
 	if (port->dvb[0].dev)
 		dvb_unregister_device(port->dvb[0].dev);
 	if (port->en) {
 		dvb_ca_en50221_release(port->en);
-		kfree(port->en->data);
+
+		client = port->dvb[0].i2c_client[0];
+		if (client) {
+			module_put(client->dev.driver->owner);
+			i2c_unregister_device(client);
+		}
+
+		/* free alloc'ed memory if needed */
+		if (port->en_freedata)
+			kfree(port->en->data);
+
 		port->en = NULL;
 	}
 }
diff --git a/drivers/media/pci/ddbridge/ddbridge.h b/drivers/media/pci/ddbridge/ddbridge.h
index 095457737bc1..f223dc6c9963 100644
--- a/drivers/media/pci/ddbridge/ddbridge.h
+++ b/drivers/media/pci/ddbridge/ddbridge.h
@@ -276,6 +276,7 @@ struct ddb_port {
 	struct ddb_input      *input[2];
 	struct ddb_output     *output;
 	struct dvb_ca_en50221 *en;
+	u8                     en_freedata;
 	struct ddb_dvb         dvb[2];
 	u32                    gap;
 	u32                    obr;
-- 
2.13.6
