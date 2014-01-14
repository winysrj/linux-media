Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57495 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbaANXi7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jan 2014 18:38:59 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] em28xx-cards: properly initialize the device bitmap
Date: Tue, 14 Jan 2014 18:35:15 -0200
Message-Id: <1389731715-28006-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of just creating a long int, use DECLARE_BITMAP().

No functional changes.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 8fc0a437054e..cd0d01b53c73 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -66,7 +66,7 @@ MODULE_PARM_DESC(usb_xfer_mode,
 
 
 /* Bitmask marking allocated devices from 0 to EM28XX_MAXBOARDS - 1 */
-static unsigned long em28xx_devused;
+DECLARE_BITMAP(em28xx_devused, EM28XX_MAXBOARDS);
 
 struct em28xx_hash_table {
 	unsigned long hash;
@@ -2887,7 +2887,7 @@ void em28xx_free_device(struct kref *ref)
 	usb_put_dev(dev->udev);
 
 	/* Mark device as unused */
-	clear_bit(dev->devno, &em28xx_devused);
+	clear_bit(dev->devno, em28xx_devused);
 
 	kfree(dev->alt_max_pkt_size_isoc);
 	kfree(dev);
@@ -3097,7 +3097,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 
 	/* Check to see next free device and mark as used */
 	do {
-		nr = find_first_zero_bit(&em28xx_devused, EM28XX_MAXBOARDS);
+		nr = find_first_zero_bit(em28xx_devused, EM28XX_MAXBOARDS);
 		if (nr >= EM28XX_MAXBOARDS) {
 			/* No free device slots */
 			printk(DRIVER_NAME ": Supports only %i em28xx boards.\n",
@@ -3105,7 +3105,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 			retval = -ENOMEM;
 			goto err_no_slot;
 		}
-	} while (test_and_set_bit(nr, &em28xx_devused));
+	} while (test_and_set_bit(nr, em28xx_devused));
 
 	/* Don't register audio interfaces */
 	if (interface->altsetting[0].desc.bInterfaceClass == USB_CLASS_AUDIO) {
@@ -3360,7 +3360,7 @@ err_free:
 	kfree(dev);
 
 err:
-	clear_bit(nr, &em28xx_devused);
+	clear_bit(nr, em28xx_devused);
 
 err_no_slot:
 	usb_put_dev(udev);
-- 
1.8.3.1

