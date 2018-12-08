Return-Path: <SRS0=LTSq=OR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FFF6C67838
	for <linux-media@archiver.kernel.org>; Sat,  8 Dec 2018 17:37:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 503CB2081C
	for <linux-media@archiver.kernel.org>; Sat,  8 Dec 2018 17:37:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="G5gzHsuD"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 503CB2081C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726264AbeLHRhU (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 8 Dec 2018 12:37:20 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:42964 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbeLHRhS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 8 Dec 2018 12:37:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=FAVutZNoA5nWRwfSxkV2PNMNqj2neLTbsfs93R9vcsQ=; b=G5gzHsuDM+mlQ/DWx9qezcqW+j
        q4lMr679jhRFonbTO36GmgkQX0ldMdCTPwNZe3p3IfCZvNri2DOdAp2XHCdE6kD/xEx2WqrSLZpEa
        B74u0JD+6UV0Id6fC2Q7c22LwZ0Zw/Zzs7vDz7YQSaTUiyzzDbAbJrExTGZ1hdhP8oGKPTI96H5AL
        J5ap/7VRgxEEJODZCSS0iX/XUiamMkyH3rPEMEL9CJ+qMXCImhDynGChgMaTFJoTwMmVVEMtKriVn
        /lOgV4hkitiuygQkZi4f5C4b9wkswYQq22hMk+LvhRA6/lvfyAmKc1xLRg9nGpmuWJ1+xjkWp3qJr
        EvhDmgTg==;
Received: from [184.48.100.57] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gVgXJ-00054M-EU; Sat, 08 Dec 2018 17:37:05 +0000
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
Subject: [PATCH 07/10] sparc64/pci_sun4v: move code around a bit
Date:   Sat,  8 Dec 2018 09:36:59 -0800
Message-Id: <20181208173702.15158-8-hch@lst.de>
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
 arch/sparc/kernel/pci_sun4v.c | 229 +++++++++++++++++-----------------
 1 file changed, 114 insertions(+), 115 deletions(-)

diff --git a/arch/sparc/kernel/pci_sun4v.c b/arch/sparc/kernel/pci_sun4v.c
index fa0e42b4cbfb..b95c70136559 100644
--- a/arch/sparc/kernel/pci_sun4v.c
+++ b/arch/sparc/kernel/pci_sun4v.c
@@ -171,87 +171,6 @@ static inline long iommu_batch_end(u64 mask)
 	return iommu_batch_flush(p, mask);
 }
 
-static void *dma_4v_alloc_coherent(struct device *dev, size_t size,
-				   dma_addr_t *dma_addrp, gfp_t gfp,
-				   unsigned long attrs)
-{
-	u64 mask;
-	unsigned long flags, order, first_page, npages, n;
-	unsigned long prot = 0;
-	struct iommu *iommu;
-	struct atu *atu;
-	struct iommu_map_table *tbl;
-	struct page *page;
-	void *ret;
-	long entry;
-	int nid;
-
-	size = IO_PAGE_ALIGN(size);
-	order = get_order(size);
-	if (unlikely(order >= MAX_ORDER))
-		return NULL;
-
-	npages = size >> IO_PAGE_SHIFT;
-
-	if (attrs & DMA_ATTR_WEAK_ORDERING)
-		prot = HV_PCI_MAP_ATTR_RELAXED_ORDER;
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
-	atu = iommu->atu;
-
-	mask = dev->coherent_dma_mask;
-	if (mask <= DMA_BIT_MASK(32))
-		tbl = &iommu->tbl;
-	else
-		tbl = &atu->tbl;
-
-	entry = iommu_tbl_range_alloc(dev, tbl, npages, NULL,
-				      (unsigned long)(-1), 0);
-
-	if (unlikely(entry == IOMMU_ERROR_CODE))
-		goto range_alloc_fail;
-
-	*dma_addrp = (tbl->table_map_base + (entry << IO_PAGE_SHIFT));
-	ret = (void *) first_page;
-	first_page = __pa(first_page);
-
-	local_irq_save(flags);
-
-	iommu_batch_start(dev,
-			  (HV_PCI_MAP_ATTR_READ | prot |
-			   HV_PCI_MAP_ATTR_WRITE),
-			  entry);
-
-	for (n = 0; n < npages; n++) {
-		long err = iommu_batch_add(first_page + (n * PAGE_SIZE), mask);
-		if (unlikely(err < 0L))
-			goto iommu_map_fail;
-	}
-
-	if (unlikely(iommu_batch_end(mask) < 0L))
-		goto iommu_map_fail;
-
-	local_irq_restore(flags);
-
-	return ret;
-
-iommu_map_fail:
-	local_irq_restore(flags);
-	iommu_tbl_range_free(tbl, *dma_addrp, npages, IOMMU_ERROR_CODE);
-
-range_alloc_fail:
-	free_pages(first_page, order);
-	return NULL;
-}
-
 unsigned long dma_4v_iotsb_bind(unsigned long devhandle,
 				unsigned long iotsb_num,
 				struct pci_bus *bus_dev)
@@ -316,38 +235,6 @@ static void dma_4v_iommu_demap(struct device *dev, unsigned long devhandle,
 	local_irq_restore(flags);
 }
 
