Return-path: <linux-media-owner@vger.kernel.org>
Received: from tichy.grunau.be ([85.131.189.73]:33353 "EHLO tichy.grunau.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757125AbZC2O62 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Mar 2009 10:58:28 -0400
Date: Sun, 29 Mar 2009 16:58:07 +0200
From: Janne Grunau <j@jannau.net>
To: linux-media@vger.kernel.org
Cc: Srinivasa Deevi <srinivasa.deevi@conexant.com>
Subject: [PATCH 2 of 8] cx231xx: use usb_interface.dev for
	v4l2_device_register
Message-ID: <20090329145807.GC17855@aniel>
References: <patchbomb.1238338474@aniel>
MIME-Version: 1.0
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: inline; filename="cx231xx_usb_intf_v4l2_dev.diff"
In-Reply-To: <patchbomb.1238338474@aniel>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

# HG changeset patch
# User Janne Grunau <j@jannau.net>
# Date 1238338428 -7200
# Node ID eb7601494dc5e58ed519dde38c763fee20cbd0a9
# Parent  36b738f9cb1916e9885084f32bb29373f70f0720
cx231xx: use usb_interface.dev for v4l2_device_register

Priority: normal

Signed-off-by: Janne Grunau <j@jannau.net>

diff -r 36b738f9cb19 -r eb7601494dc5 linux/drivers/media/video/cx231xx/cx231xx-cards.c
--- a/linux/drivers/media/video/cx231xx/cx231xx-cards.c	Sun Mar 29 16:53:48 2009 +0200
+++ b/linux/drivers/media/video/cx231xx/cx231xx-cards.c	Sun Mar 29 16:53:48 2009 +0200
@@ -685,7 +685,7 @@
 	/* Create v4l2 device */
 	snprintf(dev->v4l2_dev.name, sizeof(dev->v4l2_dev.name),
 					"%s-%03d", "cx231xx", nr);
-	retval = v4l2_device_register(&udev->dev, &dev->v4l2_dev);
+	retval = v4l2_device_register(&interface->dev, &dev->v4l2_dev);
 	if (retval) {
 		cx231xx_errdev("v4l2_device_register failed\n");
 		cx231xx_devused &= ~(1 << nr);
