Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53037 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964947AbbHLHJK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Aug 2015 03:09:10 -0400
From: Christoph Hellwig <hch@lst.de>
To: torvalds@linux-foundation.org, axboe@kernel.dk
Cc: dan.j.williams@intel.com, vgupta@synopsys.com,
	hskinnemoen@gmail.com, egtvedt@samfundet.no, realmz6@gmail.com,
	dhowells@redhat.com, monstr@monstr.eu, x86@kernel.org,
	dwmw2@infradead.org, alex.williamson@redhat.com,
	grundler@parisc-linux.org, linux-kernel@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-alpha@vger.kernel.org,
	linux-ia64@vger.kernel.org, linux-metag@vger.kernel.org,
	linux-mips@linux-mips.org, linux-parisc@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org, linux-xtensa@linux-xtensa.org,
	linux-nvdimm@ml01.01.org, linux-media@vger.kernel.org
Subject: [PATCH 09/31] ia64/pci_dma: handle page-less SG entries
Date: Wed, 12 Aug 2015 09:05:28 +0200
Message-Id: <1439363150-8661-10-git-send-email-hch@lst.de>
In-Reply-To: <1439363150-8661-1-git-send-email-hch@lst.de>
References: <1439363150-8661-1-git-send-email-hch@lst.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use sg_phys() instead of virt_to_phys(sg_virt(sg)) so that we don't
require a kernel virtual address.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/ia64/sn/pci/pci_dma.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/ia64/sn/pci/pci_dma.c b/arch/ia64/sn/pci/pci_dma.c
index d0853e8..8f713c8 100644
--- a/arch/ia64/sn/pci/pci_dma.c
+++ b/arch/ia64/sn/pci/pci_dma.c
@@ -18,9 +18,6 @@
 #include <asm/sn/pcidev.h>
 #include <asm/sn/sn_sal.h>
 
-#define SG_ENT_VIRT_ADDRESS(sg)	(sg_virt((sg)))
-#define SG_ENT_PHYS_ADDRESS(SG)	virt_to_phys(SG_ENT_VIRT_ADDRESS(SG))
-
 /**
  * sn_dma_supported - test a DMA mask
  * @dev: device to test
@@ -291,7 +288,7 @@ static int sn_dma_map_sg(struct device *dev, struct scatterlist *sgl,
 	 */
 	for_each_sg(sgl, sg, nhwentries, i) {
 		dma_addr_t dma_addr;
-		phys_addr = SG_ENT_PHYS_ADDRESS(sg);
+		phys_addr = sg_phys(sg);
 		if (dmabarr)
 			dma_addr = provider->dma_map_consistent(pdev,
 								phys_addr,
-- 
1.9.1

