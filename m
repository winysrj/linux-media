Return-Path: <SRS0=LTSq=OR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBAD6C67838
	for <linux-media@archiver.kernel.org>; Sat,  8 Dec 2018 17:37:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90DA42081C
	for <linux-media@archiver.kernel.org>; Sat,  8 Dec 2018 17:37:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AyWvMEWw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 90DA42081C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbeLHRhX (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 8 Dec 2018 12:37:23 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:42960 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726193AbeLHRhS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 8 Dec 2018 12:37:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=I+WnIekMM1tbq+rSftkEdHek2fZG7uorjOiJB1PtslI=; b=AyWvMEWwHf4VceiiuzIv8UyW4r
        waoZzL7eW4Qf17uPtdC2ytEOVUFX2tqgsH5IxutbrPCRA7KTJUNdBPvozp9mqYwd1O9yEU+Pn5Ey/
        yoto1DkR9yYe8wG5/iQFM9Q5FN/MEYcDuaEnhWDoG3bksqYOMgRn78BgV2i7VxsiIWHyEmCA7bfbW
        JUNpMa8FcMMM+XE3RPJWXCkrWr+r0OZdipEifGN0/wg9U6DUMd0SUZP5i5WObhEHwixsKJ6JO+1if
        MkrrfQ0lyiXA2S4+PpqYPaV8DIPzgtZWv8l0UDlntGX7ITEB/WwKmgV7Yr9B3JWEbzp1OELzupl18
        jOPt3yVg==;
Received: from [184.48.100.57] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gVgXH-000543-PA; Sat, 08 Dec 2018 17:37:03 +0000
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
Subject: [PATCH 03/10] arm64/iommu: implement support for DMA_ATTR_NON_CONSISTENT
Date:   Sat,  8 Dec 2018 09:36:55 -0800
Message-Id: <20181208173702.15158-4-hch@lst.de>
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

DMA_ATTR_NON_CONSISTENT forces contiguous allocations as we don't
want to remap, and is otherwise forced down the same pass as if we
were always on a coherent device.  No new code required except for
a few conditionals.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/arm64/mm/dma-mapping.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/mm/dma-mapping.c b/arch/arm64/mm/dma-mapping.c
index d39b60113539..0010688ca30e 100644
--- a/arch/arm64/mm/dma-mapping.c
+++ b/arch/arm64/mm/dma-mapping.c
@@ -240,7 +240,8 @@ static void *__iommu_alloc_attrs(struct device *dev, size_t size,
 				dma_free_from_pool(addr, size);
 			addr = NULL;
 		}
-	} else if (attrs & DMA_ATTR_FORCE_CONTIGUOUS) {
+	} else if (attrs & (DMA_ATTR_FORCE_CONTIGUOUS |
+			DMA_ATTR_NON_CONSISTENT)) {
 		pgprot_t prot = arch_dma_mmap_pgprot(dev, PAGE_KERNEL, attrs);
 		struct page *page;
 
@@ -256,7 +257,7 @@ static void *__iommu_alloc_attrs(struct device *dev, size_t size,
 			return NULL;
 		}
 
-		if (coherent) {
+		if (coherent || (attrs & DMA_ATTR_NON_CONSISTENT)) {
 			memset(addr, 0, size);
 			return addr;
 		}
@@ -309,7 +310,8 @@ static void __iommu_free_attrs(struct device *dev, size_t size, void *cpu_addr,
 	if (dma_in_atomic_pool(cpu_addr, size)) {
 		iommu_dma_unmap_page(dev, handle, iosize, 0, 0);
 		dma_free_from_pool(cpu_addr, size);
-	} else if (attrs & DMA_ATTR_FORCE_CONTIGUOUS) {
+	} else if (attrs & (DMA_ATTR_FORCE_CONTIGUOUS |
+			DMA_ATTR_NON_CONSISTENT)) {
 		struct page *page = vmalloc_to_page(cpu_addr);
 
 		iommu_dma_unmap_page(dev, handle, iosize, 0, attrs);
@@ -342,10 +344,11 @@ static int __iommu_mmap_attrs(struct device *dev, struct vm_area_struct *vma,
 	if (dma_mmap_from_dev_coherent(dev, vma, cpu_addr, size, &ret))
 		return ret;
 
-	if (attrs & DMA_ATTR_FORCE_CONTIGUOUS) {
+	if (attrs & (DMA_ATTR_FORCE_CONTIGUOUS | DMA_ATTR_NON_CONSISTENT)) {
 		unsigned long pfn;
 
-		if (dev_is_dma_coherent(dev))
+		if (dev_is_dma_coherent(dev) ||
+		    (attrs & DMA_ATTR_NON_CONSISTENT))
 			pfn = virt_to_pfn(cpu_addr);
 		else
 			pfn = vmalloc_to_pfn(cpu_addr);
@@ -366,10 +369,11 @@ static int __iommu_get_sgtable(struct device *dev, struct sg_table *sgt,
 	unsigned int count = PAGE_ALIGN(size) >> PAGE_SHIFT;
 	struct vm_struct *area = find_vm_area(cpu_addr);
 
-	if (attrs & DMA_ATTR_FORCE_CONTIGUOUS) {
+	if (attrs & (DMA_ATTR_FORCE_CONTIGUOUS | DMA_ATTR_NON_CONSISTENT)) {
 		struct page *page;
 
-		if (dev_is_dma_coherent(dev))
+		if (dev_is_dma_coherent(dev) ||
+		    (attrs & DMA_ATTR_NON_CONSISTENT))
 			page = virt_to_page(cpu_addr);
 		else
 			page = vmalloc_to_page(cpu_addr);
-- 
2.19.2

