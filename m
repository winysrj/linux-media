Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.enix.org ([193.19.211.146]:35195 "EHLO smtp.enix.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354Ab2AGOB5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Jan 2012 09:01:57 -0500
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: linux-media@vger.kernel.org, dheitmueller@kernellabs.com,
	srinivasa.deevi@conexant.com
Cc: gregory.clement@free-electrons.com,
	maxime.ripard@free-electrons.com,
	michael.opdenacker@free-electrons.com
Subject: [PATCH 1/4] cx231xx: use URB_NO_TRANSFER_DMA_MAP on URBs allocated with usb_alloc_urb()
Date: Sat,  7 Jan 2012 14:52:37 +0100
Message-Id: <1325944360-28964-2-git-send-email-thomas.petazzoni@free-electrons.com>
In-Reply-To: <1325944360-28964-1-git-send-email-thomas.petazzoni@free-electrons.com>
References: <1325944360-28964-1-git-send-email-thomas.petazzoni@free-electrons.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

URBs allocated with usb_alloc_urb() are allocated from DMA-coherent
areas, and therefore it is not necessary to call dma_map_single() on
such buffers. Worst, on ARM, calling dma_map_single() on a
DMA-coherent buffer will trigger a BUG_ON() in
arch/arm/mm/dma-mapping.c.

Therefore, we mark all URBs allocated with usb_alloc_urb() with the
URB_NO_TRANSFER_DMA_MAP transfer_flags, so that the USB core does not
do dma_map_single()/dma_unmap_single() on those buffers.

This is similar to 882787ff8fdeb0be790547ee9b22b281095e95da for the
gspca driver, and has already been discussed on the linux-media list
in the past:
http://www.mail-archive.com/linux-media@vger.kernel.org/msg37086.html.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
---
 drivers/media/video/cx231xx/cx231xx-audio.c |    4 ++--
 drivers/media/video/cx231xx/cx231xx-core.c  |    4 ++--
 drivers/media/video/cx231xx/cx231xx-vbi.c   |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/cx231xx/cx231xx-audio.c b/drivers/media/video/cx231xx/cx231xx-audio.c
index 30d13c1..e0b2d5c 100644
--- a/drivers/media/video/cx231xx/cx231xx-audio.c
+++ b/drivers/media/video/cx231xx/cx231xx-audio.c
@@ -298,7 +298,7 @@ static int cx231xx_init_audio_isoc(struct cx231xx *dev)
 		urb->context = dev;
 		urb->pipe = usb_rcvisocpipe(dev->udev,
 						dev->adev.end_point_addr);
-		urb->transfer_flags = URB_ISO_ASAP;
+		urb->transfer_flags = URB_ISO_ASAP | URB_NO_TRANSFER_DMA_MAP;
 		urb->transfer_buffer = dev->adev.transfer_buffer[i];
 		urb->interval = 1;
 		urb->complete = cx231xx_audio_isocirq;
@@ -356,7 +356,7 @@ static int cx231xx_init_audio_bulk(struct cx231xx *dev)
 		urb->context = dev;
 		urb->pipe = usb_rcvbulkpipe(dev->udev,
 						dev->adev.end_point_addr);
-		urb->transfer_flags = 0;
+		urb->transfer_flags = URB_NO_TRANSFER_DMA_MAP;
 		urb->transfer_buffer = dev->adev.transfer_buffer[i];
 		urb->complete = cx231xx_audio_bulkirq;
 		urb->transfer_buffer_length = sb_size;
diff --git a/drivers/media/video/cx231xx/cx231xx-core.c b/drivers/media/video/cx231xx/cx231xx-core.c
index d4457f9..d4527f2 100644
--- a/drivers/media/video/cx231xx/cx231xx-core.c
+++ b/drivers/media/video/cx231xx/cx231xx-core.c
@@ -1071,7 +1071,7 @@ int cx231xx_init_isoc(struct cx231xx *dev, int max_packets,
 				 sb_size, cx231xx_isoc_irq_callback, dma_q, 1);
 
 		urb->number_of_packets = max_packets;
-		urb->transfer_flags = URB_ISO_ASAP;
+		urb->transfer_flags = URB_ISO_ASAP | URB_NO_TRANSFER_DMA_MAP;
 
 		k = 0;
 		for (j = 0; j < max_packets; j++) {
@@ -1182,7 +1182,7 @@ int cx231xx_init_bulk(struct cx231xx *dev, int max_packets,
 			return -ENOMEM;
 		}
 		dev->video_mode.bulk_ctl.urb[i] = urb;
-		urb->transfer_flags = 0;
+		urb->transfer_flags = URB_NO_TRANSFER_DMA_MAP;
 
 		dev->video_mode.bulk_ctl.transfer_buffer[i] =
 		    usb_alloc_coherent(dev->udev, sb_size, GFP_KERNEL,
diff --git a/drivers/media/video/cx231xx/cx231xx-vbi.c b/drivers/media/video/cx231xx/cx231xx-vbi.c
index 1c7a4da..852878d 100644
--- a/drivers/media/video/cx231xx/cx231xx-vbi.c
+++ b/drivers/media/video/cx231xx/cx231xx-vbi.c
@@ -452,7 +452,7 @@ int cx231xx_init_vbi_isoc(struct cx231xx *dev, int max_packets,
 			return -ENOMEM;
 		}
 		dev->vbi_mode.bulk_ctl.urb[i] = urb;
-		urb->transfer_flags = 0;
+		urb->transfer_flags = URB_NO_TRANSFER_DMA_MAP;
 
 		dev->vbi_mode.bulk_ctl.transfer_buffer[i] =
 		    kzalloc(sb_size, GFP_KERNEL);
-- 
1.7.4.1

