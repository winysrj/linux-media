Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58265 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755368Ab1IQPeD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Sep 2011 11:34:03 -0400
Received: from localhost.localdomain (unknown [91.178.181.94])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 585DB35A00
	for <linux-media@vger.kernel.org>; Sat, 17 Sep 2011 15:34:02 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/5] uvcvideo: Detect The Imaging Source CCD cameras by vendor and product ID
Date: Sat, 17 Sep 2011 17:33:58 +0200
Message-Id: <1316273642-3624-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Arne Caspari <arne@unicap-imaging.org>

The Imaging Source CCD cameras use a vendor specific interface class
even though they are actually UVC compliant.

Signed-off-by: Arne Caspari <arne@unicap-imaging.org>
---
 drivers/media/video/uvc/uvc_driver.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_driver.c b/drivers/media/video/uvc/uvc_driver.c
index e4100b1..a3c24dd 100644
--- a/drivers/media/video/uvc/uvc_driver.c
+++ b/drivers/media/video/uvc/uvc_driver.c
@@ -2331,6 +2331,14 @@ static struct usb_device_id uvc_ids[] = {
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
 	  .driver_info		= UVC_QUIRK_PROBE_DEF },
+	/* The Imaging Source USB CCD cameras */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x199e,
+	  .idProduct		= 0x8102,
+	  .bInterfaceClass	= USB_CLASS_VENDOR_SPEC,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0 },
 	/* Bodelin ProScopeHR */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_DEV_HI
-- 
1.7.3.4

