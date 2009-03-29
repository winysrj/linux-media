Return-path: <linux-media-owner@vger.kernel.org>
Received: from tichy.grunau.be ([85.131.189.73]:49216 "EHLO tichy.grunau.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753770AbZC2MnM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Mar 2009 08:43:12 -0400
Date: Sun, 29 Mar 2009 14:42:51 +0200
From: Janne Grunau <j@jannau.net>
To: linux-media@vger.kernel.org
Cc: Steven Toth <stoth@linuxtv.org>
Subject: [PATCH 5 of 6] au0828: use usb_interface.dev for
	v4l2_device_register
Message-ID: <20090329124251.GF637@aniel>
References: <patchbomb.1238329154@aniel>
MIME-Version: 1.0
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: inline; filename="v4l2_device_usb_interface-5.patch"
In-Reply-To: <patchbomb.1238329154@aniel>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

# HG changeset patch
# User Janne Grunau <j@jannau.net>
# Date 1238191025 -3600
# Node ID 16016db934ee03d0156754b8e07d4212c933d234
# Parent  210007cef5bdef2364590755a2b7ab219534db16
au0828: use usb_interface.dev for v4l2_device_register

From: Janne Grunau <j@jannau.net>

removes the explicitly set v4l2_device.name

Priority: normal

Signed-off-by: Janne Grunau <j@jannau.net>

diff -r 210007cef5bd -r 16016db934ee linux/drivers/media/video/au0828/au0828-core.c
--- a/linux/drivers/media/video/au0828/au0828-core.c	Fri Mar 27 22:54:45 2009 +0100
+++ b/linux/drivers/media/video/au0828/au0828-core.c	Fri Mar 27 22:57:05 2009 +0100
@@ -199,9 +199,7 @@
 
 	/* Create the v4l2_device */
 	i = atomic_inc_return(&au0828_instance) - 1;
-	snprintf(dev->v4l2_dev.name, sizeof(dev->v4l2_dev.name), "%s-%03d",
-		 "au0828", i);
-	retval = v4l2_device_register(&dev->usbdev->dev, &dev->v4l2_dev);
+	retval = v4l2_device_register(&interface->dev, &dev->v4l2_dev);
 	if (retval) {
 		printk(KERN_ERR "%s() v4l2_device_register failed\n",
 		       __func__);
