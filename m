Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53138 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbaAMVgT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jan 2014 16:36:19 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 5/7] [media] go7007-usb: only use go->dev after allocated
Date: Mon, 13 Jan 2014 16:32:36 -0200
Message-Id: <1389637958-3884-6-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1389637958-3884-1-git-send-email-m.chehab@samsung.com>
References: <1389637958-3884-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes those warnings:
	drivers/staging/media/go7007/go7007-usb.c: In function 'go7007_usb_probe':
	drivers/staging/media/go7007/go7007-usb.c:1060: warning: 'go' is used uninitialized in this function

While here, comment a code that will never run.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/staging/media/go7007/go7007-usb.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/media/go7007/go7007-usb.c b/drivers/staging/media/go7007/go7007-usb.c
index 58684da45e6c..1d747de6dfa6 100644
--- a/drivers/staging/media/go7007/go7007-usb.c
+++ b/drivers/staging/media/go7007/go7007-usb.c
@@ -1057,7 +1057,7 @@ static int go7007_usb_probe(struct usb_interface *intf,
 	char *name;
 	int video_pipe, i, v_urb_len;
 
-	dev_dbg(go->dev, "probing new GO7007 USB board\n");
+	printk(KERN_DEBUG "go7007-usb: probing new board\n");
 
 	switch (id->driver_info) {
 	case GO7007_BOARDID_MATRIX_II:
@@ -1097,13 +1097,16 @@ static int go7007_usb_probe(struct usb_interface *intf,
 		board = &board_px_tv402u;
 		break;
 	case GO7007_BOARDID_LIFEVIEW_LR192:
-		dev_err(go->dev, "The Lifeview TV Walker Ultra is not supported. Sorry!\n");
+		printk(KERN_ERR
+		       "The Lifeview TV Walker Ultra is not supported. Sorry!\n");
 		return -ENODEV;
+#if 0
 		name = "Lifeview TV Walker Ultra";
 		board = &board_lifeview_lr192;
 		break;
+#endif
 	case GO7007_BOARDID_SENSORAY_2250:
-		dev_info(go->dev, "Sensoray 2250 found\n");
+		printk(KERN_INFO "Sensoray 2250 found\n");
 		name = "Sensoray 2250/2251";
 		board = &board_sensoray_2250;
 		break;
@@ -1112,8 +1115,9 @@ static int go7007_usb_probe(struct usb_interface *intf,
 		board = &board_ads_usbav_709;
 		break;
 	default:
-		dev_err(go->dev, "unknown board ID %d!\n",
-				(unsigned int)id->driver_info);
+		printk(KERN_ERR
+		       "unknown board ID %d!\n",
+		       (unsigned int)id->driver_info);
 		return -ENODEV;
 	}
 
-- 
1.8.3.1

