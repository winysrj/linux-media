Return-Path: <SRS0=LTSq=OR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64B2CC65BAF
	for <linux-media@archiver.kernel.org>; Sat,  8 Dec 2018 17:37:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22A912081C
	for <linux-media@archiver.kernel.org>; Sat,  8 Dec 2018 17:37:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dXpk2xj6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 22A912081C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726256AbeLHRhU (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 8 Dec 2018 12:37:20 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:42968 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbeLHRhS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 8 Dec 2018 12:37:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=1gyRIvwO7YjDhu1pOGNh/fO+2+8GUnj5Y1CfvjSlDBA=; b=dXpk2xj61RcWCWZZ4AfADciXZN
        CrEBEfqaaC/ZHW+zQQNeh12wqjEZ25C4V6DePxEhvQtGx7SfpXbEyx7ndUUmeMnhGbfYFyZZVOr7s
        +R/6QQYvqXY+Bp3vNQfkdpqVrln3vN+0CCTrI4MPjOgr9JruP8mfxSbaSHriU3n4Fuf9WRNZ33BpJ
        Pix4+M1ZllQIGKEX8ZqY8w+4dcYmdGV+9YA30I2SWUG8cKgm4DDtfQR1W/pzRURerMvLeVn9ph3zr
        ieWkLw1qvOV4zpr61+QJpE+Jnk9FPaqU+dhppDUcAMFJdhiQmIq/b5eeWOCZIoUDKqTizR8M8G8Mk
        c7tXyCug==;
Received: from [184.48.100.57] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gVgXG-00053x-UN; Sat, 08 Dec 2018 17:37:03 +0000
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
Subject: [PATCH 01/10] dma-direct: provide a generic implementation of DMA_ATTR_NON_CONSISTENT
Date:   Sat,  8 Dec 2018 09:36:53 -0800
Message-Id: <20181208173702.15158-2-hch@lst.de>
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

If DMA_ATTR_NON_CONSISTENT is passed in the flags we can always just
use the dma_direct_alloc_pages implementation given that the callers
will take care of any cache maintainance on ownership transfers between
the CPU and the device.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/arc/mm/dma.c              | 21 ++++++--------------
 arch/mips/mm/dma-noncoherent.c |  5 ++---
 arch/openrisc/kernel/dma.c     | 23 +++++++++-------------
 arch/parisc/kernel/pci-dma.c   | 35 ++++++++++++----------------------
 kernel/dma/direct.c            |  4 ++--
 5 files changed, 31 insertions(+), 57 deletions(-)

diff --git a/arch/arc/mm/dma.c b/arch/arc/mm/dma.c
index db203ff69ccf..135759d4ea8c 100644
--- a/arch/arc/mm/dma.c
+++ b/arch/arc/mm/dma.c
@@ -24,7 +24,6 @@ void *arch_dma_alloc(struct device *dev, size_t size, dma_addr_t *dma_handle,
 	struct page *page;
 	phys_addr_t paddr;
 	void *kvaddr;
-	bool need_coh = !(attrs & DMA_ATTR_NON_CONSISTENT);
 
 	/*
 	 * __GFP_HIGHMEM flag is cleared by upper layer functions
@@ -46,14 +45,10 @@ void *arch_dma_alloc(struct device *dev, size_t size, dma_addr_t *dma_handle,
 	 * A coherent buffer needs MMU mapping to enforce non-cachability.
 	 * kvaddr is kernel Virtual address (0x7000_0000 based).
 	 */
-	if (need_coh) {
-		kvaddr = ioremap_nocache(paddr, size);
-		if (kvaddr == NULL) {
-			__free_pages(page, order);
-			return NULL;
-		}
-	} else {
-		kvaddr = (void *)(u32)paddr;
+	kvaddr = ioremap_nocache(paddr, size);
+	if (kvaddr == NULL) {
+		__free_pages(page, order);
+		return NULL;
 	}
 
 	/*
@@ -66,9 +61,7 @@ void *arch_dma_alloc(struct device *dev, size_t size, dma_addr_t *dma_handle,
 	 * Currently flush_cache_vmap nukes the L1 cache completely which
 	 * will be optimized as a separate commit
 	 */
-	if (need_coh)
-		dma_cache_wback_inv(paddr, size);
-
+	dma_cache_wback_inv(paddr, size);
 	return kvaddr;
 }
 
@@ -78,9 +71,7 @@ void arch_dma_free(struct device *dev, size_t size, void *vaddr,
 	phys_addr_t paddr = dma_handle;
 	struct page *page = virt_to_page(paddr);
 
-	if (!(attrs & DMA_ATTR_NON_CONSISTENT))
-		iounmap((void __force __iomem *)vaddr);
-
+	iounmap((void __force __iomem *)vaddr);
 	__free_pages(page, get_order(size));
 }
 
diff --git a/arch/mips/mm/dma-noncoherent.c b/arch/mips/mm/dma-noncoherent.c
index cb38461391cb..7576cd7193ba 100644
--- a/arch/mips/mm/dma-noncoherent.c
+++ b/arch/mips/mm/dma-noncoherent.c
@@ -50,7 +50,7 @@ void *arch_dma_alloc(struct device *dev, size_t size,
 	void *ret;
 
 	ret = dma_direct_alloc_pages(dev, size, dma_handle, gfp, attrs);
-	if (ret && !(attrs & DMA_ATTR_NON_CONSISTENT)) {
+	if (ret) {
 		dma_cache_wback_inv((unsigned long) ret, size);
 		ret = (void *)UNCAC_ADDR(ret);
 	}
@@ -61,8 +61,7 @@ void *arch_dma_alloc(struct device *dev, size_t size,
 void arch_dma_free(struct device *dev, size_t size, void *cpu_addr,
 		dma_addr_t dma_addr, unsigned long attrs)
 {
-	if (!(attrs & DMA_ATTR_NON_CONSISTENT))
-		cpu_addr = (void *)CAC_ADDR((unsigned long)cpu_addr);
+	cpu_addr = (void *)CAC_ADDR((unsigned long)cpu_addr);
 	dma_direct_free_pages(dev, size, cpu_addr, dma_addr, attrs);
 }
 
diff --git a/arch/openrisc/kernel/dma.c b/arch/openrisc/kernel/dma.c
index 159336adfa2f..483adbb000bb 100644
--- a/arch/openrisc/kernel/dma.c
+++ b/arch/openrisc/kernel/dma.c
@@ -98,15 +98,13 @@ arch_dma_alloc(struct device *dev, size_t size, dma_addr_t *dma_handle,
 
 	va = (unsigned long)page;
 
-	if ((attrs & DMA_ATTR_NON_CONSISTENT) == 0) {
-		/*
-		 * We need to iterate through the pages, clearing the dcache for
-		 * them and setting the cache-inhibit bit.
-		 */
-		if (walk_page_range(va, va + size, &walk)) {
-			free_pages_exact(page, size);
-			return NULL;
-		}
+	/*
+	 * We need to iterate through the pages, clearing the dcache for
+	 * them and setting the cache-inhibit bit.
+	 */
+	if (walk_page_range(va, va + size, &walk)) {
+		free_pages_exact(page, size);
+		return NULL;
 	}
 
 	return (void *)va;
@@ -122,11 +120,8 @@ arch_dma_free(struct device *dev, size_t size, void *vaddr,
 		.mm = &init_mm
 	};
 
-	if ((attrs & DMA_ATTR_NON_CONSISTENT) == 0) {
-		/* walk_page_range shouldn't be able to fail here */
-		WARN_ON(walk_page_range(va, va + size, &walk));
-	}
-
+	/* walk_page_range shouldn't be able to fail here */
+	WARN_ON(walk_page_range(va, va + size, &walk));
 	free_pages_exact(vaddr, size);
 }
 
diff --git a/arch/parisc/kernel/pci-dma.c b/arch/parisc/kernel/pci-dma.c
index 04c48f1ef3fb..6780449e3e8b 100644
--- a/arch/parisc/kernel/pci-dma.c
+++ b/arch/parisc/kernel/pci-dma.c
@@ -421,29 +421,18 @@ static void *pcxl_dma_alloc(struct device *dev, size_t size,
 	return (void *)vaddr;
 }
 
-static void *pcx_dma_alloc(struct device *dev, size_t size,
-		dma_addr_t *dma_handle, gfp_t flag, unsigned long attrs)
+static inline bool cpu_supports_coherent_area(void)
 {
-	void *addr;
-
-	if ((attrs & DMA_ATTR_NON_CONSISTENT) == 0)
-		return NULL;
-
-	addr = (void *)__get_free_pages(flag, get_order(size));
-	if (addr)
-		*dma_handle = (dma_addr_t)virt_to_phys(addr);
-
-	return addr;
+	return boot_cpu_data.cpu_type == pcxl2 ||
+		boot_cpu_data.cpu_type == pcxl;
 }
 
 void *arch_dma_alloc(struct device *dev, size_t size,
 		dma_addr_t *dma_handle, gfp_t gfp, unsigned long attrs)
 {
-
-	if (boot_cpu_data.cpu_type == pcxl2 || boot_cpu_data.cpu_type == pcxl)
+	if (cpu_supports_coherent_area())
 		return pcxl_dma_alloc(dev, size, dma_handle, gfp, attrs);
-	else
-		return pcx_dma_alloc(dev, size, dma_handle, gfp, attrs);
+	return NULL;
 }
 
 void arch_dma_free(struct device *dev, size_t size, void *vaddr,
@@ -451,14 +440,14 @@ void arch_dma_free(struct device *dev, size_t size, void *vaddr,
 {
 	int order = get_order(size);
 
-	if (boot_cpu_data.cpu_type == pcxl2 || boot_cpu_data.cpu_type == pcxl) {
-		size = 1 << (order + PAGE_SHIFT);
-		unmap_uncached_pages((unsigned long)vaddr, size);
-		pcxl_free_range((unsigned long)vaddr, size);
+	if (WARN_ON_ONCE(!cpu_supports_coherent_area()))
+		return;
 
-		vaddr = __va(dma_handle);
-	}
-	free_pages((unsigned long)vaddr, get_order(size));
+	size = 1 << (order + PAGE_SHIFT);
+	unmap_uncached_pages((unsigned long)vaddr, size);
+	pcxl_free_range((unsigned long)vaddr, size);
+
+	free_pages((unsigned long)__va(dma_handle), get_order(size));
 }
 
 void arch_sync_dma_for_device(struct device *dev, phys_addr_t paddr,
diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index 308f88a750c8..4efe1188fd2e 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -206,7 +206,7 @@ void dma_direct_free_pages(struct device *dev, size_t size, void *cpu_addr,
 void *dma_direct_alloc(struct device *dev, size_t size,
 		dma_addr_t *dma_handle, gfp_t gfp, unsigned long attrs)
 {
-	if (!dev_is_dma_coherent(dev))
+	if (!dev_is_dma_coherent(dev) && !(attrs & DMA_ATTR_NON_CONSISTENT))
 		return arch_dma_alloc(dev, size, dma_handle, gfp, attrs);
 	return dma_direct_alloc_pages(dev, size, dma_handle, gfp, attrs);
 }
@@ -214,7 +214,7 @@ void *dma_direct_alloc(struct device *dev, size_t size,
 void dma_direct_free(struct device *dev, size_t size,
 		void *cpu_addr, dma_addr_t dma_addr, unsigned long attrs)
 {
-	if (!dev_is_dma_coherent(dev))
+	if (!dev_is_dma_coherent(dev) && !(attrs & DMA_ATTR_NON_CONSISTENT))
 		arch_dma_free(dev, size, cpu_addr, dma_addr, attrs);
 	else
 		dma_direct_free_pages(dev, size, cpu_addr, dma_addr, attrs);
-- 
2.19.2

