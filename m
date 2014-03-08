Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44276 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbaCHMUX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Mar 2014 07:20:23 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 2/2] em28xx-dvb: remove one level of identation at fini callback
Date: Sat,  8 Mar 2014 09:19:37 -0300
Message-Id: <1394281177-5920-2-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1394281177-5920-1-git-send-email-m.chehab@samsung.com>
References: <1394281177-5920-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Simplify the logic a little by removing one level of identation.
Also, it only makes sense to print something if the .fini callback
is actually doing something.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-dvb.c | 48 +++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 22 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index cacdca3a3412..6638394b3457 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -1543,6 +1543,9 @@ static inline void prevent_sleep(struct dvb_frontend_ops *ops)
 
 static int em28xx_dvb_fini(struct em28xx *dev)
 {
+	struct em28xx_dvb *dvb;
+	struct i2c_client *client;
+
 	if (dev->is_audio_only) {
 		/* Shouldn't initialize IR for this interface */
 		return 0;
@@ -1553,35 +1556,36 @@ static int em28xx_dvb_fini(struct em28xx *dev)
 		return 0;
 	}
 
-	em28xx_info("Closing DVB extension");
+	if (!dev->dvb)
+		return 0;
 
-	if (dev->dvb) {
-		struct em28xx_dvb *dvb = dev->dvb;
-		struct i2c_client *client = dvb->i2c_client_tuner;
+	em28xx_info("Closing DVB extension");
 
-		em28xx_uninit_usb_xfer(dev, EM28XX_DIGITAL_MODE);
+	dvb = dev->dvb;
+	client = dvb->i2c_client_tuner;
 
-		if (dev->disconnected) {
-			/* We cannot tell the device to sleep
-			 * once it has been unplugged. */
-			if (dvb->fe[0])
-				prevent_sleep(&dvb->fe[0]->ops);
-			if (dvb->fe[1])
-				prevent_sleep(&dvb->fe[1]->ops);
-		}
+	em28xx_uninit_usb_xfer(dev, EM28XX_DIGITAL_MODE);
 
-		/* remove I2C tuner */
-		if (client) {
-			module_put(client->dev.driver->owner);
-			i2c_unregister_device(client);
-		}
+	if (dev->disconnected) {
+		/* We cannot tell the device to sleep
+		 * once it has been unplugged. */
+		if (dvb->fe[0])
+			prevent_sleep(&dvb->fe[0]->ops);
+		if (dvb->fe[1])
+			prevent_sleep(&dvb->fe[1]->ops);
+	}
 
-		em28xx_unregister_dvb(dvb);
-		kfree(dvb);
-		dev->dvb = NULL;
-		kref_put(&dev->ref, em28xx_free_device);
+	/* remove I2C tuner */
+	if (client) {
+		module_put(client->dev.driver->owner);
+		i2c_unregister_device(client);
 	}
 
+	em28xx_unregister_dvb(dvb);
+	kfree(dvb);
+	dev->dvb = NULL;
+	kref_put(&dev->ref, em28xx_free_device);
+
 	return 0;
 }
 
-- 
1.8.5.3

