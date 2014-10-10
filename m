Return-path: <linux-media-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:46876
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751703AbaJJS7w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Oct 2014 14:59:52 -0400
From: John Crispin <blogic@openwrt.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 2/2] [media] uvcvideo: add support for iPassion iP2970
Date: Fri, 10 Oct 2014 20:41:13 +0200
Message-Id: <1412966473-5407-2-git-send-email-blogic@openwrt.org>
In-Reply-To: <1412966473-5407-1-git-send-email-blogic@openwrt.org>
References: <1412966473-5407-1-git-send-email-blogic@openwrt.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This camera chip can be found on D-Link DIR-930 IP cameras.

Signed-off-by: John Crispin <blogic@openwrt.org>
---
 drivers/media/usb/uvc/uvc_driver.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index f8135f4..abf8bf2 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -2486,6 +2486,17 @@ static struct usb_device_id uvc_ids[] = {
 	  .bInterfaceProtocol	= 0,
 	  .driver_info		= UVC_QUIRK_PROBE_MINMAX
 				| UVC_QUIRK_IGNORE_SELECTOR_UNIT },
+	/* iPassion iP2970 */
+	{ .match_flags          = USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x1B3B,
+	  .idProduct		= 0x2970,
+	  .bInterfaceClass	= USB_CLASS_VIDEO,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0,
+	  .driver_info		= UVC_QUIRK_PROBE_MINMAX
+				| UVC_QUIRK_STREAM_NO_FID
+				| UVC_QUIRK_SINGLE_ISO },
 	/* Generic USB Video Class */
 	{ USB_INTERFACE_INFO(USB_CLASS_VIDEO, 1, 0) },
 	{}
-- 
1.7.10.4

