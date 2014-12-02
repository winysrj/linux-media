Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51362 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932104AbaLBOcF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Dec 2014 09:32:05 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Benjamin Larsson <benjamin@southpole.se>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3/3] rtl28xxu: change module unregister order
Date: Tue,  2 Dec 2014 16:31:23 +0200
Message-Id: <1417530683-5063-3-git-send-email-crope@iki.fi>
In-Reply-To: <1417530683-5063-1-git-send-email-crope@iki.fi>
References: <1417530683-5063-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We must unregister frontend first and after that driver itself. That
order went wrong after demod drivers were switched to kernel I2C
drivers, causing crashes.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 77 +++++++++++++++++++--------------
 1 file changed, 45 insertions(+), 32 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index de8caf7..93bb7c9 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -916,6 +916,31 @@ err:
 	return ret;
 }
 
+static int rtl2832u_frontend_detach(struct dvb_usb_adapter *adap)
+{
+	struct dvb_usb_device *d = adap_to_d(adap);
+	struct rtl28xxu_priv *priv = d_to_priv(d);
+	struct i2c_client *client;
+
+	dev_dbg(&d->udev->dev, "%s:\n", __func__);
+
+	/* remove I2C slave demod */
+	client = priv->i2c_client_slave_demod;
+	if (client) {
+		module_put(client->dev.driver->owner);
+		i2c_unregister_device(client);
+	}
+
+	/* remove I2C demod */
+	client = priv->i2c_client_demod;
+	if (client) {
+		module_put(client->dev.driver->owner);
+		i2c_unregister_device(client);
+	}
+
+	return 0;
+}
+
 static struct qt1010_config rtl28xxu_qt1010_config = {
 	.i2c_address = 0x62, /* 0xc4 */
 };
@@ -1150,6 +1175,24 @@ err:
 	return ret;
 }
 
+static int rtl2832u_tuner_detach(struct dvb_usb_adapter *adap)
+{
+	struct dvb_usb_device *d = adap_to_d(adap);
+	struct rtl28xxu_priv *priv = d_to_priv(d);
+	struct i2c_client *client;
+
+	dev_dbg(&d->udev->dev, "%s:\n", __func__);
+
+	/* remove I2C tuner */
+	client = priv->i2c_client_tuner;
+	if (client) {
+		module_put(client->dev.driver->owner);
+		i2c_unregister_device(client);
+	}
+
+	return 0;
+}
+
 static int rtl28xxu_init(struct dvb_usb_device *d)
 {
 	int ret;
@@ -1184,37 +1227,6 @@ err:
 	return ret;
 }
 
-static void rtl28xxu_exit(struct dvb_usb_device *d)
-{
-	struct rtl28xxu_priv *priv = d->priv;
-	struct i2c_client *client;
-
-	dev_dbg(&d->udev->dev, "%s:\n", __func__);
-
-	/* remove I2C tuner */
-	client = priv->i2c_client_tuner;
-	if (client) {
-		module_put(client->dev.driver->owner);
-		i2c_unregister_device(client);
-	}
-
-	/* remove I2C slave demod */
-	client = priv->i2c_client_slave_demod;
-	if (client) {
-		module_put(client->dev.driver->owner);
-		i2c_unregister_device(client);
-	}
-
-	/* remove I2C demod */
-	client = priv->i2c_client_demod;
-	if (client) {
-		module_put(client->dev.driver->owner);
-		i2c_unregister_device(client);
-	}
-
-	return;
-}
-
 static int rtl2831u_power_ctrl(struct dvb_usb_device *d, int onoff)
 {
 	int ret;
@@ -1596,9 +1608,10 @@ static const struct dvb_usb_device_properties rtl2832u_props = {
 	.i2c_algo = &rtl28xxu_i2c_algo,
 	.read_config = rtl2832u_read_config,
 	.frontend_attach = rtl2832u_frontend_attach,
+	.frontend_detach = rtl2832u_frontend_detach,
 	.tuner_attach = rtl2832u_tuner_attach,
+	.tuner_detach = rtl2832u_tuner_detach,
 	.init = rtl28xxu_init,
-	.exit = rtl28xxu_exit,
 	.get_rc_config = rtl2832u_get_rc_config,
 
 	.num_adapters = 1,
-- 
http://palosaari.fi/

