Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52215 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375Ab1KDMqT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Nov 2011 08:46:19 -0400
Received: from localhost.localdomain (unknown [91.178.160.144])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 2D91335B6E
	for <linux-media@vger.kernel.org>; Fri,  4 Nov 2011 12:46:18 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 3/6] uvcvideo: Add support for LogiLink Wireless Webcam
Date: Fri,  4 Nov 2011 13:46:14 +0100
Message-Id: <1320410777-14108-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1320410777-14108-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1320410777-14108-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The camera requires the PROBE_MINMAX quirk. Add a corresponding entry in
the device IDs list.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/uvc/uvc_driver.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_driver.c b/drivers/media/video/uvc/uvc_driver.c
index 656d4c9..750ab68 100644
--- a/drivers/media/video/uvc/uvc_driver.c
+++ b/drivers/media/video/uvc/uvc_driver.c
@@ -2033,6 +2033,15 @@ MODULE_PARM_DESC(timeout, "Streaming control requests timeout");
  * though they are compliant.
  */
 static struct usb_device_id uvc_ids[] = {
+	/* LogiLink Wireless Webcam */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x0416,
+	  .idProduct		= 0xa91a,
+	  .bInterfaceClass	= USB_CLASS_VIDEO,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0,
+	  .driver_info		= UVC_QUIRK_PROBE_MINMAX },
 	/* Genius eFace 2025 */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
-- 
1.7.3.4

