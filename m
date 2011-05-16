Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44044 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535Ab1EPWZb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 May 2011 18:25:31 -0400
Received: by wya21 with SMTP id 21so3797871wya.19
        for <linux-media@vger.kernel.org>; Mon, 16 May 2011 15:25:30 -0700 (PDT)
Subject: [PATCH ] v1.87 DM04/QQBOX provide error frontend detach/memory
 release.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 May 2011 23:25:23 +0100
Message-ID: <1305584723.2481.13.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Remove and free any unused frontend attach on firmware change
 and provide memory release using priv_exit callback.

Other minor changes
fix le16 warning.
remove unnecessary lme2510_kill_urb.

Moving of rc_core is still on TODO list.

Requires Patch: dvb-usb provide exit any structure inside priv.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/dvb-usb/lmedm04.c |   93 +++++++++++++----------------------
 1 files changed, 34 insertions(+), 59 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/lmedm04.c b/drivers/media/dvb/dvb-usb/lmedm04.c
index f36f471..c636149 100644
--- a/drivers/media/dvb/dvb-usb/lmedm04.c
+++ b/drivers/media/dvb/dvb-usb/lmedm04.c
@@ -831,7 +831,7 @@ static int lme_firmware_switch(struct usb_device *udev, int cold)
 
 	cold_fw = !cold;
 
-	if (udev->descriptor.idProduct == 0x1122) {
+	if (le16_to_cpu(udev->descriptor.idProduct) == 0x1122) {
 		switch (dvb_usb_lme2510_firmware) {
 		default:
 			dvb_usb_lme2510_firmware = TUNER_S0194;
@@ -901,20 +901,6 @@ static int lme_firmware_switch(struct usb_device *udev, int cold)
 	return ret;
 }
 
-static int lme2510_kill_urb(struct usb_data_stream *stream)
-{
-	int i;
-
-	for (i = 0; i < stream->urbs_submitted; i++) {
-		deb_info(3, "killing URB no. %d.", i);
-		/* stop the URB */
-		usb_kill_urb(stream->urb_list[i]);
-	}
-	stream->urbs_submitted = 0;
-
-	return 0;
-}
-
 static struct tda10086_config tda10086_config = {
 	.demod_address = 0x1c,
 	.invert = 0,
@@ -1052,9 +1038,11 @@ static int dm04_lme2510_frontend_attach(struct dvb_usb_adapter *adap)
 	}
 
 
-end:	if (ret) {
-		kfree(adap->fe);
-		adap->fe = NULL;
+end:	if (ret < 0) {
+		if (adap->fe) {
+			dvb_frontend_detach(adap->fe);
+			adap->fe = NULL;
+		}
 		return -ENODEV;
 	}
 
@@ -1126,6 +1114,30 @@ static int lme2510_powerup(struct dvb_usb_device *d, int onoff)
 	return ret;
 }
 
+static int lme2510_priv_exit(struct dvb_usb_device *d)
+{
+	struct lme2510_state *st = d->priv;
+
+	if (st->usb_buffer != NULL) {
+		st->i2c_talk_onoff = 1;
+		st->signal_lock = 0;
+		st->signal_level = 0;
+		st->signal_sn = 0;
+		kfree(st->usb_buffer);
+	}
+
+	if (st->lme_urb != NULL) {
+		usb_kill_urb(st->lme_urb);
+		usb_free_coherent(d->udev, 5000, st->buffer,
+				  st->lme_urb->transfer_dma);
+		info("Interrupt Service Stopped");
+		rc_unregister_device(d->rc_dev);
+		info("Remote Stopped");
+	}
+
+	return 0;
+}
+
 /* DVB USB Driver stuff */
 static struct dvb_usb_device_properties lme2510_properties;
 static struct dvb_usb_device_properties lme2510c_properties;
@@ -1178,6 +1190,7 @@ MODULE_DEVICE_TABLE(usb, lme2510_table);
 static struct dvb_usb_device_properties lme2510_properties = {
 	.caps = DVB_USB_IS_AN_I2C_ADAPTER,
 	.size_of_priv = sizeof(struct lme2510_state),
+	.priv_exit = lme2510_priv_exit,
 	.num_adapters = 1,
 	.adapter = {
 		{
@@ -1220,6 +1233,7 @@ static struct dvb_usb_device_properties lme2510_properties = {
 static struct dvb_usb_device_properties lme2510c_properties = {
 	.caps = DVB_USB_IS_AN_I2C_ADAPTER,
 	.size_of_priv = sizeof(struct lme2510_state),
+	.priv_exit = lme2510_priv_exit,
 	.num_adapters = 1,
 	.adapter = {
 		{
@@ -1258,49 +1272,10 @@ static struct dvb_usb_device_properties lme2510c_properties = {
 	}
 };
 
-static void *lme2510_exit_int(struct dvb_usb_device *d)
-{
-	struct lme2510_state *st = d->priv;
-	struct dvb_usb_adapter *adap = &d->adapter[0];
-	void *buffer = NULL;
-
-	if (adap != NULL) {
-		lme2510_kill_urb(&adap->stream);
-		adap->feedcount = 0;
-	}
-
-	if (st->lme_urb != NULL) {
-		st->i2c_talk_onoff = 1;
-		st->signal_lock = 0;
-		st->signal_level = 0;
-		st->signal_sn = 0;
-		buffer = st->usb_buffer;
-		usb_kill_urb(st->lme_urb);
-		usb_free_coherent(d->udev, 5000, st->buffer,
-				  st->lme_urb->transfer_dma);
-		info("Interrupt Service Stopped");
-		rc_unregister_device(d->rc_dev);
-		info("Remote Stopped");
-	}
-	return buffer;
-}
-
-static void lme2510_exit(struct usb_interface *intf)
-{
-	struct dvb_usb_device *d = usb_get_intfdata(intf);
-	void *usb_buffer;
-
-	if (d != NULL) {
-		usb_buffer = lme2510_exit_int(d);
-		dvb_usb_device_exit(intf);
-		kfree(usb_buffer);
-	}
-}
-
 static struct usb_driver lme2510_driver = {
 	.name		= "LME2510C_DVB-S",
 	.probe		= lme2510_probe,
-	.disconnect	= lme2510_exit,
+	.disconnect	= dvb_usb_device_exit,
 	.id_table	= lme2510_table,
 };
 
@@ -1327,5 +1302,5 @@ module_exit(lme2510_module_exit);
 
 MODULE_AUTHOR("Malcolm Priestley <tvboxspy@gmail.com>");
 MODULE_DESCRIPTION("LME2510(C) DVB-S USB2.0");
-MODULE_VERSION("1.86");
+MODULE_VERSION("1.87");
 MODULE_LICENSE("GPL");
-- 
1.7.4.1

