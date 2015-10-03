Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51207 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbbJCPXk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Oct 2015 11:23:40 -0400
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>,
	Don Fry <pcnet32@frontier.com>,
	Oliver Neukum <oneukum@suse.com>
Cc: linux-net-drivers@solarflare.com, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, netdev@vger.kernel.org,
	linux-parisc@vger.kernel.org, linux-serial@vger.kernel.org,
	linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 05/15] cx88: use pci_set_dma_mask insted of pci_dma_supported
Date: Sat,  3 Oct 2015 17:19:29 +0200
Message-Id: <1443885579-7094-6-git-send-email-hch@lst.de>
In-Reply-To: <1443885579-7094-1-git-send-email-hch@lst.de>
References: <1443885579-7094-1-git-send-email-hch@lst.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This ensures the dma mask that is supported by the driver is recorded
in the device structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/media/pci/cx88/cx88-alsa.c  | 2 +-
 drivers/media/pci/cx88/cx88-mpeg.c  | 2 +-
 drivers/media/pci/cx88/cx88-video.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/pci/cx88/cx88-alsa.c b/drivers/media/pci/cx88/cx88-alsa.c
index 7f8dc60..0703a81 100644
--- a/drivers/media/pci/cx88/cx88-alsa.c
+++ b/drivers/media/pci/cx88/cx88-alsa.c
@@ -890,7 +890,7 @@ static int snd_cx88_create(struct snd_card *card, struct pci_dev *pci,
 		return err;
 	}
 
-	if (!pci_dma_supported(pci,DMA_BIT_MASK(32))) {
+	if (!pci_set_dma_mask(pci,DMA_BIT_MASK(32))) {
 		dprintk(0, "%s/1: Oops: no 32bit PCI DMA ???\n",core->name);
 		err = -EIO;
 		cx88_core_put(core, pci);
diff --git a/drivers/media/pci/cx88/cx88-mpeg.c b/drivers/media/pci/cx88/cx88-mpeg.c
index 34f5057..9b3b565 100644
--- a/drivers/media/pci/cx88/cx88-mpeg.c
+++ b/drivers/media/pci/cx88/cx88-mpeg.c
@@ -393,7 +393,7 @@ static int cx8802_init_common(struct cx8802_dev *dev)
 	if (pci_enable_device(dev->pci))
 		return -EIO;
 	pci_set_master(dev->pci);
-	if (!pci_dma_supported(dev->pci,DMA_BIT_MASK(32))) {
+	if (!pci_set_dma_mask(dev->pci,DMA_BIT_MASK(32))) {
 		printk("%s/2: Oops: no 32bit PCI DMA ???\n",dev->core->name);
 		return -EIO;
 	}
diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index 400e5ca..f12af31 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -1311,7 +1311,7 @@ static int cx8800_initdev(struct pci_dev *pci_dev,
 	       dev->pci_lat,(unsigned long long)pci_resource_start(pci_dev,0));
 
 	pci_set_master(pci_dev);
-	if (!pci_dma_supported(pci_dev,DMA_BIT_MASK(32))) {
+	if (!pci_set_dma_mask(pci_dev,DMA_BIT_MASK(32))) {
 		printk("%s/0: Oops: no 32bit PCI DMA ???\n",core->name);
 		err = -EIO;
 		goto fail_core;
-- 
1.9.1

