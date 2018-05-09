Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:54783 "EHLO
        homiemail-a46.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934914AbeEIQar (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 May 2018 12:30:47 -0400
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH] em28xx: Demote several dev_err to dev_info
Date: Wed,  9 May 2018 11:30:36 -0500
Message-Id: <1525883436-14124-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These two statements are not errors, reduce to appropriate level.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 9a68bdf..325e98b 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -3702,7 +3702,7 @@ static int em28xx_usb_probe(struct usb_interface *intf,
 
 	/* Don't register audio interfaces */
 	if (intf->altsetting[0].desc.bInterfaceClass == USB_CLASS_AUDIO) {
-		dev_err(&intf->dev,
+		dev_info(&intf->dev,
 			"audio device (%04x:%04x): interface %i, class %i\n",
 			le16_to_cpu(udev->descriptor.idVendor),
 			le16_to_cpu(udev->descriptor.idProduct),
@@ -3985,7 +3985,7 @@ static void em28xx_usb_disconnect(struct usb_interface *intf)
 
 	dev->disconnected = 1;
 
-	dev_err(&dev->intf->dev, "Disconnecting %s\n", dev->name);
+	dev_info(&dev->intf->dev, "Disconnecting %s\n", dev->name);
 
 	flush_request_modules(dev);
 
-- 
2.7.4
