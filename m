Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54596 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbaG0T1k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Jul 2014 15:27:40 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v3 3/6] cx231xx: use devm_ functions to allocate memory
Date: Sun, 27 Jul 2014 16:27:29 -0300
Message-Id: <1406489252-30636-4-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1406489252-30636-1-git-send-email-m.chehab@samsung.com>
References: <1406489252-30636-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The initialization is already too complex. Use devm_ functions
to make the code simpler and easier to modify.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/cx231xx/cx231xx-cards.c | 43 ++++++++++---------------------
 1 file changed, 13 insertions(+), 30 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index 499d395544cd..f1cf44af96cf 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -1104,12 +1104,6 @@ void cx231xx_release_resources(struct cx231xx *dev)
 
 	/* Mark device as unused */
 	clear_bit(dev->devno, &cx231xx_devused);
-
-	kfree(dev->video_mode.alt_max_pkt_size);
-	kfree(dev->vbi_mode.alt_max_pkt_size);
-	kfree(dev->sliced_cc_mode.alt_max_pkt_size);
-	kfree(dev->ts1_mode.alt_max_pkt_size);
-	kfree(dev);
 }
 
 /*
@@ -1298,16 +1292,16 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 		}
 	} while (test_and_set_bit(nr, &cx231xx_devused));
 
+	udev = usb_get_dev(interface_to_usbdev(interface));
+
 	/* allocate memory for our device state and initialize it */
-	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	dev = devm_kzalloc(&udev->dev, sizeof(*dev), GFP_KERNEL);
 	if (dev == NULL) {
 		cx231xx_err(DRIVER_NAME ": out of memory!\n");
 		clear_bit(nr, &cx231xx_devused);
 		return -ENOMEM;
 	}
 
-	udev = usb_get_dev(interface_to_usbdev(interface));
-
 	snprintf(dev->name, 29, "cx231xx #%d", nr);
 	dev->devno = nr;
 	dev->model = id->driver_info;
@@ -1410,9 +1404,8 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 	cx231xx_info("EndPoint Addr 0x%x, Alternate settings: %i\n",
 		     dev->video_mode.end_point_addr,
 		     dev->video_mode.num_alt);
-	dev->video_mode.alt_max_pkt_size =
-		kmalloc(32 * dev->video_mode.num_alt, GFP_KERNEL);
 
+	dev->video_mode.alt_max_pkt_size = devm_kmalloc_array(&udev->dev, 32, dev->video_mode.num_alt, GFP_KERNEL);
 	if (dev->video_mode.alt_max_pkt_size == NULL) {
 		cx231xx_errdev("out of memory!\n");
 		retval = -ENOMEM;
@@ -1434,7 +1427,7 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 	if (idx >= dev->max_iad_interface_count) {
 		cx231xx_errdev("VBI PCB interface #%d doesn't exist\n", idx);
 		retval = -ENODEV;
-		goto err_vbi_alt;
+		goto err_video_alt;
 	}
 	uif = udev->actconfig->interface[idx];
 
@@ -1446,13 +1439,12 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 	cx231xx_info("EndPoint Addr 0x%x, Alternate settings: %i\n",
 		     dev->vbi_mode.end_point_addr,
 		     dev->vbi_mode.num_alt);
-	dev->vbi_mode.alt_max_pkt_size =
-	    kmalloc(32 * dev->vbi_mode.num_alt, GFP_KERNEL);
 
+	dev->vbi_mode.alt_max_pkt_size = devm_kmalloc_array(&udev->dev, 32, dev->vbi_mode.num_alt, GFP_KERNEL);
 	if (dev->vbi_mode.alt_max_pkt_size == NULL) {
 		cx231xx_errdev("out of memory!\n");
 		retval = -ENOMEM;
-		goto err_vbi_alt;
+		goto err_video_alt;
 	}
 
 	for (i = 0; i < dev->vbi_mode.num_alt; i++) {
@@ -1470,7 +1462,7 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 	if (idx >= dev->max_iad_interface_count) {
 		cx231xx_errdev("Sliced CC PCB interface #%d doesn't exist\n", idx);
 		retval = -ENODEV;
-		goto err_sliced_cc_alt;
+		goto err_video_alt;
 	}
 	uif = udev->actconfig->interface[idx];
 
@@ -1482,13 +1474,12 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 	cx231xx_info("EndPoint Addr 0x%x, Alternate settings: %i\n",
 		     dev->sliced_cc_mode.end_point_addr,
 		     dev->sliced_cc_mode.num_alt);
-	dev->sliced_cc_mode.alt_max_pkt_size =
-		kmalloc(32 * dev->sliced_cc_mode.num_alt, GFP_KERNEL);
+	dev->sliced_cc_mode.alt_max_pkt_size = devm_kmalloc_array(&udev->dev, 32, dev->sliced_cc_mode.num_alt, GFP_KERNEL);
 
 	if (dev->sliced_cc_mode.alt_max_pkt_size == NULL) {
 		cx231xx_errdev("out of memory!\n");
 		retval = -ENOMEM;
-		goto err_sliced_cc_alt;
+		goto err_video_alt;
 	}
 
 	for (i = 0; i < dev->sliced_cc_mode.num_alt; i++) {
@@ -1506,7 +1497,7 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 		if (idx >= dev->max_iad_interface_count) {
 			cx231xx_errdev("TS1 PCB interface #%d doesn't exist\n", idx);
 			retval = -ENODEV;
-			goto err_ts1_alt;
+			goto err_video_alt;
 		}
 		uif = udev->actconfig->interface[idx];
 
@@ -1518,13 +1509,12 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 		cx231xx_info("EndPoint Addr 0x%x, Alternate settings: %i\n",
 			     dev->ts1_mode.end_point_addr,
 			     dev->ts1_mode.num_alt);
-		dev->ts1_mode.alt_max_pkt_size =
-			kmalloc(32 * dev->ts1_mode.num_alt, GFP_KERNEL);
 
+		dev->ts1_mode.alt_max_pkt_size = devm_kmalloc_array(&udev->dev, 32, dev->ts1_mode.num_alt, GFP_KERNEL);
 		if (dev->ts1_mode.alt_max_pkt_size == NULL) {
 			cx231xx_errdev("out of memory!\n");
 			retval = -ENOMEM;
-			goto err_ts1_alt;
+			goto err_video_alt;
 		}
 
 		for (i = 0; i < dev->ts1_mode.num_alt; i++) {
@@ -1551,12 +1541,6 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 	request_modules(dev);
 
 	return 0;
-err_ts1_alt:
-	kfree(dev->sliced_cc_mode.alt_max_pkt_size);
-err_sliced_cc_alt:
-	kfree(dev->vbi_mode.alt_max_pkt_size);
-err_vbi_alt:
-	kfree(dev->video_mode.alt_max_pkt_size);
 err_video_alt:
 	/* cx231xx_uninit_dev: */
 	cx231xx_close_extension(dev);
@@ -1572,7 +1556,6 @@ err_v4l2:
 err_if:
 	usb_put_dev(udev);
 	clear_bit(dev->devno, &cx231xx_devused);
-	kfree(dev);
 	return retval;
 }
 
-- 
1.9.3

