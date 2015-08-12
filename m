Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53054 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965007AbbHLHJN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Aug 2015 03:09:13 -0400
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
Subject: [PATCH 10/31] powerpc/iommu: handle page-less SG entries
Date: Wed, 12 Aug 2015 09:05:29 +0200
Message-Id: <1439363150-8661-11-git-send-email-hch@lst.de>
In-Reply-To: <1439363150-8661-1-git-send-email-hch@lst.de>
References: <1439363150-8661-1-git-send-email-hch@lst.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For the iommu offset we just need and offset into the page.  Calculate
that using the physical address instead of using the virtual address
so that we don't require a virtual mapping.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/powerpc/kernel/iommu.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index a8e3490..0f52e40 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -457,7 +457,7 @@ int ppc_iommu_map_sg(struct device *dev, struct iommu_table *tbl,
 
 	max_seg_size = dma_get_max_seg_size(dev);
 	for_each_sg(sglist, s, nelems, i) {
-		unsigned long vaddr, npages, entry, slen;
+		unsigned long paddr, npages, entry, slen;
 
 		slen = s->length;
 		/* Sanity check */
@@ -466,22 +466,22 @@ int ppc_iommu_map_sg(struct device *dev, struct iommu_table *tbl,
 			continue;
 		}
 		/* Allocate iommu entries for that segment */
-		vaddr = (unsigned long) sg_virt(s);
-		npages = iommu_num_pages(vaddr, slen, IOMMU_PAGE_SIZE(tbl));
+		paddr = sg_phys(s);
+		npages = iommu_num_pages(paddr, slen, IOMMU_PAGE_SIZE(tbl));
 		align = 0;
 		if (tbl->it_page_shift < PAGE_SHIFT && slen >= PAGE_SIZE &&
-		    (vaddr & ~PAGE_MASK) == 0)
+		    (paddr & ~PAGE_MASK) == 0)
 			align = PAGE_SHIFT - tbl->it_page_shift;
 		entry = iommu_range_alloc(dev, tbl, npages, &handle,
 					  mask >> tbl->it_page_shift, align);
 
-		DBG("  - vaddr: %lx, size: %lx\n", vaddr, slen);
+		DBG("  - paddr: %lx, size: %lx\n", paddr, slen);
 
 		/* Handle failure */
 		if (unlikely(entry == DMA_ERROR_CODE)) {
 			if (printk_ratelimit())
 				dev_info(dev, "iommu_alloc failed, tbl %p "
-					 "vaddr %lx npages %lu\n", tbl, vaddr,
+					 "paddr %lx npages %lu\n", tbl, paddr,
 					 npages);
 			goto failure;
 		}
@@ -496,7 +496,7 @@ int ppc_iommu_map_sg(struct device *dev, struct iommu_table *tbl,
 
 		/* Insert into HW table */
 		build_fail = tbl->it_ops->set(tbl, entry, npages,
-					      vaddr & IOMMU_PAGE_MASK(tbl),
+					      paddr & IOMMU_PAGE_MASK(tbl),
 					      direction, attrs);
 		if(unlikely(build_fail))
 			goto failure;
-- 
1.9.1

