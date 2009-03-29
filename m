Return-path: <linux-media-owner@vger.kernel.org>
Received: from tichy.grunau.be ([85.131.189.73]:52206 "EHLO tichy.grunau.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753317AbZC2Mke (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Mar 2009 08:40:34 -0400
Date: Sun, 29 Mar 2009 14:40:13 +0200
From: Janne Grunau <j@jannau.net>
To: linux-media@vger.kernel.org
Cc: Srinivasa Deevi <srinivasa.deevi@conexant.com>
Subject: [PATCH 2 of 6] cx321xx: use usb_interface.dev for
	v4l2_device_register
Message-ID: <20090329124013.GC637@aniel>
References: <patchbomb.1238329154@aniel>
MIME-Version: 1.0
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: inline; filename="v4l2_device_usb_interface-2.patch"
In-Reply-To: <patchbomb.1238329154@aniel>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

# HG changeset patch
# User Janne Grunau <j@jannau.net>
# Date 1238190165 -3600
# Node ID edca57a287041646c86b404852ef9abf0ecd6c72
# Parent  602a8fff1ba466ec4fb4816d0fb0725c8650c311
cx321xx: use usb_interface.dev for v4l2_device_register

From: Janne Grunau <j@jannau.net>

removes the explicitly set v4l2_device.name

Priority: normal

Signed-off-by: Janne Grunau <j@jannau.net>

diff -r 602a8fff1ba4 -r edca57a28704 linux/drivers/media/video/cx231xx/cx231xx-cards.c
--- a/linux/drivers/media/video/cx231xx/cx231xx-cards.c	Fri Mar 27 22:34:06 2009 +0100
+++ b/linux/drivers/media/video/cx231xx/cx231xx-cards.c	Fri Mar 27 22:42:45 2009 +0100
@@ -683,9 +683,7 @@
 	 */
 
 	/* Create v4l2 device */
-	snprintf(dev->v4l2_dev.name, sizeof(dev->v4l2_dev.name),
-					"%s-%03d", "cx231xx", nr);
-	retval = v4l2_device_register(&udev->dev, &dev->v4l2_dev);
+	retval = v4l2_device_register(&interface->dev, &dev->v4l2_dev);
 	if (retval) {
 		cx231xx_errdev("v4l2_device_register failed\n");
 		cx231xx_devused &= ~(1 << nr);
