Return-path: <linux-media-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:60679 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753885AbeFTPVZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Jun 2018 11:21:25 -0400
Date: Wed, 20 Jun 2018 17:21:22 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-usb@vger.kernel.org, tglx@linutronix.de
Subject: [PATCH 27/27 v2] media: uvcvideo: use usb_fill_int_urb() for the
 ->intarval value
Message-ID: <20180620152122.ebstiwvdpbhgsbrs@linutronix.de>
References: <20180620110105.19955-1-bigeasy@linutronix.de>
 <3925059.Md1u3KRT1n@avalon>
 <20180620132144.5cdu2ydlqre4ijg6@linutronix.de>
 <18211658.4PQ3SEps0f@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <18211658.4PQ3SEps0f@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

uvc_init_video_isoc() assigns
	urb->interval = p->desc.bInterval;

for the interval. This is correct for FS/LS. For HS/SS the bInterval
value is using a logarithmic encoding. The usb_fill_int_urb() function
takes this into account while settings the ->interval member.
->start_frame is set to -1 on init and should be filled by the HC on
completion of the URB.

Use usb_fill_int_urb() to fill the members of the struct urb.

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
