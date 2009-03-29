Return-path: <linux-media-owner@vger.kernel.org>
Received: from tichy.grunau.be ([85.131.189.73]:52208 "EHLO tichy.grunau.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752866AbZC2Ml4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Mar 2009 08:41:56 -0400
Received: from localhost (unknown [78.52.195.10])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by tichy.grunau.be (Postfix) with ESMTPSA id 3337390002
	for <linux-media@vger.kernel.org>; Sun, 29 Mar 2009 14:41:33 +0200 (CEST)
Date: Sun, 29 Mar 2009 14:41:35 +0200
From: Janne Grunau <j@jannau.net>
To: linux-media@vger.kernel.org
Subject: [PATCH 3 of 6] usbvision: use usb_interface.dev for
	v4l2_device_register
Message-ID: <20090329124135.GD637@aniel>
References: <patchbomb.1238329154@aniel>
MIME-Version: 1.0
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: inline; filename="v4l2_device_usb_interface-3.patch"
In-Reply-To: <patchbomb.1238329154@aniel>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

# HG changeset patch
# User Janne Grunau <j@jannau.net>
# Date 1238190800 -3600
# Node ID 09d6b9873181402892bb746d101b1b22b245208d
# Parent  edca57a287041646c86b404852ef9abf0ecd6c72
usbvision: use usb_interface.dev for v4l2_device_register

From: Janne Grunau <j@jannau.net>

Priority: normal

Signed-off-by: Janne Grunau <j@jannau.net>

diff -r edca57a28704 -r 09d6b9873181 linux/drivers/media/video/usbvision/usbvision-video.c
--- a/linux/drivers/media/video/usbvision/usbvision-video.c	Fri Mar 27 22:42:45 2009 +0100
+++ b/linux/drivers/media/video/usbvision/usbvision-video.c	Fri Mar 27 22:53:20 2009 +0100
@@ -1530,7 +1530,8 @@
  * Returns NULL on error, a pointer to usb_usbvision else.
  *
  */
-static struct usb_usbvision *usbvision_alloc(struct usb_device *dev)
+static struct usb_usbvision *usbvision_alloc(struct usb_device *dev,
+					     struct usb_interface *intf)
 {
 	struct usb_usbvision *usbvision;
 
@@ -1539,7 +1540,7 @@
 		return NULL;
 
 	usbvision->dev = dev;
-	if (v4l2_device_register(&dev->dev, &usbvision->v4l2_dev))
+	if (v4l2_device_register(&intf->dev, &usbvision->v4l2_dev))
 		goto err_free;
 
 	mutex_init(&usbvision->lock);	/* available */
@@ -1677,7 +1678,8 @@
 		return -ENODEV;
 	}
 
-	if ((usbvision = usbvision_alloc(dev)) == NULL) {
+	usbvision = usbvision_alloc(dev, intf);
+	if (usbvision == NULL) {
 		dev_err(&intf->dev, "%s: couldn't allocate USBVision struct\n", __func__);
 		return -ENOMEM;
 	}
