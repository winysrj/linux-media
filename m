Return-path: <linux-media-owner@vger.kernel.org>
Received: from tichy.grunau.be ([85.131.189.73]:33361 "EHLO tichy.grunau.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757252AbZC2PAF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Mar 2009 11:00:05 -0400
Date: Sun, 29 Mar 2009 16:59:44 +0200
From: Janne Grunau <j@jannau.net>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <devin.heitmueller@gmail.com>
Subject: [PATCH 7 of 8] au0828: remove explicitly set v4l2_device.name and
	unused au0828_instance
Message-ID: <20090329145944.GH17855@aniel>
References: <patchbomb.1238338474@aniel>
MIME-Version: 1.0
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: inline; filename="au0828_remove_v4l2_dev_name.diff"
In-Reply-To: <patchbomb.1238338474@aniel>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

# HG changeset patch
# User Janne Grunau <j@jannau.net>
# Date 1238338428 -7200
# Node ID 9de2e49de0b75360d86b8fc444de057a485003c1
# Parent  1fd54536517a9be6f93f5711766bb8efd64ddbdf
au0828: remove explicitly set v4l2_device.name and unused au0828_instance

Priority: normal

Signed-off-by: Janne Grunau <j@jannau.net>

diff -r 1fd54536517a -r 9de2e49de0b7 linux/drivers/media/video/au0828/au0828-core.c
--- a/linux/drivers/media/video/au0828/au0828-core.c	Sun Mar 29 16:53:48 2009 +0200
+++ b/linux/drivers/media/video/au0828/au0828-core.c	Sun Mar 29 16:53:48 2009 +0200
@@ -37,8 +37,6 @@
 module_param_named(debug, au0828_debug, int, 0644);
 MODULE_PARM_DESC(debug, "enable debug messages");
 
-static atomic_t au0828_instance = ATOMIC_INIT(0);
-
 #define _AU0828_BULKPIPE 0x03
 #define _BULKPIPESIZE 0xffff
 
@@ -170,7 +168,7 @@
 static int au0828_usb_probe(struct usb_interface *interface,
 	const struct usb_device_id *id)
 {
-	int ifnum, retval, i;
+	int ifnum, retval;
 	struct au0828_dev *dev;
 	struct usb_device *usbdev = interface_to_usbdev(interface);
 
@@ -198,9 +196,6 @@
 	usb_set_intfdata(interface, dev);
 
 	/* Create the v4l2_device */
-	i = atomic_inc_return(&au0828_instance) - 1;
-	snprintf(dev->v4l2_dev.name, sizeof(dev->v4l2_dev.name), "%s-%03d",
-		 "au0828", i);
 	retval = v4l2_device_register(&interface->dev, &dev->v4l2_dev);
 	if (retval) {
 		printk(KERN_ERR "%s() v4l2_device_register failed\n",
