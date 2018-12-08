Return-Path: <SRS0=LTSq=OR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41306C04EB8
	for <linux-media@archiver.kernel.org>; Sat,  8 Dec 2018 17:37:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0AB132081C
	for <linux-media@archiver.kernel.org>; Sat,  8 Dec 2018 17:37:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="npUsXCus"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0AB132081C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726280AbeLHRhX (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 8 Dec 2018 12:37:23 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:42962 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726223AbeLHRhT (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 8 Dec 2018 12:37:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=7kqMcnLmVFeoQnDMxocbVrlIY+4jeZ6Ab2fif+he9Kc=; b=npUsXCuskLDtFMp0w2shACalwT
        /fgAocw/TueSdjampu6EVtyIUz+MLHez0vD5vk70Vt8MUtoS1zr7hrBV9U6QsSh9HC88XLS9dFKMF
        Z8EwyqaRvuWqccuVsaGRG2uQmvSzdJxLZj7cjzFPo2WuEKEu9Iehzh1vhzvZMP2+XXt8k3A9a8fAC
        eXL7a2hWUvPl+bxEs2xbn4kZOYLaX2HixePRo/yZut4dVVejiPCWk/sosA/HLeB4O2Wv9mITfOgaI
        U9cmQJlecV756RNOiR44BkQHtSEh1rO4bu3a7izFQ6/2eUmOyo2aEBZp8z0dIQaJXY3mvgiPW8nGS
        7FG/XBLg==;
Received: from [184.48.100.57] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gVgXI-00054C-KO; Sat, 08 Dec 2018 17:37:04 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     iommu@lists.linux-foundation.org
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        "Matwey V. Kornilov" <matwey@sai.msu.ru>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-snps-arc@lists.infradead.org,
        Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, sparclinux@vger.kernel.org,
        openrisc@lists.librecores.org, linux-parisc@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: [PATCH 05/10] sparc64/iommu: move code around a bit
Date:   Sat,  8 Dec 2018 09:36:57 -0800
Message-Id: <20181208173702.15158-6-hch@lst.de>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181208173702.15158-1-hch@lst.de>
References: <20181208173702.15158-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Move the alloc / free routines down the file so that we can easily use
the map / unmap helpers to implement non-consistent allocations.

Also drop the _coherent postfix to match the method name.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/sparc/kernel/iommu.c | 135 +++++++++++++++++++-------------------
 1 file changed, 67 insertions(+), 68 deletions(-)

diff --git a/arch/sparc/kernel/iommu.c b/arch/sparc/kernel/iommu.c
index 0626bae5e3da..4bf0497e0704 100644
--- a/arch/sparc/kernel/iommu.c
+++ b/arch/sparc/kernel/iommu.c
@@ -195,72 +195,6 @@ static inline void iommu_free_ctx(struct iommu *iommu, int ctx)
 	}
 }
 
