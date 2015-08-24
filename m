Return-path: <linux-media-owner@vger.kernel.org>
Received: from vms173025pub.verizon.net ([206.46.173.25]:59329 "EHLO
	vms173025pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbbHXX6n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Aug 2015 19:58:43 -0400
Received: from smtp.flippedperspective.com ([108.38.100.161])
 by vms173025.mailsrvcs.net
 (Oracle Communications Messaging Server 7.0.5.32.0 64bit (built Jul 16 2014))
 with ESMTPA id <0NTL0072EZTFRQA0@vms173025.mailsrvcs.net> for
 linux-media@vger.kernel.org; Mon, 24 Aug 2015 17:58:27 -0500 (CDT)
From: Zvi Effron <viz+kernel@flippedperspective.com>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Zvi Effron <viz+kernel@flippedperspective.com>
Subject: [PATCH] add interface protocol 1 for Surface Pro 3 cameras
Date: Mon, 24 Aug 2015 15:57:42 -0700
Message-id: <1440457062-2633-1-git-send-email-viz+kernel@flippedperspective.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The cameras on the Surface Pro 3 report interface protocol of 1.
The generic USB video class doesn't work for them.
This adds entries for the front and rear camera.

Signed-off-by: Zvi Effron <viz+kernel@flippedperspective.com>
---
 drivers/media/usb/uvc/uvc_driver.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 4b5b3e8..d2fdbc1 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -2142,6 +2142,22 @@ static struct usb_device_id uvc_ids[] = {
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
 	  .driver_info		= UVC_QUIRK_PROBE_MINMAX },
+	/* Microsoft Surface Pro 3 LifeCam Front */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x045e,
+	  .idProduct		= 0x07be,
+	  .bInterfaceClass	= USB_CLASS_VIDEO,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 1 },
+	/* Microsoft Surface Pro 3 LifeCam Rear */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x045e,
+	  .idProduct		= 0x07bf,
+	  .bInterfaceClass	= USB_CLASS_VIDEO,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 1 },
 	/* Logitech Quickcam Fusion */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
-- 
2.4.3

