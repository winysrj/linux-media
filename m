Return-path: <linux-media-owner@vger.kernel.org>
Received: from tichy.grunau.be ([85.131.189.73]:33357 "EHLO tichy.grunau.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757172AbZC2O7A (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Mar 2009 10:59:00 -0400
Received: from localhost (unknown [78.52.195.10])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by tichy.grunau.be (Postfix) with ESMTPSA id 828FC90002
	for <linux-media@vger.kernel.org>; Sun, 29 Mar 2009 16:58:37 +0200 (CEST)
Date: Sun, 29 Mar 2009 16:58:39 +0200
From: Janne Grunau <j@jannau.net>
To: linux-media@vger.kernel.org
Subject: [PATCH 4 of 8] usbvision: use usb_interface.dev for
	v4l2_device_register
Message-ID: <20090329145839.GE17855@aniel>
References: <patchbomb.1238338474@aniel>
MIME-Version: 1.0
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: inline; filename="usbvision_usb_intf_v4l2_dev.diff"
In-Reply-To: <patchbomb.1238338474@aniel>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

# HG changeset patch
# User Janne Grunau <j@jannau.net>
# Date 1238338428 -7200
# Node ID 01af508490af3bc9c939c36001d6989e2c147aa0
# Parent  ce50af27b414d4e146e6833b78852b42b129293a
usbvision: use usb_interface.dev for v4l2_device_register

Priority: normal

Signed-off-by: Janne Grunau <j@jannau.net>

diff -r ce50af27b414 -r 01af508490af linux/drivers/media/video/usbvision/usbvision-video.c
--- a/linux/drivers/media/video/usbvision/usbvision-video.c	Sun Mar 29 16:53:48 2009 +0200
+++ b/linux/drivers/media/video/usbvision/usbvision-video.c	Sun Mar 29 16:53:48 2009 +0200
@@ -1522,7 +1522,8 @@
  * Returns NULL on error, a pointer to usb_usbvision else.
  *
  */
-static struct usb_usbvision *usbvision_alloc(struct usb_device *dev)
+static struct usb_usbvision *usbvision_alloc(struct usb_device *dev,
+					     struct usb_interface *intf)
 {
 	struct usb_usbvision *usbvision;
 
@@ -1531,7 +1532,7 @@
 		return NULL;
 
 	usbvision->dev = dev;
-	if (v4l2_device_register(&dev->dev, &usbvision->v4l2_dev))
+	if (v4l2_device_register(&intf->dev, &usbvision->v4l2_dev))
 		goto err_free;
 
 	mutex_init(&usbvision->lock);	/* available */
@@ -1669,7 +1670,8 @@
 		return -ENODEV;
 	}
 
-	if ((usbvision = usbvision_alloc(dev)) == NULL) {
+	usbvision = usbvision_alloc(dev, intf);
+	if (usbvision == NULL) {
 		dev_err(&intf->dev, "%s: couldn't allocate USBVision struct\n", __func__);
 		return -ENOMEM;
 	}
