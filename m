Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52907 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934041AbbHLHIz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Aug 2015 03:08:55 -0400
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
Subject: [PATCH 02/31] scatterlist: use sg_phys()
Date: Wed, 12 Aug 2015 09:05:21 +0200
Message-Id: <1439363150-8661-3-git-send-email-hch@lst.de>
In-Reply-To: <1439363150-8661-1-git-send-email-hch@lst.de>
References: <1439363150-8661-1-git-send-email-hch@lst.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Dan Williams <dan.j.williams@intel.com>

Coccinelle cleanup to replace open coded sg to physical address
translations.  This is in preparation for introducing scatterlists that
reference __pfn_t.

// sg_phys.cocci: convert usage page_to_phys(sg_page(sg)) to sg_phys(sg)
// usage: make coccicheck COCCI=sg_phys.cocci MODE=patch

virtual patch

@@
struct scatterlist *sg;
@@

- page_to_phys(sg_page(sg)) + sg->offset
+ sg_phys(sg)

@@
struct scatterlist *sg;
@@

- page_to_phys(sg_page(sg))
+ sg_phys(sg) & PAGE_MASK

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/arm/mm/dma-mapping.c                    | 2 +-
 arch/microblaze/kernel/dma.c                 | 3 +--
 drivers/iommu/intel-iommu.c                  | 4 ++--
 drivers/iommu/iommu.c                        | 2 +-
 drivers/staging/android/ion/ion_chunk_heap.c | 4 ++--
 5 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index cba12f3..3d3d6aa 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -1520,7 +1520,7 @@ static int __map_sg_chunk(struct device *dev, struct scatterlist *sg,
 		return -ENOMEM;
 
 	for (count = 0, s = sg; count < (size >> PAGE_SHIFT); s = sg_next(s)) {
-		phys_addr_t phys = page_to_phys(sg_page(s));
+		phys_addr_t phys = sg_phys(s) & PAGE_MASK;
 		unsigned int len = PAGE_ALIGN(s->offset + s->length);
 
 		if (!is_coherent &&
diff --git a/arch/microblaze/kernel/dma.c b/arch/microblaze/kernel/dma.c
index bf4dec2..c89da63 100644
--- a/arch/microblaze/kernel/dma.c
+++ b/arch/microblaze/kernel/dma.c
@@ -61,8 +61,7 @@ static int dma_direct_map_sg(struct device *dev, struct scatterlist *sgl,
 	/* FIXME this part of code is untested */
 	for_each_sg(sgl, sg, nents, i) {
 		sg->dma_address = sg_phys(sg);
-		__dma_sync(page_to_phys(sg_page(sg)) + sg->offset,
-							sg->length, direction);
+		__dma_sync(sg_phys(sg), sg->length, direction);
 	}
 
 	return nents;
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 0649b94..3541d65 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -2097,7 +2097,7 @@ static int __domain_mapping(struct dmar_domain *domain, unsigned long iov_pfn,
 			sg_res = aligned_nrpages(sg->offset, sg->length);
 			sg->dma_address = ((dma_addr_t)iov_pfn << VTD_PAGE_SHIFT) + sg->offset;
 			sg->dma_length = sg->length;
-			pteval = page_to_phys(sg_page(sg)) | prot;
+			pteval = (sg_phys(sg) & PAGE_MASK) | prot;
 			phys_pfn = pteval >> VTD_PAGE_SHIFT;
 		}
 
@@ -3623,7 +3623,7 @@ static int intel_nontranslate_map_sg(struct device *hddev,
 
 	for_each_sg(sglist, sg, nelems, i) {
 		BUG_ON(!sg_page(sg));
-		sg->dma_address = page_to_phys(sg_page(sg)) + sg->offset;
+		sg->dma_address = sg_phys(sg);
 		sg->dma_length = sg->length;
 	}
 	return nelems;
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index f286090..049df49 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1408,7 +1408,7 @@ size_t default_iommu_map_sg(struct iommu_domain *domain, unsigned long iova,
 	min_pagesz = 1 << __ffs(domain->ops->pgsize_bitmap);
 
 	for_each_sg(sg, s, nents, i) {
-		phys_addr_t phys = page_to_phys(sg_page(s)) + s->offset;
+		phys_addr_t phys = sg_phys(s);
 
 		/*
 		 * We are mapping on IOMMU page boundaries, so offset within
diff --git a/drivers/staging/android/ion/ion_chunk_heap.c b/drivers/staging/android/ion/ion_chunk_heap.c
index 5474615..f7b6ef9 100644
--- a/drivers/staging/android/ion/ion_chunk_heap.c
+++ b/drivers/staging/android/ion/ion_chunk_heap.c
@@ -81,7 +81,7 @@ static int ion_chunk_heap_allocate(struct ion_heap *heap,
 err:
 	sg = table->sgl;
 	for (i -= 1; i >= 0; i--) {
-		gen_pool_free(chunk_heap->pool, page_to_phys(sg_page(sg)),
+		gen_pool_free(chunk_heap->pool, sg_phys(sg) & PAGE_MASK,
 			      sg->length);
 		sg = sg_next(sg);
 	}
@@ -109,7 +109,7 @@ static void ion_chunk_heap_free(struct ion_buffer *buffer)
 							DMA_BIDIRECTIONAL);
 
 	for_each_sg(table->sgl, sg, table->nents, i) {
-		gen_pool_free(chunk_heap->pool, page_to_phys(sg_page(sg)),
+		gen_pool_free(chunk_heap->pool, sg_phys(sg) & PAGE_MASK,
 			      sg->length);
 	}
 	chunk_heap->allocated -= allocated_size;
-- 
1.9.1

