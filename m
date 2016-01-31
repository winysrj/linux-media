Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42892 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757477AbcAaQPD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Jan 2016 11:15:03 -0500
From: Vladis Dronov <vdronov@redhat.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Cc: Vladis Dronov <vdronov@redhat.com>
Subject: [PATCH] [media] usbvision: revert commit 588afcc1
Date: Sun, 31 Jan 2016 17:14:52 +0100
Message-Id: <1454256892-7832-1-git-send-email-vdronov@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Vladis Dronov <vdronov@redhat.com>
---
I believe, commit 588afcc1 should be reverted, concerns being:

* "!dev->actconfig->interface[ifnum]" won't catch a case where
the value is not NULL but some garbage. This way the system may
crash later with GPF.

* "(ifnum >= USB_MAXINTERFACES)" does not cover all the error
conditions. "ifnum" should be compared to "dev->actconfig->
desc.bNumInterfaces", i.e. compared to the number of "struct
usb_interface" kzalloc()-ed, not to USB_MAXINTERFACES.

* There is a "struct usb_device" leak in this error path,
as there is usb_get_dev(), but no usb_put_dev() on this path.

* There is a bug of the same type several lines below with number
of endpoints. The code is accessing hard-coded second endpoint
("interface->endpoint[1].desc") which may not exist. It would be
great to handle this in the same patch too.

* All the concerns above are resolved by already-accepted patch
fa52bd50 "[media] usbvision: fix crash on detecting device with
invalid configuration"

* Mailing list message:
http://www.spinics.net/lists/linux-media/msg94832.html

 drivers/media/usb/usbvision/usbvision-video.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/media/usb/usbvision/usbvision-video.c b/drivers/media/usb/usbvision/usbvision-video.c
index de9ff3b..6996ab8 100644
--- a/drivers/media/usb/usbvision/usbvision-video.c
+++ b/drivers/media/usb/usbvision/usbvision-video.c
@@ -1461,13 +1461,6 @@ static int usbvision_probe(struct usb_interface *intf,
 	printk(KERN_INFO "%s: %s found\n", __func__,
 				usbvision_device_data[model].model_string);
 
-	/*
-	 * this is a security check.
-	 * an exploit using an incorrect bInterfaceNumber is known
-	 */
-	if (ifnum >= USB_MAXINTERFACES || !dev->actconfig->interface[ifnum])
-		return -ENODEV;
-
 	if (usbvision_device_data[model].interface >= 0)
 		interface = &dev->actconfig->interface[usbvision_device_data[model].interface]->altsetting[0];
 	else if (ifnum < dev->actconfig->desc.bNumInterfaces)
-- 
2.4.3

