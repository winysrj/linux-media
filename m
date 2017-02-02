Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.75]:50116 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750777AbdBBOgp (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Feb 2017 09:36:45 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Wolfram Sang <wsa-dev@sang-engineering.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] dvb-usb-v2: avoid use-after-free
Date: Thu,  2 Feb 2017 15:36:01 +0100
Message-Id: <20170202143627.3565895-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I ran into a stack frame size warning because of the on-stack copy of
the USB device structure:

drivers/media/usb/dvb-usb-v2/dvb_usb_core.c: In function 'dvb_usbv2_disconnect':
drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:1029:1: error: the frame size of 1104 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]

Copying a device structure like this is wrong for a number of other reasons
too aside from the possible stack overflow. One of them is that the
dev_info() call will print the name of the device later, but AFAICT
we have only copied a pointer to the name earlier and the actual name
has been freed by the time it gets printed.

This removes the on-stack copy of the device and instead copies the
device name using kstrdup(). I'm ignoring the possible failure here
as both printk() and kfree() are able to deal with NULL pointers.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
index a8e6624fbe83..a9bb2dde98ea 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
@@ -1013,8 +1013,8 @@ EXPORT_SYMBOL(dvb_usbv2_probe);
 void dvb_usbv2_disconnect(struct usb_interface *intf)
 {
 	struct dvb_usb_device *d = usb_get_intfdata(intf);
-	const char *name = d->name;
-	struct device dev = d->udev->dev;
+	const char *devname = kstrdup(dev_name(&d->udev->dev), GFP_KERNEL);
+	const char *drvname = d->name;
 
 	dev_dbg(&d->udev->dev, "%s: bInterfaceNumber=%d\n", __func__,
 			intf->cur_altsetting->desc.bInterfaceNumber);
@@ -1024,8 +1024,9 @@ void dvb_usbv2_disconnect(struct usb_interface *intf)
 
 	dvb_usbv2_exit(d);
 
-	dev_info(&dev, "%s: '%s' successfully deinitialized and disconnected\n",
-			KBUILD_MODNAME, name);
+	pr_info("%s: '%s:%s' successfully deinitialized and disconnected\n",
+		KBUILD_MODNAME, drvname, devname);
+	kfree(devname);
 }
 EXPORT_SYMBOL(dvb_usbv2_disconnect);
 
-- 
2.9.0

