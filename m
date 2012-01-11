Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33675 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756613Ab2AKAWP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jan 2012 19:22:15 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0B0METg019529
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 10 Jan 2012 19:22:15 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 5/6] [media] cx231xx: cx231xx_devused is racy
Date: Tue, 10 Jan 2012 22:20:25 -0200
Message-Id: <1326241226-6734-5-git-send-email-mchehab@redhat.com>
In-Reply-To: <1326241226-6734-1-git-send-email-mchehab@redhat.com>
References: <1326241226-6734-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

cx231xx_devused is racy. Re-implement it in a proper way,
to remove the risk of mangling it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/video/cx231xx/cx231xx-cards.c |   36 +++++++++++++-------------
 1 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/media/video/cx231xx/cx231xx-cards.c b/drivers/media/video/cx231xx/cx231xx-cards.c
index bd82f01..1f2fbbf 100644
--- a/drivers/media/video/cx231xx/cx231xx-cards.c
+++ b/drivers/media/video/cx231xx/cx231xx-cards.c
@@ -854,7 +854,7 @@ void cx231xx_release_resources(struct cx231xx *dev)
 	usb_put_dev(dev->udev);
 
 	/* Mark device as unused */
-	cx231xx_devused &= ~(1 << dev->devno);
+	clear_bit(dev->devno, &cx231xx_devused);
 
 	kfree(dev->video_mode.alt_max_pkt_size);
 	kfree(dev->vbi_mode.alt_max_pkt_size);
@@ -1039,21 +1039,21 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 		return -ENODEV;
 
 	/* Check to see next free device and mark as used */
-	nr = find_first_zero_bit(&cx231xx_devused, CX231XX_MAXBOARDS);
-	cx231xx_devused |= 1 << nr;
-
-	if (nr >= CX231XX_MAXBOARDS) {
-		cx231xx_err(DRIVER_NAME
-		 ": Supports only %i cx231xx boards.\n", CX231XX_MAXBOARDS);
-		cx231xx_devused &= ~(1 << nr);
-		return -ENOMEM;
-	}
+	do {
+		nr = find_first_zero_bit(&cx231xx_devused, CX231XX_MAXBOARDS);
+		if (nr >= CX231XX_MAXBOARDS) {
+			/* No free device slots */
+			cx231xx_err(DRIVER_NAME ": Supports only %i devices.\n",
+					CX231XX_MAXBOARDS);
+			return -ENOMEM;
+		}
+	} while (test_and_set_bit(nr, &cx231xx_devused));
 
 	/* allocate memory for our device state and initialize it */
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 	if (dev == NULL) {
 		cx231xx_err(DRIVER_NAME ": out of memory!\n");
-		cx231xx_devused &= ~(1 << nr);
+		clear_bit(dev->devno, &cx231xx_devused);
 		return -ENOMEM;
 	}
 
@@ -1129,7 +1129,7 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 	if (assoc_desc->bFirstInterface != ifnum) {
 		cx231xx_err(DRIVER_NAME ": Not found "
 			    "matching IAD interface\n");
-		cx231xx_devused &= ~(1 << nr);
+		clear_bit(dev->devno, &cx231xx_devused);
 		kfree(dev);
 		dev = NULL;
 		return -ENODEV;
@@ -1148,7 +1148,7 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 	retval = v4l2_device_register(&interface->dev, &dev->v4l2_dev);
 	if (retval) {
 		cx231xx_errdev("v4l2_device_register failed\n");
-		cx231xx_devused &= ~(1 << nr);
+		clear_bit(dev->devno, &cx231xx_devused);
 		kfree(dev);
 		dev = NULL;
 		return -EIO;
@@ -1156,7 +1156,7 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 	/* allocate device struct */
 	retval = cx231xx_init_dev(&dev, udev, nr);
 	if (retval) {
-		cx231xx_devused &= ~(1 << dev->devno);
+		clear_bit(dev->devno, &cx231xx_devused);
 		v4l2_device_unregister(&dev->v4l2_dev);
 		kfree(dev);
 		dev = NULL;
@@ -1181,7 +1181,7 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 
 	if (dev->video_mode.alt_max_pkt_size == NULL) {
 		cx231xx_errdev("out of memory!\n");
-		cx231xx_devused &= ~(1 << nr);
+		clear_bit(dev->devno, &cx231xx_devused);
 		v4l2_device_unregister(&dev->v4l2_dev);
 		kfree(dev);
 		dev = NULL;
@@ -1215,7 +1215,7 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 
 	if (dev->vbi_mode.alt_max_pkt_size == NULL) {
 		cx231xx_errdev("out of memory!\n");
-		cx231xx_devused &= ~(1 << nr);
+		clear_bit(dev->devno, &cx231xx_devused);
 		v4l2_device_unregister(&dev->v4l2_dev);
 		kfree(dev);
 		dev = NULL;
@@ -1250,7 +1250,7 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 
 	if (dev->sliced_cc_mode.alt_max_pkt_size == NULL) {
 		cx231xx_errdev("out of memory!\n");
-		cx231xx_devused &= ~(1 << nr);
+		clear_bit(dev->devno, &cx231xx_devused);
 		v4l2_device_unregister(&dev->v4l2_dev);
 		kfree(dev);
 		dev = NULL;
@@ -1286,7 +1286,7 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 
 		if (dev->ts1_mode.alt_max_pkt_size == NULL) {
 			cx231xx_errdev("out of memory!\n");
-			cx231xx_devused &= ~(1 << nr);
+			clear_bit(dev->devno, &cx231xx_devused);
 			v4l2_device_unregister(&dev->v4l2_dev);
 			kfree(dev);
 			dev = NULL;
-- 
1.7.7.5

