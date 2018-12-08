Return-Path: <SRS0=LTSq=OR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66C80C64EB1
	for <linux-media@archiver.kernel.org>; Sat,  8 Dec 2018 17:37:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 301C22081C
	for <linux-media@archiver.kernel.org>; Sat,  8 Dec 2018 17:37:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="i+aF6u7T"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 301C22081C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbeLHRhT (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 8 Dec 2018 12:37:19 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:42954 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbeLHRhS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 8 Dec 2018 12:37:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=kXkzU9BzUhWvx/Zcm13Tqvhxg671ARu4x9T2MJXWUJ0=; b=i+aF6u7Tp/uOvkkcL3Ce45TtF+
        8Fd1S1iwSUtZ4SogqwQvEZ1xHF4k2d4K9dT7lFM5yBAMnlyJ0kVJ48Snvqwldv2IosN8e96LSGugT
        nRBz/BdyTS+o0+Sm9v0NmhIf2QzmQWyqDccG3zdcS2aRyPHb/FH6pbpPqRXBhEidRonqN7x3gEyD4
        VrdXsbhUVtAn3/8zDvrN4y4px8BmN2kQYOtVnH7XfsjWYbvCLV2SCrxwba5i2iGxqwH8dECN1EhWS
        1T9Pa6IwqeKxbSSAnO65hEbEvZobYTJhY1I9DKcZhjcLeAk4XjNo8su79RZe6u0XPNdsX/GVTTR/Q
        tP6z5ebg==;
Received: from [184.48.100.57] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gVgXH-000540-BE; Sat, 08 Dec 2018 17:37:03 +0000
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
Subject: [PATCH 02/10] arm64/iommu: don't remap contiguous allocations for coherent devices
Date:   Sat,  8 Dec 2018 09:36:54 -0800
Message-Id: <20181208173702.15158-3-hch@lst.de>
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

There is no need to have an additional kernel mapping for a contiguous
allocation if the device already is DMA coherent, so skip it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/arm64/mm/dma-mapping.c | 35 ++++++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/mm/dma-mapping.c b/arch/arm64/mm/dma-mapping.c
index 4c0f498069e8..d39b60113539 100644
--- a/arch/arm64/mm/dma-mapping.c
+++ b/arch/arm64/mm/dma-mapping.c
@@ -255,13 +255,18 @@ static void *__iommu_alloc_attrs(struct device *dev, size_t size,
 						    size >> PAGE_SHIFT);
 			return NULL;
 		}
+
+		if (coherent) {
+			memset(addr, 0, size);
+			return addr;
+		}
+
 		addr = dma_common_contiguous_remap(page, size, VM_USERMAP,
 						   prot,
 						   __builtin_return_address(0));
 		if (addr) {
 			memset(addr, 0, size);
-			if (!coherent)
-				__dma_flush_area(page_to_virt(page), iosize);
+			__dma_flush_area(page_to_virt(page), iosize);
 		} else {
 			iommu_dma_unmap_page(dev, *handle, iosize, 0, attrs);
 			dma_release_from_contiguous(dev, page,
@@ -309,7 +314,9 @@ static void __iommu_free_attrs(struct device *dev, size_t size, void *cpu_addr,
 
 		iommu_dma_unmap_page(dev, handle, iosize, 0, attrs);
 		dma_release_from_contiguous(dev, page, size >> PAGE_SHIFT);
-		dma_common_free_remap(cpu_addr, size, VM_USERMAP);
+
+		if (!dev_is_dma_coherent(dev))
+			dma_common_free_remap(cpu_addr, size, VM_USERMAP);
 	} else if (is_vmalloc_addr(cpu_addr)){
 		struct vm_struct *area = find_vm_area(cpu_addr);
 
@@ -336,11 +343,12 @@ static int __iommu_mmap_attrs(struct device *dev, struct vm_area_struct *vma,
 		return ret;
 
 	if (attrs & DMA_ATTR_FORCE_CONTIGUOUS) {
-		/*
-		 * DMA_ATTR_FORCE_CONTIGUOUS allocations are always remapped,
-		 * hence in the vmalloc space.
-		 */
-		unsigned long pfn = vmalloc_to_pfn(cpu_addr);
+		unsigned long pfn;
+
+		if (dev_is_dma_coherent(dev))
+			pfn = virt_to_pfn(cpu_addr);
+		else
+			pfn = vmalloc_to_pfn(cpu_addr);
 		return __swiotlb_mmap_pfn(vma, pfn, size);
 	}
 
@@ -359,11 +367,12 @@ static int __iommu_get_sgtable(struct device *dev, struct sg_table *sgt,
 	struct vm_struct *area = find_vm_area(cpu_addr);
 
 	if (attrs & DMA_ATTR_FORCE_CONTIGUOUS) {
-		/*
-		 * DMA_ATTR_FORCE_CONTIGUOUS allocations are always remapped,
-		 * hence in the vmalloc space.
-		 */
-		struct page *page = vmalloc_to_page(cpu_addr);
+		struct page *page;
+
+		if (dev_is_dma_coherent(dev))
+			page = virt_to_page(cpu_addr);
+		else
+			page = vmalloc_to_page(cpu_addr);
 		return __swiotlb_get_sgtable_page(sgt, page, size);
 	}
 
-- 
2.19.2

