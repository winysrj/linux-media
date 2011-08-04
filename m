Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:53463 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab1HDHO2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Aug 2011 03:14:28 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 13/21] [staging] tm6000: Properly count device usage.
Date: Thu,  4 Aug 2011 09:14:11 +0200
Message-Id: <1312442059-23935-14-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1312442059-23935-1-git-send-email-thierry.reding@avionic-design.de>
References: <1312442059-23935-1-git-send-email-thierry.reding@avionic-design.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When the USB device is disconnected, the device usage bit is not cleared
properly. This leads to errors when a device is unplugged and replugged
several times until all TM6000_MAXBOARDS bits are used and keeps the
driver from binding to the device.
---
 drivers/staging/tm6000/tm6000-cards.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index 68f7c7a..94fd138 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -1177,7 +1177,7 @@ static int tm6000_usb_probe(struct usb_interface *interface,
 	mutex_init(&dev->usb_lock);
 
 	/* Increment usage count */
-	tm6000_devused |= 1<<nr;
+	set_bit(nr, &tm6000_devused);
 	snprintf(dev->name, 29, "tm6000 #%d", nr);
 
 	dev->model = id->driver_info;
@@ -1293,7 +1293,7 @@ static int tm6000_usb_probe(struct usb_interface *interface,
 err:
 	printk(KERN_ERR "tm6000: Error %d while registering\n", rc);
 
-	tm6000_devused &= ~(1<<nr);
+	clear_bit(nr, &tm6000_devused);
 	usb_put_dev(usbdev);
 
 	kfree(dev);
@@ -1351,6 +1351,7 @@ static void tm6000_usb_disconnect(struct usb_interface *interface)
 	tm6000_close_extension(dev);
 	tm6000_remove_from_devlist(dev);
 
+	clear_bit(dev->devno, &tm6000_devused);
 	kfree(dev);
 }
 
-- 
1.7.6

