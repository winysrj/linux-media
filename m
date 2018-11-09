Return-path: <linux-media-owner@vger.kernel.org>
Received: from lnfm1.sai.msu.ru ([93.180.26.255]:36552 "EHLO lnfm1.sai.msu.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725758AbeKJFL5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Nov 2018 00:11:57 -0500
From: "Matwey V. Kornilov" <matwey@sai.msu.ru>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: matwey.kornilov@gmail.com,
        "Matwey V. Kornilov" <matwey@sai.msu.ru>, tfiga@chromium.org,
        laurent.pinchart@ideasonboard.com, stern@rowland.harvard.edu,
        ezequiel@collabora.com, hdegoede@redhat.com, hverkuil@xs4all.nl,
        mchehab@kernel.org, rostedt@goodmis.org, mingo@redhat.com,
        isely@pobox.com, bhumirks@gmail.com, colin.king@canonical.com,
        kieran.bingham@ideasonboard.com, keiichiw@chromium.org
Subject: [PATCH v6 2/2] media: usb: pwc: Don't use coherent DMA buffers for ISO transfer
Date: Fri,  9 Nov 2018 22:03:27 +0300
Message-Id: <20181109190327.23606-3-matwey@sai.msu.ru>
In-Reply-To: <20181109190327.23606-1-matwey@sai.msu.ru>
References: <20181109190327.23606-1-matwey@sai.msu.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DMA cocherency slows the transfer down on systems without hardware
coherent DMA.
Instead we use noncocherent DMA memory and explicit sync at data receive
handler.

Based on previous commit the following performance benchmarks have been
carried out. Average memcpy() data transfer rate (rate) and handler
completion time (time) have been measured when running video stream at
640x480 resolution at 10fps.

x86_64 based system (Intel Core i5-3470). This platform has hardware
coherent DMA support and proposed change doesn't make big difference here.

 * kmalloc:            rate = (2.0 +- 0.4) GBps
                       time = (5.0 +- 3.0) usec
 * usb_alloc_coherent: rate = (3.4 +- 1.2) GBps
                       time = (3.5 +- 3.0) usec

We see that the measurements agree within error ranges in this case.
So theoretically predicted performance downgrade cannot be reliably
measured here.

armv7l based system (TI AM335x BeagleBone Black @ 300MHz). This platform
has no hardware coherent DMA support. DMA coherence is implemented via
disabled page caching that slows down memcpy() due to memory controller
behaviour.

 * kmalloc:            rate =  ( 94 +- 4) MBps
                       time =  (101 +- 4) usec
 * usb_alloc_coherent: rate = (28.1 +- 0.1) MBps
                       time =  (341 +- 2) usec

Note, that quantative difference leads (this commit leads to 3.3 times
acceleration) to qualitative behavior change in this case. As it was
stated before, the video stream cannot be successfully received at AM335x
platforms with MUSB based USB host controller due to performance issues
[1].

[1] https://www.spinics.net/lists/linux-usb/msg165735.html

Signed-off-by: Matwey V. Kornilov <matwey@sai.msu.ru>
---
 drivers/media/usb/pwc/pwc-if.c | 62 +++++++++++++++++++++++++++++++++---------
 1 file changed, 49 insertions(+), 13 deletions(-)

diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
index 53c111bd5a22..a81fb319b339 100644
--- a/drivers/media/usb/pwc/pwc-if.c
+++ b/drivers/media/usb/pwc/pwc-if.c
@@ -159,6 +159,32 @@ static const struct video_device pwc_template = {
 /***************************************************************************/
 /* Private functions */
 
+static void *pwc_alloc_urb_buffer(struct device *dev,
+				  size_t size, dma_addr_t *dma_handle)
+{
+	void *buffer = kmalloc(size, GFP_KERNEL);
+
+	if (!buffer)
+		return NULL;
+
+	*dma_handle = dma_map_single(dev, buffer, size, DMA_FROM_DEVICE);
+	if (dma_mapping_error(dev, *dma_handle)) {
+		kfree(buffer);
+		return NULL;
+	}
+
+	return buffer;
+}
+
+static void pwc_free_urb_buffer(struct device *dev,
+				size_t size,
+				void *buffer,
+				dma_addr_t dma_handle)
+{
+	dma_unmap_single(dev, dma_handle, size, DMA_FROM_DEVICE);
+	kfree(buffer);
+}
+
 static struct pwc_frame_buf *pwc_get_next_fill_buf(struct pwc_device *pdev)
 {
 	unsigned long flags = 0;
@@ -306,6 +332,11 @@ static void pwc_isoc_handler(struct urb *urb)
 	/* Reset ISOC error counter. We did get here, after all. */
 	pdev->visoc_errors = 0;
 
+	dma_sync_single_for_cpu(&urb->dev->dev,
+				urb->transfer_dma,
+				urb->transfer_buffer_length,
+				DMA_FROM_DEVICE);
+
 	/* vsync: 0 = don't copy data
 		  1 = sync-hunt
 		  2 = synched
@@ -352,6 +383,11 @@ static void pwc_isoc_handler(struct urb *urb)
 		pdev->vlast_packet_size = flen;
 	}
 
+	dma_sync_single_for_device(&urb->dev->dev,
+				   urb->transfer_dma,
+				   urb->transfer_buffer_length,
+				   DMA_FROM_DEVICE);
+
 handler_end:
 	trace_pwc_handler_exit(urb, pdev);
 
@@ -428,16 +464,15 @@ static int pwc_isoc_init(struct pwc_device *pdev)
 		urb->dev = udev;
 		urb->pipe = usb_rcvisocpipe(udev, pdev->vendpoint);
 		urb->transfer_flags = URB_ISO_ASAP | URB_NO_TRANSFER_DMA_MAP;
-		urb->transfer_buffer = usb_alloc_coherent(udev,
-							  ISO_BUFFER_SIZE,
-							  GFP_KERNEL,
-							  &urb->transfer_dma);
+		urb->transfer_buffer_length = ISO_BUFFER_SIZE;
+		urb->transfer_buffer = pwc_alloc_urb_buffer(&udev->dev,
+							    urb->transfer_buffer_length,
+							    &urb->transfer_dma);
 		if (urb->transfer_buffer == NULL) {
 			PWC_ERROR("Failed to allocate urb buffer %d\n", i);
 			pwc_isoc_cleanup(pdev);
 			return -ENOMEM;
 		}
-		urb->transfer_buffer_length = ISO_BUFFER_SIZE;
 		urb->complete = pwc_isoc_handler;
 		urb->context = pdev;
 		urb->start_frame = 0;
@@ -488,15 +523,16 @@ static void pwc_iso_free(struct pwc_device *pdev)
 
 	/* Freeing ISOC buffers one by one */
 	for (i = 0; i < MAX_ISO_BUFS; i++) {
-		if (pdev->urbs[i]) {
+		struct urb *urb = pdev->urbs[i];
+
+		if (urb) {
 			PWC_DEBUG_MEMORY("Freeing URB\n");
-			if (pdev->urbs[i]->transfer_buffer) {
-				usb_free_coherent(pdev->udev,
-					pdev->urbs[i]->transfer_buffer_length,
-					pdev->urbs[i]->transfer_buffer,
-					pdev->urbs[i]->transfer_dma);
-			}
-			usb_free_urb(pdev->urbs[i]);
+			if (urb->transfer_buffer)
+				pwc_free_urb_buffer(&urb->dev->dev,
+						    urb->transfer_buffer_length,
+						    urb->transfer_buffer,
+						    urb->transfer_dma);
+			usb_free_urb(urb);
 			pdev->urbs[i] = NULL;
 		}
 	}
-- 
2.16.4
