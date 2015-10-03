Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51191 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879AbbJCPXp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Oct 2015 11:23:45 -0400
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>,
	Don Fry <pcnet32@frontier.com>,
	Oliver Neukum <oneukum@suse.com>
Cc: linux-net-drivers@solarflare.com, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, netdev@vger.kernel.org,
	linux-parisc@vger.kernel.org, linux-serial@vger.kernel.org,
	linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 03/15] saa7164: use pci_set_dma_mask insted of pci_dma_supported
Date: Sat,  3 Oct 2015 17:19:27 +0200
Message-Id: <1443885579-7094-4-git-send-email-hch@lst.de>
In-Reply-To: <1443885579-7094-1-git-send-email-hch@lst.de>
References: <1443885579-7094-1-git-send-email-hch@lst.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This ensures the dma mask that is supported by the driver is recorded
in the device structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/media/pci/saa7164/saa7164-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/saa7164/saa7164-core.c b/drivers/media/pci/saa7164/saa7164-core.c
index 3206a82..8f36b48 100644
--- a/drivers/media/pci/saa7164/saa7164-core.c
+++ b/drivers/media/pci/saa7164/saa7164-core.c
@@ -1264,7 +1264,7 @@ static int saa7164_initdev(struct pci_dev *pci_dev,
 
 	pci_set_master(pci_dev);
 	/* TODO */
-	if (!pci_dma_supported(pci_dev, 0xffffffff)) {
+	if (!pci_set_dma_mask(pci_dev, 0xffffffff)) {
 		printk("%s/0: Oops: no 32bit PCI DMA ???\n", dev->name);
 		err = -EIO;
 		goto fail_irq;
-- 
1.9.1

