Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([93.97.41.153]:59338 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676Ab2H1RSd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Aug 2012 13:18:33 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jarod Wilson <jarod@wilsonet.com>, linux-media@vger.kernel.org
Subject: [PATCH] [media] ttusbir: support suspend and resume
Date: Tue, 28 Aug 2012 18:18:32 +0100
Message-Id: <1346174312-27294-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The led is green, not yellow.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ttusbir.c | 48 ++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 44 insertions(+), 4 deletions(-)

diff --git a/drivers/media/rc/ttusbir.c b/drivers/media/rc/ttusbir.c
index 2151927..f0921b5 100644
--- a/drivers/media/rc/ttusbir.c
+++ b/drivers/media/rc/ttusbir.c
@@ -66,11 +66,11 @@ static void ttusbir_set_led(struct ttusbir *tt)
 
 	smp_mb();
 
-	if (tt->led_on != tt->is_led_on &&
+	if (tt->led_on != tt->is_led_on && tt->udev &&
 				atomic_add_unless(&tt->led_complete, 1, 1)) {
 		tt->bulk_buffer[4] = tt->is_led_on = tt->led_on;
 		ret = usb_submit_urb(tt->bulk_urb, GFP_ATOMIC);
-		if (ret && ret != -ENODEV) {
+		if (ret) {
 			dev_warn(tt->dev, "failed to submit bulk urb: %d\n",
 									ret);
 			atomic_dec(&tt->led_complete);
@@ -300,7 +300,7 @@ static int __devinit ttusbir_probe(struct usb_interface *intf,
 		tt->bulk_out_endp), tt->bulk_buffer, sizeof(tt->bulk_buffer),
 						ttusbir_bulk_complete, tt);
 
-	tt->led.name = "ttusbir:yellow:power";
+	tt->led.name = "ttusbir:green:power";
 	tt->led.brightness_set = ttusbir_brightness_set;
 	tt->led.brightness_get = ttusbir_brightness_get;
 	tt->is_led_on = tt->led_on = true;
@@ -370,13 +370,16 @@ out:
 static void __devexit ttusbir_disconnect(struct usb_interface *intf)
 {
 	struct ttusbir *tt = usb_get_intfdata(intf);
+	struct usb_device *udev = tt->udev;
 	int i;
 
+	tt->udev = NULL;
+
 	rc_unregister_device(tt->rc);
 	led_classdev_unregister(&tt->led);
 	for (i = 0; i < NUM_URBS; i++) {
 		usb_kill_urb(tt->urb[i]);
-		usb_free_coherent(tt->udev, 128, tt->urb[i]->transfer_buffer,
+		usb_free_coherent(udev, 128, tt->urb[i]->transfer_buffer,
 						tt->urb[i]->transfer_dma);
 		usb_free_urb(tt->urb[i]);
 	}
@@ -386,6 +389,40 @@ static void __devexit ttusbir_disconnect(struct usb_interface *intf)
 	kfree(tt);
 }
 
+static int ttusbir_suspend(struct usb_interface *intf, pm_message_t message)
+{
+	struct ttusbir *tt = usb_get_intfdata(intf);
+	int i;
+
+	for (i = 0; i < NUM_URBS; i++)
+		usb_kill_urb(tt->urb[i]);
+
+	led_classdev_suspend(&tt->led);
+	usb_kill_urb(tt->bulk_urb);
+
+	return 0;
+}
+
+static int ttusbir_resume(struct usb_interface *intf)
+{
+	struct ttusbir *tt = usb_get_intfdata(intf);
+	int i, rc;
+
+	led_classdev_resume(&tt->led);
+	tt->is_led_on = true;
+	ttusbir_set_led(tt);
+
+	for (i = 0; i < NUM_URBS; i++) {
+		rc = usb_submit_urb(tt->urb[i], GFP_KERNEL);
+		if (rc) {
+			dev_warn(tt->dev, "failed to submit urb: %d\n", rc);
+			break;
+		}
+	}
+
+	return rc;
+}
+
 static const struct usb_device_id ttusbir_table[] = {
 	{ USB_DEVICE(0x0b48, 0x2003) },
 	{ }
@@ -395,6 +432,9 @@ static struct usb_driver ttusbir_driver = {
 	.name = DRIVER_NAME,
 	.id_table = ttusbir_table,
 	.probe = ttusbir_probe,
+	.suspend = ttusbir_suspend,
+	.resume = ttusbir_resume,
+	.reset_resume = ttusbir_resume,
 	.disconnect = __devexit_p(ttusbir_disconnect)
 };
 
-- 
1.7.11.4

