Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:41571 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742AbaAXVSd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jan 2014 16:18:33 -0500
Received: by mail-ob0-f174.google.com with SMTP id uy5so4153108obc.5
        for <linux-media@vger.kernel.org>; Fri, 24 Jan 2014 13:18:32 -0800 (PST)
From: Thomas Pugliese <thomas.pugliese@gmail.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com,
	Thomas Pugliese <thomas.pugliese@gmail.com>
Subject: [PATCH] uvc: update uvc_endpoint_max_bpi to handle USB_SPEED_WIRELESS devices
Date: Fri, 24 Jan 2014 15:17:28 -0600
Message-Id: <1390598248-343-1-git-send-email-thomas.pugliese@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Isochronous endpoints on devices with speed == USB_SPEED_WIRELESS can 
have a max packet size ranging from 1-3584 bytes.  Add a case to 
uvc_endpoint_max_bpi to handle USB_SPEED_WIRELESS.  Otherwise endpoints 
for those devices will fall to the default case which masks off any 
values > 2047.  This causes uvc_init_video to underestimate the 
bandwidth available and fail to find a suitable alt setting for high 
bandwidth video streams.

Signed-off-by: Thomas Pugliese <thomas.pugliese@gmail.com>
---
 drivers/media/usb/uvc/uvc_video.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index 898c208..103cd4e 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1453,6 +1453,9 @@ static unsigned int uvc_endpoint_max_bpi(struct usb_device *dev,
 	case USB_SPEED_HIGH:
 		psize = usb_endpoint_maxp(&ep->desc);
 		return (psize & 0x07ff) * (1 + ((psize >> 11) & 3));
+	case USB_SPEED_WIRELESS:
+		psize = usb_endpoint_maxp(&ep->desc);
+		return psize;
 	default:
 		psize = usb_endpoint_maxp(&ep->desc);
 		return psize & 0x07ff;
-- 
1.8.3.2

