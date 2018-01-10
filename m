Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:34105 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751932AbeAJSD3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 Jan 2018 13:03:29 -0500
From: Christoph Hellwig <hch@lst.de>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Kong Lai <kong.lai@tundra.com>, linux-pci@vger.kernel.org,
        linux-media@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] media/ttusb-budget: remove pci_zalloc_coherent abuse
Date: Wed, 10 Jan 2018 19:03:19 +0100
Message-Id: <20180110180322.30186-2-hch@lst.de>
In-Reply-To: <20180110180322.30186-1-hch@lst.de>
References: <20180110180322.30186-1-hch@lst.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Switch to a plain kzalloc instead of pci_zalloc_coherent to allocate
memory for the USB DMA.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c b/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
index a142b9dc0feb..ea40a24947ba 100644
--- a/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
+++ b/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
@@ -102,7 +102,6 @@ struct ttusb {
 	unsigned int isoc_in_pipe;
 
 	void *iso_buffer;
-	dma_addr_t iso_dma_handle;
 
 	struct urb *iso_urb[ISO_BUF_COUNT];
 
@@ -792,26 +791,17 @@ static void ttusb_free_iso_urbs(struct ttusb *ttusb)
 
 	for (i = 0; i < ISO_BUF_COUNT; i++)
 		usb_free_urb(ttusb->iso_urb[i]);
-
-	pci_free_consistent(NULL,
-			    ISO_FRAME_SIZE * FRAMES_PER_ISO_BUF *
-			    ISO_BUF_COUNT, ttusb->iso_buffer,
-			    ttusb->iso_dma_handle);
+	kfree(ttusb->iso_buffer);
 }
 
 static int ttusb_alloc_iso_urbs(struct ttusb *ttusb)
 {
 	int i;
 
-	ttusb->iso_buffer = pci_zalloc_consistent(NULL,
-						  ISO_FRAME_SIZE * FRAMES_PER_ISO_BUF * ISO_BUF_COUNT,
-						  &ttusb->iso_dma_handle);
-
-	if (!ttusb->iso_buffer) {
-		dprintk("%s: pci_alloc_consistent - not enough memory\n",
-			__func__);
+	ttusb->iso_buffer = kcalloc(FRAMES_PER_ISO_BUF * ISO_BUF_COUNT,
+			ISO_FRAME_SIZE, GFP_KERNEL);
+	if (!ttusb->iso_buffer)
 		return -ENOMEM;
-	}
 
 	for (i = 0; i < ISO_BUF_COUNT; i++) {
 		struct urb *urb;
-- 
2.14.2
