Return-path: <linux-media-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:59948 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754173AbeFTLBq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Jun 2018 07:01:46 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-usb@vger.kernel.org, tglx@linutronix.de,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 27/27] media: uvcvideo: use usb_fill_int_urb()
Date: Wed, 20 Jun 2018 13:01:05 +0200
Message-Id: <20180620110105.19955-28-bigeasy@linutronix.de>
In-Reply-To: <20180620110105.19955-1-bigeasy@linutronix.de>
References: <20180620110105.19955-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using usb_fill_int_urb() helps to find code which initializes an
URB. A grep for members of the struct (like ->complete) reveal lots
of other things, too.
usb_fill_int_urb() also checks bInterval to be in the 1…16 range on
HS/SS.

Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/media/usb/uvc/uvc_video.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index a88b2e51a666..79e7a827ed44 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1619,21 +1619,19 @@ static int uvc_init_video_isoc(struct uvc_streaming *stream,
 			return -ENOMEM;
 		}
 
-		urb->dev = stream->dev->udev;
-		urb->context = stream;
-		urb->pipe = usb_rcvisocpipe(stream->dev->udev,
-				ep->desc.bEndpointAddress);
+		usb_fill_int_urb(urb, stream->dev->udev,
+				 usb_rcvisocpipe(stream->dev->udev,
+						 ep->desc.bEndpointAddress),
+				 stream->urb_buffer[i], size,
+				 uvc_video_complete, stream,
+				 ep->desc.bInterval);
 #ifndef CONFIG_DMA_NONCOHERENT
 		urb->transfer_flags = URB_ISO_ASAP | URB_NO_TRANSFER_DMA_MAP;
 		urb->transfer_dma = stream->urb_dma[i];
 #else
 		urb->transfer_flags = URB_ISO_ASAP;
 #endif
-		urb->interval = ep->desc.bInterval;
-		urb->transfer_buffer = stream->urb_buffer[i];
-		urb->complete = uvc_video_complete;
 		urb->number_of_packets = npackets;
-		urb->transfer_buffer_length = size;
 
 		for (j = 0; j < npackets; ++j) {
 			urb->iso_frame_desc[j].offset = j * psize;
-- 
2.17.1
