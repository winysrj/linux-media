Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:43453 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965988Ab2FAXKq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Jun 2012 19:10:46 -0400
Received: by weyu7 with SMTP id u7so1684959wey.19
        for <linux-media@vger.kernel.org>; Fri, 01 Jun 2012 16:10:45 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 1 Jun 2012 20:10:45 -0300
Message-ID: <CA+MoWDqx-agjxCDOJmWOuY21FzkoXyg_ckWj=gV-FyF0cLxpDQ@mail.gmail.com>
Subject: [PATCH] cx231xx: Paranoic memory save
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch saves 255 bytes of memory on cx231xx_usb_probe() by
removing a char array.

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
diff --git a/drivers/media/video/cx231xx/cx231xx-cards.c
b/drivers/media/video/cx231xx/cx231xx-cards.c
index 8ed460d..02d4d36 100644
--- a/drivers/media/video/cx231xx/cx231xx-cards.c
+++ b/drivers/media/video/cx231xx/cx231xx-cards.c
@@ -1023,7 +1023,6 @@ static int cx231xx_usb_probe(struct
usb_interface *interface,
 	int nr = 0, ifnum;
 	int i, isoc_pipe = 0;
 	char *speed;
-	char descr[255] = "";
 	struct usb_interface_assoc_descriptor *assoc_desc;

 	udev = usb_get_dev(interface_to_usbdev(interface));
@@ -1098,20 +1097,10 @@ static int cx231xx_usb_probe(struct
usb_interface *interface,
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
-	if (*descr)
-		strlcat(descr, " ", sizeof(descr));
-
-	cx231xx_info("New device %s@ %s Mbps "
+	cx231xx_info("New device %s %s @ %s Mbps "
 	     "(%04x:%04x) with %d interfaces\n",
-	     descr,
+	     udev->manufacturer ? udev->manufacturer : "",
+	     udev->product ? udev->product : "",
 	     speed,
 	     le16_to_cpu(udev->descriptor.idVendor),
 	     le16_to_cpu(udev->descriptor.idProduct),
