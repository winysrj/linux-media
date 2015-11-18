Return-path: <linux-media-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:33478 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756001AbbKRPIF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2015 10:08:05 -0500
Date: Wed, 18 Nov 2015 16:08:02 +0100
From: Christoph Hellwig <hch@lst.de>
To: Tycho =?iso-8859-1?Q?L=FCrsen?= <tycholursen@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: Re: cx23885: use pci_set_dma_mask insted of pci_dma_supported
Message-ID: <20151118150802.GA20457@lst.de>
References: <20151112175329.6ccc66f3@recife.lan> <20151118092156.762dc600@recife.lan> <564C841E.1050601@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <564C841E.1050601@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tycho,

please try the patch below - Andrew should be sending it on to Linux soon.

---
>From 4c03a9f77104b04af45833e0424954191ca94a12 Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Wed, 11 Nov 2015 18:13:09 +0100
Subject: various: fix pci_set_dma_mask return value checking

pci_set_dma_mask returns a negative errno value, not a bool
like pci_dma_supported.  This of course was just a giant test
for attention :)

Reported-by: Jongman Heo <jongman.heo@samsung.com>
Tested-by: Jongman Heo <jongman.heo@samsung.com>	[pcnet32]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/media/pci/cx23885/cx23885-core.c           | 4 ++--
 drivers/media/pci/cx25821/cx25821-core.c           | 3 ++-
 drivers/media/pci/cx88/cx88-alsa.c                 | 4 ++--
 drivers/media/pci/cx88/cx88-mpeg.c                 | 3 ++-
 drivers/media/pci/cx88/cx88-video.c                | 4 ++--
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c | 2 +-
 drivers/media/pci/saa7134/saa7134-core.c           | 4 ++--
 drivers/media/pci/saa7164/saa7164-core.c           | 4 ++--
 drivers/media/pci/tw68/tw68-core.c                 | 4 ++--
 drivers/net/ethernet/amd/pcnet32.c                 | 5 +++--
 10 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-core.c b/drivers/media/pci/cx23885/cx23885-core.c
index 35759a9..e8f8472 100644
--- a/drivers/media/pci/cx23885/cx23885-core.c
+++ b/drivers/media/pci/cx23885/cx23885-core.c
@@ -1992,9 +1992,9 @@ static int cx23885_initdev(struct pci_dev *pci_dev,
 		(unsigned long long)pci_resource_start(pci_dev, 0));
 
 	pci_set_master(pci_dev);
