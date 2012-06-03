Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:37498 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759474Ab2FCCAk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Jun 2012 22:00:40 -0400
Received: by vcbf11 with SMTP id f11so1940552vcb.19
        for <linux-media@vger.kernel.org>; Sat, 02 Jun 2012 19:00:39 -0700 (PDT)
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: linux-media@vger.kernel.org
Cc: elezegarcia@gmail.com, Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH] cx231xx: Paranoic stack memory save
Date: Sat,  2 Jun 2012 23:00:14 -0300
Message-Id: <1338688814-2043-1-git-send-email-peter.senna@gmail.com>
In-Reply-To: <CA+MoWDqx-agjxCDOJmWOuY21FzkoXyg_ckWj=gV-FyF0cLxpDQ@mail.gmail.com>
References: <CA+MoWDqx-agjxCDOJmWOuY21FzkoXyg_ckWj=gV-FyF0cLxpDQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch saves 255 bytes of stack memory on cx231xx_usb_probe() by removing a char array. Tested by compilation only.

This should replace the patch:
http://patchwork.linuxtv.org/patch/11565/

Because something went wrong with the previous E-mail, and not all lines of the patch were reconized as being the patch.

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

