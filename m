Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([80.229.237.210]:47365 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756106Ab3G3XKF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Jul 2013 19:10:05 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	linux-media@vger.kernel.org
Subject: [PATCH 5/5] [media] redrat3: wire up rc feedback led
Date: Wed, 31 Jul 2013 00:00:04 +0100
Message-Id: <1375225204-5082-5-git-send-email-sean@mess.org>
In-Reply-To: <1375225204-5082-1-git-send-email-sean@mess.org>
References: <1375225204-5082-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/Kconfig   |  2 ++
 drivers/media/rc/redrat3.c | 83 ++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 82 insertions(+), 3 deletions(-)

diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index 7fa6b22..11e84bc 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -223,6 +223,8 @@ config IR_REDRAT3
 	tristate "RedRat3 IR Transceiver"
 	depends on USB_ARCH_HAS_HCD
 	depends on RC_CORE
+	select NEW_LEDS
+	select LEDS_CLASS
 	select USB
 	---help---
 	   Say Y here if you want to use a RedRat3 Infrared Transceiver.
diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index ccd267f..094484f 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -47,6 +47,7 @@
 
 #include <asm/unaligned.h>
 #include <linux/device.h>
+#include <linux/leds.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/usb.h>
@@ -186,6 +187,13 @@ struct redrat3_dev {
 	struct rc_dev *rc;
 	struct device *dev;
 
+	/* led control */
+	struct led_classdev led;
+	atomic_t flash;
+	struct usb_ctrlrequest flash_control;
+	struct urb *flash_urb;
+	u8 flash_in_buf;
+
 	/* save off the usb device pointer */
 	struct usb_device *udev;
 
@@ -480,9 +488,9 @@ static inline void redrat3_delete(struct redrat3_dev *rr3,
 {
 	rr3_ftr(rr3->dev, "%s cleaning up\n", __func__);
 	usb_kill_urb(rr3->read_urb);
-
+	usb_kill_urb(rr3->flash_urb);
 	usb_free_urb(rr3->read_urb);
-
+	usb_free_urb(rr3->flash_urb);
 	usb_free_coherent(udev, le16_to_cpu(rr3->ep_in->wMaxPacketSize),
 			  rr3->bulk_in_buf, rr3->dma_in);
 
@@ -850,6 +858,44 @@ out:
 	return ret;
 }
 
+static void redrat3_brightness_set(struct led_classdev *led_dev, enum
+						led_brightness brightness)
+{
+	struct redrat3_dev *rr3 = container_of(led_dev, struct redrat3_dev,
+									led);
+
+	if (brightness != LED_OFF && atomic_cmpxchg(&rr3->flash, 0, 1) == 0) {
+		int ret = usb_submit_urb(rr3->flash_urb, GFP_ATOMIC);
+		if (ret != 0) {
+			dev_dbg(rr3->dev, "%s: unexpected ret of %d\n",
+				__func__, ret);
+			atomic_set(&rr3->flash, 0);
+		}
+	}
+}
+
+static void redrat3_led_complete(struct urb *urb)
+{
+	struct redrat3_dev *rr3 = urb->context;
+
+	switch (urb->status) {
+	case 0:
+		break;
+	case -ECONNRESET:
+	case -ENOENT:
+	case -ESHUTDOWN:
+		usb_unlink_urb(urb);
+		return;
+	case -EPIPE:
+	default:
+		dev_dbg(rr3->dev, "Error: urb status = %d\n", urb->status);
+		break;
+	}
+
+	rr3->led.brightness = LED_OFF;
+	atomic_dec(&rr3->flash);
+}
+
 static struct rc_dev *redrat3_init_rc_dev(struct redrat3_dev *rr3)
 {
 	struct device *dev = rr3->dev;
@@ -993,10 +1039,35 @@ static int redrat3_dev_probe(struct usb_interface *intf,
 	/* default.. will get overridden by any sends with a freq defined */
 	rr3->carrier = 38000;
 
+	/* led control */
+	rr3->led.name = "redrat3:red:feedback";
+	rr3->led.default_trigger = "rc-feedback";
+	rr3->led.brightness_set = redrat3_brightness_set;
+	retval = led_classdev_register(&intf->dev, &rr3->led);
+	if (retval)
+		goto error;
+
+	atomic_set(&rr3->flash, 0);
+	rr3->flash_urb = usb_alloc_urb(0, GFP_KERNEL);
+	if (!rr3->flash_urb) {
+		retval = -ENOMEM;
+		goto led_free_error;
+	}
+
+	/* setup packet is 'c0 b9 0000 0000 0001' */
+	rr3->flash_control.bRequestType = 0xc0;
+	rr3->flash_control.bRequest = RR3_BLINK_LED;
+	rr3->flash_control.wLength = cpu_to_le16(1);
+
+	usb_fill_control_urb(rr3->flash_urb, udev, usb_rcvctrlpipe(udev, 0),
+			(unsigned char *)&rr3->flash_control,
+			&rr3->flash_in_buf, sizeof(rr3->flash_in_buf),
+			redrat3_led_complete, rr3);
+
 	rr3->rc = redrat3_init_rc_dev(rr3);
 	if (!rr3->rc) {
 		retval = -ENOMEM;
-		goto error;
+		goto led_free_error;
 	}
 	setup_timer(&rr3->rx_timeout, redrat3_rx_timeout, (unsigned long)rr3);
 
@@ -1006,6 +1077,8 @@ static int redrat3_dev_probe(struct usb_interface *intf,
 	rr3_ftr(dev, "Exiting %s\n", __func__);
 	return 0;
 
+led_free_error:
+	led_classdev_unregister(&rr3->led);
 error:
 	redrat3_delete(rr3, rr3->udev);
 
@@ -1027,6 +1100,7 @@ static void redrat3_dev_disconnect(struct usb_interface *intf)
 
 	usb_set_intfdata(intf, NULL);
 	rc_unregister_device(rr3->rc);
+	led_classdev_unregister(&rr3->led);
 	del_timer_sync(&rr3->rx_timeout);
 	redrat3_delete(rr3, udev);
 
@@ -1037,7 +1111,9 @@ static int redrat3_dev_suspend(struct usb_interface *intf, pm_message_t message)
 {
 	struct redrat3_dev *rr3 = usb_get_intfdata(intf);
 	rr3_ftr(rr3->dev, "suspend\n");
+	led_classdev_suspend(&rr3->led);
 	usb_kill_urb(rr3->read_urb);
+	usb_kill_urb(rr3->flash_urb);
 	return 0;
 }
 
@@ -1047,6 +1123,7 @@ static int redrat3_dev_resume(struct usb_interface *intf)
 	rr3_ftr(rr3->dev, "resume\n");
 	if (usb_submit_urb(rr3->read_urb, GFP_ATOMIC))
 		return -EIO;
+	led_classdev_resume(&rr3->led);
 	return 0;
 }
 
-- 
1.8.3.1

