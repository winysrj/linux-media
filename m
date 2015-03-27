Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.ispras.ru ([83.149.199.45]:59935 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbbC0WjT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2015 18:39:19 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	ldv-project@linuxtesting.org
Subject: [PATCH] [media] usbvision: fix leak of usb_dev on failure paths in usbvision_probe()
Date: Sat, 28 Mar 2015 01:39:09 +0300
Message-Id: <1427495949-434-1-git-send-email-khoroshilov@ispras.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is no usb_put_dev() on failure paths in usbvision_probe().

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/media/usb/usbvision/usbvision-video.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/media/usb/usbvision/usbvision-video.c b/drivers/media/usb/usbvision/usbvision-video.c
index cd2fbf11e3b4..239d0e0ca087 100644
--- a/drivers/media/usb/usbvision/usbvision-video.c
+++ b/drivers/media/usb/usbvision/usbvision-video.c
@@ -1525,7 +1525,7 @@ static int usbvision_probe(struct usb_interface *intf,
 	const struct usb_host_interface *interface;
 	struct usb_usbvision *usbvision = NULL;
 	const struct usb_endpoint_descriptor *endpoint;
-	int model, i;
+	int model, i, ret;
 
 	PDEBUG(DBG_PROBE, "VID=%#04x, PID=%#04x, ifnum=%u",
 				dev->descriptor.idVendor,
@@ -1534,7 +1534,8 @@ static int usbvision_probe(struct usb_interface *intf,
 	model = devid->driver_info;
 	if (model < 0 || model >= usbvision_device_data_size) {
 		PDEBUG(DBG_PROBE, "model out of bounds %d", model);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto err_usb;
 	}
 	printk(KERN_INFO "%s: %s found\n", __func__,
 				usbvision_device_data[model].model_string);
@@ -1549,18 +1550,21 @@ static int usbvision_probe(struct usb_interface *intf,
 		    __func__, ifnum);
 		dev_err(&intf->dev, "%s: Endpoint attributes %d",
 		    __func__, endpoint->bmAttributes);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto err_usb;
 	}
 	if (usb_endpoint_dir_out(endpoint)) {
 		dev_err(&intf->dev, "%s: interface %d. has ISO OUT endpoint!\n",
 		    __func__, ifnum);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto err_usb;
 	}
 
 	usbvision = usbvision_alloc(dev, intf);
 	if (usbvision == NULL) {
 		dev_err(&intf->dev, "%s: couldn't allocate USBVision struct\n", __func__);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto err_usb;
 	}
 
 	if (dev->descriptor.bNumConfigurations > 1)
@@ -1579,8 +1583,8 @@ static int usbvision_probe(struct usb_interface *intf,
 	usbvision->alt_max_pkt_size = kmalloc(32 * usbvision->num_alt, GFP_KERNEL);
 	if (usbvision->alt_max_pkt_size == NULL) {
 		dev_err(&intf->dev, "usbvision: out of memory!\n");
-		usbvision_release(usbvision);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto err_pkt;
 	}
 
 	for (i = 0; i < usbvision->num_alt; i++) {
@@ -1615,6 +1619,12 @@ static int usbvision_probe(struct usb_interface *intf,
 
 	PDEBUG(DBG_PROBE, "success");
 	return 0;
+
+err_pkt:
+	usbvision_release(usbvision);
+err_usb:
+	usb_put_dev(dev);
+	return ret;
 }
 
 
-- 
1.9.1