-static void *dma_4u_alloc_coherent(struct device *dev, size_t size,
-				   dma_addr_t *dma_addrp, gfp_t gfp,
-				   unsigned long attrs)
-{
-	unsigned long order, first_page;
-	struct iommu *iommu;
-	struct page *page;
-	int npages, nid;
-	iopte_t *iopte;
-	void *ret;
-
-	size = IO_PAGE_ALIGN(size);
-	order = get_order(size);
-	if (order >= 10)
-		return NULL;
-
-	nid = dev->archdata.numa_node;
-	page = alloc_pages_node(nid, gfp, order);
-	if (unlikely(!page))
-		return NULL;
-
-	first_page = (unsigned long) page_address(page);
-	memset((char *)first_page, 0, PAGE_SIZE << order);
-
-	iommu = dev->archdata.iommu;
-
-	iopte = alloc_npages(dev, iommu, size >> IO_PAGE_SHIFT);
-
-	if (unlikely(iopte == NULL)) {
-		free_pages(first_page, order);
-		return NULL;
-	}
-
-	*dma_addrp = (iommu->tbl.table_map_base +
-		      ((iopte - iommu->page_table) << IO_PAGE_SHIFT));
-	ret = (void *) first_page;
-	npages = size >> IO_PAGE_SHIFT;
-	first_page = __pa(first_page);
-	while (npages--) {
-		iopte_val(*iopte) = (IOPTE_CONSISTENT(0UL) |
-				     IOPTE_WRITE |
-				     (first_page & IOPTE_PAGE));
-		iopte++;
-		first_page += IO_PAGE_SIZE;
-	}
-
-	return ret;
-}
-
-static void dma_4u_free_coherent(struct device *dev, size_t size,
-				 void *cpu, dma_addr_t dvma,
-				 unsigned long attrs)
-{
-	struct iommu *iommu;
-	unsigned long order, npages;
-
-	npages = IO_PAGE_ALIGN(size) >> IO_PAGE_SHIFT;
-	iommu = dev->archdata.iommu;
-
-	iommu_tbl_range_free(&iommu->tbl, dvma, npages, IOMMU_ERROR_CODE);
-
-	order = get_order(size);
-	if (order < 10)
-		free_pages((unsigned long)cpu, order);
-}
-
 static dma_addr_t dma_4u_map_page(struct device *dev, struct page *page,
 				  unsigned long offset, size_t sz,
 				  enum dma_data_direction direction,
@@ -742,6 +676,71 @@ static void dma_4u_sync_sg_for_cpu(struct device *dev,
 	spin_unlock_irqrestore(&iommu->lock, flags);
 }
 
+static void *dma_4u_alloc(struct device *dev, size_t size,
+			  dma_addr_t *dma_addrp, gfp_t gfp, unsigned long attrs)
+{
+	unsigned long order, first_page;
+	struct iommu *iommu;
+	struct page *page;
+	int npages, nid;
+	iopte_t *iopte;
+	void *ret;
+
+	size = IO_PAGE_ALIGN(size);
+	order = get_order(size);
+	if (order >= 10)
+		return NULL;
+
+	nid = dev->archdata.numa_node;
+	page = alloc_pages_node(nid, gfp, order);
+	if (unlikely(!page))
+		return NULL;
+
+	first_page = (unsigned long) page_address(page);
+	memset((char *)first_page, 0, PAGE_SIZE << order);
+
+	iommu = dev->archdata.iommu;
+
+	iopte = alloc_npages(dev, iommu, size >> IO_PAGE_SHIFT);
+
+	if (unlikely(iopte == NULL)) {
+		free_pages(first_page, order);
+		return NULL;
+	}
+
+	*dma_addrp = (iommu->tbl.table_map_base +
+		      ((iopte - iommu->page_table) << IO_PAGE_SHIFT));
+	ret = (void *) first_page;
+	npages = size >> IO_PAGE_SHIFT;
+	first_page = __pa(first_page);
+	while (npages--) {
+		iopte_val(*iopte) = (IOPTE_CONSISTENT(0UL) |
+				     IOPTE_WRITE |
+				     (first_page & IOPTE_PAGE));
+		iopte++;
+		first_page += IO_PAGE_SIZE;
+	}
+
+	return ret;
+}
+
+static void dma_4u_free(struct device *dev, size_t size, void *cpu,
+			dma_addr_t dvma, unsigned long attrs)
+{
+	struct iommu *iommu;
+	unsigned long order, npages;
+
+	npages = IO_PAGE_ALIGN(size) >> IO_PAGE_SHIFT;
+	iommu = dev->archdata.iommu;
+
+	iommu_tbl_range_free(&iommu->tbl, dvma, npages, IOMMU_ERROR_CODE);
+
+	order = get_order(size);
+	if (order < 10)
+		free_pages((unsigned long)cpu, order);
+}
+
+
 static int dma_4u_supported(struct device *dev, u64 device_mask)
 {
 	struct iommu *iommu = dev->archdata.iommu;
@@ -758,8 +757,8 @@ static int dma_4u_supported(struct device *dev, u64 device_mask)
 }
 
 static const struct dma_map_ops sun4u_dma_ops = {
-	.alloc			= dma_4u_alloc_coherent,
-	.free			= dma_4u_free_coherent,
+	.alloc			= dma_4u_alloc,
+	.free			= dma_4u_free,
 	.map_page		= dma_4u_map_page,
 	.unmap_page		= dma_4u_unmap_page,
 	.map_sg			= dma_4u_map_sg,
-- 
2.19.2

