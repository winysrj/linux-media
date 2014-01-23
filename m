Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out003.kontent.com ([81.88.40.217]:33404 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbaAWK2a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jan 2014 05:28:30 -0500
From: oliver@neukum.org
To: laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org
Cc: Oliver Neukum <oneukum@suse.de>
Subject: [PATCH] uvc: simplify redundant check
Date: Thu, 23 Jan 2014 11:28:24 +0100
Message-Id: <1390472905-29586-1-git-send-email-oliver@neukum.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Oliver Neukum <oneukum@suse.de>

x < constant implies x + unsigned < constant
That check just obfuscates the code

Signed-off-by: Oliver Neukum <oneukum@suse.de>
---
 drivers/media/usb/uvc/uvc_driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index c3bb250..b6cac17 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -925,7 +925,7 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 	case UVC_VC_HEADER:
 		n = buflen >= 12 ? buffer[11] : 0;
 
-		if (buflen < 12 || buflen < 12 + n) {
+		if (buflen < 12 + n) {
 			uvc_trace(UVC_TRACE_DESCR, "device %d videocontrol "
 				"interface %d HEADER error\n", udev->devnum,
 				alts->desc.bInterfaceNumber);
-- 
1.8.4

