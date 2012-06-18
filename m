Return-path: <linux-media-owner@vger.kernel.org>
Received: from matrix.voodoobox.net ([75.127.97.206]:35293 "EHLO
	matrix.voodoobox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580Ab2FREPX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jun 2012 00:15:23 -0400
Received: from shed.thedillows.org ([IPv6:2001:470:8:bf8::2])
	by matrix.voodoobox.net (8.13.8/8.13.8) with ESMTP id q5I4FM7I024386
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 18 Jun 2012 00:15:22 -0400
Received: from [192.168.0.10] (obelisk.thedillows.org [192.168.0.10])
	by shed.thedillows.org (8.14.4/8.14.4) with ESMTP id q5I4FL5W030882
	for <linux-media@vger.kernel.org>; Mon, 18 Jun 2012 00:15:21 -0400
Message-ID: <1339992921.32360.38.camel@obelisk.thedillows.org>
Subject: [PATCH 1/2] [media] cx231xx: don't DMA to random addresses
From: David Dillow <dave@thedillows.org>
To: linux-media@vger.kernel.org
Date: Mon, 18 Jun 2012 00:15:21 -0400
In-Reply-To: <1339992819.32360.36.camel@obelisk.thedillows.org>
References: <1339992819.32360.36.camel@obelisk.thedillows.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit 7a6f6c29d264cdd2fe0eb3d923217eed5f0ad134 (cx231xx: use
URB_NO_TRANSFER_DMA_MAP) was intended to avoid mapping the DMA buffer
for URB twice. This works for the URBs allocated with usb_alloc_urb(),
as those are allocated from cohernent DMA pools, but the flag was also
added for the VBI and audio URBs, which have a manually allocated area.
This leaves the random trash in the structure after allocation as the
DMA address, corrupting memory and preventing VBI and audio from
working. Letting the USB core map the buffers solves the problem.

Signed-off-by: David Dillow <dave@thedillows.org>
--
This should also go to -stable, as this can corrupt memory.

diff --git a/drivers/media/video/cx231xx/cx231xx-audio.c b/drivers/media/video/cx231xx/cx231xx-audio.c
index 068f78d..b4c99c7 100644
--- a/drivers/media/video/cx231xx/cx231xx-audio.c
+++ b/drivers/media/video/cx231xx/cx231xx-audio.c
@@ -307,7 +307,7 @@ static int cx231xx_init_audio_isoc(struct cx231xx *dev)
 		urb->context = dev;
 		urb->pipe = usb_rcvisocpipe(dev->udev,
 						dev->adev.end_point_addr);
-		urb->transfer_flags = URB_ISO_ASAP | URB_NO_TRANSFER_DMA_MAP;
+		urb->transfer_flags = URB_ISO_ASAP;
 		urb->transfer_buffer = dev->adev.transfer_buffer[i];
 		urb->interval = 1;
 		urb->complete = cx231xx_audio_isocirq;
@@ -368,7 +368,7 @@ static int cx231xx_init_audio_bulk(struct cx231xx *dev)
 		urb->context = dev;
 		urb->pipe = usb_rcvbulkpipe(dev->udev,
 						dev->adev.end_point_addr);
-		urb->transfer_flags = URB_NO_TRANSFER_DMA_MAP;
+		urb->transfer_flags = 0;
 		urb->transfer_buffer = dev->adev.transfer_buffer[i];
 		urb->complete = cx231xx_audio_bulkirq;
 		urb->transfer_buffer_length = sb_size;
diff --git a/drivers/media/video/cx231xx/cx231xx-vbi.c b/drivers/media/video/cx231xx/cx231xx-vbi.c
index 3d15314..ac7db52 100644
--- a/drivers/media/video/cx231xx/cx231xx-vbi.c
+++ b/drivers/media/video/cx231xx/cx231xx-vbi.c
@@ -448,7 +448,7 @@ int cx231xx_init_vbi_isoc(struct cx231xx *dev, int max_packets,
 			return -ENOMEM;
 		}
 		dev->vbi_mode.bulk_ctl.urb[i] = urb;
-		urb->transfer_flags = URB_NO_TRANSFER_DMA_MAP;
+		urb->transfer_flags = 0;
 
 		dev->vbi_mode.bulk_ctl.transfer_buffer[i] =
 		    kzalloc(sb_size, GFP_KERNEL);


