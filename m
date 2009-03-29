Return-path: <linux-media-owner@vger.kernel.org>
Received: from tichy.grunau.be ([85.131.189.73]:33359 "EHLO tichy.grunau.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757212AbZC2O7x (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Mar 2009 10:59:53 -0400
Date: Sun, 29 Mar 2009 16:59:33 +0200
From: Janne Grunau <j@jannau.net>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <devin.heitmueller@gmail.com>
Subject: [PATCH 6 of 8] au0828: use usb_interface.dev for
	v4l2_device_register
Message-ID: <20090329145932.GG17855@aniel>
References: <patchbomb.1238338474@aniel>
MIME-Version: 1.0
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: inline; filename="au0828_usb_intf_v4l2_dev.diff"
In-Reply-To: <patchbomb.1238338474@aniel>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

# HG changeset patch
# User Janne Grunau <j@jannau.net>
# Date 1238338428 -7200
# Node ID 1fd54536517a9be6f93f5711766bb8efd64ddbdf
# Parent  2d52ac089920f9ac36960c0245442fd89a06bb75
au0828: use usb_interface.dev for v4l2_device_register

Priority: normal

Signed-off-by: Janne Grunau <j@jannau.net>

diff -r 2d52ac089920 -r 1fd54536517a linux/drivers/media/video/au0828/au0828-core.c
--- a/linux/drivers/media/video/au0828/au0828-core.c	Sun Mar 29 16:53:48 2009 +0200
+++ b/linux/drivers/media/video/au0828/au0828-core.c	Sun Mar 29 16:53:48 2009 +0200
@@ -201,7 +201,7 @@
 	i = atomic_inc_return(&au0828_instance) - 1;
 	snprintf(dev->v4l2_dev.name, sizeof(dev->v4l2_dev.name), "%s-%03d",
 		 "au0828", i);
-	retval = v4l2_device_register(&dev->usbdev->dev, &dev->v4l2_dev);
+	retval = v4l2_device_register(&interface->dev, &dev->v4l2_dev);
 	if (retval) {
 		printk(KERN_ERR "%s() v4l2_device_register failed\n",
 		       __func__);
