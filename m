Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52951 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934057AbbHLHI7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Aug 2015 03:08:59 -0400
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
Subject: [PATCH 05/31] x86/pci-calgary: handle page-less SG entries
Date: Wed, 12 Aug 2015 09:05:24 +0200
Message-Id: <1439363150-8661-6-git-send-email-hch@lst.de>
In-Reply-To: <1439363150-8661-1-git-send-email-hch@lst.de>
References: <1439363150-8661-1-git-send-email-hch@lst.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For the iommu offset we just need and offset into the page.  Calculate
that using the physical address instead of using the virtual address
so that we don't require a virtual mapping.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/x86/kernel/pci-calgary_64.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index 0497f71..8f1581d 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -368,16 +368,14 @@ static int calgary_map_sg(struct device *dev, struct scatterlist *sg,
 {
 	struct iommu_table *tbl = find_iommu_table(dev);
 	struct scatterlist *s;
-	unsigned long vaddr;
+	unsigned long paddr;
 	unsigned int npages;
 	unsigned long entry;
 	int i;
 
 	for_each_sg(sg, s, nelems, i) {
-		BUG_ON(!sg_page(s));
-
-		vaddr = (unsigned long) sg_virt(s);
-		npages = iommu_num_pages(vaddr, s->length, PAGE_SIZE);
+		paddr = sg_phys(s);
+		npages = iommu_num_pages(paddr, s->length, PAGE_SIZE);
 
 		entry = iommu_range_alloc(dev, tbl, npages);
 		if (entry == DMA_ERROR_CODE) {
@@ -389,7 +387,7 @@ static int calgary_map_sg(struct device *dev, struct scatterlist *sg,
 		s->dma_address = (entry << PAGE_SHIFT) | s->offset;
 
 		/* insert into HW table */
-		tce_build(tbl, entry, npages, vaddr & PAGE_MASK, dir);
+		tce_build(tbl, entry, npages, paddr & PAGE_MASK, dir);
 
 		s->dma_length = s->length;
 	}
-- 
1.9.1

