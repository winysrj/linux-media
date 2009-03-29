Return-path: <linux-media-owner@vger.kernel.org>
Received: from tichy.grunau.be ([85.131.189.73]:52209 "EHLO tichy.grunau.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753430AbZC2Mmc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Mar 2009 08:42:32 -0400
Date: Sun, 29 Mar 2009 14:42:11 +0200
From: Janne Grunau <j@jannau.net>
To: linux-media@vger.kernel.org
Cc: Mike Isely <isely@pobox.com>
Subject: [PATCH 4 of 6] pvrusb2: use usb_interface.dev for
	v4l2_device_register
Message-ID: <20090329124211.GE637@aniel>
References: <patchbomb.1238329154@aniel>
MIME-Version: 1.0
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: inline; filename="v4l2_device_usb_interface-4.patch"
In-Reply-To: <patchbomb.1238329154@aniel>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

# HG changeset patch
# User Janne Grunau <j@jannau.net>
# Date 1238190885 -3600
# Node ID 210007cef5bdef2364590755a2b7ab219534db16
# Parent  09d6b9873181402892bb746d101b1b22b245208d
pvrusb2: use usb_interface.dev for v4l2_device_register

From: Janne Grunau <j@jannau.net>

Priority: normal

Signed-off-by: Janne Grunau <j@jannau.net>

diff -r 09d6b9873181 -r 210007cef5bd linux/drivers/media/video/pvrusb2/pvrusb2-hdw.c
--- a/linux/drivers/media/video/pvrusb2/pvrusb2-hdw.c	Fri Mar 27 22:53:20 2009 +0100
+++ b/linux/drivers/media/video/pvrusb2/pvrusb2-hdw.c	Fri Mar 27 22:54:45 2009 +0100
@@ -2591,7 +2591,7 @@
 	hdw->ctl_read_urb = usb_alloc_urb(0,GFP_KERNEL);
 	if (!hdw->ctl_read_urb) goto fail;
 
-	if (v4l2_device_register(&usb_dev->dev, &hdw->v4l2_dev) != 0) {
+	if (v4l2_device_register(&intf->dev, &hdw->v4l2_dev) != 0) {
 		pvr2_trace(PVR2_TRACE_ERROR_LEGS,
 			   "Error registering with v4l core, giving up");
 		goto fail;
