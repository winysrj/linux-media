Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55659 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756203AbaKLEXX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Nov 2014 23:23:23 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 6/8] rtl28xxu: rename tuner I2C client pointer
Date: Wed, 12 Nov 2014 06:23:08 +0200
Message-Id: <1415766190-24482-7-git-send-email-crope@iki.fi>
In-Reply-To: <1415766190-24482-1-git-send-email-crope@iki.fi>
References: <1415766190-24482-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Better to rename tuner I2C to something which clearly says it is
for tuner as there is now multiple different I2C clients used.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 6 +++---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 93f8afc..47360d3 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1094,7 +1094,7 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 				break;
 			}
 
-			priv->client = client;
+			priv->i2c_client_tuner = client;
 			sd = i2c_get_clientdata(client);
 			i2c_set_adapdata(i2c_adap_internal, d);
 
@@ -1153,7 +1153,7 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 				priv->tuner);
 	}
 
-	if (fe == NULL && priv->client == NULL) {
+	if (fe == NULL && priv->i2c_client_tuner == NULL) {
 		ret = -ENODEV;
 		goto err;
 	}
@@ -1206,7 +1206,7 @@ static void rtl28xxu_exit(struct dvb_usb_device *d)
 	dev_dbg(&d->udev->dev, "%s:\n", __func__);
 
 	/* remove I2C tuner */
-	client = priv->client;
+	client = priv->i2c_client_tuner;
 	if (client) {
 		module_put(client->dev.driver->owner);
 		i2c_unregister_device(client);
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.h b/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
index 9c059ac..bfc0b57 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
@@ -57,7 +57,7 @@ struct rtl28xxu_priv {
 	u8 page; /* integrated demod active register page */
 	struct i2c_adapter *demod_i2c_adapter;
 	bool rc_active;
-	struct i2c_client *client;
+	struct i2c_client *i2c_client_tuner;
 	struct i2c_client *i2c_client_slave_demod;
 	int (*init)(struct dvb_frontend *fe);
 	#define SLAVE_DEMOD_NONE           0
-- 
http://palosaari.fi/