-	if (!pci_set_dma_mask(pci_dev, 0xffffffff)) {
+	err = pci_set_dma_mask(pci_dev, 0xffffffff);
+	if (err) {
 		printk("%s/0: Oops: no 32bit PCI DMA ???\n", dev->name);
-		err = -EIO;
 		goto fail_context;
 	}
 
diff --git a/drivers/media/pci/cx25821/cx25821-core.c b/drivers/media/pci/cx25821/cx25821-core.c
index dbc695f..0042803 100644
--- a/drivers/media/pci/cx25821/cx25821-core.c
+++ b/drivers/media/pci/cx25821/cx25821-core.c
@@ -1319,7 +1319,8 @@ static int cx25821_initdev(struct pci_dev *pci_dev,
 		dev->pci_lat, (unsigned long long)dev->base_io_addr);
 
 	pci_set_master(pci_dev);
-	if (!pci_set_dma_mask(pci_dev, 0xffffffff)) {
+	err = pci_set_dma_mask(pci_dev, 0xffffffff);
+	if (err) {
 		pr_err("%s/0: Oops: no 32bit PCI DMA ???\n", dev->name);
 		err = -EIO;
 		goto fail_irq;
diff --git a/drivers/media/pci/cx88/cx88-alsa.c b/drivers/media/pci/cx88/cx88-alsa.c
index 0ed1b65..1b5268f 100644
--- a/drivers/media/pci/cx88/cx88-alsa.c
+++ b/drivers/media/pci/cx88/cx88-alsa.c
@@ -890,9 +890,9 @@ static int snd_cx88_create(struct snd_card *card, struct pci_dev *pci,
 		return err;
 	}
 
-	if (!pci_set_dma_mask(pci,DMA_BIT_MASK(32))) {
+	err = pci_set_dma_mask(pci,DMA_BIT_MASK(32));
+	if (err) {
 		dprintk(0, "%s/1: Oops: no 32bit PCI DMA ???\n",core->name);
-		err = -EIO;
 		cx88_core_put(core, pci);
 		return err;
 	}
diff --git a/drivers/media/pci/cx88/cx88-mpeg.c b/drivers/media/pci/cx88/cx88-mpeg.c
index 9db7767..f34c229 100644
--- a/drivers/media/pci/cx88/cx88-mpeg.c
+++ b/drivers/media/pci/cx88/cx88-mpeg.c
@@ -393,7 +393,8 @@ static int cx8802_init_common(struct cx8802_dev *dev)
 	if (pci_enable_device(dev->pci))
 		return -EIO;
 	pci_set_master(dev->pci);
-	if (!pci_set_dma_mask(dev->pci,DMA_BIT_MASK(32))) {
+	err = pci_set_dma_mask(dev->pci,DMA_BIT_MASK(32));
+	if (err) {
 		printk("%s/2: Oops: no 32bit PCI DMA ???\n",dev->core->name);
 		return -EIO;
 	}
diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index 0de1ad5..aef9acf 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -1314,9 +1314,9 @@ static int cx8800_initdev(struct pci_dev *pci_dev,
 	       dev->pci_lat,(unsigned long long)pci_resource_start(pci_dev,0));
 
 	pci_set_master(pci_dev);
-	if (!pci_set_dma_mask(pci_dev,DMA_BIT_MASK(32))) {
+	err = pci_set_dma_mask(pci_dev,DMA_BIT_MASK(32));
+	if (err) {
 		printk("%s/0: Oops: no 32bit PCI DMA ???\n",core->name);
-		err = -EIO;
 		goto fail_core;
 	}
 	dev->alloc_ctx = vb2_dma_sg_init_ctx(&pci_dev->dev);
diff --git a/drivers/media/pci/netup_unidvb/netup_unidvb_core.c b/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
index 60b2d46..3fdbd81 100644
--- a/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
+++ b/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
@@ -810,7 +810,7 @@ static int netup_unidvb_initdev(struct pci_dev *pci_dev,
 		"%s(): board vendor 0x%x, revision 0x%x\n",
 		__func__, board_vendor, board_revision);
 	pci_set_master(pci_dev);
-	if (!pci_set_dma_mask(pci_dev, 0xffffffff)) {
+	if (pci_set_dma_mask(pci_dev, 0xffffffff) < 0) {
 		dev_err(&pci_dev->dev,
 			"%s(): 32bit PCI DMA is not supported\n", __func__);
 		goto pci_detect_err;
diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
index e79d63e..f720cea 100644
--- a/drivers/media/pci/saa7134/saa7134-core.c
+++ b/drivers/media/pci/saa7134/saa7134-core.c
@@ -951,9 +951,9 @@ static int saa7134_initdev(struct pci_dev *pci_dev,
 	       pci_name(pci_dev), dev->pci_rev, pci_dev->irq,
 	       dev->pci_lat,(unsigned long long)pci_resource_start(pci_dev,0));
 	pci_set_master(pci_dev);
-	if (!pci_set_dma_mask(pci_dev, DMA_BIT_MASK(32))) {
+	err = pci_set_dma_mask(pci_dev, DMA_BIT_MASK(32));
+	if (err) {
 		pr_warn("%s: Oops: no 32bit PCI DMA ???\n", dev->name);
-		err = -EIO;
 		goto fail1;
 	}
 
diff --git a/drivers/media/pci/saa7164/saa7164-core.c b/drivers/media/pci/saa7164/saa7164-core.c
index 8f36b48..8bbd092 100644
--- a/drivers/media/pci/saa7164/saa7164-core.c
+++ b/drivers/media/pci/saa7164/saa7164-core.c
@@ -1264,9 +1264,9 @@ static int saa7164_initdev(struct pci_dev *pci_dev,
 
 	pci_set_master(pci_dev);
 	/* TODO */
-	if (!pci_set_dma_mask(pci_dev, 0xffffffff)) {
+	err = pci_set_dma_mask(pci_dev, 0xffffffff);
+	if (err) {
 		printk("%s/0: Oops: no 32bit PCI DMA ???\n", dev->name);
-		err = -EIO;
 		goto fail_irq;
 	}
 
diff --git a/drivers/media/pci/tw68/tw68-core.c b/drivers/media/pci/tw68/tw68-core.c
index 8c5655d..4e77618 100644
--- a/drivers/media/pci/tw68/tw68-core.c
+++ b/drivers/media/pci/tw68/tw68-core.c
@@ -257,9 +257,9 @@ static int tw68_initdev(struct pci_dev *pci_dev,
 		dev->name, pci_name(pci_dev), dev->pci_rev, pci_dev->irq,
 		dev->pci_lat, (u64)pci_resource_start(pci_dev, 0));
 	pci_set_master(pci_dev);
-	if (!pci_set_dma_mask(pci_dev, DMA_BIT_MASK(32))) {
+	err = pci_set_dma_mask(pci_dev, DMA_BIT_MASK(32));
+	if (err) {
 		pr_info("%s: Oops: no 32bit PCI DMA ???\n", dev->name);
-		err = -EIO;
 		goto fail1;
 	}
 
diff --git a/drivers/net/ethernet/amd/pcnet32.c b/drivers/net/ethernet/amd/pcnet32.c
index e2afabf..7ccebae 100644
--- a/drivers/net/ethernet/amd/pcnet32.c
+++ b/drivers/net/ethernet/amd/pcnet32.c
@@ -1500,10 +1500,11 @@ pcnet32_probe_pci(struct pci_dev *pdev, const struct pci_device_id *ent)
 		return -ENODEV;
 	}
 
-	if (!pci_set_dma_mask(pdev, PCNET32_DMA_MASK)) {
+	err = pci_set_dma_mask(pdev, PCNET32_DMA_MASK);
+	if (err) {
 		if (pcnet32_debug & NETIF_MSG_PROBE)
 			pr_err("architecture does not support 32bit PCI busmaster DMA\n");
-		return -ENODEV;
+		return err;
 	}
 	if (!request_region(ioaddr, PCNET32_TOTAL_SIZE, "pcnet32_probe_pci")) {
 		if (pcnet32_debug & NETIF_MSG_PROBE)
-- 
1.9.1

