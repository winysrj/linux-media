Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:44337 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756463AbeAIUjw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 9 Jan 2018 15:39:52 -0500
From: Christoph Hellwig <hch@lst.de>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] media/ttusb-dev: remove pci_zalloc_coherent abuse
Date: Tue,  9 Jan 2018 21:39:38 +0100
Message-Id: <20180109203939.5930-3-hch@lst.de>
In-Reply-To: <20180109203939.5930-1-hch@lst.de>
References: <20180109203939.5930-1-hch@lst.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Switch to a plain kzalloc instea of pci_zalloc_coherent to allocate
memory for the USB DMA.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/media/usb/ttusb-dec/ttusb_dec.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/media/usb/ttusb-dec/ttusb_dec.c b/drivers/media/usb/ttusb-dec/ttusb_dec.c
index cdefb5dfbbdc..794ea8a78181 100644
--- a/drivers/media/usb/ttusb-dec/ttusb_dec.c
+++ b/drivers/media/usb/ttusb-dec/ttusb_dec.c
@@ -127,7 +127,6 @@ struct ttusb_dec {
 	struct urb		*irq_urb;
 	dma_addr_t		irq_dma_handle;
 	void			*iso_buffer;
-	dma_addr_t		iso_dma_handle;
 	struct urb		*iso_urb[ISO_BUF_COUNT];
 	int			iso_stream_count;
 	struct mutex		iso_mutex;
@@ -1185,11 +1184,7 @@ static void ttusb_dec_free_iso_urbs(struct ttusb_dec *dec)
 
 	for (i = 0; i < ISO_BUF_COUNT; i++)
 		usb_free_urb(dec->iso_urb[i]);
-
-	pci_free_consistent(NULL,
-			    ISO_FRAME_SIZE * (FRAMES_PER_ISO_BUF *
-					      ISO_BUF_COUNT),
-			    dec->iso_buffer, dec->iso_dma_handle);
+	kfree(dec->iso_buffer);
 }
 
 static int ttusb_dec_alloc_iso_urbs(struct ttusb_dec *dec)
@@ -1198,10 +1193,8 @@ static int ttusb_dec_alloc_iso_urbs(struct ttusb_dec *dec)
 
 	dprintk("%s\n", __func__);
 
-	dec->iso_buffer = pci_zalloc_consistent(NULL,
-						ISO_FRAME_SIZE * (FRAMES_PER_ISO_BUF * ISO_BUF_COUNT),
-						&dec->iso_dma_handle);
-
+	dec->iso_buffer = kzalloc(ISO_FRAME_SIZE *
+			(FRAMES_PER_ISO_BUF * ISO_BUF_COUNT), GFP_KERNEL);
 	if (!dec->iso_buffer) {
 		dprintk("%s: pci_alloc_consistent - not enough memory\n",
 			__func__);
-- 
2.14.2
