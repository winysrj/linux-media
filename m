Return-path: <linux-media-owner@vger.kernel.org>
Received: from tichy.grunau.be ([85.131.189.73]:33358 "EHLO tichy.grunau.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757175AbZC2O73 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Mar 2009 10:59:29 -0400
Received: from localhost (unknown [78.52.195.10])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by tichy.grunau.be (Postfix) with ESMTPSA id DF6D190002
	for <linux-media@vger.kernel.org>; Sun, 29 Mar 2009 16:59:06 +0200 (CEST)
Date: Sun, 29 Mar 2009 16:59:08 +0200
From: Janne Grunau <j@jannau.net>
To: linux-media@vger.kernel.org
Subject: [PATCH 5 of 8] pvrusb2: use usb_interface.dev for
	v4l2_device_register
Message-ID: <20090329145908.GF17855@aniel>
References: <patchbomb.1238338474@aniel>
MIME-Version: 1.0
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: inline; filename="pvrusb2_usb_intf_v4l2_dev.diff"
In-Reply-To: <patchbomb.1238338474@aniel>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

# HG changeset patch
# User Janne Grunau <j@jannau.net>
# Date 1238338428 -7200
# Node ID 2d52ac089920f9ac36960c0245442fd89a06bb75
# Parent  01af508490af3bc9c939c36001d6989e2c147aa0
pvrusb2: use usb_interface.dev for v4l2_device_register

Priority: normal

Signed-off-by: Janne Grunau <j@jannau.net>

diff -r 01af508490af -r 2d52ac089920 linux/drivers/media/video/pvrusb2/pvrusb2-hdw.c
--- a/linux/drivers/media/video/pvrusb2/pvrusb2-hdw.c	Sun Mar 29 16:53:48 2009 +0200
+++ b/linux/drivers/media/video/pvrusb2/pvrusb2-hdw.c	Sun Mar 29 16:53:48 2009 +0200
@@ -2591,7 +2591,7 @@
 	hdw->ctl_read_urb = usb_alloc_urb(0,GFP_KERNEL);
 	if (!hdw->ctl_read_urb) goto fail;
 
-	if (v4l2_device_register(&usb_dev->dev, &hdw->v4l2_dev) != 0) {
+	if (v4l2_device_register(&intf->dev, &hdw->v4l2_dev) != 0) {
 		pvr2_trace(PVR2_TRACE_ERROR_LEGS,
 			   "Error registering with v4l core, giving up");
 		goto fail;
