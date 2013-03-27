Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:38916 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218Ab3C0UIY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Mar 2013 16:08:24 -0400
Message-ID: <1364414899.3909.25.camel@samsungRC530>
Subject: [patch 2/2] media: radio-ma901: return ENODEV in probe if
 usb_device doesn't match
From: Alexey Klimov <klimov.linux@gmail.com>
To: mchehab@redhat.com
Cc: jkosina@suse.cz, linux-input@vger.kernel.org,
	linux@wagner-budenheim.de, klimov.linux@gmail.com,
	linux-media@vger.kernel.org
Date: Thu, 28 Mar 2013 00:08:19 +0400
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Masterkit MA901 usb radio device shares USB ID with Atmel V-USB devices.
This patch adds additional checks in usb_ma901radio_probe() and if
product or manufacturer doesn't match we return -ENODEV and don't
continue. This allows hid drivers to handle not MA901 device.

Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>

diff --git a/drivers/media/radio/radio-ma901.c b/drivers/media/radio/radio-ma901.c
index c61f590..348dafc 100644
--- a/drivers/media/radio/radio-ma901.c
+++ b/drivers/media/radio/radio-ma901.c
@@ -347,9 +347,20 @@ static void usb_ma901radio_release(struct v4l2_device *v4l2_dev)
 static int usb_ma901radio_probe(struct usb_interface *intf,
 				const struct usb_device_id *id)
 {
+	struct usb_device *dev = interface_to_usbdev(intf);
 	struct ma901radio_device *radio;
 	int retval = 0;
 
+	/* Masterkit MA901 usb radio has the same USB ID as many others
+	 * Atmel V-USB devices. Let's make additional checks to be sure
+	 * that this is our device.
+	 */
+
+	if (dev->product && dev->manufacturer &&
+		(strncmp(dev->product, "MA901", 5) != 0
+		|| strncmp(dev->manufacturer, "www.masterkit.ru", 16) != 0))
+		return -ENODEV;
+
 	radio = kzalloc(sizeof(struct ma901radio_device), GFP_KERNEL);
 	if (!radio) {
 		dev_err(&intf->dev, "kzalloc for ma901radio_device failed\n");


