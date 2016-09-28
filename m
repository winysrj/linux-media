Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:36382 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932518AbcI1NGo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Sep 2016 09:06:44 -0400
From: Felipe Balbi <felipe.balbi@linux.intel.com>
To: Linux USB <linux-usb@vger.kernel.org>
Cc: Felipe Balbi <felipe.balbi@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: [RFC/PATCH 14/45] media: usb: uvc: make use of new usb_endpoint_maxp_mult()
Date: Wed, 28 Sep 2016 16:05:23 +0300
Message-Id: <20160928130554.29790-15-felipe.balbi@linux.intel.com>
In-Reply-To: <20160928130554.29790-1-felipe.balbi@linux.intel.com>
References: <20160928130554.29790-1-felipe.balbi@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We have introduced a helper to calculate multiplier
value from wMaxPacketSize. Start using it.

Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
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
2.10.0.440.g21f862b

