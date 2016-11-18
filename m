Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43600 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754189AbcKRPHI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Nov 2016 10:07:08 -0500
Subject: patch "media: usb: uvc: make use of new usb_endpoint_maxp_mult()" added to usb-testing
To: felipe.balbi@linux.intel.com, laurent.pinchart@ideasonboard.com,
        linux-media@vger.kernel.org, mchehab@kernel.org
From: <gregkh@linuxfoundation.org>
Date: Fri, 18 Nov 2016 16:06:32 +0100
Message-ID: <147948159214175@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


This is a note to let you know that I've just added the patch titled

    media: usb: uvc: make use of new usb_endpoint_maxp_mult()

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


>From 08295ee0e6976b060cd5c2a59877d8ea6379075c Mon Sep 17 00:00:00 2001
From: Felipe Balbi <felipe.balbi@linux.intel.com>
Date: Wed, 28 Sep 2016 13:22:53 +0300
Subject: media: usb: uvc: make use of new usb_endpoint_maxp_mult()

We have introduced a helper to calculate multiplier
value from wMaxPacketSize. Start using it.

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: <linux-media@vger.kernel.org>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
---
 drivers/media/usb/uvc/uvc_video.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index b5589d5f5da4..11e0e5f4e1c2 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1467,6 +1467,7 @@ static unsigned int uvc_endpoint_max_bpi(struct usb_device *dev,
 					 struct usb_host_endpoint *ep)
 {
 	u16 psize;
+	u16 mult;
 
 	switch (dev->speed) {
 	case USB_SPEED_SUPER:
@@ -1474,7 +1475,8 @@ static unsigned int uvc_endpoint_max_bpi(struct usb_device *dev,
 		return le16_to_cpu(ep->ss_ep_comp.wBytesPerInterval);
 	case USB_SPEED_HIGH:
 		psize = usb_endpoint_maxp(&ep->desc);
-		return (psize & 0x07ff) * (1 + ((psize >> 11) & 3));
+		mult = usb_endpoint_maxp_mult(&ep->desc);
+		return (psize & 0x07ff) * mult;
 	case USB_SPEED_WIRELESS:
 		psize = usb_endpoint_maxp(&ep->desc);
 		return psize;
-- 
2.10.2


