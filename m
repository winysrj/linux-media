Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39587 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab2GQMH4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Jul 2012 08:07:56 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tony Nie <tony_nie@realsil.com.cn>
Cc: linux-media@vger.kernel.org
Subject: [PATCH] uvcvideo: Support super speed endpoints
Date: Tue, 17 Jul 2012 14:07:57 +0200
Message-Id: <1342526877-5110-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <50037E43.3070606@realsil.com.cn>
References: <50037E43.3070606@realsil.com.cn>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Compute the maximum number of bytes per interval using the burst and
multiplier values for super speed endpoints.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/uvc/uvc_video.c |   28 +++++++++++++++++++++++-----
 1 files changed, 23 insertions(+), 5 deletions(-)

Hi Tony,

Could you please test the following patch ?

I wonder whether it would make sense to move the uvc_endpoint_max_bpi()
function to the USB core.

diff --git a/drivers/media/video/uvc/uvc_video.c b/drivers/media/video/uvc/uvc_video.c
index 7ac4347..0d2e5c2 100644
--- a/drivers/media/video/uvc/uvc_video.c
+++ b/drivers/media/video/uvc/uvc_video.c
@@ -1439,6 +1439,26 @@ static void uvc_uninit_video(struct uvc_streaming *stream, int free_buffers)
 }
 
 /*
+ * Compute the maximum number of bytes per interval for an endpoint.
+ */
+static unsigned int uvc_endpoint_max_bpi(struct usb_device *dev,
+					 struct usb_host_endpoint *ep)
+{
+	u16 psize;
+
+	switch (dev->speed) {
+	case USB_SPEED_SUPER:
+		return ep->ss_ep_comp.wBytesPerInterval;
+	case USB_SPEED_HIGH:
+		psize = usb_endpoint_maxp(&ep->desc);
+		return (psize & 0x07ff) * (1 + ((psize >> 11) & 3));
+	default:
+		psize = usb_endpoint_maxp(&ep->desc);
+		return psize & 0x07ff;
+	}
+}
+
+/*
  * Initialize isochronous URBs and allocate transfer buffers. The packet size
  * is given by the endpoint.
  */
@@ -1450,8 +1470,7 @@ static int uvc_init_video_isoc(struct uvc_streaming *stream,
 	u16 psize;
 	u32 size;
 
-	psize = le16_to_cpu(ep->desc.wMaxPacketSize);
-	psize = (psize & 0x07ff) * (1 + ((psize >> 11) & 3));
+	psize = uvc_endpoint_max_bpi(stream->dev->udev, ep);
 	size = stream->ctrl.dwMaxVideoFrameSize;
 
 	npackets = uvc_alloc_urb_buffers(stream, size, psize, gfp_flags);
@@ -1506,7 +1525,7 @@ static int uvc_init_video_bulk(struct uvc_streaming *stream,
 	u16 psize;
 	u32 size;
 
-	psize = le16_to_cpu(ep->desc.wMaxPacketSize) & 0x07ff;
+	psize = usb_endpoint_maxp(&ep->desc) & 0x7ff;
 	size = stream->ctrl.dwMaxPayloadTransferSize;
 	stream->bulk.max_payload_size = size;
 
@@ -1595,8 +1614,7 @@ static int uvc_init_video(struct uvc_streaming *stream, gfp_t gfp_flags)
 				continue;
 
 			/* Check if the bandwidth is high enough. */
-			psize = le16_to_cpu(ep->desc.wMaxPacketSize);
-			psize = (psize & 0x07ff) * (1 + ((psize >> 11) & 3));
+			psize = uvc_endpoint_max_bpi(stream->dev->udev, ep);
 			if (psize >= bandwidth && psize <= best_psize) {
 				altsetting = alts->desc.bAlternateSetting;
 				best_psize = psize;
-- 
Regards,

Laurent Pinchart

