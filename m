Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:43997 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752193AbdJTHZn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Oct 2017 03:25:43 -0400
Received: by mail-pf0-f195.google.com with SMTP id a8so9830902pfc.0
        for <linux-media@vger.kernel.org>; Fri, 20 Oct 2017 00:25:42 -0700 (PDT)
From: Jaejoong Kim <climbbb.kim@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, Jaejoong Kim <climbbb.kim@gmail.com>
Subject: [PATCH 1/2] media: usb: uvc: remove duplicate & operation
Date: Fri, 20 Oct 2017 16:25:27 +0900
Message-Id: <1508484328-11018-2-git-send-email-climbbb.kim@gmail.com>
In-Reply-To: <1508484328-11018-1-git-send-email-climbbb.kim@gmail.com>
References: <1508484328-11018-1-git-send-email-climbbb.kim@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

usb_endpoint_maxp() has an inline keyword and searches for bits[10:0]
by & operation with 0x7ff. So, we can remove the duplicate & operation
with 0x7ff.

Signed-off-by: Jaejoong Kim <climbbb.kim@gmail.com>
---
 drivers/media/usb/uvc/uvc_video.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index fb86d6a..f4ace63 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1469,13 +1469,13 @@ static unsigned int uvc_endpoint_max_bpi(struct usb_device *dev,
 	case USB_SPEED_HIGH:
 		psize = usb_endpoint_maxp(&ep->desc);
 		mult = usb_endpoint_maxp_mult(&ep->desc);
-		return (psize & 0x07ff) * mult;
+		return psize * mult;
 	case USB_SPEED_WIRELESS:
 		psize = usb_endpoint_maxp(&ep->desc);
 		return psize;
 	default:
 		psize = usb_endpoint_maxp(&ep->desc);
-		return psize & 0x07ff;
+		return psize;
 	}
 }
 
-- 
2.7.4
