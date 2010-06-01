Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46473 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754342Ab0FAIRo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Jun 2010 04:17:44 -0400
Date: Tue, 1 Jun 2010 10:17:27 +0200
From: Dan Carpenter <error27@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] V4L/DVB: cpia_usb: remove unneeded variable
Message-ID: <20100601081727.GL5483@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is just a cleanup patch.  We never use the "udev" variable so I
have removed it.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/media/video/cpia_usb.c b/drivers/media/video/cpia_usb.c
index ef1f893..58d193f 100644
--- a/drivers/media/video/cpia_usb.c
+++ b/drivers/media/video/cpia_usb.c
@@ -584,7 +584,6 @@ static void cpia_disconnect(struct usb_interface *intf)
 {
 	struct cam_data *cam = usb_get_intfdata(intf);
 	struct usb_cpia *ucpia;
-	struct usb_device *udev;
 
 	usb_set_intfdata(intf, NULL);
 	if (!cam)
@@ -606,8 +605,6 @@ static void cpia_disconnect(struct usb_interface *intf)
 	if (waitqueue_active(&ucpia->wq_stream))
 		wake_up_interruptible(&ucpia->wq_stream);
 
-	udev = interface_to_usbdev(intf);
-
 	ucpia->curbuff = ucpia->workbuff = NULL;
 
 	vfree(ucpia->buffers[2]);
