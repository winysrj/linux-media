Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43852 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755068AbaLWUu1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 15:50:27 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 03/66] rtl28xxu: switch rtl2832 demod attach to I2C binding
Date: Tue, 23 Dec 2014 22:48:56 +0200
Message-Id: <1419367799-14263-3-git-send-email-crope@iki.fi>
In-Reply-To: <1419367799-14263-1-git-send-email-crope@iki.fi>
References: <1419367799-14263-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As rtl2832 driver support now I2C binding we will switch to that one.

Tested-by: Benjamin Larsson <benjamin@southpole.se>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 29 ++++++++++++++++++++++++++---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.h |  1 +
 2 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 73580f8..2165734 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -790,7 +790,10 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 	int ret;
 	struct dvb_usb_device *d = adap_to_d(adap);
 	struct rtl28xxu_priv *priv = d_to_priv(d);
+	struct rtl2832_platform_data platform_data;
 	const struct rtl2832_config *rtl2832_config;
+	struct i2c_board_info board_info = {};
+	struct i2c_client *client;
 
 	dev_dbg(&d->udev->dev, "%s:\n", __func__);
 
@@ -823,12 +826,26 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 	}
 
 	/* attach demodulator */
-	adap->fe[0] = dvb_attach(rtl2832_attach, rtl2832_config, &d->i2c_adap);
-	if (!adap->fe[0]) {
+	platform_data.config = rtl2832_config;
+	platform_data.dvb_frontend = &adap->fe[0];
+	strlcpy(board_info.type, "rtl2832", I2C_NAME_SIZE);
+	board_info.addr = 0x10;
+	board_info.platform_data = &platform_data;
+	request_module("%s", board_info.type);
+	client = i2c_new_device(&d->i2c_adap, &board_info);
+	if (client == NULL || client->dev.driver == NULL) {
+		ret = -ENODEV;
+		goto err;
+	}
+
+	if (!try_module_get(client->dev.driver->owner)) {
+		i2c_unregister_device(client);
 		ret = -ENODEV;
 		goto err;
 	}
 
+	priv->i2c_client_demod = client;
+
 	/* RTL2832 I2C repeater */
 	priv->demod_i2c_adapter = rtl2832_get_i2c_adapter(adap->fe[0]);
 
@@ -837,7 +854,6 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 
 	if (priv->slave_demod) {
 		struct i2c_board_info info = {};
-		struct i2c_client *client;
 
 		/*
 		 * We continue on reduced mode, without DVB-T2/C, using master
@@ -1190,6 +1206,13 @@ static void rtl28xxu_exit(struct dvb_usb_device *d)
 		i2c_unregister_device(client);
 	}
 
+	/* remove I2C demod */
+	client = priv->i2c_client_demod;
+	if (client) {
+		module_put(client->dev.driver->owner);
+		i2c_unregister_device(client);
+	}
+
 	return;
 }
 
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.h b/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
index 3e3ea9d..e52a2b7 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
@@ -57,6 +57,7 @@ struct rtl28xxu_priv {
 	u8 page; /* integrated demod active register page */
 	struct i2c_adapter *demod_i2c_adapter;
 	bool rc_active;
+	struct i2c_client *i2c_client_demod;
 	struct i2c_client *i2c_client_tuner;
 	struct i2c_client *i2c_client_slave_demod;
 	#define SLAVE_DEMOD_NONE           0
-- 
http://palosaari.fi/

