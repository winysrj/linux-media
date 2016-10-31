Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:53389 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S945227AbcJaRwb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 31 Oct 2016 13:52:31 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 4/9] [media] redrat3: fix error paths in probe
Date: Mon, 31 Oct 2016 17:52:22 +0000
Message-Id: <1477936347-9029-5-git-send-email-sean@mess.org>
In-Reply-To: <1477936347-9029-1-git-send-email-sean@mess.org>
References: <1477936347-9029-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If redrat3_delete() is called, ensure ep_in and udev members are set
up so we don't dereference null in the error path. Also ensure that
rc dev device exists before we enable the receiver and that the
led urb exists before we create the led device.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/redrat3.c | 49 ++++++++++++++++++++++------------------------
 1 file changed, 23 insertions(+), 26 deletions(-)

diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 23180ec..eaf374d 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -982,17 +982,19 @@ static int redrat3_dev_probe(struct usb_interface *intf,
 		goto no_endpoints;
 
 	rr3->dev = &intf->dev;
+	rr3->ep_in = ep_in;
+	rr3->ep_out = ep_out;
+	rr3->udev = udev;
 
 	/* set up bulk-in endpoint */
 	rr3->read_urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (!rr3->read_urb)
-		goto error;
+		goto redrat_free;
 
-	rr3->ep_in = ep_in;
 	rr3->bulk_in_buf = usb_alloc_coherent(udev,
 		le16_to_cpu(ep_in->wMaxPacketSize), GFP_KERNEL, &rr3->dma_in);
 	if (!rr3->bulk_in_buf)
-		goto error;
+		goto redrat_free;
 
 	pipe = usb_rcvbulkpipe(udev, ep_in->bEndpointAddress);
 	usb_fill_bulk_urb(rr3->read_urb, udev, pipe, rr3->bulk_in_buf,
@@ -1000,34 +1002,16 @@ static int redrat3_dev_probe(struct usb_interface *intf,
 	rr3->read_urb->transfer_dma = rr3->dma_in;
 	rr3->read_urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 
-	rr3->ep_out = ep_out;
-	rr3->udev = udev;
-
 	redrat3_reset(rr3);
 	redrat3_get_firmware_rev(rr3);
 
-	/* might be all we need to do? */
-	retval = redrat3_enable_detector(rr3);
-	if (retval < 0)
-		goto error;
-
 	/* default.. will get overridden by any sends with a freq defined */
 	rr3->carrier = 38000;
 
-	/* led control */
-	rr3->led.name = "redrat3:red:feedback";
-	rr3->led.default_trigger = "rc-feedback";
-	rr3->led.brightness_set = redrat3_brightness_set;
-	retval = led_classdev_register(&intf->dev, &rr3->led);
-	if (retval)
-		goto error;
-
 	atomic_set(&rr3->flash, 0);
 	rr3->flash_urb = usb_alloc_urb(0, GFP_KERNEL);
-	if (!rr3->flash_urb) {
-		retval = -ENOMEM;
-		goto led_free_error;
-	}
+	if (!rr3->flash_urb)
+		goto redrat_free;
 
 	/* setup packet is 'c0 b9 0000 0000 0001' */
 	rr3->flash_control.bRequestType = 0xc0;
@@ -1039,20 +1023,33 @@ static int redrat3_dev_probe(struct usb_interface *intf,
 			&rr3->flash_in_buf, sizeof(rr3->flash_in_buf),
 			redrat3_led_complete, rr3);
 
+	/* led control */
+	rr3->led.name = "redrat3:red:feedback";
+	rr3->led.default_trigger = "rc-feedback";
+	rr3->led.brightness_set = redrat3_brightness_set;
+	retval = led_classdev_register(&intf->dev, &rr3->led);
+	if (retval)
+		goto redrat_free;
+
 	rr3->rc = redrat3_init_rc_dev(rr3);
 	if (!rr3->rc) {
 		retval = -ENOMEM;
-		goto led_free_error;
+		goto led_free;
 	}
 
+	/* might be all we need to do? */
+	retval = redrat3_enable_detector(rr3);
+	if (retval < 0)
+		goto led_free;
+
 	/* we can register the device now, as it is ready */
 	usb_set_intfdata(intf, rr3);
 
 	return 0;
 
-led_free_error:
+led_free:
 	led_classdev_unregister(&rr3->led);
-error:
+redrat_free:
 	redrat3_delete(rr3, rr3->udev);
 
 no_endpoints:
-- 
2.7.4

