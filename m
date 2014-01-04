Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44193 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064AbaADR0K (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Jan 2014 12:26:10 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v4 RFC 2/2] [media] em28xx: USB: adjust for changed 3.8 USB API
Date: Sat,  4 Jan 2014 09:09:20 -0200
Message-Id: <1388833760-23260-2-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1388833760-23260-1-git-send-email-m.chehab@samsung.com>
References: <1388833760-23260-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The recent changes in the USB API ("implement new semantics for
URB_ISO_ASAP") made the former meaning of the URB_ISO_ASAP flag the
default, and changed this flag to mean that URBs can be delayed.
This is not the behaviour wanted by any of the audio drivers because
it leads to discontinuous playback with very small period sizes.
Therefore, our URBs need to be submitted without this flag.

This patch implements the same fix as found at snd-usb-audio driver
(commit c75c5ab575af7db707689cdbb5a5c458e9a034bb)

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-audio.c | 2 +-
 drivers/media/usb/em28xx/em28xx-core.c  | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
index 30ee389a07f0..084ccb8bbab6 100644
--- a/drivers/media/usb/em28xx/em28xx-audio.c
+++ b/drivers/media/usb/em28xx/em28xx-audio.c
@@ -705,7 +705,7 @@ static int em28xx_audio_init(struct em28xx *dev)
 		urb->dev = dev->udev;
 		urb->context = dev;
 		urb->pipe = usb_rcvisocpipe(dev->udev, EM28XX_EP_AUDIO);
-		urb->transfer_flags = URB_ISO_ASAP | URB_NO_TRANSFER_DMA_MAP;
+		urb->transfer_flags = URB_NO_TRANSFER_DMA_MAP;
 		urb->transfer_buffer = dev->adev.transfer_buffer[i];
 		urb->interval = 1;
 		urb->complete = em28xx_audio_isocirq;
diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index 97cc83c3c287..3fae119fc064 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -953,8 +953,7 @@ int em28xx_alloc_urbs(struct em28xx *dev, enum em28xx_mode mode, int xfer_bulk,
 			usb_fill_int_urb(urb, dev->udev, pipe,
 					 usb_bufs->transfer_buffer[i], sb_size,
 					 em28xx_irq_callback, dev, 1);
-			urb->transfer_flags = URB_ISO_ASAP |
-					      URB_NO_TRANSFER_DMA_MAP;
+			urb->transfer_flags = URB_NO_TRANSFER_DMA_MAP;
 			k = 0;
 			for (j = 0; j < usb_bufs->num_packets; j++) {
 				urb->iso_frame_desc[j].offset = k;
-- 
1.8.3.1

