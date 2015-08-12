Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53203 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965187AbbHLHJg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Aug 2015 03:09:36 -0400
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
Subject: [PATCH 18/31] nios2: handle page-less SG entries
Date: Wed, 12 Aug 2015 09:05:37 +0200
Message-Id: <1439363150-8661-19-git-send-email-hch@lst.de>
In-Reply-To: <1439363150-8661-1-git-send-email-hch@lst.de>
References: <1439363150-8661-1-git-send-email-hch@lst.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make all cache invalidation conditional on sg_has_page() and use
sg_phys to get the physical address directly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/nios2/mm/dma-mapping.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/arch/nios2/mm/dma-mapping.c b/arch/nios2/mm/dma-mapping.c
index ac5da75..1a0a68d 100644
--- a/arch/nios2/mm/dma-mapping.c
+++ b/arch/nios2/mm/dma-mapping.c
@@ -64,13 +64,11 @@ int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 	BUG_ON(!valid_dma_direction(direction));
 
 	for_each_sg(sg, sg, nents, i) {
-		void *addr;
-
-		addr = sg_virt(sg);
-		if (addr) {
-			__dma_sync_for_device(addr, sg->length, direction);
-			sg->dma_address = sg_phys(sg);
+		if (sg_has_page(sg)) {
+			__dma_sync_for_device(sg_virt(sg), sg->length,
+						direction);
 		}
+		sg->dma_address = sg_phys(sg);
 	}
 
 	return nents;
@@ -113,9 +111,8 @@ void dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nhwentries,
 		return;
 
 	for_each_sg(sg, sg, nhwentries, i) {
-		addr = sg_virt(sg);
-		if (addr)
-			__dma_sync_for_cpu(addr, sg->length, direction);
+		if (sg_has_page(sg))
+			__dma_sync_for_cpu(sg_virt(sg), sg->length, direction);
 	}
 }
 EXPORT_SYMBOL(dma_unmap_sg);
@@ -166,8 +163,10 @@ void dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg, int nelems,
 	BUG_ON(!valid_dma_direction(direction));
 
 	/* Make sure that gcc doesn't leave the empty loop body.  */
-	for_each_sg(sg, sg, nelems, i)
-		__dma_sync_for_cpu(sg_virt(sg), sg->length, direction);
+	for_each_sg(sg, sg, nelems, i) {
+		if (sg_has_page(sg))
+			__dma_sync_for_cpu(sg_virt(sg), sg->length, direction);
+	}
 }
 EXPORT_SYMBOL(dma_sync_sg_for_cpu);
 
@@ -179,8 +178,10 @@ void dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
 	BUG_ON(!valid_dma_direction(direction));
 
 	/* Make sure that gcc doesn't leave the empty loop body.  */
-	for_each_sg(sg, sg, nelems, i)
-		__dma_sync_for_device(sg_virt(sg), sg->length, direction);
-
+	for_each_sg(sg, sg, nelems, i) {
+		if (sg_has_page(sg))
+			__dma_sync_for_device(sg_virt(sg), sg->length,
+					direction);
+	}
 }
 EXPORT_SYMBOL(dma_sync_sg_for_device);
-- 
1.9.1

