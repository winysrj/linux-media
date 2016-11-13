Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:33052 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932923AbcKMKb3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 13 Nov 2016 05:31:29 -0500
From: Mike Krinkin <krinkin.m.u@gmail.com>
To: linux-usb@vger.kernel.org
Cc: felipe.balbi@linux.intel.com, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org, mchehab@kernel.org,
        laurent.pinchart@ideasonboard.com,
        Mike Krinkin <krinkin.m.u@gmail.com>
Subject: [PATCH] usb: core: urb make use of usb_endpoint_maxp_mult
Date: Sun, 13 Nov 2016 13:31:16 +0300
Message-Id: <1479033076-2995-1-git-send-email-krinkin.m.u@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since usb_endpoint_maxp now returns only lower 11 bits mult
calculation here isn't correct anymore and that breaks webcam
for me. Patch make use of usb_endpoint_maxp_mult instead of
direct calculation.

Fixes: abb621844f6a ("usb: ch9: make usb_endpoint_maxp() return
       only packet size")

Signed-off-by: Mike Krinkin <krinkin.m.u@gmail.com>
---
 drivers/usb/core/urb.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/core/urb.c b/drivers/usb/core/urb.c
index 0be49a1..d75cb8c 100644
--- a/drivers/usb/core/urb.c
+++ b/drivers/usb/core/urb.c
@@ -412,11 +412,8 @@ int usb_submit_urb(struct urb *urb, gfp_t mem_flags)
 		}
 
 		/* "high bandwidth" mode, 1-3 packets/uframe? */
-		if (dev->speed == USB_SPEED_HIGH) {
-			int	mult = 1 + ((max >> 11) & 0x03);
-			max &= 0x07ff;
-			max *= mult;
-		}
+		if (dev->speed == USB_SPEED_HIGH)
+			max *= usb_endpoint_maxp_mult(&ep->desc);
 
 		if (urb->number_of_packets <= 0)
 			return -EINVAL;
-- 
2.7.4

