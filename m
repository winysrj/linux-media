Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:47276 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755624Ab2FNR7T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jun 2012 13:59:19 -0400
Received: by gglu4 with SMTP id u4so1627280ggl.19
        for <linux-media@vger.kernel.org>; Thu, 14 Jun 2012 10:59:18 -0700 (PDT)
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Julia Lawall <julia@diku.dk>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	linux-media@vger.kernel.org
Cc: Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 1/8] [RESEND] cx231xx: Paranoic stack memory save
Date: Thu, 14 Jun 2012 14:58:09 -0300
Message-Id: <1339696716-14373-1-git-send-email-peter.senna@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Saves 255 bytes of stack memory on cx231xx_usb_probe() by removing a char array.

Tested by compilation only.

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
 drivers/media/video/cx231xx/cx231xx-cards.c |   17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/media/video/cx231xx/cx231xx-cards.c b/drivers/media/video/cx231xx/cx231xx-cards.c
index 8ed460d..02d4d36 100644
--- a/drivers/media/video/cx231xx/cx231xx-cards.c
+++ b/drivers/media/video/cx231xx/cx231xx-cards.c
@@ -1023,7 +1023,6 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 	int nr = 0, ifnum;
 	int i, isoc_pipe = 0;
 	char *speed;
-	char descr[255] = "";
 	struct usb_interface_assoc_descriptor *assoc_desc;
 
 	udev = usb_get_dev(interface_to_usbdev(interface));
@@ -1098,20 +1097,10 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
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
-- 
1.7.10.2

