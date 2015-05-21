Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39871 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161082AbbEUVYL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2015 17:24:11 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3/8] em28xx: add support for DVB SEC I2C client
Date: Fri, 22 May 2015 00:23:53 +0300
Message-Id: <1432243438-12225-3-git-send-email-crope@iki.fi>
In-Reply-To: <1432243438-12225-1-git-send-email-crope@iki.fi>
References: <1432243438-12225-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for DVB SEC (satellite equipment controller) I2C client.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/em28xx/em28xx-dvb.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 5b7c7c88..ef1bfa2 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -96,6 +96,7 @@ struct em28xx_dvb {
 	int			lna_gpio;
 	struct i2c_client	*i2c_client_demod;
 	struct i2c_client	*i2c_client_tuner;
+	struct i2c_client	*i2c_client_sec;
 };
 
 static inline void print_err_status(struct em28xx *dev,
@@ -1729,7 +1730,6 @@ static int em28xx_dvb_fini(struct em28xx *dev)
 	em28xx_info("Closing DVB extension\n");
 
 	dvb = dev->dvb;
-	client = dvb->i2c_client_tuner;
 
 	em28xx_uninit_usb_xfer(dev, EM28XX_DIGITAL_MODE);
 
@@ -1746,7 +1746,15 @@ static int em28xx_dvb_fini(struct em28xx *dev)
 		}
 	}
 
+	/* remove I2C SEC */
+	client = dvb->i2c_client_sec;
+	if (client) {
+		module_put(client->dev.driver->owner);
+		i2c_unregister_device(client);
+	}
+
 	/* remove I2C tuner */
+	client = dvb->i2c_client_tuner;
 	if (client) {
 		module_put(client->dev.driver->owner);
 		i2c_unregister_device(client);
-- 
http://palosaari.fi/

