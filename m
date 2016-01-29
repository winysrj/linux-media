Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36895 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756553AbcA2RNH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jan 2016 12:13:07 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 1/3] [media] em28xx: make sure that the device has video
Date: Fri, 29 Jan 2016 15:11:58 -0200
Message-Id: <759f0a1be7c9e2937056189acdd7338e737d609f.1454087508.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are some devices, like Terratec Cinergy HTC, where
while the device supports analog TV, the driver is not
capable yet of handling it, because the analog TV driver
was not written.

So, don't bind the em28xx-v4l drivers on such devices.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 2001c9c14784..ec4e95119877 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -3468,7 +3468,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 	/* save our data pointer in this interface device */
 	usb_set_intfdata(interface, dev);
 
-	/* allocate device struct */
+	/* allocate device struct and check if the device is a webcam */
 	mutex_init(&dev->lock);
 	retval = em28xx_init_dev(dev, udev, interface, nr);
 	if (retval) {
@@ -3484,6 +3484,15 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 		try_bulk = usb_xfer_mode > 0;
 	}
 
+	/* Disable V4L2 if the device doesn't have a decoder */
+	if (has_video &&
+	    dev->board.decoder == EM28XX_NODECODER && !dev->board.is_webcam) {
+		printk(DRIVER_NAME
+		       ": Currently, V4L2 is not supported on this model\n");
+		has_video = false;
+		dev->has_video = false;
+	}
+
 	/* Select USB transfer types to use */
 	if (has_video) {
 		if (!dev->analog_ep_isoc || (try_bulk && dev->analog_ep_bulk))
-- 
2.5.0