-static void dma_4v_free_coherent(struct device *dev, size_t size, void *cpu,
-				 dma_addr_t dvma, unsigned long attrs)
-{
-	struct pci_pbm_info *pbm;
-	struct iommu *iommu;
-	struct atu *atu;
-	struct iommu_map_table *tbl;
-	unsigned long order, npages, entry;
-	unsigned long iotsb_num;
-	u32 devhandle;
-
-	npages = IO_PAGE_ALIGN(size) >> IO_PAGE_SHIFT;
-	iommu = dev->archdata.iommu;
-	pbm = dev->archdata.host_controller;
-	atu = iommu->atu;
-	devhandle = pbm->devhandle;
-
-	if (dvma <= DMA_BIT_MASK(32)) {
-		tbl = &iommu->tbl;
-		iotsb_num = 0; /* we don't care for legacy iommu */
-	} else {
-		tbl = &atu->tbl;
-		iotsb_num = atu->iotsb->iotsb_num;
-	}
-	entry = ((dvma - tbl->table_map_base) >> IO_PAGE_SHIFT);
-	dma_4v_iommu_demap(dev, devhandle, dvma, iotsb_num, entry, npages);
-	iommu_tbl_range_free(tbl, dvma, npages, IOMMU_ERROR_CODE);
-	order = get_order(size);
-	if (order < 10)
-		free_pages((unsigned long)cpu, order);
-}
-
 static dma_addr_t dma_4v_map_page(struct device *dev, struct page *page,
 				  unsigned long offset, size_t sz,
 				  enum dma_data_direction direction,
@@ -671,6 +558,118 @@ static void dma_4v_unmap_sg(struct device *dev, struct scatterlist *sglist,
 	local_irq_restore(flags);
 }
 
+static void *dma_4v_alloc(struct device *dev, size_t size,
+			  dma_addr_t *dma_addrp, gfp_t gfp, unsigned long attrs)
+{
+	u64 mask;
+	unsigned long flags, order, first_page, npages, n;
+	unsigned long prot = 0;
+	struct iommu *iommu;
+	struct atu *atu;
+	struct iommu_map_table *tbl;
+	struct page *page;
+	void *ret;
+	long entry;
+	int nid;
+
+	size = IO_PAGE_ALIGN(size);
+	order = get_order(size);
+	if (unlikely(order >= MAX_ORDER))
+		return NULL;
+
+	npages = size >> IO_PAGE_SHIFT;
+
+	if (attrs & DMA_ATTR_WEAK_ORDERING)
+		prot = HV_PCI_MAP_ATTR_RELAXED_ORDER;
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
+	atu = iommu->atu;
+
+	mask = dev->coherent_dma_mask;
+	if (mask <= DMA_BIT_MASK(32))
+		tbl = &iommu->tbl;
+	else
+		tbl = &atu->tbl;
+
+	entry = iommu_tbl_range_alloc(dev, tbl, npages, NULL,
+				      (unsigned long)(-1), 0);
+
+	if (unlikely(entry == IOMMU_ERROR_CODE))
+		goto range_alloc_fail;
+
+	*dma_addrp = (tbl->table_map_base + (entry << IO_PAGE_SHIFT));
+	ret = (void *) first_page;
+	first_page = __pa(first_page);
+
+	local_irq_save(flags);
+
+	iommu_batch_start(dev,
+			  (HV_PCI_MAP_ATTR_READ | prot |
+			   HV_PCI_MAP_ATTR_WRITE),
+			  entry);
+
+	for (n = 0; n < npages; n++) {
+		long err = iommu_batch_add(first_page + (n * PAGE_SIZE), mask);
+		if (unlikely(err < 0L))
+			goto iommu_map_fail;
+	}
+
+	if (unlikely(iommu_batch_end(mask) < 0L))
+		goto iommu_map_fail;
+
+	local_irq_restore(flags);
+
+	return ret;
+
+iommu_map_fail:
+	local_irq_restore(flags);
+	iommu_tbl_range_free(tbl, *dma_addrp, npages, IOMMU_ERROR_CODE);
+
+range_alloc_fail:
+	free_pages(first_page, order);
+	return NULL;
+}
+
+static void dma_4v_free(struct device *dev, size_t size, void *cpu,
+			dma_addr_t dvma, unsigned long attrs)
+{
+	struct pci_pbm_info *pbm;
+	struct iommu *iommu;
+	struct atu *atu;
+	struct iommu_map_table *tbl;
+	unsigned long order, npages, entry;
+	unsigned long iotsb_num;
+	u32 devhandle;
+
+	npages = IO_PAGE_ALIGN(size) >> IO_PAGE_SHIFT;
+	iommu = dev->archdata.iommu;
+	pbm = dev->archdata.host_controller;
+	atu = iommu->atu;
+	devhandle = pbm->devhandle;
+
+	if (dvma <= DMA_BIT_MASK(32)) {
+		tbl = &iommu->tbl;
+		iotsb_num = 0; /* we don't care for legacy iommu */
+	} else {
+		tbl = &atu->tbl;
+		iotsb_num = atu->iotsb->iotsb_num;
+	}
+	entry = ((dvma - tbl->table_map_base) >> IO_PAGE_SHIFT);
+	dma_4v_iommu_demap(dev, devhandle, dvma, iotsb_num, entry, npages);
+	iommu_tbl_range_free(tbl, dvma, npages, IOMMU_ERROR_CODE);
+	order = get_order(size);
+	if (order < 10)
+		free_pages((unsigned long)cpu, order);
+}
+
 static int dma_4v_supported(struct device *dev, u64 device_mask)
 {
 	struct iommu *iommu = dev->archdata.iommu;
@@ -689,8 +688,8 @@ static int dma_4v_supported(struct device *dev, u64 device_mask)
 }
 
 static const struct dma_map_ops sun4v_dma_ops = {
-	.alloc				= dma_4v_alloc_coherent,
-	.free				= dma_4v_free_coherent,
+	.alloc				= dma_4v_alloc,
+	.free				= dma_4v_free,
 	.map_page			= dma_4v_map_page,
 	.unmap_page			= dma_4v_unmap_page,
 	.map_sg				= dma_4v_map_sg,
-- 
2.19.2

