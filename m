Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:56278 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519AbaKHLfL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Nov 2014 06:35:11 -0500
Received: by mail-pd0-f182.google.com with SMTP id fp1so4912871pdb.13
        for <linux-media@vger.kernel.org>; Sat, 08 Nov 2014 03:35:10 -0800 (PST)
Date: Sat, 8 Nov 2014 19:35:08 +0800
From: "Nibble Max" <nibble.max@gmail.com>
To: "Olli Salonen" <olli.salonen@iki.fi>
Cc: "linux-media" <linux-media@vger.kernel.org>,
	"Antti Palosaari" <crope@iki.fi>
Subject: [PATCH v2 1/2] smipcie: use add_i2c_client and del_i2c_client functions.
Message-ID: <201411081935055005215@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v2:
-no change, just resend with other patches.

"add_i2c_client" and "del_i2c_client" functions make code shorter and easy to maintain.

Signed-off-by: Nibble Max <nibble.max@gmail.com>
---
 drivers/media/pci/smipcie/smipcie.c | 69 +++++++++++++++++++++----------------
 1 file changed, 40 insertions(+), 29 deletions(-)

diff --git a/drivers/media/pci/smipcie/smipcie.c b/drivers/media/pci/smipcie/smipcie.c
index d1c1463..c27e45b 100644
--- a/drivers/media/pci/smipcie/smipcie.c
+++ b/drivers/media/pci/smipcie/smipcie.c
@@ -477,6 +477,33 @@ static irqreturn_t smi_irq_handler(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+static struct i2c_client *smi_add_i2c_client(struct i2c_adapter *adapter,
+			struct i2c_board_info *info)
+{
+	struct i2c_client *client;
+
+	request_module(info->type);
+	client = i2c_new_device(adapter, info);
+	if (client == NULL || client->dev.driver == NULL)
+		goto err_add_i2c_client;
+
+	if (!try_module_get(client->dev.driver->owner)) {
+		i2c_unregister_device(client);
+		goto err_add_i2c_client;
+	}
+	return client;
+
+err_add_i2c_client:
+	client = NULL;
+	return client;
+}
+
+static void smi_del_i2c_client(struct i2c_client *client)
+{
+	module_put(client->dev.driver->owner);
+	i2c_unregister_device(client);
+}
+
 static const struct m88ds3103_config smi_dvbsky_m88ds3103_cfg = {
 	.i2c_addr = 0x68,
 	.clock = 27000000,
@@ -517,18 +544,12 @@ static int smi_dvbsky_m88ds3103_fe_attach(struct smi_port *port)
 	strlcpy(tuner_info.type, "m88ts2022", I2C_NAME_SIZE);
 	tuner_info.addr = 0x60;
 	tuner_info.platform_data = &m88ts2022_config;
-	request_module("m88ts2022");
-	tuner_client = i2c_new_device(tuner_i2c_adapter, &tuner_info);
-	if (tuner_client == NULL || tuner_client->dev.driver == NULL) {
+	tuner_client = smi_add_i2c_client(tuner_i2c_adapter, &tuner_info);
+	if (!tuner_client) {
 		ret = -ENODEV;
 		goto err_tuner_i2c_device;
 	}
 
-	if (!try_module_get(tuner_client->dev.driver->owner)) {
-		ret = -ENODEV;
-		goto err_tuner_i2c_module;
-	}
-
 	/* delegate signal strength measurement to tuner */
 	port->fe->ops.read_signal_strength =
 			port->fe->ops.tuner_ops.get_rf_strength;
@@ -536,8 +557,6 @@ static int smi_dvbsky_m88ds3103_fe_attach(struct smi_port *port)
 	port->i2c_client_tuner = tuner_client;
 	return ret;
 
-err_tuner_i2c_module:
-	i2c_unregister_device(tuner_client);
 err_tuner_i2c_device:
 	dvb_frontend_detach(port->fe);
 	return ret;
@@ -581,18 +600,12 @@ static int smi_dvbsky_m88rs6000_fe_attach(struct smi_port *port)
 	strlcpy(tuner_info.type, "m88rs6000t", I2C_NAME_SIZE);
 	tuner_info.addr = 0x21;
 	tuner_info.platform_data = &m88rs6000t_config;
-	request_module("m88rs6000t");
-	tuner_client = i2c_new_device(tuner_i2c_adapter, &tuner_info);
-	if (tuner_client == NULL || tuner_client->dev.driver == NULL) {
+	tuner_client = smi_add_i2c_client(tuner_i2c_adapter, &tuner_info);
+	if (!tuner_client) {
 		ret = -ENODEV;
 		goto err_tuner_i2c_device;
 	}
 
-	if (!try_module_get(tuner_client->dev.driver->owner)) {
-		ret = -ENODEV;
-		goto err_tuner_i2c_module;
-	}
-
 	/* delegate signal strength measurement to tuner */
 	port->fe->ops.read_signal_strength =
 			port->fe->ops.tuner_ops.get_rf_strength;
@@ -600,8 +613,6 @@ static int smi_dvbsky_m88rs6000_fe_attach(struct smi_port *port)
 	port->i2c_client_tuner = tuner_client;
 	return ret;
 
-err_tuner_i2c_module:
-	i2c_unregister_device(tuner_client);
 err_tuner_i2c_device:
 	dvb_frontend_detach(port->fe);
 	return ret;
@@ -631,7 +642,10 @@ static int smi_fe_init(struct smi_port *port)
 	/* register dvb frontend */
 	ret = dvb_register_frontend(adap, port->fe);
 	if (ret < 0) {
-		i2c_unregister_device(port->i2c_client_tuner);
+		if (port->i2c_client_tuner)
+			smi_del_i2c_client(port->i2c_client_tuner);
+		if (port->i2c_client_demod)
+			smi_del_i2c_client(port->i2c_client_demod);
 		dvb_frontend_detach(port->fe);
 		return ret;
 	}
@@ -645,15 +659,12 @@ static int smi_fe_init(struct smi_port *port)
 
 static void smi_fe_exit(struct smi_port *port)
 {
-	struct i2c_client *tuner_client;
-
 	dvb_unregister_frontend(port->fe);
-	/* remove I2C tuner */
-	tuner_client = port->i2c_client_tuner;
-	if (tuner_client) {
-		module_put(tuner_client->dev.driver->owner);
-		i2c_unregister_device(tuner_client);
-	}
+	/* remove I2C demod and tuner */
+	if (port->i2c_client_tuner)
+		smi_del_i2c_client(port->i2c_client_tuner);
+	if (port->i2c_client_demod)
+		smi_del_i2c_client(port->i2c_client_demod);
 	dvb_frontend_detach(port->fe);
 }

-- 
1.9.1

