Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48998 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab2CMO1d (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Mar 2012 10:27:33 -0400
Received: by yenl12 with SMTP id l12so592839yen.19
        for <linux-media@vger.kernel.org>; Tue, 13 Mar 2012 07:27:32 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: mchehab@infradead.org
Cc: rankincj@yahoo.com, dheitmueller@kernellabs.com, crope@iki.fi,
	saschasommer@freenet.de, linux-media@vger.kernel.org,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH 2/2] media: em28xx: Paranoic stack save
Date: Tue, 13 Mar 2012 11:27:09 -0300
Message-Id: <1331648829-2339-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch saves 255 bytes of stack on usb_probe() by removing
a char array. In some platforms this is represents a substantial save.

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/video/em28xx/em28xx-cards.c |   19 ++++---------------
 1 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index ce1b60f..d328616 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -3122,7 +3122,6 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 	int i, nr;
 	const int ifnum = interface->altsetting[0].desc.bInterfaceNumber;
 	char *speed;
-	char descr[255] = "";
 
 	udev = usb_get_dev(interface_to_usbdev(interface));
 
@@ -3227,21 +3226,11 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 		speed = "unknown";
 	}
 
-	if (udev->manufacturer)
-		strlcpy(descr, udev->manufacturer, sizeof(descr));
-
-	if (udev->product) {
-		if (*descr)
-			strlcat(descr, " ", sizeof(descr));
-		strlcat(descr, udev->product, sizeof(descr));
-	}
-
-	if (*descr)
-		strlcat(descr, " ", sizeof(descr));
-
 	printk(KERN_INFO DRIVER_NAME
-		": New device %s@ %s Mbps (%04x:%04x, interface %d, class %d)\n",
-		descr,
+		": New device %s %s @ %s Mbps "
+		"(%04x:%04x, interface %d, class %d)\n",
+		udev->manufacturer ? udev->manufacturer : "",
+		udev->product ? udev->product : "",
 		speed,
 		le16_to_cpu(udev->descriptor.idVendor),
 		le16_to_cpu(udev->descriptor.idProduct),
-- 
1.7.3.4

