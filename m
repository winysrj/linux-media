Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:48873 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755057Ab0JFI7j (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Oct 2010 04:59:39 -0400
Received: from localhost.localdomain (unknown [91.178.188.185])
	by perceval.irobotique.be (Postfix) with ESMTPSA id 93E6235D56
	for <linux-media@vger.kernel.org>; Wed,  6 Oct 2010 08:59:38 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 01/14] uvcvideo: Fix support for Medion Akoya All-in-one PC integrated webcam
Date: Wed,  6 Oct 2010 10:59:39 +0200
Message-Id: <1286355592-13603-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1286355592-13603-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1286355592-13603-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The camera requires the STREAM_NO_FID quirk. Add a corresponding entry
in the device IDs list.

Cc: stable.org
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/uvc/uvc_driver.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_driver.c b/drivers/media/video/uvc/uvc_driver.c
index 28ed5b4..a4bdbac 100644
--- a/drivers/media/video/uvc/uvc_driver.c
+++ b/drivers/media/video/uvc/uvc_driver.c
@@ -2092,6 +2092,15 @@ static struct usb_device_id uvc_ids[] = {
 	  .bInterfaceProtocol	= 0,
 	  .driver_info		= UVC_QUIRK_PROBE_MINMAX
 				| UVC_QUIRK_PROBE_DEF },
+	/* IMC Networks (Medion Akoya) */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x13d3,
+	  .idProduct		= 0x5103,
+	  .bInterfaceClass	= USB_CLASS_VIDEO,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0,
+	  .driver_info		= UVC_QUIRK_STREAM_NO_FID },
 	/* Syntek (HP Spartan) */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
-- 
1.7.2.2

