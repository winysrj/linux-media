Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53151 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965007AbbHLHJ1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Aug 2015 03:09:27 -0400
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
Subject: [PATCH 15/31] sparc32/iommu: handle page-less SG entries
Date: Wed, 12 Aug 2015 09:05:34 +0200
Message-Id: <1439363150-8661-16-git-send-email-hch@lst.de>
In-Reply-To: <1439363150-8661-1-git-send-email-hch@lst.de>
References: <1439363150-8661-1-git-send-email-hch@lst.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Pass a PFN to iommu_get_one instad of calculating it locall from a
page structure so that we don't need pages for every address we can
DMA to or from.

Also further restrict the cache flushing as we now have a non-highmem
way of not kernel virtual mapped physical addresses.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/sparc/mm/iommu.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/sparc/mm/iommu.c b/arch/sparc/mm/iommu.c
index 491511d..3ed53d7 100644
--- a/arch/sparc/mm/iommu.c
+++ b/arch/sparc/mm/iommu.c
@@ -174,7 +174,7 @@ static void iommu_flush_iotlb(iopte_t *iopte, unsigned int niopte)
 	}
 }
 
-static u32 iommu_get_one(struct device *dev, struct page *page, int npages)
+static u32 iommu_get_one(struct device *dev, unsigned long pfn, int npages)
 {
 	struct iommu_struct *iommu = dev->archdata.iommu;
 	int ioptex;
@@ -183,7 +183,7 @@ static u32 iommu_get_one(struct device *dev, struct page *page, int npages)
 	int i;
 
 	/* page color = pfn of page */
-	ioptex = bit_map_string_get(&iommu->usemap, npages, page_to_pfn(page));
+	ioptex = bit_map_string_get(&iommu->usemap, npages, pfn);
 	if (ioptex < 0)
 		panic("iommu out");
 	busa0 = iommu->start + (ioptex << PAGE_SHIFT);
@@ -192,11 +192,11 @@ static u32 iommu_get_one(struct device *dev, struct page *page, int npages)
 	busa = busa0;
 	iopte = iopte0;
 	for (i = 0; i < npages; i++) {
-		iopte_val(*iopte) = MKIOPTE(page_to_pfn(page), IOPERM);
+		iopte_val(*iopte) = MKIOPTE(pfn, IOPERM);
 		iommu_invalidate_page(iommu->regs, busa);
 		busa += PAGE_SIZE;
 		iopte++;
-		page++;
+		pfn++;
 	}
 
 	iommu_flush_iotlb(iopte0, npages);
@@ -214,7 +214,7 @@ static u32 iommu_get_scsi_one(struct device *dev, char *vaddr, unsigned int len)
 	off = (unsigned long)vaddr & ~PAGE_MASK;
 	npages = (off + len + PAGE_SIZE-1) >> PAGE_SHIFT;
 	page = virt_to_page((unsigned long)vaddr & PAGE_MASK);
-	busa = iommu_get_one(dev, page, npages);
+	busa = iommu_get_one(dev, page_to_pfn(page), npages);
 	return busa + off;
 }
 
@@ -243,7 +243,7 @@ static void iommu_get_scsi_sgl_gflush(struct device *dev, struct scatterlist *sg
 	while (sz != 0) {
 		--sz;
 		n = (sg->length + sg->offset + PAGE_SIZE-1) >> PAGE_SHIFT;
-		sg->dma_address = iommu_get_one(dev, sg_page(sg), n) + sg->offset;
+		sg->dma_address = iommu_get_one(dev, sg_pfn(sg), n) + sg->offset;
 		sg->dma_length = sg->length;
 		sg = sg_next(sg);
 	}
@@ -264,7 +264,8 @@ static void iommu_get_scsi_sgl_pflush(struct device *dev, struct scatterlist *sg
 		 * XXX Is this a good assumption?
 		 * XXX What if someone else unmaps it here and races us?
 		 */
-		if ((page = (unsigned long) page_address(sg_page(sg))) != 0) {
+		if (sg_has_page(sg) &&
+		    (page = (unsigned long) page_address(sg_page(sg))) != 0) {
 			for (i = 0; i < n; i++) {
 				if (page != oldpage) {	/* Already flushed? */
 					flush_page_for_dma(page);
@@ -274,7 +275,7 @@ static void iommu_get_scsi_sgl_pflush(struct device *dev, struct scatterlist *sg
 			}
 		}
 
-		sg->dma_address = iommu_get_one(dev, sg_page(sg), n) + sg->offset;
+		sg->dma_address = iommu_get_one(dev, sg_pfn(sg), n) + sg->offset;
 		sg->dma_length = sg->length;
 		sg = sg_next(sg);
 	}
-- 
1.9.1

